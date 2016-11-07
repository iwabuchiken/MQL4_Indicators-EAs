//--------------------------------------------------------------------
// callindicator.mq4
// The code should be used for educational purpose only.
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
     
         //saveData_Highs_2();     // execute
//         saveData_Highs_3();     // execute
         
         //saveData_BBValue();     // exec: BB vand value
         int numof_days = 30;
         
         saveData_BBValue_ForDays(numof_days);   // exec: BB +2s values

//         conv_DateTime_2_SerialTimeLabel(TimeCurrent());
         
         Fact_Up = false;        // no more executions
         
         
     }

//--------------------------------------------------------------------
   return;                            // Exit start()
}//int start()
//--------------------------------------------------------------------

void saveData_Highs_2() {

      Alert("saveData_Highs_2()");

      //steps.3
      //ref https://docs.mql4.com/files/fileopen
      string terminal_data_path = TerminalInfoString(TERMINAL_DATA_PATH);
      
   //--- another example with the creation of an enclosed directory in MQL4\Files\
      string subfolder = "Research";
      
      string fname = "dat.txt";
      
      //int filehandle = FileOpen(subfolder+"\\fractals.txt",FILE_READ|FILE_WRITE|FILE_TXT);
      int filehandle = FileOpen(subfolder + "\\" + fname, FILE_READ|FILE_WRITE|FILE_TXT);
      
      if(filehandle!=INVALID_HANDLE)
        {
            //ref https://www.mql5.com/en/forum/3239
            FileSeek(filehandle,0,SEEK_END);
        
         //FileWrite(filehandle,TimeCurrent(),Symbol(), EnumToString(ENUM_TIMEFRAMES(_Period)));
         //FileWrite(filehandle,TimeCurrent(),Symbol(), EnumToString(ENUM_TIMEFRAMES(_Period)));
         
         datetime d = TimeCurrent();      // current time
         
         FileWrite(filehandle,
               //"",TimeCurrent(),":",Symbol(),":",EnumToString(ENUM_TIMEFRAMES(_Period)),"");
               //"",TimeCurrent(),"" +
               //";",TimeToStr(TimeCurrent(),TIME_SECONDS),"" +
               //";",conv_Seconds_2_TimeLabel(TimeCurrent()),"" +
               "[test_indicator_callindicator.mq4]\n" +
               "",d,"" +
               ";",TimeToStr(d,TIME_DATE)," ",TimeToStr(d,TIME_SECONDS),"" +
               ";",conv_Seconds_2_TimeLabel(d),"" +
               
               ";",Symbol(),":",EnumToString(ENUM_TIMEFRAMES(_Period)),"");
         
         //show filehandle
         Alert("filehandle => '",filehandle,"'");
         
         FileClose(filehandle);
         Print("The file most be created in the folder "+terminal_data_path+"\\"+subfolder);
         
        }
      else {
      
         Print("File open failed, error ",GetLastError());
         
         //alert
         Alert("File open failed, error");
         
      }

}//saveData_Highs_2

string conv_Seconds_2_TimeLabel(int seconds) {

   //int seconds_final = seconds - (minutes * 60);   // seconds, final ---> 2 digits
   int seconds_final = seconds % 60;   // seconds, final ---> 2 digits
   
   int minutes = seconds / 60;            // minutes, total
   
   int minutes_final = minutes % 60;      // minutes, final ---> 2 digits
   
   int hours = minutes / 60;
   
   int hours_final = hours % 24;
   
   int days = hours / 24;
   
   //string time_label = minutes_final + ":" + seconds_final;
   string time_label = days + " " + hours_final + ":" + minutes_final + ":" + seconds_final; // build label
   
   return time_label;

}//conv_Seconds_2_TimeLabel(int seconds)

void saveData_Highs_3() {

      Alert("saveData_Highs_3()");

      //steps.4
      //ref https://docs.mql4.com/files/fileopen
      string terminal_data_path = TerminalInfoString(TERMINAL_DATA_PATH);
      
   //--- another example with the creation of an enclosed directory in MQL4\Files\
      string subfolder = "Research", fname = "dat.txt";
      
      int filehandle = FileOpen(subfolder + "\\" + fname, FILE_READ|FILE_WRITE|FILE_TXT);
      
      if(filehandle!=INVALID_HANDLE)
        {
            
            int numOf_Highs = 3;
            
            for(int i = 0; i < numOf_Highs; i++)
              {

                  //ref https://www.mql5.com/en/forum/3239
                  FileSeek(filehandle,0,SEEK_END);
                 
                  datetime d = TimeCurrent();      // current time
                  
                  FileWrite(filehandle,
                 
                        "[test_indicator_callindicator.mq4]\n" +
                        
                        ";",TimeToStr(d,TIME_DATE)," ",TimeToStr(d,TIME_SECONDS),"" +
                        
                        ";",Symbol(),":",EnumToString(ENUM_TIMEFRAMES(_Period)),"" +
                        " / High[",i,"] = ",High[i],""
                        ) ;
               
              }
            
         
         //show filehandle
         Alert("filehandle => '",filehandle,"'");
         
         FileClose(filehandle);
         Print("The file most be created in the folder "+terminal_data_path+"\\"+subfolder);
         
        }
      else {
      
         Print("File open failed, error ",GetLastError());
         
         //alert
         Alert("File open failed, error");
         
      }

}//saveData_Highs_3

