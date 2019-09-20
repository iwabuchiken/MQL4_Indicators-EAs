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
//| externs
//+------------------------------------------------------------------+
//extern int Time_period        = PERIOD_M1;
//extern int Time_period        = PERIOD_M5;
extern int Time_period        = PERIOD_M15;

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
//| vars                                               |
//+------------------------------------------------------------------+
string PGName = "abc";     //

//string txt_Msg;

double __MyPoint   = 0.001;

string   txt;
bool     res;

bool SWITHCH_DEBUG_eap_2   = true;

int res_eap_2_i = 0;

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

string fname_Log_For_Session = "[eap-2.id-1].(" + conv_DateTime_2_SerialTimeLabel((int) TimeLocal()) + ").log";
//string dpath_Log = "Logs"; // under the dir "C:\Users\iwabuchiken\AppData\Roaming\MetaQuotes\Terminal\B9B5D4C0EA7B43E1F3A680F94F757B3D\MQL4\Files"

//_20190829_110901:tmp
string fname_Log_DAT_For_Session = "[eap-2.id-1].(" + conv_DateTime_2_SerialTimeLabel((int) TimeLocal()) + ").dat";

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

   //debug
   txt = "starting...";
   
   txt += "\n";
   
   Print("[", __FILE__, ":",__LINE__,"] ", txt);

   /********************************
      step : A : 0
         order --> pending?
   ********************************/
   //_20190918_084005:tmp
   //_20190918_084218:caller
   _is_Order_Pending();
   
   /********************************
      step : A : 1
         trailing
   ********************************/
   //_20190829_112152:next
   //_20190906_165225:caller
   trail_Orders();

   /********************************
      step : j1
         new bar ?
   ********************************/
   res = _is_NewBar();
   
   // valid : is a new bar ?
   if(res == true)//_is_NewBar()
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
         //_20190910_120006:next
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
                     res = judge_1();
                     
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
                           res_eap_2_i = take_Position__Buy(TRAILING_LEVEL_STOP, TRAILING_LEVEL_TAKE);
      
                           txt = "(step : j2-2 : Y : 1) position ==> taken : "
                                 + (string) res_eap_2_i;
                                 
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
                     /*******************
                        step : j3 : Y : 1
                           take --> position
                     *******************/
                     //_20190827_131828:caller
                     res_eap_2_i = take_Position__Buy(TRAILING_LEVEL_STOP, TRAILING_LEVEL_TAKE);

                     txt = "(step : j3 : Y : 1) position ==> taken : "
                           + (string) res_eap_2_i;
                           
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
               
     }//if(res == true)
     
   else//if(res == true)//_is_NewBar()
       {

         /*******************
            step : j1 : N
               new bar --> NO
         *******************/
         //_20190828_102028:next
         /*******************
            step : j1-2
               position ==> taken ?
         *******************/
         if(flg_OrderOpened == true)
           {
               /*******************
                  step : j1-2 : Y
                     judge_1 ==> true
               *******************/
               /*******************
                  step : j1-2 : Y : 1
                     return
               *******************/
//               txt = "(step : j1-2 : Y) returning...";
//                     
//               write_Log(
//                  dpath_Log
//                  , fname_Log_For_Session
//                  
//                  , __FILE__, __LINE__
//                  
//                  , txt);
               
               // return
               return(0);
            
           }
         else//if(flg_OrderOpened == true)
           {
               /*******************
                  step : j1-2 : N
                     judge_1 ==> false
               *******************/
               /*******************
                  step : j1-3
                     judge_1 ==> true ?
               *******************/
               res = judge_1();
               
               if(res == true)
                 {
                     /*******************
                        step : j1-3 :Y
                           judge_1 ==> true
                     *******************/
                     txt = "(step : j1-3 :Y) judge_1 ==> true";
                     write_Log(
                        dpath_Log
                        , fname_Log_For_Session
                        
                        , __FILE__, __LINE__
                        
                        , txt);
                     
                     //_20190826_135520:next   
                     /*******************
                        step : j1-3 :Y : 1
                           take --> position
                     *******************/
                     //_20190827_131828:caller
                     res_eap_2_i = take_Position__Buy(TRAILING_LEVEL_STOP, TRAILING_LEVEL_TAKE);
      
                     txt = "(step : j1-3 :Y : 1) position ==> taken : "
                           + (string) res_eap_2_i;
                           
                     write_Log(
                        dpath_Log
                        , fname_Log_For_Session
                        
                        , __FILE__, __LINE__
                        
                        , txt);
      
                     /*******************
                        step : j1-3 :Y : 2
                           flag --> true
                     *******************/
                     flg_OrderOpened = true;
      
                     txt = "(step : j1-3 :Y : 2) flag ==> true ("
                           + (string) flg_OrderOpened
                           + ")"
                           ;
                           
                     write_Log(
                        dpath_Log
                        , fname_Log_For_Session
                        
                        , __FILE__, __LINE__
                        
                        , txt);
      
                     /*******************
                        step : j1-3 :Y : 3
                           return
                     *******************/
                     txt = "(step : j1-3 :Y : 3) returning...";
                           
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
                        step : j1-3 :N
                           judge_1 ==> false
                     *******************/
                     txt = "(step : j1-3 :N) judge_1 ==> false";
                     write_Log(
                        dpath_Log
                        , fname_Log_For_Session
                        
                        , __FILE__, __LINE__
                        
                        , txt);
      
                     /*******************
                        step : j1-3 :N : 1
                           return
                     *******************/
                     txt = "(step : j1-3 :N : 1) returning...";
                           
                     write_Log(
                        dpath_Log
                        , fname_Log_For_Session
                        
                        , __FILE__, __LINE__
                        
                        , txt);
      
                     // return
                     return(0);
                  
                 }//if(res == true)
            
           }//if(flg_OrderOpened == true)
           
         /*******************
            step : j1-2
               position --> to take ?
         *******************/
         

         /*******************
            step : j1-3
               position --> taken ?
         *******************/
         
         /*******************
            step : j1 : N : 1
               continue
         *******************/
        return(0);
        
       }//if(res == true)//_is_NewBar()


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

