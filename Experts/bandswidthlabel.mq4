#property copyright "tomokinta"

#property indicator_chart_window
#property indicator_buffers 3
#property indicator_color1 Gold
#property indicator_color2 Gold
#property indicator_color3 Gold


//---- indicator parameters
extern int    BandsPeriod       = 20;
extern int    BandsShift        = 0;
extern double BandsDeviations   = 2.0;
extern int    BandsAppliedPrice = 0;

extern int    FontColor         = Tomato;
extern int    FontSize          = 24;
extern string FontType          = "Comic Sans MS";
extern int    WhatCorner        = 3;



//---- buffers
double MovingBuffer[];
double UpperBuffer[];
double LowerBuffer[];

int init(){
    //---- indicators
    SetIndexStyle(0,DRAW_LINE);
    SetIndexBuffer(0,MovingBuffer);
    SetIndexStyle(1,DRAW_LINE);
    SetIndexBuffer(1,UpperBuffer);
    SetIndexStyle(2,DRAW_LINE);
    SetIndexBuffer(2,LowerBuffer);
    //----
    SetIndexDrawBegin(0,BandsPeriod+BandsShift);
    SetIndexDrawBegin(1,BandsPeriod+BandsShift);
    SetIndexDrawBegin(2,BandsPeriod+BandsShift);
    //----
    return(0);
}


int deinit(){
   ObjectDelete("Bands_Width_Label");
   return(0);
}

int start(){

    if(Bars<=BandsPeriod) return(0);

    for(int i=0; i<Bars; i++){
        UpperBuffer[i] = iBands(NULL,0,BandsPeriod,BandsDeviations,BandsShift,BandsAppliedPrice,MODE_UPPER,i);
        LowerBuffer[i] = iBands(NULL,0,BandsPeriod,BandsDeviations,BandsShift,BandsAppliedPrice,MODE_LOWER,i);
        MovingBuffer[i] = iMA(NULL,0,BandsPeriod,BandsShift,BandsAppliedPrice,PRICE_CLOSE,i);
    }

    string Band_Width = DoubleToStr(UpperBuffer[0] - LowerBuffer[0],Digits);
    ObjectCreate("Bands_Width_Label", OBJ_LABEL, 0, 0, 0);
    ObjectSetText("Bands_Width_Label", Band_Width, FontSize, FontType, FontColor);
    ObjectSet("Bands_Width_Label", OBJPROP_CORNER, WhatCorner);
    ObjectSet("Bands_Width_Label", OBJPROP_XDISTANCE, 1);
    ObjectSet("Bands_Width_Label", OBJPROP_YDISTANCE, 1);
}

