//+------------------------------------------------------------------+
//| C:\Users\iwabuchiken\AppData\Roaming\MetaQuotes\Terminal\34B08C83A5AAE27A4079DE708E60511E\MQL4\Include\
//    lib_ea_2.mqh
//+------------------------------------------------------------------+
#property copyright "Copyright 2016, MetaQuotes Software Corp."
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
#include <utils.mqh>
//#include <lib_ea_2.mqh>
#include <libfx/libfx_dp_1.mqh>

//extern int NUMOF_TARGET_BARS;

//extern string dpath_Log;

/***************************
   <list of funcs located in external files>
   2019/12/19 12:57:03
   
   dp_Trend_Down_1   libfx_dp_1.mqh

*****************/

/*---------------------
   vars
---------------------*/
bool SWITHCH_DEBUG_lib_ea_2   = true;

string   txt;
bool     res;

/*---------------------

   bool judge_1()
   
   at : 2019/08/26 13:36:27

---------------------*/
//bool judge_1() {
bool judge_1(string typeOf_Pattern_s) {

//_20190826_133747:caller
//_20190826_133801:head
//_20190826_133815:wl

   /*******************
      step : 1
         prep : vars
   *******************/
   bool  valOf_Judge = false;
   
   /*******************
      step : 2
         judge
   *******************/
   if(typeOf_Pattern_s == typeOf_Pattern_DP_TREND_DOWN_1)
     {
         /*******************
            step : 2 : 1
               judge : typeOf_Pattern_DP_TREND_DOWN_1
         *******************/
         /*******************
            step : 2 : 1.1
               log
         *******************/
         //debug
         txt = "(step : 2 : 1.1) judge : typeOf_Pattern_DP_TREND_DOWN_1";

         write_Log(dpath_Log, fname_Log_For_Session
               , __FILE__, __LINE__, txt);

         /*******************
            step : 2 : 1.2
               set : val
         *******************/
         //valOf_Judge = true;
         //_20191219_130232:caller
         valOf_Judge = dp_Trend_Down_1();

         //debug
         txt = "(step : 2 : 1.2) judge : dp_Trend_Down_1 => "
               + (string) valOf_Judge
               + ")"
               ;

         write_Log(dpath_Log, fname_Log_For_Session
               , __FILE__, __LINE__, txt);
         
         
     }//if(typeOf_Pattern_s == typeOf_Pattern_DP_TREND_DOWN_1)
   else
     {
         /*******************
            step : 2 : X
               judge : unknown pattern type
         *******************/
         /*******************
            step : 2 : X.1
               log
         *******************/
         //debug
         txt = "(step : 2 : X.1) judge : unknown pattern type";

         write_Log(dpath_Log, fname_Log_For_Session
               , __FILE__, __LINE__, txt);

         /*******************
            step : 2 : 1.2
               set : val
         *******************/
         valOf_Judge = false;
      
     }//if(typeOf_Pattern_s == typeOf_Pattern_DP_TREND_DOWN_1)  
   
   /*******************
      step : X
         return
   *******************/
   //return true;
   return valOf_Judge;

}// judge_1()

