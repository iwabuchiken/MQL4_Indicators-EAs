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
//   saveData_Highs();
   saveData_Highs_2();
   
//   show_Alert_3();

/*

//   if (Bid > MA)   // Checking if price above
   if (Bid > MA && Fact_Up == true)   // Checking if price above
     {
      Fact_Dn = true;                 // Report about price above MA
      Fact_Up = false;                // Don't report about price below MA

      // show alert
      //show_Alert();
      show_Alert_2();
      
      
      
     }
//--------------------------------------------------------------------
//   if (Bid < MA)   // Checking if price below
   if (Bid < MA && Fact_Dn == true)   // Checking if price below
     {
      Fact_Up = true;                 // Report about price below MA
      Fact_Dn = false;                // Don't report about price above MA
      Alert("Price is below MA(",Period_MA,").");// Alert 
      
      //test
      show_Alert_2();
      
      
     }
     
*/     
//--------------------------------------------------------------------
   return;                            // Exit start()
  }
//--------------------------------------------------------------------

int get_IndicatorCounted() {

   // get count
   int count = IndicatorCounted();
   
   return count;

}//get_IndicatorCounted

void show_Alert() {

      Alert("Price is above MA!!!(",Period_MA,").");// Alert 
      //Alert("Bid is now... ==> (",Bid,").");// Alert 
      
      
      int count = get_IndicatorCounted();
      //string commment = "Bid is now...?? ==> (",Bid," / Period_MA=",Period_MA," \n/ bars=",count," / Bars=",Bars,").";
      //string commment = "Bid is now...?? ==>  (",Bid," / ";
      
      
      int Counted_bars=IndicatorCounted(); // Number of counted bars
      int i = Bars-Counted_bars-1;
      
      //ref multiple string lines / https://forum.mql4.com/46640
      //Alert(commment);
      Alert("Bid is now... ==> (",Bid," / Period_MA=",Period_MA," " + 
            "\n/ bars=",count," " + 
            "/ Bars=",Bars," / High=",High[i],"" + 
            " ).");// Alert 


}//show_Alert()

