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
#include <lib_ea.mqh>


//+------------------------------------------------------------------+
//| vars                                               |
//+------------------------------------------------------------------+
string PGName = "abc";     //

//string txt_Msg;

double __MyPoint   = 0.001;

//+------------------------------------------------------------------+
//| vars : counter
//+------------------------------------------------------------------+
int cntOf_Ticks = 0;

string fname_Log_For_Session = "[ea_Exp_1__TrailingStop].(" + conv_DateTime_2_SerialTimeLabel((int) TimeLocal()) + ").log";
string dpath_Log = "Logs"; // under the dir "C:\Users\iwabuchiken\AppData\Roaming\MetaQuotes\Terminal\B9B5D4C0EA7B43E1F3A680F94F757B3D\MQL4\Files"

//+------------------------------------------------------------------+
//| externs
//+------------------------------------------------------------------+
extern int Time_period        = PERIOD_M1;
//extern int Time_period        = PERIOD_M5;

//ref Ask_MFI_EA
extern int MagicNumber  = 10001;
extern double Lots      = 0.1;
extern double StopLoss  = 30 * 0.001;  // StopLoss (in currency)
extern double TakeProfit= 70 * 0.001;  // TakeProfit (in currency)

//extern double StopLoss=0.03;
//extern double TakeProfit=0.05;

extern int TrailingStop = 0.03;
extern int Slippage     = 0.01;

extern string Sym_Set   = "EURJPY";

bool is_Up_Bar() {

   /********************************
      get : the latest bar
   ********************************/
   int index = 1;
   
   float price_Close_Latest = (float) Close[index];
   float price_Open_Latest = (float) Open[index];
   
   float diff_Latest = price_Close_Latest - price_Open_Latest;
   
   string d = TimeToStr(iTime(Symbol(),Period(), index));
   
   string txt = "\nlatest close = "
                + (string) price_Close_Latest
                + "\nlatest open = "
                + (string) price_Open_Latest
                + "\nlatest diff = "
                + (string) diff_Latest
                + "\ndatetime = "
                + d
               ;
                
   write_Log(
         dpath_Log
         //, fname_Log
         , fname_Log_For_Session
         , __FILE__
         , __LINE__
         , txt);

   //debug
   Print("[", __FILE__, ":",__LINE__,"] ", txt);

//aaaa

   //return true;
   return (diff_Latest > 0) ? true : false;

}//is_Up_Bar()

/*****************************
   void op_NewBar()
*****************************/
void op_NewBar() {

  double TheStopLoss    = StopLoss;
  double TheTakeProfit  = TakeProfit; 
//  double TheStopLoss=0;
//  double TheTakeProfit=0; 
   
   string txt_Msg = "\nnew bar (tick = "
                + (string) cntOf_Ticks
               + ")"
               + " "
               + "(period = "
               + (string) Period()
               + " / "
               + "symbol = "
               + (string) Symbol()
               + ")"
               ;
                
   write_Log(
         dpath_Log, fname_Log_For_Session
         , __FILE__, __LINE__
         , txt_Msg);

   /********************************
      detect : down or up ?
   ********************************/
   /********************************
      get : the latest bar
   ********************************/
   int index = 1;
   
   double price_Close_Latest = (double) Close[index];
   double price_Open_Latest = (double) Open[index];
   
   /********************************
      the latest bar : down ?
   ********************************/
   double diff_Latest = price_Close_Latest - price_Open_Latest;
   
   string d = TimeToStr(iTime(Symbol(),Period(), index));

   if(diff_Latest >= 0)
     {
      
         string txt = "\ndiff_Latest >= 0 ("
                      + (string) diff_Latest
                      + ") ("
                      + d
                      + ")"
                     ;
                      
         write_Log(
               dpath_Log, fname_Log_For_Session
               , __FILE__, __LINE__
               , txt);
         
     }//if(diff_Latest >= 0)

   else
    {

         string txt = "\ndiff_Latest < 0 ("
                      + (string) diff_Latest
                      + ") ("
                      + d
                      + ")"
                     ;
                      
         write_Log(
               dpath_Log, fname_Log_For_Session
               , __FILE__, __LINE__
               , txt);
     
    }
   
   /********************************
      detect : above BB.+1?
   ********************************/


}//op_NewBar()

//+------------------------------------------------------------------+
//    expert start function
//+------------------------------------------------------------------+
int start()
{
   /********************************
      count : ticks
   ********************************/
   cntOf_Ticks += 1;

   /********************************
      new bar ?
   ********************************/
   bool res = _is_NewBar();
   
   // valid : is a new bar ?
   if(res == true)
     {
         op_NewBar();

     }//if(res == true)
   else
       {
        
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
            //+ "MyPoint * 10 * _TheTakeProfit = " + (string) (MyPoint * 10 * _TheTakeProfit)
            //+ "MyPoint * 10 * _TheTakeProfit (DoubleToStr) = " + DoubleToStr( (MyPoint * 10 * _TheTakeProfit), 3)
            //+ "\nMyPoint * 10 * _TheStopLoss = " + (string) (MyPoint * 10 * _TheStopLoss)
            //+ "\nMyPoint * 10 * _TheStopLoss (NormalizeDouble, digits=3) = " + (string) NormalizeDouble((MyPoint * 10 * _TheStopLoss),3)
            + "\nMyPoint * 10 * _TheStopLoss (NormalizeDouble, digits=2) = " + (string) NormalizeDouble((__MyPoint * 10 * _TheStopLoss),2)
            ;
            //"MyPoint * 10 * _TheTakeProfit = 0.07000000000000001"
            //"MyPoint * 10 * _TheStopLoss = 0.03"
            //"MyPoint * 10 * _TheTakeProfit (DoubleToStr) = 0.070"
            //"MyPoint * 10 * _TheStopLoss (NormalizeDouble, digits=3) = 0.03"
            //"MyPoint * 10 * _TheStopLoss (NormalizeDouble, digits=2) = 0.03"
            //"MyPoint * 10 * _TheTakeProfit (NormalizeDouble, digits=2) = 0.07000000000000001"
            

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

int init()
{

   //debug
   Print("[", __FILE__, ":",__LINE__,"] init... ", PGName);

   // basic data
   show_BasicData();

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
   Print("[", __FILE__, ":",__LINE__,"] symbol, period => ", Symbol(), " / ", Period());

}//setup()

/*
2019/01/28 15:41:44
func-list.(ea_Exp_1__TrailingStop.mq4).20190128_154144.txt
==========================================
<funcs>

1)	int init()
2)	bool is_Up_Bar() {
3)	void op_NewBar() {
4)	void setup() {
5)	int start()

==========================================
==========================================
<vars>

1)	string PGName = "abc";     //
2)	int cntOf_Ticks = 0;
3)	string dpath_Log = "Logs"; // under the dir "C:\Users\iwabuchiken\AppData\Roaming\MetaQuotes\Terminal\B9B5D4C0EA7B43E1F3A680F94F757B3D\MQL4\Files"
4)	string fname_Log_For_Session = "ea_44_5.3_2_up-up-buy." + conv_DateTime_2_SerialTimeLabel((int) TimeLocal()) + ".log";

==========================================
==========================================
<externs>

1)	extern double Lots =0.1;
2)	extern int MagicNumber=10001;
3)	extern int Slippage=0.01;
4)	extern double StopLoss=3;  // StopLoss (in pips)
5)	extern string Sym_Set = "EURJPY";
6)	extern double TakeProfit=7;  // TakeProfit (in pips)
7)	extern int Time_period        = PERIOD_M1;
8)	extern int TrailingStop=0.03;

==========================================
*/
