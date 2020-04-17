/*+------------------------------------------------------------------+
   created at : 2020/04/09 14:50:29
   origina file : 
      ea_tester-1.mq4 // C:\Users\iwabuchiken\AppData\Roaming\MetaQuotes\Terminal\34B08C83A5AAE27A4079DE708E60511E\MQL4\Experts\labs\44_10.2

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
      /*
         _is_NewBar()
      */
#include <lib_ea_2.mqh>
#include <lib_ea.mqh>

#include <libfx/libfx_cons.mqh>
//#include <libfx/libfx_tester-1.mqh>

//+------------------------------------------------------------------+
//| externs
//+------------------------------------------------------------------+
extern int Time_period        = PERIOD_M1;
//extern int Time_period        = PERIOD_M5;
//extern int Time_period        = PERIOD_M15;

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

//extern string Sym_Set   = "EURJPY";
extern string Sym_Set   = "AUDJPY";

//+------------------------------------------------------------------+
//| funcs (external)

/***************************
   <list of funcs located in external files>
   2019/12/18 16:46:38
   
   is_Order_Pending  lib_ea_2.mqh
   judge_1           lib_ea_2.mqh
   get_BB_Loc_Num    lib_ea_2.mqh
   take_Position__Buy
   get_BB_Loc_Nums
   
   dp_2__All_True    libfx_dp_1.mqh

*****************/

//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
//| vars                                               |
//+------------------------------------------------------------------+
string PGName = "file=ea-4:dp=dp_2__All_True"
            + "\n"
            + ":StopLoss=" + (string) StopLoss
            + "\n"
            + ":TakeProfit=" + (string) TakeProfit
            + "\n"
            + ":TrailingStop=" + (string) TrailingStop
            + "\n"
            ;     //
//string PGName = "abc";     //

//string txt_Msg;

double __MyPoint   = 0.001;

//string   txt;
//bool     res;

bool SWITHCH_DEBUG_eap_2   = true;

int res_ea_3_i = 0;

double   priceOf_Prev_Tick__Bid     = -1.0;
double priceOf_Current_Tick__Bid    = -1.0;

double   priceOf_Prev_Tick__Ask     = -1.0;
double priceOf_Current_Tick__Ask    = -1.0;

//_20190920_120627:tmp
double   priceOf_Prev_Bid     = -1.0;
double   priceOf_Bid__Max     = -1.0;

// trailing stop/take : 2019/09/10 11:53:13
// unit : points
extern double   TRAILING_LEVEL_STOP = 50.0;
extern double   TRAILING_LEVEL_TAKE = 100.0;

int      valOf_Threshold_Trailing = 40;   // 40 x Points (= 4 pips)

//+------------------------------------------------------------------+
//| vars : flags
//+------------------------------------------------------------------+
bool flg_OrderOpened = false;


//+------------------------------------------------------------------+
//| vars : counter, strings
//+------------------------------------------------------------------+
int num_Ticket = 0;

int cntOf_Ticks = 0;

string fname_Log_For_Session = "[ea-4_tester-1].(" + conv_DateTime_2_SerialTimeLabel((int) TimeLocal()) + ").log";
//string dpath_Log = "Logs"; // under the dir "C:\Users\iwabuchiken\AppData\Roaming\MetaQuotes\Terminal\B9B5D4C0EA7B43E1F3A680F94F757B3D\MQL4\Files"

//_20190829_110901:tmp
string fname_Log_DAT_For_Session = "[ea-3].(" + conv_DateTime_2_SerialTimeLabel((int) TimeLocal()) + ").dat";

string   strOf_EA = "eap-2.id-1";

string dpath_Log = "Logs/" 
               + conv_DateTime_2_SerialTimeLabel((int) TimeLocal()) 
               
               + "["
               + strOf_EA
               + "]"
               + "."
               
               + "["
               + Sym_Set + "-" + (string) Time_period
               + "]"
               
               + ".dir";

string txt_EA_4 = "";   // for general use

bool result_b_global;   // for general use

int result_i_global;   // for general use