void show_Alert_2() {

      Alert("show_Alert_2()");

      //Alert("TerminalInfoString(TERMINAL_DATA_PATH)... \n " +
        //     "==> (",TerminalInfoString(TERMINAL_DATA_PATH),").");// Alert 
             
      // C:\Users\iwabuchiken\AppData\Roaming\MetaQuotes\Terminal\34B08C83A5AAE27A4079DE708E60511E

      //steps.2
      //ref https://docs.mql4.com/files/fileopen
      string terminal_data_path=TerminalInfoString(TERMINAL_DATA_PATH);
      string filename=terminal_data_path+"\\MQL4\\Files\\"+"fractals.csv";
      
      int filehandle=FileOpen(filename,FILE_WRITE|FILE_CSV);
      
      if(filehandle<0)
        {
         Print("Failed to open the file by the absolute path ");
         Print("Error code ",GetLastError());
        }
      else {
      
         Print("file => opened");
      
      }
      
   //--- correct way of working in the "file sandbox"
      ResetLastError();
      filehandle=FileOpen("fractals.csv",FILE_WRITE|FILE_CSV);
      if(filehandle!=INVALID_HANDLE)
        {
         FileWrite(filehandle,TimeCurrent(),Symbol(), EnumToString(ENUM_TIMEFRAMES(_Period)));
         FileClose(filehandle);
         Print("FileOpen OK");
        }
      else Print("Operation FileOpen failed, error ",GetLastError());
   //--- another example with the creation of an enclosed directory in MQL4\Files\
      string subfolder="Research";
      filehandle=FileOpen(subfolder+"\\fractals.txt",FILE_WRITE|FILE_CSV);
         if(filehandle!=INVALID_HANDLE)
        {
         //FileWrite(filehandle,TimeCurrent(),Symbol(), EnumToString(ENUM_TIMEFRAMES(_Period)));
         FileWrite(filehandle,TimeCurrent(),Symbol(), EnumToString(ENUM_TIMEFRAMES(_Period)));
         
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

}//show_Alert()

void show_Alert_3() {

      Alert("show_Alert_3()");

      //steps.3
      //ref https://docs.mql4.com/files/fileopen
      string terminal_data_path=TerminalInfoString(TERMINAL_DATA_PATH);
      string filename=terminal_data_path+"\\MQL4\\Files\\"+"fractals.csv";
      
      //int filehandle=FileOpen(filename,FILE_WRITE|FILE_CSV);
      int filehandle=FileOpen(filename,FILE_WRITE|FILE_CSV);
      
      if(filehandle<0)
        {
         Print("Failed to open the file by the absolute path ");
         Print("Error code ",GetLastError());
        }
      else {
      
         Print("file => opened");
      
      }
      
   //--- correct way of working in the "file sandbox"
      ResetLastError();
      filehandle=FileOpen("fractals.csv",FILE_WRITE|FILE_CSV);
      if(filehandle!=INVALID_HANDLE)
        {
         FileWrite(filehandle,TimeCurrent(),Symbol(), EnumToString(ENUM_TIMEFRAMES(_Period)));
         FileClose(filehandle);
         Print("FileOpen OK");
        }
      else Print("Operation FileOpen failed, error ",GetLastError());

   //--- another example with the creation of an enclosed directory in MQL4\Files\
      string subfolder="Research";
      
      //filehandle=FileOpen(subfolder+"\\fractals.txt",FILE_WRITE|FILE_CSV);
      //filehandle=FileOpen(subfolder+"\\fractals.txt",FILE_READ|FILE_WRITE|FILE_CSV);
      filehandle=FileOpen(subfolder+"\\fractals.txt",FILE_READ|FILE_WRITE|FILE_TXT);
      
         if(filehandle!=INVALID_HANDLE)
        {
            //ref https://www.mql5.com/en/forum/3239
            FileSeek(filehandle,0,SEEK_END);
        
         //FileWrite(filehandle,TimeCurrent(),Symbol(), EnumToString(ENUM_TIMEFRAMES(_Period)));
         FileWrite(filehandle,TimeCurrent(),Symbol(), EnumToString(ENUM_TIMEFRAMES(_Period)));
         
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

}//show_Alert_3()

void saveData_Highs() {

      //+------------------------------------------------------------------+
      //| setup                                                                 |
      //+------------------------------------------------------------------+
      //ref https://docs.mql4.com/files/fileopen
      string terminal_data_path = TerminalInfoString(TERMINAL_DATA_PATH);
      
      string fname = "highs.txt";
      
      string filepath = terminal_data_path + "\\MQL4\\Files\\" + fname;

      //+------------------------------------------------------------------+
      //| validate: file exists                                                                 |
      //+------------------------------------------------------------------+
      int filehandle;
      
      if(FileIsExist(filepath) != true)
        {
        
            //alert
            Alert("file NOT exists => ",filepath,"");
        
            //filehandle = FileOpen(filepath, FILE_WRITE|FILE_TXT);
            filehandle = FileOpen(filepath, FILE_WRITE|FILE_CSV);
            
        }
      else
        {
            
            filehandle = FileOpen(filepath, FILE_WRITE|FILE_READ|FILE_TXT);
            
        }

      //+------------------------------------------------------------------+
      //| file open                                                                 |
      //+------------------------------------------------------------------+
      //int filehandle = FileOpen(filepath, FILE_READ|FILE_WRITE|FILE_TXT);
      //int filehandle = FileOpen(filepath, FILE_WRITE|FILE_READ|FILE_TXT);

      if(filehandle == INVALID_HANDLE) {
      
         //alert
         Alert("Invalid file handle => ",fname,"");
         
         return;
      
      }
      
      // seek end
      //ref https://www.mql5.com/en/forum/3239
      FileSeek(filehandle,0,SEEK_END);

      //+------------------------------------------------------------------+
      //| file: write                                                                 |
      //+------------------------------------------------------------------+
      FileWrite(filehandle,
            "[",TimeCurrent(),":",Symbol(),":",EnumToString(ENUM_TIMEFRAMES(_Period)),"" +
            "Highs ]" );

      //+------------------------------------------------------------------+
      //| file: close                                                                 |
      //+------------------------------------------------------------------+
      FileClose(filehandle);
      
      //+------------------------------------------------------------------+
      //| report                                                                 |
      //+------------------------------------------------------------------+
      //alert
       Alert("file written => ",fname,"");

}//saveData_Highs()

void saveData_Highs_2() {

      Alert("saveData_Highs_2()");

      //steps.3
      //ref https://docs.mql4.com/files/fileopen
      string terminal_data_path=TerminalInfoString(TERMINAL_DATA_PATH);
      string filename=terminal_data_path+"\\MQL4\\Files\\"+"fractals.csv";
      
      //int filehandle=FileOpen(filename,FILE_WRITE|FILE_CSV);
      int filehandle=FileOpen(filename,FILE_WRITE|FILE_CSV);
      
      if(filehandle<0)
        {
         Print("Failed to open the file by the absolute path ");
         Print("Error code ",GetLastError());
        }
      else {
      
         Print("file => opened");
      
      }
      
   //--- correct way of working in the "file sandbox"
      ResetLastError();
      filehandle=FileOpen("fractals.csv",FILE_WRITE|FILE_CSV);
      if(filehandle!=INVALID_HANDLE)
        {
         FileWrite(filehandle,TimeCurrent(),Symbol(), EnumToString(ENUM_TIMEFRAMES(_Period)));
         FileClose(filehandle);
         Print("FileOpen OK");
        }
      else Print("Operation FileOpen failed, error ",GetLastError());

   //--- another example with the creation of an enclosed directory in MQL4\Files\
      string subfolder="Research";
      
      //filehandle=FileOpen(subfolder+"\\fractals.txt",FILE_WRITE|FILE_CSV);
      //filehandle=FileOpen(subfolder+"\\fractals.txt",FILE_READ|FILE_WRITE|FILE_CSV);
      filehandle=FileOpen(subfolder+"\\fractals.txt",FILE_READ|FILE_WRITE|FILE_TXT);
      
         if(filehandle!=INVALID_HANDLE)
        {
            //ref https://www.mql5.com/en/forum/3239
            FileSeek(filehandle,0,SEEK_END);
        
         //FileWrite(filehandle,TimeCurrent(),Symbol(), EnumToString(ENUM_TIMEFRAMES(_Period)));
         FileWrite(filehandle,TimeCurrent(),Symbol(), EnumToString(ENUM_TIMEFRAMES(_Period)));
         
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
