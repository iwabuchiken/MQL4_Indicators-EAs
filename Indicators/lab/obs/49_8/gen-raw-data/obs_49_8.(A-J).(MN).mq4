//--------------------------------------------------------------------
//    loc   :  C:\Users\iwabuchiken\AppData\Roaming\MetaQuotes\Terminal\34B08C83A5AAE27A4079DE708E60511E\MQL4\Indicators\lab\24_16
//    file  :  t_24_15.mq4
//    time  :  2017/11/10 11:34:19
//    generated files : C:\Users\iwabuchiken\AppData\Roaming\MetaQuotes\Terminal\34B08C83A5AAE27A4079DE708E60511E\MQL4\Files\Research
// 
// <Usage>
// - 
// <steps>
//    1. update
//          *1) comment block: file name, created-at string
//          *2) "SUBFOLDER" value
//          *2-2) "FNAME" value
//          *3) "string title" value
//          4) _file_write__header() --> column names
//          5) _file_write__data() --> edit variables

//--------------------------------------------------------------------
//+------------------------------------------------------------------+
//| Includes                                                                 |
//+------------------------------------------------------------------+
#include <utils.mqh>

//+------------------------------------------------------------------+
//| vars                                                                 |
//+------------------------------------------------------------------+
extern int Period_MA=21;            // Calculated MA period

int HOURS_PER_DAY=24;

int HIT_INDICES[];   // indices of matched bars

                     // counter
int NUMOF_HIT_INDICES=0;

int FILE_HANDLE;

//+------------------------------------------------------------------+
//| infra vars                                                                 |
//+------------------------------------------------------------------+
int      NUMOF_BARS_PER_HOUR =1;        // default: 1 bar per hour

int      NUMOF_TARGET_BARS=0;

string   FNAME;

string   session_ID = "24_16";

string   FNAME_THIS = "t_" + session_ID + ".(1).mq4";

string   STRING_TIME;

datetime T;

//string DATA[][6];

int      NUMOF_DATA;

// current PERIOD
string   CURRENT_PERIOD = "";   // "D1", "H1", etc.

string   TIME_LABEL = "";

//string MAIN_LABEL = "file-io";

string dpath_Log = "Logs";
//C:\Users\iwabuchiken\AppData\Roaming\MetaQuotes\Terminal\34B08C83A5AAE27A4079DE708E60511E\MQL4\Logs
string fname_Log = "dev.log";

//+------------------------------------------------------------------+
//| input vars                                                                 |
//+------------------------------------------------------------------+
//input int      NUMOF_DAYS  = 365; // 1 year
//input int      NUMOF_DAYS  = 60;    // 2 months
//input int      NUMOF_DAYS  = 180;    // 6 months
//input int      NUMOF_DAYS  = 180;    // Num of bars
//input int      NUMOF_DAYS  = 10000;    // Num of bars
input int      NUMOF_DAYS  = 200;    // Num of bars

// default: PERIOD_H1
//input int      TIME_FRAME=60;
input int      TIME_FRAME  = 43200;  // Time frame (MN1)
//input int      TIME_FRAME  = 10080;  // W1
//input int      TIME_FRAME  = 1440;  // 1 day
//input int      TIME_FRAME  = 1;  // 1 min
//input int      TIME_FRAME  = 5;  // 5 min
//input int      TIME_FRAME  = 15;  // 15 min
//input int      TIME_FRAME  = 60;  // 60 min

// BB period (Bollinger Band)
input int      BB_PERIOD = 25;

// 
input string   SUBFOLDER   = "obs/44_/44_5.1_10";      // subfolder name ---> same as sessin_ID
input string   SYMBOL_STR="AUDJPY";
//input string   SYMBOL_STR="USDJPY";
//input string   SYMBOL_STR="EURUSD";
//input string   SYMBOL_STR="EURJPY";
input string MAIN_LABEL = "rawdata";
//input string MAIN_LABEL = "data";
//input string MAIN_LABEL = "file-io";

input int      RSI_PERIOD     = 20;

