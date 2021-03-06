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
#include <cons_fx.mqh>
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
string   txt_Lib_ea_2;

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
   
   double stoploss = NormalizeDouble(Bid - minstoplevel, Digits);
   //double stoploss=NormalizeDouble(Bid-minstoplevel*Point,Digits);
   
   //double takeprofit=NormalizeDouble(Bid+minstoplevel*Point,Digits);
   //double takeprofit    = NormalizeDouble(Bid + mintakelevel * Point, Digits);
   //double takeprofit    = NormalizeDouble(Bid + (Ask - Bid) + mintakelevel * Point, Digits);
   double takeprofit    = NormalizeDouble(Bid + mintakelevel, Digits);
   
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
         
         //_20200414_160033:next
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

//20200730_145640:caller
//20200730_145648:head
//20200730_145655:wl

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

   double mintakelevel     = _mintakelevel;
   
   double price_Spread     = Ask - Bid;
   
   //code:20200730_151828:c
   // stoploss
   double val_Premium__SL = minstoplevel + price_Spread;
   
   //ref https://fx-earth.com/fx00365/#i
   double stoploss = NormalizeDouble( price_Order + val_Premium__SL, Digits);
   
   //
   double val_Premium__TP = mintakelevel + price_Spread;
   
   double takeprofit    = NormalizeDouble( price_Order - val_Premium__TP, Digits);
   
   // order volume
   double order_volume  = 0.1;
   
   //debug
   if(SWITHCH_DEBUG_lib_ea_2 == true)
     {

         txt = "(step : 1) vars";
         txt += "\n";
         
         
         //txt += "price\t" + (string) price;
         txt += "price_Order\t" + (string) price_Order;
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

         // val_Premium__SL
         txt += "val_Premium__SL\t" + (string) NormalizeDouble(val_Premium__SL, Digits);
         txt += "\n";
           
         // val_Premium__TP
         txt += "val_Premium__TP\t" + (string) NormalizeDouble(val_Premium__TP, Digits);
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
      
         //code:20200730_145823:c
         //debug:20200730_145815:d
         //return (-1);
      
     }//if(SWITHCH_DEBUG_lib_ea_2 == true)
   
   /*******************
      step : 2
         sell
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
                  //, 1
                  , order_volume
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

   is_Order_Fully_Pending
   
   at : 2019/12/18 16:32:08
   
   @return
      -1    order not pending
   
---------------------*/
//func
bool is_Order_Fully_Pending(int _maxOf_NumOf_Pending_Orders) {
//_20200413_214410:head
//_20200413_214415:caller

   /*******************
      step : 0
         prep : vars
   *******************/
   bool valOf_Ret;
   
   /*******************
      step : 1
         count : orders
   *******************/
   int cntOf_Orders = OrdersTotal();

   /*******************
      step : j1
         num of orders --> more than the target num ?
                      --> equal or more than the target num ?  #=> 20200427_092141
   *******************/
   //_20200427_092057:modify
   //if(cntOf_Orders > _maxOf_NumOf_Pending_Orders)
   if(cntOf_Orders >= _maxOf_NumOf_Pending_Orders)
     {
         /*******************
            step : j1 : Y
               num of orders --> more than the target num
         *******************/
         /*******************
            step : j1 : Y : 1
               log
         *******************/
         /*******************
            step : j1 : Y : 2
               set : return val
         *******************/
         // return
         valOf_Ret = true;
         
     }
   else//if(cntOf_Orders > 0)   
     {
         /*******************
            step : j1 : N
               num of orders --> LESS than the target num ?
         *******************/
         /*******************
            step : j1 : N : 1
               log
         *******************/
         /*******************
            step : j1 : N : 2
               set : return val
         *******************/
         // return
         valOf_Ret = false;
            
     }//if(cntOf_Orders > 0)


   /*******************
      step : X
         return
   *******************/
   return(valOf_Ret);

}//bool is_Order_Fully_Pending(int _maxOf_NumOf_Pending_Orders) {


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

/*---------------------
   int get_BB_Loc_Num(int index)
   
   at : 2020/04/15 10:32:33
   
   @param : index
         ==> Close[index], and so forth
   
   @return
      int num_BB_Area   ==> location number in BB
   
---------------------*/
//func
int get_BB_Loc_Num(int index) {
//_20200415_103130:head
//_20200415_103134:caller

   /*******************
      step : 1
         price : close
   *******************/
   /*******************
      step : 1.1
         obtain
   *******************/
   double price_Close = Close[index];
   double price_Open  = Open[index];
   
   // log
   txt_Lib_ea_2 = "[" + __FILE__ + ":" + (string) __LINE__ + "] get_BB_Loc_Num"   
                + "\n"
                + "price_Close\t" + (string) price_Close
                + "\n"
                + "price_Open\t" + (string) price_Open
                + "\n"
                 ;
   
   
   /*******************
      step : 2
         BB prices
   *******************/
   float BB_Prices[5];
   float BB_Price;
   
   int idxOf_BB_Prices = 0;
   
   string   BB_Labels[5] = {"2S", "1S", "main", "M1S", "M2S"};
   
   /*******************
      step : 2.1
         BB : 2S
   *******************/   
   //int index = 0;
   int deviation = 2; int   period_BB = 20;
   int bb_Mode = MODE_UPPER; int price_Applied = PRICE_CLOSE;
   
   //float BB_2S = (float) iBands(Symbol(), Period(), period_BB
   //ref C:\Users\iwabuchiken\AppData\Roaming\MetaQuotes\Terminal\34B08C83A5AAE27A4079DE708E60511E\MQL4\Experts\labs\44_5.1\ea-1_up-up-buy.mq4
   BB_Price = (float) iBands(Symbol(), Period(), period_BB
               , deviation    //deviation ref https:docs.mql4.com/constants/indicatorconstants/lines
               , 0, price_Applied, bb_Mode    //mode
               , index);   
   
   // append
   BB_Prices[idxOf_BB_Prices]   = BB_Price;
          
   /*******************
      step : 2.1
         BB : 1S
   *******************/   
   //index = 0;
   deviation = 1;
   period_BB = 20;
   bb_Mode = MODE_UPPER;
   price_Applied = PRICE_CLOSE;

   BB_Price = (float) iBands(Symbol(), Period(), period_BB
               , deviation    //deviation ref https:docs.mql4.com/constants/indicatorconstants/lines
               , 0, price_Applied, bb_Mode    //mode
               , index);   
   
   // append
   idxOf_BB_Prices += 1;
   
   BB_Prices[idxOf_BB_Prices]   = BB_Price;
   
/*   float BB_1S = (float) iBands(
               Symbol(), Period()
               , period_BB
               , deviation    //deviation ref https:docs.mql4.com/constants/indicatorconstants/lines
               , 0
               , price_Applied
               , bb_Mode    //mode
               , index);   
*/ 

   /*******************
      step : 2.3
         BB : main
   *******************/   
   //index = 0;
   deviation = 1;
   period_BB = 20;
   bb_Mode = MODE_MAIN;
   price_Applied = PRICE_CLOSE;

   BB_Price = (float) iBands(Symbol(), Period(), period_BB
               , deviation    //deviation ref https:docs.mql4.com/constants/indicatorconstants/lines
               , 0, price_Applied, bb_Mode    //mode
               , index);   
   
   // append
   idxOf_BB_Prices += 1;
   
   BB_Prices[idxOf_BB_Prices]   = BB_Price;   
   //BB_Prices[2]   = BB_Price;

   /*******************
      step : 2.4
         BB : M1S
   *******************/   
   //index = 0;
   deviation = 1;
   period_BB = 20;
   bb_Mode = MODE_LOWER;
   price_Applied = PRICE_CLOSE;

   BB_Price = (float) iBands(Symbol(), Period(), period_BB
               , deviation    //deviation ref https:docs.mql4.com/constants/indicatorconstants/lines
               , 0, price_Applied, bb_Mode    //mode
               , index);   
   
   // append
   idxOf_BB_Prices += 1;
   
   BB_Prices[idxOf_BB_Prices]   = BB_Price;   
   //BB_Prices[2]   = BB_Price;

   /*******************
      step : 2.5
         BB : M2S
   *******************/   
   //index = 0;
   deviation = 2;
   period_BB = 20;
   bb_Mode = MODE_LOWER;
   price_Applied = PRICE_CLOSE;

   BB_Price = (float) iBands(Symbol(), Period(), period_BB
               , deviation    //deviation ref https:docs.mql4.com/constants/indicatorconstants/lines
               , 0, price_Applied, bb_Mode    //mode
               , index);   
   
   // append
   idxOf_BB_Prices += 1;
   
   BB_Prices[idxOf_BB_Prices]   = BB_Price;   
   // report
   //string txt_Lib_ea_2 = "";
   
   /*******************
      step : 3
         show : BB prices
   *******************/   
   for(int i=0; i< 5; i++)
     {
         txt_Lib_ea_2 += "BB_Prices[" + (string) i + "]"
                     + "\t"
                     + (string) BB_Prices[i]
                     
                     + "\t"   // label
                     + BB_Labels[i]
                     
                     + "\t"   // time
                     + (string) Time[index]  //ref https://www.mql5.com/en/forum/139216
                     + "\n"   // return
                     ;
     }

   // separator line
   txt_Lib_ea_2 += "\n";

   /*******************
      step : 4
         compare
   *******************/   
   int   num_BB_Area;
   
   if(price_Close >= BB_Prices[0])//   >= BB 2S
     {
         num_BB_Area = 1;
     }
   else if(price_Close >= BB_Prices[1])//   >= BB 1S
    {
         num_BB_Area = 2;
    }
   else if(price_Close >= BB_Prices[2])//   >= BB main
    {
         num_BB_Area = 3;
    }
   else if(price_Close > BB_Prices[3])//   > BB M1S
    {
         num_BB_Area = 4;
    }
   else if(price_Close > BB_Prices[4])//   > BB M2S
    {
         num_BB_Area = 5;
    }
   else if(price_Close <= BB_Prices[4])//   <= BB M2S
    {
         num_BB_Area = 6;
    }
   else
    {
         num_BB_Area = -1;
    }
    
    // log
    txt_Lib_ea_2 += "num_BB_Area"
               + "\t"
               + (string) num_BB_Area
               + "\n"
               ;
    
   /*******************
      step : X
         return
   *******************/
   //debug
   //string txt_Lib_ea_2 = "[" + __FILE__ + ":" + (string) __LINE__ + "] get_BB_Loc_Num"
/*   txt_Lib_ea_2 += "[" + __FILE__ + ":" + (string) __LINE__ + "] get_BB_Loc_Num"
                + "\n"
                + "price_Close\t" + (string) price_Close
                + "\n"
                + "price_Open\t" + (string) price_Open
                + "\n"
                
                + "BB_2S\t" + (string) BB_2S
                + "\n"
                + "BB_1S\t" + (string) BB_1S
                + "\n"
                ;
*/
/*   
   //debug
   Print(txt_Lib_ea_2);
   
   write_Log(dpath_Log , fname_Log_For_Session
         , __FILE__ , __LINE__ , txt_Lib_ea_2);
  */ 
   /*******************
      step : X.1
         set : val
   *******************/
   // return
   //int valOf_Ret = -1;  // test
   int valOf_Ret = num_BB_Area;

   /*******************
      step : X.2
         return
   *******************/
   // : int num_BB_Area
   return valOf_Ret;

}//int is_Order_Pending() {

