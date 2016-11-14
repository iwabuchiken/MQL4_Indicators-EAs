//--------------------------------------------------------------------
// test_pattern-seeker-1.mq4
// 2016/11/13 23:40:37
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

//int NUMOF_DAYS = 3;
//int NUMOF_DAYS = 10;
int NUMOF_DAYS = 30;
//int NUMOF_DAYS = 90;
int NUMOF_BARS_IN_PATTERN = 3;

int HOURS_PER_DAY = 24;

int HIT_INDICES[];   // indices of matched bars(i.e. 3-ups)
//int HIT_INDICES[NUMOF_DAYS * HOURS_PER_DAY];   // indices of matched bars(i.e. 3-ups)

//ArrayResize(HIT_INDICES, Bars);
//ArrayResize(HIT_INDICES, NUMOF_DAYS * HOURS_PER_DAY);
//ArrayResize(HIT_INDICES, 90 * 24);

//--------------------------------------------------------------------
int start()                           // Special function start()
  {

   //test
   if(Fact_Up == true)           // initially, Fact_Up is set to be true
     {
     
         detect_3Downs();

         detect_3Downs_Under_BB_CenterBand();
         
         detect_3Downs_Over_BB_CenterBand();
         
         Fact_Up = false;        // no more executions
         

         //+------------------------------------------------------------------+
         //| Ending                                                                 |
         //+------------------------------------------------------------------+
         Alert("Done");
         
     }



//--------------------------------------------------------------------
   return 0;                            // Exit start()
   
}//int start()
//--------------------------------------------------------------------

int _inspect__exec(int index) {
      
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
      if(! (c <= 0) ) return 0;     // down bar

      // Bollinger
      //double band_center = iBands(NULL,0,20,2,0,PRICE_LOW,MODE_LOWER,index + offset);
      //double band_center = iBands(Symbol(), PERIOD_H1, 20,2,0,PRICE_LOW,MODE_LOWER,index + offset);
                            // symbol, timeframe   period   deviation   band_shift  applied_price  mode        shift
      //double band_center = iMA(NULL    ,PERIOD_H1  ,20      ,0          ,0          ,PRICE_CLOSE   ,MODE_UPPER ,index + offset);
      //double band_center = iBands(NULL,0,20,2,0,PRICE_LOW,MODE_LOWER,index + offset);
      double band_center = iBands(NULL,0, 20, 0, 0, PRICE_CLOSE, MODE_LOWER, index + offset);
      
      
      if(band_center < b)     // Open price over the center band
        {
            //
            Alert("[index + offset: ",index + offset,"] band_center => ",band_center," / Open => ",b," (returning...)");
            
            return 0;
            
        }

      //+------------------------------------------------------------------+
      //| bar: 2 => down                                                                 |
      //+------------------------------------------------------------------+
      offset -= 1;
      
      Alert("[" + (string) __LINE__ + "] offset => -1 (now ",offset," / index = ",index,")");

      // validate: index + offset >= 0
      if(index + offset < 0)
        {
        
            Alert("index + offset --> less than zero");
            
            //return 0;
            return offset;
            
        }

      // validate: BB center band
                     // symbol, timeframe   period   deviation   band_shift  applied_price  mode        shift
      //band_center = iMA(NULL,   PERIOD_H1,  20,      0,          0,          PRICE_CLOSE,   MODE_UPPER, index + offset);
      band_center = iBands(NULL,0, 20, 0, 0, PRICE_CLOSE, MODE_LOWER, index + offset);
      
      
      if(band_center < b)     // Open price over the center band
        {
            //
            Alert("[index + offset: ",index + offset,"] band_center => ",band_center," / Open => ",b," (returning...)");
            
            return offset;
            
        }

      a = Close[index + offset];
      
      //Alert("Close => ",a," (index = ",index,")");
      b = Open[index + offset];
      
      c = a - b;
      
      //if(! (c <= 0) ) return offset;
      if(! (c <= 0) ) return offset;

      //+------------------------------------------------------------------+
      //| bar: 3 => down                                                                 |
      //+------------------------------------------------------------------+
      offset -= 1;
      
      Alert("offset => -1 (now ",offset," / index = ",index,")");

      // validate: index + offset >= 0
      if(index + offset < 0)
        {
        
            Alert("index + offset --> less than zero");
            
            //return 0;
            return offset;
            
        }

      // validate: BB center band
                     // symbol, timeframe   period   deviation   band_shift  applied_price  mode        shift
      //band_center = iMA(NULL,   PERIOD_H1,  20,      0,          0,          PRICE_CLOSE,   MODE_UPPER, index + offset);
      band_center = iBands(NULL,0, 20, 0, 0, PRICE_CLOSE, MODE_LOWER, index + offset);
      
      
      if(band_center < b)     // Open price over the center band
        {
            //
            Alert("[index + offset: ",index + offset,"] band_center => ",band_center," / Open => ",b," (returning...)");
            
            return offset;
            
        }

      a = Close[index + offset];
      
      //Alert("Close => ",a," (index = ",index,")");
      b = Open[index + offset];
      
      c = a - b;
      
      //if(! (c <= 0) ) return offset;
      if(! (c <= 0) ) return offset;


     //+------------------------------------------------------------------+
     //| default                                                                 |
     //+------------------------------------------------------------------+
     //return 0;
     return index;

}//_inspect_exec(int index)

