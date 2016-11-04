//+------------------------------------------------------------------+
//|                                                        Kairi.mq4 |
//|                    Copyright(C) 2005 S.B.T. All Rights Reserved. |
//|                              http://fumito.s68.xrea.com/sb/sufx/ |
//+------------------------------------------------------------------+
#property  copyright "Copyright(C) 2005 S.B.T. All Rights Reserved."
#property  link      "http://fumito.s68.xrea.com/sb/sufx/"
//---- indicator settings
#property  indicator_separate_window
#property  indicator_buffers 1
#property  indicator_color1  DodgerBlue
//---- indicator parameters
extern int MA_Period=21;
extern int MA_Method=0;
extern int Apply=0;
//---- indicator buffers
double     Kairi_buffer[];

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   string short_name1,short_name2;

//---- drawing settings
   IndicatorDigits(MarketInfo(Symbol(),MODE_DIGITS)+1);
//---- indicator buffers mapping
   if(!SetIndexBuffer(0,Kairi_buffer))
      Print("cannot set indicator buffers!");
//---- name for DataWindow and indicator subwindow label
   switch(MA_Method)
     {
      case 1 : short_name1="EMA("; break;
      case 2 : short_name1="SMMA("; break;
      case 3 : short_name1="LWMA("; break;
      default :
         MA_Method=0;
         short_name1="SMA(";
     }
   switch(Apply)
     {
      case 1 : short_name2="Apply to Open price"; break;
      case 2 : short_name2="Apply to High price"; break;
      case 3 : short_name2="Apply to Low price"; break;
      case 4 : short_name2="Apply to Median price, (high+low)/2"; break;
      case 5 : short_name2="Apply to Typical price, (high+low+close)/3"; break;
      case 6 : short_name2="Apply to Weighted close price, (high+low+close+close)/4"; break;
      default :
         Apply=0;
         short_name2="Apply to Close price";
     }
   IndicatorShortName("Kairi("+short_name1+"("+MA_Period+")) "+short_name2);
   SetIndexLabel(0,"Kairi");
//---- initialization done
   return(0);
  }
