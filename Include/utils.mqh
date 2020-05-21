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

//extern string dpath_Log;

string conv_DateTime_2_SerialTimeLabel(int time) {

      //string datetime_label = TimeToStr(time);
      string datetime_label = TimeToStr(time, TIME_DATE|TIME_SECONDS);
      
      //debug
//      Alert("[",__LINE__,"] datetime_label => ",datetime_label,"");
      
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
int get_index
(string target_datetime, int period, int _NUMOF_TARGET_BARS) {

   int index = -1;

   string d;
   
   //debug
   int count = 0;
   
   int count_max = 20;
   
   //Alert("[",__LINE__,"] NUMOF_TARGET_BARS = ",NUMOF_TARGET_BARS,"");
   
   for(int i = 0; i < _NUMOF_TARGET_BARS; i ++) {

      d = TimeToStr(iTime(Symbol(),Period(), i));
      
      //debug
//      Alert("[",__LINE__,"] i = ",i," / d = ",d,"");
      
      // judge
      if(d == target_datetime)
        {
            Print("[",__LINE__,"] match => d = '",d,"' "
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
   
//   Alert("[",__LINE__,"] get_ArrayOf_BarData_Basic() => starting...");
   
//   Alert("[",__LINE__,"] pastXBars => ", pastXBars);
   
   for(int i = 0; i < pastXBars; i++)
     {
     
         get_BarData_Basic(i, aryOf_BasicData);
         
         // insert data
         AryOf_BasicData[i][0]  = aryOf_BasicData[0];
         AryOf_BasicData[i][1]  = aryOf_BasicData[1];
         AryOf_BasicData[i][2]  = aryOf_BasicData[2];
         AryOf_BasicData[i][3]  = aryOf_BasicData[3];
         
         //Alert("[",__LINE__,"] loop : i = ", i, " ==> done");
         
     }

//   Alert("[",__LINE__,"] for loop => done");

   //get_ArrayOf_BarData_Basic
}//void get_ArrayOf_BarData_Basic

/****************************
   void get_ArrayOf_BarData_Basic(...)
   
   @param index : int   => index in the array of tick data
   @param AryOf_BasicData : double[][4]  => empty array
   @param symbol_Str : currency pair string  => e.g. "USDJPY"
   @param period : bar period  => e.g. "PERIOD_H1"
   
   @processes
      AryOf_BasicData  => [[open, high, low, close],[open, high, low, close],...]
   
   @infos
      AryOf_BasicData   => resize the first dimension
      
   @meta infos
      written  : 2017/08/27 15:23:23
   
*****************************/
void get_ArrayOf_BarData_Basic_2
(int pastXBars, double &AryOf_BasicData[][4], string symbol_Str, int period) {

   /****************
      set : symbol
   *****************/
   set_Symbol(symbol_Str, period);

   /****************
      get : basic data
   *****************/
   // resize
   ArrayResize(AryOf_BasicData, pastXBars);
   
   //int i;
   
   double   aryOf_BasicData[4];
   
//   Alert("[",__LINE__,"] get_ArrayOf_BarData_Basic() => starting...");
   
//   Alert("[",__LINE__,"] pastXBars => ", pastXBars);
   
   for(int i = 0; i < pastXBars; i++)
     {
     
         get_BarData_Basic(i, aryOf_BasicData);
         
         // insert data
         AryOf_BasicData[i][0]  = aryOf_BasicData[0];
         AryOf_BasicData[i][1]  = aryOf_BasicData[1];
         AryOf_BasicData[i][2]  = aryOf_BasicData[2];
         AryOf_BasicData[i][3]  = aryOf_BasicData[3];
         
         //Alert("[",__LINE__,"] loop : i = ", i, " ==> done");
         
     }//for(int i = 0; i < pastXBars; i++)

}//void get_ArrayOf_BarData_Basic(int pastXBars, double &AryOf_BasicData[][4], string symbol_Str)

/****************************
   int write2File_AryOf_BasicData
   
   @return
      -1 can't open file

*****************************/
int write2File_AryOf_BasicData
(string _FNAME, string _SUBFOLDER, double &_AryOf_BasicData[][4], int _lenOf_Array) {

   //+------------------------------------------------------------------+
   //| file: open
   //+------------------------------------------------------------------+
   int _FILE_HANDLE = NULL;
   
   
   _FILE_HANDLE =_file_open(_FILE_HANDLE, _FNAME, _SUBFOLDER);
   //int result=_file_open(FILE_HANDLE, FNAME, SUBFOLDER);

   if(_FILE_HANDLE == -1)
     {

      return -1;

     }

   /*********************
      write : header
   *********************/
   _file_write__header(_FILE_HANDLE);
   
   /*
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
*/
   /*********************
      write : data
   *********************/
   for(int i=0; i < _lenOf_Array; i++)
     {
         //AryOf_BasicData[i];
         //AryOf_BasicData[i][0];
         FileWrite(_FILE_HANDLE,

          (i+1),

          _AryOf_BasicData[i][0]     // Open
          , _AryOf_BasicData[i][1]   // High
          , _AryOf_BasicData[i][2]   // Low
          , _AryOf_BasicData[i][3]   // Close
          , _AryOf_BasicData[i][3] - _AryOf_BasicData[i][0]   // Diff
          , _AryOf_BasicData[i][1] - _AryOf_BasicData[i][2]   // Range
          );
     }

   /*********************
      file : close
   *********************/
   _file_close(_FILE_HANDLE);

   /*********************
      return
   *********************/
   return 1;

}//write2File_AryOf_BasicData(FNAME, AryOf_BasicData)

/****************************
   int write2File_AryOf_BasicData
   
   @return
      -1 can't open file

*****************************/
int write2File_AryOf_BasicData_2
(string _FNAME, string _SUBFOLDER, double &_AryOf_BasicData[][4], int _lenOf_Array,
         string _SYMBOL_STR, string _CURRENT_PERIOD, 
         int _NUMOF_DAYS, int _NUMOF_TARGET_BARS, 
         string _TIME_LABEL
         	
         , int _TIME_FRAME
) {

   //+------------------------------------------------------------------+
   //| file: open
   //+------------------------------------------------------------------+
   int _FILE_HANDLE = NULL;
   
   
   _FILE_HANDLE =_file_open(_FILE_HANDLE, _FNAME, _SUBFOLDER);
   //int result=_file_open(FILE_HANDLE, FNAME, SUBFOLDER);

   if(_FILE_HANDLE == -1)
     {

      return -1;

     }

   /*********************
      write : header
   *********************/
   _file_write__header_2(_FILE_HANDLE, 
         _SYMBOL_STR, _CURRENT_PERIOD, 
         _NUMOF_DAYS, _NUMOF_TARGET_BARS, 
         _TIME_LABEL);
   
   /*********************
      write : data
   *********************/
   for(int i=0; i < _lenOf_Array; i++)
     {
         //AryOf_BasicData[i];
         //AryOf_BasicData[i][0];
         FileWrite(_FILE_HANDLE,

          (i+1),

          _AryOf_BasicData[i][0]     // Open
          , _AryOf_BasicData[i][1]   // High
          , _AryOf_BasicData[i][2]   // Low
          , _AryOf_BasicData[i][3]   // Close
          , _AryOf_BasicData[i][3] - _AryOf_BasicData[i][0]   // Diff
          , _AryOf_BasicData[i][1] - _AryOf_BasicData[i][2]   // Range
          
          , TimeToStr(iTime(Symbol(), _TIME_FRAME, i))
          
          );
     }

   /*********************
      file : close
   *********************/
   _file_close(_FILE_HANDLE);

   /*********************
      return
   *********************/
   return 1;

}//write2File_AryOf_BasicData(FNAME, AryOf_BasicData)

/****************************
   int write2File_AryOf_BasicData_With_RSI
   
   @return
      -1 can't open file

*****************************/
int write2File_AryOf_BasicData_With_RSI(
   string _FNAME, string _SUBFOLDER, 

   double &_AryOf_BasicData[][4], 

   int _lenOf_Array, int shift,
   
   string _SYMBOL_STR, string _CURRENT_PERIOD, 
   
   int _NUMOF_DAYS, int _NUMOF_TARGET_BARS, 
   
   string _TIME_LABEL, int _TIME_FRAME
   
) {

   //+------------------------------------------------------------------+
   //| file: open
   //+------------------------------------------------------------------+
   int _FILE_HANDLE = NULL;
   
   
   _FILE_HANDLE =_file_open(_FILE_HANDLE, _FNAME, _SUBFOLDER);
   //int result=_file_open(FILE_HANDLE, FNAME, SUBFOLDER);

   if(_FILE_HANDLE == -1)
     {

      return -1;

     }

   /*********************
      write : header
   *********************/
   _file_write__header_With_RSI(_FILE_HANDLE, 
         _SYMBOL_STR, _CURRENT_PERIOD, 
         _NUMOF_DAYS, _NUMOF_TARGET_BARS, 
         _TIME_LABEL, shift);

   /*********************
      write : data
   *********************/
   for(int i=0; i < _lenOf_Array; i++)
     {
         //AryOf_BasicData[i];
         //AryOf_BasicData[i][0];
         FileWrite(_FILE_HANDLE,

          (i+1),

          _AryOf_BasicData[i][0]     // Open
          , _AryOf_BasicData[i][1]   // High
          , _AryOf_BasicData[i][2]   // Low
          , _AryOf_BasicData[i][3]   // Close
          
          , _AryOf_BasicData[i][4]   // RSI
          
          , _AryOf_BasicData[i][3] - _AryOf_BasicData[i][0]   // Diff
          , _AryOf_BasicData[i][1] - _AryOf_BasicData[i][2]   // Range
          
          , TimeToStr(iTime(Symbol(), _TIME_FRAME, i))
          
          );
     }

   /*********************
      file : close
   *********************/
   _file_close(_FILE_HANDLE);

   /*********************
      return
   *********************/
   return 1;

}//write2File_AryOf_BasicData(FNAME, AryOf_BasicData)

/****************************
   int write2File_AryOf_BasicData_With_RSI
   
   @return
      -1 can't open file

*****************************/
int write2File_AryOf_BasicData_With_RSI_BB(
   string _FNAME, string _SUBFOLDER, 

   //double &_AryOf_BasicData[][4], 
   double &_AryOf_BasicData[][10], 

   int _lenOf_Array, int shift,
   
   string _SYMBOL_STR, string _CURRENT_PERIOD, 
   
   int _NUMOF_DAYS, int _NUMOF_TARGET_BARS, 
   
   string _TIME_LABEL, int _TIME_FRAME
   
) {

   //+------------------------------------------------------------------+
   //| file: open
   //+------------------------------------------------------------------+
   int _FILE_HANDLE = NULL;
   
   
   _FILE_HANDLE =_file_open(_FILE_HANDLE, _FNAME, _SUBFOLDER);
   //int result=_file_open(FILE_HANDLE, FNAME, SUBFOLDER);

   if(_FILE_HANDLE == -1)
     {

      return -1;

     }

   /*********************
      write : header
   *********************/
   _file_write__header_With_RSI_BB(_FILE_HANDLE, 
         _SYMBOL_STR, _CURRENT_PERIOD, 
         _NUMOF_DAYS, _NUMOF_TARGET_BARS, 
         _TIME_LABEL, shift);

   /*********************
      write : data
   *********************/
   for(int i=0; i < _lenOf_Array; i++)
     {
         //AryOf_BasicData[i];
         //AryOf_BasicData[i][0];
         FileWrite(_FILE_HANDLE,

          (i+1),

          _AryOf_BasicData[i][0]     // Open
          , _AryOf_BasicData[i][1]   // High
          , _AryOf_BasicData[i][2]   // Low
          , _AryOf_BasicData[i][3]   // Close
          
          , _AryOf_BasicData[i][4]   // RSI
          
          , _AryOf_BasicData[i][5]   // BB 2s
          , _AryOf_BasicData[i][6]   // BB 1s
          
          , _AryOf_BasicData[i][7]   // BB main
          , _AryOf_BasicData[i][8]   // BB -1s
          , _AryOf_BasicData[i][9]   // BB -2s
          
          , _AryOf_BasicData[i][3] - _AryOf_BasicData[i][0]   // Diff
          , _AryOf_BasicData[i][1] - _AryOf_BasicData[i][2]   // Range
          
          , TimeToStr(iTime(Symbol(), _TIME_FRAME, i))
          
          //test
          , TimeToStr(iTime(Symbol(), _TIME_FRAME, i) + (7 * 60 * 60))
          
          );
     }

   /*********************
      file : close
   *********************/
   _file_close(_FILE_HANDLE);

   /*********************
      return
   *********************/
   return 1;

}//write2File_AryOf_BasicData_With_RSI_BB

/****************************
   int write2File_AryOf_BasicData_With_RSI
   
   @return
      -1 can't open file

*****************************/
int write2File_AryOf_BasicData_With_RSI_BB_MFI(
   string _FNAME, string _SUBFOLDER, 

   //double &_AryOf_BasicData[][4], 
   double &_AryOf_BasicData[][11], 

   int _lenOf_Array, int shift,
   
   string _SYMBOL_STR, string _CURRENT_PERIOD, 
   
   int _NUMOF_DAYS, int _NUMOF_TARGET_BARS, 
   
   string _TIME_LABEL, int _TIME_FRAME
   
) {

   //+------------------------------------------------------------------+
   //| file: open
   //+------------------------------------------------------------------+
   int _FILE_HANDLE = NULL;
   
   
   _FILE_HANDLE =_file_open(_FILE_HANDLE, _FNAME, _SUBFOLDER);
   //int result=_file_open(FILE_HANDLE, FNAME, SUBFOLDER);

   if(_FILE_HANDLE == -1)
     {

      return -1;

     }

   /*********************
      write : header
   *********************/
   //_20200521_151117:tmp
   _file_write__header_With_RSI_BB_MFI(_FILE_HANDLE, 
         _SYMBOL_STR, _CURRENT_PERIOD, 
         _NUMOF_DAYS, _NUMOF_TARGET_BARS, 
         _TIME_LABEL, shift);

   /*********************
      write : data
      
         // input
         AryOf_Data[i][0] = Open[i];
         AryOf_Data[i][1] = High[i];
         AryOf_Data[i][2] = Low[i];
         AryOf_Data[i][3] = Close[i];

         AryOf_Data[i][4] = rsi;
         
         AryOf_Data[i][5] = ibands_2S_Plus;
         AryOf_Data[i][6] = ibands_1S_Plus;
         
         AryOf_Data[i][7] = ibands_Main;
         
         AryOf_Data[i][8] = ibands_1S_Minus;
         AryOf_Data[i][9] = ibands_2S_Minus;
         
         AryOf_Data[i][10] = mfi;

   *********************/
   //_20200521_151335:tmp
   for(int i=0; i < _lenOf_Array; i++)
     {
         //AryOf_BasicData[i];
         //AryOf_BasicData[i][0];
         FileWrite(_FILE_HANDLE,

          (i+1),

          //_AryOf_BasicData[i][0]     // Open
          NormalizeDouble((double)_AryOf_BasicData[i][0],3)     // Open
          //, _AryOf_BasicData[i][1]   // High
          //, _AryOf_BasicData[i][2]   // Low
          //, _AryOf_BasicData[i][3]   // Close
          , NormalizeDouble((double)_AryOf_BasicData[i][1],3)   // High
          , NormalizeDouble((double)_AryOf_BasicData[i][2],3)   // Low
          , NormalizeDouble((double)_AryOf_BasicData[i][3],3)   // Close
          
          //, _AryOf_BasicData[i][4]   // RSI
          , NormalizeDouble((double)_AryOf_BasicData[i][4],5)   // RSI
          
          //, _AryOf_BasicData[i][10]   // MFI
          , NormalizeDouble((double)_AryOf_BasicData[i][10],5)   // MFI
          
          //_20200521_151404:tmp
          //, _AryOf_BasicData[i][11]   // Force
          , NormalizeDouble((double)_AryOf_BasicData[i][11],5)   // Force
          
          //, _AryOf_BasicData[i][6]   // BB 2s ?
          //, _AryOf_BasicData[i][5]   // BB 1s ?
          //, _AryOf_BasicData[i][5]   // BB 2s
          , NormalizeDouble((double)_AryOf_BasicData[i][5],3)
          
          //, _AryOf_BasicData[i][6]   // BB 1s
          , NormalizeDouble((double)_AryOf_BasicData[i][6],3)
          
          //, _AryOf_BasicData[i][7]   // BB main
          , NormalizeDouble((double)_AryOf_BasicData[i][7],3)
          
          //, _AryOf_BasicData[i][8]   // BB -1s
          , NormalizeDouble((double)_AryOf_BasicData[i][8],3)
          
          //, _AryOf_BasicData[i][9]   // BB -2s
          , NormalizeDouble((double)_AryOf_BasicData[i][9],3)
          
          , _AryOf_BasicData[i][3] - _AryOf_BasicData[i][0]   // Diff
          //, NormalizeDouble((double)_AryOf_BasicData[i][0],3)   //=> value not correct
          //, NormalizeDouble(_AryOf_BasicData[i][0],3)   //=> value not correct
          //, StringFormat("%.03f", _AryOf_BasicData[i][0])  //=> value not correct
          
          , _AryOf_BasicData[i][1] - _AryOf_BasicData[i][2]   // Range
          //, NormalizeDouble((double)_AryOf_BasicData[i][2],3)  //=> value not correct
          
          , TimeToStr(iTime(Symbol(), _TIME_FRAME, i))
          
          //test
          , TimeToStr(iTime(Symbol(), _TIME_FRAME, i) + (7 * 60 * 60))
          
          );
     }

   /*********************
      file : close
   *********************/
   _file_close(_FILE_HANDLE);

   /*********************
      return
   *********************/
   return 1;

}//write2File_AryOf_BasicData_With_RSI_BB

/****************************
   int write2File_AryOf_BasicData_With_RSI
   
   @return
      -1 can't open file

*****************************/
int write2File_AryOf_BasicData_With_RSI_BB_MFI__Shifted(
   string _FNAME, 
   string _SUBFOLDER, 

   //double &_AryOf_BasicData[][4], 
   double &_AryOf_BasicData[][11], 

   int _lenOf_Array, 
   int shift,
   
   string _SYMBOL_STR, 
   string _CURRENT_PERIOD, 
   
   int _NUMOF_DAYS, 
   int _NUMOF_TARGET_BARS, 
   
   string _TIME_LABEL, 
   int _TIME_FRAME
   
) {

   //+------------------------------------------------------------------+
   //| file: open
   //+------------------------------------------------------------------+
   int _FILE_HANDLE = NULL;
   
   
   _FILE_HANDLE =_file_open(_FILE_HANDLE, _FNAME, _SUBFOLDER);
   //int result=_file_open(FILE_HANDLE, FNAME, SUBFOLDER);

   if(_FILE_HANDLE == -1)
     {

      return -1;

     }

   /*********************
      write : header
   *********************/
   _file_write__header_With_RSI_BB_MFI(_FILE_HANDLE, 
         _SYMBOL_STR, _CURRENT_PERIOD, 
         _NUMOF_DAYS, _NUMOF_TARGET_BARS, 
         _TIME_LABEL, shift);

   /*********************
      write : data
   *********************/
   for(int i=0; i < _lenOf_Array; i++)
     {
         //AryOf_BasicData[i];
         //AryOf_BasicData[i][0];
         FileWrite(_FILE_HANDLE,

          (i+1),

          _AryOf_BasicData[i][0]     // Open
          , _AryOf_BasicData[i][1]   // High
          , _AryOf_BasicData[i][2]   // Low
          , _AryOf_BasicData[i][3]   // Close
          
          , _AryOf_BasicData[i][4]   // RSI
          
          , _AryOf_BasicData[i][10]   // MFI
          
          , _AryOf_BasicData[i][5]   // BB 2s
          , _AryOf_BasicData[i][6]   // BB 1s
          
          , _AryOf_BasicData[i][7]   // BB main
          , _AryOf_BasicData[i][8]   // BB -1s
          , _AryOf_BasicData[i][9]   // BB -2s
          
          , _AryOf_BasicData[i][3] - _AryOf_BasicData[i][0]   // Diff
          , _AryOf_BasicData[i][1] - _AryOf_BasicData[i][2]   // Range
/*          
          , TimeToStr(iTime(Symbol(), _TIME_FRAME, i))
          
          //test
          , TimeToStr(iTime(Symbol(), _TIME_FRAME, i) + (7 * 60 * 60))
*/
          , TimeToStr(iTime(Symbol(), _TIME_FRAME, i + shift))
          
          //test
          , TimeToStr(iTime(Symbol(), _TIME_FRAME, i + shift) + (7 * 60 * 60))
          
          );
     }

   /*********************
      file : close
   *********************/
   _file_close(_FILE_HANDLE);

   /*********************
      return
   *********************/
   return 1;

}//write2File_AryOf_BasicData_With_RSI_BB_MFI__Shifted

/****************************
   _file_open()
   
   @return
      1  file opened
      -1 can't open file

*****************************/
int _file_open(int _FILE_HANDLE, string _FNAME, string _SUBFOLDER) 
  {

   _FILE_HANDLE = FileOpen("Research\\" + _SUBFOLDER + "\\"+ _FNAME, FILE_WRITE|FILE_CSV);

   if(_FILE_HANDLE == INVALID_HANDLE) 
     {

      Print("[",__LINE__,"] can't open file: ",_FNAME,"");

      // return
      return -1;

     }//if(FILE_HANDLE == INVALID_HANDLE)

   //+------------------------------------------------------------------+
   //| File: seek
   //+------------------------------------------------------------------+
   //ref https://www.mql5.com/en/forum/3239
   FileSeek(_FILE_HANDLE,0,SEEK_END);

   return _FILE_HANDLE;

  }//_file_open()

/****************************
   _file_open_2()
   
   <usage>
   @_SUBFOLDER ==> the folder under C:\Users\iwabuchiken\AppData\Roaming\MetaQuotes\Terminal\34B08C83A5AAE27A4079DE708E60511E\MQL4\Files
   
   @return
      1  file opened
      -1 can't open file

*****************************/
int _file_open_2(
   int _FILE_HANDLE
   , string _FNAME, string _SUBFOLDER
   , int _file_Mode, int _file_Type) 
  {

   _FILE_HANDLE = FileOpen(
            _SUBFOLDER + "\\"+ _FNAME, _file_Mode|_file_Type);
            //_SUBFOLDER + "\\"+ _FNAME, FILE_WRITE|FILE_CSV);

   if(_FILE_HANDLE == INVALID_HANDLE) 
     {

      Print("[", __FILE__, ":", __LINE__, "] can't open file: ",_FNAME,"");

      // return
      return -1;

     }//if(FILE_HANDLE == INVALID_HANDLE)

   //+------------------------------------------------------------------+
   //| File: seek
   //+------------------------------------------------------------------+
   //ref https://www.mql5.com/en/forum/3239
   FileSeek(_FILE_HANDLE,0,SEEK_END);

   return _FILE_HANDLE;

  }//_file_open_2()

void _file_close(int _FILE_HANDLE) 
  {

   FileClose(_FILE_HANDLE);

   Print("[", __FILE__, ":",__LINE__,"] file => closed : ", (string) _FILE_HANDLE);

}//_file_close()

int _file_write__header(int _FILE_HANDLE) 
  {

   // column names
   uint result = FileWrite(_FILE_HANDLE,
               
               //"no.", "index", "kairi", "datetime", "symbol", "period"
               "no", "Open", "High", "Low", "Close", "Diff", "High/Low"
               
             );    // header
   /***************
      validate
   ***************/
   if(result == 0)
     {
         Print("[",__LINE__,"] header => NOT written");
         
         return 0;
         
     }

//debug
   Print("[",__LINE__,"] header => written");

// return
   return 1;

}//_file_write__header()

int _file_write__header_2(int _FILE_HANDLE,
         string _SYMBOL_STR, string _CURRENT_PERIOD, 
         int _NUMOF_DAYS, int _NUMOF_TARGET_BARS, 
         string _TIME_LABEL) 
  {

   // meta info
   FileWrite(_FILE_HANDLE,
      
      "Pair=" + _SYMBOL_STR
      
      , "Period=" + _CURRENT_PERIOD
      
      , "Days=" + (string) _NUMOF_DAYS
      
      , "Bars=" + (string) _NUMOF_TARGET_BARS

      , "Time=" + _TIME_LABEL

   );
   
   // column names
   uint result = FileWrite(_FILE_HANDLE,
               
               //"no.", "index", "kairi", "datetime", "symbol", "period"
               "no", "Open", "High", "Low", "Close", "Diff", "High/Low"
               
               , "datetime"
               
             );    // header
   /***************
      validate
   ***************/
   if(result == 0)
     {
         Print("[",__LINE__,"] header => NOT written");
         
         return 0;
         
     }

   //debug
   Print("[",__LINE__,"] header => written");

// return
   return 1;

}//_file_write__header_2()


int _file_write__header_With_RSI(
         int _FILE_HANDLE,
         string _SYMBOL_STR, string _CURRENT_PERIOD, 
         int _NUMOF_DAYS, int _NUMOF_TARGET_BARS, 
         string _TIME_LABEL, int shift) 
  {

   // meta info
   FileWrite(_FILE_HANDLE,
      
      "Pair=" + _SYMBOL_STR
      
      , "Period=" + _CURRENT_PERIOD
      
      , "Days=" + (string) _NUMOF_DAYS
      
      , "Shift=" + (string) shift

      , "Bars=" + (string) _NUMOF_TARGET_BARS

      , "Time=" + _TIME_LABEL

   );
   
   // column names
   uint result = FileWrite(_FILE_HANDLE,
               
               //"no.", "index", "kairi", "datetime", "symbol", "period"
               "no", "Open", "High", "Low", "Close"
               , "RSI"
               , "Diff", "High/Low"
               
               , "datetime"
               
             );    // header
   /***************
      validate
   ***************/
   if(result == 0)
     {
         Alert("[",__LINE__,"] header => NOT written");
         
         return 0;
         
     }

   //debug
   Alert("[",__LINE__,"] header => written");

// return
   return 1;

}//_file_write__header_2()

int _file_write__header_With_RSI_BB(
         int _FILE_HANDLE,
         string _SYMBOL_STR, string _CURRENT_PERIOD, 
         int _NUMOF_DAYS, int _NUMOF_TARGET_BARS, 
         string _TIME_LABEL, int shift) 
  {

   // meta info
   FileWrite(_FILE_HANDLE,
      
      "Pair=" + _SYMBOL_STR
      
      , "Period=" + _CURRENT_PERIOD
      
      , "Days=" + (string) _NUMOF_DAYS
      
      , "Shift=" + (string) shift

      , "Bars=" + (string) _NUMOF_TARGET_BARS

      , "Time=" + _TIME_LABEL

   );
   
   // column names
   uint result = FileWrite(_FILE_HANDLE,
               
               //"no.", "index", "kairi", "datetime", "symbol", "period"
               "no", "Open", "High", "Low", "Close"
               
               , "RSI"
               
               , "BB.2s", "BB.1s", "BB.main", "BB.-1s", "BB.-2s"
               
               , "Diff", "High/Low"
               
               , "datetime"
               
             );    // header
   /***************
      validate
   ***************/
   if(result == 0)
     {
         Alert("[",__LINE__,"] header => NOT written");
         
         return 0;
         
     }

   //debug
   Print("[",__LINE__,"] header => written");

// return
   return 1;

}//int _file_write__header_With_RSI_BB

int _file_write__header_With_RSI_BB_MFI(
         int _FILE_HANDLE,
         string _SYMBOL_STR, string _CURRENT_PERIOD, 
         int _NUMOF_DAYS, int _NUMOF_TARGET_BARS, 
         string _TIME_LABEL, int shift) 
  {

   // meta info
   FileWrite(_FILE_HANDLE,
      
      "Pair=" + _SYMBOL_STR
      
      , "Period=" + _CURRENT_PERIOD
      
      , "Days=" + (string) _NUMOF_DAYS
      
      , "Shift=" + (string) shift

      , "Bars=" + (string) _NUMOF_TARGET_BARS

      , "Time=" + _TIME_LABEL

   );
   
   //_20200521_151203:tmp
   // column names
   uint result = FileWrite(_FILE_HANDLE,
               
               //"no.", "index", "kairi", "datetime", "symbol", "period"
               "no", "Open", "High", "Low", "Close"
               
               , "RSI"
               
               , "MFI"
               
               //_20200521_151237:tmp
               , "Force"
               
               , "BB.2s", "BB.1s", "BB.main", "BB.-1s", "BB.-2s"
               
               , "Diff", "High/Low"
               
               , "datetime"
               
             );    // header
   /***************
      validate
   ***************/
   if(result == 0)
     {
         Alert("[",__LINE__,"] header => NOT written");
         
         return 0;
         
     }

   //debug
   Alert("[",__LINE__,"] header => written");

// return
   return 1;

}//int _file_write__header_With_RSI_BB_MFI

/****************************
func : int set_Symbol(string symbol_str, int period)

   @param symbol_str     => "USDJPY"
   @param period         => e.g. 60 --> H1
   
   @return
      1    => symbol set
      -1   => otherwise

*****************************/
int set_Symbol(string symbol_str, int period) {

   bool res_utils = ChartSetSymbolPeriod(0,symbol_str, period);  // set symbol

   if(res_utils == true)
     {
     
         //debug
         //Print("[", __FILE__, ":",__LINE__,"] symbol set => ", symbol_str);
         Print("[", __FILE__, ":",__LINE__,"] symbol set => ", symbol_str
                  , " ("
                  , (string) period, ")"
                  );
     
         return 1;
     }
     else
       {
       
         //debug
         Alert("[", __FILE__, ":",__LINE__,"] symbol NOT set => ", symbol_str);

         return -1;
       }

}//int set_Symbol(string symbol_str, int period)

string _get_FNAME(
               string _SUBFOLDER, string main_Label, 
               string _SYMBOL_STR, string _CURRENT_PERIOD, 
               int _NUMOF_DAYS, int _NUMOF_TARGET_BARS, 
               string _TIME_LABEL) {
/*
   string tmp = "[" + _SUBFOLDER
         
         + "_" + main_Label + "]"
*/

   string tmp = _SUBFOLDER
         
         + "_" + main_Label

         + ".(" + _SYMBOL_STR + ")"

         + ".(" + "Period-" + _CURRENT_PERIOD + ")"

         + ".(" + "NumOfUnits-" + (string) _NUMOF_DAYS + ")"
         //+ "." + "Days-" + (string) _NUMOF_DAYS
         
         +".(" + "Bars-" + (string) _NUMOF_TARGET_BARS + ")"
         
         +"." + _TIME_LABEL
         
         +".csv";


/*
   string tmp = _SUBFOLDER
         
//         + "_" + "file-io"
         + "_" + main_Label

         + "." + _SYMBOL_STR

         + "." + "Period-" + _CURRENT_PERIOD

         + "." + "NumOfUnits-" + (string) _NUMOF_DAYS
         //+ "." + "Days-" + (string) _NUMOF_DAYS
         
         +"." + "Bars-" + (string) _NUMOF_TARGET_BARS
         
         +"." + _TIME_LABEL
         
         +".csv";
*/
   //debug
   Print("[", __FILE__, ":",__LINE__,"] file name built => ", tmp);

   return tmp;

}//string _get_FNAME

string _get_FNAME__Shifted(
               string _SUBFOLDER, string main_Label, 
               string _SYMBOL_STR, string _CURRENT_PERIOD, 
               int _NUMOF_DAYS, int _NUMOF_TARGET_BARS, 
               string _TIME_LABEL, int _SHIFT) {

   string tmp = _SUBFOLDER
         
//         + "_" + "file-io"
         + "_" + main_Label

         + "." + _SYMBOL_STR

         + "." + "Period-" + _CURRENT_PERIOD

         + "." + "Days-" + (string) _NUMOF_DAYS
         
         +"." + "Bars-" + (string) _NUMOF_TARGET_BARS
         
         +"." + "Shift-" + (string) _SHIFT
         
         +"." + _TIME_LABEL
         
         +".csv";
         
   //debug
   Print("[", __FILE__, ":",__LINE__,"] file name built => ", tmp);

   return tmp;

}//_get_FNAME__Shifted

/******************************************
   @params
      string       symbol,           // symbol
      int          timeframe,        // timeframe
      int          period,           // period
      int          applied_price,    // applied price
      int          shift             // shift
   
   @return
      number of RSI values
   
******************************************/
int get_AryOf_RSI(
      string symbol_Str, 
      int time_Frame, 
      int period_RSI, 
      int price, 
      int shift, 
      int length,
      double &AryOf_Data[][5]) {

   //debug
   Print("[", __FILE__, ":",__LINE__,"] get_AryOf_RSI()");

   /****************
      array ---> resize
   ****************/
   ArrayResize(AryOf_Data, length);

   double  rsi;
   
   int count = 0;

   //debug
   Print("[", __FILE__, ":",__LINE__,"] starting ---> for loop");

   //for(int i = shift; i<(shift + length); i++)
   //for(int i = shift; i<(shift + length) - 1; i++)
   for(int i = 0; i < length; i++)
     {
     
         rsi = iRSI(symbol_Str, time_Frame, period_RSI, price, i);
         
         // input
         AryOf_Data[i][0] = Open[i];
         AryOf_Data[i][1] = High[i];
         AryOf_Data[i][2] = Low[i];
         AryOf_Data[i][3] = Close[i];

         AryOf_Data[i][4] = rsi;
         
         // count
         count ++;

/*
         //debug
         Alert("[", __FILE__, ":",__LINE__,"] rsi ---> ", 
                     rsi
                     , "(i = ", i
                     , " / "
                     , "index = ", (i + shift)
                     , ")"
                     
                     );
*/

     }
   //double  rsi = iRSI(symbol_Str, time_Frame, period_RSI, price, shift);
   
      //debug
      /*
   Alert("[", __FILE__, ":",__LINE__,"] rsi => ", 
                  rsi, 
                  "(shift = ", shift
                  , " / "
                  , "period = ", period_RSI
                  
                  , ")"
                  
   );
*/
   /****************
      return
   ****************/
   return count;

}//int get_RSI(string symbol_Str, int time_Frame, int period, int price, int shift, double &AryOf_Data[][5])

/******************************************
   @params
      string       symbol,           // symbol
      int          timeframe,        // timeframe
      int          period,           // period
      int          applied_price,    // applied price
      int          shift             // shift
   
   @return
      number of RSI values
   
******************************************/
int get_AryOf_RSI_BB(
      string symbol_Str, 
      int time_Frame, 
      int period_RSI, 
      int price, 
      int shift, 
      int length,
      double &AryOf_Data[][10]) {

   //debug
   Print("[", __FILE__, ":",__LINE__,"] get_AryOf_RSI_BB()");

   /****************
      array ---> resize
   ****************/
   ArrayResize(AryOf_Data, length);

   double  rsi;
   
   //ref https://docs.mql4.com/indicators/ibands
   double   ibands_Main;
   double   ibands_1S_Plus;
   double   ibands_1S_Minus;
   double   ibands_2S_Plus;
   double   ibands_2S_Minus;
   
   int   period_BB = 20;
   
   int count = 0;

   //debug
   Print("[", __FILE__, ":",__LINE__,"] starting ---> for loop");

   //for(int i = shift; i<(shift + length); i++)
   //for(int i = shift; i<(shift + length) - 1; i++)
   for(int i = 0; i < length; i++)
     {
     
         //ref https://docs.mql4.com/indicators/irsi
         rsi = iRSI(symbol_Str, time_Frame, period_RSI, price, i);
            
            /*
            string       symbol,           // symbol
            int          timeframe,        // timeframe
            int          period,           // averaging period
            double       deviation,        // standard deviations
            int          bands_shift,      // bands shift
            int          applied_price,    // applied price
            int          mode,             // line index
            int          shift             // shift
            */
         //ref https://docs.mql4.com/indicators/ibands
         ibands_Main = iBands(symbol_Str,time_Frame, period_BB, 0,0,PRICE_CLOSE,MODE_MAIN,i);
         
         ibands_1S_Plus = iBands(symbol_Str,time_Frame, period_BB, 1.0,0,PRICE_CLOSE,MODE_UPPER,i);
         
         //ref mode lower https://docs.mql4.com/constants/indicatorconstants/lines
         ibands_1S_Minus = iBands(
                  symbol_Str,time_Frame, period_BB, 1.0,0,PRICE_CLOSE, MODE_LOWER,i);
         
         ibands_2S_Plus = iBands(symbol_Str,time_Frame, period_BB, 2.0,0,PRICE_CLOSE,MODE_UPPER,i);
         
         ibands_2S_Minus = iBands(
                  symbol_Str,time_Frame, period_BB, 2.0,0,PRICE_CLOSE, MODE_LOWER,i);
         
         // input
         AryOf_Data[i][0] = Open[i];
         AryOf_Data[i][1] = High[i];
         AryOf_Data[i][2] = Low[i];
         AryOf_Data[i][3] = Close[i];

         AryOf_Data[i][4] = rsi;
         
         AryOf_Data[i][5] = ibands_2S_Plus;
         AryOf_Data[i][6] = ibands_1S_Plus;
         
         AryOf_Data[i][7] = ibands_Main;
         
         AryOf_Data[i][8] = ibands_1S_Minus;
         AryOf_Data[i][9] = ibands_2S_Minus;
         
         // count
         count ++;

/*
         //debug
         Alert("[", __FILE__, ":",__LINE__,"] rsi ---> ", 
                     rsi
                     , "(i = ", i
                     , " / "
                     , "index = ", (i + shift)
                     , ")"
                     
                     );
*/

     }
   //double  rsi = iRSI(symbol_Str, time_Frame, period_RSI, price, shift);
   
      //debug
      /*
   Alert("[", __FILE__, ":",__LINE__,"] rsi => ", 
                  rsi, 
                  "(shift = ", shift
                  , " / "
                  , "period = ", period_RSI
                  
                  , ")"
                  
   );
*/
   /****************
      return
   ****************/
   return count;

}//int get_AryOf_RSI_BB(string symbol_Str, int time_Frame, int period, int price, int shift, double &AryOf_Data[][5])

/******************************************
   @params
      string       symbol,           // symbol
      int          timeframe,        // timeframe
      int          period,           // period
      int          applied_price,    // applied price
      int          shift             // shift
   
   @return
      number of RSI values
   
******************************************/
int get_AryOf_RSI_BB_MFI(
      string symbol_Str, 
      int time_Frame, 
      int period_RSI, 
      int price, 
      int shift, 
      int length,
      //_20200521_150611:tmp
      double &AryOf_Data[][12]) {

   //debug
   Print("[", __FILE__, ":",__LINE__,"] get_AryOf_RSI_BB_MFI()");

   /****************
      array ---> resize
   ****************/
   ArrayResize(AryOf_Data, length);

   double  rsi;
   double  mfi;
   //_20200521_145524:tmp
   double   force;
   
   //ref https://docs.mql4.com/indicators/ibands
   double   ibands_Main;
   double   ibands_1S_Plus;
   double   ibands_1S_Minus;
   double   ibands_2S_Plus;
   double   ibands_2S_Minus;
   
   int   period_BB = 20;
   
   int   period_Force = 20;
   int   ma_Force = MODE_SMA;
   int   applied_price_Force = PRICE_CLOSE;
   
   int count = 0;

   //debug
   Print("[", __FILE__, ":",__LINE__,"] starting ---> for loop");

   //for(int i = shift; i<(shift + length); i++)
   //for(int i = shift; i<(shift + length) - 1; i++)
   for(int i = 0; i < length; i++)
     {
     
         //_20200518_130129:ref
         //ref https://docs.mql4.com/indicators/irsi
         rsi = iRSI(symbol_Str, time_Frame, period_RSI, price, i);
         
         mfi = iMFI(symbol_Str, time_Frame, period_RSI, i);
            
            /*
            string       symbol,           // symbol
            int          timeframe,        // timeframe
            int          period,           // averaging period
            double       deviation,        // standard deviations
            int          bands_shift,      // bands shift
            int          applied_price,    // applied price
            int          mode,             // line index
            int          shift             // shift
            */
         
         //_20200521_145459:tmp
            /*
            double  iForce(
               string       symbol,           // symbol              :1
               int          timeframe,        // timeframe           :2
               int          period,           // averaging period    :3
               int          ma_method,        // averaging method    :4
               int          applied_price,    // applied price       :5
               int          shift             // shift               :6
               );         
            */
         force = iForce(
                     symbol_Str, time_Frame
                     , period_Force
                     , ma_Force
                     , applied_price_Force
                     , i);
         
         
         //ref https://docs.mql4.com/indicators/ibands
         ibands_Main = iBands(symbol_Str,time_Frame, period_BB, 0,0,PRICE_CLOSE,MODE_MAIN,i);
         
         ibands_1S_Plus = iBands(symbol_Str,time_Frame, period_BB, 1.0,0,PRICE_CLOSE,MODE_UPPER,i);
         
         //ref mode lower https://docs.mql4.com/constants/indicatorconstants/lines
         ibands_1S_Minus = iBands(
                  symbol_Str,time_Frame, period_BB, 1.0,0,PRICE_CLOSE, MODE_LOWER,i);
         
         ibands_2S_Plus = iBands(symbol_Str,time_Frame, period_BB, 2.0,0,PRICE_CLOSE,MODE_UPPER,i);
         
         ibands_2S_Minus = iBands(
                  symbol_Str,time_Frame, period_BB, 2.0,0,PRICE_CLOSE, MODE_LOWER,i);
         
         // input
         AryOf_Data[i][0] = Open[i];
         AryOf_Data[i][1] = High[i];
         AryOf_Data[i][2] = Low[i];
         AryOf_Data[i][3] = Close[i];

         AryOf_Data[i][4] = rsi;
         
         AryOf_Data[i][5] = ibands_2S_Plus;
         AryOf_Data[i][6] = ibands_1S_Plus;
         
         AryOf_Data[i][7] = ibands_Main;
         
         AryOf_Data[i][8] = ibands_1S_Minus;
         AryOf_Data[i][9] = ibands_2S_Minus;
         
         AryOf_Data[i][10] = mfi;
         
         //_20200521_150925:tmp
         AryOf_Data[i][11] = force;
         
         // count
         count ++;

/*
         //debug
         Alert("[", __FILE__, ":",__LINE__,"] rsi ---> ", 
                     rsi
                     , "(i = ", i
                     , " / "
                     , "index = ", (i + shift)
                     , ")"
                     
                     );
*/

     }
   //double  rsi = iRSI(symbol_Str, time_Frame, period_RSI, price, shift);
   
      //debug
      /*
   Alert("[", __FILE__, ":",__LINE__,"] rsi => ", 
                  rsi, 
                  "(shift = ", shift
                  , " / "
                  , "period = ", period_RSI
                  
                  , ")"
                  
   );
*/
   /****************
      return
   ****************/
   return count;

}//get_AryOf_RSI_BB_MFI

/******************************************
   @params
      string       symbol,           // symbol
      int          timeframe,        // timeframe
      int          period,           // period
      int          applied_price,    // applied price
      int          shift             // shift
   
   @return
      number of RSI values
   
******************************************/
int get_AryOf_RSI_BB_MFI__MQL5(
      string symbol_Str, 
      int time_Frame, 
      int period_RSI, 
      int price, 
      int shift, 
      int length,
      double &AryOf_Data[][11]) {

   //debug
   Print("[", __FILE__, ":",__LINE__,"] get_AryOf_RSI_BB_MFI()");

   /****************
      array ---> resize
   ****************/
   ArrayResize(AryOf_Data, length);

   double  rsi;
   double  mfi;
   
   //ref https://docs.mql4.com/indicators/ibands
   double   ibands_Main;
   double   ibands_1S_Plus;
   double   ibands_1S_Minus;
   double   ibands_2S_Plus;
   double   ibands_2S_Minus;
   
   int   period_BB = 20;
   
   int count = 0;

   //debug
   Print("[", __FILE__, ":",__LINE__,"] starting ---> for loop");

   //for(int i = shift; i<(shift + length); i++)
   //for(int i = shift; i<(shift + length) - 1; i++)
   for(int i = 0; i < length; i++)
     {
     
         //ref https://docs.mql4.com/indicators/irsi
         rsi = iRSI(symbol_Str, time_Frame, period_RSI, price, i);
         
         mfi = iMFI(symbol_Str, time_Frame, period_RSI, i);
            
            /*
            string       symbol,           // symbol
            int          timeframe,        // timeframe
            int          period,           // averaging period
            double       deviation,        // standard deviations
            int          bands_shift,      // bands shift
            int          applied_price,    // applied price
            int          mode,             // line index
            int          shift             // shift
            */
         //ref https://docs.mql4.com/indicators/ibands
         ibands_Main = iBands(symbol_Str,time_Frame, period_BB, 0,0,PRICE_CLOSE,MODE_MAIN,i);
         
         ibands_1S_Plus = iBands(symbol_Str,time_Frame, period_BB, 1.0,0,PRICE_CLOSE,MODE_UPPER,i);
         
         //ref mode lower https://docs.mql4.com/constants/indicatorconstants/lines
         ibands_1S_Minus = iBands(
                  symbol_Str,time_Frame, period_BB, 1.0,0,PRICE_CLOSE, MODE_LOWER,i);
         
         ibands_2S_Plus = iBands(symbol_Str,time_Frame, period_BB, 2.0,0,PRICE_CLOSE,MODE_UPPER,i);
         
         ibands_2S_Minus = iBands(
                  symbol_Str,time_Frame, period_BB, 2.0,0,PRICE_CLOSE, MODE_LOWER,i);
         
         // input
         AryOf_Data[i][0] = Open[i];
         AryOf_Data[i][1] = High[i];
         AryOf_Data[i][2] = Low[i];
         AryOf_Data[i][3] = Close[i];

         AryOf_Data[i][4] = rsi;
         
         AryOf_Data[i][5] = ibands_2S_Plus;
         AryOf_Data[i][6] = ibands_1S_Plus;
         
         AryOf_Data[i][7] = ibands_Main;
         
         AryOf_Data[i][8] = ibands_1S_Minus;
         AryOf_Data[i][9] = ibands_2S_Minus;
         
         AryOf_Data[i][10] = mfi;
         
         // count
         count ++;

/*
         //debug
         Alert("[", __FILE__, ":",__LINE__,"] rsi ---> ", 
                     rsi
                     , "(i = ", i
                     , " / "
                     , "index = ", (i + shift)
                     , ")"
                     
                     );
*/

     }
   //double  rsi = iRSI(symbol_Str, time_Frame, period_RSI, price, shift);
   
      //debug
      /*
   Alert("[", __FILE__, ":",__LINE__,"] rsi => ", 
                  rsi, 
                  "(shift = ", shift
                  , " / "
                  , "period = ", period_RSI
                  
                  , ")"
                  
   );
*/
   /****************
      return
   ****************/
   return count;

}//get_AryOf_RSI_BB_MFI__MQL5

/******************************************
   @params
      string       symbol,           // symbol
      int          timeframe,        // timeframe
      int          period,           // period
      int          applied_price,    // applied price
      int          shift             // shift
   
   @return
      number of RSI values
   
******************************************/
int get_AryOf_RSI_BB_MFI__Shifted(
      string symbol_Str, 
      int time_Frame, 
      int period_RSI, 
      int price, 
      int shift, 
      int length,
      double &AryOf_Data[][11]) {

   //debug
   Print("[", __FILE__, ":",__LINE__,"] get_AryOf_RSI_BB_MFI__Shifted() --> starting");

   /****************
      array ---> resize
   ****************/
   ArrayResize(AryOf_Data, length);

   double  rsi;
   double  mfi;
   
   //ref https://docs.mql4.com/indicators/ibands
   double   ibands_Main;
   double   ibands_1S_Plus;
   double   ibands_1S_Minus;
   double   ibands_2S_Plus;
   double   ibands_2S_Minus;
   
   int   period_BB = 20;
   
   int count = 0;

   //debug
   Print("[", __FILE__, ":",__LINE__,"] starting ---> for loop");

   //for(int i = shift; i<(shift + length); i++)
   //for(int i = shift; i<(shift + length) - 1; i++)
   for(int i = 0; i < length; i++)
     {
     
         //ref https://docs.mql4.com/indicators/irsi
         /*
         rsi = iRSI(symbol_Str, time_Frame, period_RSI, price, i);
         
         mfi = iMFI(symbol_Str, time_Frame, period_RSI, i);
         */
         rsi = iRSI(symbol_Str, time_Frame, period_RSI, price, i + shift);
         
         mfi = iMFI(symbol_Str, time_Frame, period_RSI, i + shift);
            
            /*
            string       symbol,           // symbol
            int          timeframe,        // timeframe
            int          period,           // averaging period
            double       deviation,        // standard deviations
            int          bands_shift,      // bands shift
            int          applied_price,    // applied price
            int          mode,             // line index
            int          shift             // shift
            */
         //ref https://docs.mql4.com/indicators/ibands
         /*
         ibands_Main = iBands(symbol_Str,time_Frame, period_BB, 0,0,PRICE_CLOSE,MODE_MAIN,i);
         
         ibands_1S_Plus = iBands(symbol_Str,time_Frame, period_BB, 1.0,0,PRICE_CLOSE,MODE_UPPER,i);
         
         //ref mode lower https://docs.mql4.com/constants/indicatorconstants/lines
         ibands_1S_Minus = iBands(
                  symbol_Str,time_Frame, period_BB, 1.0,0,PRICE_CLOSE, MODE_LOWER,i);
         
         ibands_2S_Plus = iBands(symbol_Str,time_Frame, period_BB, 2.0,0,PRICE_CLOSE,MODE_UPPER,i);
         
         ibands_2S_Minus = iBands(
                  symbol_Str,time_Frame, period_BB, 2.0,0,PRICE_CLOSE, MODE_LOWER,i);
         */
         ibands_Main = iBands(
                  symbol_Str,time_Frame, period_BB, 0,0,PRICE_CLOSE,MODE_MAIN,i + shift);
         
         ibands_1S_Plus = iBands(
                  symbol_Str,time_Frame, period_BB, 1.0,0,PRICE_CLOSE,MODE_UPPER,i + shift);
         
         //ref mode lower https://docs.mql4.com/constants/indicatorconstants/lines
         ibands_1S_Minus = iBands(
                  symbol_Str,time_Frame, period_BB, 1.0,0,PRICE_CLOSE, MODE_LOWER,i + shift);
         
         ibands_2S_Plus = iBands(
                  symbol_Str,time_Frame, period_BB, 2.0,0,PRICE_CLOSE,MODE_UPPER,i + shift);
         
         ibands_2S_Minus = iBands(
                  symbol_Str,time_Frame, period_BB, 2.0,0,PRICE_CLOSE, MODE_LOWER,i + shift);
         
         // input
         /*
         AryOf_Data[i][0] = Open[i];
         AryOf_Data[i][1] = High[i];
         AryOf_Data[i][2] = Low[i];
         AryOf_Data[i][3] = Close[i];
         */
         AryOf_Data[i][0] = Open[i + shift];
         AryOf_Data[i][1] = High[i + shift];
         AryOf_Data[i][2] = Low[i + shift];
         AryOf_Data[i][3] = Close[i + shift];
         
         AryOf_Data[i][4] = rsi;
         
         AryOf_Data[i][5] = ibands_2S_Plus;
         AryOf_Data[i][6] = ibands_1S_Plus;
         
         AryOf_Data[i][7] = ibands_Main;
         
         AryOf_Data[i][8] = ibands_1S_Minus;
         AryOf_Data[i][9] = ibands_2S_Minus;
         
         AryOf_Data[i][10] = mfi;
         
         // count
         count ++;

/*
         //debug
         Alert("[", __FILE__, ":",__LINE__,"] rsi ---> ", 
                     rsi
                     , "(i = ", i
                     , " / "
                     , "index = ", (i + shift)
                     , ")"
                     
                     );
*/

     }
   //double  rsi = iRSI(symbol_Str, time_Frame, period_RSI, price, shift);
   
      //debug
      /*
   Alert("[", __FILE__, ":",__LINE__,"] rsi => ", 
                  rsi, 
                  "(shift = ", shift
                  , " / "
                  , "period = ", period_RSI
                  
                  , ")"
                  
   );
*/
   /****************
      return
   ****************/
   return count;

}//get_AryOf_RSI_BB_MFI__Shifted

void conv_Index_2_TimeString(int index, int __TIME_FRAME, string __Symbol) {

   //int _TIME_FRAME = TIME_FRAME;
   
   string label = TimeToStr(iTime(__Symbol, __TIME_FRAME, index));
   //string label = TimeToStr(iTime(Symbol(), _TIME_FRAME, index));

   //debug
   Print("[", __FILE__, ":",__LINE__,"] index => ", index, " / ", "label => ", label);
   

}//void test_Conv_Index_2_TimeString(index)

/*************************
int conv_TimeString_2_Index

   @param
   
   @return
      -1    Not found

*************************/
int conv_TimeString_2_Index
(string time_string, string symbol, int time_frame, int limit) {

   //int index;
   int index = -1;
   
   /*********
      validate : time string format
   **********/   
   for(int i=0;i< limit; i++)
     {
      
         string label = TimeToStr(iTime(symbol, time_frame, i));
         
         //debug
         Print("[", __FILE__, ":",__LINE__,"] Time label => ", label,
                  " / ", "index => ", i);
                  
         // detect
         if(label == time_string)
           {

            //debug
            Print("[", __FILE__, ":",__LINE__,"] Hit => ", time_string);
            
            index = i;
            
            break;
               
           }
      
     }//for(int i=0;i< limit; i++)
   
   //debug
   //Alert("[", __FILE__, ":",__LINE__,"] index => ", index, " / ", "label => ", label);


   // return
   return index;

}//conv_TimeString_2_Index(string time_string, string symbol, int time_frame)

/*************************
string get_TimeLabel_Current(int type)

   @param   type
               1  Serial          '20171110_0000'
               2  MQL4 standard   '2017.11.10 00:00'
               3  Slash colon     '2017/11/10 00:00'
      
   @return

*************************/
string get_TimeLabel_Current(int type) {
   //ref https://docs.mql4.com/constants/structures/mqldatetime
/*   datetime date1=D'2008.03.01';
   datetime date2=D'2009.03.01';
 
   MqlDateTime str1,str2;
   TimeToStruct(date1,str1);
   
   //debug
   Alert("[", __FILE__, ":",__LINE__,"] str1.day_of_year => ", str1.day_of_year);   //=> 60
  */ 
/*   
//   printf("%02d.%02d.%4d, day of year = %d",str1.day,str1.mon,
  //        str1.year,str1.day_of_year);

   //ref https://docs.mql4.com/convert/timetostr
   string var1=TimeToStr(TimeCurrent(),TIME_DATE|TIME_SECONDS);
   
   //debug
   Alert("[", __FILE__, ":",__LINE__,"] TimeCurrent() => ", TimeCurrent());   //=> 
*/
/*   
   // test : 3
   string time_Label = "";;
   
   if(type == 1)
     {   
         //ref concatenate https://docs.mql4.com/strings/stringconcatenate
         time_Label = StringConcatenate(
                        Year(), Month(), Day()
                        
                        , "_"
                        , Hour(), Minute(), Seconds()
         
         
         );
         //time_Label = Year() + Month() + Day();
     }

   //debug
   Alert("[", __FILE__, ":",__LINE__,"] time_Label => ", time_Label);

*/

/*   
   Alert("[", __FILE__, ":",__LINE__,"] TimeCurrent => "
            , Year()
            //, "/"
            , Month()
            //, "/"
            , Day()
            //, "/"

            
   );   //=> 
  */        
  
   // test : 4
   string time_Label = TimeToStr(TimeLocal(),TIME_DATE|TIME_SECONDS);
   //string time_Label = TimeToStr(TimeCurrent(),TIME_DATE|TIME_SECONDS);
   
   // prep vars
            //ref https://docs.mql4.com/strings/stringsplit
         // date, time
         string to_split= time_Label;   // A string to split into substrings
         string sep=" ";                // A separator as a character
         ushort u_sep;                  // The code of the separator character
         string result[];               // An array to get strings
         //--- Get the separator code
         u_sep=StringGetCharacter(sep,0);
         //--- Split the string to substrings
         int k=StringSplit(to_split,u_sep,result);
         
         //debug
         Print("[", __FILE__, ":",__LINE__,"] result[0] => ", result[0]
         
                  , " / "
                  
                  , "result[1] => ", result[1]
         
         );
         
         // date --> into 3 parts
         to_split= result[0];   // A string to split into substrings
         sep=".";                // A separator as a character
         //u_sep;                  // The code of the separator character
         string res_1[];               // An array to get strings

         u_sep = StringGetCharacter(sep,0);
         //--- Split the string to substrings
         k = StringSplit(to_split,u_sep,res_1);

         //debug
         Print("[", __FILE__, ":",__LINE__,"] res_1[0] => ", res_1[0]
         
                  , " / "
                  
                  , "res_1[1] => ", res_1[1]
         
         );

         // time --> into 2 parts
         to_split= result[1];   // A string to split into substrings
         sep=":";                // A separator as a character
         //u_sep;                  // The code of the separator character
         string res_2[];               // An array to get strings

         u_sep = StringGetCharacter(sep,0);
         //--- Split the string to substrings
         k = StringSplit(to_split,u_sep,res_2);

         //debug
         Print("[", __FILE__, ":",__LINE__,"] res_2[0] => ", res_2[0]
         
                  , " / "
                  
                  , "res_2[1] => ", res_2[1]
         
         );      
   
   if(type == 1)  // serial
     {

         
         // concatenate
         time_Label = StringConcatenate(
                  res_1[0], res_1[1], res_1[2]
                  
                  , "_"
                  
                  , res_2[0], res_2[1], res_2[2]
         );
         
     }//if(type == 1)  // serial
   else if (type == 3)
   //3  Slash colon     '2017/11/10 00:00'
     {

         // concatenate
         time_Label = StringConcatenate(
                  res_1[0]
                  , "/"
                  , res_1[1]
                  , "/"
                  , res_1[2]
                  
                  , " "
                  
                  , res_2[0]
                  , ":"
                  , res_2[1]
                  , ":"
                  , res_2[2]
         );
      
     }
  
      //debug
      Print("[", __FILE__, ":",__LINE__,"] time_Label => ", time_Label);
  
    
   // return
   //return NULL;
   return time_Label;

}//get_TimeLabel_Current()

void get_BasicData_with_RSI(
string _symbol_Str, int _pastXBars,
string _SUBFOLDER, string _MAIN_LABEL,
string _CURRENT_PERIOD, int _NUMOF_DAYS,
int _NUMOF_TARGET_BARS, string _TIME_LABEL,
int _TIME_FRAME) {

   //double   AryOf_BasicData[][4];
   double   AryOf_BasicData[][5];

   // get data
   //int pastXBars = NUMOF_DAYS;
   int pastXBars = _pastXBars;
   
   string _FNAME = _get_FNAME(
               _SUBFOLDER, _MAIN_LABEL, _symbol_Str, 
               _CURRENT_PERIOD, _NUMOF_DAYS, 
               _NUMOF_TARGET_BARS, _TIME_LABEL);

    //debug
    Print("[", __FILE__, ":",__LINE__,"] FNAME => ", _FNAME);
    
    /******************
      iRSI
    ******************/
    //ref https://docs.mql4.com/indicators/irsi
         /*
         string       symbol,           // symbol
         int          timeframe,        // timeframe
         int          period,           // period
         int          applied_price,    // applied price
         int          shift             // shift
         */
   int shift = 1;
   
   int period_RSI = 20;
   
   int price_Target = PRICE_CLOSE;
   
   double   AryOf_Data[][5];
   
   //int length = 5;
   int length = _NUMOF_DAYS;
   
   //debug
   Print("[", __FILE__, ":",__LINE__,"] calling ---> get_AryOf_RSI");
   
      
   get_AryOf_RSI(
            _symbol_Str, 
            (int) _CURRENT_PERIOD, 
            period_RSI, 
            price_Target, 
            shift, 
            length,
            AryOf_Data);


    /******************
      data ---> write to file
    ******************/
   write2File_AryOf_BasicData_With_RSI(
      _FNAME, _SUBFOLDER, AryOf_Data
      
      , length, shift
            
      , _symbol_Str
      
      , _CURRENT_PERIOD
      
      , _NUMOF_DAYS
      
      , _NUMOF_TARGET_BARS
      
      , _TIME_LABEL
      
      , _TIME_FRAME

   );

   //debug
   Print("[", __FILE__, ":",__LINE__,"] get_BasicData_with_RSI() => done");
   
}//void get_BasicData_with_RSI

void get_BasicData_with_RSI_BB(
   string _symbol_Str, int _pastXBars,
   string _SUBFOLDER, string _MAIN_LABEL,
   string _CURRENT_PERIOD, int _NUMOF_DAYS,
   int _NUMOF_TARGET_BARS, string _TIME_LABEL,
   int _TIME_FRAME) {

   //double   AryOf_BasicData[][4];
   //double   AryOf_BasicData[][7];

   // get data
   //int pastXBars = NUMOF_DAYS;
   int pastXBars = _pastXBars;
   
   string _FNAME = _get_FNAME(
               _SUBFOLDER, _MAIN_LABEL, _symbol_Str, 
               _CURRENT_PERIOD, _NUMOF_DAYS, 
               _NUMOF_TARGET_BARS, _TIME_LABEL);

    //debug
    Print("[", __FILE__, ":",__LINE__,"] FNAME => ", _FNAME);
    
    /******************
      iRSI
    ******************/
    //ref https://docs.mql4.com/indicators/irsi
         /*
         string       symbol,           // symbol
         int          timeframe,        // timeframe
         int          period,           // period
         int          applied_price,    // applied price
         int          shift             // shift
         */
   int shift = 1;
   
   int period_RSI = 20;
   
   int price_Target = PRICE_CLOSE;
   
   //double   AryOf_Data[][5];
   double   AryOf_Data[][10];
   
   //int length = 5;
   int length = _NUMOF_DAYS;
   
   //debug
   Print("[", __FILE__, ":",__LINE__,"] calling ---> get_AryOf_RSI");
   
      
   //get_AryOf_RSI(
   get_AryOf_RSI_BB(
            _symbol_Str, 
            (int) _CURRENT_PERIOD, 
            period_RSI, 
            price_Target, 
            shift, 
            length,
            AryOf_Data);


    /******************
      data ---> write to file
    ******************/
   write2File_AryOf_BasicData_With_RSI_BB(
      _FNAME, _SUBFOLDER, AryOf_Data
      
      , length, shift
            
      , _symbol_Str
      
      , _CURRENT_PERIOD
      
      , _NUMOF_DAYS
      
      , _NUMOF_TARGET_BARS
      
      , _TIME_LABEL
      
      , _TIME_FRAME

   );

   //debug
   Print("[", __FILE__, ":",__LINE__,"] get_BasicData_with_RSI() => done");
   
}//void get_BasicData_with_RSI_BB

void get_BasicData_with_RSI_BB_MFI__MQL5(
   string _symbol_Str, int _pastXBars,
   string _SUBFOLDER, string _MAIN_LABEL,
   string _CURRENT_PERIOD, int _NUMOF_DAYS,
   int _NUMOF_TARGET_BARS, string _TIME_LABEL,
   int _TIME_FRAME) {

   // get data

   int pastXBars = _pastXBars;
   
   string _FNAME = _get_FNAME(
               _SUBFOLDER, _MAIN_LABEL, _symbol_Str, 
               _CURRENT_PERIOD, _NUMOF_DAYS, 
               _NUMOF_TARGET_BARS, _TIME_LABEL);

    //debug
    Print("[", __FILE__, ":",__LINE__,"] FNAME => ", _FNAME);
    
    /******************
      iRSI
    ******************/
    //ref https://docs.mql4.com/indicators/irsi
         /*
         string       symbol,           // symbol
         int          timeframe,        // timeframe
         int          period,           // period
         int          applied_price,    // applied price
         int          shift             // shift
         */
   int shift = 1;
   
   int period_RSI = 20;
   
   int price_Target = PRICE_CLOSE;
   
   //double   AryOf_Data[][5];
   double   AryOf_Data[][11];
   
   //int length = 5;
   int length = _NUMOF_DAYS;
   
   //debug
   Print("[", __FILE__, ":",__LINE__,"] calling ---> get_AryOf_RSI");
   

   //get_AryOf_RSI(
   get_AryOf_RSI_BB_MFI(
            _symbol_Str, 
            (int) _CURRENT_PERIOD, 
            period_RSI, 
            price_Target, 
            shift, 
            length,
            AryOf_Data);


    /******************
      data ---> write to file
    ******************/
   write2File_AryOf_BasicData_With_RSI_BB_MFI(
      _FNAME, _SUBFOLDER, AryOf_Data
      
      , length, shift
            
      , _symbol_Str
      
      , _CURRENT_PERIOD
      
      , _NUMOF_DAYS
      
      , _NUMOF_TARGET_BARS
      
      , _TIME_LABEL
      
      , _TIME_FRAME

   );

    /******************
      Array --> free
    ******************/
    //ref
    ArrayFree(AryOf_Data);
    
   // debug
   string txt_utils = "AryOf_Data --> freed ("
            + "symbol = " + _symbol_Str
            + " / "
            + "period = " + _CURRENT_PERIOD
            + ")"
            ;
   
   //string dpath_Log = "Logs";
   //C:\Users\iwabuchiken\AppData\Roaming\MetaQuotes\Terminal\34B08C83A5AAE27A4079DE708E60511E\MQL4\Logs
   //string fname_Log = "dev.log";

/*
   // debug
   write_Log(
         dpath_Log
         , fname_Log
         , __FILE__
         , __LINE__
         , txt);
         //, name);
*/

   //debug
   Print("[", __FILE__, ":",__LINE__,"] get_BasicData_with_RSI() => done");
   
}//get_BasicData_with_RSI_BB_MFI__MQL5

void get_BasicData_with_RSI_BB_MFI(
   string _symbol_Str, int _pastXBars,
   string _SUBFOLDER, string _MAIN_LABEL,
   string _CURRENT_PERIOD, int _NUMOF_DAYS,
   int _NUMOF_TARGET_BARS, string _TIME_LABEL,
   int _TIME_FRAME) {

   // get data

   int pastXBars = _pastXBars;
   
   string _FNAME = _get_FNAME(
               _SUBFOLDER, _MAIN_LABEL, _symbol_Str, 
               _CURRENT_PERIOD, _NUMOF_DAYS, 
               _NUMOF_TARGET_BARS, _TIME_LABEL);

    //debug
    Print("[", __FILE__, ":",__LINE__,"] FNAME => ", _FNAME);
    
    /******************
      iRSI
    ******************/
    //ref https://docs.mql4.com/indicators/irsi
         /*
         string       symbol,           // symbol
         int          timeframe,        // timeframe
         int          period,           // period
         int          applied_price,    // applied price
         int          shift             // shift
         */
   int shift = 1;
   
   int period_RSI = 20;
   
   int price_Target = PRICE_CLOSE;
   
   //double   AryOf_Data[][5];
   //20200521_150747:tmp
   //double   AryOf_Data[][11];
   double   AryOf_Data[][12];
   
   //int length = 5;
   int length = _NUMOF_DAYS;
   
   //debug
   Print("[", __FILE__, ":",__LINE__,"] calling ---> get_AryOf_RSI");
   

   //_20200521_150728:tmp
   //get_AryOf_RSI(
   get_AryOf_RSI_BB_MFI(
            _symbol_Str, 
            (int) _CURRENT_PERIOD, 
            period_RSI, 
            price_Target, 
            shift, 
            length,
            AryOf_Data);


    /******************
      data ---> write to file
    ******************/
   write2File_AryOf_BasicData_With_RSI_BB_MFI(
      _FNAME, _SUBFOLDER, AryOf_Data
      
      , length, shift
            
      , _symbol_Str
      
      , _CURRENT_PERIOD
      
      , _NUMOF_DAYS
      
      , _NUMOF_TARGET_BARS
      
      , _TIME_LABEL
      
      , _TIME_FRAME

   );

    /******************
      Array --> free
    ******************/
    //ref
    ArrayFree(AryOf_Data);
    
   // debug
   string txt_utils = "AryOf_Data --> freed ("
            + "symbol = " + _symbol_Str
            + " / "
            + "period = " + _CURRENT_PERIOD
            + ")"
            ;
   
   //string dpath_Log = "Logs";
   //C:\Users\iwabuchiken\AppData\Roaming\MetaQuotes\Terminal\34B08C83A5AAE27A4079DE708E60511E\MQL4\Logs
   //string fname_Log = "dev.log";

/*
   // debug
   write_Log(
         dpath_Log
         , fname_Log
         , __FILE__
         , __LINE__
         , txt);
         //, name);
*/

   //debug
   Print("[", __FILE__, ":",__LINE__,"] get_BasicData_with_RSI() => done");
   
}//get_BasicData_with_RSI_BB_MFI

void get_BasicData_with_RSI_BB_MFI__Shifted(
   string _symbol_Str
   , int _pastXBars,
   string _SUBFOLDER
   , string _MAIN_LABEL,
   string _CURRENT_PERIOD
   , int _NUMOF_DAYS,
   int _NUMOF_TARGET_BARS
   , string _TIME_LABEL,
   int _TIME_FRAME
   , int _SHIFT
   ) {

   // get data

   int pastXBars = _pastXBars;
   
   string _FNAME = _get_FNAME__Shifted(
               _SUBFOLDER, _MAIN_LABEL, _symbol_Str, 
               _CURRENT_PERIOD, _NUMOF_DAYS, 
               _NUMOF_TARGET_BARS, _TIME_LABEL, _SHIFT);

    //debug
    Print("[", __FILE__, ":",__LINE__,"] FNAME => ", _FNAME);
    
    /******************
      iRSI
    ******************/
    //ref https://docs.mql4.com/indicators/irsi
         /*
         string       symbol,           // symbol
         int          timeframe,        // timeframe
         int          period,           // period
         int          applied_price,    // applied price
         int          shift             // shift
         */
   int shift = _SHIFT;
   
   int period_RSI = 20;
   
   int price_Target = PRICE_CLOSE;
   
   //double   AryOf_Data[][5];
   double   AryOf_Data[][11];
   
   //int length = 5;
   int length = _NUMOF_DAYS;
   
   //debug
   Print("[", __FILE__, ":",__LINE__,"] calling ---> get_AryOf_RSI");
   

   //get_AryOf_RSI(
   /*
   get_AryOf_RSI_BB_MFI(
            _symbol_Str, 
            (int) _CURRENT_PERIOD, 
            period_RSI, 
            price_Target, 
            shift, 
            length,
            AryOf_Data);
   */
   
   get_AryOf_RSI_BB_MFI__Shifted(
/*         string symbol_Str, 
      int time_Frame, 
      int period_RSI, 
      int price, 
      int shift, 
      int length,
      double &AryOf_Data[][11]
      */
            _symbol_Str, 
            (int) _CURRENT_PERIOD, 
            period_RSI, 
            price_Target, 
            shift, 
            length,
            AryOf_Data);

    /******************
      data ---> write to file
    ******************/
/*
   write2File_AryOf_BasicData_With_RSI_BB_MFI(
      _FNAME, _SUBFOLDER, AryOf_Data
      
      , length, shift
            
      , _symbol_Str
      
      , _CURRENT_PERIOD
      
      , _NUMOF_DAYS
      
      , _NUMOF_TARGET_BARS
      
      , _TIME_LABEL
      
      , _TIME_FRAME

   );
*/
   write2File_AryOf_BasicData_With_RSI_BB_MFI__Shifted(
      _FNAME, 
      _SUBFOLDER, 
      
      AryOf_Data
      
      , length, 
      shift, 
      
      _symbol_Str
      , _CURRENT_PERIOD
      
      , _NUMOF_DAYS      
      , _NUMOF_TARGET_BARS
      
      , _TIME_LABEL      
      , _TIME_FRAME

   );

   //debug
   Print("[", __FILE__, ":",__LINE__,"] get_BasicData_with_RSI() => done");
   
}//get_BasicData_with_RSI_BB_MFI__Shifted

//+------------------------------------------------------------------+
//| int write_Log                                                       |
//    @return :
//       1  => log written
//       -1  => file open --> failed
//+------------------------------------------------------------------+
//_20190926_094452:tmp
int write_Log(
   string _dpath_Log
   , string _fname_Log
   , string fpath_Source
   , int line_Num
   , string body) {


   //debug
   Print("[", __FILE__, ":",__LINE__,"] file => opening... ", _fname_Log);


   //+----------------------------+
   // step : 1
   //| file : open                           |
   //+----------------------------+
   int _FILE_HANDLE = NULL;
   

/*          int _FILE_HANDLE
   , string _FNAME, string _SUBFOLDER
   , int _file_Mode, int _file_Type) */
   
   //int _file_Mode = FILE_WRITE;
   //ref append https://www.mql5.com/en/forum/128204
   int _file_Mode = FILE_WRITE|FILE_READ;
   int _file_Type = FILE_TXT;
   
   _FILE_HANDLE =_file_open_2(_FILE_HANDLE, _fname_Log, _dpath_Log, _file_Mode, _file_Type);
   //_FILE_HANDLE =_file_open(_FILE_HANDLE, _fname_Log, _dpath_Log);

   // validate
   if(_FILE_HANDLE == -1)
     {
         //debug
         Print("[", __FILE__, ":",__LINE__,"] file => can't open (handle = "
         , _FILE_HANDLE, " / dir path = ", _dpath_Log, " / file name = ", _fname_Log
         , ")");
         
         return -1;
         
     }

   //debug
   Print("[", __FILE__, ":",__LINE__,"] file => opened (handle = "
   
      , _FILE_HANDLE
      , " / "
      , "file name => "
      , _fname_Log
      , ")"
   
   );

   //-------------------------------------
   // step : 2
   //    validate size
   //-------------------------------------
   //_20190926_095008:tmp
   //ref https://docs.mql4.com/files/filesize
   ulong sizeOf_File = FileSize(_FILE_HANDLE);
   
   //ulong sizeOf_Log_File__max = 1000;
   ulong sizeOf_Log_File__max = 1000 * 200;  // 200k bytes
   
   //-------------------------------------
   // step : 2.1
   //    size of log file ==> more than max ?
   //-------------------------------------
   if(sizeOf_File > sizeOf_Log_File__max)
   //if(false)
     {
      
      //_20190926_101307:fix
      /*-------------------------------------
         step : 2.1 : Y : 1
            *copy log file ==> DROP
            *log text ==> write to a new log file /==> DROP
      -------------------------------------*/
      string fpath_Source__tmp = _dpath_Log + "\\" + _fname_Log;
      //string fname_Dest__tmp = _fname_Log + "(copy)(" + get_TimeLabel_Current(1) + ").copy";
      //string fpath_Dest__tmp = _fname_Log + "(copy)(" + get_TimeLabel_Current(1) + ").copy";
      
      string strOf_Time_Label = (string) get_TimeLabel_Current(1);
      
      string fpath_Dest__tmp = _dpath_Log 
                              + "\\" + _fname_Log 
                              + ".(" + strOf_Time_Label
                              //+ "(copy).(" + strOf_Time_Label
                              //+ "(copy).(" + (string) get_TimeLabel_Current(1) 
                              + ").copy";
      
      int _FILE_HANDLE__tmp = NULL;
      
      /*-------------------------------------
         step : 2.1 : Y : 1.1
            log text ==> read
      -------------------------------------*/
      //string textOf_Log_File = FileReadString(
      
      /*-------------------------------------
         step : 2.1 : Y : 1.2
            new log file : copy
      -------------------------------------*/
      /*-------------------------------------
         step : 2.1 : Y : 1.2 : 1
            close ==> current log file
      -------------------------------------*/
      //_20190927_114131:tmp
      _file_close(_FILE_HANDLE);
      
      //_FILE_HANDLE__tmp =_file_open_2(_FILE_HANDLE__tmp, fname_Dest__tmp, _dpath_Log, _file_Mode, _file_Type);      
      
      /*-------------------------------------
         step : 2.1 : Y : 1.2 : 2
            copy
      -------------------------------------*/
      bool res__tmp = FileCopy(fpath_Source__tmp, 0, fpath_Dest__tmp, 0);
            //_SUBFOLDER + "\\"+ _FNAME, _file_Mode|_file_Type);

      //debug
      Print("[", __FILE__, ":",__LINE__,"] log file ==> copied "
                        + "(" + (string) res__tmp + ")"
                        + " : " + fpath_Dest__tmp 
      
      
      );

      /*-------------------------------------
         step : 2.1 : Y : 2
            close ==> current log file
      -------------------------------------*/
      //_file_close(_FILE_HANDLE);

      /*-------------------------------------
         step : 2.1 : Y : 3
            log file --> re-open
      -------------------------------------*/
      _file_Mode = FILE_WRITE;
      
      _FILE_HANDLE =_file_open_2(_FILE_HANDLE, _fname_Log, _dpath_Log, _file_Mode, _file_Type);

      /*-------------------------------------
         step : 2.1 : Y : 4
            log file : write ""
      -------------------------------------*/
      FileWrite(_FILE_HANDLE, "");

      /*-------------------------------------
         step : 2.1 : Y : 5
            log file : close
      -------------------------------------*/
      _file_close(_FILE_HANDLE);
      
      /*-------------------------------------
         step : 2.1 : Y : 6
            log file : re-open --> _file_Mode = FILE_WRITE|FILE_READ
      -------------------------------------*/
      _file_Mode = FILE_WRITE|FILE_READ;
      
      _FILE_HANDLE =_file_open_2(_FILE_HANDLE, _fname_Log, _dpath_Log, _file_Mode, _file_Type);
      
      
     }//if(sizeOf_File > sizeOf_Log_File__max)
   
   //+----------------------------+
   //| write : body                           |
   //+----------------------------+
   FileWrite(_FILE_HANDLE
   
         , "["
         //, TimeToStr(TimeCurrent(),TIME_SECONDS)
         , TimeToStr(TimeLocal(),TIME_DATE|TIME_SECONDS)
         , " / "
         , fpath_Source, ":"
         , line_Num, "]"
         , body
         
         );

   //+----------------------------+
   //| file : close                           |
   //+----------------------------+
   _file_close(_FILE_HANDLE);

   //+----------------------------+
   //| return                           |
   //+----------------------------+
   return 1;

}//int write_Log(string dpath_Log, string fname_Log, string fpath_Source, int line_Num, string body)

//+------------------------------------------------------------------+
//| int write_Log__No_File_Line_Strings
//    at : 2019/09/04 13:41:17                                                       |
//    @return :
//       1  => log written
//       -1  => file open --> failed
//+------------------------------------------------------------------+
int write_Log__No_File_Line_Strings(
   string _dpath_Log
   , string _fname_Log
//   , string fpath_Source
//   , int line_Num
   , string body) {

//_20190904_134341:caller
//_20190904_134344:head
//_20190904_134350:wl

   //debug
   Print("[", __FILE__, ":",__LINE__,"] file => opening... ", _fname_Log);


   //+----------------------------+
   //| file : open                           |
   //+----------------------------+
   int _FILE_HANDLE = NULL;
   

/*          int _FILE_HANDLE
   , string _FNAME, string _SUBFOLDER
   , int _file_Mode, int _file_Type) */
   
   //int _file_Mode = FILE_WRITE;
   //ref append https://www.mql5.com/en/forum/128204
   int _file_Mode = FILE_WRITE|FILE_READ;
   int _file_Type = FILE_TXT;
   
   _FILE_HANDLE =_file_open_2(_FILE_HANDLE, _fname_Log, _dpath_Log, _file_Mode, _file_Type);
   //_FILE_HANDLE =_file_open(_FILE_HANDLE, _fname_Log, _dpath_Log);

   // validate
   if(_FILE_HANDLE == -1)
     {
         //debug
         Print("[", __FILE__, ":",__LINE__,"] file => can't open (handle = "
         , _FILE_HANDLE, " / dir path = ", _dpath_Log, " / file name = ", _fname_Log
         , ")");
         
         return -1;
         
     }

   //debug
   Print("[", __FILE__, ":",__LINE__,"] file => opened (handle = "
   
      , _FILE_HANDLE
      , " / "
      , "file name => "
      , _fname_Log
      , ")"
   
   );
   
   //+----------------------------+
   //| write : body                           |
   //+----------------------------+
   FileWrite(_FILE_HANDLE
   
//         , "["
//         //, TimeToStr(TimeCurrent(),TIME_SECONDS)
//         , TimeToStr(TimeLocal(),TIME_DATE|TIME_SECONDS)
//         , " / "
//         , fpath_Source, ":"
//         , line_Num, "]"
         , body
         
         );

   //+----------------------------+
   //| file : close                           |
   //+----------------------------+
   _file_close(_FILE_HANDLE);

   //+----------------------------+
   //| return                           |
   //+----------------------------+
   return 1;

}//int write_Log__No_File_Line_Strings(string dpath_Log, string fname_Log, string fpath_Source, int line_Num, string body)

//+------------------------------------------------------------------+
//|                                                          |
//+------------------------------------------------------------------+
bool _is_NewBar() {

   //ref https://www.mql5.com/en/articles/159
   static datetime last_time=0;
   
   datetime lastbar_time = (datetime) SeriesInfoInteger(Symbol(),Period(),SERIES_LASTBAR_DATE);

   // debug
   //string txt_utils = "last_time = ", last_time, " / ", "lastbar_time = ", lastbar_time;
   string txt_utils = "last_time = " + (string)last_time 
               + " / "
                + "lastbar_time = " + (string)lastbar_time;

/*   
   write_Log(
         dpath_Log
         //, fname_Log
         , fname_Log_For_Session
         , __FILE__
         , __LINE__
         , txt);
*/
   //debug
   //Print("[", __FILE__, ":",__LINE__,"] SeriesInfoInteger => ", lastbar_time);
   
//--- if it is the first call of the function
   if(last_time==0)
     {
      //--- set the time and exit
      last_time=lastbar_time;
      return(false);
     }

//--- if the time differs
   if(last_time!=lastbar_time)
     {
     
     
      //--- memorize the time and return true
      last_time=lastbar_time;
      
      
      return(true);
     }
//--- if we passed to this line, then the bar is not new; return false
   return(false);   
   
   //debug
   //Alert("[", __FILE__, ":",__LINE__,"] SeriesInfoInteger => ", lastbar_time);

}//_is_NewBar()

//+------------------------------------------------------------------+
//| _is_Above_BB_1S()          

/*
   params :
         Symbol()
         , Period()
         , period_BB
         , _deviation   // deviation //ref https://docs.mql4.com/constants/indicatorconstants/lines
         
         , 0
         , _BB_price
         , _mode   // mode
         , _shift
         , _target_price
*/

//+------------------------------------------------------------------+
bool is_Above_BB_X(
         string _symbol
         , int _period
         , int _period_BB
         , double _deviation
         
         , int _band_shift
         , int _BB_price
         , int _mode
         , int _shift
         , float _target_price
         
         , string _dpath_Log
         , string _fname_Log_For_Session
         ) {

   int index = 0;

   int deviation = 1;

   //float close_Latest = (float) Close[index];
   float close_Latest = _target_price;
   
   int   period_BB = 20;
   
   //ref https://docs.mql4.com/indicators/ibands
   //float BB_1S = (float) iBands(Symbol(),Period(), period_BB, 0,0,PRICE_CLOSE,MODE_MAIN, index);
   //float BB_1S = (float) iBands(
   float BB_Val = (float) iBands(
               _symbol
               , _period
               , _period_BB
               , _deviation   // deviation //ref https://docs.mql4.com/constants/indicatorconstants/lines
               , _band_shift
               , _BB_price
               , _mode   // mode
               , _shift);
            /*   
               string       symbol,           // symbol
               int          timeframe,        // timeframe
               int          period,           // averaging period
               double       deviation,        // standard deviations
               int          bands_shift,      // bands shift
               int          applied_price,    // applied price
               int          mode,             // line index
               int          shift             // shift
            */
   // judge
   bool judge = (close_Latest > BB_Val);
   
   //debug
   //Alert("[", __FILE__, ":",__LINE__,"] "
   //char _char[50];
   //sprintf(_char, "latest close : %.03f", close_Latest);
         //'sprintf' - function not defined	ea-1_up-up-buy.mq4	160	4

   Print("[", __FILE__, ":",__LINE__,"] "
         
         , "target closing price => ", (string) close_Latest
         , " / "
         , "BB_Val => ", (string) BB_Val
         , " ("
         , "mode = ", (string) _mode
         , ")"
         );

   // debug
   string txt_utils = "\n"
         + "_deviation : " + (string) _deviation
         + " / "
         + "_target_price : " + (string) _target_price
         + " / "
         + "BB_Val : " + (string) BB_Val
         + " / "
            ;
   
   write_Log(
         _dpath_Log
         //, fname_Log
         , _fname_Log_For_Session
         , __FILE__
         , __LINE__
         , txt_utils);

   // return
   return judge;

}//bool is_Above_BB_X(

/*

2019/02/03 08:33:22
func-list.(utils.mqh).20190203_083322.txt
==========================================
<funcs>

1)	string _CURRENT_PERIOD, int _NUMOF_DAYS,
2)	int _NUMOF_TARGET_BARS, string _TIME_LABEL,
3)	string _SUBFOLDER, string _MAIN_LABEL,
4)	int _TIME_FRAME) {
5)	void _file_close(int _FILE_HANDLE)
6)	int _file_open(int _FILE_HANDLE, string _FNAME, string _SUBFOLDER)
7)	int _file_open_2(
8)	int _file_write__header(int _FILE_HANDLE)
9)	int _file_write__header_2(int _FILE_HANDLE,
10)	int _file_write__header_With_RSI(
11)	int _file_write__header_With_RSI_BB(
12)	int _file_write__header_With_RSI_BB_MFI(
13)	string _get_FNAME(
14)	string _get_FNAME__Shifted(
15)	bool _is_NewBar() {
16)	string _symbol_Str, int _pastXBars,
17)	string conv_DateTime_2_SerialTimeLabel(int time) {
18)	void conv_Index_2_TimeString(int index, int __TIME_FRAME, string __Symbol) {
19)	int conv_TimeString_2_Index
20)	int conv_TimeString_2_Index
21)	void get_ArrayOf_BarData_Basic
22)	void get_ArrayOf_BarData_Basic_2
23)	int get_AryOf_RSI(
24)	int get_AryOf_RSI_BB(
25)	int get_AryOf_RSI_BB_MFI(
26)	int get_AryOf_RSI_BB_MFI__Shifted(
27)	void get_BasicData_with_RSI(
28)	void get_BasicData_with_RSI_BB(
29)	void get_BasicData_with_RSI_BB_MFI(
30)	void get_BasicData_with_RSI_BB_MFI__Shifted(
31)	string get_TimeLabel_Current(int type) {
32)	string get_TimeLabel_Current(int type)
33)	int get_index
34)	bool is_Above_BB_X(
35)	int set_Symbol(string symbol_str, int period) {
36)	int set_Symbol(string symbol_str, int period)
37)	int write2File_AryOf_BasicData
38)	int write2File_AryOf_BasicData_2
39)	int write2File_AryOf_BasicData_With_RSI(
40)	int write2File_AryOf_BasicData_With_RSI_BB(
41)	int write2File_AryOf_BasicData_With_RSI_BB_MFI(
42)	int write2File_AryOf_BasicData_With_RSI_BB_MFI__Shifted(
43)	int write_Log(
=======
2019/01/25 10:44:57
==========================================
<funcs>

1	string _CURRENT_PERIOD, int _NUMOF_DAYS,
2	int _NUMOF_TARGET_BARS, string _TIME_LABEL,
3	string _SUBFOLDER, string _MAIN_LABEL,
4	int _TIME_FRAME)
5	void _file_close(int _FILE_HANDLE)
6	int _file_open(int _FILE_HANDLE, string _FNAME, string _SUBFOLDER)
7	int _file_open_2(
8	int _file_write__header(int _FILE_HANDLE)
9	int _file_write__header_2(int _FILE_HANDLE,
10	int _file_write__header_With_RSI(
11	int _file_write__header_With_RSI_BB(
12	int _file_write__header_With_RSI_BB_MFI(
13	string _get_FNAME(
14	string _get_FNAME__Shifted(
15	bool _is_NewBar()
16	string _symbol_Str, int _pastXBars,
17	string conv_DateTime_2_SerialTimeLabel(int time)
18	void conv_Index_2_TimeString(int index, int __TIME_FRAME, string __Symbol)
19	int conv_TimeString_2_Index
20	int conv_TimeString_2_Index
21	void get_ArrayOf_BarData_Basic
22	void get_ArrayOf_BarData_Basic_2
23	int get_AryOf_RSI(
24	int get_AryOf_RSI_BB(
25	int get_AryOf_RSI_BB_MFI(
26	int get_AryOf_RSI_BB_MFI__Shifted(
27	void get_BarData_Basic(int index, double
28	void get_BasicData_with_RSI(
29	void get_BasicData_with_RSI_BB(
30	void get_BasicData_with_RSI_BB_MFI(
31	void get_BasicData_with_RSI_BB_MFI__Shifted(
32	string get_TimeLabel_Current(int type)
33	string get_TimeLabel_Current(int type)
34	int get_index
35	bool is_Above_BB_X(
36	int set_Symbol(string symbol_str, int period)
37	int write2File_AryOf_BasicData
38	int write2File_AryOf_BasicData_2
39	int write2File_AryOf_BasicData_With_RSI(
40	int write2File_AryOf_BasicData_With_RSI_BB(
41	int write2File_AryOf_BasicData_With_RSI_BB_MFI(
42	int write2File_AryOf_BasicData_With_RSI_BB_MFI__Shifted(
43	int write_Log(

==========================================
==========================================
<vars>


==========================================
==========================================
<externs>


==========================================
*/
