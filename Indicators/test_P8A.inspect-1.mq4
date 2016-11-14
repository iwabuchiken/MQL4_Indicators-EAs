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
input string symbol_str = "USDJPY";

bool Fact_Up = true;                  // Fact of report that price..
bool Fact_Dn = true;                  //..is above or below MA

//int NUMOF_DAYS = 3;
//int NUMOF_DAYS = 10;
input int NUMOF_DAYS = 30;
//int NUMOF_DAYS = 90;
int NUMOF_BARS_IN_PATTERN = 3;

int HOURS_PER_DAY = 24;

int HIT_INDICES[];   // indices of matched bars(i.e. 3-ups)

input int X_UPS = 18;
input double discout = 0.8;

//--------------------------------------------------------------------
int start()                           // Special function start()
  {

   //test
   if(Fact_Up == true)           // initially, Fact_Up is set to be true
     {
     
         detect_Up_XPips();
         
         
         //detect_Get_MaxPips_Up();

         Fact_Up = false;        // no more executions
         

         //+------------------------------------------------------------------+
         //| Ending                                                                 |
         //+------------------------------------------------------------------+
         //Alert("Done");
         
     }



//--------------------------------------------------------------------
   return 0;                            // Exit start()
   
}//int start()
//--------------------------------------------------------------------

int _inspect__exec__UpXPips(int index) {
      
      double a,b,c;
      
      //double d,e;
      //double lower_shadow;
      
      int offset = 0;

      //+------------------------------------------------------------------+
      //| bar: 1 => down                                                                 |
      //+------------------------------------------------------------------+
      a = Close[index + offset];
      b = Open[index + offset];
      
      c = a - b;
      
      //if(! (c <= 0) ) return offset;
      if( c <= 0 ) return 0;     // down bar
      
      // validate: X pips
      if(c < X_UPS)
        {
            
            Alert("Up --> less than " + (string) X_UPS);
            
            return 0;
            
        }


      //+------------------------------------------------------------------+
      //| bar: 2 => down                                                                 |
      //+------------------------------------------------------------------+
      offset -= 1;
      
      // validate: index + offset >= 0
      if(index + offset < 0)
        {
        
            Alert("index + offset --> less than zero");
            
            //return 0;
            return offset;
            
        }


      a = Close[index + offset];
      
      //Alert("Close => ",a," (index = ",index,")");
      b = Open[index + offset];
      
      double c2 = a - b;
      
      // validate: up bar
      if(! c2 <= 0 ) return offset;

      // validate: X*discount
      Alert("[" + (string) index + "] c2 = ",c2," / c = ",c," / c*discount = ",c * discout,"");
      if( c2 < c * discout )
        {
            
            Alert("c2 is less than discounted c");
            
            return offset;
            
        }

     //+------------------------------------------------------------------+
     //| default                                                                 |
     //+------------------------------------------------------------------+
     //return 0;
     return index;

}//_inspect_exec(int index)

void detect_Get_MaxPips_Up() {

   Alert("inspect [",TimeToStr(TimeLocal(), TIME_DATE|TIME_SECONDS),"]");
   
      //+------------------------------------------------------------------+
      //| setup                                                                 |
      //+------------------------------------------------------------------+
      //string symbol_name = "USDJPY";         // symbol string
      string symbol_name = symbol_str;         // symbol string
      
      ChartSetSymbolPeriod(0, symbol_name, 0);  // set symbol

      //ref https://docs.mql4.com/files/fileopen
      string terminal_data_path = TerminalInfoString(TERMINAL_DATA_PATH);  // data path
      
      string subfolder = "Research\\30_2";      // subfolder name
      
      //string fname = "3ups_3downs"        // file name
      
      //datetime t = TimeCurrent();
      datetime t = TimeLocal();
      //datetime t2 = GetTickCount();
      
         //+------------------------------------------------------------------+
         //| detect patterns => Down, then up: X pips
         //+------------------------------------------------------------------+
         //int result;
         
         // function
         

         //for(int i = (numof_target_bars - 1); i >= 0; i--)
         double a, b;
         double diff_prev = 0;
         
         double diff_current = 0;
         
         int index_max = 0;
         
         for(int i = 0; i < Bars; i ++)
        {
            a = Open[i];
            b = Close[i];
            
            //diff_current = b - a;
            diff_current = Close[i] - Open[i];
            
            if(diff_current < 0)
              {
                  continue;
              }
            
            // compare
            if(diff_current > diff_prev)
              {
              
                  diff_prev = diff_current;
                  
                  index_max = i;
                  
              }
        
         }//for(int i = 0; i < numof_target_bars - numof_ups ;i++)

         //debug
         Alert("[",__LINE__,"] get max => done (max = ",diff_prev," " 
                  + "/ ",TimeToStr(iTime(Symbol(), Period(), index_max)),"");
         
         

}//detect_Get_MaxPips_Up()