int _inspect__exec_over_center_band(int index) {
      
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
      if(! (c <= 0) ) return 0;     // down bar

      // Bollinger
      //double band_center = iBands(NULL,0,20,2,0,PRICE_LOW,MODE_LOWER,index + offset);
      //double band_center = iBands(Symbol(), PERIOD_H1, 20,2,0,PRICE_LOW,MODE_LOWER,index + offset);
                            // symbol, timeframe   period   deviation   band_shift  applied_price  mode        shift
      //double band_center = iMA(NULL    ,PERIOD_H1  ,20      ,0          ,0          ,PRICE_CLOSE   ,MODE_UPPER ,index + offset);
      //double band_center = iBands(NULL,0,20,2,0,PRICE_LOW,MODE_LOWER,index + offset);
      double band_center = iBands(NULL,0, 20, 0, 0, PRICE_CLOSE, MODE_LOWER, index + offset);
      
      
      if(band_center > b)     // Open price over the center band
        {
            //
            Alert("[index + offset: ",index + offset,"] band_center => ",band_center," / Open => ",b," (returning...)");
            
            return 0;
            
        }

      //+------------------------------------------------------------------+
      //| bar: 2 => down                                                                 |
      //+------------------------------------------------------------------+
      offset -= 1;
      
      Alert("[" + (string) __LINE__ + "] offset => -1 (now ",offset," / index = ",index,")");

      // validate: index + offset >= 0
      if(index + offset < 0)
        {
        
            Alert("index + offset --> less than zero");
            
            //return 0;
            return offset;
            
        }

      // validate: BB center band
                     // symbol, timeframe   period   deviation   band_shift  applied_price  mode        shift
      //band_center = iMA(NULL,   PERIOD_H1,  20,      0,          0,          PRICE_CLOSE,   MODE_UPPER, index + offset);
      band_center = iBands(NULL,0, 20, 0, 0, PRICE_CLOSE, MODE_LOWER, index + offset);
      
      
      if(band_center > b)     // Open price over the center band
        {
            //
            Alert("[index + offset: ",index + offset,"] band_center => ",band_center," / Open => ",b," (returning...)");
            
            return offset;
            
        }

      a = Close[index + offset];
      
      //Alert("Close => ",a," (index = ",index,")");
      b = Open[index + offset];
      
      c = a - b;
      
      //if(! (c <= 0) ) return offset;
      if(! (c <= 0) ) return offset;

      //+------------------------------------------------------------------+
      //| bar: 3 => down                                                                 |
      //+------------------------------------------------------------------+
      offset -= 1;
      
      Alert("offset => -1 (now ",offset," / index = ",index,")");

      // validate: index + offset >= 0
      if(index + offset < 0)
        {
        
            Alert("index + offset --> less than zero");
            
            //return 0;
            return offset;
            
        }

      // validate: BB center band
                     // symbol, timeframe   period   deviation   band_shift  applied_price  mode        shift
      //band_center = iMA(NULL,   PERIOD_H1,  20,      0,          0,          PRICE_CLOSE,   MODE_UPPER, index + offset);
      band_center = iBands(NULL,0, 20, 0, 0, PRICE_CLOSE, MODE_LOWER, index + offset);
      
      
      if(band_center > b)     // Open price over the center band
        {
            //
            Alert("[index + offset: ",index + offset,"] band_center => ",band_center," / Open => ",b," (returning...)");
            
            return offset;
            
        }

      a = Close[index + offset];
      
      //Alert("Close => ",a," (index = ",index,")");
      b = Open[index + offset];
      
      c = a - b;
      
      //if(! (c <= 0) ) return offset;
      if(! (c <= 0) ) return offset;


     //+------------------------------------------------------------------+
     //| default                                                                 |
     //+------------------------------------------------------------------+
     //return 0;
     return index;

}//_inspect__exec_over_center_band(int index)


