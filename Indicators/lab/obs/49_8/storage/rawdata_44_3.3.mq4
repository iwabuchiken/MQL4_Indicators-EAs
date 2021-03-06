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
int      NUMOF_BARS_PER_HOUR　=1;        // default: 1 bar per hour

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

string MAIN_LABEL = "file-io";

// "extern" --> this variable is used also in utils.mqh 20180902_141253
extern string dpath_Log = "Logs";
//string dpath_Log = "Logs";
//C:\Users\iwabuchiken\AppData\Roaming\MetaQuotes\Terminal\34B08C83A5AAE27A4079DE708E60511E\MQL4\Logs
extern string fname_Log = "dev.log";

string   SYMBOL_STR = "USDJPY";

//string symbols[] = {"USDJPY", "EURJPY", "EURUSD", "AUDJPY", "GBPJPY"};
string symbols[] = {"USDJPY", "EURJPY"};

//string symbol_Sets[][3] = {

//const string numOf_Days = "2000";
#define numOf_Days "3000"

#define  __SYMBOL_SETS_X 10
//int symbol_Sets_X = 8;
int symbol_Sets_Y = 3;
//string symbol_Sets[8][3] = {
string symbol_Sets[__SYMBOL_SETS_X][3] = {
/*
            {"USDJPY", "5", numOf_Days}
            , {"USDJPY", "60", numOf_Days}

            , {"EURJPY", "5", numOf_Days}
            , {"EURJPY", "60", numOf_Days}


            , {"EURUSD", "5", numOf_Days}
            , {"EURUSD", "60", numOf_Days}

            , {"AUDJPY", "5", numOf_Days}
            , {"AUDJPY", "60", numOf_Days}
*/
            , {"GBPJPY", "5", numOf_Days}
            , {"GBPJPY", "60", numOf_Days}

/*
            {"USDJPY", "5", "2000"}
            , {"USDJPY", "60", "2000"}

            , {"EURJPY", "5", "2000"}
            , {"EURJPY", "60", "2000"}


            , {"EURUSD", "5", "2000"}
            , {"EURUSD", "60", "2000"}
*/
/*            
            , {"AUDJPY", "5", "1000"}
            , {"AUDJPY", "60", "1000"}
*/            
            };

//int timeframes[] = {5, 15, 30, 60};
int timeframes[] = {5, 60};

int      TIME_FRAME  = 1440;  // Time frame

string   SUBFOLDER   = "obs/44_/44_3.2_15";      // subfolder name ---> same as sessin_ID

int      NUMOF_DAYS  = 180;    // Num of bars

//+------------------------------------------------------------------+
//| input vars                                                                 |
//+------------------------------------------------------------------+

//input int      NUMOF_DAYS  = 365; // 1 year
//input int      NUMOF_DAYS  = 60;    // 2 months
//input int      NUMOF_DAYS  = 180;    // 6 months
//input int      NUMOF_DAYS  = 180;    // Num of bars

// default: PERIOD_H1
//input int      TIME_FRAME=60;
//input int      TIME_FRAME  = 1440;  // 1 day
//input int      TIME_FRAME  = 1440;  // Time frame


// BB period (Bollinger Band)
input int      BB_PERIOD = 25;

//input string   SUBFOLDER   = "24_16";      // subfolder name ---> same as sessin_ID
//input string   SUBFOLDER   = "obs/49_6";      // subfolder name ---> same as sessin_ID
//input string   SUBFOLDER   = "obs\\49_6";      // subfolder name ---> same as sessin_ID

input int      RSI_PERIOD     = 20;

input int      RSI_THRESHOLD  = 75;

input string   SPAN_START     = "2016.04.01 00:00";

input string   SPAN_END     = "2016.10.31 23:00";

input bool     WRITE_DATA_TO_FILE = true;

//--------------------------------------------------------------------
int init() {

   // debug
   string txt = "\n****************** init() ************************************************";
   
   // debug
   write_Log(
         dpath_Log
         , fname_Log
         , __FILE__
         , __LINE__
         , txt);
         //, name);


   //+------------------------------------------------------------------+
   //| setup
   //+------------------------------------------------------------------+
   //setup();
   //setup_2();
   setup_3();

/*
   //debug
   Alert("[", __FILE__, ":",__LINE__,"] NUMOF_TARGET_BARS => ", NUMOF_TARGET_BARS);
   
   //debug
   Alert("[", __FILE__, ":",__LINE__,"] init() done");
*/
   //ref return value -> https://www.mql5.com/en/forum/55560   
   return 0;
  
}//int init()


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
   
   
   get_BasicData_with_RSI_BB_MFI(
       _symbol_Str,  _pastXBars,
       _SUBFOLDER,  _MAIN_LABEL,
       _CURRENT_PERIOD,  _NUMOF_DAYS,
       _NUMOF_TARGET_BARS,  _TIME_LABEL,
       _TIME_FRAME);
   
   
   
   return   0;

}//exec()

int start() // Special function start()
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


void _setup__BasicParams_2(string _SYMBOL_STRING, int _TIME_FRAME) {

   /*
      debug
   */
   string txt = "\n_setup__BasicParams_2 ============";
   
   // debug
   write_Log(
         dpath_Log
         , fname_Log
         , __FILE__
         , __LINE__
         , txt);
         //, name);

   // debug
   txt = "time frame => " + (string)_TIME_FRAME
   
         + " / "
         + "symbol => "
         + _SYMBOL_STRING
   ;
   
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

}//void _setup__BasicParams_2()

//ref about "tick" --> https://www.mql5.com/en/forum/109552

