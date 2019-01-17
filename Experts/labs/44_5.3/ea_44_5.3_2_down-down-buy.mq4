/*+------------------------------------------------------------------+
   created at : 2019/01/09 13:45:56
   origina file : 
      Ask_MFI_EA.mq4 // C:\Users\iwabuchiken\AppData\Roaming\MetaQuotes\Terminal\B9B5D4C0EA7B43E1F3A680F94F757B3D\MQL4\Experts\labs\44_5.3
         ==> obtained from : http://www.forexeadvisor.com/expert_generator.aspx      

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

string txt_Msg;

//+------------------------------------------------------------------+
//| vars : counter
//+------------------------------------------------------------------+
int cntOf_Ticks = 0;

string fname_Log_For_Session = "ea_44_5.3_2_up-up-buy." + conv_DateTime_2_SerialTimeLabel((int) TimeLocal()) + ".log";
string dpath_Log = "Logs"; // under the dir "C:\Users\iwabuchiken\AppData\Roaming\MetaQuotes\Terminal\B9B5D4C0EA7B43E1F3A680F94F757B3D\MQL4\Files"

//+------------------------------------------------------------------+
//| externs
//+------------------------------------------------------------------+
extern int Time_period        = PERIOD_M1;
//extern int Time_period        = PERIOD_M5;

//ref Ask_MFI_EA
extern int MagicNumber=10001;
extern double Lots =0.1;
extern double StopLoss=3;  // StopLoss (in pips)
extern double TakeProfit=7;  // TakeProfit (in pips)

//extern double StopLoss=0.03;
//extern double TakeProfit=0.05;

extern int TrailingStop=0.03;
extern int Slippage=0.01;

bool is_Up_Bar() {

   /****************
      get : the latest bar
   ****************/
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

void op_NewBar() {

  double TheStopLoss    = StopLoss;
  double TheTakeProfit  = TakeProfit; 
//  double TheStopLoss=0;
//  double TheTakeProfit=0; 
   
   txt_Msg = "\nnew bar (tick = "
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
         dpath_Log
         //, fname_Log
         , fname_Log_For_Session
         , __FILE__
         , __LINE__
         , txt_Msg);

   /****************
      detect : down down buy ?
   ****************/
   bool res = detect_DownDown_Buy();
   
   txt_Msg = "\ndetect_DownDown_Buy() => "
               + (string) res
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

   /****************
      if detected ==> buy
   ****************/
   if(res == true)
     {
         
         // ea : id=2 : down-down-buy
         buy_DownDown_Buy(TheStopLoss, TheTakeProfit, dpath_Log, fname_Log_For_Session);
         
         // ea : id=3 : down-down-sell
         buy_DownDown_Sell(TheStopLoss, TheTakeProfit, dpath_Log, fname_Log_For_Session);
         
         
     }//if(res == true)


   /****************
      detect : up bar ?
   ****************/
/*
   bool bl_Is_Up_Bar = is_Up_Bar();
   
   if(bl_Is_Up_Bar == false)
     {   

         txt_Msg = "is_Up_Bar() ---> false"
                     ;
                      
         write_Log(
               dpath_Log
               , fname_Log_For_Session
               , __FILE__
               , __LINE__
               , txt_Msg);
               
         return;
         
     }
   else
     {
         txt_Msg = "is_Up_Bar() ---> true"
                     ;
                      
         write_Log(
               dpath_Log
               , fname_Log_For_Session
               , __FILE__
               , __LINE__
               , txt_Msg);
               
         return;
      
     }
*/     

   /****************
      detect : above BB.+1?
   ****************/


}//op_NewBar()

//+------------------------------------------------------------------+
//    expert start function
//+------------------------------------------------------------------+
int start()
{
   /****************
      count : ticks
   ****************/
   cntOf_Ticks += 1;

   /****************
      new bar ?
   ****************/
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
//|                                                          |
//+------------------------------------------------------------------+
int init()
{

   //debug
   Print("[", __FILE__, ":",__LINE__,"] init... ", PGName);


   setup();

   //_is_NewBar();

  double MyPoint=Point;
  
  //@_20190115_150404 
  /*
      MyPoint * 2 * 100  ===> + 0.20 JPY
      MyPoint * 2 * 10  ===> + 0.02 JPY (0.01 * 2)
      MyPoint * N * 10  ===> + 0.0N JPY (0.01 * N, N<=9)
      
  */
  double _TheTakeProfit = TakeProfit;
  double _TheStopLoss = StopLoss;
  
  double Level_TakeProfit = Bid + MyPoint * 10 * _TheTakeProfit;  // (+0.01 * takeprofit pips) JPY
  double Level_StopLoss = Bid - MyPoint * 10 * _TheStopLoss;        // (-0.01 * stoploss pips) JPY
  //double Level_TakeProfit = Bid + MyPoint * 2 * 100;  // +0.20 yen
  //double Level_StopLoss = Bid - MyPoint * 100;        // -0.11 yen

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

   txt_Msg += "\n"
            + "Point = " + (string) Point
            + "\nBid = " + (string) Bid
            ;
                
   txt_Msg += "\n"
            + "MyPoint * 10 * _TheTakeProfit = " + (string) (MyPoint * 10 * _TheTakeProfit)
            + "\nMyPoint * 10 * _TheStopLoss = " + (string) (MyPoint * 10 * _TheStopLoss)
            ;

   txt_Msg += "\n"
            + "_TheTakeProfit = " + (string) _TheTakeProfit
            + "\n_TheStopLoss = " + (string) _TheStopLoss
            ;

   write_Log(
         dpath_Log, fname_Log_For_Session
         , __FILE__, __LINE__
         , txt_Msg);   

   
   return(0);
}

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
