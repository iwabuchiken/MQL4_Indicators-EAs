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
//| vars : flags
//+------------------------------------------------------------------+
bool flg_OrderOpened = false;

int num_Ticket = 0;

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

   /********************************
      test_TrailingStop()
   ********************************/
   test_TrailingStop(diff_Latest);

   if(diff_Latest >= 0)
     {
      
         string txt = "\ndiff_Latest >= 0 ("
                      + (string) NormalizeDouble(diff_Latest,3)
                      + ") ("
                      + d
                      + ")"
                     ;
                      
         write_Log(
               dpath_Log, fname_Log_For_Session
               , __FILE__, __LINE__
               , txt);
         
     }//if(diff_Latest >= 0)

   else//if(diff_Latest >= 0)
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
     
    }//if(diff_Latest >= 0)
   
}//op_NewBar()

//xxx
void test_TrailingStop(double diff_Latest) {

   /********************************
      vars
   ********************************/
   string txt;
   
   double val_TakeProfit = 0.04; // in currency
   double val_StopLoss = 0.02; // in currency
   
   /********************************
      message : function starts
   ********************************/
   //txt = "\ntest_TrailingStop ------------------"
   txt = "\n//test_TrailingStop ------------------"
               + "\n"
                ;
                
   write_Log(
         dpath_Log, fname_Log_For_Session
         , __FILE__, __LINE__
         , txt);

   /********************************
      j2 : order opened ?
   ********************************/
   //_20190827_143229:ref
   if(OrdersTotal() >= 1)
   //if(flg_OrderOpened == true)
     {
         /********************************
            j2 : Y
               order opened
         ********************************/
         //txt = "\n(j2 : Y : 1) flg_OrderOpened == true (total ="
         txt = "\nOrdersTotal() >= 1 (total ="
                     + (string) OrdersTotal()
                     + ")"
                     + "\n"
                      ;
                      
         write_Log(
               dpath_Log, fname_Log_For_Session
               , __FILE__, __LINE__
               , txt);
         
         /********************************
            j2 : Y : 1
               select order
         ********************************/
         bool res = OrderSelect(num_Ticket, SELECT_BY_TICKET);
         
         /********************************
            j2.2
               select order --> error ?
         ********************************/
         // select
         if(OrderSelect(num_Ticket, SELECT_BY_TICKET) == true)
         //if(OrderSelect(num_Ticket, SELECT_BY_TICKET) == true)
          {
            /********************************
               j2.2 : N
                  select order --> error : NO
            ********************************/
               
               /********************************
                  j2.2 : N : 1
                     show : data
               ********************************/
               double price_Open = OrderOpenPrice();
               double price_Close = OrderClosePrice();
               double price_TP = OrderTakeProfit();
               double price_SL = OrderStopLoss();
               
               txt = "\nOrder selected : "
                        + (string) num_Ticket + "\n"

                        //+ "OrderType() = " 
                        //+ (string) OrderType() + "\n"

                        + "OrderType() = "
                        + (string) OrderType()
                        + " / " 
                        + listOf_OrderTypes[OrderType()] + "\n"

                        + "OrderOpenPrice() = " 
                        + (string) price_Open + "\n"

                        + "OrderClosePrice() = " 
                        + (string) price_Close + "\n"

                        + "OrderTakeProfit() = " 
                        + (string) price_TP + "\n"

                        + "OrderStopLoss() = " 
                        + (string) price_SL + "\n"

                        + "Close - SL = " 
                        + (string) (price_Close - price_SL) + "\n"
                            ;
                            
               write_Log(
                     dpath_Log, fname_Log_For_Session
                     , __FILE__, __LINE__
                     , txt);

               /********************************
                  j2.2 : N : 2
                     calc : condition for trailing
                     ref : http://benfranklin.chips.jp/cake_apps/Cake_IFM11/images/view/31351
               ********************************/
               double trailingStop_Threshold;
               bool cond_Exec_Trailing = false;
               
               if(OrderType() == OP_BUY)
                 {
                  
                     trailingStop_Threshold = price_SL + TrailingStop + TrailingStop_Margin;

                     txt = "\nOrderType ==> buy"
                              + "\n"
                                  ;
                                  
                     write_Log(
                           dpath_Log, fname_Log_For_Session
                           , __FILE__, __LINE__
                           , txt);
                           
                     // condition
                     cond_Exec_Trailing = (price_Close > trailingStop_Threshold);
                  
                 }
               else
                 {

                     trailingStop_Threshold = price_SL - TrailingStop - TrailingStop_Margin;

                     txt = "\nOrderType ==> sell"
                              + "\n"
                                  ;
                                  
                     write_Log(
                           dpath_Log, fname_Log_For_Session
                           , __FILE__, __LINE__
                           , txt);

                     // condition
                     cond_Exec_Trailing = (price_Close < trailingStop_Threshold);
                  
                 }
               
               
               
               txt = "\nTrailingStop_Threshold : "
                        + (string) trailingStop_Threshold + "\n"
                        
                        + "\nprice_Close : "
                        + (string) price_Close + "\n"

                        + "\nClose - Threshold : "
                        + (string) NormalizeDouble((price_Close - trailingStop_Threshold),3) + "\n"
                        
                        + "\ncond_Exec_Trailing : "
                        + (string) cond_Exec_Trailing + "\n"
                        
                        + "\n"
                            ;
                            
               write_Log(
                     dpath_Log, fname_Log_For_Session
                     , __FILE__, __LINE__
                     , txt);
               
               
               //ccc
               
          }//if(OrderSelect(num_Ticket, SELECT_BY_TICKET) == true)
         else
           {
            /********************************
               j2.2 : Y
                  select order --> error
            ********************************/

               txt = "\nOrderSelect()(ticket = " 
                        + (string) num_Ticket
                        + ")"
                        + " ==> returned error : "
                        + (string) GetLastError()
                        + "\n"
                            ;
                            
               write_Log(
                     dpath_Log, fname_Log_For_Session
                     , __FILE__, __LINE__
                     , txt);

               /********************************
                  return
               ********************************/
               return;
            
           }//if(OrderSelect(num_Ticket, SELECT_BY_TICKET) == true)
          //Print("OrderSelect returned the error of ",GetLastError());

         /********************************
            j2.0.1
               flag ---> UP ?
         ********************************/
         if(flg_OrderOpened == false)
           {
            /********************************
               j2.0.1 : Y : 1
                  flag ---> not UP; UP
            ********************************/
            flg_OrderOpened = true;              
            
            txt = "\n(j2.0.1 : Y : 1) flg_OrderOpened is now : true"
                        + "\n"
                         ;
                         
            write_Log(
                  dpath_Log, fname_Log_For_Session
                  , __FILE__, __LINE__
                  , txt);
                  
           }//if(flg_OrderOpened == false)
         
         return;

     }
   else//if(OrdersTotal() >= 1)
     {
         /********************************
            j2 : N
               order NOT opened
         ********************************/
         /********************************
            j2.1
               flga ---> UP ?
         ********************************/
         if(flg_OrderOpened == true)
           {
               /********************************
                  j2.1 : Y
                     flga ---> UP
               ********************************/
               /********************************
                  j2.1 : Y : 1
                     flag ---> down
               ********************************/
               flg_OrderOpened = false;
               
           }//if(flg_OrderOpened == true)

         /********************************
            j3 : diff --> up/down ?
         ********************************/
         if(diff_Latest > 0.0)//j3 : diff --> up/down ?
           {
               /********************************
                  j3 : Y
                     diff --> up
               ********************************/
               txt = "\ndiff_Latest ==> UP ("
                           + (string) DoubleToStr(diff_Latest, 3)
                           + ")"
                           + "\n"
                            ;
                            
               write_Log(
                     dpath_Log, fname_Log_For_Session
                     , __FILE__, __LINE__
                     , txt);
               
               /********************************
                  j3 : Y : 1
                     buy
               ********************************/
              double Level_TakeProfit = Bid + 0.04;  // (+0.01 * takeprofit pips) JPY
              double Level_StopLoss = Bid - 0.02;        // (-0.01 * stoploss pips) JPY
               
              num_Ticket = OrderSend(
                  Symbol(), OP_BUY
                  , (double) Lots, (double) Ask
                  , (int) Slippage
                  , (double) NormalizeDouble(Level_StopLoss, Digits())
                  , (double) NormalizeDouble(Level_TakeProfit, Digits())
                  //, Level_StopLoss
                  //, Level_TakeProfit
                  , "EA Generator www.ForexEAdvisor.com"
                  , MagicNumber
                  , 0
                  , Blue);

               txt = "\n(j3 : Y : 1) num_Ticket (buy) : "
                           + (string) num_Ticket
                           + "\n"
                            ;
                            
               write_Log(
                     dpath_Log, fname_Log_For_Session
                     , __FILE__, __LINE__
                     , txt);

               /********************************
                  j3 : Y : 2
                     flag ---> UP
               ********************************/
               flg_OrderOpened = true;

               /********************************
                  return
               ********************************/
               return;
            
           }
         else if (diff_Latest < 0.0)//if(diff_Latest > 0.0) "j3 : diff --> up/down ?"
           {
               /********************************
                  j3 : N
                     diff --> down
               ********************************/
               txt = "\ndiff_Latest ==> DOWN ("
                           + (string) DoubleToStr(diff_Latest, 3)
                           + ")"
                           + "\n"
                            ;
                            
               write_Log(
                     dpath_Log, fname_Log_For_Session
                     , __FILE__, __LINE__
                     , txt);

               /********************************
                  j3 : N : 1
                     sell
               ********************************/
              double Level_TakeProfit = Ask - val_TakeProfit;  // (+0.01 * takeprofit pips) JPY
              double Level_StopLoss = Ask + val_StopLoss;        // (-0.01 * stoploss pips) JPY

              num_Ticket = OrderSend(
                  Symbol(), OP_SELL
                  , Lots, Bid
                  , (int) Slippage
                  , NormalizeDouble(Level_StopLoss, Digits())
                  , NormalizeDouble(Level_TakeProfit, Digits())
                  //, Level_StopLoss
                  //, Level_TakeProfit
                  , "EA Generator www.ForexEAdvisor.com"
                  , MagicNumber
                  , 0
                  , Blue);
/*                  Symbol(), OP_BUY
                  , Lots, Ask
                  , Slippage
                  , NormalizeDouble(Level_StopLoss, Digits())
                  , NormalizeDouble(Level_TakeProfit, Digits())
                  //, Level_StopLoss
                  //, Level_TakeProfit
                  , "EA Generator www.ForexEAdvisor.com"
                  , MagicNumber
                  , 0
                  , Blue);
*/
               txt = "\n(j3 : N : 1) num_Ticket (sell) : "
                           + (string) num_Ticket
                           + "\n"
                            ;
                            //ccc
               write_Log(
                     dpath_Log, fname_Log_For_Session
                     , __FILE__, __LINE__
                     , txt);

               /********************************
                  j3 : Y : 2
                     flag ---> UP
               ********************************/
               flg_OrderOpened = true;

               /********************************
                  return
               ********************************/               
               return;
            
           }
         else//if(diff_Latest > 0.0) "j3 : diff --> up/down ?"
           {
               /********************************
                  j3 : None
                     diff --> zero
               ********************************/

               txt = "\ndiff_Latest ==> "
                           + (string) DoubleToStr(diff_Latest, 3)
                           + "\n"
                            ;
                            
               write_Log(
                     dpath_Log, fname_Log_For_Session
                     , __FILE__, __LINE__
                     , txt);
               
               return;
            
           }//if(diff_Latest > 0.0) "j3 : diff --> up/down ?"
/*         
         string txt = "\nflg_OrderOpened == false"
                     + "\n"
                      ;
                      
         write_Log(
               dpath_Log, fname_Log_For_Session
               , __FILE__, __LINE__
               , txt);
*/
         return;
      
     }//if(OrdersTotal() >= 1)
   
}//test_TrailingStop(double diff_Latest)

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
   show_BasicData();


   // basic data : order-related
   show_OrderData();
   
   
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