/*---------------------

   void get_BB_Loc_Nums(int _lenOf_Bars, int _num_Start_Index) {
   
   at : 2020/04/17 16:08:09
   
   @param : _lenOf_Bars
               how many previous bars, counting from the most latest
   
   @param : _num_Start_Index
               starting index for Close[]
   
   @return
      int lo_BB_Area_Nums[]
   
---------------------*/
//func
//void get_BB_Loc_Nums(int _lenOf_Bars, int _num_Start_Index, float &_lo_BB_Loc_Nums[]) {
void get_BB_Loc_Nums(
      int _lenOf_Bars
      , int _num_Start_Index
      , float &_lo_Price_Close[]
      , int &_lo_BB_Loc_Nums[]
      , string &_lo_DateTime[]
      
      , int &_lo_Up_Down[]
      //_20200421_171612:tmp
      , float &_lo_WidthOf_Up_Down[]
      
      ) {

//_20200417_160749:caller
//_20200417_160752:head
//_20200417_160755:wl

   /*******************
      step : 1
         prep : vars
   *****************/
   // log text
   string logFor_Get_BB_Loc_Nums = "";
   logFor_Get_BB_Loc_Nums += "[" + __FILE__ + ":" + (string) __LINE__ + "]"
                  + " "
                  + "get_BB_Loc_Nums() ==> starts"
                  + "\n"
                  ;
   
   write_Log(dpath_Log , fname_Log_For_Session
         , __FILE__ , __LINE__ , logFor_Get_BB_Loc_Nums);
   
   /*******************
      step : 2
         init : vars
   *****************/
   // resize array
   ArrayResize(_lo_BB_Loc_Nums, _lenOf_Bars);
   ArrayResize(_lo_Price_Close, _lenOf_Bars);
   ArrayResize(_lo_DateTime, _lenOf_Bars);
   
   ArrayResize(_lo_Up_Down, _lenOf_Bars);
   ArrayResize(_lo_WidthOf_Up_Down, _lenOf_Bars);
   
   /*******************
      step : 3
         set : vars
   *****************/
   /*******************
      step : 3.0
         prep : vars
   *****************/
   int num_BB_Area;
   
   //test
   for(int i = 0; i < _lenOf_Bars; i++)
     {

         /*******************
            step : 3.1
               price close
         *****************/
         //_20200417_165431:next
         // set val
         //_lo_BB_Loc_Nums[i] = -1 * i;
         //_lo_BB_Loc_Nums[i]   = (float) Close[i];
         _lo_Price_Close[i]   = (float) Close[i];
         
         _lo_DateTime[i]      = (string) Time[i];
         
         //debug
         logFor_Get_BB_Loc_Nums = StringFormat(
                  "_lo_Price_Close[%d]\t%.03f\t%s"
                  , i
                  , _lo_Price_Close[i]
                  //, Time[i]
                  //, (string) Time[i]
                  , _lo_DateTime[i]
                  );
                  
         /*******************
            step : 3.2
               BB zone num
         *****************/
         //_20200420_132018:tmp
         // get : num
         num_BB_Area = get_BB_Loc_Num(i);
         
         // set
         _lo_BB_Loc_Nums[i] = num_BB_Area;
         
         logFor_Get_BB_Loc_Nums += StringFormat(
                  "(num_BB_Area = %d)"
                  , _lo_BB_Loc_Nums[i]
                  );
         
         write_Log(dpath_Log , fname_Log_For_Session
               , __FILE__ , __LINE__ , logFor_Get_BB_Loc_Nums);


         /*******************
            step : 3.3
               up, down
         *****************/
         float diff = (float) Close[i] - (float) Open[i];
         
         if(diff >= 0)
           {
               // set val
               _lo_Up_Down[i] = 1;
               
           }
         else
           {
               // set val
               _lo_Up_Down[i] = - 1;
            
           }

         /*******************
            step : 3.4
               _lo_WidthOf_Up_Down
         *****************/
         //_20200421_171753:tmp
         _lo_WidthOf_Up_Down[i] = diff;


     }//for(int i=0; i < _lenOf_Bars; i++)

   // separator
   logFor_Get_BB_Loc_Nums += "\n";
   
   //debug
   logFor_Get_BB_Loc_Nums = "[" + __FILE__ + ":" + (string) __LINE__ + "] _lo_Price_Close => vals set"
                + "\n"
                ;

   
   //debug
   Print(logFor_Get_BB_Loc_Nums);
   
   write_Log(dpath_Log , fname_Log_For_Session
         , __FILE__ , __LINE__ , logFor_Get_BB_Loc_Nums);

   /*******************
      step : X
         return
   *******************/
   /*******************
      step : X.1
         set : vals
   *******************/
   //int valOf_Ret[] = {-1, -1, -1, -1, -1};
   
   /*******************
      step : X.2
         return
   *******************/

}//void get_BB_Loc_Nums(int _lenOf_Bars, int _num_Start_Index) {