input int      RSI_THRESHOLD  = 75;

input string   SPAN_START     = "2016.04.01 00:00";

input string   SPAN_END     = "2016.10.31 23:00";

input bool     WRITE_DATA_TO_FILE = true;

//--------------------------------------------------------------------
int init() {

   //+------------------------------------------------------------------+
   //| setup
   //+------------------------------------------------------------------+
   setup();

   //debug
   Alert("[", __FILE__, ":",__LINE__,"] NUMOF_TARGET_BARS => ", NUMOF_TARGET_BARS);
   
   //debug
   Alert("[", __FILE__, ":",__LINE__,"] init() done");

   //ref return value -> https://www.mql5.com/en/forum/55560   
   return 0;
  
}//int init()

//void test_4(string symbol_Str) {
void get_BasicData_with_RSI(string symbol_Str) {

   //double   AryOf_BasicData[][4];
   double   AryOf_BasicData[][5];

   // get data
   int pastXBars = NUMOF_DAYS;
   
   FNAME = _get_FNAME(
               SUBFOLDER, MAIN_LABEL, symbol_Str, 
               CURRENT_PERIOD, NUMOF_DAYS, 
               NUMOF_TARGET_BARS, TIME_LABEL);
//ccc
    //debug
    Alert("[", __FILE__, ":",__LINE__,"] FNAME => ", FNAME);
    
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
   int length = NUMOF_DAYS;
   
   //debug
   Alert("[", __FILE__, ":",__LINE__,"] calling ---> get_AryOf_RSI");
   
      
   get_AryOf_RSI(
            SYMBOL_STR, 
            (int) CURRENT_PERIOD, 
            period_RSI, 
            price_Target, 
            shift, 
            length,
            AryOf_Data);


    /******************
      data ---> write to file
    ******************/
   write2File_AryOf_BasicData_With_RSI(
      FNAME, SUBFOLDER, AryOf_Data
      
      , length, shift
            
      , SYMBOL_STR
      
      , CURRENT_PERIOD
      
      , NUMOF_DAYS
      
      , NUMOF_TARGET_BARS
      
      , TIME_LABEL
      
      , TIME_FRAME

   );

   
   
   //debug
   Alert("[", __FILE__, ":",__LINE__,"] get_BasicData_with_RSI() => done");
   
}//void get_BasicData_with_RSI

