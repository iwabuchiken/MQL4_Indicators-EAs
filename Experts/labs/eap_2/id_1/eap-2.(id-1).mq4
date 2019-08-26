/*+------------------------------------------------------------------+
   created at : 2019/01/28 10:04:49
   origina file : 
      ea_44_5.3_2_down-down-buy.mq4

//+------------------------------------------------------------------+*/

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
#include <lib_ea_2.mqh>
#include <lib_ea.mqh>


//+------------------------------------------------------------------+
//| vars                                               |
//+------------------------------------------------------------------+
string PGName = "abc";     //

//string txt_Msg;

double __MyPoint   = 0.001;

string   txt;
bool     res;

//+------------------------------------------------------------------+
//| vars : flags
//+------------------------------------------------------------------+
bool flg_OrderOpened = false;

int num_Ticket = 0;

//+------------------------------------------------------------------+
//| vars : counter
//+------------------------------------------------------------------+
int cntOf_Ticks = 0;

string fname_Log_For_Session = "[eap-2.id-1].(" + conv_DateTime_2_SerialTimeLabel((int) TimeLocal()) + ").log";
//string dpath_Log = "Logs"; // under the dir "C:\Users\iwabuchiken\AppData\Roaming\MetaQuotes\Terminal\B9B5D4C0EA7B43E1F3A680F94F757B3D\MQL4\Files"
string dpath_Log = "Logs/" + conv_DateTime_2_SerialTimeLabel((int) TimeLocal()) + ".dir";

//+------------------------------------------------------------------+
//| externs
//+------------------------------------------------------------------+
extern int Time_period        = PERIOD_M1;
//extern int Time_period        = PERIOD_M5;

//ref Ask_MFI_EA
extern int MagicNumber  = 10001;
extern double Lots      = 0.1;
extern double StopLoss  = 20 * 0.001;  // StopLoss (in currency)
extern double TakeProfit= 40 * 0.001;  // TakeProfit (in currency)
//extern double StopLoss  = 30 * 0.001;  // StopLoss (in currency)
//extern double TakeProfit= 70 * 0.001;  // TakeProfit (in currency)

//extern double StopLoss=0.03;
//extern double TakeProfit=0.05;

extern double TrailingStop = 0.03;  // TrailingStop (in currency)
extern double Slippage     = 0.01;  // Slippage (in currency)

extern double TrailingStop_Margin     = 0.01;

extern string Sym_Set   = "EURJPY";


//+------------------------------------------------------------------+
//    expert start function
//+------------------------------------------------------------------+
int start()
{
   /********************************
      count : ticks
   ********************************/
   cntOf_Ticks += 1;

   //debug
   txt = "starting...";
   
   txt += "\n";
   
   Print("[", __FILE__, ":",__LINE__,"] ", txt);

   /********************************
      step : j1
         new bar ?
   ********************************/
   res = _is_NewBar();
   
   // valid : is a new bar ?
   if(res == true)
     {
         /*******************
            step : j1 : Y
               new bar
         *******************/
         //debug
         txt = "(step : j1 : Y) new bar";
         write_Log(
               dpath_Log
               , fname_Log_For_Session
               
               , __FILE__, __LINE__
               
               , txt);
         

         /*******************
            step : j2
               flag --> True ?
         *******************/
         if(flg_OrderOpened == true)
           {
               /*******************
                  step : j2 : Y
                     flag --> True
               *******************/
               /*******************
                  step : j2 : Y : 1
                     continue
               *******************/
              return(0);
            
           }
         else//if(flg_OrderOpened == true)
          {
               /*******************
                  step : j2 : N
                     flag --> False
               *******************/
               //
               txt = "(step : j2 : N)";
               write_Log(
                  dpath_Log
                  //, fname_Log
                  , fname_Log_For_Session
                  , __FILE__
                  , __LINE__
                  , txt);
            
               /*******************
                  step : j3
                     judge_1 ==> true ?
               *******************/
               //_20190826_132608:tmp
               //_20190826_133747:caller
               res = judge_1();
               
               if(res == true)
                 {
                     /*******************
                        step : j3 : Y
                           judge_1 ==> true
                     *******************/
                     txt = "(step : j3 : Y) judge_1 ==> true";
                     write_Log(
                        dpath_Log
                        , fname_Log_For_Session
                        
                        , __FILE__, __LINE__
                        
                        , txt);
                     
                     //_20190826_135520:next   
                  
                 }
               else//if(res == true)
                 {
                     /*******************
                        step : j3 : N
                           judge_1 ==> false
                     *******************/
                     txt = "(step : j3 : N) judge_1 ==> false";
                     write_Log(
                        dpath_Log
                        , fname_Log_For_Session
                        
                        , __FILE__, __LINE__
                        
                        , txt);
                  
                 }//if(res == true)
          
          }//if(flg_OrderOpened == true)
               
     }//if(res == true)
     
   else
       {

         /*******************
            step : j1 : N
               new bar --> NO
         *******************/
         /*******************
            step : j1 : N : 1
               continue
         *******************/
        return(0);
        
       }//if(res == true)


   return(0);
}