int init()
{

   //debug
   Print("[", __FILE__, ":",__LINE__,"] init... ", PGName);

   // basic data
   //show_BasicData();


   // basic data : order-related
   //show_OrderData();
   
   /*******************
      step : 1
         setup
   *******************/   
   // setup
   setup();

   //_is_NewBar();

   /*******************
      step : 2
         data file : write : header
   *******************/
   setup_Data_File();
    
 

   
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
            txt = "priceOf_Bid__Max ==> updated : "
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
               res = judge_1();
               
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
                     res_eap_2_i = take_Position__Buy(TRAILING_LEVEL_STOP, TRAILING_LEVEL_TAKE);

                     txt = "(step : j2-2 : Y : 1) position ==> taken : "
                           + (string) res_eap_2_i;
                           
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
               /*******************
                  step : j3 : Y : 1
                     take --> position
               *******************/
               //_20190827_131828:caller
               res_eap_2_i = take_Position__Buy(TRAILING_LEVEL_STOP, TRAILING_LEVEL_TAKE);

               txt = "(step : j3 : Y : 1) position ==> taken : "
                     + (string) res_eap_2_i;
                     
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
2019/09/09 13:52:06
func-list.(eap-2.(id-1).mq4).20190909_135206.txt
==========================================
<funcs>

1	int init()
2	void setup() {
3	void setup_Data_File() {
4	void show_BasicData() {
5	void show_OrderData() {
6	int start()
7	void trail_Orders() {

==========================================
==========================================
<vars>

1	string PGName = "abc";     //
2	bool SWITHCH_DEBUG_eap_2   = true;
3	int cntOf_Ticks = 0;
4	bool flg_OrderOpened = false;
5	string fname_Log_DAT_For_Session = "[eap-2.id-1].(" + conv_DateTime_2_SerialTimeLabel((int) TimeLocal()) + ").dat";
6	string fname_Log_For_Session = "[eap-2.id-1].(" + conv_DateTime_2_SerialTimeLabel((int) TimeLocal()) + ").log";
7	int num_Ticket = 0;
8	int res_eap_2_i = 0;

==========================================
==========================================
<externs, inputs>

1	extern double Lots      = 0.1;
2	extern int MagicNumber  = 10001;
3	extern double Slippage     = 0.01;  // Slippage (in currency)
4	extern double StopLoss  = 20 * 0.001;  // StopLoss (in currency)
5	extern string Sym_Set   = "EURJPY";
6	extern double TakeProfit= 40 * 0.001;  // TakeProfit (in currency)
7	extern int Time_period        = PERIOD_M1;
8	extern double TrailingStop = 0.03;  // TrailingStop (in currency)
9	extern double TrailingStop_Margin     = 0.01;

==========================================
*/
