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
//--------------------------------------------------------------------
int start()                           // Special function start()
  {
   double MA;                         // MA value on 0 bar    
//--------------------------------------------------------------------
                                      // Tech. ind. function call
   MA=iMA(NULL,0,Period_MA,0,MODE_SMA,PRICE_CLOSE,0); 
//--------------------------------------------------------------------

   //test
   if(Fact_Up == true)           // initially, Fact_Up is set to true
     {
     
         //int numof_days = 30;
         int numof_days = 3;
         
         //seekPattern_3Falls3Ups(numof_days);   // exec: BB +2s values
         //seekPattern_3Falls3Ups__V2(numof_days);
         //seekPattern_3Falls3Ups(numof_days);
         seekPattern_3Ups(numof_days);

         Fact_Up = false;        // no more executions
         
         
     }

//--------------------------------------------------------------------
   return;                            // Exit start()
}//int start()
//--------------------------------------------------------------------

void seekPattern_3Falls3Ups(int numof_days) {

      Alert("seekPattern_3Falls3Ups()");


      //test: change symbol: step.8-3-P.1-t.4

      //+------------------------------------------------------------------+
      //| setup                                                                 |
      //+------------------------------------------------------------------+
      string symbol_name = "USDJPY";         // symbol string
      
      ChartSetSymbolPeriod(0, symbol_name, 0);  // set symbol

      //ref https://docs.mql4.com/files/fileopen
      string terminal_data_path = TerminalInfoString(TERMINAL_DATA_PATH);  // data path
      
      string subfolder = "Research";      // subfolder name
      
      string fname = "3ups_3downs"        // file name
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
            
            datetime d = TimeCurrent();      // current time
                  
            //int numOf_Highs = 3;
            int hours_per_day = 24;
            int numOf_Highs = numof_days * hours_per_day;
            
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
                        "List of 3-ups"
                        
                        );

            //+------------------------------------------------------------------+
            //| header                                                                 |
            //+------------------------------------------------------------------+
            //FileWrite(filehandle,"no.","time", "close");    // header
            FileWrite(filehandle,"no.", "index", "time", "a", "b", "c");    // header

            //+------------------------------------------------------------------+
            //| get: data: setup                                                                 |
            //+------------------------------------------------------------------+
            // vars
            //int i;
            double a,b;    // a => high, b => low
            
            double c;      // diff of a minus b
            
            int numof_target_bars = numof_days * 24;
            
            //string data[][3];    // data: no., time, close
            
            int k = 0;      // offset used for i
            
            //int hit_indices[];   // indices of matched bars(i.e. 3-ups)
            int hit_indices[];   // indices of matched bars(i.e. 3-ups)
            
            //ref https://docs.mql4.com/array/arrayresize
            //ArrayResize(hit_indices, Bars);     // compile -> OK
            ArrayResize(hit_indices, numof_days * 24);     // compile -> OK
            
            int numof_hit_indices = 0;  // count up the matched bars
                        
                     
            for(int i=0; i < numof_target_bars ;i++)
           {
               
               a = Close[i + k];
               b = Open[i + k];
               c = a - b;
               
               if(c >= 0)
                 {
                     
                     hit_indices[numof_hit_indices] = i;
                     
                     FileWrite(filehandle, 
                           numof_hit_indices, 
                           i, 
                           TimeToStr(iTime(symbol_name, Period(), i)), 
                           a, b, c);    // data
                     
                     numof_hit_indices += 1;
                     
                 }
               
           }//for(int i=0; i < numof_target_bars ;i++)

            
            
                 
            //FileWrite(filehandle,"numof_hit_indices => ",numof_hit_indices,"");
                 
         //+------------------------------------------------------------------+
         //| footer                                                                 |
         //+------------------------------------------------------------------+
         FileWrite(filehandle, 
                  "numof_hit_indices=",numof_hit_indices,"", 
                  "total bars=",numof_target_bars,"",
                  
                  "ratio=",numof_hit_indices*1.0/numof_target_bars,""
                  
                  );    // data
         
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

      


}//void seekPattern_3Falls3Ups(int numof_days)

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

