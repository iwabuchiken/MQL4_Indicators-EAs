//+------------------------------------------------------------------+
//|                                                       lib_ea.mqh |
//|                                                     iwabuchi ken |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "iwabuchi ken"
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
//|  vars
//+------------------------------------------------------------------+
string listOf_OrderTypes[4] = {"OP_BUY", "OP_SELL"};

//+------------------------------------------------------------------+
//|  funcs
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|  detect_DownDown_Buy
//+------------------------------------------------------------------+
//bool detect_DownDown_Buy() {
bool detect_DownDown_Buy(string _dpath_Log, string _fname_Log_For_Session) {
   
   /********************************
      vars
   ********************************/
   int   period_BB = 20;
   
   
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
      
         string txt_lib_ea = "\ndiff_Latest >= 0 ("
                      + (string) diff_Latest
                      + ") ("
                      + d
                      + ")"
                     ;
                      
         write_Log(
               _dpath_Log
               , _fname_Log_For_Session
               , __FILE__
               , __LINE__
               , txt_lib_ea);
         
         // return
         return false;
      
     }//if(diff_Latest >= 0)

   /********************************
      the latest bar : below BB.-1 ?
   ********************************/
   index = 1;
   
   double ibands_1S_Plus = iBands(
               Symbol()
               , Period()
               , period_BB
               , 1.0
               , 0
               , PRICE_CLOSE
               , MODE_LOWER
               , index);
   
   // compare
   if(price_Close_Latest >= ibands_1S_Plus)
     {

         string txt_lib_ea = "\nprice_Close_Latest >= ibands_1S_Plus"
                      + " (close = "
                      + (string) price_Close_Latest
                      + ")"
                      + " (BB.-1 = "
                      + (string) ibands_1S_Plus
                      + ") ("
                      + d
                      + ")"
                     ;
                      
         write_Log(
               _dpath_Log, _fname_Log_For_Session
               , __FILE__, __LINE__
               , txt_lib_ea);
         
         // return
         return false;
      
     }//if(price_Close_Latest >= ibands_1S_Plus)

   /********************************
      the one before the latest : down ?
   ********************************/
   double price_Close_SecondLatest = (double) Close[index + 1];
   double price_Open_SecondLatest = (double) Open[index + 1];

   string d2 = TimeToStr(iTime(Symbol(),Period(), index + 1));
   
   /********************************
      the latest bar : down ?
   ********************************/
   double diff_SecondLatest = price_Close_SecondLatest - price_Open_SecondLatest;

   // compare
   if(diff_SecondLatest >= 0)
     {

         string txt_lib_ea = "\ndiff_SecondLatest >= 0"
                      + " (diff = "
                      + (string) diff_SecondLatest
                      + ")"
                      + "("
                      + d2
                      + ")"
                     ;
                      
         write_Log(
               _dpath_Log, _fname_Log_For_Session
               , __FILE__, __LINE__
               , txt_lib_ea);
         
         // return
         return false;
         
      }//if(diff_SecondLatest >= 0)

   /********************************
      detection ---> true
   ********************************/
   string txt_lib_ea = "\ndetect_DownDown_Buy() ==> true"
                + " (datetime = "
                + d
                + ")"
               ;
                
   write_Log(
         _dpath_Log, _fname_Log_For_Session
         , __FILE__, __LINE__
         , txt_lib_ea);
   
   
   /********************************
      return
   ********************************/
   return true;
      
}//detect_DownDown_Buy()