int exec() {

   //+------------------------------------------------------------------+
   //| vars
   //+------------------------------------------------------------------+

   //+------------------------------------------------------------------+
   //| setup
   //+------------------------------------------------------------------+
   //+---------------------------------+
   //| setup   : file
   //+---------------------------------+
   T = TimeLocal();
   
   TIME_LABEL = conv_DateTime_2_SerialTimeLabel((int)T);
   
   //string main_Label = "file-io";
   string main_Label = MAIN_LABEL;
   
   FNAME = _get_FNAME(
               SUBFOLDER, main_Label, SYMBOL_STR, 
               CURRENT_PERIOD, NUMOF_DAYS, 
               NUMOF_TARGET_BARS, TIME_LABEL);

    //debug
    Alert("[", __FILE__, ":",__LINE__,"] FNAME => ", FNAME);
   
   //+------------------------------------------------------------------+
   //| get : array of basic bar data
   //+------------------------------------------------------------------+
   //get_BasicData_with_RSI(SYMBOL_STR);
	string _symbol_Str   = SYMBOL_STR;
	int _pastXBars       = NUMOF_DAYS;
	string _SUBFOLDER    = SUBFOLDER;
	string _MAIN_LABEL   = MAIN_LABEL;
	string _CURRENT_PERIOD  = CURRENT_PERIOD;
	int _NUMOF_DAYS      = NUMOF_DAYS;
	int _NUMOF_TARGET_BARS  = NUMOF_TARGET_BARS;
	string _TIME_LABEL      = TIME_LABEL;
	int _TIME_FRAME      = TIME_FRAME;
   
   /********************************
      gen data : _NUMOF_DAYS = 1 
   ********************************/
/*
   int tmp_NumOf_Days = 1;
   
   get_BasicData_with_RSI_BB_MFI(
       _symbol_Str,  _pastXBars,
       _SUBFOLDER,  _MAIN_LABEL,
       //_CURRENT_PERIOD,  _NUMOF_DAYS,
       _CURRENT_PERIOD,  tmp_NumOf_Days,
       _NUMOF_TARGET_BARS,  _TIME_LABEL,
       _TIME_FRAME);
*/

   /********************************
      gen data : TEST
   ********************************/
/*
   string str_Symbol = "GBPJPY";
   
   int tmp_NumOf_Days = 1;
   
   get_BasicData_with_RSI_BB_MFI(
       str_Symbol,  _pastXBars,
       _SUBFOLDER,  _MAIN_LABEL,
       _CURRENT_PERIOD,  tmp_NumOf_Days,
       _NUMOF_TARGET_BARS,  _TIME_LABEL,
       _TIME_FRAME);
*/

   /********************************
      gen data : TEST
   ********************************/
   string str_Symbol = "GBPJPY";
   
   int tmp_NumOf_Days[3] = {1,3,5};
   
   
   for(int  i =0; i < 3; i ++)
     {

         get_BasicData_with_RSI_BB_MFI(
             str_Symbol,  _pastXBars,
             _SUBFOLDER,  _MAIN_LABEL,
             _CURRENT_PERIOD,  tmp_NumOf_Days[i],
             _NUMOF_TARGET_BARS,  _TIME_LABEL,
             _TIME_FRAME);
      
     }
   

   /********************************
      gen data : 
   ********************************/
   get_BasicData_with_RSI_BB_MFI(
       _symbol_Str,  _pastXBars,
       _SUBFOLDER,  _MAIN_LABEL,
       _CURRENT_PERIOD,  _NUMOF_DAYS,
       _NUMOF_TARGET_BARS,  _TIME_LABEL,
       _TIME_FRAME);
   
   
   return   0;

}//exec()

 // Special function start()
int start()
  {
  
         //+------------------------------------------------------------------+
         //| setup
         //+------------------------------------------------------------------+
         //setup();
         //Alert("[",__LINE__,"] starting...");
   
   
         //+------------------------------------------------------------------+
         //| operations                                                                 |
         //+------------------------------------------------------------------+
         //exec();
         //+------------------------------------------------------------------+
         //| terminating the loop                                                                 |
         //+------------------------------------------------------------------+

//--------------------------------------------------------------------
   return 0;                            // Exit start()

  }//int start()
//--------------------------------------------------------------------

