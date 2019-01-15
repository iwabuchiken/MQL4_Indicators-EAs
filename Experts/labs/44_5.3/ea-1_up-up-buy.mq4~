//+------------------------------------------------------------------+
//|                                                          abc.mq4 |
//|  Copyright (c) 2010 Area Creators Co., Ltd. All rights reserved. |
//|                                          http://www.mars-fx.com/ |
//+------------------------------------------------------------------+
#property copyright "Copyright (c) 2010 Area Creators Co., Ltd. All rights reserved."
#property link      "http://www.mars-fx.com/"

//+------------------------------------------------------------------+
//|                                              |
//+------------------------------------------------------------------+
#include <stderror.mqh>
#include <stdlib.mqh>
#include <WinUser32.mqh>

//+------------------------------------------------------------------+
//|  : original                                             |
//+------------------------------------------------------------------+
#include <utils.mqh>

//+------------------------------------------------------------------+
//|                                                        |
//+------------------------------------------------------------------+
#define URL "http://www.mars-fx.com/"      //URL
#define ERR_TITLE1 ""    //(1)
#define MAIL_TITLE "MarsFX MailAlert"      //
#define R_SUCCESS         0                //()
#define R_ERROR          -1                //()
#define R_ALERT          -2                //(1)
#define R_WARNING        -3                //(2)
#define BUY_SIGNAL        1                //()
#define SELL_SIGNAL       2                //()
#define BUY_EXIT_SIGNAL   1                //()
#define SELL_EXIT_SIGNAL  2                //()
#define ORDER_TYPE_ALL    1                //()
#define ORDER_TYPE_BUY    2                //()
#define ORDER_TYPE_SELL   3                //()
#define LAST_ORDER        4                //()
#define LAST_HIS          1                //()
#define LAST_BUT_ONE_HIS  2                //()

//+------------------------------------------------------------------+
//|                                              |
//+------------------------------------------------------------------+
extern int MagicNumber       = 12345678;      //
extern double Lots           = 0.1;                   //
extern int Slippage          = 3;                 //
extern double TakeProfitPips = 0;         //Pips
extern double StopLossPips   = 0;           //Pips
extern int OpenOrderMax      = 1;           //
extern double CloseLotsMax   = 0;           //
extern int AutoLotsType      = 0;    //(0:1:2:3:)


//2() Start------------------------------------------------------------------------------------------------------------------------------
//BB
extern int Entry002_BB_Period       = 20;         //
extern int Entry002_BB_Deviation    = 2;       //
extern int Entry002_BB_Mode         = 1;            //
extern int Entry002_BB_TimeFrame    = 0;      //
extern int Entry002_BB_AppliedPrice = 0;   //
//2() End--------------------------------------------------------------------------------------------------------------------------------


//2() Start------------------------------------------------------------------------------------------------------------------------------
//MA
extern int Exit002_MA_Period       = 14;          //
extern int Exit002_MA_Method       = 0;           //
extern int Exit002_MA_TimeFrame    = 0;       //
extern int Exit002_MA_AppliedPrice = 0;    //
//2() End--------------------------------------------------------------------------------------------------------------------------------

extern int Time_period        = PERIOD_M5;


//vars from : fxeabuilder.mq4 Start------------------------------------------------------------------------------------------------------------------------------
double RealPoint;
//string Currency = "USDJPY";
string Currency = "EURJPY";
int ShortTicket;
//vars from : fxeabuilder.mq4 End--------------------------------------------------------------------------------------------------------------------------------

//vars from : fxeabuilder.mq4 Start------------------------------------------------------------------------------------------------------------------------------
//string dpath_Log = "C:\\Users\\iwabuchiken\\AppData\\Roaming\\MetaQuotes\\Terminal\\34B08C83A5AAE27A4079DE708E60511E\\MQL4\\Logs";
string dpath_Log = "Logs";
//C:\Users\iwabuchiken\AppData\Roaming\MetaQuotes\Terminal\34B08C83A5AAE27A4079DE708E60511E\MQL4\Logs
string fname_Log = "dev.log";