/*---------------------

   int take_Position__Buy()
   
   at : 2019/08/27 13:14:21

https://docs.mql4.com/trading/ordersend

int  OrderSend(
   string   symbol,              // symbol      1
   int      cmd,                 // operation   2

   double   volume,              // volume      3
   double   price,               // price       4

   int      slippage,            // slippage    5
   double   stoploss,            // stop loss   6
   double   takeprofit,          // take profit 7

   string   comment=NULL,        // comment     8

   int      magic=0,             // magic number   9

   datetime expiration=0,        // pending order expiration   10
   color    arrow_color=clrNONE  // color                      11

   );
   
---------------------*/
//func
//int take_Position__Buy() {
int take_Position__Buy(double _minstoplevel, double _mintakelevel) {

//_20190827_131828:caller
//_20190827_131835:head
//_20190827_131838:wl

   /*******************
      step : 1
         prep : vars
   *******************/
   //ref https://docs.mql4.com/trading/ordersend
   double price=Ask;
   
   //double minstoplevel=MarketInfo(Symbol(),MODE_STOPLEVEL);
   double minstoplevel     = _minstoplevel;
   //double minstoplevel     = 4.0;
   //double mintakelevel     = 8.0;
   double mintakelevel     = _mintakelevel;
   //double mintakelevel     = 8.0;
   
   double stoploss=NormalizeDouble(Bid-minstoplevel*Point,Digits);
   
   //double takeprofit=NormalizeDouble(Bid+minstoplevel*Point,Digits);
   //double takeprofit    = NormalizeDouble(Bid + mintakelevel * Point, Digits);
   //double takeprofit    = NormalizeDouble(Bid + (Ask - Bid) + mintakelevel * Point, Digits);
   double takeprofit    = NormalizeDouble(Bid + mintakelevel * Point, Digits);
   
   //debug
   if(SWITHCH_DEBUG_lib_ea_2 == true)
     {

         txt = "(step : 1) vars";
         txt += "\n";
         
         
         txt += "price\t" + (string) price;
         txt += "\n";
                       
         txt += "Ask\t" + (string) NormalizeDouble(Ask, Digits);
         txt += "\n";
                       
         txt += "Bid\t" + (string) NormalizeDouble(Bid, Digits);
         txt += "\n";
                       
         txt += "(Ask - Bid)\t" + (string) NormalizeDouble((Ask - Bid), Digits);
         //NormalizeDouble(Bid + (Ask - Bid) + mintakelevel * Point, Digits)
         txt += "\n";
                       
         txt += "Point\t" + (string) NormalizeDouble(Point, Digits);
         txt += "\n";
                       
         txt += "Digits\t" + (string) Digits;
         txt += "\n";
         
                  //price	117.358
                  //Point	0.001
                  //Digits	3         

         txt += "minstoplevel\t" + (string) NormalizeDouble(minstoplevel, Digits);
         txt += "\n";
           
         txt += "mintakelevel\t" + (string) NormalizeDouble(mintakelevel, Digits);
         txt += "\n";
           
         txt += "stoploss\t" + (string) NormalizeDouble(stoploss, Digits);
         txt += "\n";
           
         txt += "takeprofit\t" + (string) NormalizeDouble(takeprofit, Digits);
         txt += "\n";
         
         write_Log(
            dpath_Log
            , fname_Log_For_Session
            
            , __FILE__, __LINE__
            
            , txt);
      
     }   
   
   
   /*******************
      step : 2
         buy
   *******************/
   int ticket=OrderSend(
                  Symbol()
                  ,OP_BUY
                  
                  ,1
                  ,price
                  ,3          // slippage             5
                  
                  ,stoploss
                  ,takeprofit
                  
                  ,"My order"
                  ,16384
                  
                  ,0          // pending order expiration   10
                  ,clrGreen
                  );

   if(ticket<0)
     {
      Print("OrderSend failed with error #",GetLastError());

      txt = "OrderSend failed with error #" + (string) GetLastError();
      txt += "\n";
      
      write_Log(
         dpath_Log
         , fname_Log_For_Session
         
         , __FILE__, __LINE__
         
         , txt);
      
     }
   else {
         
         Print("OrderSend placed successfully");
         
         txt = "OrderSend placed successfully : " + (string) ticket;
         txt += "\n";
         
         write_Log(
            dpath_Log
            , fname_Log_For_Session
            
            , __FILE__, __LINE__
            
            , txt);
         
         
         //_20190829_110834:tmp
         // log : data
         // ticket num, ask, bid, minstoplevel, mintakelevel, stoploss, takeprofit
         txt = "\t"
               + (string) ticket
               + "\t"
               + (string) NormalizeDouble(Ask, Digits)
               + "\t"
               + (string) NormalizeDouble(Bid, Digits)
               + "\t"
               
               + (string) NormalizeDouble(minstoplevel, Digits)
               + "\t"
               
               + (string) NormalizeDouble(mintakelevel, Digits)
               + "\t"

               + (string) NormalizeDouble(stoploss, Digits)
               + "\t"

               + (string) NormalizeDouble(takeprofit, Digits)
                              + "\t"

               ;
               
         write_Log(
            dpath_Log
            , fname_Log_DAT_For_Session
            
            , __FILE__, __LINE__
            
            , txt);            
         
   //---
     }
     
   /*******************
      step : X
         return
   *******************/
   int ret = ticket;
   //int ret = -1;
   
   return ret;
   

}//take_Position__Buy() //func