void seekPattern_3Falls3Ups__V2(int numof_days) {

      Alert("seekPattern_3Falls3Ups()");

      //+------------------------------------------------------------------+
      //| setup                                                                 |
      //+------------------------------------------------------------------+
      string symbol_name = "USDJPY";         // symbol string
      
      ChartSetSymbolPeriod(0, symbol_name, 0);  // set symbol

      //ref https://docs.mql4.com/files/fileopen
      string terminal_data_path = TerminalInfoString(TERMINAL_DATA_PATH);  // data path
      
      string subfolder = "Research";      // subfolder name
      
      string fname = "3ups_3downs"        // file name
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
            
            datetime d = TimeCurrent();      // current time
                  
            //int numOf_Highs = 3;
            int hours_per_day = 24;
            int numOf_Highs = numof_days * hours_per_day;
            
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
                        "List of 3-ups"
                        
                        );

            //+------------------------------------------------------------------+
            //| header                                                                 |
            //+------------------------------------------------------------------+
            //FileWrite(filehandle,"no.","time", "close");    // header
            FileWrite(filehandle,"no.", "index", "time", "close", "open", "diff");    // header

            //+------------------------------------------------------------------+
            //| get: data: setup                                                                 |
            //+------------------------------------------------------------------+
            // vars
            //int i;
            double a,b;    // a => high, b => low
            
            double c;      // diff of a minus b
            
            int numof_target_bars = numof_days * 24;
            
            //string data[][3];    // data: no., time, close
            
            int k = 0;      // offset used for i
            
            //int hit_indices[];   // indices of matched bars(i.e. 3-ups)
            int hit_indices[];   // indices of matched bars(i.e. 3-ups)
            
            //ref https://docs.mql4.com/array/arrayresize
            //ArrayResize(hit_indices, Bars);     // compile -> OK
            ArrayResize(hit_indices, numof_days * 24);     // compile -> OK
            
            int numof_hit_indices = 0;  // count up the matched bars
            
            int numof_ups = 3;
                     
            //for(int i=0; i < numof_target_bars ;i++)
            for(int i = 0; i < numof_target_bars - numof_ups ;i++)
           {
               
               a = Close[i + k];    // k --> 0
               b = Open[i + k];
               c = a - b;
               
               if(c >= 0)  // 1st bar
                 {
                     
                     k += 1;     // increment k; k is now --> 1
                     
                     // reenter each value
                     a = Close[i + k];
                     b = Open[i + k];
                     c = a - b;
                     
                     if(c >= 0)  // 2nd bar
                       {

                           k += 1;     // increment k; k is now --> 2
                           
                           // reenter each value
                           a = Close[i + k];
                           b = Open[i + k];
                           c = a - b;
                           
                           if(c >= 0)  // 3rd bar
                             {
                                 // Now, 3 bars are all ups.
                                 // The value of the index i --> save to hit_indices[]
                                 hit_indices[numof_hit_indices] = i;
                                 
                                 // write file
                                 FileWrite(filehandle, 
                                 
                                       numof_hit_indices, 
                                       i, 
                                       TimeToStr(iTime(symbol_name, Period(), i)), 
                                       a, b, c);    // data

                                 
                                 
                                 numof_hit_indices += 1;    // increment the count
                                 
                                 // increment i
                                 i += k;
                                 
                                 // reset k
                                 k = 0;
                     
                                 // next index
                                 continue;
                                 
                             }//if(c >= 0)  // 3rd bar
                           else//if(c >= 0)  // 3rd bar
                             {
                              
                                 // increment i
                                 i += k;
                                 
                                 // reset k
                                 k = 0;
                                 
                                 // next index
                                 continue;
                              
                             }//if(c >= 0)  // 3rd bar
                        
                       }//if(c >= 0)  // 2nd bar
                     else
                       {
                        
                           i += 1;     // increment i by 1
                           
                           // reset k
                           k = 0;
                           
                           continue;
                        
                       }//if(c >= 0)  // 2nd bar
                     
                 }//if(c >= 0)  // 1st bar
               else
                 {
                     
                     // reset k
                     k = 0;
                     
                     continue;
                     
                 }//if(c >= 0)  // 1st bar
               
           }//for(int i=0; i < numof_target_bars ;i++)

            
            
                 
            //FileWrite(filehandle,"numof_hit_indices => ",numof_hit_indices,"");
                 
         //+------------------------------------------------------------------+
         //| footer                                                                 |
         //+------------------------------------------------------------------+
         FileWrite(filehandle, 
                  "numof_hit_indices=",numof_hit_indices,"", 
                  "total bars=",numof_target_bars,"",
                  
                  "ratio=",numof_hit_indices*1.0/numof_target_bars,""
                  
                  );    // data
         
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

      


}//void seekPattern_3Falls3Ups__V2(int numof_days)