//+------------------------------------------------------------------+
//    vars
//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
//    expert start function
//+------------------------------------------------------------------+
//_func:start
int start()
{
   /********************************
      count : ticks
   ********************************/
   cntOf_Ticks += 1;

   //test
   return 0;


   /*
   //debug
   txt = "starting...";
   
   txt += "\n";
   
   Print("[", __FILE__, ":",__LINE__,"] ", txt);
   */
   //debug
   txt_EA_4 = "[" + __FILE__ + ":" + (string) __LINE__ + "] starting..."
            + " (tick = "
            + (string) cntOf_Ticks
            + ")";
   ;
   
   //debug
   Print(txt_EA_4);
   
   write_Log(dpath_Log , fname_Log_For_Session
         , __FILE__ , __LINE__ , txt_EA_4);
   

   /********************************
      step : A : 0
         order --> pending?
   ********************************/
   //_20190918_084005:tmp
   //_20190918_084218:caller
   //_is_Order_Pending();
   
   /********************************
      step : A : 1
         trailing
   ********************************/
   //_20190829_112152:next
   //_20190906_165225:caller
   //trail_Orders();

   /********************************
      step : j1
         new bar ?
   ********************************/
   //_20200409_151057:tmp
   result_b_global = _is_NewBar();

   //debug
   txt_EA_4 = "[" + __FILE__ + ":" + (string) __LINE__ + "] _is_NewBar => " + (string) result_b_global;
   
   //debug
   Print(txt_EA_4);
   
   write_Log(dpath_Log , fname_Log_For_Session
         , __FILE__ , __LINE__ , txt_EA_4);

   //test
   //_20200410_152021:tmp
   if(result_b_global == true)//_is_NewBar
     {
         /********************************
            step : 0
               
         ********************************/
         //_20200410_161525:next
         
     
         /********************************
            step : j1 : Y
               new bar
         ********************************/
         /********************************
            step : j1 : Y : 1
               log
         ********************************/
         //debug
         txt_EA_4 = "[" + __FILE__ + ":" + (string) __LINE__ + "] (step : j1 : Y : 1) new bar";
         
         write_Log(dpath_Log , fname_Log_For_Session
               , __FILE__ , __LINE__ , txt_EA_4);

         /********************************
            step : j2
               order pending ?
         ********************************/
         //_20200413_214758:tmp
         int maxOf_NumOf_Pending_Orders = 40;
         
         bool retVal_b_2 = is_Order_Fully_Pending(maxOf_NumOf_Pending_Orders);
         //int retVal_i_2 = is_Order_Pending();

         //debug
         //txt_EA_4 = "[" + __FILE__ + ":" + (string) __LINE__ + "] (step : j2) retVal_i_2 (is_Order_Pending) => "
         //          + (string) retVal_i_2;
         txt_EA_4 = "[" + __FILE__ + ":" + (string) __LINE__ 
                  + "] (step : j2) retVal_b_2 (is_Order_Fully_Pending) => "
                   + (string) retVal_b_2;
         
         
         write_Log(dpath_Log , fname_Log_For_Session
               , __FILE__ , __LINE__ , txt_EA_4);
         
         //_20200410_154418:tmp
         //if(retVal_i_2 == true)//is_Order_Pending
         //if(retVal_i_2 >= 1)//is_Order_Pending
         if(retVal_b_2 == true)//is_Order_Fully_Pending
           {
               /********************************
                  step : j2 : Y
                     order pending
               ********************************/
               /********************************
                  step : j2 : Y : 1
                     log
               ********************************/
               //debug
               txt_EA_4 = "[" + __FILE__ + ":" + (string) __LINE__ + "]"
                        + " (step : j2 : Y : 1) is_Order_Fully_Pending => true"
                        + " (is_Order_Fully_Pending = "
                        + (string) retVal_b_2
                        //+ " (step : j2 : Y : 1) is_Order_Pending => true"
                        //+ " (is_Order_Pending = "
                        //+ (string) retVal_i_2
                         ;
               
               write_Log(dpath_Log , fname_Log_For_Session
                     , __FILE__ , __LINE__ , txt_EA_4);

               /********************************
                  step : j2 : Y : 2
                     end
               ********************************/
               //debug
               txt_EA_4 = "[" + __FILE__ + ":" + (string) __LINE__ + "]"
                        + " (step : j2 : Y : 2) end"
                         ;
               
               write_Log(dpath_Log , fname_Log_For_Session
                     , __FILE__ , __LINE__ , txt_EA_4);               
               
               // continue
               //continue;
            
           }
         //else//if(retVal_i_2 == true)//is_Order_Pending
         else//if(retVal_i_2 == true)//is_Order_Fully_Pending
          {
               /********************************
                  step : j2 : N
                     order NOT pending
               ********************************/
               /********************************
                  step : j2 : N : 1
                     log
               ********************************/
               //debug
               txt_EA_4 = "[" + __FILE__ + ":" + (string) __LINE__ + "]"
                        + " (step : j2 : N : 1) is_Order_Fully_Pending => false"
                        //+ " (step : j2 : N : 1) is_Order_Pending => false"
                         ;
               
               write_Log(dpath_Log , fname_Log_For_Session
                     , __FILE__ , __LINE__ , txt_EA_4);

               /********************************
                  step : j3
                     buy : condition filled ?
               ********************************/
               /********************************
                  step : j3 : 0
                     conditions
               ********************************/
               bool j3_b = dp_2__All_True();

               /********************************
                  step : j3 : 0.1
                     if sentence
               ********************************/
               if(j3_b == true)//dp_2__All_True
                 {
                     /********************************
                        step : j3 : Y
                           buy : condition filled
                     ********************************/
                     /********************************
                        step : j3 : Y : 1
                           log
                     ********************************/
                     //debug
                     txt_EA_4 = "[" + __FILE__ + ":" + (string) __LINE__ + "]"
                              + " (step : j3 : Y : 1) buy : condition filled"
                               ;
                     
                     write_Log(dpath_Log , fname_Log_For_Session
                           , __FILE__ , __LINE__ , txt_EA_4);

                     /********************************
                        step : j3 : Y : 2
                           buy ==> exec
                     ********************************/
                     //_20200411_104528:tmp
                     double minstoplevel    = 0.05;
                     double mintakelevel    = 0.10;
                     
                     int result_i = take_Position__Buy(minstoplevel, mintakelevel);
                     
                     //debug
                     txt_EA_4 = "[" + __FILE__ + ":" + (string) __LINE__ + "]"
                              + " (step : j3 : Y : 2) buy ==> exec : take_Position__Buy --> "
                              + (string) result_i
                               ;
                     
                     write_Log(dpath_Log , fname_Log_For_Session
                           , __FILE__ , __LINE__ , txt_EA_4);                     
                     
                 }
               else//if(j3_b == true)//dp_2__All_True
                 {
                     /********************************
                        step : j3 : N
                           buy : condition NOT filled
                     ********************************/
                     /********************************
                        step : j3 : N : 1
                           log
                     ********************************/
                     //debug
                     txt_EA_4 = "[" + __FILE__ + ":" + (string) __LINE__ + "]"
                              + " (step : j3 : N : 1) buy : condition NOT filled"
                               ;
                     
                     write_Log(dpath_Log , fname_Log_For_Session
                           , __FILE__ , __LINE__ , txt_EA_4);
                     
                  
                 }//if(j3_b == true)//dp_2__All_True
               
              
           //}//if(retVal_i_2 == true)//is_Order_Pending
           }//if(retVal_i_2 == true)//is_Order_Fully_Pending
      
     }
   else//if(result_b_global == true)//_is_NewBar
    {
         /********************************
            step : j1 : N
               NOT new bar
         ********************************/
         /********************************
            step : j1 : N : 1
               log
         ********************************/
         //debug
         txt_EA_4 = "[" + __FILE__ + ":" + (string) __LINE__ + "] (step : j1 : N : 1) NOT a new bar";
         
         write_Log(dpath_Log , fname_Log_For_Session
               , __FILE__ , __LINE__ , txt_EA_4);     

     }//if(result_b_global == true)//_is_NewBar

   //debug
   //_20200331_173735:tmp
   return(0);
   
   // valid : is a new bar ?
   if(res == true)//_is_NewBar()
     {
         /*******************
            step : j1 : Y
               new bar
         *******************/
         /*******************
            step : j1 : Y : 1
               log
         *******************/
         //debug
         txt = "(step : j1 : Y : 1) new bar";
         write_Log(
               dpath_Log
               , fname_Log_For_Session
               
               , __FILE__, __LINE__
               
               , txt);
         
         /*******************
            step : j1-1
               orders ==> pending ?
         *******************/
         /*******************
            step : j1-1 : 1
               check
         *******************/
         //_20191218_162827:tmp
         //_20191218_163351:caller
         int retVal_i = is_Order_Pending();

         /*******************
            step : j1-1 : 2
               pending ?
         *******************/
         if(retVal_i == -1 && flg_OrderOpened == true)
           {
               /*******************
                  step : j1-1 : Y
                     pending
               *******************/
               /*******************
                  step : j1-1 : Y : 1
                     flag ==> reset
               *******************/
               flg_OrderOpened = false;
      
               //debug
               txt = "(step : j1 : Y : 1) orders not pending; flg_OrderOpened ==> back to false ("
                     + (string) flg_OrderOpened
                     + ")"
                     ;

               write_Log(dpath_Log, fname_Log_For_Session
                     , __FILE__, __LINE__, txt);
                     
           }//if(retVal_i == -1)
         
         
         /*******************
            step : j2
               flag --> True ?
         *******************/
         //_20190910_120006:next
         if(flg_OrderOpened == true)
           {
               /*******************
                  step : j2 : Y
                     flag --> True
               *******************/
               /*******************
                  step : j2 : Y : 1
                     log
               *******************/
               txt = "(step : j2 : Y : 1) flg_OrderOpened ==> true ("
                     + (string) flg_OrderOpened
                     + ")";
                     
               write_Log(
                  dpath_Log
                  //, fname_Log
                  , fname_Log_For_Session
                  , __FILE__
                  , __LINE__
                  , txt);
               
               /*******************
                  step : j2 : Y : 2
                     count : orders
               *******************/
               int cntOf_Orders = OrdersTotal();

               txt = "(step : j2 : Y : 2) count ==> orders ("
                     + (string) cntOf_Orders
                     + ")";
                     
               write_Log(
                  dpath_Log, fname_Log_For_Session
                  , __FILE__, __LINE__
                  , txt
                  );


           }
         else//if(flg_OrderOpened == true)
          {
               /*******************
                  step : j2 : N
                     flag --> False
               *******************/
               /*******************
                  step : j2 : N : 1
                     log
               *******************/
               txt = "(step : j2 : N : 1) flg_OrderOpened ==> false ("
                           + (string) flg_OrderOpened
                           + ")";
                     
               write_Log(
                  dpath_Log
                  //, fname_Log
                  , fname_Log_For_Session
                  , __FILE__
                  , __LINE__
                  , txt);
               
               //_20191216_135445:tmp
               /*******************
                  step : j3
                     pattern ==> detected ? (judge_1)
               *******************/
               //_20191218_170646:next
               //res = judge_1();
               res = judge_1(typeOf_Pattern_DP_TREND_DOWN_1);
               
               if(res == true)   // judge_1()
                 {
                     /*******************
                        step : j3 : Y
                           pattern ==> detected
                     *******************/
                     /*******************
                        step : j3 : Y : 1
                           log
                     *******************/
                     txt = "(step : j3 : Y : 1) pattern ==> detected";
                     
                     write_Log(
                        dpath_Log
                        , fname_Log_For_Session
                        
                        , __FILE__, __LINE__
                        
                        , txt);
                     
                     // return
                     //return(0);
                     
                     //_20191216_141526:tmp
                     /*******************
                        step : j3 : Y : 2
                           position ==> take
                     *******************/
                     txt = "(step : j3 : Y : 2) position ==> taking...";
                     
                     write_Log(dpath_Log, fname_Log_For_Session
                        , __FILE__, __LINE__, txt);

                     // take position
                     res_ea_3_i = take_Position__Sell(TRAILING_LEVEL_STOP, TRAILING_LEVEL_TAKE);
                     
                     //log
                     txt = "(step : j3 : Y : 2) position ==> taken : res_ea_3_i = "
                           + (string) res_ea_3_i;

                     write_Log(dpath_Log, fname_Log_For_Session
                        , __FILE__, __LINE__, txt);

                     /*******************
                        step : j3 : Y : 3
                           flg_Opened ==> true
                     *******************/
                     flg_OrderOpened = true;

                     //log
                     txt = "(step : j3 : Y : 3) flg_Opened ==> true ("
                           + (string) flg_OrderOpened
                           + ")";

                     write_Log(dpath_Log, fname_Log_For_Session
                        , __FILE__, __LINE__, txt);
                     
                     
                     // return
                     return(0);                     
                     
                 }
               else//if(res == true)   // judge_1()
                 {
                     /*******************
                        step : j3 : N
                           pattern ==> NOT detected
                     *******************/
                     /*******************
                        step : j3 : N : 1
                           log
                     *******************/
                     txt = "(step : j3 : Y : 1) pattern ==> NOT detected";
                     
                     write_Log(
                        dpath_Log
                        , fname_Log_For_Session
                        
                        , __FILE__, __LINE__
                        
                        , txt);
                     
                     // return
                     return(0);
                  
                 }//if(res == true)   // judge_1()                    
               
          }//if(flg_OrderOpened == true)
               
     }//if(res == true)
     
   else//if(res == true)//_is_NewBar()
       {

         /*******************
            step : j1 : N
               new bar --> NO
         *******************/
         /*******************
            step : j1 : N : 1
               log
         *******************/
         txt = "(step : j1 : N : 1) new bar --> NO"
                     ;
               
         write_Log(
            dpath_Log
            //, fname_Log
            , fname_Log_For_Session
            , __FILE__
            , __LINE__
            , txt);

   }//if(res == true)//_is_NewBar()


   return(0);

}//start()

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

