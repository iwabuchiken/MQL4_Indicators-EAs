//--------------------------------------------------------------------
// callindicator.mq4
// The code should be used for educational purpose only.
//--------------------------------------------------------------------
extern int Period_MA = 21;            // Calculated MA period
bool Fact_Up = true;                  // Fact of report that price..
bool Fact_Dn = true;                  //..is above or below MA
//--------------------------------------------------------------------
int start()                           // Special function start()
  {
   double MA;                         // MA value on 0 bar    
//--------------------------------------------------------------------
                                      // Tech. ind. function call
   MA=iMA(NULL,0,Period_MA,0,MODE_SMA,PRICE_CLOSE,0); 
//--------------------------------------------------------------------
//   if (Bid > MA)   // Checking if price above
   if (Bid > MA && Fact_Up == true)   // Checking if price above
     {
      Fact_Dn = true;                 // Report about price above MA
      Fact_Up = false;                // Don't report about price below MA

      // show alert
      //show_Alert();
      show_Alert_2();
      
      
      
     }
//--------------------------------------------------------------------
//   if (Bid < MA)   // Checking if price below
   if (Bid < MA && Fact_Dn == true)   // Checking if price below
     {
      Fact_Up = true;                 // Report about price below MA
      Fact_Dn = false;                // Don't report about price above MA
      Alert("Price is below MA(",Period_MA,").");// Alert 
     }
//--------------------------------------------------------------------
   return;                            // Exit start()
  }
//--------------------------------------------------------------------

int get_IndicatorCounted() {

   // get count
   int count = IndicatorCounted();
   
   return count;

}//get_IndicatorCounted

void show_Alert() {

      Alert("Price is above MA!!!(",Period_MA,").");// Alert 
      //Alert("Bid is now... ==> (",Bid,").");// Alert 
      
      
      int count = get_IndicatorCounted();
      //string commment = "Bid is now...?? ==> (",Bid," / Period_MA=",Period_MA," \n/ bars=",count," / Bars=",Bars,").";
      //string commment = "Bid is now...?? ==>  (",Bid," / ";
      
      
      int Counted_bars=IndicatorCounted(); // Number of counted bars
      int i = Bars-Counted_bars-1;
      
      //ref multiple string lines / https://forum.mql4.com/46640
      //Alert(commment);
      Alert("Bid is now... ==> (",Bid," / Period_MA=",Period_MA," " + 
            "\n/ bars=",count," " + 
            "/ Bars=",Bars," / High=",High[i],"" + 
            " ).");// Alert 


}//show_Alert()

void show_Alert_2() {

      //Alert("TerminalInfoString(TERMINAL_DATA_PATH)... \n " +
        //     "==> (",TerminalInfoString(TERMINAL_DATA_PATH),").");// Alert 
             
      // C:\Users\iwabuchiken\AppData\Roaming\MetaQuotes\Terminal\34B08C83A5AAE27A4079DE708E60511E


      

}//show_Alert()