//+------------------------------------------------------------------+
//|   void show_BasicData() {
//+------------------------------------------------------------------+
void show_BasicData() {

  //double MyPoint=Point;

  //@_20190115_150404 
  /*
      MyPoint * 2 * 100  ===> + 0.20 JPY
      MyPoint * 2 * 10  ===> + 0.02 JPY (0.01 * 2)
      MyPoint * N * 10  ===> + 0.0N JPY (0.01 * N, N<=9)
      
  */
  double _TheTakeProfit = TakeProfit;
  double _TheStopLoss = StopLoss;
  
  double Level_TakeProfit = Bid + TakeProfit;  // (+0.01 * takeprofit pips) JPY
  double Level_StopLoss = Bid - StopLoss;        // (-0.01 * stoploss pips) JPY
  //double Level_TakeProfit = Bid + MyPoint * 10 * _TheTakeProfit;  // (+0.01 * takeprofit pips) JPY
  //double Level_StopLoss = Bid - MyPoint * 10 * _TheStopLoss;        // (-0.01 * stoploss pips) JPY
  //double Level_TakeProfit = Bid + MyPoint * 2 * 100;  // +0.20 yen
  //double Level_StopLoss = Bid - MyPoint * 100;        // -0.11 yen


   //debug
   double num = 0.12345678;
   
   string txt_Msg = "\n"
            + "Num (string): " 
                  + (string) num
                  + "\n"
            + "Num (NormalizeDouble, 2): " 
                  + (string) NormalizeDouble(0.12345678, 2)
                  + "\n"
            + "Digits() : "
                  + (string) Digits()
                  + "\n"
            + "Point : "
                  + (string) Point
                  + "\n"
            ;
            //"_TheTakeProfit = 0.12345678"
            //Num (string): 0.12345678
            //Num (NormalizeDouble, 2): 0.12
            //"Digits() : 3"

   write_Log(
         dpath_Log, fname_Log_For_Session
         , __FILE__, __LINE__
         , txt_Msg);   
   
   //debug : order types
   txt_Msg = "\n"
            + "OP_BUY : " 
                  + (string) OP_BUY
                  + "\n"
            + "OP_SELL : " 
                  + (string) OP_SELL
                  + "\n"
            ;
            //"_TheTakeProfit = 0.12345678"
            //Num (string): 0.12345678
            //Num (NormalizeDouble, 2): 0.12
            //"Digits() : 3"

   write_Log(
         dpath_Log, fname_Log_For_Session
         , __FILE__, __LINE__
         , txt_Msg);   



   //debug
   Print("[", __FILE__, ":",__LINE__,"] "
            , "Level_TakeProfit => ", (string) Level_TakeProfit
            , " / "
            , "Level_StopLoss => ", (string) Level_StopLoss
            
            );
//abc
   txt_Msg = "\n"
            + "Level_TakeProfit => "+ (string) Level_TakeProfit
            + " / "
            + "Level_StopLoss => "+ (string) Level_StopLoss
               ;
               //"Level_TakeProfit => 124.982 / Level_StopLoss => 124.882"

   txt_Msg += "\n"
            + "Point = " + (string) Point
            + "\nBid = " + (string) Bid
            ;
            //"Point = 0.001"
                
   txt_Msg += "\n"
            + "MyPoint * 10 * _TheTakeProfit (NormalizeDouble, digits=2) = " + (string) NormalizeDouble((__MyPoint * 10 * _TheTakeProfit), 2)
            + "\nMyPoint * 10 * _TheStopLoss (NormalizeDouble, digits=2) = " + (string) NormalizeDouble((__MyPoint * 10 * _TheStopLoss),2)
            ;

   txt_Msg += "\n"
            + "_TheTakeProfit = " + (string) _TheTakeProfit
            + "\n_TheStopLoss = " + (string) _TheStopLoss
            ;

   write_Log(
         dpath_Log, fname_Log_For_Session
         , __FILE__, __LINE__
         , txt_Msg);   

   /************************************
      "Point" values
   ************************************/
   string symbol_set = "USDJPY";

   int period = Time_period;
   
   set_Symbol(symbol_set, period);
   
   //debug
   txt_Msg = "\n"
            + "Point (" + symbol_set + ")"
               + " = " + (string) Point
               + "\n"
            ;

   symbol_set = "EURJPY";
   
   set_Symbol(symbol_set, period);
   
   //debug
   txt_Msg += "\n"
            + "Point (" + symbol_set + ")"
               + " = " + (string) Point
               + "\n"
               ;
   
   // EURUSD
   symbol_set = "EURUSD";
   
   set_Symbol(symbol_set, period);
   
   //debug
   txt_Msg += "\n"
            + "Point (" + symbol_set + ")"
               + " = " + (string) Point
               + "\n"
               ;
               
   write_Log(
         dpath_Log, fname_Log_For_Session
         , __FILE__, __LINE__
         , txt_Msg);   
            /*
            Point (USDJPY) = 0.001
            
            Point (EURJPY) = 0.001
            
            Point (EURUSD) = 0.001
            */
       
}//void show_BasicData() {