void setup_Data_File() {

   /*******************
      step : 1
         file name
   *******************/   
   //_20190904_133743:tmp
   //debug
   txt = "# this file\t"
            + fname_Log_DAT_For_Session
               ;
            //OrdersTotal : 0               
   
   //txt += "\n";
   
   write_Log__No_File_Line_Strings(
         dpath_Log, fname_Log_DAT_For_Session
         //, __FILE__, __LINE__
         , txt);  

   /*******************
      step : 2
         pair name, period
   *******************/   
   txt = "# Symbol\t"
            + Symbol()
               ;
            //OrdersTotal : 0               

   txt += "\n";
      
   txt += "# Period\t"
            + (string) Period()
               ;
            //OrdersTotal : 0               
   
   txt += "\n";
   
   write_Log__No_File_Line_Strings(
         dpath_Log, fname_Log_DAT_For_Session
         //, __FILE__, __LINE__
         , txt);  
   

}//setup_Data_File()

//func
int init()
{

   //debug
   Print("[", __FILE__, ":",__LINE__,"] init... : PGName = ", PGName);

   //debug
   txt_EA_4 = "[" + __FILE__ + ":" + (string) __LINE__ + "] "
               + "\n"
               + "init ==> comp : " + PGName;

   Print(txt_EA_4);

   //debug
   write_Log(
         dpath_Log , fname_Log_For_Session
         , __FILE__ , __LINE__ , txt_EA_4);

   //test
   //_20200403_155202:test
   result_i_global = is_Order_Pending();
   
   //debug
   //Print("[", __FILE__, ":",__LINE__,"] is_Order_Pending => ", result);

   //debug
   //txt_EA_4 += "[" + __FILE__ + ":" + (string) __LINE__ + "] is_Order_Pending => " + (string) result_i_global;
   txt_EA_4 = "[" + __FILE__ + ":" + (string) __LINE__ + "] is_Order_Pending => " + (string) result_i_global;
  
   Print(txt_EA_4);

   //debug
   write_Log(
         dpath_Log , fname_Log_For_Session
         , __FILE__ , __LINE__ , txt_EA_4);

   //_20200331_173857:tmp
   // basic data
   //show_BasicData();


   // basic data : order-related
   //show_OrderData();
   
   /*******************
      step : 1
         setup
   *******************/   
   // setup
   //setup();

   //_20200409_150058:tmp
   result_b_global = _is_NewBar();

   //debug
   //txt_EA_4 += "[" + __FILE__ + ":" + (string) __LINE__ + "] _is_NewBar => " + (string) result_b_global;
   txt_EA_4 = "[" + __FILE__ + ":" + (string) __LINE__ + "] "
            //+ "\n"
            + "_is_NewBar => " + (string) result_b_global
            + "\n"
   ;
   
   /*******************
      step : X
         tests : get_BB_Loc_Num
   *******************/   
   int index = 0;
   
   int num_BB_Area = get_BB_Loc_Num(index);

   //debug
   txt_EA_4 += "[" + __FILE__ + ":" + (string) __LINE__ + "] num_BB_Area => "
                + (string) num_BB_Area
                + " ("
                + "index = " + (string) index
                + ")"
                ;

   
   //debug
   Print(txt_EA_4);
   
   write_Log(dpath_Log , fname_Log_For_Session
         , __FILE__ , __LINE__ , txt_EA_4);

   //_20200417_161938:tmp
   int   lenOf_Bars      = 5;
   int   num_Start_Index = 0;
   float lo_BB_Loc_Nums[];
   
   get_BB_Loc_Nums(lenOf_Bars, num_Start_Index, lo_BB_Loc_Nums);

   //debug
   txt_EA_4 = "[" + __FILE__ + ":" + (string) __LINE__ + "] get_BB_Loc_Nums";
   txt_EA_4 += "\n";
   
   for(int i = 0; i < lenOf_Bars; i++)
     {
         // get val
         //debug
         txt_EA_4 += "lo_BB_Loc_Nums[" + (string) i + "]"
                  + "\t"
                  + (string) lo_BB_Loc_Nums[i]
                  + "\n"
             ;
      
     }//for(int i=0; i < lenOf_Bars; i++)

   write_Log(dpath_Log , fname_Log_For_Session
         , __FILE__ , __LINE__ , txt_EA_4);
   
   /*******************
      step : 2
         data file : write : header
   *******************/
   //setup_Data_File();

   //debug
   txt_EA_4 = StringFormat(
            "[%s:%d] init() ==> exiting..."
            , __FILE__
            , __LINE__
            
            );
   txt_EA_4 += "\n";

   write_Log(dpath_Log , fname_Log_For_Session
         , __FILE__ , __LINE__ , txt_EA_4);   

   return(0);

}//int init()
   
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

