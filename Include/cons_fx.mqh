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
   cons_LO_Threshold_Prices_A_J_M1
   
   at : 20200501_184032   
---------------------*/
float cons_LO_Threshold_Prices_A_J_M1[6] = {
      
      (float) 0.005, (float) 0.01, (float) 0.015
      
      , (float) 0.02, (float) 0.03, (float) 0.04

};

/*---------------------
   cons_LO_Threshold_Prices_A_J_M5
   
   at : 2020/05/02 12:52:26
---------------------*/
float cons_LO_Threshold_Prices_A_J_M5[6] = {
      
      (float) 0.010, (float) 0.020, (float) 0.030
      
      , (float) 0.040, (float) 0.050, (float) 0.060

};

/*---------------------
   cons_LO_Threshold_Prices_A_J_M5
   
   at : 2020/05/02 12:52:26
---------------------*/
float cons_LO_Threshold_Bar_Width_Level_A_J_M1[7] = {
        (float) -0.030
      , (float) -0.020
      , (float) -0.010
      
      , (float) 0.0
      
      , (float) 0.010
      , (float) 0.020
      , (float) 0.030
/*
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
*/

};