void show_OrderData() {

   //debug
   string txt_Msg = "\n"
            + "show_OrderData()----------------"
               + "\n"
               ;
/*               
   write_Log(
         dpath_Log, fname_Log_For_Session
         , __FILE__, __LINE__
         , txt_Msg);   
*/
   /************************************
      OrdersTotal()
   ************************************/
   int numOf_OpenedOrders = OrdersTotal();

   //debug
   txt_Msg += "\n"
            + "OrdersTotal : " + (string) numOf_OpenedOrders
               + "\n"
               ;
            //OrdersTotal : 0               
   
   write_Log(
         dpath_Log, fname_Log_For_Session
         , __FILE__, __LINE__
         , txt_Msg);   

}//show_OrderData()

int init()
{

   //debug
   Print("[", __FILE__, ":",__LINE__,"] init... ", PGName);

   // basic data
   //show_BasicData();


   // basic data : order-related
   //show_OrderData();
   
   
   // setup
   setup();

   //_is_NewBar();

   
   return(0);
}

void setup() {

   //string symbol_set = "EURJPY";
   string symbol_set = Sym_Set;

   int period = Time_period;
   
   set_Symbol(symbol_set, period);

   //debug
   //ref print https://docs.mql4.com/common/printformat
   txt = "[" + __FILE__ + ":" + (string) __LINE__ 
               + "] symbol + period => " + Symbol() + " / " + (string) Period();
   
   Print(txt);
   //Print("[", __FILE__, ":",__LINE__,"] symbol, period => ", Symbol(), " / ", Period());

   //debug
   write_Log(
         dpath_Log
         //, fname_Log
         , fname_Log_For_Session
         , __FILE__
         , __LINE__
         , txt);
   

}//setup()

/*
2019/01/29 17:49:03
func-list.(ea_Exp_1__TrailingStop.mq4).20190129_174903.txt
==========================================
<funcs>

1)	int init()
2)	bool is_Up_Bar() {
3)	void op_NewBar() {
4)	void setup() {
5)	void show_BasicData() {
6)	void show_OrderData() {
7)	int start()
8)	void test_TrailingStop(double diff_Latest) {

==========================================
==========================================
<vars>

1)	string PGName = "abc";     //
2)	int cntOf_Ticks = 0;
3)	string dpath_Log = "Logs"; // under the dir "C:\Users\iwabuchiken\AppData\Roaming\MetaQuotes\Terminal\B9B5D4C0EA7B43E1F3A680F94F757B3D\MQL4\Files"
4)	bool flg_OrderOpened = false;
5)	string fname_Log_For_Session = "[ea_Exp_1__TrailingStop].(" + conv_DateTime_2_SerialTimeLabel((int) TimeLocal()) + ").log";

==========================================
==========================================
<externs>

1)	extern double Lots      = 0.1;
2)	extern int MagicNumber  = 10001;
3)	extern int Slippage     = 0.01;
4)	extern double StopLoss  = 30 * 0.001;  // StopLoss (in currency)
5)	extern string Sym_Set   = "EURJPY";
6)	extern double TakeProfit= 70 * 0.001;  // TakeProfit (in currency)
7)	extern int Time_period        = PERIOD_M1;
8)	extern int TrailingStop = 0.03;

==========================================
*/