//void buy_DownDown_Buy(double _TheStopLoss, double _TheTakeProfit) {
void buy_DownDown_Buy(
         double _Lots
         , int _Slippage
         , int _MagicNumber
         , double _TheStopLoss
         , double _TheTakeProfit
         , string _dpath_Log, string _fname_Log_For_Session) {

     int result=0;
     
     double MyPoint=Point;
     
     string txt_Msg;
     
     //@_20190115_150404 
     /*
         MyPoint * 2 * 100  ===> + 0.20 JPY
         MyPoint * 2 * 10  ===> + 0.02 JPY (0.01 * 2)
         MyPoint * N * 10  ===> + 0.0N JPY (0.01 * N, N<=9)
         
     */
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

      txt_Msg = "[" + __FILE__+ ":" + (string) __LINE__ + "] "
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
            _dpath_Log, _fname_Log_For_Session
            , __FILE__, __LINE__
            , txt_Msg);
      
     //if((Ask>iMFI(NULL,PERIOD_M5,20,0))) // Here is your open buy rule

     {
        result=OrderSend(
                  Symbol()
                  , OP_BUY
                  //, Lots
                  , _Lots
                  , Ask
                  , _Slippage
                  , Level_StopLoss
                  , Level_TakeProfit
                  //, 0
                  //, 0
                  , "EA Generator www.ForexEAdvisor.com"
                  , _MagicNumber
                  , 0
                  , Blue);
      

      txt_Msg = "\n-------------------------------- [new order : buy_DownDown_Buy]\n"
               + "order id = " + (string) result
               ;

      write_Log(
            _dpath_Log, _fname_Log_For_Session
            , __FILE__, __LINE__
            , txt_Msg);
      

/*
//ref https://docs.mql4.com/trading/ordersend
int  OrderSend(
   string   symbol,              // symbol
   int      cmd,                 // operation
   double   volume,              // volume
   double   price,               // price
   int      slippage,            // slippage
   double   stoploss,            // stop loss
   double   takeprofit,          // take profit
   string   comment=NULL,        // comment
   int      magic=0,             // magic number
   datetime expiration=0,        // pending order expiration
   color    arrow_color=clrNONE  // color
   );
*/   
   
/*
        if(result>0)
        {
         _TheStopLoss=0;
         _TheTakeProfit=0;
         
         if(TakeProfit>0) _TheTakeProfit=Ask+TakeProfit*MyPoint;
         
         if(StopLoss>0) _TheStopLoss=Ask-StopLoss*MyPoint;
         abc
         bool res = OrderSelect(result,SELECT_BY_TICKET);
         
         //debug
         Print("[", __FILE__, ":",__LINE__,"] ", "OrderSelect => ", (string) res);
         
         //_20190827_143022:ref
         OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble(_TheStopLoss,Digits),NormalizeDouble(_TheTakeProfit,Digits),0,Green);
        }
*/        
        //return(0);
     }
   


}//buy_DownDown_Buy()

//xxx
void buy_DownDown_Sell(
         double _Lots
         , int _Slippage
         , int _MagicNumber
         
         , double _TheStopLoss
         , double _TheTakeProfit
         , string _dpath_Log, string _fname_Log_For_Session) {

     int result=0;
     
     double MyPoint=Point;
     
     string txt_Msg;
     
     //@_20190115_150404 
     /*
         MyPoint * 2 * 100  ===> + 0.20 JPY
         MyPoint * 2 * 10  ===> + 0.02 JPY (0.01 * 2)
         MyPoint * N * 10  ===> + 0.0N JPY (0.01 * N, N<=9)
         
     */
     double Level_TakeProfit = Ask - MyPoint * 10 * _TheTakeProfit;  // (+0.01 * takeprofit pips) JPY
     double Level_StopLoss = Ask + MyPoint * 10 * _TheStopLoss;        // (-0.01 * stoploss pips) JPY
     //double Level_TakeProfit = Bid + MyPoint * 10 * _TheTakeProfit;  // (+0.01 * takeprofit pips) JPY
     //double Level_StopLoss = Bid - MyPoint * 10 * _TheStopLoss;        // (-0.01 * stoploss pips) JPY

      //debug
      Print("[", __FILE__, ":",__LINE__,"] "
               , "Level_TakeProfit => ", (string) Level_TakeProfit
               , " / "
               , "Level_StopLoss => ", (string) Level_StopLoss
               
               );

      txt_Msg = "[" + __FILE__+ ":" + (string) __LINE__ + "] "
               + "Level_TakeProfit => "+ (string) Level_TakeProfit
               + " / "
               + "Level_StopLoss => "+ (string) Level_StopLoss
                  ;

      txt_Msg += "\n"
               + "Point = " + (string) Point
               + "\nBid = " + (string) Ask
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
            _dpath_Log, _fname_Log_For_Session
            , __FILE__, __LINE__
            , txt_Msg);
      
     //if((Ask>iMFI(NULL,PERIOD_M5,20,0))) // Here is your open buy rule

     {
        result=OrderSend(
                  Symbol()
                  , OP_SELL
                  , _Lots
                  , Bid
                  , _Slippage
                  , Level_StopLoss
                  , Level_TakeProfit
                  //, 0
                  //, 0
                  , "EA Generator www.ForexEAdvisor.com"
                  , _MagicNumber
                  , 0
                  , Blue);
      

      txt_Msg = "\n-------------------------------- [new order : buy_DownDown_Sell]\n"
               + "order id = " + (string) result
               ;

      write_Log(
            _dpath_Log, _fname_Log_For_Session
            , __FILE__, __LINE__
            , txt_Msg);
  
     }
   


}//buy_DownDown_Sell