/*---------------------
   op_Get_BB_Loc_Nums
   
   at : 2020/04/20 17:06:07
   
   @param : 
   
   @return
---------------------*/
//func
void op_Get_BB_Loc_Nums(

      int   _lenOf_Bars
      , int _num_Start_Index
      , float  &_lo_Price_Close[]
      , int &_lo_BB_Loc_Nums[]
      , string &_lo_DateTime[]
      , string _dpath_Log
      , string _fname_Log_For_Bar_Data
      , bool   _flg_Write_Header
      
      , int &_lo_Up_Down[]
      //_20200421_171418:tmp
      , float &_lo_WidthOf_Up_Down[]
      
      , string _symbol, string _period
      
      ) {

//_20200420_170644:caller
//_20200420_170648:head
//_20200420_170651:wl

   //_20200417_161938:tmp
   //int   lenOf_Bars      = 5;
   
      /*
      void get_BB_Loc_Nums(
         int _lenOf_Bars
         , int _num_Start_Index
         , float &_lo_Price_Close[]
         , int &_lo_BB_Loc_Nums[]) {
         }*/
   //get_BB_Loc_Nums(lenOf_Bars, num_Start_Index, lo_BB_Loc_Nums);
   get_BB_Loc_Nums(
               _lenOf_Bars
               , _num_Start_Index
               , _lo_Price_Close
               , _lo_BB_Loc_Nums
               , _lo_DateTime
               
               //_20200421_094322:tmp
               , _lo_Up_Down
               //_20200421_171525:tmp
               , _lo_WidthOf_Up_Down
               
               );

   //_20200423_132224:debug
   //debug
   string logFor_This_Func = "[" + __FILE__ + ":" + (string) __LINE__ + "] op_Get_BB_Loc_Nums";
   logFor_This_Func += "\n";
   
   for(int i = 0; i < _lenOf_Bars; i++)
     {
         // get val
         //debug
         //_20200423_132319:debug
         logFor_This_Func += "_lo_BB_Loc_Nums[" + (string) i + "]"
                  + "\t"
                  + (string) _lo_BB_Loc_Nums[i]
                  
                  + "\t"
                  
                  + "(up/down = " + (string) _lo_Up_Down[i]
                  + ")"
                  
                  + "\n"
             ;
      
     }//for(int i=0; i < lenOf_Bars; i++)

   write_Log(_dpath_Log , fname_Log_For_Session
         , __FILE__ , __LINE__ , logFor_This_Func);
   
   /*******************
      step : 2
         bar data file : write
            ==> header
   *******************/
   /*******************
      step : 2.1
         header
   *******************/
   string txt_Tmp;
   
   // judge
   if(_flg_Write_Header == true)
     {

         //_20200422_130025:tmp
         txt_Tmp = StringFormat(
                     "[%s:%d]\nsymbol!!\t%s\nperiod\t%s\n"
                     , __FILE__, __LINE__, _symbol, _period
         
                  );
   
         txt_Tmp += StringFormat("this file\t%s\n", _fname_Log_For_Bar_Data);
         
         txt_Tmp += "\tdatetime current"
                  + "\tBB.-5\tBB.-4\tBB.-3\tBB.-2\tBB.-1"
                  
                  + "\t"
                  
                  + "u/d.-5\tu/d.-4\tu/d.-3\tu/d.-2\tu/d.-1"
                  
                  //_20200421_171946:tmp
                  + "\t"
                  
                  + "width.-5\twidth.-4\twidth.-3\twidth.-2\twidth.-1"
                  
                  + "\n";
         
         txt_Tmp += "\t";
      
         write_Log(_dpath_Log , _fname_Log_For_Bar_Data
               , __FILE__ , __LINE__ , txt_Tmp);   
      
     }//if(_flg_Write_Header == true)
   
   //debug
   //_20200423_132644:fix
   txt_Tmp = "bar data file : header ==> written (bar data file = " 
         + _fname_Log_For_Bar_Data+ ")";

   write_Log(_dpath_Log , fname_Log_For_Session
         , __FILE__ , __LINE__ , txt_Tmp);   

   //debug
   txt_Tmp = "header ==> written" + "(Close[1] = " + (string) Close[1] + ")"
               + " / "
               + "_lo_DateTime[0] = " + _lo_DateTime[0]
               ;
   txt_Tmp += "\n";
   
   write_Log(_dpath_Log , _fname_Log_For_Bar_Data
         , __FILE__ , __LINE__ , txt_Tmp);   

   /*******************
      step : 2.2
         body
   *******************/
   /*******************
      step : 2.2 : 1
         body : datetime current
   *******************/
   //setup_Data_File();
   txt_Tmp = "\t" + _lo_DateTime[0];
   txt_Tmp += "\t";
   
   //debug
   write_Log(_dpath_Log , _fname_Log_For_Bar_Data
         , __FILE__ , __LINE__ , txt_Tmp);   

   /*******************
      step : 2.2 : 2
         body : BB zone num
   *******************/   
   int j;
   
   //for(j = 1; j < lenOf_Bars; j ++)
   //for(j = 0; j < lenOf_Bars - 1; j ++)   //=> working
   //for(j = lenOf_Bars - 2; j > 0; j --)
   for(j = _lenOf_Bars - 1; j > 0; j --)
   //for(j = lenOf_Bars; j > 0; j --)
     {
         // get val
         //debug
         txt_Tmp += (string) _lo_BB_Loc_Nums[j]

/*                  
                  + "(" 
                  + "j = " + (string) j
                  + ", "
                  + _lo_DateTime[j]
                  + ")"
*/
                  + "\t"
             ;
      
     }//for(int i=0; i < lenOf_Bars; i++)

   /*******************
      step : 2.2 : 3
         body : up/down
   *******************/   
   for(j = _lenOf_Bars - 1; j > 0; j --)
   //for(j = lenOf_Bars; j > 0; j --)
     {
         // get val
         //debug
         txt_Tmp += (string) _lo_Up_Down[j]
                  + "\t"
             ;
      
     }//for(int i=0; i < lenOf_Bars; i++)

   //debug
   write_Log(_dpath_Log , _fname_Log_For_Bar_Data
         , __FILE__ , __LINE__ , txt_Tmp);   

        
   // last index ==> not to add when reversing the data in for-loop
   //                ==> index 0 designates to the current bar, which has not yet got closed.
   //txt_Tmp += (string) lo_BB_Loc_Nums[j];
   //txt_Tmp += "\n";

   /*******************
      step : 2.2 : 4
         body : width
   *******************/   
   /*******************
      step : 2.2 : 4.1
         float val
   *******************/   
   //_20200421_172106:tmp
   for(j = _lenOf_Bars - 1; j > 0; j --)
   //for(j = lenOf_Bars; j > 0; j --)
     {
         // get val
         //debug
         txt_Tmp += StringFormat("%.03f", _lo_WidthOf_Up_Down[j])
                  + "\t"
             ;
      
     }//for(int i=0; i < lenOf_Bars; i++)
   
   /*******************
      step : 2.2 : 4.2
         range num
   *******************/   
   //_20200421_172106:tmp
   // vars
   
   //_20200502_133605:tmp
   float lo_Thresholds[7] = {
                    (float) -1, (float) -1, (float) -1
                  , (float) -1, (float) -1, (float) -1
                  , (float) -1
            };
   
   //int lenOf_LO_Thresholds = 8;
   int lenOf_LO_Thresholds = 7;
   
   for(int i = 0; i < lenOf_LO_Thresholds; i++)
         lo_Thresholds[i] = cons_LO_Threshold_Bar_Width_Level_A_J_M1[i];
   
   //debug
   write_Log(_dpath_Log , _fname_Log_For_Bar_Data
         , __FILE__ , __LINE__ , "lo_Thresholds[2] = " + (string) lo_Thresholds[2]);   
   
/*
   float lo_Thresholds[7] = {
   
        (float) - 0.030
      , (float) - 0.020
      //, (float) - 0.015
      , (float) - 0.010
      //, (float) - 0.005
      
      , (float)   0.0
      
      //, (float) 0.005
      , (float) 0.010
      //, (float) 0.015
      , (float) 0.020
      , (float) 0.030
   
   };
*/
   //int lenOf_LO_Thresholds = ArraySize(lo_Thresholds);
   lenOf_LO_Thresholds = ArraySize(lo_Thresholds);
   
   //_20200503_135025:ref
   int lo_Thresholds_Indexes[8] = {-4, -3, -2, -1, 1, 2, 3, 4};
   
   int lo_Histo[8] = {
            0, 0, 0, 0
            ,0, 0, 0, 0
   };
   
   // func
   //_20200424_180052:caller
   txt_Tmp += get_LO_Width_Zone_Nums(
                  //_20200424_181503:fix
                  _lo_WidthOf_Up_Down
                  , _lenOf_Bars
                  , lo_Thresholds
                  , lo_Thresholds_Indexes
                  );

   //debug
   write_Log(_dpath_Log , _fname_Log_For_Bar_Data
         , __FILE__ , __LINE__ , txt_Tmp);   

/*   

   int counter = 0;
   
   for(j = _lenOf_Bars - 1; j > 0; j --)
   //for(j = lenOf_Bars; j > 0; j --)
     {
         // evaluate
         counter = 0;
         
         if(_lo_WidthOf_Up_Down[j] <= lo_Thresholds[0]) 
               { txt_Tmp += (string) lo_Thresholds_Indexes[0] + "\t"; }
         
         else if(_lo_WidthOf_Up_Down[j] <= lo_Thresholds[1])
               { txt_Tmp += (string) lo_Thresholds_Indexes[1] + "\t"; }
         
         else if(_lo_WidthOf_Up_Down[j] <= lo_Thresholds[2])
               { txt_Tmp += (string) lo_Thresholds_Indexes[2] + "\t"; }
         
         else if(_lo_WidthOf_Up_Down[j] <= lo_Thresholds[3])
               { txt_Tmp += (string) lo_Thresholds_Indexes[3] + "\t"; }
         
         else if(_lo_WidthOf_Up_Down[j] <= lo_Thresholds[4])
               { txt_Tmp += (string) lo_Thresholds_Indexes[4] + "\t"; }
         
         else if(_lo_WidthOf_Up_Down[j] <= lo_Thresholds[5])
               { txt_Tmp += (string) lo_Thresholds_Indexes[5] + "\t"; }
         
         else if(_lo_WidthOf_Up_Down[j] <= lo_Thresholds[6])
               { txt_Tmp += (string) lo_Thresholds_Indexes[6] + "\t"; }
         
         else if(_lo_WidthOf_Up_Down[j] > lo_Thresholds[6])
               { txt_Tmp += (string) lo_Thresholds_Indexes[7] + "\t"; }

     }//for(int i=0; i < lenOf_Bars; i++)

*/

/*
         // evaluate
         counter = 0;
         
         if(_lo_WidthOf_Up_Down[j] <= lo_Thresholds[0]) { lo_Histo[0] += 1; }
         
         else if(_lo_WidthOf_Up_Down[j] <= lo_Thresholds[1]) { lo_Histo[1] += 1; }
         else if(_lo_WidthOf_Up_Down[j] <= lo_Thresholds[2]) { lo_Histo[2] += 1; }
         else if(_lo_WidthOf_Up_Down[j] <= lo_Thresholds[3]) { lo_Histo[3] += 1; }
         
         else if(_lo_WidthOf_Up_Down[j] <= lo_Thresholds[4]) { lo_Histo[4] += 1; }
         else if(_lo_WidthOf_Up_Down[j] <= lo_Thresholds[5]) { lo_Histo[5] += 1; }
         else if(_lo_WidthOf_Up_Down[j] <= lo_Thresholds[6]) { lo_Histo[6] += 1; }
         
         else if(_lo_WidthOf_Up_Down[j] > lo_Thresholds[6]) { lo_Histo[7] += 1; }
*/               


/*      
     int i;
     
     for(i = 0; i < lenOf_LO_Thresholds; i++)
       {
         //debug
         txt_Tmp += StringFormat("%.03f\t%d", lo_Thresholds[i], lo_Histo[i])
                  + "\t"
             ;
         
         txt_Tmp += "\n";
         
       }//for(int i = 0; i < lenOf_LO_Thresholds; i++)
     
     txt_Tmp += StringFormat("more\t%d", lo_Histo[i])
                  + "\n";
     txt_Tmp += "\n";
*/                

   write_Log(_dpath_Log , _fname_Log_For_Bar_Data
         , __FILE__ , __LINE__ , txt_Tmp);   

   //debug
   txt_Tmp = "op_Get_BB_Loc_Nums ==> complete";
   txt_Tmp += "\n";
   
   write_Log(_dpath_Log , _fname_Log_For_Bar_Data
         , __FILE__ , __LINE__ , txt_Tmp);   


}//void op_Get_BB_Loc_Nums(