//func
void trail_Orders() {

//_20190906_165225:caller
//_20190906_165231:head
//_20190906_165238:wl
   
   /*******************
      step : 1
         vars
   *******************/   

   /*******************
      step : 2
         OrdersTotal
   *******************/   
   int numOf_Orders = OrdersTotal();

   //debug
   if(SWITHCH_DEBUG_eap_2 == true)
     {

         txt = "numOf_Orders ==> "
               + (string) numOf_Orders
         ;
         
         txt += "\n";
         
         Print("[", __FILE__, ":",__LINE__,"] ", txt);
      
     }//if(SWITHCH_DEBUG_eap_2 == true)

   /*******************
      step : 3
         OrderSelect
   *******************/   
   //ref https://docs.mql4.com/trading/orderstotal
   int pos = 0;
   
   /*******************
      step : 3.1
         OrderSelect ==> true ?
   *******************/   
   if(OrderSelect(pos,SELECT_BY_POS) != false) {

      /*******************
         step : 3.2
            show : order ticket
      *******************/   
      if(SWITHCH_DEBUG_eap_2 == true)
        {
   
            txt = "OrderTicket ==> "
                  + (string) OrderTicket()
            ;
            
            txt += "\n";
            
            Print("[", __FILE__, ":",__LINE__,"] ", txt);
         
        }//if(SWITHCH_DEBUG_eap_2 == true)   

      /*******************
         step : 3.3
            store --> new price, if higher than the prev
      *******************/
      //ref https://www.mql5.com/en/forum/70074
      MqlTick Latest_Price;
      SymbolInfoTick(Symbol(), Latest_Price);
      
      // current ---> copy to prev
      priceOf_Prev_Tick__Bid = priceOf_Current_Tick__Bid;
      
      priceOf_Current_Tick__Bid = Latest_Price.bid;
      
      priceOf_Current_Tick__Ask = Latest_Price.ask;
      
      //_20190918_090936:tmp
      
      //_20190906_171140:next
      
      //debug
      if(SWITHCH_DEBUG_eap_2 == true)
        {
            //_20190918_092035:tmp
            txt = "priceOf_Current_Tick__Bid ==> "
                  + (string) NormalizeDouble(priceOf_Current_Tick__Bid, 3)
                  //+ (string) priceOf_Current_Tick__Bid
            ;
            
            //txt += "\n";
            txt += " / ";
            
            txt += "priceOf_Prev_Tick__Bid ==> "
                  + (string) NormalizeDouble(priceOf_Prev_Tick__Bid, 3)
                  //+ (string) priceOf_Prev_Tick__Bid
            ;
            
            txt += "\n";

            txt += "priceOf_Current_Tick__Ask ==> "
                  + (string) NormalizeDouble(priceOf_Current_Tick__Ask, 3)
                  //+ (string) priceOf_Current_Tick__Ask
            ;
            
            txt += "\n";

            Print("[", __FILE__, ":",__LINE__,"] ", txt);
         
        }//if(SWITHCH_DEBUG_eap_2 == true)   
      
      /*******************
         step : 4
            trailing
      *******************/
      /*******************
         step : 4.1
            
      *******************/
      double pr_Open = OrderOpenPrice();
      
      //ref https://thefxmaster.com/what-is-bid-and-ask-price-in-forex/
      // ask --> buy ; bid --> sell ; ask > bid (always)
      double SPREAD = NormalizeDouble(Latest_Price.ask - Latest_Price.bid, 3);
      
      //_20190918_085532:tmp
      //double threshold = pr_Open + SPREAD;
      double threshold = pr_Open + valOf_Threshold_Trailing * Point;

      //debug
      if(SWITHCH_DEBUG_eap_2 == true)
        {
            //_20190918_092435:tmp
            txt = "pr_Open ==> "
                  + (string) NormalizeDouble(pr_Open, 3)
                  //+ (string) pr_Open
            ;
            
            //txt += "\n";
            txt += " / ";
            
            txt += "SPREAD ==> "
                  + (string) NormalizeDouble(SPREAD, 3)
                  //+ (string) SPREAD
            ;
            
            txt += " / ";
            txt += "threshold ==> "
                  + (string) NormalizeDouble(threshold, 3)
            ;
            
            // TP        
            txt += "\n";
            
            txt += " / ";
            txt += "OrderTakeProfit ==> "
                  + (string) NormalizeDouble(OrderTakeProfit(), 3)
            ;

            // SL
            txt += "\n";
            
            txt += " / ";
            txt += "OrderStopLoss ==> "
                  + (string) NormalizeDouble(OrderStopLoss(), 3)
            ;
            
            txt += "\n";

            Print("[", __FILE__, ":",__LINE__,"] ", txt);
         
        }//if(SWITHCH_DEBUG_eap_2 == true)   

      /*******************
         step : j1
            current tick bid --> above the threshold ?
      *******************/
      //_20190909_135929:next
 
      //_20190920_115150:tmp
      /*******************
         step : 6 : j1
            new Bid > prev max ?
      *******************/
      if(priceOf_Current_Tick__Bid > priceOf_Bid__Max)
        {
            /*******************
               step : 6 : j1 : Y
                  new Bid > prev max
            *******************/
            /*******************
               step : 6 : j1 : Y : 1
                  max --> update
            *******************/
            priceOf_Bid__Max = priceOf_Current_Tick__Bid;

            /*******************
               step : 6 : j1 : Y : 2
                  log
            *******************/
            // log
            txt = "(step : 6 : j1 : Y : 2) priceOf_Bid__Max ==> updated : "
                  + (string) NormalizeDouble(priceOf_Bid__Max, 3)
            ;
            
            txt += "\n";

            Print("[", __FILE__, ":",__LINE__,"] ", txt);

            write_Log(
                  dpath_Log
                  , fname_Log_For_Session
                  
                  , __FILE__, __LINE__
                  
                  , txt);

            /*******************
               step : 6 : j2
                  pr_Max > pr_Open + 4 pips ?
            *******************/
            //_20190920_122313:next
            double ts_Trailing = pr_Open + valOf_Threshold_Trailing * Point;
            
            bool cond_1 = priceOf_Bid__Max > ts_Trailing;
            
            if(cond_1 == true)
              {
                  /*******************
                     step : 6 : j2 : Y
                        pr_Max > pr_Open + 4 pips
                  *******************/
                  /*******************
                     step : 6 : j2 : Y : 1
                        log
                  *******************/
                  // log
                  txt = "(step : 6 : j2 : Y : 1) pr_Max > pr_Open + 4 pips : "
                        + (string) NormalizeDouble(priceOf_Bid__Max, 3)
                        + " / "
                        + (string) NormalizeDouble(pr_Open, 3)
                  ;
                  
                  txt += "\n";
      
                  Print("[", __FILE__, ":",__LINE__,"] ", txt);
      
                  write_Log(
                        dpath_Log
                        , fname_Log_For_Session
                        
                        , __FILE__, __LINE__
                        
                        , txt);

                  /*******************
                     step : 6 : j2 : Y : 2.1
                        set : new TP, SL
                  *******************/
                  //_20190924_115546:next
                  
                  double priceOf_TP_new = priceOf_Bid__Max + TRAILING_LEVEL_TAKE * Point;
                  
                  double priceOf_SL_new = priceOf_Bid__Max - TRAILING_LEVEL_STOP * Point;
                  
                  
                  /*******************
                     step : 6 : j2 : Y : 2.2
                        exec : modify order
                  *******************/
                  /*******************
                     step : 6 : j2 : Y : 2.2 : 1
                        prep
                  *******************/
                  num_Ticket = OrderTicket();
                  
                  /*******************
                     step : 6 : j2 : Y : 2.2 : 2
                        modify
                  *******************/
                  res = OrderModify(num_Ticket, pr_Open, priceOf_SL_new, priceOf_TP_new, 0, Blue);
                  
                  //debug
                  if(!res)
                     Print("Error in OrderModify. Error code = ",GetLastError());
                  else
                    {
                        //_20190927_120146:next
                        // log
                        txt = "(step : 6 : j2 : Y : 2.2 : 2) order ==> modified ("
                              + (string) num_Ticket
                              + ")"
                        ;
                        
                        txt += "\n";
            
                        Print("[", __FILE__, ":",__LINE__,"] ", txt);
            
                        write_Log(
                              dpath_Log
                              , fname_Log_For_Session
                              
                              , __FILE__, __LINE__
                              
                              , txt);                     
                    }
                     //Print("Order modified successfully.");                  
                  

               
              }
            else//if(cond_1 == true)
              {
                  /*******************
                     step : 6 : j2 : N
                        pr_Max <= pr_Open + 4 pips
                  *******************/
                  /*******************
                     step : 6 : j2 : N : 1
                        log
                  *******************/
                  // log
                  txt = "(step : 6 : j2 : N : 1) pr_Max <= pr_Open + 4 pips : "
                        + (string) NormalizeDouble(priceOf_Bid__Max, 3)
                        + " / "
                        + (string) NormalizeDouble(pr_Open + Point * valOf_Threshold_Trailing, 3)  //_20190926_094101:tmp
                        //+ (string) NormalizeDouble(pr_Open, 3)
                  ;
                  
                  txt += "\n";
      
                  Print("[", __FILE__, ":",__LINE__,"] ", txt);
      
                  write_Log(
                        dpath_Log
                        , fname_Log_For_Session
                        
                        , __FILE__, __LINE__
                        
                        , txt);
               
              }//if(cond_1 == true)

            
        }
      else//if(priceOf_Current_Tick__Bid > priceOf_Bid__Max)
        {
            /*******************
               step : 6 : j1 : N
                  new Bid <= prev max
            *******************/
            /*******************
               step : 6 : j1 : N : 1
                  log
            *******************/
            // log
            txt = "priceOf_Bid__Max ==> Remain (curr = "
                  + (string) NormalizeDouble(priceOf_Current_Tick__Bid, 3)
                  + " / "
                  + "max = "
                  + (string) NormalizeDouble(priceOf_Bid__Max, 3)
                  + ")"
            ;
            
            txt += "\n";

            Print("[", __FILE__, ":",__LINE__,"] ", txt);
         
        }////if(priceOf_Current_Tick__Bid > priceOf_Bid__Max)
        
         
   }//if(OrderSelect(pos,SELECT_BY_POS) != false) {
   

}//trail_Orders()