/*---------------------

   int take_Position__Sell()
   
   at : 2019/08/27 13:14:21

https://docs.mql4.com/trading/ordersend

int  OrderSend(
   string   symbol,              // symbol      1
   int      cmd,                 // operation   2

   double   volume,              // volume      3
   double   price,               // price       4

   int      slippage,            // slippage    5
   double   stoploss,            // stop loss   6
   double   takeprofit,          // take profit 7

   string   comment=NULL,        // comment     8

   int      magic=0,             // magic number   9

   datetime expiration=0,        // pending order expiration   10
   color    arrow_color=clrNONE  // color                      11

   );
   
---------------------*/
//func
//int take_Position__Sell() {
int take_Position__Sell(double _minstoplevel, double _mintakelevel) {

//_20190827_131828:caller
//_20190827_131835:head
//_20190827_131838:wl

   /*******************
      step : 1
         prep : vars
   *******************/
   //ref https://docs.mql4.com/trading/ordersend
   //double price=Ask;
   //double price= Bid; 
   double price_Order = Bid; // selling price (the fx operator sells to you at this price)
                     // (https://www.uedaharlowfx.jp/dictionary/アスク（ask）.html, http://fx-hitobashira.com/fx人柱さんのfx奮闘記/分かりやすい！fx用語解説/アスク（ask）とは？.html)
                     // Bid ==> buying price (the fx operator buys from you at this price)
                     // Ask > Bid
   //double minstoplevel=MarketInfo(Symbol(),MODE_STOPLEVEL);
   double minstoplevel     = _minstoplevel;
   //double minstoplevel     = 4.0;
   //double mintakelevel     = 8.0;
   double mintakelevel     = _mintakelevel;
   //double mintakelevel     = 8.0;
   
   //double stoploss = NormalizeDouble( Bid - minstoplevel * Point, Digits);
   double stoploss = NormalizeDouble( Ask + minstoplevel * Point, Digits);
   
   //double takeprofit=NormalizeDouble(Bid+minstoplevel*Point,Digits);
   //double takeprofit    = NormalizeDouble(Bid + mintakelevel * Point, Digits);
   //double takeprofit    = NormalizeDouble(Bid + (Ask - Bid) + mintakelevel * Point, Digits);
   //double takeprofit    = NormalizeDouble(Bid + mintakelevel * Point, Digits);
   double takeprofit    = NormalizeDouble(Ask - mintakelevel * Point, Digits);
   
   //debug
   if(SWITHCH_DEBUG_lib_ea_2 == true)
     {

         txt = "(step : 1) vars";
         txt += "\n";
         
         
         //txt += "price\t" + (string) price;
         txt += "price\t" + (string) price_Order;
         txt += "\n";
                       
         txt += "Ask\t" + (string) NormalizeDouble(Ask, Digits);
         txt += "\n";
                       
         txt += "Bid\t" + (string) NormalizeDouble(Bid, Digits);
         txt += "\n";
                       
         txt += "(Ask - Bid)\t" + (string) NormalizeDouble((Ask - Bid), Digits);
         //NormalizeDouble(Bid + (Ask - Bid) + mintakelevel * Point, Digits)
         txt += "\n";
                       
         txt += "Point\t" + (string) NormalizeDouble(Point, Digits);
         txt += "\n";
                       
         txt += "Digits\t" + (string) Digits;
         txt += "\n";
         
                  //price	117.358
                  //Point	0.001
                  //Digits	3         

         txt += "minstoplevel\t" + (string) NormalizeDouble(minstoplevel, Digits);
         txt += "\n";
           
         txt += "mintakelevel\t" + (string) NormalizeDouble(mintakelevel, Digits);
         txt += "\n";
           
         txt += "stoploss\t" + (string) NormalizeDouble(stoploss, Digits);
         txt += "\n";
           
         txt += "takeprofit\t" + (string) NormalizeDouble(takeprofit, Digits);
         txt += "\n";
         
         write_Log(
            dpath_Log
            , fname_Log_For_Session
            
            , __FILE__, __LINE__
            
            , txt);
      
     }   
   
   
   /*******************
      step : 2
         buy
   *******************/
   //_20191217_124004:tmp
/*
   string   symbol,              // symbol      1
   int      cmd,                 // operation   2

   double   volume,              // volume      3
   double   price,               // price       4

   int      slippage,            // slippage    5
   double   stoploss,            // stop loss   6
   double   takeprofit,          // take profit 7

   string   comment=NULL,        // comment     8

   int      magic=0,             // magic number   9

   datetime expiration=0,        // pending order expiration   10
   color    arrow_color=clrNONE  // color                      11   
*/
   int ticket=OrderSend(
                  Symbol()
                  //,OP_BUY
                  , OP_SELL
                  , 1
                  //,price
                  , price_Order
                  , 3          // slippage             5
                  
                  , stoploss
                  , takeprofit
                  
                  , "My order"
                  , 16384
                  
                  , 0          // pending order expiration   10
                  ,clrGreen
                  );

   if(ticket<0)
     {
      Print("OrderSend failed with error #",GetLastError());

      txt = "OrderSend failed with error #" + (string) GetLastError();
      txt += "\n";
      
      write_Log(
         dpath_Log
         , fname_Log_For_Session
         
         , __FILE__, __LINE__
         
         , txt);
      
     }
   else {
         
         Print("OrderSend placed successfully");
         
         txt = "OrderSend placed successfully : " + (string) ticket;
         txt += "\n";
         
         write_Log(
            dpath_Log
            , fname_Log_For_Session
            
            , __FILE__, __LINE__
            
            , txt);
         
         
         //_20190829_110834:tmp
         // log : data
         // ticket num, ask, bid, minstoplevel, mintakelevel, stoploss, takeprofit
         txt = "\t"
               + (string) ticket
               + "\t"
               + (string) NormalizeDouble(Ask, Digits)
               + "\t"
               + (string) NormalizeDouble(Bid, Digits)
               + "\t"
               
               + (string) NormalizeDouble(minstoplevel, Digits)
               + "\t"
               
               + (string) NormalizeDouble(mintakelevel, Digits)
               + "\t"

               + (string) NormalizeDouble(stoploss, Digits)
               + "\t"

               + (string) NormalizeDouble(takeprofit, Digits)
                              + "\t"

               ;
               
         write_Log(
            dpath_Log
            , fname_Log_DAT_For_Session
            
            , __FILE__, __LINE__
            
            , txt);            
         
   //---
     }
     
   /*******************
      step : X
         return
   *******************/
   int ret = ticket;
   //int ret = -1;
   
   return ret;
   

}//take_Position__Sell() //func