/*---------------------
   get_Stats__Bar_Width
   
   at : 2020/04/22 13:09:19
   
   @param : 
   
   @return
---------------------*/
//func
void get_Stats__Bar_Width(

      string   _dpath_Log
      , string   _fname_Log_For_Session
      , string   _fname_Log_For_Stats_Data
      
      ) {

//_20200422_131005:caller
//_20200422_131010:head
//_20200422_131013:wl

   /*******************
      step : 0
         prep : vars
   *******************/   
   string txt_Tmp;
   
   //txt_Tmp = "get_Stats__Bar_Width ==> starting..."
   txt_Tmp = "get_Stats__Bar_Width ==> starting...";
   
   write_Log(_dpath_Log , _fname_Log_For_Stats_Data
         , __FILE__ , __LINE__ , txt_Tmp);   

   /*******************
      step : 1
         prep : vars
   *******************/
   //test:20200422_133026
   int lenOf_Close_Array = ArraySize(Close);

   /*******************
      step : 2
         sort out : Close prices
   *******************/
   //_20200422_134431:tmp
   /*******************
      step : 2 : 1
         prep : vars
   *******************/
   //float lo_Threshold_Prices[4];
   
   //lo_Threshold_Prices[0] = 0.01;
   //lo_Threshold_Prices[0] = (float) 0.01;  //=> no warning
   
   
   //float lo_Threshold_Prices[4] = {
   
   //_20200501_182722:tmp
   // thresholds : M1 : //_20200422_143448:mark
   //float lo_Threshold_Prices[6] = cons_LO_Threshold_Prices_A_J_M1; //=> 'lo_Threshold_Prices' - invalid array access	lib_ea_2.mqh	1603	10
   //float lo_Threshold_Prices[6] = cons_LO_Threshold_Prices_A_J_M1[]; //=> ']' - expression expected	lib_ea_2.mqh	1604	67
   //float lo_Threshold_Prices[6];// = cons_LO_Threshold_Prices_A_J_M1; //=> working
   //float lo_Threshold_Prices[] = &cons_LO_Threshold_Prices_A_J_M1[];  //=> not working
   
   float lo_Threshold_Prices[6] = {-1, -1, -1, -1, -1, -1};
   
   //for(int i = 0; i < 6; i++) lo_Threshold_Prices[i] = cons_LO_Threshold_Prices_A_J_M1[i];
   for(int i = 0; i < 6; i++) lo_Threshold_Prices[i] = cons_LO_Threshold_Prices_A_J_M5[i];

     
   //lo_Threshold_Prices[0] = cons_LO_Threshold_Prices_A_J_M1[0];   //=> working


/*
   float lo_Threshold_Prices[6] = {
   //float lo_Threshold_Prices[4] = [
         
         (float) 0.005
         , (float) 0.01
         
         , (float) 0.015
         , (float) 0.02
         
         , (float) 0.03
         , (float) 0.04
   //];
   };
*/
   int lo_Histograms[7] = {0, 0
                           , 0, 0
                           , 0, 0
                           , 0
   
                           };
   
   // length
   int lenOf_LO_Threshold_Prices = ArraySize(lo_Threshold_Prices);

   int lenOf_LO_Histograms = ArraySize(lo_Histograms);

   /*******************
      step : 2 : 2
         categorize
   *******************/
   //_20200502_124927:tmp
   int lenOf_Target_Prices = 100;
   //int lenOf_Target_Prices = 50;
   
   double diff;
   
   int i;
   
   //for(int i = 0; i < lenOf_Target_Prices; i++)
   for(i = 0; i < lenOf_Target_Prices; i++)
     {
         // get : diff
         diff = Close[i] - Open[i];
         
         diff = MathAbs(diff);
         
         // categorize
         if(diff <= lo_Threshold_Prices[0]) { lo_Histograms[0] += 1; } // increment : histo
         else if(diff <= lo_Threshold_Prices[1]) { lo_Histograms[1] += 1; } // increment : histo
         
         else if(diff <= lo_Threshold_Prices[2]) { lo_Histograms[2] += 1; } // increment : histo
         else if(diff <= lo_Threshold_Prices[3]) { lo_Histograms[3] += 1; } // increment : histo
         
         else if(diff <= lo_Threshold_Prices[4]) { lo_Histograms[4] += 1; } // increment : histo
         else if(diff <= lo_Threshold_Prices[5]) { lo_Histograms[5] += 1; } // increment : histo
         
         else if(diff > lo_Threshold_Prices[5]) { lo_Histograms[6] += 1; } // increment : histo
         //else if(diff > lo_Threshold_Prices[3]) { lo_Histograms[4] += 1; } // increment : histo

     }//for(int i = 0; i < lenOf_Target_Prices; i++)

   /*******************
      step : 2 : 3
         report
   *******************/
   //_20200422_143724:tmp
   /*******************
      step : 2 : 3.1
         meta
   *******************/
   txt_Tmp = "\n";
   
   // length : Close[]
   txt_Tmp += StringFormat("lenOf_Close_Array\t%d\n", lenOf_Close_Array);
   
   //write_Log(_dpath_Log , _fname_Log_For_Stats_Data
   //      , __FILE__ , __LINE__ , txt_Tmp);   
   
   // symbol, period
   string symbol = Symbol();
   
   string period = (string) Period();
   
   txt_Tmp += "\n";
   
   txt_Tmp += StringFormat("symbol\t%s\nperiod\t%s\n"
   
            , symbol, period
   );

   // start/end date
   txt_Tmp += StringFormat("start\t%s\nend\t%s\n"
   
            , (string) Time[0]
            , (string) Time[lenOf_LO_Threshold_Prices - 1]
   );
   
   // num of target bars
   txt_Tmp += StringFormat("lenOf_Target_Prices\t%d\n"
   
            , lenOf_Target_Prices
   );
   
   txt_Tmp += "\n";
   
   // header
   txt_Tmp += "<histogram of diffs>";
   txt_Tmp += "\n";
   
   txt_Tmp += "lo_Threshold_Prices(<=)\thisto\n";

   /*******************
      step : 2 : 3.2
         body
   *******************/
   //for(int i = 0; i < ArraySize(lo_Threshold_Prices); i++)
   //for(int i = 0; i < lenOf_LO_Threshold_Prices; i++)
   for(i = 0; i < lenOf_LO_Threshold_Prices; i++)
     {
         txt_Tmp += StringFormat(
                     //"%.03f\t%d"
                     "%.03f\t%d\t%.02f"
                     , lo_Threshold_Prices[i]
                     , lo_Histograms[i]
                     
                     , (float) lo_Histograms[i] * 1.0 / lenOf_Target_Prices
                     
                     
                     );
         
         txt_Tmp += "\n";
     }
     
   // more than : lo_Threshold_Prices[-1]
   //txt_Tmp += StringFormat("more\t%d", lo_Histograms[4]);
   //txt_Tmp += StringFormat("more\t%d", lo_Histograms[i]);
   txt_Tmp += StringFormat(
                  "more\t%d\t%.02f"
                  , lo_Histograms[i]
                  , (float) lo_Histograms[i] * 1.0 / lenOf_Target_Prices
                  );
         
   txt_Tmp += "\n";

   write_Log(_dpath_Log , _fname_Log_For_Stats_Data
         , __FILE__ , __LINE__ , txt_Tmp);   

}//void get_Stats__Bar_Width(

/*---------------------
   get_LO_Width_Zone_Nums
   
   at : 2020/04/24 18:00:45
   
   @param : 
   
   @return
---------------------*/
//func
string get_LO_Width_Zone_Nums(
            //_20200424_181604:fix
              float  &_lo_WidthOf_Up_Down[]
            , int    _lenOf_Bars
            , float  &_lo_Thresholds[]
            , int    &_lo_Thresholds_Indexes[]
      ) {

//_20200424_180052:caller
//_20200424_180057:head
//_20200424_180100:wl

   /*******************
      step : 1
         prep : vars
   *******************/
   int counter = 0;
   
   string txt_Tmp = "";
   
   int j;   // for-loop
   
   /*******************
      step : 2
         loop
   *******************/
   for(j = _lenOf_Bars - 1; j > 0; j --)
     {
         // evaluate
         counter = 0;
         
         if(_lo_WidthOf_Up_Down[j] <= _lo_Thresholds[0]) 
               { txt_Tmp += (string) _lo_Thresholds_Indexes[0] + "\t"; }
         
         else if(_lo_WidthOf_Up_Down[j] <= _lo_Thresholds[1])
               { txt_Tmp += (string) _lo_Thresholds_Indexes[1] + "\t"; }
         
         else if(_lo_WidthOf_Up_Down[j] <= _lo_Thresholds[2])
               { txt_Tmp += (string) _lo_Thresholds_Indexes[2] + "\t"; }
         
         else if(_lo_WidthOf_Up_Down[j] <= _lo_Thresholds[3])
               { txt_Tmp += (string) _lo_Thresholds_Indexes[3] + "\t"; }
         
         else if(_lo_WidthOf_Up_Down[j] <= _lo_Thresholds[4])
               { txt_Tmp += (string) _lo_Thresholds_Indexes[4] + "\t"; }
         
         else if(_lo_WidthOf_Up_Down[j] <= _lo_Thresholds[5])
               { txt_Tmp += (string) _lo_Thresholds_Indexes[5] + "\t"; }
         
         else if(_lo_WidthOf_Up_Down[j] <= _lo_Thresholds[6])
               { txt_Tmp += (string) _lo_Thresholds_Indexes[6] + "\t"; }
         
         else if(_lo_WidthOf_Up_Down[j] > _lo_Thresholds[6])
               { txt_Tmp += (string) _lo_Thresholds_Indexes[7] + "\t"; }

     }//for(int i=0; i < lenOf_Bars; i++)

   /*******************
      step : 3
         return
   *******************/
   string   valOf_Ret = txt_Tmp;
   
   // return
   return valOf_Ret;

}//string get_LO_Width_Zone_Nums(

