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