string fname_Log_For_Session = "dev." + conv_DateTime_2_SerialTimeLabel((int) TimeLocal()) + ".log";

//vars from : fxeabuilder.mq4 End--------------------------------------------------------------------------------------------------------------------------------


//+------------------------------------------------------------------+
//| vars                                               |
//+------------------------------------------------------------------+
string PGName = "abc";     //
int RETRY_TIMEOUT    = 60;               //()
int RETRY_INTERVAL   = 15000;            //
int PLDigits         = 2;                //
double wk_point      = 0;                //35Point
double order[1][12];                    //   
double order_his[1][12];                //
double exception[1][2];                 //
int OrderCount       = 0;                //
bool MailFlag        = false;            //(true:false:)
bool AlertFlag       = false;            //(true:false:)

int cntOf_Ticks = 0;  // count the num of ticks -- start()
//static int cntOf_Ticks = 0;  // count the num of ticks -- start()
int cntOf_Ticks_In_The_Bar = 0;

string txt_Msg = "";


/*
//+------------------------------------------------------------------+
//| prototypes                                                     |
//+------------------------------------------------------------------+
//void _inspections(void);
*/


//+------------------------------------------------------------------+
//| _is_Above_BB_1S()                                                         |
//+------------------------------------------------------------------+
//
//bool _is_Above_BB_1S() {
//
//   int index = 0;
//
//   int deviation = 1;
//
//   float close_Latest = (float) Close[index];
//   
//   int   period_BB = 20;
//   
//   //ref https://docs.mql4.com/indicators/ibands
//   //float BB_1S = (float) iBands(Symbol(),Period(), period_BB, 0,0,PRICE_CLOSE,MODE_MAIN, index);
//   float BB_1S = (float) iBands(
//               Symbol()
//               , Period()
//               , period_BB
//               , deviation   // deviation //ref https://docs.mql4.com/constants/indicatorconstants/lines
//               , 0
//               , PRICE_CLOSE
//               , MODE_UPPER   // mode
//               , index);
//            /*   
//               string       symbol,           // symbol
//               int          timeframe,        // timeframe
//               int          period,           // averaging period
//               double       deviation,        // standard deviations
//               int          bands_shift,      // bands shift
//               int          applied_price,    // applied price
//               int          mode,             // line index
//               int          shift             // shift
//            */
//   // judge
//   bool judge = (close_Latest > BB_1S);
//   
//   //debug
//   //Alert("[", __FILE__, ":",__LINE__,"] "
//   //char _char[50];
//   //sprintf(_char, "latest close : %.03f", close_Latest);
//         //'sprintf' - function not defined	ea-1_up-up-buy.mq4	160	4
//
//   Print("[", __FILE__, ":",__LINE__,"] "
//         
//         , "latest close => ", (string) close_Latest
//         , " / "
//         , "BB_1S => ", (string) BB_1S
//         
//         
//         );
//
//   // return
//   return judge;
//
//}//_is_Above_BB_1S()


void setup() {

   string symbol_set = "EURJPY";
   
   int period = Time_period;
   //int period = PERIOD_M1;
   //int period = PERIOD_M5;
   
   set_Symbol(symbol_set, period);

   //debug
   //ref print https://docs.mql4.com/common/printformat
   Print("[", __FILE__, ":",__LINE__,"] symbol, period => ", Symbol(), " / ", Period());

}//setup()

//+------------------------------------------------------------------+
//|                                                          |
//+------------------------------------------------------------------+
int init()
{

   //debug
   Print("[", __FILE__, ":",__LINE__,"] init... ", PGName);


   setup();

   //_is_NewBar();
   
   return(0);
}

