//--------------------------------------------------------------------
// test_P8A.inspect-1.mq4
// 2016/11/15 00:01:52
// 
// <Usage>
// - Find patterns in a given symbol chart.
// - Use H1 bars
// 
//--------------------------------------------------------------------
//+------------------------------------------------------------------+
//| Includes                                                                 |
//+------------------------------------------------------------------+
#include <utils.mqh>

//+------------------------------------------------------------------+
//| vars                                                                 |
//+------------------------------------------------------------------+
extern int Period_MA = 21;            // Calculated MA period

bool Fact_Up = true;                  // Fact of report that price..
bool Fact_Dn = true;                  //..is above or below MA

int NUMOF_BARS_IN_PATTERN = 3;

int HOURS_PER_DAY = 24;

int HIT_INDICES[];   // indices of matched bars(i.e. 3-ups)

//+------------------------------------------------------------------+
//| infra vars                                                                 |
//+------------------------------------------------------------------+
string SUBFOLDER = "Research\\32_1";      // subfolder name


//+------------------------------------------------------------------+
//| input vars                                                                 |
//+------------------------------------------------------------------+
input string symbol_str = "USDJPY";

//input int X_UPS = 10;
//input double X_UPS = 0.10;
input double X_UPS = 0.20;

input double X_UPS_OVER_2S = 0.1;

input double X_UPS_AFTER_BREAK = 0.3;

//int NUMOF_DAYS = 3;
//input int NUMOF_DAYS = 10;
input int NUMOF_DAYS = 30;
//int NUMOF_DAYS = 90;

//--------------------------------------------------------------------
int start()                           // Special function start()
  {

   //test
   if(Fact_Up == true)           // initially, Fact_Up is set to be true
     {
     
         detect_Up_XPips_On_BB_Plus2s();
         
         Fact_Up = false;        // no more executions

     }



//--------------------------------------------------------------------
   return 0;                            // Exit start()
   
}//int start()
//--------------------------------------------------------------------

int _inspect__exec__Up_XPips_On_BB_Plus2s(int index) {
      
      double a,b,c;
      
      int offset = 0;

      //+------------------------------------------------------------------+
      //| bar: 1 => up
      //+------------------------------------------------------------------+
      a = Close[index + offset];
      b = Open[index + offset];
      
      //c = a - b;
      c = Close[index + offset] - Open[index + offset];
      
      //if(! (c <= 0) ) return offset;
      if( c <= 0 ) return 0;     // down bar
      
      // validate: X pips
      if(c < X_UPS)
        {
            
            Alert("Up --> less than " + (string) X_UPS + "(diff = ",c,")" + " [index = ",index," / ",TimeToStr(iTime(Symbol(), Period(), index)),"");
            
            return 0;
            
        }

      //+------------------------------------------------------------------+
      //| validate: break up the 2s line
      //+------------------------------------------------------------------+
      double band_2s = iBands(NULL,0, 20, 2, 0, PRICE_CLOSE, MODE_UPPER, index + offset);
      
      // Open: under 2s
      if(Open[index + offset] > band_2s)
        {
            
            Alert("Open --> over 2s [index = ",index,""
                  + " / ",TimeToStr(iTime(Symbol(), Period(), index)),"]");
            
            return 0;
            
        }
      
      // Close: over 2s
      if(Close[index + offset] < (band_2s + X_UPS_OVER_2S))
        {
            
            Alert("Close --> under 2s + ",X_UPS_OVER_2S," [index = ",index,""
                  + " / ",TimeToStr(iTime(Symbol(), Period(), index)),"]");
            
            return 0;
            
        }

     //+------------------------------------------------------------------+
     //| default                                                                 |
     //+------------------------------------------------------------------+
     Alert("returning index... [",index," / ",TimeToStr(iTime(Symbol(), Period(), index)),"]");
     
     //return 0;
     return index;

}//_inspect__exec__Up_XPips_On_BB_Plus2s(int index)