/*---------------------
   op_Post_Take_Position
   
   at : 2020/04/20 17:06:07
   
   @param : 
   
   @return
---------------------*/
//func
void op_Post_Take_Position(

      int   _num_Ticket
      
      , string _dpath_Log
      , string _fname_Log_For_Ticket_Data
      , string _fname_Log_For_Session
      
      , string _symbol, string _period
      , string _nameOf_DetectPattern
      
      , bool _flg_Write_Meta_Data
      
      , bool _flg_Write_Body_Data
      
      ) {

//_20200428_144224:caller
//_20200428_144229:head
//_20200428_144232:wl

   /*******************
      step : 1
         prep : vars
   *******************/
   string logFor_This_Func;
   
   //int    numOf_Target_Prev_Bars = 6;
   //int    numOf_Target_Prev_Bars = 9;
   int    numOf_Target_Prev_Bars = 12;
   
   /*******************
      step : 2
         write : meta info
   *******************/
   if(_flg_Write_Meta_Data == true)
     {
      
         //debug
         logFor_This_Func = "[" + __FILE__ + ":" + (string) __LINE__ + "] op_Post_Take_Position";
         logFor_This_Func += "\n";
      
         logFor_This_Func += StringFormat(
                     "[%s:%d]\nsymbol\t%s\nperiod\t%s\ndp\t%s\n"
                     , __FILE__, __LINE__, _symbol, _period, _nameOf_DetectPattern
         
                  );
      
         logFor_This_Func += StringFormat("this file\t%s\n", _fname_Log_For_Ticket_Data);
            
         write_Log(_dpath_Log , _fname_Log_For_Ticket_Data
               , __FILE__ , __LINE__ , logFor_This_Func);

     }

   /*******************
      step : 2
         write : ticket and others
   *******************/
   /*******************
      step : 2.1
         header
   *******************/
   if(_flg_Write_Meta_Data == true)
     {
         /*******************
            step : 2.1 : 1
               ticket num
         *******************/
         //logFor_This_Func = "ticket num";
         logFor_This_Func = "\tticket-num";
         
         /*******************
            step : 2.1 : 2
               datetime
         *******************/
         // current : datetime
         logFor_This_Func += "\t";
         logFor_This_Func += "curr.datetime";

/*         
         // current : BB loc
         logFor_This_Func += "\t";
         logFor_This_Func += "curr.BB-loc";
*/
         //logFor_This_Func += "\n";
         
         /*******************
            step : 2.1 : 3
               close price
         *******************/
         // Close[]
         logFor_This_Func += "\t";
         //for(int i = 1; i <= numOf_Target_Prev_Bars; i++)
         for(int i = numOf_Target_Prev_Bars; i >= 1; i --)
           {
               logFor_This_Func += "Close.-" + (string) i;
               
               logFor_This_Func += "\t";
            
           }

         /*******************
            step : 2.1 : 4
               price : up / down
         *******************/
         //logFor_This_Func += "\t";
         //for(int i = 1; i <= numOf_Target_Prev_Bars; i++)
         for(int i = numOf_Target_Prev_Bars; i >= 1; i --)
           {
               logFor_This_Func += "u/d.-" + (string) i;
               
               logFor_This_Func += "\t";
            
           }

         /*******************
            step : 2.1 : 5
               price : width : val
         *******************/
         //logFor_This_Func += "\t";
         //for(int i = 1; i <= numOf_Target_Prev_Bars; i++)
         for(int i = numOf_Target_Prev_Bars; i >= 1; i --)
           {
               logFor_This_Func += "width.-" + (string) i;
               
               logFor_This_Func += "\t";
            
           }

         /*******************
            step : 2.1 : 6
               price : width : level
         *******************/
         //logFor_This_Func += "\t";
         //for(int i = 1; i <= numOf_Target_Prev_Bars; i++)
         for(int i = numOf_Target_Prev_Bars; i >= 1; i --)
           {
               logFor_This_Func += "w-level.-" + (string) i;
               
               logFor_This_Func += "\t";
            
           }

         //_20200518_125012:tmp
         /*******************
            step : 2.1 : 6a : 1
               MFI
         *******************/
         for(int i = numOf_Target_Prev_Bars; i >= 1; i --)
           {
               logFor_This_Func += "MFI.-" + (string) i;
               
               logFor_This_Func += "\t";
            
           }
         
         /*******************
            step : 2.1 : 6a : 2
               RSI
         *******************/
         for(int i = numOf_Target_Prev_Bars; i >= 1; i --)
           {
               logFor_This_Func += "RSI.-" + (string) i;
               
               logFor_This_Func += "\t";
            
           }

         /*******************
            step : 2.1 : 6a : 3
               Force
         *******************/
         for(int i = numOf_Target_Prev_Bars; i >= 1; i --)
           {
               logFor_This_Func += "Force.-" + (string) i;
               
               logFor_This_Func += "\t";
            
           }
         
         /*******************
            step : 2.1 : 7
               BB loc
         *******************/
         //logFor_This_Func += "\t";
         //for(int i = 1; i <= numOf_Target_Prev_Bars; i++)
         for(int i = numOf_Target_Prev_Bars; i >= 1; i --)
           {
               logFor_This_Func += "BB-loc.-" + (string) i;
               
               logFor_This_Func += "\t";
            
           }
         
         /*******************
            step : 2.1 : X
               write to file
         *******************/
         write_Log(_dpath_Log , _fname_Log_For_Ticket_Data
               , __FILE__ , __LINE__ , logFor_This_Func);

         
      }
      
   /*******************
      step : 2.2
         body
   *******************/
   //_20200429_165956:next
   //_20200429_163645:tmp
   if(_flg_Write_Body_Data == true) {
   
      /*******************
         step : 2.2 : 1
            ticket num
      *******************/
      logFor_This_Func = StringFormat(
      
            //"%d", _num_Ticket
            "\t%d", _num_Ticket
      
      );
      
      //logFor_This_Func += "\n";

      /*******************
         step : 2.2 : 2
            current (new bar) : datetime
      *******************/
      //_20200430_102736:tmp
      logFor_This_Func += "\t";
      
      logFor_This_Func += StringFormat(
      
            "%s", (string) Time[0]
      
      );

      /******************
         step : 2.2 : 2
            current (new bar) : BB loc
      *******************/
/*
      logFor_This_Func += "\t";
      
      logFor_This_Func += StringFormat(
      
            "%d", (string) get_BB_Loc_Num(0)
      
      );
*/    
      
      /*******************
         step : 2.2 : 3
            prev vars : Close[]
      *******************/
      // separator tab
      logFor_This_Func += "\t";
      
      // vals
      //for(int i = 1; i <= numOf_Target_Prev_Bars; i++)
      for(int i = numOf_Target_Prev_Bars; i >= 1; i --)
        {
         
            //logFor_This_Func += (string) Close[i];
            logFor_This_Func += (string) NormalizeDouble(Close[i], 3);

            // separator tab
            logFor_This_Func += "\t";
         
        }

      /*******************
         step : 2.2 : 4
            price : up / down
      *******************/
      //logFor_This_Func += "\t";
      
      float valOf_Up_Down;
      
      string strOf_Up_Down;
      
      //for(int i = 1; i <= numOf_Target_Prev_Bars; i++)
      for(int i = numOf_Target_Prev_Bars; i >= 1; i --)
        {
            // val
            valOf_Up_Down = (float) Close[i] - (float) Open[i];
            
            if(valOf_Up_Down >= 0)
              {
                  //strOf_Up_Down = "up";
                  strOf_Up_Down = (string) 1;
              }
            else
              {
                  //strOf_Up_Down = "down";
                  strOf_Up_Down = (string) -1;
              }
            
            logFor_This_Func += strOf_Up_Down;
            
            logFor_This_Func += "\t";
         
        }

      /*******************
         step : 2.2 : 5
            price : width : val
      *******************/
      //logFor_This_Func += "\t";
      //for(int i = 1; i <= numOf_Target_Prev_Bars; i++)
      for(int i = numOf_Target_Prev_Bars; i >= 1; i --)
        {
            // val
            valOf_Up_Down = (float) Close[i] - (float) Open[i];
        
            // string
            logFor_This_Func += (string) NormalizeDouble(valOf_Up_Down, 3);
            
            logFor_This_Func += "\t";
         
        }

      /*******************
         step : 2.1 : 6
            price : width : level
      *******************/
      //_20200503_152516:next
      //logFor_This_Func += "\t";
      //for(int i = 1; i <= numOf_Target_Prev_Bars; i++)
      int num_Width = -1;

      int lo_Thresholds_Indexes[8] = {-4, -3, -2, -1, 1, 2, 3, 4};
   
      //20200503_151441:tmp
      float lo_Thresholds[7] = {
                       (float) -1, (float) -1, (float) -1
                     , (float) -1, (float) -1, (float) -1
                     , (float) -1
               };
      
      int lenOf_LO_Thresholds = 7;
      
      for(int i = 0; i < lenOf_LO_Thresholds; i++) {
         
         if(Period() == 1)
           {
           
               lo_Thresholds[i] = cons_LO_Threshold_Bar_Width_Level_A_J_M1[i];
               
           }
         else if(Period() == 5)
           {
               lo_Thresholds[i] = cons_LO_Threshold_Bar_Width_Level_A_J_M1[i];     
           }
      
      }//for(int i = 0; i < lenOf_LO_Thresholds; i++) {
      
      //int idxOf_Target_Bar = 1;
    
      for(int i = numOf_Target_Prev_Bars; i >= 1; i --)
        {
            // get : width number
            num_Width = get_Bar_Width_Level_Nums(
                              i
                              , lo_Thresholds
                              , lo_Thresholds_Indexes);
        
            //logFor_This_Func += "w-level.-" + (string) i;
            //logFor_This_Func += "-";
            logFor_This_Func += (string) num_Width;
            
            logFor_This_Func += "\t";
         
        }
      
      //_20200518_124948:tmp
      /*******************
         step : 2.1 : 6a : 1
            MFI
      *******************/
      /* https://docs.mql4.com/indicators/imfi
      
         double  iMFI(
            string       symbol,     // symbol
            int          timeframe,  // timeframe
            int          period,     // averaging period
            int          shift       // shift
            );      
            
      */
      
      //=> //_20200518_130129:ref utils.mqh
      
      string symbol_Str = Symbol();
      
      int time_Frame = Period();

      int period_MFI = 20;
      
      int num_Normalized_Double = 5;
      
      double mfi;
      
      for(int i = numOf_Target_Prev_Bars; i >= 1; i --)
        {
        
            // get : mfi
            mfi = iMFI(symbol_Str, time_Frame, period_MFI, i);
        
            logFor_This_Func += (string) NormalizeDouble(mfi, num_Normalized_Double);
            
            //logFor_This_Func += (string) mfi;
            
            logFor_This_Func += "\t";
         
        }
      
      /*******************
         step : 2.1 : 6a : 2
            RSI
      *******************/
      //_20200518_131109:tmp
      double rsi;
      
      int period_RSI = 20;
      
      int price_Applied_RSI = PRICE_CLOSE;
      
      for(int i = numOf_Target_Prev_Bars; i >= 1; i --)
        {
            // rsi
            rsi = iRSI(symbol_Str, time_Frame, period_RSI, price_Applied_RSI, i);
        
            logFor_This_Func += (string) NormalizeDouble(rsi, num_Normalized_Double);
            
            logFor_This_Func += "\t";
         
        }

      /*******************
         step : 2.1 : 6a : 3
            Force
      *******************/
      //_20200518_132500:tmp
            /*
            
            double  iForce(
               string       symbol,           // symbol
               int          timeframe,        // timeframe
               int          period,           // averaging period
               int          ma_method,        // averaging method
               int          applied_price,    // applied price
               int          shift             // shift
               );
            
            */      
      double force;
      
      int period_Force = 20;
      
      int price_Applied_Force = PRICE_CLOSE;
      
      int ma_Method_Force = MODE_SMA;
      
      for(int i = numOf_Target_Prev_Bars; i >= 1; i --)
        {
            // val
            force = iForce(
                  symbol_Str
                  , time_Frame
                  , period_Force
                  , ma_Method_Force
                  , price_Applied_Force
                  , i);
        
            logFor_This_Func += (string) NormalizeDouble(force, num_Normalized_Double);
            
            logFor_This_Func += "\t";
         
        }
   
      /*******************
         step : 2.1 : 7
            BB loc
      *******************/
      //logFor_This_Func += "\t";
      //for(int i = 1; i <= numOf_Target_Prev_Bars; i++)
      for(int i = numOf_Target_Prev_Bars; i >= 1; i --)
        {
            //_20200501_182325:tmp
            int num_BB_loc = get_BB_Loc_Num(i);
        
            logFor_This_Func += (string) num_BB_loc;
            
            logFor_This_Func += "\t";
         
        }
            
      /*******************
         step : 2.2 : X
            write
      *******************/
      write_Log(_dpath_Log , _fname_Log_For_Ticket_Data
                  , __FILE__ , __LINE__ , logFor_This_Func);   
                  
   }//if(_flg_Write_Body_Data == true)
      
   //debug
   logFor_This_Func = "[" + __FILE__ + ":" + (string) __LINE__ + "] op_Post_Take_Position ==> comp.";
   logFor_This_Func += "\n";
   
   write_Log(_dpath_Log , _fname_Log_For_Session
            , __FILE__ , __LINE__ , logFor_This_Func);
   
   
}//op_Post_Take_Position(