/*---------------------

   int is_Order_Pending()
   
   at : 2019/12/18 16:32:08
   
   @return
      -1    order not pending
   
---------------------*/
//func
int is_Order_Pending() {
//_20191218_163345:head
//_20191218_163351:caller

   /*******************
      step : 0
         prep : vars
   *******************/
   int valOf_No_Pending = -1;
   
   /*******************
      step : 1
         count : orders
   *******************/
   int cntOf_Orders = OrdersTotal();

   /*******************
      step : j1
         orders --> pending ?
   *******************/
   if(cntOf_Orders > 0)
     {
         /*******************
            step : j1 : Y
               orders --> pending
         *******************/
         /*******************
            step : j1 : Y : 1
               log
         *******************/
         /*******************
            step : j1 : Y : 2
               return
         *******************/
         // return
         return(cntOf_Orders);
      
     }
   else//if(cntOf_Orders > 0)   
     {
         /*******************
            step : j1 : N
               orders --> pending
         *******************/
         /*******************
            step : j1 : N : 1
               log
         *******************/
         /*******************
            step : j1 : N : 2
               return
         *******************/
         // return
         return(valOf_No_Pending);
   
     }//if(cntOf_Orders > 0)
   
}//int is_Order_Pending() {

/*
2019/09/09 13:47:44
func-list.(lib_ea_2.mqh).20190909_134744.txt
==========================================
<funcs>

1	int  OrderSend(
2	bool judge_1() {
3	int take_Position__Buy() {

==========================================
==========================================
<vars>

1	bool SWITHCH_DEBUG_lib_ea_2   = true;

==========================================
==========================================
<externs, inputs>


==========================================
*/