bool detect_UpUp_Sell(string _dpath_Log, string _fname_Log_For_Session){

   /********************************
      vars
   ********************************/
   int   period_BB = 20;
   
   
   /********************************
      get : the latest bar
   ********************************/
   int index = 1;
   
   double price_Close_Latest = (double) Close[index];
   double price_Open_Latest = (double) Open[index];
   
   /********************************
      the latest bar : up ?
   ********************************/
   double diff_Latest = price_Close_Latest - price_Open_Latest;
   
   string d = TimeToStr(iTime(Symbol(),Period(), index));
   
   if(diff_Latest <= 0)
     {
      
         string txt_lib_ea = "\ndiff_Latest <= 0 ("
                      + (string) diff_Latest
                      + ") ("
                      + d
                      + ")"
                     ;
                      
         write_Log(
               _dpath_Log, _fname_Log_For_Session
               , __FILE__, __LINE__
               , txt_lib_ea);
         
         // return
         return false;
      
     }//if(diff_Latest >= 0)

   /********************************
      the latest bar : above BB.+1 ?
   ********************************/
   index = 1;
   
   double ibands_1S_Plus = iBands(
               Symbol()
               , Period()
               , period_BB
               , 1.0
               , 0
               , PRICE_CLOSE
               , MODE_UPPER
               , index);
   
   // compare
   if(price_Close_Latest < ibands_1S_Plus)
     {

         string txt_lib_ea = "\nprice_Close_Latest < ibands_1S_Plus"
                      + " (close = "
                      + (string) price_Close_Latest
                      + ")"
                      + " (BB.+1 = "
                      + (string) ibands_1S_Plus
                      + ") ("
                      + d
                      + ")"
                     ;
                      
         write_Log(
               _dpath_Log, _fname_Log_For_Session
               , __FILE__, __LINE__
               , txt_lib_ea);
         
         // return
         return false;
      
     }//if(price_Close_Latest >= ibands_1S_Plus)

   /********************************
      the one before the latest : up ?
   ********************************/
   double price_Close_SecondLatest = (double) Close[index + 1];
   double price_Open_SecondLatest = (double) Open[index + 1];

   string d2 = TimeToStr(iTime(Symbol(),Period(), index + 1));
   
   /********************************
      the latest bar : up ?
   ********************************/
   double diff_SecondLatest = price_Close_SecondLatest - price_Open_SecondLatest;

   // compare
   if(diff_SecondLatest < 0)
     {

         string txt_lib_ea = "\ndiff_SecondLatest < 0"
                      + " (diff = "
                      + (string) diff_SecondLatest
                      + ")"
                      + "("
                      + d2
                      + ")"
                     ;
                      
         write_Log(
               _dpath_Log, _fname_Log_For_Session
               , __FILE__, __LINE__
               , txt_lib_ea);
         
         // return
         return false;
         
      }//if(diff_SecondLatest >= 0)

   /********************************
      detection ---> true
   ********************************/
   string txt_lib_ea = "\ndetect_UpUp_Sell() ==> true"
                + " (datetime = "
                + d
                + ")"
               ;
                //ccc
   write_Log(
         _dpath_Log, _fname_Log_For_Session
         , __FILE__, __LINE__
         , txt_lib_ea);
   
   /********************************
      return
   ********************************/
   return true;
}