//+------------------------------------------------------------------+
//|                                                          |
//+------------------------------------------------------------------+
int deinit()
{
/*
   //
   ObjectDelete("PGName");
   
   //debug
   Alert("[", __FILE__, ":",__LINE__,"] deinit... ", PGName);
   Alert("[", __FILE__, ":",__LINE__,"] WindowOnDropped() => '", WindowOnDropped(), "'");
  */ 
   return(0);
}

//+------------------------------------------------------------------+
//|                                                        |
//+------------------------------------------------------------------+
//xxx
int start()
{

   //+----------------------------------------+
   //| count : ticks |
   //+----------------------------------------+
   cntOf_Ticks += 1;
   cntOf_Ticks_In_The_Bar += 1;

   //string txt =  "cntOf_Ticks", cntOf_Ticks
   string txt =  "cntOf_Ticks" + (string) cntOf_Ticks
         + " / "
         + "cntOf_Ticks_In_The_Bar = " + (string) cntOf_Ticks_In_The_Bar
   
         + " ("
         + TimeToStr(TimeLocal(),TIME_DATE|TIME_SECONDS)
         + ")"
            ;
   
   //debug
   //Alert("[", __FILE__, ":",__LINE__, "] ", txt);
   //Print("[", __FILE__, ":",__LINE__, "] ", txt);

   //+----------------------------------------+
   //| new bar                                       |
   //+----------------------------------------+
   // detect a new bar
   bool isNewBar = _is_NewBar();
     
   // reset : cntOf_Ticks_In_The_Bar
   if(isNewBar == true)
     {

         // debug
         //txt = "cntOf_Ticks = " + (string)cntOf_Ticks
         txt = "\n" 
                     + "cntOf_Ticks = " + (string)cntOf_Ticks
                     + " / "
                     + "cntOf_Ticks_In_The_Bar = " + (string) cntOf_Ticks_In_The_Bar
                     + "\n"
                     + "cntOf_Ticks_In_The_Bar => resetting to 0...";
         write_Log(
               dpath_Log
               //, fname_Log
               , fname_Log_For_Session
               , __FILE__
               , __LINE__
               , txt);
               //, name);
         
         //debug
         Print("[", __FILE__, ":",__LINE__, "] ", txt);
         
         //+----------------------------------------+
         //| new bar : above BB.+1S       |
         //+----------------------------------------+
         // detect a new bar
         //Symbol(),Period(), period_BB, 0,0,PRICE_CLOSE,MODE_MAIN, index

         int _shift = 1;
         int _deviation = 1;
         int _mode = MODE_UPPER;
         int   period_BB = 20;
         int _BB_price = PRICE_CLOSE;

         float _target_price = (float) Close[0];
         
         bool is_Above_BB_1S = is_Above_BB_X(
                              
                                 Symbol()
                                 , Period()
                                 , period_BB
                                 , _deviation   // deviation //ref https://docs.mql4.com/constants/indicatorconstants/lines
                                 , 0
                                 , _BB_price
                                 , _mode   // mode
                                 , _shift
                                 , _target_price
                                 , dpath_Log
                                 , fname_Log_For_Session
                              );
                              //aaa
         
         //debug
         //Print("[", __FILE__, ":",__LINE__,"] _is_Above_BB_1S => ", is_Above_BB_1S);

         // debug
         txt = "_is_Above_BB_1S => " + (string) is_Above_BB_1S
                  ;
         
         write_Log(
               dpath_Log
               //, fname_Log
               , fname_Log_For_Session
               , __FILE__
               , __LINE__
               , txt);
               
         Print("[", __FILE__, ":",__LINE__,"] ", txt);

         // reset
         cntOf_Ticks_In_The_Bar = 0;
         

     }//if(isNewBar == true)
/*   
   //debug
   Print("[", __FILE__, ":",__LINE__,"] _is_Above_BB_1S => ", is_Above_BB_1S);
*/
   return(0);

}//int start()



//+------------------------------------------------------------------+