void detect_Up_XPips() {

   Alert("inspect [",TimeToStr(TimeLocal(), TIME_DATE|TIME_SECONDS),"]");
   
      //+------------------------------------------------------------------+
      //| setup                                                                 |
      //+------------------------------------------------------------------+
      //string symbol_name = "USDJPY";         // symbol string
      string symbol_name = symbol_str;         // symbol string
      
      ChartSetSymbolPeriod(0, symbol_name, 0);  // set symbol

      //ref https://docs.mql4.com/files/fileopen
      string terminal_data_path = TerminalInfoString(TERMINAL_DATA_PATH);  // data path
      
      string subfolder = "Research\\30_2";      // subfolder name
      
      //string fname = "3ups_3downs"        // file name
      
      //datetime t = TimeCurrent();
      datetime t = TimeLocal();
      //datetime t2 = GetTickCount();
      
      //string fname = "P7A_ins-2"        // file name
      string fname = "P8A_ins_1.detect_Ups_XPips"        // file name
                  //+ "_" 
                  + "." 
                  //+ conv_DateTime_2_SerialTimeLabel(TimeCurrent()) 
                  //+ conv_DateTime_2_SerialTimeLabel(t) 
                  + conv_DateTime_2_SerialTimeLabel((int)t) 
                  + ".csv";
      
      string title = "Down then up: " + (string) X_UPS + " pips (inspect: p-8A)";

      //test
//      Alert("fname => ",fname,"");
      
      //Alert("t => ",t," / TimeLocal => ",TimeLocal(),"");
      
      //return;

      //+------------------------------------------------------------------+
      //| File: open                                                                 |
      //+------------------------------------------------------------------+
      int filehandle = FileOpen(subfolder + "\\" + fname, FILE_WRITE|FILE_CSV);
      
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
         //datetime d = TimeCurrent();      // current time
         datetime d = TimeLocal();      // current time

         //int HOURS_PER_DAY = 24;
         
         //int numof_target_bars = NUMOF_DAYS * HOURS_PER_DAY;
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
         //ArrayResize(HIT_INDICES, numof_target_bars);     // compile -> OK
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
         //| detect patterns => Down, then up: X pips
         //+------------------------------------------------------------------+
         int result;
         
         // function
         

         //for(int i = (numof_target_bars - 1); i >= 0; i--)
         for(int i = (numof_target_bars - 1); i >= 0; i--)
        {

               //result = _inspect__exec__UpXPips(i);
               result = _inspect__exec__UpXPips(i);
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
         Alert("[",__LINE__,"] 3 downs => detected");
         
         Alert("[",__LINE__,"] numof_HIT_INDICES => ",numof_HIT_INDICES,"");

         //+------------------------------------------------------------------+
         //| write: hit data => Down, then up
         //+------------------------------------------------------------------+
         FileWrite(filehandle, "");
         
         FileWrite(filehandle, "["+ (string)__LINE__ + "] List of 3-downs",
         
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


      }//if(filehandle == INVALID_HANDLE)

      //+------------------------------------------------------------------+
      //| File: close                                                                 |
      //+------------------------------------------------------------------+
      
      FileClose(filehandle);
      
      Alert("file => closed");

}//detect_Up_XPips()
