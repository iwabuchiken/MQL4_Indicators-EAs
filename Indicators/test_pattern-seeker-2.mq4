//--------------------------------------------------------------------
// test_pattern-seeker-1.mq4
// 20161108_104115
// 
// <Usage>
// - Find patterns in a given symbol chart.
// - Use H1 bars
// - seekPattern_3Falls3Ups() ---> detect a pattern in which 3 downs and 3 ups appear.
//--------------------------------------------------------------------
extern int Period_MA = 21;            // Calculated MA period
bool Fact_Up = true;                  // Fact of report that price..
bool Fact_Dn = true;                  //..is above or below MA

//int NUMOF_DAYS = 3;
//int NUMOF_DAYS = 30;
int NUMOF_DAYS = 90;
int NUMOF_BARS_IN_PATTERN = 6;

//--------------------------------------------------------------------
int start()                           // Special function start()
  {

   //test
   if(Fact_Up == true)           // initially, Fact_Up is set to true
     {
     
         seekPattern_P7A();

         Fact_Up = false;        // no more executions
         
         
     }

//--------------------------------------------------------------------
   return;                            // Exit start()
}//int start()
//--------------------------------------------------------------------

string conv_DateTime_2_SerialTimeLabel(int time) {

      //string datetime_label = TimeToStr(time);
      string datetime_label = TimeToStr(time, TIME_DATE|TIME_SECONDS);
      
      //+------------------------------------------------------------------+
      //| split: date and time                                                                 |
      //+------------------------------------------------------------------+
      
      //ref https://docs.mql4.com/strings/stringsplit
      string sep=" ";                // A separator as a character
      
      ushort u_sep;                  // The code of the separator character
      
      string result_date_time[];               // An array to get strings
      
      //--- Get the separator code
      u_sep=StringGetCharacter(sep,0);
   
      int k=StringSplit(datetime_label,u_sep,result_date_time);
      

      //+------------------------------------------------------------------+
      //| split: date                                                                 |
      //+------------------------------------------------------------------+
      string sep_date=".";                // A separator as a character
      
//      ushort u_sep;                  // The code of the separator character
      
      string result_date[];               // An array to get strings
      
      //--- Get the separator code
      u_sep = StringGetCharacter(sep_date,0);
   
      k = StringSplit(result_date_time[0],u_sep,result_date);
      
      
      //+------------------------------------------------------------------+
      //| split: time                                                                 |
      //+------------------------------------------------------------------+
      string sep_time=":";                // A separator as a character
      
//      ushort u_sep;                  // The code of the separator character
      
      string result_time[];               // An array to get strings
      
      //--- Get the separator code
      u_sep = StringGetCharacter(sep_time,0);
   
      k = StringSplit(result_date_time[1],u_sep,result_time);


      //+------------------------------------------------------------------+
      //| Build string                                                                 |
      //+------------------------------------------------------------------+
      string time_label = result_date[0] + result_date[1] + result_date[2]
      
                        + "_"
                        
                        + result_time[0] + result_time[1] + result_time[2];

      //+------------------------------------------------------------------+
      //| report                                                                 |
      //+------------------------------------------------------------------+

      Alert("datetime_label => ",datetime_label,""
      
            + "\n"
            + "result_date_time[0] => ",result_date_time[0],""
            
            + "\n"
            + "result_date[0] => ",result_date[0],""
            
            + "\n"
            + "result_time[0] => ",result_time[0],""
            
            + "\n"
            + "time_label => ", time_label,""
            
      );


      
      
      return time_label;

}//conv_DateTime_2_SerialTimeLabel(int time)