void _setup__BasicParams() {

   /*
      debug
   */
   string txt = "\n_setup__BasicParams ============";
   
   // debug
   write_Log(
   dpath_Log
   , fname_Log
   , __FILE__
   , __LINE__
   , txt);
   //, name);

   // debug
   txt = "time frame => " + (string)TIME_FRAME;
   
   // debug
   write_Log(
      dpath_Log
      , fname_Log
      , __FILE__
      , __LINE__
      , txt);
      //, name);


   int res;
   
   switch(TIME_FRAME)
/*
   #ref https://www.mql5.com/en/forum/140787
   PERIOD_M1   1
   PERIOD_M5   5
   PERIOD_M15  15
   PERIOD_M30  30 
   PERIOD_H1   60
   PERIOD_H4   240
   PERIOD_D1   1440
   PERIOD_W1   10080
   PERIOD_MN1  43200
   */
     {
      case  5:      // 5 minutes

         NUMOF_TARGET_BARS = NUMOF_DAYS;
         
         //ChartSetSymbolPeriod(0,SYMBOL_STR,PERIOD_H1);  // set symbol
         res = set_Symbol(SYMBOL_STR, PERIOD_M5);
         
         //debug
         Alert("[", __FILE__, ":",__LINE__,"] symbol set => ", SYMBOL_STR);
         
         // period name
         CURRENT_PERIOD = "M5";

         break;

      case  15:      // 15 minutes
                     // ref https://docs.mql4.com/constants/chartconstants/enum_timeframes

         NUMOF_TARGET_BARS = NUMOF_DAYS;
         
         //ChartSetSymbolPeriod(0,SYMBOL_STR,PERIOD_H1);  // set symbol
         res = set_Symbol(SYMBOL_STR, PERIOD_M15);
         
         //debug
         Alert("[", __FILE__, ":",__LINE__,"] symbol set => ", SYMBOL_STR);
         
         // period name
         CURRENT_PERIOD = "M15";

         break;

      case  30:      // 30 minutes

         NUMOF_TARGET_BARS = NUMOF_DAYS;
         
         //ChartSetSymbolPeriod(0,SYMBOL_STR,PERIOD_H1);  // set symbol
         res = set_Symbol(SYMBOL_STR, PERIOD_M30);
         
         //debug
         Alert("[", __FILE__, ":",__LINE__,"] symbol set => ", SYMBOL_STR);
         
         // period name
         CURRENT_PERIOD = "M30";

         //debug
         txt = "breaking switch loop (CURRENT_PERIOD = " + CURRENT_PERIOD + ")";
         
         // debug
         write_Log(
            dpath_Log, fname_Log
            , __FILE__, __LINE__
            , txt);
            //, name);

         break;

      case  60:      // 1 hour

         NUMOF_TARGET_BARS=NUMOF_DAYS*24;
         
         //ChartSetSymbolPeriod(0,SYMBOL_STR,PERIOD_H1);  // set symbol
         res = set_Symbol(SYMBOL_STR, PERIOD_H1);
         
         //debug
         Alert("[", __FILE__, ":",__LINE__,"] symbol set => ", SYMBOL_STR);
         
         // period name
         CURRENT_PERIOD = "H1";

         break;

      case  240: // 4 hours

         NUMOF_TARGET_BARS = NUMOF_DAYS * 6;
         
         //ChartSetSymbolPeriod(0,SYMBOL_STR,PERIOD_H4);  // set symbol
         res = set_Symbol(SYMBOL_STR, PERIOD_H4);
         
         //debug
         Alert("[", __FILE__, ":",__LINE__,"] symbol set => ", SYMBOL_STR);

         // period name
         CURRENT_PERIOD = "H4";

         break;

      case  480: // 8 hours

         NUMOF_TARGET_BARS = NUMOF_DAYS*3;
         
         //ChartSetSymbolPeriod(0,SYMBOL_STR,PERIOD_H8);  // set symbol
         res = set_Symbol(SYMBOL_STR, PERIOD_H8);
         
         //debug
         Alert("[", __FILE__, ":",__LINE__,"] symbol set => ", SYMBOL_STR);
         
         // period name
         CURRENT_PERIOD = "H8";

         break;

      case  1440: // 1 day

         NUMOF_TARGET_BARS = NUMOF_DAYS;
         
         //ChartSetSymbolPeriod(0,SYMBOL_STR,PERIOD_D1);  // set symbol
         res = set_Symbol(SYMBOL_STR, PERIOD_D1);
         
         //debug
         Alert("[", __FILE__, ":",__LINE__,"] symbol set => ", SYMBOL_STR);


         // period name
         CURRENT_PERIOD = "D1";

         break;

      case  10080: // 1 week

         //ref https://www.mql5.com/en/forum/151559
         //NUMOF_TARGET_BARS = (int) NUMOF_DAYS / 7;
         NUMOF_TARGET_BARS = NUMOF_DAYS;
         
         //ChartSetSymbolPeriod(0,SYMBOL_STR,PERIOD_W1);  // set symbol
         res = set_Symbol(SYMBOL_STR, PERIOD_W1);
         
         //debug
         Alert("[", __FILE__, ":",__LINE__,"] symbol set => ", SYMBOL_STR);

         // period name
         CURRENT_PERIOD = "W1";

         break;

      case  43200: // 1 month

         //ref https://www.mql5.com/en/forum/151559
         //NUMOF_TARGET_BARS = (int) NUMOF_DAYS / 7;
         NUMOF_TARGET_BARS = NUMOF_DAYS;
         
         //ChartSetSymbolPeriod(0,SYMBOL_STR,PERIOD_W1);  // set symbol
         res = set_Symbol(SYMBOL_STR, PERIOD_MN1);
         
         //debug
         Alert("[", __FILE__, ":",__LINE__,"] symbol set => ", SYMBOL_STR);

         // period name
         CURRENT_PERIOD = "MN1";

         break;

      case  1: // 1 minute: "NUMOF_DAYS" value is now interpreted as
         //             "NUMOF_HOURS"

         NUMOF_TARGET_BARS=NUMOF_DAYS*60;
         
         //ChartSetSymbolPeriod(0,SYMBOL_STR,PERIOD_M1);  // set symbol
         res = set_Symbol(SYMBOL_STR, PERIOD_M1);
         
         //debug
         Alert("[", __FILE__, ":",__LINE__,"] symbol set => ", SYMBOL_STR);
         

         // period name
         CURRENT_PERIOD = "M1";

         break;

      default:

         NUMOF_TARGET_BARS=NUMOF_DAYS*24;
         
         //ChartSetSymbolPeriod(0,SYMBOL_STR,PERIOD_H1);  // set symbol
         res = set_Symbol(SYMBOL_STR, PERIOD_H1);
         
         //debug
         Alert("[", __FILE__, ":",__LINE__,"] symbol set => ", SYMBOL_STR);

         // period name
         CURRENT_PERIOD = "H1";

         break;
     }

}//void _setup__BasicParams()