/*---------------------
   op_Post_Take_Position__V2
   
   at : 2020/10/28 16:45:52
   
   @param : 
   
   @return
---------------------*/
//func
void op_Post_Take_Position__V2(

      int   _num_Ticket
      
      , string _dpath_Log
      , string _fname_Log_For_Ticket_Data
      , string _fname_Log_For_Session
      
      , string _symbol, string _period
      , string _nameOf_DetectPattern
      
      , bool _flg_Write_Meta_Data
      
      , bool _flg_Write_Body_Data
      
      ) {

//caller:20201028_164603
//head:20201028_164614

   /*******************
      step : 1
         prep : vars
   *******************/
   string logFor_This_Func;
   
   //int    numOf_Target_Prev_Bars = 6;
   //int    numOf_Target_Prev_Bars = 9;
   //int    numOf_Target_Prev_Bars = 12;
   int    numOf_Target_Prev_Bars = 20;
   
   /*******************
      step : 2
         write : meta info
   *******************/
   if(_flg_Write_Meta_Data == true)
     {
      
         //debug
         logFor_This_Func = "[" + __FILE__ + ":" + (string) __LINE__ + "] op_Post_Take_Position";
         logFor_This_Func += "\n";
      
         logFor_This_Func += StringFormat(
                     "[%s:%d]\nsymbol\t%s\nperiod\t%s\ndp\t%s\n"
                     , __FILE__, __LINE__, _symbol, _period, _nameOf_DetectPattern
         
                  );
      
         logFor_This_Func += StringFormat("this file\t%s\n", _fname_Log_For_Ticket_Data);
            
         write_Log(_dpath_Log , _fname_Log_For_Ticket_Data
               , __FILE__ , __LINE__ , logFor_This_Func);

     }

   /*******************
      step : 2
         write : ticket and others
   *******************/
   /*******************
      step : 2.1
         header
   *******************/
   //marker:20201028_165311
   if(_flg_Write_Meta_Data == true)
     {
         /*******************
            step : 2.1 : 1
               ticket num
         *******************/
         //logFor_This_Func = "ticket num";
         logFor_This_Func = "\tticket-num";
         
         /*******************
            step : 2.1 : 2
               datetime
         *******************/
         // current : datetime
         logFor_This_Func += "\t";
         logFor_This_Func += "curr.datetime";

/*         
         // current : BB loc
         logFor_This_Func += "\t";
         logFor_This_Func += "curr.BB-loc";
*/
         //logFor_This_Func += "\n";
         
         /*******************
            step : 2.1 : 3
               close price
         *******************/
         // Close[]
         logFor_This_Func += "\t";
         //for(int i = 1; i <= numOf_Target_Prev_Bars; i++)
         for(int i = numOf_Target_Prev_Bars; i >= 1; i --)
           {
               logFor_This_Func += "Close.-" + (string) i;
               
               logFor_This_Func += "\t";
            
           }

         /*******************
            step : 2.1 : 4
               price : up / down
         *******************/
         //logFor_This_Func += "\t";
         //for(int i = 1; i <= numOf_Target_Prev_Bars; i++)
         for(int i = numOf_Target_Prev_Bars; i >= 1; i --)
           {
               logFor_This_Func += "u/d.-" + (string) i;
               
               logFor_This_Func += "\t";
            
           }

         /*******************
            step : 2.1 : 5
               price : width : val
         *******************/
         //logFor_This_Func += "\t";
         //for(int i = 1; i <= numOf_Target_Prev_Bars; i++)
         for(int i = numOf_Target_Prev_Bars; i >= 1; i --)
           {
               logFor_This_Func += "width.-" + (string) i;
               
               logFor_This_Func += "\t";
            
           }

         /*******************
            step : 2.1 : 6
               price : width : level
         *******************/
         //logFor_This_Func += "\t";
         //for(int i = 1; i <= numOf_Target_Prev_Bars; i++)
         for(int i = numOf_Target_Prev_Bars; i >= 1; i --)
           {
               logFor_This_Func += "w-level.-" + (string) i;
               
               logFor_This_Func += "\t";
            
           }

         //_20200518_125012:tmp
         /*******************
            step : 2.1 : 6a : 1
               MFI
         *******************/
         for(int i = numOf_Target_Prev_Bars; i >= 1; i --)
           {
               logFor_This_Func += "MFI.-" + (string) i;
               
               logFor_This_Func += "\t";
            
           }
         
         /*******************
            step : 2.1 : 6a : 2
               RSI
         *******************/
         for(int i = numOf_Target_Prev_Bars; i >= 1; i --)
           {
               logFor_This_Func += "RSI.-" + (string) i;
               
               logFor_This_Func += "\t";
            
           }

         /*******************
            step : 2.1 : 6a : 3
               Force
         *******************/
         for(int i = numOf_Target_Prev_Bars; i >= 1; i --)
           {
               logFor_This_Func += "Force.-" + (string) i;
               
               logFor_This_Func += "\t";
            
           }
         
         /*******************
            step : 2.1 : 7
               BB loc
         *******************/
         //logFor_This_Func += "\t";
         //for(int i = 1; i <= numOf_Target_Prev_Bars; i++)
         for(int i = numOf_Target_Prev_Bars; i >= 1; i --)
           {
               logFor_This_Func += "BB-loc.-" + (string) i;
               
               logFor_This_Func += "\t";
            
           }

         /*******************
            step : 2.1 : 8
               num of up/down bars
         *******************/
         //code:20201028_165549
         logFor_This_Func += "num-up-bars";         
         logFor_This_Func += "\t";

         logFor_This_Func += "num-down-bars";         
         logFor_This_Func += "\t";
         
         logFor_This_Func += "up/down-ratio";         
         logFor_This_Func += "\t";
         
         //code:20201029_140006
         /*******************
            step : 2.1 : 9
               max/min prices
         *******************/
         logFor_This_Func += "price-max";         
         logFor_This_Func += "\t";
         
         logFor_This_Func += "BB.loc";         
         logFor_This_Func += "\t";
         
         logFor_This_Func += "prev-N-bar";         
         logFor_This_Func += "\t";
         
         logFor_This_Func += "price-min";
         logFor_This_Func += "\t";

         logFor_This_Func += "BB.loc";         
         logFor_This_Func += "\t";
         
         logFor_This_Func += "prev-N-bar";         
         logFor_This_Func += "\t";
         
         
         /*******************
            step : 2.1 : X
               write to file
         *******************/
         write_Log(_dpath_Log , _fname_Log_For_Ticket_Data
               , __FILE__ , __LINE__ , logFor_This_Func);

         
      }
      
   /*******************
      step : 2.2
         body
   *******************/
   //marker:20201028_165651
   //_20200429_165956:next
   //_20200429_163645:tmp
   if(_flg_Write_Body_Data == true) {
   
      /*******************
         step : 2.2 : 1
            ticket num
      *******************/
      logFor_This_Func = StringFormat(
      
            //"%d", _num_Ticket
            "\t%d", _num_Ticket
      
      );
      
      //logFor_This_Func += "\n";

      /*******************
         step : 2.2 : 2
            current (new bar) : datetime
      *******************/
      //_20200430_102736:tmp
      logFor_This_Func += "\t";
      
      logFor_This_Func += StringFormat(
      
            "%s", (string) Time[0]
      
      );

      /******************
         step : 2.2 : 2
            current (new bar) : BB loc
      *******************/
/*
      logFor_This_Func += "\t";
      
      logFor_This_Func += StringFormat(
      
            "%d", (string) get_BB_Loc_Num(0)
      
      );
*/    
      
      /*******************
         step : 2.2 : 3
            prev vars : Close[]
      *******************/
      // separator tab
      logFor_This_Func += "\t";
      
      // vals
      //for(int i = 1; i <= numOf_Target_Prev_Bars; i++)
      for(int i = numOf_Target_Prev_Bars; i >= 1; i --)
        {
         
            //logFor_This_Func += (string) Close[i];
            logFor_This_Func += (string) NormalizeDouble(Close[i], 3);

            // separator tab
            logFor_This_Func += "\t";
         
        }

      /*******************
         step : 2.2 : 4
            price : up / down
      *******************/
      //logFor_This_Func += "\t";
      
      float valOf_Up_Down;
      
      string strOf_Up_Down;
      
      //for(int i = 1; i <= numOf_Target_Prev_Bars; i++)
      for(int i = numOf_Target_Prev_Bars; i >= 1; i --)
        {
            // val
            valOf_Up_Down = (float) Close[i] - (float) Open[i];
            
            if(valOf_Up_Down >= 0)
              {
                  //strOf_Up_Down = "up";
                  strOf_Up_Down = (string) 1;
              }
            else
              {
                  //strOf_Up_Down = "down";
                  strOf_Up_Down = (string) -1;
              }
            
            logFor_This_Func += strOf_Up_Down;
            
            logFor_This_Func += "\t";
         
        }

      /*******************
         step : 2.2 : 5
            price : width : val
      *******************/
      //logFor_This_Func += "\t";
      //for(int i = 1; i <= numOf_Target_Prev_Bars; i++)
      for(int i = numOf_Target_Prev_Bars; i >= 1; i --)
        {
            // val
            valOf_Up_Down = (float) Close[i] - (float) Open[i];
        
            // string
            logFor_This_Func += (string) NormalizeDouble(valOf_Up_Down, 3);
            
            logFor_This_Func += "\t";
         
        }

      /*******************
         step : 2.2 : 6
            price : width : level
      *******************/
      //_20200503_152516:next
      //logFor_This_Func += "\t";
      //for(int i = 1; i <= numOf_Target_Prev_Bars; i++)
      int num_Width = -1;

      int lo_Thresholds_Indexes[8] = {-4, -3, -2, -1, 1, 2, 3, 4};
   
      //20200503_151441:tmp
      float lo_Thresholds[7] = {
                       (float) -1, (float) -1, (float) -1
                     , (float) -1, (float) -1, (float) -1
                     , (float) -1
               };
      
      int lenOf_LO_Thresholds = 7;
      
      for(int i = 0; i < lenOf_LO_Thresholds; i++) {
         
         if(Period() == 1)
           {
           
               lo_Thresholds[i] = cons_LO_Threshold_Bar_Width_Level_A_J_M1[i];
               
           }
         else if(Period() == 5)
           {
               lo_Thresholds[i] = cons_LO_Threshold_Bar_Width_Level_A_J_M1[i];     
           }
      
      }//for(int i = 0; i < lenOf_LO_Thresholds; i++) {
      
      //int idxOf_Target_Bar = 1;
    
      for(int i = numOf_Target_Prev_Bars; i >= 1; i --)
        {
            // get : width number
            num_Width = get_Bar_Width_Level_Nums(
                              i
                              , lo_Thresholds
                              , lo_Thresholds_Indexes);
        
            //logFor_This_Func += "w-level.-" + (string) i;
            //logFor_This_Func += "-";
            logFor_This_Func += (string) num_Width;
            
            logFor_This_Func += "\t";
         
        }
      
      //_20200518_124948:tmp
      /*******************
         step : 2.2 : 6a : 1
            MFI
      *******************/
      /* https://docs.mql4.com/indicators/imfi
      
         double  iMFI(
            string       symbol,     // symbol
            int          timeframe,  // timeframe
            int          period,     // averaging period
            int          shift       // shift
            );      
            
      */
      
      //=> //_20200518_130129:ref utils.mqh
      
      string symbol_Str = Symbol();
      
      int time_Frame = Period();

      int period_MFI = 20;
      
      int num_Normalized_Double = 5;
      
      double mfi;
      
      for(int i = numOf_Target_Prev_Bars; i >= 1; i --)
        {
        
            // get : mfi
            mfi = iMFI(symbol_Str, time_Frame, period_MFI, i);
        
            logFor_This_Func += (string) NormalizeDouble(mfi, num_Normalized_Double);
            
            //logFor_This_Func += (string) mfi;
            
            logFor_This_Func += "\t";
         
        }
      
      /*******************
         step : 2.2 : 6a : 2
            RSI
      *******************/
      //_20200518_131109:tmp
      double rsi;
      
      int period_RSI = 20;
      
      int price_Applied_RSI = PRICE_CLOSE;
      
      for(int i = numOf_Target_Prev_Bars; i >= 1; i --)
        {
            // rsi
            rsi = iRSI(symbol_Str, time_Frame, period_RSI, price_Applied_RSI, i);
        
            logFor_This_Func += (string) NormalizeDouble(rsi, num_Normalized_Double);
            
            logFor_This_Func += "\t";
         
        }

      /*******************
         step : 2.2 : 6a : 3
            Force
      *******************/
      //_20200518_132500:tmp
            /*
            
            double  iForce(
               string       symbol,           // symbol
               int          timeframe,        // timeframe
               int          period,           // averaging period
               int          ma_method,        // averaging method
               int          applied_price,    // applied price
               int          shift             // shift
               );
            
            */      
      double force;
      
      int period_Force = 20;
      
      int price_Applied_Force = PRICE_CLOSE;
      
      int ma_Method_Force = MODE_SMA;
      
      for(int i = numOf_Target_Prev_Bars; i >= 1; i --)
        {
            // val
            force = iForce(
                  symbol_Str
                  , time_Frame
                  , period_Force
                  , ma_Method_Force
                  , price_Applied_Force
                  , i);
        
            logFor_This_Func += (string) NormalizeDouble(force, num_Normalized_Double);
            
            logFor_This_Func += "\t";
         
        }
   
      /*******************
         step : 2.2 : 7
            BB loc
      *******************/
      //logFor_This_Func += "\t";
      //for(int i = 1; i <= numOf_Target_Prev_Bars; i++)
      for(int i = numOf_Target_Prev_Bars; i >= 1; i --)
        {
            //_20200501_182325:tmp
            int num_BB_loc = get_BB_Loc_Num(i);
        
            logFor_This_Func += (string) num_BB_loc;
            
            logFor_This_Func += "\t";
         
        }

      /*******************
         step : 2.2 : 8
            num of : up/down bars
      *******************/
      //code:20201028_165728
      /*logFor_This_Func += "num-up-bars";         
      logFor_This_Func += "num-down-bars";         
      logFor_This_Func += "up/down-ratio";         */
   
      /*******************
         step : 2.2 : 8 : 1
            num of : up bars, down bars
      *******************/
      // "i <= ..." --> Price[1] to Price[12]
      //    numOf_Target_Prev_Bars --> 12, for example
      // prep
      int numOf_Count__Up     = 0;
      int numOf_Count__Down   = 0;
      
      double   valOf_Bias_In_Up_Down_Judge   = 0.0;
      
      for(int i=0;i <= numOf_Target_Prev_Bars;i++)
        {
            // get : diff of the bar
            double   difOf_Bar = (double) Close[i] - Open[i];
            
            // judge
            if(difOf_Bar + valOf_Bias_In_Up_Down_Judge >= 0)
              {
                  // count
                  numOf_Count__Up   += 1;
               
              }//if(difOf_Bar + valOf_Bias_In_Up_Down_Judge >= 0)
            else
              {
                  // count : minus
                  numOf_Count__Down    += 1;
              }
         
        }//for(int i=0;i <= numOf_Target_Prev_Bars;i++)
      
      // build text
      logFor_This_Func += (string) numOf_Count__Up;      
      logFor_This_Func += "\t";

      logFor_This_Func += (string) numOf_Count__Down;      
      logFor_This_Func += "\t";
      
      /*******************
         step : 2.2 : 8 : 2
            ratio
      *******************/
      double   ratioOf_Up_Down = (double) numOf_Count__Up * 1.0 / numOf_Count__Down;
      
      int numOf_Digit__Display_Ratio = 3;
      
      logFor_This_Func += (string) NormalizeDouble(ratioOf_Up_Down, numOf_Digit__Display_Ratio);
      logFor_This_Func += "\t";

      //code:20201029_141922
      /*******************
         step : 2.2 : 9
            max/min prices
      *******************/
      /*******************
         step : 2.2 : 9 : 1
            prep : vars
      *******************/
      double   price_Max = 0.0;
      double   price_Min = 9999.0;
      
      double   price_Current_Bar_High  = 0.0;
      double   price_Current_Bar_Low   = 0.0;
      
      int      indexOf_Prev_Bar_Max = 0;
      int      indexOf_Prev_Bar_Min = 0;

      int      numOf_BB_Loc_Max = 0;
      int      numOf_BB_Loc_Min = 0;
      
      /*******************
         step : 2.2 : 9 : 2
            detection
      *******************/
      //code:20201029_140233
      //for(int i=0;i <= numOf_Target_Prev_Bars;i++)
      for(int i = 1; i <= numOf_Target_Prev_Bars; i++)
        {
            
            // judge
            bool  is_Up_Bar = ((double) Close[i] - Open[i] >= 0);
            
            // set : target price
            if(is_Up_Bar == true)
              {
                  // set
                  price_Current_Bar_High  = (double) Close[i];
                  price_Current_Bar_Low   = (double) Open[i];
              }
            else
              {
                  // set
                  price_Current_Bar_High  = (double) Open[i];
                  price_Current_Bar_Low   = (double) Close[i];
               
              }
            
            // judge + update
            if(price_Current_Bar_High > price_Max)
              {
                  // update : max
                  price_Max   = price_Current_Bar_High;
                  
                  // update : prev bar index
                  indexOf_Prev_Bar_Max = i;
                  
                  // update : prev bar : BB.loc
                  numOf_BB_Loc_Max  = get_BB_Loc_Num(i);
                  
              }
              
            if(price_Current_Bar_Low < price_Min)
              {
                  // update : max
                  price_Min   = price_Current_Bar_Low;
                  
                  // update : prev bar index
                  indexOf_Prev_Bar_Min = i;
                  
                  // update : prev bar : BB.loc
                  numOf_BB_Loc_Min  = get_BB_Loc_Num(i);
                  
              }            
                    
        }//for(int i=0;i <= numOf_Target_Prev_Bars;i++)      
      
      /*******************
         step : 2.2 : 9 : 3
            log line : build
      *******************/
      /*logFor_This_Func += "price-max";         
         logFor_This_Func += "\t";
         
         logFor_This_Func += "price-min";*/
      /*
         logFor_This_Func += "price-max";         
         logFor_This_Func += "\t";
         
         logFor_This_Func += "BB.loc";         
         logFor_This_Func += "\t";
         
         logFor_This_Func += "prev-N-bar";         
         logFor_This_Func += "\t";      
      
      */
      // max
      logFor_This_Func += (string) price_Max;
      logFor_This_Func += "\t";
      
      logFor_This_Func += (string) numOf_BB_Loc_Max;
      logFor_This_Func += "\t";
      
      logFor_This_Func += (string) indexOf_Prev_Bar_Max;
      logFor_This_Func += "\t";
      
      // min
      logFor_This_Func += (string) price_Min;
      logFor_This_Func += "\t";

      logFor_This_Func += (string) numOf_BB_Loc_Min;
      logFor_This_Func += "\t";
      
      logFor_This_Func += (string) indexOf_Prev_Bar_Min;
      logFor_This_Func += "\t";
      

      /*******************
         step : 2.2 : X
            write
      *******************/
      write_Log(_dpath_Log , _fname_Log_For_Ticket_Data
                  , __FILE__ , __LINE__ , logFor_This_Func);   
                  
   }//if(_flg_Write_Body_Data == true)
      
   //debug
   logFor_This_Func = "[" + __FILE__ + ":" + (string) __LINE__ + "] op_Post_Take_Position ==> comp.";
   logFor_This_Func += "\n";
   
   write_Log(_dpath_Log , _fname_Log_For_Session
            , __FILE__ , __LINE__ , logFor_This_Func);
   
   
}//op_Post_Take_Position__V2(