//+------------------------------------------------------------------+
//| Moving Averages Convergence/Divergence                           |
//+------------------------------------------------------------------+
int start()
  {
   int limit;
   int counted_bars=IndicatorCounted();
   double     MA_buffer[];
//---- check for possible errors
   if(counted_bars<0) return(-1);
//---- last counted bar will be recounted
   if(counted_bars>0) counted_bars--;
   limit=Bars-counted_bars;
   ArrayResize(MA_buffer,limit);
//---- macd counted in the 1-st buffer
   for(int i=0; i<limit; i++) {
      switch(MA_Method) {
         case 0 : 
            switch(Apply) {
               case 0 : 
                  MA_buffer[i]=iMA(NULL,0,MA_Period,0,MODE_SMA,PRICE_CLOSE,i); break;
               case 1 : 
                  MA_buffer[i]=iMA(NULL,0,MA_Period,0,MODE_SMA,PRICE_OPEN,i); break;
               case 2 : 
                  MA_buffer[i]=iMA(NULL,0,MA_Period,0,MODE_SMA,PRICE_HIGH,i); break;
               case 3 : 
                  MA_buffer[i]=iMA(NULL,0,MA_Period,0,MODE_SMA,PRICE_LOW,i); break;
               case 4 : 
                  MA_buffer[i]=iMA(NULL,0,MA_Period,0,MODE_SMA,PRICE_MEDIAN,i); break;
               case 5 : 
                  MA_buffer[i]=iMA(NULL,0,MA_Period,0,MODE_SMA,PRICE_TYPICAL,i); break;
               case 6 : 
                  MA_buffer[i]=iMA(NULL,0,MA_Period,0,MODE_SMA,PRICE_WEIGHTED,i); break;
            }
            break;
         case 1 : 
            switch(Apply) {
               case 0 : 
                  MA_buffer[i]=iMA(NULL,0,MA_Period,0,MODE_EMA,PRICE_CLOSE,i); break;
               case 1 : 
                  MA_buffer[i]=iMA(NULL,0,MA_Period,0,MODE_EMA,PRICE_OPEN,i); break;
               case 2 : 
                  MA_buffer[i]=iMA(NULL,0,MA_Period,0,MODE_EMA,PRICE_HIGH,i); break;
               case 3 : 
                  MA_buffer[i]=iMA(NULL,0,MA_Period,0,MODE_EMA,PRICE_LOW,i); break;
               case 4 : 
                  MA_buffer[i]=iMA(NULL,0,MA_Period,0,MODE_EMA,PRICE_MEDIAN,i); break;
               case 5 : 
                  MA_buffer[i]=iMA(NULL,0,MA_Period,0,MODE_EMA,PRICE_TYPICAL,i); break;
               case 6 : 
                  MA_buffer[i]=iMA(NULL,0,MA_Period,0,MODE_EMA,PRICE_WEIGHTED,i); break;
            }
            break;
         case 2 : 
            switch(Apply) {
               case 0 : 
                  MA_buffer[i]=iMA(NULL,0,MA_Period,0,MODE_SMMA,PRICE_CLOSE,i); break;
               case 1 : 
                  MA_buffer[i]=iMA(NULL,0,MA_Period,0,MODE_SMMA,PRICE_OPEN,i); break;
               case 2 : 
                  MA_buffer[i]=iMA(NULL,0,MA_Period,0,MODE_SMMA,PRICE_HIGH,i); break;
               case 3 : 
                  MA_buffer[i]=iMA(NULL,0,MA_Period,0,MODE_SMMA,PRICE_LOW,i); break;
               case 4 : 
                  MA_buffer[i]=iMA(NULL,0,MA_Period,0,MODE_SMMA,PRICE_MEDIAN,i); break;
               case 5 : 
                  MA_buffer[i]=iMA(NULL,0,MA_Period,0,MODE_SMMA,PRICE_TYPICAL,i); break;
               case 6 : 
                  MA_buffer[i]=iMA(NULL,0,MA_Period,0,MODE_SMMA,PRICE_WEIGHTED,i); break;
            }
            break;
         case 3 : 
            switch(Apply) {
               case 0 : 
                  MA_buffer[i]=iMA(NULL,0,MA_Period,0,MODE_LWMA,PRICE_CLOSE,i); break;
               case 1 : 
                  MA_buffer[i]=iMA(NULL,0,MA_Period,0,MODE_LWMA,PRICE_OPEN,i); break;
               case 2 : 
                  MA_buffer[i]=iMA(NULL,0,MA_Period,0,MODE_LWMA,PRICE_HIGH,i); break;
               case 3 : 
                  MA_buffer[i]=iMA(NULL,0,MA_Period,0,MODE_LWMA,PRICE_LOW,i); break;
               case 4 : 
                  MA_buffer[i]=iMA(NULL,0,MA_Period,0,MODE_LWMA,PRICE_MEDIAN,i); break;
               case 5 : 
                  MA_buffer[i]=iMA(NULL,0,MA_Period,0,MODE_LWMA,PRICE_TYPICAL,i); break;
               case 6 : 
                  MA_buffer[i]=iMA(NULL,0,MA_Period,0,MODE_LWMA,PRICE_WEIGHTED,i); break;
            }
            break;
      }
   }

   for(i=0; i<limit; i++) {
   switch(Apply)
     {
      case 0 : Kairi_buffer[i] = (Close[i]-MA_buffer[i])/MA_buffer[i]*100; break;
      case 1 : Kairi_buffer[i] = (Open[i]-MA_buffer[i])/MA_buffer[i]*100; break;
      case 2 : Kairi_buffer[i] = (High[i]-MA_buffer[i])/MA_buffer[i]*100; break;
      case 3 : Kairi_buffer[i] = (Low[i]-MA_buffer[i])/MA_buffer[i]*100; break;
      case 4 : Kairi_buffer[i] = (((High[i]+Low[i])/2)-MA_buffer[i])/MA_buffer[i]*100-100; break;
      case 5 : Kairi_buffer[i] = (((High[i]+Low[i]+Close[i])/3)-MA_buffer[i])/MA_buffer[i]*100-100; break;
      case 6 : Kairi_buffer[i] = (((High[i]+Low[i]+Close[i]+Close[i])/4)-MA_buffer[i])/MA_buffer[i]*100-100; break;
     }      
   }

   return(0);
  }