void seekPattern_P7A() {

      Alert("seekPattern_P7A()");

      //+------------------------------------------------------------------+
      //| setup                                                                 |
      //+------------------------------------------------------------------+
      string symbol_name = "USDJPY";         // symbol string
      
      ChartSetSymbolPeriod(0, symbol_name, 0);  // set symbol

      //ref https://docs.mql4.com/files/fileopen
      string terminal_data_path = TerminalInfoString(TERMINAL_DATA_PATH);  // data path
      
      string subfolder = "Research\\28_1";      // subfolder name
      
      //string fname = "3ups_3downs"        // file name
      string fname = "P7A"        // file name
                  //+ "_" 
                  + "." 
                  + conv_DateTime_2_SerialTimeLabel(TimeCurrent()) 
                  + ".csv";

      //+------------------------------------------------------------------+
      //| File: open                                                                 |
      //+------------------------------------------------------------------+
      int filehandle = FileOpen(subfolder + "\\" + fname, FILE_WRITE|FILE_CSV);
      
      if(filehandle!=INVALID_HANDLE)
        {
            
            //+------------------------------------------------------------------+
            //| vars                                                                 |
            //+------------------------------------------------------------------+
            datetime d = TimeCurrent();      // current time

            int hours_per_day = 24;
            
            //int numof_target_bars = NUMOF_DAYS * hours_per_day;
            int numof_target_bars = (NUMOF_DAYS * hours_per_day > Bars) 
                              ? Bars : NUMOF_DAYS * hours_per_day;

            int k = 0;      // offset used for i
            
            int hit_indices[];   // indices of matched bars(i.e. 3-ups)
            
            int numof_hit_indices = 0;  // count up the matched bars

            //ref https://docs.mql4.com/array/arrayresize
            ArrayResize(hit_indices, numof_target_bars);     // compile -> OK
            
            //ref https://www.mql5.com/en/forum/3239
            FileSeek(filehandle,0,SEEK_END);

            //+------------------------------------------------------------------+
            //| metadata                                                                  |
            //+------------------------------------------------------------------+
            FileWrite(filehandle, 
                        TimeToStr(d, TIME_DATE|TIME_SECONDS), 
                        symbol_name,
                        //PERIOD_CURRENT
                        //ref https://www.mql5.com/en/forum/133159
                        "period = ",Period(),"",
                        "List of p-7A"
                        
                        );

            //+------------------------------------------------------------------+
            //| header                                                                 |
            //+------------------------------------------------------------------+
            FileWrite(filehandle,
                  "no.", "index", "time", "close", "open", "diff",
                  "upper shadow (3rd bar)", "body (3rd bar)", "lower shadow (3rd bar)"
                  
                  );    // header

            //+------------------------------------------------------------------+
            //| detect patterns                                                                 |
            //+------------------------------------------------------------------+
            double a,b;
            
            double upper_shadow, lower_shadow;
            
            double c;
            
            int result;
            
            for(int i = (numof_target_bars - 1); i >= 0; i--)
           {
           
               result = _seekPattern_P7A__exec(i);
                              
               if(result == i && i != 0)
                 {
                 
                     // add to the array
                     hit_indices[numof_hit_indices] = i;
                     
                     // increment the index
                     numof_hit_indices += 1;
                     
                     // offset index i
                     i -= (NUMOF_BARS_IN_PATTERN - 1) < 0 ? 0 : NUMOF_BARS_IN_PATTERN - 1;
                     
                     // next index value
                     continue;
                     
                  }
                else if(result < 0)//if(ret == i)
                  {
                     // increment i by the return value(which is, the offset value k minus -1)
                     // next index value
                     i += result; continue;
                     
                  }//if(ret == i)
                // neither of the above
                else continue;

            }//for(int i = 0; i < numof_target_bars - numof_ups ;i++)
            
                 
         //+------------------------------------------------------------------+
         //| footer                                                                 |
         //+------------------------------------------------------------------+
         FileWrite(filehandle, 
                  
                  "numof_hit_indices=",numof_hit_indices,"", 
                  //"num of hit bars=",numof_hit_indices * xups,"", 
                  
                  "total bars=",numof_target_bars,"",
                  
                  //"ratio=",numof_hit_indices*1.0/numof_target_bars,""
                  "ratio=",(NUMOF_BARS_IN_PATTERN * numof_hit_indices) * 1.0/numof_target_bars,""
                  //int NUMOF_BARS_IN_PATTERN = 2;
                  //"ratio=", (numof_hit_indices * xups) * 1.0 / numof_target_bars,""
                  
                  );    // data
         
         
         //+------------------------------------------------------------------+
         //| write: hit data                                                                 |
         //+------------------------------------------------------------------+
         //double a, b;
         
         
         for(i=0; i < numof_hit_indices; i++)
           {
               a = Close[hit_indices[i]];
               b = Open[hit_indices[i]];
               
               FileWrite(filehandle, 
                  
                  (i + 1), 
                  
                  hit_indices[i],
                  
                  TimeToStr(iTime(Symbol(), Period(), hit_indices[i])),
                  
                  //a, b, (a - b)
                  a, b, (a - b),
                  
                  High[hit_indices[i] - 2] - Open[hit_indices[i] - 2],
                  
                  Open[hit_indices[i] - 2] - Close[hit_indices[i] - 2],
                  
                  //High[hit_indices[i] - 2] - Open[hit_indices[i] - 2],
                  
                  Close[hit_indices[i] - 2] - Low[hit_indices[i] - 2]
                  
               );    // data
            
           }//for(int i=0;i < numof_hit_indices; i++)
         
         FileClose(filehandle);
         //Print("The file most be created in the folder "+terminal_data_path+"\\"+subfolder);

      //+------------------------------------------------------------------+
      //| File: can't open                                                                 |
      //+------------------------------------------------------------------+
      }
      else {
      
         Print("File open failed, error ",GetLastError());
         
         //alert
         Alert("File open failed, error");
         
      }

      


}//seekPattern_P7A()