//_20200502_141051:next
/*---------------------
   get_Bar_Width_Level_Nums
   
   at : 2020/05/03 13:47:54
   
   @param : 
   
   @return
---------------------*/
//func
int get_Bar_Width_Level_Nums(
         int _index
         , float& _lo_Level_Vals[]
         , int& _lo_Num_For_Level[]) {

//_20200503_133227:caller
//_20200503_133233:head
//_20200503_133237:wl

   /*******************
      step : 1
         prep : vars
   *******************/
   float diff = (float) Close[_index] - (float) Open[_index];

   int lenOf_LO_Level_Vals = ArraySize(_lo_Level_Vals);
   
   // index for : _lo_Num_For_Level
   int idxFor_LO_Num_For_Level = -1;
   
   // num for : diff more than the max threshold val
   int numFor_More_Than_Max_Threshold = -99;
   
   // 
   /*******************
      step : 2
         compare   
   *******************/
   int i = 0;
   
   for( ; i < lenOf_LO_Level_Vals; i++)
     {
         // val
         float val_Level = _lo_Level_Vals[i];
         
         // compare
         bool cond_1 = (val_Level < 0) ? (diff < val_Level) : (diff <= val_Level);
         
         //if(diff < val_Level)
         if(cond_1 == true)
           {
               idxFor_LO_Num_For_Level = i;
               
               break;
           }
         
     }
     
   // in case : passed for-loop through
   if(i == lenOf_LO_Level_Vals)
     {
         // more than : max threshold
         //idxFor_LO_Num_For_Level = numFor_More_Than_Max_Threshold;
         idxFor_LO_Num_For_Level = i;
     }
   
   /*******************
      step : 3
         set : level number
   *******************/
   //int valOf_Ret_i = -1;
   int valOf_Ret_i = _lo_Num_For_Level[idxFor_LO_Num_For_Level];
   
   /*
   if(idxFor_LO_Num_For_Level == numFor_More_Than_Max_Threshold)
     {
         //
         valOf_Ret_i = idxFor_LO_Num_For_Level;
      
     }
   else
     {
         valOf_Ret_i = _lo_Num_For_Level[idxFor_LO_Num_For_Level];
     }
*/
   // return
   return valOf_Ret_i;

}//int get_Bar_Width_Level_Nums(int index, float lo_Level_Vals) {

/*
2020/05/02 13:12:20
func-list.(lib_ea_2.mqh).20200502_131220.txt
==========================================
<funcs>

1	int  OrderSend(
2	int  OrderSend(
3	int get_BB_Loc_Num(int index) {
4	void get_BB_Loc_Nums(
5	string get_LO_Width_Zone_Nums(
6	void get_Stats__Bar_Width(
7	bool is_Order_Fully_Pending(int _maxOf_NumOf_Pending_Orders) {
8	int is_Order_Pending() {
9	bool judge_1(string typeOf_Pattern_s) {
10	void op_Get_BB_Loc_Nums(
11	void op_Post_Take_Position(
12	int take_Position__Buy(double _minstoplevel, double _mintakelevel) {
13	int take_Position__Sell(double _minstoplevel, double _mintakelevel) {

==========================================
==========================================
<vars>

1	bool SWITHCH_DEBUG_lib_ea_2   = true;

==========================================
==========================================
<externs, inputs>


==========================================
*/
