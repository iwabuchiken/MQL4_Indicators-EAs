//+------------------------------------------------------------------+
//|                                                      utils.h.mqh |
//|                        Copyright 2016, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2016, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict
//+------------------------------------------------------------------+
//| defines                                                          |
//+------------------------------------------------------------------+
// #define MacrosHello   "Hello, world!"
// #define MacrosYear    2010
//+------------------------------------------------------------------+
//| DLL imports                                                      |
//+------------------------------------------------------------------+
// #import "user32.dll"
//   int      SendMessageA(int hWnd,int Msg,int wParam,int lParam);
// #import "my_expert.dll"
//   int      ExpertRecalculate(int wParam,int lParam);
// #import
//+------------------------------------------------------------------+
//| EX5 imports                                                      |
//+------------------------------------------------------------------+
// #import "stdlib.ex5"
//   string ErrorDescription(int error_code);
// #import
//+------------------------------------------------------------------+

//extern int NUMOF_TARGET_BARS;

string conv_DateTime_2_SerialTimeLabel(int time) {

      //string datetime_label = TimeToStr(time);
      string datetime_label = TimeToStr(time, TIME_DATE|TIME_SECONDS);
      
      //debug
      Alert("[",__LINE__,"] datetime_label => ",datetime_label,"");
      
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

/****************************

   @param target_datetime     => "2016.12.20 08:00"   (H1)
   @param period              => 60 --> H1
   
   @return
      -1    => no match
      >=0   => hit index
   
   @original
   dir: C:\Users\iwabuchiken\AppData\Roaming\MetaQuotes\Terminal\34B08C83A5AAE27A4079DE708E60511E\MQL4\Indicators\lab
   file: test_56-1_get-index-from-datetime.mq4
   time: 2017/01/09 13:08:40
*****************************/
//int get_index(string target_datetime, int period) {
int get_index(string target_datetime, int period, int NUMOF_TARGET_BARS) {

   int index = -1;

   string d;
   
   //debug
   int count = 0;
   
   int count_max = 20;
   
   //Alert("[",__LINE__,"] NUMOF_TARGET_BARS = ",NUMOF_TARGET_BARS,"");
   
   for(int i = 0; i < NUMOF_TARGET_BARS; i ++) {

      d = TimeToStr(iTime(Symbol(),Period(), i));
      
      //debug
//      Alert("[",__LINE__,"] i = ",i," / d = ",d,"");
      
      // judge
      if(d == target_datetime)
        {
            Alert("[",__LINE__,"] match => d = '",d,"' "
                  + "/ target_datetime = '",target_datetime,"'"
                  + " / "
                  + "index = ",i,""
                  
                  );
                  
            // break the for loop
            index = i;
            
            break;
            
        }
      else
        {
//            Alert("[",__LINE__,"] not match");
        }
   
   }//for(int i = 0; i < NUMOF_TARGET_BARS; i ++)

   return index;
   
}//get_index(string target_datetime, int period)

/****************************
   void get_BarData_Basic(int index, double &DATA[])
   
   @param index : int   => index in the array of tick data
   @param DATA : double[]  => empty array
   
   @return
      DATA  => [open, high, low, close]
   
*****************************/
//ref pass array : https://www.mql5.com/en/forum/150076
void get_BarData_Basic(int index, double &DATA[]) {
//void get_BarData_Basic(int index, string &DATA[]) {
//void get_BarData_Basic(int index, string DATA[]) {
//void get_BarData_Basic(int index, string* DATA) {

   ///string DATA[4];
   DATA[0] = Open[index];
   DATA[1] = High[index];
   DATA[2] = Low[index];
   DATA[3] = Close[index];
/*   
   DATA[0] = "yes";
   DATA[1] = "no";
   DATA[2] = "off cource";
   DATA[3] = "certainly";
  */ 
   //return DATA;

}//string[] get_BarData_Basic(int index)

/****************************
   void get_ArrayOf_BarData_Basic(...)
   
   @param index : int   => index in the array of tick data
   @param AryOf_BasicData : double[][4]  => empty array
   
   @processes
      AryOf_BasicData  => [[open, high, low, close],[open, high, low, close],...]
   
   @infos
      AryOf_BasicData   => resize the first dimension
      
   @meta infos
      written  : 2017/08/27 15:23:23
   
*****************************/
void get_ArrayOf_BarData_Basic
(int pastXBars, double &AryOf_BasicData[][4]) {

   // resize
   ArrayResize(AryOf_BasicData, pastXBars);
   
   //int i;
   
   double   aryOf_BasicData[4];
   
   Alert("[",__LINE__,"] get_ArrayOf_BarData_Basic() => starting...");
   
   Alert("[",__LINE__,"] pastXBars => ", pastXBars);
   
   for(int i = 0; i < pastXBars; i++)
     {
     
         get_BarData_Basic(i, aryOf_BasicData);
         
         // insert data
         AryOf_BasicData[i][0]  = aryOf_BasicData[0];
         AryOf_BasicData[i][1]  = aryOf_BasicData[1];
         AryOf_BasicData[i][2]  = aryOf_BasicData[2];
         AryOf_BasicData[i][3]  = aryOf_BasicData[3];
         
         Alert("[",__LINE__,"] loop : i = ", i, " ==> done");
         
     }

   Alert("[",__LINE__,"] for loop => done");

   //get_ArrayOf_BarData_Basic
}//void get_ArrayOf_BarData_Basic

/****************************
   int write2File_AryOf_BasicData
   
   @return
      -1 can't open file

*****************************/
int write2File_AryOf_BasicData
(string FNAME, string SUBFOLDER, double &AryOf_BasicData[][4], int lenOf_Array) {

   //+------------------------------------------------------------------+
   //| file: open
   //+------------------------------------------------------------------+
   int FILE_HANDLE = NULL;
   
   
   FILE_HANDLE =_file_open(FILE_HANDLE, FNAME, SUBFOLDER);
   //int result=_file_open(FILE_HANDLE, FNAME, SUBFOLDER);

   if(FILE_HANDLE == -1)
     {

      return -1;

     }

   /*********************
      write : header
   *********************/
   FileWrite(
      FILE_HANDLE,
      
      "no"
      , "Open"
      , "High"
      , "Low"
      , "Close"
      , "Diff"
      , "High/Low"
   
   );

   /*********************
      write : data
   *********************/
   for(int i=0; i < lenOf_Array; i++)
     {
         //AryOf_BasicData[i];
         //AryOf_BasicData[i][0];
         FileWrite(FILE_HANDLE,

          (i+1),

          AryOf_BasicData[i][0]     // Open
          , AryOf_BasicData[i][1]   // High
          , AryOf_BasicData[i][2]   // Low
          , AryOf_BasicData[i][3]   // Close
          , AryOf_BasicData[i][3] - AryOf_BasicData[i][0]   // Diff
          , AryOf_BasicData[i][1] - AryOf_BasicData[i][2]   // Range
          );
     }

   /*********************
      file : close
   *********************/
   _file_close(FILE_HANDLE);

   /*********************
      return
   *********************/
   return 1;

}//write2File_AryOf_BasicData(FNAME, AryOf_BasicData)

/****************************
   _file_open()
   
   @return
      1  file opened
      -1 can't open file

*****************************/
int _file_open(int FILE_HANDLE, string FNAME, string SUBFOLDER) 
  {

   FILE_HANDLE = FileOpen("Research\\" + SUBFOLDER + "\\"+FNAME,FILE_WRITE|FILE_CSV);

   if(FILE_HANDLE==INVALID_HANDLE) 
     {

      Alert("[",__LINE__,"] can't open file: ",FNAME,"");

      // return
      return -1;

     }//if(FILE_HANDLE == INVALID_HANDLE)

   //+------------------------------------------------------------------+
   //| File: seek
   //+------------------------------------------------------------------+
   //ref https://www.mql5.com/en/forum/3239
   FileSeek(FILE_HANDLE,0,SEEK_END);

   return FILE_HANDLE;

  }//_file_open()

void _file_close(int FILE_HANDLE) 
  {

   FileClose(FILE_HANDLE);

   Alert("[",__LINE__,"] file => closed : ", (string) FILE_HANDLE);

  }//_file_close()