void seekPattern_3Ups(int numof_days) {

      Alert("seekPattern_3Falls3Ups()");

      //+------------------------------------------------------------------+
      //| setup                                                                 |
      //+------------------------------------------------------------------+
      string symbol_name = "USDJPY";         // symbol string
      
      ChartSetSymbolPeriod(0, symbol_name, 0);  // set symbol

      //ref https://docs.mql4.com/files/fileopen
      string terminal_data_path = TerminalInfoString(TERMINAL_DATA_PATH);  // data path
      
      string subfolder = "Research";      // subfolder name
      
      //string fname = "3ups_3downs"        // file name
      string fname = "3ups"        // file name
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
            
            datetime d = TimeCurrent();      // current time
                  
            //int numOf_Highs = 3;
            int hours_per_day = 24;
            int numOf_Highs = numof_days * hours_per_day;
            
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
                        "List of 3-ups"
                        
                        );

            //+------------------------------------------------------------------+
            //| header                                                                 |
            //+------------------------------------------------------------------+
            //FileWrite(filehandle,"no.","time", "close");    // header
            FileWrite(filehandle,"no.", "index", "time", "close", "open", "diff");    // header

            //+------------------------------------------------------------------+
            //| get: data: setup                                                                 |
            //+------------------------------------------------------------------+
            // vars
            //int i;
            //double a,b;    // a => high, b => low
            
            //double c;      // diff of a minus b
            
            int numof_target_bars = numof_days * 24;
            
            //string data[][3];    // data: no., time, close
            
            int k = 0;      // offset used for i
            
            //int hit_indices[];   // indices of matched bars(i.e. 3-ups)
            int hit_indices[];   // indices of matched bars(i.e. 3-ups)
            
            //ref https://docs.mql4.com/array/arrayresize
            //ArrayResize(hit_indices, Bars);     // compile -> OK
            ArrayResize(hit_indices, numof_days * 24);     // compile -> OK
            
            int numof_hit_indices = 0;  // count up the matched bars
            
            int numof_ups = 3;
            
            //int max_depths = numof_ups;
            int max_depths = numof_ups;
            
            int current_depths = 0;
                     
            //for(int i=0; i < numof_target_bars ;i++)
            for(int i = 0; i < numof_target_bars - numof_ups ;i++)
           {
               
               // nested function
               //int ret = _seekPattern_3Ups__GetDiff(i, k, max_depths);
               int ret = _seekPattern_3Ups__GetDiff(i, k, max_depths, filehandle);
               
               if(ret == i)
                 {
                 
                     // add to the array
                     hit_indices[numof_hit_indices] = i;
                     
                     // increment the index
                     numof_hit_indices += 1;
                     
                     // increment i
                     i += (max_depths - 1);
                     
                     // next index value
                     continue;
                     
                 }
                else if(ret < 0)//if(ret == i)
                 {
                     // increment i by the return value(which is, the offset value k minus -1)
                     i += ret * (-1);
                     
                     // next index value
                     continue;
                     
                 }//if(ret == i)
                else    // neither of the above
                        // then, just continue the loop
                  {
                   
                   continue;
                   
                  }//if(ret == i)
               
            }//for(int i = 0; i < numof_target_bars - numof_ups ;i++)
            //FileWrite(filehandle,"numof_hit_indices => ",numof_hit_indices,"");
                 
         //+------------------------------------------------------------------+
         //| footer                                                                 |
         //+------------------------------------------------------------------+
         FileWrite(filehandle, 
                  "numof_hit_indices=",numof_hit_indices,"", 
                  "total bars=",numof_target_bars,"",
                  
                  "ratio=",numof_hit_indices*1.0/numof_target_bars,""
                  
                  );    // data
         
         
         //+------------------------------------------------------------------+
         //| write: hit data                                                                 |
         //+------------------------------------------------------------------+
         double a, b;
         
         for(i=0; i < numof_hit_indices; i++)
           {
               a = Close[hit_indices[i]];
               b = Open[hit_indices[i]];
               
               FileWrite(filehandle, 
                  
                  (i + 1), 
                  
                  hit_indices[i],
                  
                  TimeToStr(iTime(Symbol(), Period(), hit_indices[i])),
                  
                  a, b, (a - b)
                  
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

      


}//void seekPattern_3Falls3Ups__V2(int numof_days)

int _seekPattern_3Ups__GetDiff
(int i, int k, int depth, int filehandle) {

      double a,b, c;    // a => high, b => low
      
      a = Close[i + k];
      b = Open[i + k];

      c = a - b;     // diff

      if(c >= 0)     // white bar
        {
            
            //debug
            //ref https://www.mql5.com/en/forum/3239
            FileSeek(filehandle,0,SEEK_END);

            //+------------------------------------------------------------------+
            //| metadata                                                                  |
            //+------------------------------------------------------------------+
            FileWrite(filehandle, 
                        TimeToStr(iTime(Symbol(), Period(), i)), 
                        "i=",i,"",
                        "k=",k,"",
                        "a=",a,"",
                        "b=",b,"",
                        "c=",c,""
                        
                        );

            
            // inspect: k
            if((k + 1) > depth)  // i.e. the current bar is the last bar to be inspected
            //if( k > depth)
                                 // i.e. the current is the Xth bar in X-Ups detection work
              {
              
                  FileWrite(filehandle, 
                        
                        "(k + 1) > depth"
                        
                        );
                  
                  return i;
                  
              }//if((k + 1) > depth)
            else
              {
              
                  FileWrite(filehandle, 
                        
                        "(k + 1) <= depth"
                        
                        );
              
                  // offset k
                  k += 1;
                  
                  // call the function
                  //return _seekPattern_3Ups__GetDiff(i, k, depth);
                  return _seekPattern_3Ups__GetDiff(i, k, depth, filehandle);
                  
              }//if((k + 1) > depth)

         }//if(c >= 0)     // white bar
         
       else//if(c >= 0)     // white bar
         {
            
            FileWrite(filehandle, 
                        
                  "c >= 0"
            
            );
            // return the current offset value(modified)
            return k * (-1);
         
          
         }//if(c >= 0)     // white bar
         
}