int _inspect__exec_all_location(int index) {
      
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
      if(! (c <= 0) ) return 0;     // down bar

      //+------------------------------------------------------------------+
      //| bar: 2 => down                                                                 |
      //+------------------------------------------------------------------+
      offset -= 1;
      
      Alert("[" + (string) __LINE__ + "] offset => -1 (now ",offset," / index = ",index,")");

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
      
      c = a - b;
      
      //if(! (c <= 0) ) return offset;
      if(! (c <= 0) ) return offset;

      //+------------------------------------------------------------------+
      //| bar: 3 => down                                                                 |
      //+------------------------------------------------------------------+
      offset -= 1;
      
      Alert("offset => -1 (now ",offset," / index = ",index,")");

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
      
      c = a - b;
      
      //if(! (c <= 0) ) return offset;
      if(! (c <= 0) ) return offset;


     //+------------------------------------------------------------------+
     //| default                                                                 |
     //+------------------------------------------------------------------+
     //return 0;
     return index;

}//_inspect_exec_all_location(int index)


void detect_3Downs_Under_BB_CenterBand() {

   Alert("inspect [",TimeToStr(TimeLocal(), TIME_DATE|TIME_SECONDS),"]");
   
      //+------------------------------------------------------------------+
      //| setup                                                                 |
      //+------------------------------------------------------------------+
      string symbol_name = "USDJPY";         // symbol string
      
      ChartSetSymbolPeriod(0, symbol_name, 0);  // set symbol

      //ref https://docs.mql4.com/files/fileopen
      string terminal_data_path = TerminalInfoString(TERMINAL_DATA_PATH);  // data path
      
      string subfolder = "Research\\29_1";      // subfolder name
      
      //string fname = "3ups_3downs"        // file name
      
      //datetime t = TimeCurrent();
      datetime t = TimeLocal();
      //datetime t2 = GetTickCount();
      
      //string fname = "P7A_ins-2"        // file name
      string fname = "P7A_ins_3.detect_3Downs_Under_BB_CenterBand"        // file name
                  //+ "_" 
                  + "." 
                  //+ conv_DateTime_2_SerialTimeLabel(TimeCurrent()) 
                  //+ conv_DateTime_2_SerialTimeLabel(t) 
                  + conv_DateTime_2_SerialTimeLabel((int)t) 
                  + ".csv";
      
      string title = "3-downs, under BB.CB(center band) (inspect: p-7A)";

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
         //| detect patterns => 3-downs under BB.CB                                                                 |
         //+------------------------------------------------------------------+
         int result;
         
         // function
         

         //for(int i = (numof_target_bars - 1); i >= 0; i--)
         for(int i = (numof_target_bars - 1); i >= 0; i--)
        {

               result = _inspect__exec(i);
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
                     
                     // offset index i
                     //i -= (NUMOF_BARS_IN_PATTERN - 1) < 0 ? 0 : NUMOF_BARS_IN_PATTERN - 1;
                     
                     // next index value
                     //continue;
                     
                  }
                else if(result < 0)//if(ret == i)
                  {
                     
                  }//if(ret == i)
                // neither of the above
                //else continue;
        
         }//for(int i = 0; i < numof_target_bars - numof_ups ;i++)

         //debug
         Alert("[",__LINE__,"] 3 downs => detected");
         
         Alert("[",__LINE__,"] numof_HIT_INDICES => ",numof_HIT_INDICES,"");