void saveData_BBValue() {

      Alert("saveData_Highs_3()");

      //steps.4
      //ref https://docs.mql4.com/files/fileopen
      string terminal_data_path = TerminalInfoString(TERMINAL_DATA_PATH);
      
   //--- another example with the creation of an enclosed directory in MQL4\Files\
      string subfolder = "Research", fname = "dat.txt";
      
      int filehandle = FileOpen(subfolder + "\\" + fname, FILE_READ|FILE_WRITE|FILE_TXT);
      
      if(filehandle!=INVALID_HANDLE)
        {
            
            int numOf_Highs = 3;
            
            for(int i = 0; i < numOf_Highs; i++)
              {

                  //ref https://www.mql5.com/en/forum/3239
                  FileSeek(filehandle,0,SEEK_END);
                 
                  datetime d = TimeCurrent();      // current time
                  
                  FileWrite(filehandle,
                 
                        "[test_indicator_callindicator.mq4]\n" +
                        
                        ";",TimeToStr(d,TIME_DATE)," ",TimeToStr(d,TIME_SECONDS),"" +
                        
                        ";",Symbol(),":",EnumToString(ENUM_TIMEFRAMES(_Period)),"" +
                        //" / BB[",i,"] = ",iBands(Symbol(),0,20,2,0,PRICE_LOW,MODE_LOWER,i),""
                        //" / BB[",i,"] = ",iBands(Symbol(),0,20,2,0,PRICE_CLOSE,MODE_UPPER,0),""
                        " / BB[",i,"] = ",iBands(Symbol(),0,20,2,0,PRICE_CLOSE,MODE_UPPER,i),""
                        ) ;
               
              }
            
         
         //show filehandle
         Alert("filehandle => '",filehandle,"'");
         
         FileClose(filehandle);
         Print("The file most be created in the folder "+terminal_data_path+"\\"+subfolder);
         
        }
      else {
      
         Print("File open failed, error ",GetLastError());
         
         //alert
         Alert("File open failed, error");
         
      }

}//saveData_BBValue

void saveData_BBValue_ForDays(int numof_days) {

      Alert("saveData_BBValue_ForDays()");

      //+------------------------------------------------------------------+
      //| setup                                                                 |
      //+------------------------------------------------------------------+
      //steps.8
      //ref https://docs.mql4.com/files/fileopen
      string terminal_data_path = TerminalInfoString(TERMINAL_DATA_PATH);
      
      //string subfolder = "Research", fname = "dat.txt";
      string subfolder = "Research";
      
      //string fname = "bb_values.csv";
      string fname = "bb_values" 
                  //+ "_" 
                  + "." 
                  + conv_DateTime_2_SerialTimeLabel(TimeCurrent()) 
                  + ".csv";
      
      //int filehandle = FileOpen(subfolder + "\\" + fname, FILE_READ|FILE_WRITE|FILE_TXT);
      //int filehandle = FileOpen(subfolder + "\\" + fname, FILE_READ|FILE_WRITE|FILE_CSV);
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
            //| header                                                                 |
            //+------------------------------------------------------------------+
            FileWrite(filehandle, TimeToStr(d), Symbol());
            FileWrite(filehandle,"no.","time", "close","BB +2s");
                 
            
                 
            for(int i = 0; i < numOf_Highs; i++)
              {
                  //+------------------------------------------------------------------+
                  //| check: saturdays(6, -5), sundays(0), mondays(1, 6-)                                                                 |
                  //+------------------------------------------------------------------+
                  if(TimeDayOfWeek(d - (60 * 60 * i)) == 0 || TimeDayOfWeek(d - (60 * 60 * i)) == 6)
                    {
                        continue;
                    }
                  
                  FileWrite(filehandle,
                 
                           (i + 1),
                           
                           TimeToStr(d - (60 * 60 * i)),
                           
                           //High[i],
                           Close[i],
                           
                           iBands(Symbol(),0,20,2,0,PRICE_CLOSE,MODE_UPPER,i)
                        
                        ) ;
               
              }
            
         
         //show filehandle
         Alert("filehandle => '",filehandle,"'");
         
         FileClose(filehandle);
         Print("The file most be created in the folder "+terminal_data_path+"\\"+subfolder);
         
        }
      else {
      
         Print("File open failed, error ",GetLastError());
         
         //alert
         Alert("File open failed, error");
         
      }

}//saveData_BBValue

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