void detect_Up_XPips_On_BB_Plus2s() {

   Alert("inspect [",TimeToStr(TimeLocal(), TIME_DATE|TIME_SECONDS),"]");
   
      //+------------------------------------------------------------------+
      //| setup                                                                 |
      //+------------------------------------------------------------------+
      //string symbol_name = "USDJPY";         // symbol string
      string symbol_name = symbol_str;         // symbol string
      
      ChartSetSymbolPeriod(0, symbol_name, 0);  // set symbol

      //ref https://docs.mql4.com/files/fileopen
      string terminal_data_path = TerminalInfoString(TERMINAL_DATA_PATH);  // data path
      
      //string subfolder = "Research\\31_2";      // subfolder name
      
      datetime t = TimeLocal();

      string fname = "P10A_ins_1.BreakUp-BB-Plus-2s-Up-XPips_" 
                  + (string) (MathRound(X_UPS * 100)) + "-Pips"        // file name
                  
                  + "_" + (string) (MathRound(X_UPS_OVER_2S * 100)) + "-Pips-Over-2s"        // 
                  
                  + "_" + (string) (MathRound(X_UPS_AFTER_BREAK * 100)) + "-Pips-After-Break"        // 
                  
                  //+ "_"
                  + "_" + (string) NUMOF_DAYS + "-Days"
                  
                  + "." 
                  //+ conv_DateTime_2_SerialTimeLabel(TimeCurrent()) 
                  //+ conv_DateTime_2_SerialTimeLabel(t) 
                  + conv_DateTime_2_SerialTimeLabel((int)t) 
                  + ".csv";
      
      string title = "Break up BB +2s, then " 
                     //+ "", MathRound(X_UPS_AFTER_BREAK * 100)," pips up (inspect: p-10A)";
                     + (string) (MathRound(X_UPS_AFTER_BREAK * 100)) 
                     + "pips up (inspect: p-10A)";

      //+------------------------------------------------------------------+
      //| File: open                                                                 |
      //+------------------------------------------------------------------+
      int filehandle = FileOpen(SUBFOLDER + "\\" + fname, FILE_WRITE|FILE_CSV);
      
      //if(filehandle!=INVALID_HANDLE) {
      if(filehandle == INVALID_HANDLE) {
      
            Print("File open failed, error ",GetLastError());
               
            //alert
            Alert("[",__LINE__,"] File open failed, error");
            
            return;
            
      }
      else
      {
         
         Alert("[",__LINE__,"] file => opened!");

         //+------------------------------------------------------------------+
         //| vars                                                                 |
         //+------------------------------------------------------------------+

         datetime d = TimeLocal();      // current time

         int numof_target_bars = (NUMOF_DAYS * HOURS_PER_DAY > Bars) 
                           ? Bars : NUMOF_DAYS * HOURS_PER_DAY;

         int k = 0;      // offset used for i
         
         //int HIT_INDICES[];   // indices of matched bars(i.e. 3-ups)
         int hit_indices_up[];   // 3-downs, then up
         int HIT_INDICES_down[]; // 3-downs, then down
         
         int numof_HIT_INDICES = 0;  // count up the matched bars
         int numof_hit_indices_up = 0;  // count up the matched bars
         int numof_HIT_INDICES_down = 0;  // count up the matched bars

         //ref https://docs.mql4.com/array/arrayresize

         ArrayResize(HIT_INDICES, NUMOF_DAYS * HOURS_PER_DAY);
         
         //ref https://www.mql5.com/en/forum/3239
         FileSeek(filehandle,0,SEEK_END);
         
         Alert("[",__LINE__,"] FileSeek => done");
         
         Alert("[",__LINE__,"] numof_target_bars => ",numof_target_bars,"");

         //+------------------------------------------------------------------+
         //| metadata                                                                  |
         //+------------------------------------------------------------------+
         FileWrite(filehandle, 
                     TimeToStr(d, TIME_DATE|TIME_SECONDS), 
                     symbol_name,
                     //PERIOD_CURRENT
                     //ref https://www.mql5.com/en/forum/133159
                     "period = " + (string)Period(),
                     title,
                     //"target bars=",numof_target_bars,"",
                     //"target bars = " + numof_target_bars,
                     "target bars = " + (string)numof_target_bars,
                     "Bars = " + (string)Bars
                     
                     );
                     
         FileWrite(filehandle,
         
                  "start = " + TimeToStr(iTime(Symbol(), Period(), (numof_target_bars - 1))),
                  
                  "end = " + TimeToStr(iTime(Symbol(), Period(), 0)),
                  
                  "days = " + (string)NUMOF_DAYS
         
         );
         
         //debug
         Alert("[",__LINE__,"] metadata => written");

         //+------------------------------------------------------------------+
         //| header                                                                 |
         //+------------------------------------------------------------------+
         FileWrite(filehandle,
               "no.", "index", "time", "close", "open", "diff"
               
               );    // header

         //debug
         Alert("[",__LINE__,"] header => written");

         //+------------------------------------------------------------------+
         //| detect patterns => Break up BB +2s
         //+------------------------------------------------------------------+
         int result;

         for(int i = (numof_target_bars - 1); i >= 0; i--)
        {

               //result = _inspect__exec__UpXPips(i);
               result = _inspect__exec__Up_XPips_On_BB_Plus2s(i);
               //result = i;

               //debug
               Alert("[" + (string) __LINE__ + "] result => ",result," / i => ",i," ["
               
                  + TimeToStr(iTime(Symbol(), Period(), i)) + "]"
               
               );
                        
               if(result == i && i != 0)
                 {
                 
                     // add to the array
                     HIT_INDICES[numof_HIT_INDICES] = i;
                     
                     // increment the index
                     numof_HIT_INDICES += 1;
                     
                     //debug
                     Alert("[" + (string) __LINE__ + "] result == i ---> i = ",i,"");
                     
                  }
                else if(result < 0)//if(ret == i)
                  {
                     
                  }//if(ret == i)
        
         }//for(int i = 0; i < numof_target_bars - numof_ups ;i++)

         //debug
         Alert("[",__LINE__,"] numof_HIT_INDICES => ",numof_HIT_INDICES,"");

         //+------------------------------------------------------------------+
         //| write: hit data => Break up BB +2s
         //+------------------------------------------------------------------+
         FileWrite(filehandle, "");
         
         FileWrite(filehandle, "["+ (string)__LINE__ + "] List of Break-up BB-2s",
         
               "num = " + (string) numof_HIT_INDICES
         
         );
         
         double a, b;
         
        
         //for(i=0; i < numof_HIT_INDICES; i++)
         for(int i = 0; i < numof_HIT_INDICES; i++)
           {
               a = Close[HIT_INDICES[i]];
               b = Open[HIT_INDICES[i]];
               
               FileWrite(filehandle, 
                  
                  (i + 1), 
                  
                  HIT_INDICES[i],
                  
                  TimeToStr(iTime(Symbol(), Period(), HIT_INDICES[i])),
                  
                  a, b, (a - b)
                  
               );    // data
            
           }//for(int i=0;i < numof_HIT_INDICES; i++)

            //+------------------------------------------------------------------+
            //| detect patterns => X pips up                                                                 |
            //+------------------------------------------------------------------+
            int HIT_INDICES_AFTER_BREAK[];
            
            ArrayResize(HIT_INDICES_AFTER_BREAK, numof_HIT_INDICES);
            
            //int numof_HIT_INDICES_AFTER_BREAK = 0;
            
            int numof_HIT_INDICES_AFTER_BREAK = 
                  _detect_After_Break_XPips_Up(
                        HIT_INDICES, numof_HIT_INDICES, 
                        //HIT_INDICES_AFTER_BREAK, numof_HIT_INDICES_AFTER_BREAK);
                        //HIT_INDICES_AFTER_BREAK);
                        HIT_INDICES_AFTER_BREAK, filehandle);
            
            Alert("numof_HIT_INDICES_AFTER_BREAK = ",numof_HIT_INDICES_AFTER_BREAK,"");


      }//if(filehandle == INVALID_HANDLE)
      
      
      //+------------------------------------------------------------------+
      //| File: close                                                                 |
      //+------------------------------------------------------------------+
      
      FileClose(filehandle);
      
      Alert("file => closed");

}//detect_Up_XPips_On_BB_Plus2s()