//func
int _is_Order_Pending() {

//_20190918_084218:caller
//_20190918_084223:head
//_20190918_084227:wl   

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
         txt = "(step : j2 : Y) flg_OrderOpened ==> true ("
               + (string) flg_OrderOpened
               + ")";
               
         write_Log(
            dpath_Log
            //, fname_Log
            , fname_Log_For_Session
            , __FILE__
            , __LINE__
            , txt);
         
         /*******************
            step : j2 : Y : 1
               count : orders
         *******************/
         int cntOf_Orders = OrdersTotal();

         txt = "(step : j2 : Y : 1) count ==> orders ("
               + (string) cntOf_Orders
               + ")";
               
         write_Log(
            dpath_Log, fname_Log_For_Session
            , __FILE__, __LINE__
            , txt
            );

         /*******************
            step : j2-1
               orders --> pending ?
         *******************/
         if(cntOf_Orders > 0)
           {
               /*******************
                  step : j2-1 : Y
                     orders --> pending
               *******************/
               txt = "(step : j2-1 : Y) orders --> pending";
                     
                     ;
                     
               write_Log(
                  dpath_Log, fname_Log_For_Session
                  , __FILE__, __LINE__
                  , txt
                  );

               /*******************
                  step : j2-1 : Y : 1
                     return
               *******************/
               txt = "(step : j2-1 : Y : 1) returning...";
                     
               write_Log(
                  dpath_Log, fname_Log_For_Session
                  , __FILE__, __LINE__
                  , txt
                  );
               
               // return
               return(0);
               
            
           }
         else//if(cntOf_Orders > 0)
           {
               /*******************
                  step : j2-1 : N
                     orders --> NOT pending
               *******************/
               txt = "(step : j2-1 : N) orders --> NOT pending";
                     
               write_Log(
                  dpath_Log, fname_Log_For_Session
                  , __FILE__, __LINE__
                  , txt
                  );

               /*******************
                  step : j2-1 : N : 1
                     flag --> reset
               *******************/
               flg_OrderOpened = false;

               txt = "(step : j2-1 : N : 1) flag --> reset done ("
                       + (string) flg_OrderOpened
                       + ")"
                     ;
                     
               write_Log(
                  dpath_Log, fname_Log_For_Session
                  , __FILE__, __LINE__
                  , txt
                  );
                  
               //_20190829_104432:tmp
               /*******************
                  step : j2-2
                     judge_1 ==> true ?
               *******************/
               
               //_20190826_133747:caller
               res = judge_1(typeOf_Pattern_DP_TREND_DOWN_1);
               
               if(res == true)
                 {
                     /*******************
                        step : j2-2 : Y
                           judge_1 ==> true
                     *******************/
                     txt = "(step : j2-2 : Y) judge_1 ==> true";
                     write_Log(
                        dpath_Log
                        , fname_Log_For_Session
                        
                        , __FILE__, __LINE__
                        
                        , txt);
                     
                     
                     /*******************
                        step : j2-2 : Y : 1
                           take --> position
                     *******************/
                     //_20190827_131828:caller
                     res_ea_3_i = take_Position__Buy(TRAILING_LEVEL_STOP, TRAILING_LEVEL_TAKE);

                     txt = "(step : j2-2 : Y : 1) position ==> taken : "
                           + (string) res_ea_3_i;
                           
                     write_Log(
                        dpath_Log
                        , fname_Log_For_Session
                        
                        , __FILE__, __LINE__
                        
                        , txt);

                     /*******************
                        step : j2-2 : Y : 2
                           flag --> true
                     *******************/
                     flg_OrderOpened = true;

                     txt = "(step : j2-2 : Y : 2) flag ==> true ("
                           + (string) flg_OrderOpened
                           + ")"
                           ;
                           
                     write_Log(
                        dpath_Log
                        , fname_Log_For_Session
                        
                        , __FILE__, __LINE__
                        
                        , txt);

                     /*******************
                        step : j2-2 : Y : 3
                           return
                     *******************/
                     txt = "(step : j2-2 : Y : 3) returning...";
                           
                     write_Log(
                        dpath_Log
                        , fname_Log_For_Session
                        
                        , __FILE__, __LINE__
                        
                        , txt);
                     
                     // return
                     return(0);
                     
                 }
               else//if(res == true)
                 {
                     /*******************
                        step : j2-2 : N
                           judge_1 ==> false
                     *******************/
                     txt = "(step : j2-2 : N) judge_1 ==> false";
                     write_Log(
                        dpath_Log
                        , fname_Log_For_Session
                        
                        , __FILE__, __LINE__
                        
                        , txt);

                     /*******************
                        step : j2-2 : N : 1
                           return
                     *******************/
                     txt = "(step : j2-2 : N : 1) returning...";
                           
                     write_Log(
                        dpath_Log
                        , fname_Log_For_Session
                        
                        , __FILE__, __LINE__
                        
                        , txt);

                     // return
                     return(0);
                  
                 }//if(res == true)

                 
//                     /*******************
//                        step : j2-1 : N : 2
//                           return
//                     *******************/
//                     txt = "(step : j2-1 : N : 2) returning...";
//                           
//                     write_Log(
//                        dpath_Log, fname_Log_For_Session
//                        , __FILE__, __LINE__
//                        , txt
//                        );
//                     
//                     // return
//                     return(0);
               
           }//if(cntOf_Orders > 0)
         
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
         res = judge_1(typeOf_Pattern_DP_TREND_DOWN_1);
         
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
               /*******************
                  step : j3 : Y : 1
                     take --> position
               *******************/
               //_20190827_131828:caller
               res_ea_3_i = take_Position__Buy(TRAILING_LEVEL_STOP, TRAILING_LEVEL_TAKE);

               txt = "(step : j3 : Y : 1) position ==> taken : "
                     + (string) res_ea_3_i;
                     
               write_Log(
                  dpath_Log
                  , fname_Log_For_Session
                  
                  , __FILE__, __LINE__
                  
                  , txt);

               /*******************
                  step : j3 : Y : 2
                     flag --> true
               *******************/
               flg_OrderOpened = true;

               txt = "(step : j3 : Y : 2) flag ==> true ("
                     + (string) flg_OrderOpened
                     + ")"
                     ;
                     
               write_Log(
                  dpath_Log
                  , fname_Log_For_Session
                  
                  , __FILE__, __LINE__
                  
                  , txt);

               /*******************
                  step : j3 : Y : 3
                     return
               *******************/
               txt = "(step : j3 : Y : 3) returning...";
                     
               write_Log(
                  dpath_Log
                  , fname_Log_For_Session
                  
                  , __FILE__, __LINE__
                  
                  , txt);
               
               // return
               return(0);
               
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

               /*******************
                  step : j3 : N : 1
                     return
               *******************/
               txt = "(step : j3 : N : 1) returning...";
                     
               write_Log(
                  dpath_Log
                  , fname_Log_For_Session
                  
                  , __FILE__, __LINE__
                  
                  , txt);

               // return
               return(0);
            
           }//if(res == true)
    
    }//if(flg_OrderOpened == true)

}//int _is_Order_Pending() //func