/*
         //+------------------------------------------------------------------+
         //| detect patterns => 3-downs, then up                                                                 |                                                                 |
         //+------------------------------------------------------------------+
         ArrayResize(hit_indices_up, numof_HIT_INDICES);
         
         double body;
         
         //debug
         FileWrite(filehandle, "");
         FileWrite(filehandle, "["+ (string)__LINE__ + "] 3-downs, then up...");
         
         //for(i = (numof_HIT_INDICES - 1); i >= 0; i--)
         for(int i = 0; i < numof_HIT_INDICES; i++)
           {
           
               body = Open[HIT_INDICES[i] - 3] - Close[HIT_INDICES[i] - 3];
               

               if(body <= 0)  // up
                 {
                 
                     hit_indices_up[numof_hit_indices_up] = HIT_INDICES[i];
                     // increment the index
                     numof_hit_indices_up += 1;
                     
                 }
               
           }//for(i = 0; i < numof_HIT_INDICES; i++)

*/
         //+------------------------------------------------------------------+
         //| write: hit data => 3-downs                                                                 |
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

/*
         //+------------------------------------------------------------------+
         //| write: hit data => 3-downs, then up                                                                 |
         //+------------------------------------------------------------------+
         //double a, b;
         
         FileWrite(filehandle, "");
         FileWrite(filehandle, 
         
                  "["+ (string)__LINE__ + "] 3-downs, then up",
                  "num = " + (string) numof_hit_indices_up
         
         );
         
         
         for(int i=0; i < numof_hit_indices_up; i++)
           {
               a = Close[hit_indices_up[i]];
               b = Open[hit_indices_up[i]];
               
               FileWrite(filehandle, 
                  
                  (i + 1), 
                  
                  hit_indices_up[i],
                  
                  TimeToStr(iTime(Symbol(), Period(), hit_indices_up[i])),
                  
                  a, b, (a - b)
                  
               );    // data
            
           }//for(int i=0;i < numof_hit_indices; i++)

*/

      }//if(filehandle == INVALID_HANDLE)



      //+------------------------------------------------------------------+
      //| File: close                                                                 |
      //+------------------------------------------------------------------+
      
      FileClose(filehandle);
      
      Alert("file => closed");

}//detect_3Downs_Under_BB_CenterBand()