//+------------------------------------------------------------------+
//| _detect_After_Break_XPips_Up
//    return:
//       1. X pips up ==> index
//       2. less than the middle ==> offset value (a minus number)
//+------------------------------------------------------------------+

int _detect_After_Break_XPips_Up
(int &hit_indices[], int numof_hit_indices, 
//int &HIT_INDICES_AFTER_BREAK[], int &numof_hit_indices_after_break) {
//int &HIT_INDICES_AFTER_BREAK[]) {
int &HIT_INDICES_AFTER_BREAK[], int file_handle) {
      
      //+------------------------------------------------------------------+
      //| File: write: header                                                                 |
      //+------------------------------------------------------------------+
      FileWrite(file_handle, "");
      
      FileWrite(file_handle, 
      
               "List of " 
                  + (string) (MathRound(X_UPS_AFTER_BREAK * 100))
                  + " Pips up"
                  + " / "
                  + "down the half the original up of "
                  + (string) (MathRound(X_UPS * 100))
                  + " Pips"
                  + " after break"
      );
      
      FileWrite(file_handle, 
               
               "no.", "index", "time", "up/down", "offset", "time"
      
      );
            
      //test
      //numof_hit_indices_after_break  = 10;
      
      int numof_hit_indices_after_break = 0;
      
      int offset = -1;
      
      double body = 0;
      
      double sum = 0;
      
      double middle = 0;
      
      // count
      int count = 0;
      
      int numof_ups = 0;
      
      int numof_downs = 0;
      
      //+------------------------------------------------------------------+
      //| for loop
      //+------------------------------------------------------------------+
      for(int i = 0; i < numof_hit_indices; i++)
        {
            
            Alert("index = ",hit_indices[i]," / " 
                     + TimeToStr(iTime(Symbol(), Period(), hit_indices[i])));
                     
            //+------------------------------------------------------------------+
            //| prep: middle value, sum                                                                 |
            //+------------------------------------------------------------------+
            //sum = Close[hit_indices[i]] - Open[hit_indices[i]];
            sum = 0;
            
            //middle = (sum) / 2;
            // middle: half the body; also, a negative value
            //middle = (Close[hit_indices[i]] - Open[hit_indices[i]]) / 2 * (-1);
            // middle: a positive value
            middle = (Close[hit_indices[i]] - Open[hit_indices[i]]) / 2;
            
            //debug
            Alert("[",__LINE__,"] starting: i = ",i," / target = ",hit_indices[i],"" 
                     + " / "
                     + "sum = ",sum,""
                     
                     + " / "
                     + "time = ",TimeToStr(iTime(Symbol(), Period(), hit_indices[i])),""
                     
                     );
            
            //+------------------------------------------------------------------+
            //| judge: up or down
            //+------------------------------------------------------------------+
            //+------------------------------------------------------------------+
            //| validate: end of the chart
            //+------------------------------------------------------------------+
            // validate: end of the chart
            if(hit_indices[i] + offset < 0)
              {
                  Alert("index + offset --> less than zero: " 
                        + "index = ",hit_indices[i],"" 
                        + " / ",TimeToStr(iTime(Symbol(), Period(), hit_indices[i])),""
                        + " / offset = ",offset,"");
                        
                  return offset;
                  
              }
            
            //+------------------------------------------------------------------+
            //| body: up or down?
            //+------------------------------------------------------------------+
            while(true) {

               // validate: end of the chart
               // if it is, break the while loop; next index in for loop
               if(hit_indices[i] + offset < 0)
                 {
                     Alert("[",__LINE__,"] index + offset --> less than zero: " 
                           + "index = ",hit_indices[i],"" 
                           + " / ",TimeToStr(iTime(Symbol(), Period(), hit_indices[i])),""
                           + " / offset = ",offset,"");
                                                      
                     // reset the offset
                     offset = -1;
                     
                     // reset the sum
                     sum = 0;
               
                     break;
                     
                 }

               
               // get: the body value
               body = Close[hit_indices[i] + offset] - Open[hit_indices[i] + offset];
               
               if(body >= 0)  // bar is --> up
                 {
                     
                     // add up the sum
                     sum += body;
                     
                     // judge: more than X pips plus
                     //if(sum > (Close[hit_indices[i]] + X_UPS_AFTER_BREAK))
                     //if(sum > X_UPS_AFTER_BREAK)
                     if(Close[hit_indices[i] + offset] > Close[hit_indices[i]] + X_UPS_AFTER_BREAK)
                       {
                           
                           // add the index
                           HIT_INDICES_AFTER_BREAK[numof_hit_indices_after_break] = hit_indices[i];
                           
                           // increment: numof_hit_indices_after_break
                           numof_hit_indices_after_break += 1;
                           
                           //alert
                           Alert("[",__LINE__,"] sum is larger: index = ",hit_indices[i]," / "
                           
                                 + "",TimeToStr(iTime(Symbol(), Period(), hit_indices[i])),""
                                 
                                 + " [offset = ",offset,"]"
                           );

                           // write file
                           count += 1;
                           
                           numof_ups += 1;
                           
                           
                           //"no.", "index", "time", "offset", "time"
                           FileWrite(file_handle,
                                 
                                 //(string) (i + 1),
                                 (string) count,
                                 
                                 (string) hit_indices[i],
                                 
                                 TimeToStr(iTime(Symbol(), Period(), hit_indices[i])),
                                 
                                 "up",
                                 
                                 (string) offset,
                                 
                                 TimeToStr(iTime(Symbol(), Period(), hit_indices[i] + offset))
                           
                           );
                       

                           //+------------------------------------------------------------------+
                           //| next index: reset the offset to -1,                                                                  |
                           //          then, break the while loop
                           //+------------------------------------------------------------------+
                           // reset the offset
                           offset = -1;
                           
                           // reset the sum
                           sum = 0;
                           
                           // exit the while
                           break;
                           
                       }
                     //+------------------------------------------------------------------+
                     //| sum is not yet larger than close + x pips
                     //    => increment the offset; inspect the next offset bar
                     //+------------------------------------------------------------------+
                     else   //if(sum > (Close[hit_indices[i]] + X_UPS_AFTER_BREAK))
                       {
                        
                           // incremet: offset
                           // ---> no. decrement
                           //offset += 1;
                           offset -= 1;
                        
                       }//if(sum > (Close[hit_indices[i]] + X_UPS_AFTER_BREAK))
                       
                 }//if(body >= 0)  // bar is --> up
                 
               else   //if(body >= 0)  // bar is --> down
                 {
                     
                     // decrement the sum by body
                     // "body" is a minus value; hence, add up to sum
                     sum += body;
                     
                     // judge: sum is less than half the body
                     //if(sum < middle)
                     if(Close[hit_indices[i] + offset] < Open[hit_indices[i]] + middle)
                       {
                           
                           //alert
                           Alert("[",__LINE__,"] sum is less than middle: index = ",hit_indices[i]," / "
                           
                                 + "",TimeToStr(iTime(Symbol(), Period(), hit_indices[i])),""
                                 
                                 + " " 
                                 + "[offset = ",offset,""
                                 + " / sum = ",NormalizeDouble(sum, 5),""
                                 + " / middle = ",NormalizeDouble(middle, 5),"]"
                           );
                           
                           //+------------------------------------------------------------------+
                           //| write file
                           //+------------------------------------------------------------------+
                           count += 1;
                           
                           numof_downs += 1;
                           
                           
                           //"no.", "index", "time", "offset", "time"
                           FileWrite(file_handle,
                                 
                                 //(string) (i + 1),
                                 (string) count,
                                 
                                 (string) hit_indices[i],
                                 
                                 TimeToStr(iTime(Symbol(), Period(), hit_indices[i])),
                                 
                                 "down",
                                 
                                 (string) offset,
                                 
                                 TimeToStr(iTime(Symbol(), Period(), hit_indices[i] + offset))
                           
                           );

                           
                           //+------------------------------------------------------------------+
                           //| next index: reset the offset to -1,                                                                  |
                           //          then, break the while loop
                           //+------------------------------------------------------------------+
                           // reset the offset
                           offset = -1;
                           
                           // reset the sum
                           sum = 0;
                           
                           // break the while; continue the for loop
                           break;
                           
                       }//if(sum < middle)
                     // the sum is not yet less than the middle value
                     else
                       {
                           
                           // incremet: offset
                           // ---> no. decrement
                           //offset += 1;
                           offset -= 1;
                           
                       }//if(sum < middle)
                     
                 }//if(body >= 0)  // bar is --> 
            
            }//while(true)
            
        }//for(int i = 0; i < numof_hit_indices; i++)

   // file write
   FileWrite(file_handle,
   
         "ups = " + (string) numof_ups,
         
         "downs = " + (string) numof_downs
   
   );
   
   FileWrite(file_handle,
   
         "End of list"
   
   );

   //+------------------------------------------------------------------+
   //| return: defalut
   //+------------------------------------------------------------------+
   return numof_hit_indices_after_break;

}//_detect_After_Break_XPips_Up(HIT_INDICES, HIT_INDICES_AFTER_BREAK)