void setup_2() 
  {
  
   //+------------------------------------------------------------------+
   //| opening message
   //+------------------------------------------------------------------+
   //Alert("starting TR-5.mq4");
   Alert("[", __FILE__, ":",__LINE__,"] starting" + " " + FNAME_THIS);

   //+------------------------------------------------------------------+
   //| set: time frame
   //+------------------------------------------------------------------+
   //_setup__BasicParams();

   // symbols
   //string symbols[] = {"USDJPY", "EURJPY", "EURUSD", "AUDJPY", "GBPJPY"};
   
   int numOf_Symbols = sizeof(symbols) / sizeof(string);

   // time frames
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
   
   //int timeframes[] = {5, 15, 30, 60};
   int numOf_Timeframes = sizeof(timeframes) / sizeof(int);
   
   // loop : symbols
   for(int i = 0; i < numOf_Symbols; i++)
     {
         string _symbol = symbols[i];
         
         // set SYMBOL_STR
         SYMBOL_STR = _symbol;
         
         // loop : time frames
         for(int j = 0; j < numOf_Timeframes; j++)
           {
               int _timeframe = timeframes[j];
               
               // assign
               TIME_FRAME = _timeframe;
               
               // debug
               string txt = "i = " + (string) i
                           + " / "
                           + "j = " + (string) j;
               
               // debug
               write_Log(
                     dpath_Log
                     , fname_Log
                     , __FILE__
                     , __LINE__
                     , txt);
                     //, name);

               // setup : params
               _setup__BasicParams_2(_symbol, _timeframe);
               
               // exec : gen csv files
               exec();
               
           }
         //_setup__BasicParams_2(_symbol, 5);
         
     }
   
   //_setup__BasicParams_2("USDJPY", 5);
   
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
   //exec();
   

}//setup_2

void setup_3() 
  {
  
   //+------------------------------------------------------------------+
   //| opening message
   //+------------------------------------------------------------------+
   //Alert("starting TR-5.mq4");
   Alert("[", __FILE__, ":",__LINE__,"] starting" + " " + FNAME_THIS);

   //+------------------------------------------------------------------+
   //| set: time frame
   //+------------------------------------------------------------------+
   //_setup__BasicParams();

   // symbols
   //string symbols[] = {"USDJPY", "EURJPY", "EURUSD", "AUDJPY", "GBPJPY"};
   
   int numOf_Symbols = sizeof(symbols) / sizeof(string);

   // time frames
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
   
   //int numOf_Symbol_Sets = sizeof(symbol_Sets) / sizeof(symbol_Sets[0]);
   //int numOf_Symbol_Sets = symbol_Sets_X;
   int numOf_Symbol_Sets = __SYMBOL_SETS_X;
   
   //debug
   Alert("[", __FILE__, ":",__LINE__,"] numOf_Symbol_Sets => ", (string) numOf_Symbol_Sets);

   // loop
   for(int i = 0; i < numOf_Symbol_Sets; i++)
     {
         // get : params
         //string _symbol_sets = symbol_Sets[i];
         string _symbol = symbol_Sets[i][0];
         int _timeframe = (int) symbol_Sets[i][1];
         int _numofdays = (int) symbol_Sets[i][2];
         
         // set : params
         SYMBOL_STR = _symbol;
         TIME_FRAME = _timeframe;
         NUMOF_DAYS = _numofdays;
      
         // debug
         string txt = "i = " + (string) i
                  + " / "
                  + "symbol = " + _symbol
                  + " / "
                  + "_timeframe = " + (string) _timeframe
                  + " / "
                  + "_numofdays = " + (string) _numofdays
                  ;
         
         // debug
         write_Log(dpath_Log, fname_Log
               , __FILE__, __LINE__
               , txt);
               //, name);
               
         // resize
         ArrayResize(HIT_INDICES,NUMOF_TARGET_BARS);


         //+------------------------------------------------------------------+
         //| operations                                                                 |
         //+------------------------------------------------------------------+
         
         // setup : params
         _setup__BasicParams_2(_symbol, _timeframe);
         
         // execute
         exec();
      
     }//for(int i = 0; i < numOf_Symbol_Sets; i++)

   //return;
/*   
   // loop : symbols
   for(int i = 0; i < numOf_Symbols; i++)
     {
         string _symbol = symbols[i];
         
         // set SYMBOL_STR
         SYMBOL_STR = _symbol;
         
         // loop : time frames
         for(int j = 0; j < numOf_Timeframes; j++)
           {
               int _timeframe = timeframes[j];
               
               // assign
               TIME_FRAME = _timeframe;
               
               // debug
               string txt = "i = " + (string) i
                           + " / "
                           + "j = " + (string) j;
               
               // debug
               write_Log(
                     dpath_Log
                     , fname_Log
                     , __FILE__
                     , __LINE__
                     , txt);
                     //, name);

               // setup : params
               _setup__BasicParams_2(_symbol, _timeframe);
               
               // exec : gen csv files
               exec();
               
           }
         //_setup__BasicParams_2(_symbol, 5);
         
     }
*/   
   //_setup__BasicParams_2("USDJPY", 5);
   
   //+------------------------------------------------------------------+
   //|                                                                  |
   //+------------------------------------------------------------------+
/*   Alert("[", __FILE__, ":",__LINE__,"] symbol = ",SYMBOL_STR,""
   
            + " / RSI threshold = ",RSI_THRESHOLD,""
            + " / PERIOD = ",Period(),""         
            
         );
*/
//+------------------------------------------------------------------+
//| Array
//+------------------------------------------------------------------+
   //ArrayResize(HIT_INDICES,NUMOF_TARGET_BARS);

   //+------------------------------------------------------------------+
   //| operations                                                                 |
   //+------------------------------------------------------------------+
   //exec();
   

}//setup_3