//ref about "tick" --> https://www.mql5.com/en/forum/109552
void setup() 
  {
  
   //+------------------------------------------------------------------+
   //| opening message
   //+------------------------------------------------------------------+
   //Alert("starting TR-5.mq4");
   Alert("[", __FILE__, ":",__LINE__,"] starting" + " " + FNAME_THIS);

   //+------------------------------------------------------------------+
   //| set: time frame
   //+------------------------------------------------------------------+
   _setup__BasicParams();
   
   //+------------------------------------------------------------------+
   //|                                                                  |
   //+------------------------------------------------------------------+
   Alert("[", __FILE__, ":",__LINE__,"] symbol = ",SYMBOL_STR,""
   
            + " / RSI threshold = ",RSI_THRESHOLD,""
            + " / PERIOD = ",Period(),""         
            
         );

//+------------------------------------------------------------------+
//| Array
//+------------------------------------------------------------------+
   ArrayResize(HIT_INDICES,NUMOF_TARGET_BARS);

   //+------------------------------------------------------------------+
   //| operations                                                                 |
   //+------------------------------------------------------------------+
   exec();
   

}//setup

/*
2019/02/03 09:26:16
func-list.(obs_49_8.mq4).20190203_092616.txt
==========================================
<funcs>

1)	void _setup__BasicParams() {
2)	int exec() {
3)	void get_BasicData_with_RSI(string symbol_Str) {
4)	int init() {
5)	void setup()

==========================================
==========================================
<vars>

1)	string dpath_Log = "Logs";
2)	string fname_Log = "dev.log";

==========================================
==========================================
<externs, inputs>

1)	input int      BB_PERIOD = 25;
2)	input string MAIN_LABEL = "data";
3)	input int      NUMOF_DAYS  = 180;    // Num of bars
4)	extern int Period_MA=21;            // Calculated MA period
5)	input int      RSI_PERIOD     = 20;
6)	input int      RSI_THRESHOLD  = 75;
7)	input string   SPAN_END     = "2016.10.31 23:00";
8)	input string   SPAN_START     = "2016.04.01 00:00";
9)	input string   SUBFOLDER   = "obs/44_/44_5.1_10";      // subfolder name ---> same as sessin_ID
10)	input string   SYMBOL_STR="AUDJPY";
11)	input int      TIME_FRAME  = 43200;  // MN1
12)	input bool     WRITE_DATA_TO_FILE = true;

==========================================
*/