int _seekPattern_P7A__exec(int index) {
      
      double a,b,c;
      
      double d,e;
      double lower_shadow;
      
      int offset = 0;

      //+------------------------------------------------------------------+
      //| bar: 1                                                                 |
      //+------------------------------------------------------------------+
      a = Close[index + offset];
      b = Open[index + offset];
      
      c = a - b;
      
      if(! (c <= 0) ) return offset;

            
      //+------------------------------------------------------------------+
      //| bar: 2                                                                 |
      //+------------------------------------------------------------------+
      offset -= 1;
      
      a = Close[index + offset];
      b = Open[index + offset];
      
      c = a - b;
      
      //if(! (c <= 0) ) return offset;
      if(! (c <= 0) ) return offset;

      //+------------------------------------------------------------------+
      //| bar: 3 => down, long lower shadow                                                                 |
      //+------------------------------------------------------------------+
      offset -= 1;
      
      a = Close[index + offset];
      b = Open[index + offset];
      
      c = a - b;
      
      //d = Low[index + offset];
      
      //if(! (c <= 0) ) return offset;
      //if(! (c <= 0) ) return offset;
      //if(! (c <= 0) && (lower_shadow > 0 && lower_shadow > MathAbs(c))) return offset;
      //if(! (c <= 0) && (lower_shadow > 0 && lower_shadow > MathAbs(c * 1.0))) return offset;
      //if(! (c <= 0) && (lower_shadow > 0 && lower_shadow > -1.0 * c)) return offset;
      // body => down
      if(! (c <= 0) ) return offset;
      
      // lower shadow => longer than body
      lower_shadow = Close[index + offset] - Low[index + offset];
      
      if (! (lower_shadow > 0 && lower_shadow > -1.0 * c) ) return offset;

      //+------------------------------------------------------------------+
      //| bar: 4 => up                                                               |
      //+------------------------------------------------------------------+
      offset -= 1;
      
      a = Close[index + offset];
      b = Open[index + offset];
      
      c = a - b;
      
      //if(! (c <= 0) ) return offset;
      if(! (c >= 0) ) return offset;

      //+------------------------------------------------------------------+
      //| bar: 5 => up                                                               |
      //+------------------------------------------------------------------+
      offset -= 1;
      
      a = Close[index + offset];
      b = Open[index + offset];
      
      c = a - b;
      
      //if(! (c <= 0) ) return offset;
      if(! (c >= 0) ) return offset;

      //+------------------------------------------------------------------+
      //| bar: 6 => up                                                               |
      //+------------------------------------------------------------------+
      offset -= 1;
      
      a = Close[index + offset];
      b = Open[index + offset];
      
      c = a - b;
      
      //if(! (c <= 0) ) return offset;
      if(! (c >= 0) ) return offset;

     //+------------------------------------------------------------------+
     //| default                                                                 |
     //+------------------------------------------------------------------+
     //return 0;
     return index;


}//_seekPattern_P7A__exec(int index)