void detect_3Downs_Over_BB_CenterBand() {

   Alert("inspect [",TimeToStr(TimeLocal(), TIME_DATE|TIME_SECONDS),"]");
   
      //+------------------------------------------------------------------+
      //| setup                                                                 |
      //+------------------------------------------------------------------+
      string symbol_name = "USDJPY";         // symbol string
      
      ChartSetSymbolPeriod(0, symbol_name, 0);  // set symbol

      //ref https://docs.mql4.com/files/fileopen
      string terminal_data_path = TerminalInfoString(TERMINAL_DATA_PATH);  // data path
      
      string subfolder = "Research\\29_1";      // subfolder name
      
      //string fname = "3ups_3downs"        // file name
      
      //datetime t = TimeCurrent();
      datetime t = TimeLocal();
      //datetime t2 = GetTickCount();
      
      //string fname = "P7A_ins-2"        // file name
      string fname = "P7A_ins_3.detect_3Downs_Over_BB_CenterBand"        // file name
                  //+ "_" 
                  + "." 
                  //+ conv_DateTime_2_SerialTimeLabel(TimeCurrent()) 
                  //+ conv_DateTime_2_SerialTimeLabel(t) 
                  + conv_DateTime_2_SerialTimeLabel((int)t) 
                  + ".csv";
      
      string title = "3-downs, over BB.CB(center band) (inspect: p-7A)";

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
         //| detect patterns => 3-downs under BB.CB                                                                 |
         //+------------------------------------------------------------------+
         int result;
         
         // function
         

         //for(int i = (numof_target_bars - 1); i >= 0; i--)
         for(int i = (numof_target_bars - 1); i >= 0; i--)
        {

               result = _inspect__exec_over_center_band(i);
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
                     
                     // offset index i
                     //i -= (NUMOF_BARS_IN_PATTERN - 1) < 0 ? 0 : NUMOF_BARS_IN_PATTERN - 1;
                     
                     // next index value
                     //continue;
                     
                  }
                else if(result < 0)//if(ret == i)
                  {
                     
                  }//if(ret == i)
                // neither of the above
                //else continue;
        
         }//for(int i = 0; i < numof_target_bars - numof_ups ;i++)

         //debug
         Alert("[",__LINE__,"] 3 downs => detected");
         
         Alert("[",__LINE__,"] numof_HIT_INDICES => ",numof_HIT_INDICES,"");

/*
         //+------------------------------------------------------------------+
         //| detect patterns => 3-downs, then up                                                                 |                                                                 |
         //+------------------------------------------------------------------+
         ArrayResize(hit_indices_up, numof_HIT_INDICES);
         
         double body;
         
         //debug
         FileWrite(filehandle, "");
         FileWrite(filehandle, "["+ (string)__LINE__ + "] 3-downs, then up...");
         
         //for(i = (numof_HIT_INDICES - 1); i >= 0; i--)
         for(int i = 0; i < numof_HIT_INDICES; i++)
           {
           
               body = Open[HIT_INDICES[i] - 3] - Close[HIT_INDICES[i] - 3];
               

               if(body <= 0)  // up
                 {
                 
                     hit_indices_up[numof_hit_indices_up] = HIT_INDICES[i];
                     // increment the index
                     numof_hit_indices_up += 1;
                     
                 }
               
           }//for(i = 0; i < numof_HIT_INDICES; i++)

*/
         //+------------------------------------------------------------------+
         //| write: hit data => 3-downs                                                                 |
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

/*
         //+------------------------------------------------------------------+
         //| write: hit data => 3-downs, then up                                                                 |
         //+------------------------------------------------------------------+
         //double a, b;
         
         FileWrite(filehandle, "");
         FileWrite(filehandle, 
         
                  "["+ (string)__LINE__ + "] 3-downs, then up",
                  "num = " + (string) numof_hit_indices_up
         
         );
         
         
         for(int i=0; i < numof_hit_indices_up; i++)
           {
               a = Close[hit_indices_up[i]];
               b = Open[hit_indices_up[i]];
               
               FileWrite(filehandle, 
                  
                  (i + 1), 
                  
                  hit_indices_up[i],
                  
                  TimeToStr(iTime(Symbol(), Period(), hit_indices_up[i])),
                  
                  a, b, (a - b)
                  
               );    // data
            
           }//for(int i=0;i < numof_hit_indices; i++)

*/

      }//if(filehandle == INVALID_HANDLE)



      //+------------------------------------------------------------------+
      //| File: close                                                                 |
      //+------------------------------------------------------------------+
      
      FileClose(filehandle);
      
      Alert("file => closed");

}//detect_3Downs_Over_BB_CenterBand()


