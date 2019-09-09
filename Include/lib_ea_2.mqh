//+------------------------------------------------------------------+
//|                                                      utils.h.mqh |
//|                        Copyright 2016, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
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

//extern int NUMOF_TARGET_BARS;

//extern string dpath_Log;

/*---------------------
   vars
---------------------*/
bool SWITHCH_DEBUG_lib_ea_2   = true;

/*---------------------

   bool judge_1()
   
   at : 2019/08/26 13:36:27

---------------------*/
bool judge_1() {

//_20190826_133747:caller
//_20190826_133801:head
//_20190826_133815:wl

   /*******************
      step : X
         return
   *******************/
   return true;

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
int take_Position__Buy() {

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
   double minstoplevel     = 4.0;
   //double mintakelevel     = 8.0;
   double mintakelevel     = 8.0;
   
   double stoploss=NormalizeDouble(Bid-minstoplevel*Point,Digits);
   
   //double takeprofit=NormalizeDouble(Bid+minstoplevel*Point,Digits);
   //double takeprofit    = NormalizeDouble(Bid + mintakelevel * Point, Digits);
   double takeprofit    = NormalizeDouble(Bid + (Ask - Bid) + mintakelevel * Point, Digits);
   
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
   

}//take_Position__Buy()

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
