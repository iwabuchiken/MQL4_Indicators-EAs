//+------------------------------------------------------------------+
//|                                               Moving Average.mq4 |
//|                   Copyright 2005-2014, MetaQuotes Software Corp. |
//|                                              http://www.mql4.com |
//+------------------------------------------------------------------+
#property copyright   "2005-2014, MetaQuotes Software Corp."
#property link        "http://www.mql4.com"
#property description "Moving Average sample expert advisor"

#define MAGICMA  20131111
//--- Inputs
input double Lots          =0.1;
input double MaximumRisk   =0.02;
input double DecreaseFactor=3;
input int    MovingPeriod  =12;
input int    MovingShift   =6;

int start() {

   //debug
   Alert("[", __FILE__, ":",__LINE__,"] starting...");
   
   // return
   return 0;

}// start()

void test_OrderSend() {

   int ticket = OrderSend(Symbol(),OP_BUY,0.1,     Ask,  2,       Bid-15*Point,  Bid+15*Point);

   //debug
   Alert("[", __FILE__, ":",__LINE__,"] ticket => ", ticket);

}//void test_OrderSend() {

int init() {

      //debug
      Alert("[", __FILE__, ":",__LINE__,"] init... ea_Test_2.mq4");
      
      //debug
      Alert("[", __FILE__, ":",__LINE__,"] Symbol() => '", Symbol(), "'");

      //debug
      Alert("[", __FILE__, ":",__LINE__,"] Period() => '", Period(), "'");

   // order
   //ref https://book.mql4.com/trading/ordersend
   test_OrderSend();

      // return
      return 0;


}//int init()

//+------------------------------------------------------------------+
//| __test_4_1_3__Higher_Than_Prev
//+------------------------------------------------------------------+
void __test_4_1_5__BUSL() {

   //ref https://book.mql4.com/trading/ordersend
   //int OrderSend (string symbol, int cmd, double volume, double price, int slippage, double stoploss,
   //    double takeprofit, string comment=NULL, int magic=0, datetime expiration=0, color arrow_color=CLR_NONE)
   //                      symbol   cmd   volume   price slippage stop loss      takeprofit
//   int ticket = OrderSend(Symbol(),OP_BUY,0.1,     Ask,  2,       Bid-15*Point,  Bid+15*Point);

   //debug
   //Alert("[", __FILE__, ":",__LINE__,"] Point => ", Point);

/*
   int errorno = GetLastError();
   
   //debug
   Alert("[", __FILE__, ":",__LINE__,"] errorno => ", errorno);
  */ 
   
}//__test_4_1_4__BUSL()

//+------------------------------------------------------------------+
//| OnTick function                                                  |
//+------------------------------------------------------------------+
void OnTick()
  {
      
      __test_4_1_5__BUSL();
   //debug
   //Alert("[", __FILE__, ":",__LINE__,"] High[0] => ", High[0]);
  
  }
//+------------------------------------------------------------------+