void detect_3Downs() {

   Alert("inspect [",TimeToStr(TimeLocal(), TIME_DATE|TIME_SECONDS),"]");
   
      //+------------------------------------------------------------------+
      //| setup                                                                 |
      //+------------------------------------------------------------------+
      string symbol_name = "USDJPY";         // symbol string
      
      ChartSetSymbolPeriod(0, symbol_name, 0);  // set symbol

      //ref https://docs.mql4.com/files/fileopen
      string terminal_data_path = TerminalInfoString(TERMINAL_DATA_PATH);  // data path
      
      string subfolder = "Research\\29_1";      // subfolder name
      
      //string fname = "3ups_3downs"        // file name
      
      //datetime t = TimeCurrent();
      datetime t = TimeLocal();
      //datetime t2 = GetTickCount();
      
      //string fname = "P7A_ins-2"        // file name
      string fname = "P7A_ins_3.detect_3Downs"        // file name
                  //+ "_" 
                  + "." 
                  //+ conv_DateTime_2_SerialTimeLabel(TimeCurrent()) 
                  //+ conv_DateTime_2_SerialTimeLabel(t) 
                  + conv_DateTime_2_SerialTimeLabel((int)t) 
                  + ".csv";
      
      string title = "3-downs (inspect: p-7A)";

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
         //| detect patterns => 3-downs under BB.CB                                                                 |
         //+------------------------------------------------------------------+
         int result;
         
         // function
         

         //for(int i = (numof_target_bars - 1); i >= 0; i--)
         for(int i = (numof_target_bars - 1); i >= 0; i--)
        {

               //result = _inspect__exec(i);
               result = _inspect__exec_all_location(i);
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
                     
                     // offset index i
                     //i -= (NUMOF_BARS_IN_PATTERN - 1) < 0 ? 0 : NUMOF_BARS_IN_PATTERN - 1;
                     
                     // next index value
                     //continue;
                     
                  }
                else if(result < 0)//if(ret == i)
                  {
                     
                  }//if(ret == i)
                // neither of the above
                //else continue;
        
         }//for(int i = 0; i < numof_target_bars - numof_ups ;i++)

         //debug
         Alert("[",__LINE__,"] 3 downs => detected");
         
         Alert("[",__LINE__,"] numof_HIT_INDICES => ",numof_HIT_INDICES,"");

/*
         //+------------------------------------------------------------------+
         //| detect patterns => 3-downs, then up                                                                 |                                                                 |
         //+------------------------------------------------------------------+
         ArrayResize(hit_indices_up, numof_HIT_INDICES);
         
         double body;
         
         //debug
         FileWrite(filehandle, "");
         FileWrite(filehandle, "["+ (string)__LINE__ + "] 3-downs, then up...");
         
         //for(i = (numof_HIT_INDICES - 1); i >= 0; i--)
         for(int i = 0; i < numof_HIT_INDICES; i++)
           {
           
               body = Open[HIT_INDICES[i] - 3] - Close[HIT_INDICES[i] - 3];
               

               if(body <= 0)  // up
                 {
                 
                     hit_indices_up[numof_hit_indices_up] = HIT_INDICES[i];
                     // increment the index
                     numof_hit_indices_up += 1;
                     
                 }
               
           }//for(i = 0; i < numof_HIT_INDICES; i++)

*/
         //+------------------------------------------------------------------+
         //| write: hit data => 3-downs                                                                 |
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

/*
         //+------------------------------------------------------------------+
         //| write: hit data => 3-downs, then up                                                                 |
         //+------------------------------------------------------------------+
         //double a, b;
         
         FileWrite(filehandle, "");
         FileWrite(filehandle, 
         
                  "["+ (string)__LINE__ + "] 3-downs, then up",
                  "num = " + (string) numof_hit_indices_up
         
         );
         
         
         for(int i=0; i < numof_hit_indices_up; i++)
           {
               a = Close[hit_indices_up[i]];
               b = Open[hit_indices_up[i]];
               
               FileWrite(filehandle, 
                  
                  (i + 1), 
                  
                  hit_indices_up[i],
                  
                  TimeToStr(iTime(Symbol(), Period(), hit_indices_up[i])),
                  
                  a, b, (a - b)
                  
               );    // data
            
           }//for(int i=0;i < numof_hit_indices; i++)

*/

      }//if(filehandle == INVALID_HANDLE)



      //+------------------------------------------------------------------+
      //| File: close                                                                 |
      //+------------------------------------------------------------------+
      
      FileClose(filehandle);
      
      Alert("file => closed");

}//detect_3Downs()
