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
int NUMOF_DAYS = 30;
//int NUMOF_DAYS = 90;
int NUMOF_BARS_IN_PATTERN = 3;

//--------------------------------------------------------------------
int start()                           // Special function start()
  {

   //test
   if(Fact_Up == true)           // initially, Fact_Up is set to true
     {
     
         inspect_P7A();

         Fact_Up = false;        // no more executions
         

         //+------------------------------------------------------------------+
         //| Ending                                                                 |
         //+------------------------------------------------------------------+
         Alert("Done");
         
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
/*
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

*/
      
      
      return time_label;

}//conv_DateTime_2_SerialTimeLabel(int time)

void inspect_P7A() {

      Alert("inspect_P7A()");

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
      
      string title = "List of 3-ups (inspect: p-7A)";

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
            int hit_indices_up[];   // 3-downs, then up
            int hit_indices_down[]; // 3-downs, then down
            
            int numof_hit_indices = 0;  // count up the matched bars
            int numof_hit_indices_up = 0;  // count up the matched bars
            int numof_hit_indices_down = 0;  // count up the matched bars

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
                        title
                        
                        );

            //+------------------------------------------------------------------+
            //| header                                                                 |
            //+------------------------------------------------------------------+
            FileWrite(filehandle,
                  "no.", "index", "time", "close", "open", "diff"
                  
                  );    // header

            //+------------------------------------------------------------------+
            //| detect patterns => 3-downs                                                                 |
            //+------------------------------------------------------------------+
            double a,b;
            
            double upper_shadow, lower_shadow;
            
            double c;
            
            int result;
            
            // function
            

            for(int i = (numof_target_bars - 1); i >= 0; i--)
           {
           
               result = _inspect_P7A__exec(i);
                              
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
         //| detect patterns => 3-downs, then up                                                                 |                                                                 |
         //+------------------------------------------------------------------+
         ArrayResize(hit_indices_up, numof_hit_indices);
         
         double body;
         
         //debug
         FileWrite(filehandle, "");
         FileWrite(filehandle, "3-downs, then up...");
         
         //for(i = (numof_hit_indices - 1); i >= 0; i--)
         for(i = 0; i < numof_hit_indices; i++)
           {
           
               //debug
               FileWrite(filehandle, "hit_indices[",i,"] => ",hit_indices[i]," / ",TimeToStr(iTime(Symbol(), Period(), hit_indices[i])),"" );
           
               body = Open[hit_indices[i] - 3] - Close[hit_indices[i] - 3];
               

               if(body <= 0)  // up
                 {
                 
                     //debug
                     FileWrite(filehandle, "body <= 0: ",body,"");
                     
                     hit_indices_up[numof_hit_indices_up] = hit_indices[i];
                     // increment the index
                     numof_hit_indices_up += 1;
                     
                 }
               
           }//for(i = 0; i < numof_hit_indices; i++)



/*               
         for(i = (numof_hit_indices - 1); i >= 0; i--)
           {
           
               body = Open[hit_indices[i] - 3] - Close[hit_indices[i] - 3];
               
               if(body <= 0)  // up
                 {
                     
                     hit_indices_up[numof_hit_indices_up] = hit_indices[i];
                     
                     // increment the index
                     numof_hit_indices_up += 1;
                     
                 }
               
           }
*/
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
         //| write: hit data => 3-ups                                                                 |
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
                  
                  a, b, (a - b)
                  
                  /*
                  a, b, (a - b),
                  
                  High[hit_indices[i] - 2] - Open[hit_indices[i] - 2],
                  
                  Open[hit_indices[i] - 2] - Close[hit_indices[i] - 2],
                  
                  //High[hit_indices[i] - 2] - Open[hit_indices[i] - 2],
                  
                  Close[hit_indices[i] - 2] - Low[hit_indices[i] - 2]
                  */
               );    // data
            
           }//for(int i=0;i < numof_hit_indices; i++)


         //+------------------------------------------------------------------+
         //| write: hit data => 3-downs, then up                                                                 |
         //+------------------------------------------------------------------+
         //double a, b;
         
         FileWrite(filehandle, "");
         FileWrite(filehandle, "3-ups, then up");
         
         FileWrite(filehandle, "numof_hit_indices_up => ",numof_hit_indices_up,"");

         for(i=0; i < numof_hit_indices_up; i++)
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

         //+------------------------------------------------------------------+
         //| File: close                                                                 |
         //+------------------------------------------------------------------+
         
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

      


}//inspect_P7A()

int _inspect_P7A__exec(int index) {
      
      double a,b,c;
      
      double d,e;
      double lower_shadow;
      
      int offset = 0;

      //+------------------------------------------------------------------+
      //| bar: 1 => down                                                                 |
      //+------------------------------------------------------------------+
      a = Close[index + offset];
      b = Open[index + offset];
      
      c = a - b;
      
      if(! (c <= 0) ) return offset;

            
      //+------------------------------------------------------------------+
      //| bar: 2 => down                                                                 |
      //+------------------------------------------------------------------+
      offset -= 1;
      
      a = Close[index + offset];
      b = Open[index + offset];
      
      c = a - b;
      
      //if(! (c <= 0) ) return offset;
      if(! (c <= 0) ) return offset;

      //+------------------------------------------------------------------+
      //| bar: 3 => down
      //+------------------------------------------------------------------+
      offset -= 1;
      
      a = Close[index + offset];
      b = Open[index + offset];
      
      c = a - b;
      
      // body => down
      if(! (c <= 0) ) return offset;
      
      // lower shadow => longer than body
      //lower_shadow = Close[index + offset] - Low[index + offset];
      
      //if (! (lower_shadow > 0 && lower_shadow > -1.0 * c) ) return offset;

     //+------------------------------------------------------------------+
     //| default                                                                 |
     //+------------------------------------------------------------------+
     //return 0;
     return index;

}//_inspect_P7A__exec(int index)