void sell_UpUp_Sell(
         double _Lots
         , int _Slippage
         , int _MagicNumber
         , double _TheStopLoss
         , double _TheTakeProfit
         , string _dpath_Log, string _fname_Log_For_Session) {

     int result=0;
     
     double MyPoint=Point;
     
     string txt_Msg;
     
     //@_20190125_112948
     /*
         MyPoint * 2 * 100  ===> + 0.20 JPY
         MyPoint * 2 * 10  ===> + 0.02 JPY (0.01 * 2)
         MyPoint * N * 10  ===> + 0.0N JPY (0.01 * N, N<=9)
         
     */
     double Level_TakeProfit = Bid - MyPoint * 10 * _TheTakeProfit;  // (+0.01 * takeprofit pips) JPY
     double Level_StopLoss = Bid + MyPoint * 10 * _TheStopLoss;        // (-0.01 * stoploss pips) JPY
     //double Level_TakeProfit = Bid + MyPoint * 2 * 100;  // +0.20 yen
     //double Level_StopLoss = Bid - MyPoint * 100;        // -0.11 yen

      //debug      
      txt_Msg = "[" + __FILE__+ ":" + (string) __LINE__ + "] "
               + "Level_TakeProfit => "+ (string) Level_TakeProfit
               + " / "
               + "Level_StopLoss => "+ (string) Level_StopLoss
                  ;

      Print(txt_Msg);


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
            _dpath_Log, _fname_Log_For_Session
            , __FILE__, __LINE__
            , txt_Msg);
      
     //if((Ask>iMFI(NULL,PERIOD_M5,20,0))) // Here is your open buy rule

     {
        result=OrderSend(
                  Symbol()
                  //, OP_BUY
                  , OP_SELL
                  //, Lots
                  , _Lots
                  //, Ask
                  , Bid
                  , _Slippage
                  , Level_StopLoss
                  , Level_TakeProfit
                  //, 0
                  //, 0
                  , "EA Generator www.ForexEAdvisor.com"
                  , _MagicNumber
                  , 0
                  , Blue);
      

      txt_Msg = "\n-------------------------------- [new order : buy_DownDown_Buy]\n"
               + "order id = " + (string) result
               ;

      write_Log(
            _dpath_Log, _fname_Log_For_Session
            , __FILE__, __LINE__
            , txt_Msg);
      

/*
//ref https://docs.mql4.com/trading/ordersend
int  OrderSend(
   string   symbol,              // symbol
   int      cmd,                 // operation
   double   volume,              // volume
   double   price,               // price
   int      slippage,            // slippage
   double   stoploss,            // stop loss
   double   takeprofit,          // take profit
   string   comment=NULL,        // comment
   int      magic=0,             // magic number
   datetime expiration=0,        // pending order expiration
   color    arrow_color=clrNONE  // color
   );
*/   
   
/*
        if(result>0)
        {
         _TheStopLoss=0;
         _TheTakeProfit=0;
         
         if(TakeProfit>0) _TheTakeProfit=Ask+TakeProfit*MyPoint;
         
         if(StopLoss>0) _TheStopLoss=Ask-StopLoss*MyPoint;
         abc
         bool res = OrderSelect(result,SELECT_BY_TICKET);
         
         //debug
         Print("[", __FILE__, ":",__LINE__,"] ", "OrderSelect => ", (string) res);
         
         OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble(_TheStopLoss,Digits),NormalizeDouble(_TheTakeProfit,Digits),0,Green);
        }
*/        
        //return(0);
     }
   


}//sell_UpUp_Sell()

/*
2019/01/25 11:18:46
func-list.(lib_ea.mqh).20190125_111846.txt
==========================================
<funcs>

1	void buy_DownDown_Buy(
2	void buy_DownDown_Sell(
3	bool detect_DownDown_Buy(string _dpath_Log, string _fname_Log_For_Session)
4	bool detect_UpUp_Sell(string _dpath_Log, string _fname_Log_For_Session)

==========================================
==========================================
<vars>


==========================================
*/