/*
2020/04/09 14:47:15
func-list.(ea-4.mq4).20200409_144715.txt
==========================================
<funcs>

1	int _is_Order_Pending() {
2	int init()
3	void setup() {
4	void setup_Data_File() {
5	void show_BasicData() {
6	void show_OrderData() {
7	int start()
8	void trail_Orders() {

==========================================
==========================================
<vars>

1	string PGName = "abc";     //
2	bool SWITHCH_DEBUG_eap_2   = true;
3	int cntOf_Ticks = 0;
4	bool flg_OrderOpened = false;
5	string fname_Log_DAT_For_Session = "[ea-3].(" + conv_DateTime_2_SerialTimeLabel((int) TimeLocal()) + ").dat";
6	string fname_Log_For_Session = "[ea_tester-1].(" + conv_DateTime_2_SerialTimeLabel((int) TimeLocal()) + ").log";
7	int num_Ticket = 0;
8	int res_ea_3_i = 0;

==========================================
==========================================
<externs, inputs>

1	extern double Lots      = 0.1;
2	extern int MagicNumber  = 10001;
3	extern double Slippage     = 0.01;  // Slippage (in currency)
4	extern double StopLoss  = 20 * 0.001;  // StopLoss (in currency)
5	extern string Sym_Set   = "AUDJPY";
6	extern double   TRAILING_LEVEL_STOP = 50.0;
7	extern double   TRAILING_LEVEL_TAKE = 100.0;
8	extern double TakeProfit= 40 * 0.001;  // TakeProfit (in currency)
9	extern int Time_period        = PERIOD_M1;
10	extern double TrailingStop = 0.03;  // TrailingStop (in currency)
11	extern double TrailingStop_Margin     = 0.01;

==========================================
*/
