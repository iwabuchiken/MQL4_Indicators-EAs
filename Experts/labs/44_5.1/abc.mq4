//+------------------------------------------------------------------+
//|                                                          abc.mq4 |
//|  Copyright (c) 2010 Area Creators Co., Ltd. All rights reserved. |
//|                                          http://www.mars-fx.com/ |
//+------------------------------------------------------------------+
#property copyright "Copyright (c) 2010 Area Creators Co., Ltd. All rights reserved."
#property link      "http://www.mars-fx.com/"

//+------------------------------------------------------------------+
//| ヘッダーファイル読込                                             |
//+------------------------------------------------------------------+
#include <stderror.mqh>
#include <stdlib.mqh>
#include <WinUser32.mqh>

//+------------------------------------------------------------------+
//| 定数宣言部                                                       |
//+------------------------------------------------------------------+
#define URL "http://www.mars-fx.com/"      //URL
#define ERR_TITLE1 "パラメーターエラー"    //エラータイトル(その1)
#define MAIL_TITLE "MarsFX MailAlert"      //メールタイトル
#define R_SUCCESS         0                //戻り値(成功)
#define R_ERROR          -1                //戻り値(エラー)
#define R_ALERT          -2                //戻り値(警告1)
#define R_WARNING        -3                //戻り値(警告2)
#define BUY_SIGNAL        1                //エントリーシグナル(ロング)
#define SELL_SIGNAL       2                //エントリーシグナル(ショート)
#define BUY_EXIT_SIGNAL   1                //決済シグナル(ロング)
#define SELL_EXIT_SIGNAL  2                //決済シグナル(ショート)
#define ORDER_TYPE_ALL    1                //オーダーセレクトタイプ(全て)
#define ORDER_TYPE_BUY    2                //オーダーセレクトタイプ(ロング)
#define ORDER_TYPE_SELL   3                //オーダーセレクトタイプ(ショート)
#define LAST_ORDER        4                //オーダーセレクトタイプ(直近)
#define LAST_HIS          1                //オーダー履歴(直近)
#define LAST_BUT_ONE_HIS  2                //オーダー履歴(一つ前)

//+------------------------------------------------------------------+
//| 外部パラメーター宣言                                             |
//+------------------------------------------------------------------+
extern int MagicNumber       = 12345678;      //マジックナンバー
extern double Lots           = 0.1;                   //ロット数
extern int Slippage          = 3;                 //スリッページ
extern double TakeProfitPips = 0;         //利食いPips
extern double StopLossPips   = 0;           //損切りPips
extern int OpenOrderMax      = 1;           //最大保有ポジション数
extern double CloseLotsMax   = 0;           //同時決済ポジション数
extern int AutoLotsType      = 0;    //自動ロット算出タイプ(0:なし、1:%指定、2:マーチンゲール、3:逆マーチンゲール)


//エントリー条件2(ショート) Start------------------------------------------------------------------------------------------------------------------------------
//BB
extern int Entry002_BB_Period       = 20;         //期間
extern int Entry002_BB_Deviation    = 2;       //偏差
extern int Entry002_BB_Mode         = 1;            //ライン
extern int Entry002_BB_TimeFrame    = 0;      //時間軸
extern int Entry002_BB_AppliedPrice = 0;   //価格
//エントリー条件2(ショート) End--------------------------------------------------------------------------------------------------------------------------------


//決済条件2(ロング決済) Start------------------------------------------------------------------------------------------------------------------------------
//MA
extern int Exit002_MA_Period       = 14;          //期間
extern int Exit002_MA_Method       = 0;           //算出方式
extern int Exit002_MA_TimeFrame    = 0;       //時間軸
extern int Exit002_MA_AppliedPrice = 0;    //価格
//決済条件2(ロング決済) End--------------------------------------------------------------------------------------------------------------------------------




//+------------------------------------------------------------------+
//| グローバル変数宣言                                               |
//+------------------------------------------------------------------+
string PGName = "abc";     //プログラム名
int RETRY_TIMEOUT    = 60;               //送信待ち時間(秒)
int RETRY_INTERVAL   = 15000;            //リトライインターバル
int PLDigits         = 2;                //損益少数点
double wk_point      = 0;                //3桁、5桁対応Point
double order[1][12];                    //オーダー格納用   
double order_his[1][12];                //オーダー履歴格納用
double exception[1][2];                 //例外オーダー格納用
int OrderCount       = 0;                //オーダー総数
bool MailFlag        = false;            //メールお知らせ機能(true:有効、false:無効)
bool AlertFlag       = false;            //アラートお知らせ機能(true:有効、false:無効)

//+------------------------------------------------------------------+
//| 初期処理                                                         |
//+------------------------------------------------------------------+
int init()
{
   //Pips変換処理
   if(Digits==3 || Digits==5)
   {
      wk_point = Point * 10;
   }
   else
   {
      wk_point = Point;
   }
   
   //オーダー検索
   ArrayInitialize(order,0);                     //オーダー配列初期化
   OrderCount = OrderCheck(order,MagicNumber,ORDER_TYPE_ALL);
   if(OrderCount == R_ERROR) return(R_ERROR);    //エラー処理
   
   return(0);
}

//+------------------------------------------------------------------+
//| 終了処理                                                         |
//+------------------------------------------------------------------+
int deinit()
{
   //オブジェクトの削除
   ObjectDelete("PGName");
   
   return(0);
}

//+------------------------------------------------------------------+
//| メイン処理                                                       |
//+------------------------------------------------------------------+
int start()
{
   //変数宣言
   bool result_flag       = false;                            //処理結果格納用
   int result_code        = R_ERROR;                          //処理結果格納用
   int order_count        = R_ERROR;                          //ポジション検索結果
   int order_his_count    = 0;                                //履歴ポジション数
   bool buy_entry_filter  = true;                             //フィルターフラグ(ロングエントリー)
   bool sell_entry_filter = true;                             //フィルターフラグ(ショートエントリー)
   bool buy_exit_filter   = true;                             //フィルターフラグ(ロング決済)
   bool sell_exit_filter  = true;                             //フィルターフラグ(ショート決済)
   int entry_sig          = 0;                                //エントリーシグナル
   int exit_sig           = 0;                                //決済シグナル
   int type               = OP_BUY;                           //売買区分
   double wk_mn           = 0;                                //マジックナンバー
   double wk_lots         = Lots;                             //ロット数
   double open_price      = 0;                                //約定価格格納用
   string comment         = "";                               //オーダーコメント格納用
   color arrow_color      = CLR_NONE;                         //色
   double wk_close_lots   = CloseLotsMax;                     //決済ロット数
   double takeprofit      = 0;                                //TakeProfit格納用
   double stoploss        = 0;                                //StopLoss格納用   
   int i                  = 0;                                //汎用カウンタ
   int x                  = 0;                                //汎用カウンタ
   int err_code           = 0;                                //エラーコード取得用
   string err_title       = "[オブジェクト生成エラー] ";      //エラーメッセージタイトル
   string err_title02     = "[例外エラー] ";                  //エラーメッセージタイトル02
   
   //エントリー条件-終値確定 Start----------------------------------------------------------------------------------------------------------------------
   int entry_shift_01 = 1;
   //エントリー条件-終値確定 End------------------------------------------------------------------------------------------------------------------------
   
   //決済条件-終値確定 Start----------------------------------------------------------------------------------------------------------------------------
   int exit_shift_01 = 1;
   //決済条件-終値確定 End------------------------------------------------------------------------------------------------------------------------------
   
   //フィルター条件-終値確定 Start----------------------------------------------------------------------------------------------------------------------
   //フィルター条件-終値確定 End------------------------------------------------------------------------------------------------------------------------
   
   //ラベルオブジェクト生成(PGName)
   if(ObjectFind("PGName")!=WindowOnDropped())
   {
      result_flag = ObjectCreate("PGName",OBJ_LABEL,WindowOnDropped(),0,0);
      if(result_flag == false)          
      {
         err_code = GetLastError();
         Print(err_title,err_code, " ", ErrorDescription(err_code));
      }
   }
   ObjectSet("PGName",OBJPROP_CORNER,3);              //アンカー設定
   ObjectSet("PGName",OBJPROP_XDISTANCE,3);           //横位置設定
   ObjectSet("PGName",OBJPROP_YDISTANCE,5);           //縦位置設定
   ObjectSetText("PGName",PGName,8,"Arial",Gray);     //テキスト設定


   //オーダー検索
   ArrayInitialize(order,0);                      //オーダー配列初期化
   order_count = OrderCheck(order,MagicNumber,ORDER_TYPE_ALL);
   if(order_count == R_ERROR) return(R_ERROR);    //エラー処理

   //TP/SL決済処理
   if(OrderCount > order_count)
   {
      //変数設定
      int y = 0;
      ArrayInitialize(exception,0);

      for(x=OrderCount;x>order_count;x--)
      {
         //オーダー履歴検索
         ArrayInitialize(order_his,0);                      //オーダー配列初期化
         order_his_count = OrderCheckHis(order_his,MagicNumber,exception,LAST_BUT_ONE_HIS);
         if(order_his_count == R_ERROR) return(R_ERROR);    //エラー処理
         
         //変数設定
         string str_type    = "";                                                           //オーダータイプ
         if(order_his[order_his_count-1][1]==OP_BUY) str_type  = "Buy";                     //買い
         if(order_his[order_his_count-1][1]==OP_SELL) str_type = "Sell";                    //売り
         double order_time  = order_his[order_his_count-1][7];                              //決済時刻取得
         double close_price = NormalizeDouble(order_his[order_his_count-1][8],Digits);      //決済価格
         double op          = NormalizeDouble(order_his[order_his_count-1][9],PLDigits);     //オーダープロフィット
         double swap        = NormalizeDouble(order_his[order_his_count-1][10],PLDigits);    //スワップ損益         
         double comm        = NormalizeDouble(order_his[order_his_count-1][11],PLDigits);    //手数料
         double pl          = op + swap + comm;                                             //合計損益
         exception[y][0]    = order_his[order_his_count-1][0];                              //マジックナンバー取得(除外オーダー)
         exception[y][1]    = order_his[order_his_count-1][7];                              //決済時刻取得(除外オーダー)
         y = y + 1;                                                                         //カウントアップ
         
         
         OrderCount = OrderCount - 1;
      }
   }
  
   
   //オーダー検索(ロング決済)
   ArrayInitialize(order,0);                             //オーダー配列初期化
   order_count = OrderCheck(order,MagicNumber,ORDER_TYPE_BUY);
   if(order_count == R_ERROR) return(R_ERROR);           //エラー処理

   //決済シグナル判定処理
   if(order_count > 0)
   {
      for(x=order_count-1;x>=0;x--)
      {
         //ロングポジション決済判定
         if(order[x][1] == OP_BUY)
         {
            
            //フィルター条件(共通) Start-------------------------------------------------------------------------------------------------------------------------
            //フィルター条件(共通) End---------------------------------------------------------------------------------------------------------------------------
            
            //決済条件1 Start----------------------------------------------------------------------------------------------------------------------------  
            //変数宣言
            int exit001_price_digits = Digits;    //少数点
            
            //決済条件1
            double exit001_before = Close[exit_shift_01+1];        //終値1
            double exit001_after  = Close[exit_shift_01];          //終値2
            
            //少数点正規化 
            exit001_before = NormalizeDouble(exit001_before,exit001_price_digits);
            exit001_after  = NormalizeDouble(exit001_after,exit001_price_digits);
            //決済条件1 End------------------------------------------------------------------------------------------------------------------------------  

            //決済条件2 Start----------------------------------------------------------------------------------------------------------------------------  
            //変数宣言
            int exit002_ma_digits = Digits;    //少数点
            
            //決済条件2
            double exit002_before = iMA(NULL,Exit002_MA_TimeFrame,Exit002_MA_Period,0,Exit002_MA_Method,Exit002_MA_AppliedPrice,exit_shift_01+1);    //移動平均線1
            double exit002_after  = iMA(NULL,Exit002_MA_TimeFrame,Exit002_MA_Period,0,Exit002_MA_Method,Exit002_MA_AppliedPrice,exit_shift_01);      //移動平均線2
            
            //少数点正規化 
            exit002_before = NormalizeDouble(exit002_before,exit002_ma_digits);
            exit002_after  = NormalizeDouble(exit002_after,exit002_ma_digits);
            //決済条件2 End------------------------------------------------------------------------------------------------------------------------------  

            
            //決済シグナル判定(ロング)
            exit_sig = 0;
            
            //決済条件(共通-ロング) Start------------------------------------------------------------------------------------------------------------------------
            if((exit001_before >= exit002_before) && (exit001_after < exit002_after))
            {
               if(exit_sig==0) exit_sig = BUY_EXIT_SIGNAL;     //決済シグナル(ロング)
            }
            else exit_sig = -1;
            
            //決済条件(共通-ロング) End-------------------------------------------------------------------------------------------------------------------------- 
           
            //注文決済処理(ロング)
            if((exit_sig == BUY_EXIT_SIGNAL) && (buy_exit_filter == true))
            {         
               //レート更新
               RefreshRates();

               //変数設定
               arrow_color = Blue;      //色
               
               //決済ロット数設定
               if(CloseLotsMax==0) wk_close_lots = order[x][5];
               else wk_close_lots = CloseLotsMax;

               //ポジション決済(ロング)
               result_code = OrderCloseOrg(Slippage,order[x][0],wk_close_lots,MailFlag,AlertFlag,arrow_color);
               if(result_code!=R_SUCCESS) return(R_ERROR);    //エラー処理
               OrderCount = OrderCount - 1;                   //オーダー数減算  

               //分割決済対応
               for(i=0; i<OrdersTotal(); i++)
               {
                  if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
                  {
                     //マジックナンバーと取引通貨ペアの確認
                     if(OrderSymbol() == Symbol() && OrderMagicNumber() == order[x][0])
                     {
                         OrderCount = OrderCount + 1;         //オーダー数加算  
                         break;
                     }
                  }
               }
            }
         }
      }
   }
   
   //オーダー検索(ショート決済)
   ArrayInitialize(order,0);                             //オーダー配列初期化
   order_count = OrderCheck(order,MagicNumber,ORDER_TYPE_SELL);
   if(order_count == R_ERROR) return(R_ERROR);           //エラー処理

   //決済シグナル判定処理
   if(order_count > 0)
   {
      for(x=order_count-1;x>=0;x--)
      {
         //ショートポジション決済判定
         if(order[x][1] == OP_SELL)
         {
            
            //フィルター条件(共通) Start-------------------------------------------------------------------------------------------------------------------------
            //フィルター条件(共通) End---------------------------------------------------------------------------------------------------------------------------
            
            
            //決済シグナル判定(ショート)
            exit_sig = 0;
            
            //決済条件(共通-ショート) Start------------------------------------------------------------------------------------------------------------------------
            //決済条件(共通-ショート) End-------------------------------------------------------------------------------------------------------------------------- 
           
            //注文決済処理(ショート)
            if((exit_sig == SELL_EXIT_SIGNAL) && (sell_exit_filter == true))
            {         
               //レート更新
               RefreshRates();

               //変数設定
               arrow_color = Red;      //色
               
               //決済ロット数設定
               if(CloseLotsMax==0) wk_close_lots = order[x][5];
               else wk_close_lots = CloseLotsMax;

               //ポジション決済(ショート)
               result_code = OrderCloseOrg(Slippage,order[x][0],wk_close_lots,MailFlag,AlertFlag,arrow_color);
               if(result_code!=R_SUCCESS) return(R_ERROR);    //エラー処理
               OrderCount = OrderCount - 1;                   //オーダー数減算
               
               //分割決済対応
               for(i=0; i<OrdersTotal(); i++)
               {
                  if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
                  {
                     //マジックナンバーと取引通貨ペアの確認
                     if(OrderSymbol() == Symbol() && OrderMagicNumber() == order[x][0])
                     {
                         OrderCount = OrderCount + 1;         //オーダー数加算  
                         break;
                     }
                  }
               }
            }
         }
      }
   }
   
   //オーダー検索(ロングエントリー)
   ArrayInitialize(order,0);                             //オーダー配列初期化
   order_count = OrderCheck(order,MagicNumber,ORDER_TYPE_ALL);
   if(order_count == R_ERROR) return(R_ERROR);           //エラー処理
   
   
   //フィルター条件(共通) Start-------------------------------------------------------------------------------------------------------------------------
   //フィルター条件(共通) End---------------------------------------------------------------------------------------------------------------------------
   
   
   //エントリーシグナル判定(ロング)
   entry_sig = 0;
   
   //エントリー条件(共通-ロング) Start------------------------------------------------------------------------------------------------------------------
   //エントリー条件(共通-ロング) End--------------------------------------------------------------------------------------------------------------------

   //注文送信処理(ロング)
   if((entry_sig == BUY_SIGNAL) && (buy_entry_filter == true) && (order_count < OpenOrderMax))
   {         
      //レート更新
      RefreshRates();

      //変数設定
      type        = OP_BUY;    //ロング
      open_price  = Ask;       //買値
      arrow_color = Blue;      //色
      
      //マジックナンバー算出
      wk_mn = MagicNumControl(MagicNumber);   
      
  
      //オーダーの送信
      result_code = OrderSendOrg(type,wk_lots,open_price,Slippage,0,0,comment,wk_mn,MailFlag,AlertFlag,arrow_color);
      if((result_code == R_ALERT) || (result_code == R_ERROR)) return(R_ERROR);      //エラー処理
      OrderCount = OrderCount + 1;                                                   //オーダー数加算    
   }
   
   //オーダー検索(ショートエントリー)
   ArrayInitialize(order,0);                             //オーダー配列初期化
   order_count = OrderCheck(order,MagicNumber,ORDER_TYPE_ALL);
   if(order_count == R_ERROR) return(R_ERROR);           //エラー処理
   
   
   //フィルター条件(共通) Start-------------------------------------------------------------------------------------------------------------------------
   //フィルター条件(共通) End---------------------------------------------------------------------------------------------------------------------------
   
   //エントリー条件1 Start----------------------------------------------------------------------------------------------------------------------
   //変数宣言
   int entry001_price_digits = Digits;    //少数点
   
   //エントリー条件1
   double entry001_before = Close[entry_shift_01+1];    //終値1
   double entry001_after  = Close[entry_shift_01];      //終値2
   
   //少数点正規化 
   entry001_before = NormalizeDouble(entry001_before,entry001_price_digits);
   entry001_after  = NormalizeDouble(entry001_after,entry001_price_digits);
   //エントリー条件1 End------------------------------------------------------------------------------------------------------------------------

   //エントリー条件2 Start----------------------------------------------------------------------------------------------------------------------
//変数宣言
   int entry002_bb_digits = Digits;    //少数点
   
   //エントリー条件2
   double entry002_before = iBands(NULL,Entry002_BB_TimeFrame,Entry002_BB_Period,Entry002_BB_Deviation,0,Entry002_BB_AppliedPrice,Entry002_BB_Mode,entry_shift_01+1);  //BB1
   double entry002_after  = iBands(NULL,Entry002_BB_TimeFrame,Entry002_BB_Period,Entry002_BB_Deviation,0,Entry002_BB_AppliedPrice,Entry002_BB_Mode,entry_shift_01);    //BB2
   
   //少数点正規化 
   entry002_before = NormalizeDouble(entry002_before,entry002_bb_digits);
   entry002_after  = NormalizeDouble(entry002_after,entry002_bb_digits);
   //エントリー条件2 End------------------------------------------------------------------------------------------------------------------------

   
   //エントリーシグナル判定(ショート)
   entry_sig = 0;
   
   //エントリー条件(共通-ショート) Start------------------------------------------------------------------------------------------------------------------
   if((entry001_before <= entry002_before) && (entry001_after > entry002_after))
   {
      if(entry_sig==0) entry_sig = SELL_SIGNAL;    //エントリーシグナル(ショート)
   }
   else entry_sig = -1;
  
   //エントリー条件(共通-ショート) End--------------------------------------------------------------------------------------------------------------------

   //注文送信処理(ショート)
   if((entry_sig == SELL_SIGNAL) && (sell_entry_filter == true) && (order_count < OpenOrderMax))
   {
      //レート更新
      RefreshRates();
      
      //変数設定
      type        = OP_SELL;    //ショート
      open_price  = Bid;        //売値
      arrow_color = Red;        //色

      //マジックナンバー算出
      wk_mn = MagicNumControl(MagicNumber);   
      

      //オーダーの送信
      result_code = OrderSendOrg(type,wk_lots,open_price,Slippage,0,0,comment,wk_mn,MailFlag,AlertFlag,arrow_color);
      if((result_code == R_ALERT) || (result_code == R_ERROR)) return(R_ERROR);      //エラー処理
      OrderCount = OrderCount + 1;                                                   //オーダー数加算    
   }
      
   //オーダー検索(SL/TP設定用)
   ArrayInitialize(order,0);                             //オーダー配列初期化
   order_count = OrderCheck(order,MagicNumber,ORDER_TYPE_ALL);
   if(order_count == R_ERROR) return(R_ERROR);           //エラー処理

   //SL/TPの設定
   for(i=order_count-1;i>=0;i--)
   {
      //StopLossの設定
      if(StopLossPips > 0)
      {
         //レート更新
         RefreshRates();

         //StopLoss算出(ロング)
         if(order[i][1] == OP_BUY)
         {
            stoploss = order[i][2] - StopLossPips * wk_point;
            stoploss = NormalizeDouble(stoploss,Digits);      //小数点正規化
         }
         //StopLoss算出(ショート)
         else if (order[i][1] == OP_SELL)
         {
            stoploss = order[i][2] + StopLossPips * wk_point;
            stoploss = NormalizeDouble(stoploss,Digits);      //小数点正規化
         }
         else
         {
            Print("不明なオーダーが選択されました。");
            return(R_ERROR);           //エラー処理
         }
         if(NormalizeDouble(order[i][3],Digits) == 0)
         {
            //オーダー変更処理
            result_code = OrderModifyOrg(stoploss,0,order[i][0],MailFlag,AlertFlag,arrow_color);  
            if(result_code != R_SUCCESS) return(R_ERROR);    //エラー処理
         }
      }
      //TakeProfitの設定
      if(TakeProfitPips > 0)
      {     
         //TakeProfit算出(ロング)
         if(order[i][1] == OP_BUY)
         {
            takeprofit = order[i][2] + TakeProfitPips * wk_point;
            takeprofit = NormalizeDouble(takeprofit,Digits);      //小数点正規化
         }
         //TakeProfit算出(ショート)
         else if (order[i][1] == OP_SELL)
         {
            takeprofit = order[i][2] - TakeProfitPips * wk_point;
            takeprofit = NormalizeDouble(takeprofit,Digits);      //小数点正規化
         }
         else
         {
            Print("不明なオーダーが選択されました。");
            return(R_ERROR);           //エラー処理
         }
         if(NormalizeDouble(order[i][4],Digits) == 0)
         {
            //オーダー変更処理
            result_code = OrderModifyOrg(0,takeprofit,order[i][0],MailFlag,AlertFlag,arrow_color);  
            if(result_code != R_SUCCESS) return(R_ERROR);    //エラー処理
         }
      }
   }
   return(0);
}
//+------------------------------------------------------------------+
//| 処理名  ：マジックナンバー算出処理                               |
//| 処理詳細：マジックナンバーの算出を行う。                         |
//| 引数    ：magic_base マジックナンバーの基準値                    |
//| 戻り値  ：magic_num 0以上…マジックナンバー                      |
//|                     R_ERROR…エラー                              |
//| 備考    ：                                                       |
//+------------------------------------------------------------------+
int MagicNumControl(int magic_num)
{
   int order_total  = OrdersTotal();                      //オーダーカウント用
   int err_code     = 0;                                  //エラーコード取得用
   string err_title = "[マジックナンバー算出エラー] ";    //エラーメッセージタイトル
   
   //マジックナンバー検索処理
   for(int x = magic_num;x < magic_num+OpenOrderMax;x++)
   {
      bool unused_flag = false;
      if (order_total > 0) 
      {
         for(int i=0; i<order_total; i++)
         {
            if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
            {
               //マジックナンバーと取引通貨ペアの確認
               if((OrderSymbol() == Symbol()) && (OrderMagicNumber() == x))
               {
                  unused_flag = true;
                  break;
               }
            }
            //オーダーセレクトエラー
            else          
            {
               err_code = GetLastError();
               Print(err_title,err_code, " ", ErrorDescription(err_code));
               magic_num = R_ERROR;
               break;
            }
         }
      }
      if(unused_flag == false) break;
   }
   return(x);
}
//+------------------------------------------------------------------+
//| 処理名  ：オーダーカウント処理                                   |
//| 処理詳細：オーダーの総数カウントを行う。                         |
//| 引数    ：&order[][] マジックナンバー/コメント                   |
//|           magic_base マジックナンバーの基準値                    |
//|           type 検索種別                                          |
//| 戻り値  ：magic_num 0以上…オーダー総数                          |
//|                     R_ERROR…エラー                              |
//| 備考    ：                                                       |
//+------------------------------------------------------------------+
int OrderCheck(double &order[][],int magic_base,int type)
{
   //変数宣言
   int order_total          = OrdersTotal();                  //オーダーカウント用
   int order_count          = 0;                              //検索数
   datetime order_open_date = 0;                              //最新オーダー日付格納用
   int err_code             = 0;                              //エラーコード取得用
   string err_title         = "[オーダーカウントエラー] ";    //エラーメッセージタイトル

   //オーダーのカウント
   for(int i=0; i<order_total; i++)
   {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
      {
         //マジックナンバーと取引通貨ペアの確認
         if(OrderSymbol() == Symbol() && (OrderMagicNumber() >= magic_base && OrderMagicNumber() < (magic_base + OpenOrderMax)))
         {
            switch(type)
            {
               //全オーダー
               case ORDER_TYPE_ALL:
                  if (OrderType() == OP_BUY || OrderType() == OP_SELL)
                  {
                     //マジックナンバー取得
                     order[order_count][0] = OrderMagicNumber();

                     //オーダータイプ取得
                     order[order_count][1] = OrderType();

                     //オープンプライス
                     order[order_count][2] = OrderOpenPrice();
               
                     //ストップロス
                     order[order_count][3] = OrderStopLoss();
                  
                     //テイクプロフィット
                     order[order_count][4] = OrderTakeProfit();
                  
                     //ロット数
                     order[order_count][5] = OrderLots();
                  
                     //約定時刻
                     order[order_count][6] = OrderOpenTime();
                  
                     //決済時刻
                     order[order_count][7] = OrderCloseTime();
                  
                     //決済価格
                     order[order_count][8] = OrderClosePrice();
                  
                     //評価損益
                     order[order_count][9] = OrderProfit();
                                    
                     //スワップ損益
                     order[order_count][10] = OrderSwap();
                  
                     //手数料
                     order[order_count][11] = OrderCommission();

                     order_count++;
                  }
               break;
               
               //ロングオーダー
               case ORDER_TYPE_BUY:
                  if (OrderType() == OP_BUY)
                  {
                     //マジックナンバー取得
                     order[order_count][0] = OrderMagicNumber();

                     //オーダータイプ取得
                     order[order_count][1] = OrderType();

                     //オープンプライス
                     order[order_count][2] = OrderOpenPrice();
               
                     //ストップロス
                     order[order_count][3] = OrderStopLoss();
                  
                     //テイクプロフィット
                     order[order_count][4] = OrderTakeProfit();
                  
                     //ロット数
                     order[order_count][5] = OrderLots();

                     //約定時刻
                     order[order_count][6] = OrderOpenTime();
                  
                     //決済時刻
                     order[order_count][7] = OrderCloseTime();
                  
                     //決済価格
                     order[order_count][8] = OrderClosePrice();
                  
                     //評価損益
                     order[order_count][9] = OrderProfit();
                                    
                     //スワップ損益
                     order[order_count][10] = OrderSwap();
                  
                     //手数料
                     order[order_count][11] = OrderCommission();

                     order_count++;
                  }
               break;
               
               //ショートオーダー
               case ORDER_TYPE_SELL:
                  if (OrderType() == OP_SELL)
                  {
                     //マジックナンバー取得
                     order[order_count][0] = OrderMagicNumber();

                     //オーダータイプ取得
                     order[order_count][1] = OrderType();

                     //オープンプライス
                     order[order_count][2] = OrderOpenPrice();
               
                     //ストップロス
                     order[order_count][3] = OrderStopLoss();
                  
                     //テイクプロフィット
                     order[order_count][4] = OrderTakeProfit();
                  
                     //ロット数
                     order[order_count][5] = OrderLots();
                  
                     //約定時刻
                     order[order_count][6] = OrderOpenTime();
                  
                     //決済時刻
                     order[order_count][7] = OrderCloseTime();
                  
                     //決済価格
                     order[order_count][8] = OrderClosePrice();
                  
                     //評価損益
                     order[order_count][9] = OrderProfit();
                                    
                     //スワップ損益
                     order[order_count][10] = OrderSwap();
                  
                     //手数料
                     order[order_count][11] = OrderCommission();

                     order_count++;
                  }
               break;
               
               //全オーダー
               case LAST_ORDER:
                  if (OrderType() == OP_BUY || OrderType() == OP_SELL)
                  {
                     //最新オーダー日付取得
                     if(order_open_date < OrderOpenTime())
                     {
                        order_open_date = OrderOpenTime();
                     }
                     else
                     { 
                        continue;
                     }
                     //変数設定
                     order_count = 0;    //最新情報で上書き 
                     
                     //マジックナンバー取得
                     order[order_count][0] = OrderMagicNumber();

                     //オーダータイプ取得
                     order[order_count][1] = OrderType();

                     //オープンプライス
                     order[order_count][2] = OrderOpenPrice();
               
                     //ストップロス
                     order[order_count][3] = OrderStopLoss();
                  
                     //テイクプロフィット
                     order[order_count][4] = OrderTakeProfit();
                  
                     //ロット数
                     order[order_count][5] = OrderLots();
                  
                     //約定時刻
                     order[order_count][6] = OrderOpenTime();
                  
                     //決済時刻
                     order[order_count][7] = OrderCloseTime();
                  
                     //決済価格
                     order[order_count][8] = OrderClosePrice();
                  
                     //評価損益
                     order[order_count][9] = OrderProfit();
                                    
                     //スワップ損益
                     order[order_count][10] = OrderSwap();
                  
                     //手数料
                     order[order_count][11] = OrderCommission();

                     order_count++;
                  }
               break;
                              
               //例外エラー
               default:
                  Print(err_title,OrderType()," 不明なオーダータイプが選択されました。");
                  order_count = R_ERROR;
               break;
            }
         }
      }
      //エラー処理
      else          
      {
         err_code = GetLastError();
         Print(err_title,err_code, " ", ErrorDescription(err_code));
         order_count = R_ERROR;
         break;
      }
   }
   return(order_count);
}
//+------------------------------------------------------------------+
//| 処理名  ：オーダーカウント処理（履歴）                           |
//| 処理詳細：オーダーの総数カウントを行う。                         |
//| 引数    ：&order[][] オーダー情報格納用配列                      |
//|           magic_base マジックナンバーの基準値                    |
//|           type 検索種別                                          |
//|           &exception[][] 除外オーダー                            |
//| 戻り値  ：magic_num 0以上…オーダー総数                          |
//|                     R_ERROR…エラー                              |
//| 備考    ：                                                       |
//+------------------------------------------------------------------+
int OrderCheckHis(double &order[][],int magic_base,double &exception[][],int type)
{
   //変数宣言
   int order_history        = OrdersHistoryTotal();           //オーダーカウント
   int order_count          = 0;                              //検索数
   datetime order_open_date = 0;                              //最新オーダー日付格納用(約定)
   datetime his_order_date  = 0;                              //最新オーダー日付格納用(決済)
   int err_code             = 0;                              //エラーコード取得用
   string err_title         = "[オーダーカウントエラー] ";    //エラーメッセージタイトル

   //オーダーのカウント
   for(int i=order_history-1; i>=0; i--)
   {  
      if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY)==true)
      {
         //マジックナンバーと取引通貨ペアの確認
         if(OrderSymbol() == Symbol() && (OrderMagicNumber() >= magic_base && OrderMagicNumber() < (magic_base + OpenOrderMax)))
         {  
            switch(type)
            {
               case LAST_HIS:
                  if (OrderType() == OP_BUY || OrderType() == OP_SELL)
                  {  
                     //最新オーダー日付取得
                     if(his_order_date <= OrderCloseTime())
                     {
                        //決済時刻が同じ場合
                        if(his_order_date == OrderCloseTime())
                        {
                           //約定日時比較
                           if(order_open_date > OrderOpenTime())
                           {
                              continue;
                           }
                        }
                        order_open_date = OrderOpenTime();
                        his_order_date  = OrderCloseTime();
                     }
                     else
                     { 
                        continue;
                     }

                     //変数設定
                     order_count = 0;    //最新情報で上書き  
                                  
                     //マジックナンバー取得
                     order[order_count][0] = OrderMagicNumber();

                     //オーダータイプ取得
                     order[order_count][1] = OrderType();
               
                     //オープンプライス
                     order[order_count][2] = OrderOpenPrice();
               
                     //ストップロス
                     order[order_count][3] = OrderStopLoss();
                  
                     //テイクプロフィット
                     order[order_count][4] = OrderTakeProfit();
                  
                     //ロット数
                     order[order_count][5] = OrderLots();
                  
                     //約定時刻
                     order[order_count][6] = OrderOpenTime();
                  
                     //決済時刻
                     order[order_count][7] = OrderCloseTime();
                  
                     //決済価格
                     order[order_count][8] = OrderClosePrice();
                  
                     //評価損益
                     order[order_count][9] = OrderProfit();
                                    
                     //スワップ損益
                     order[order_count][10] = OrderSwap();
                  
                     //手数料
                     order[order_count][11] = OrderCommission();

                     order_count++;
                  }
               break;
               case LAST_BUT_ONE_HIS:
                  //指定時刻より一つ前の履歴
                  if (OrderType() == OP_BUY || OrderType() == OP_SELL)
                  {
                     //一つ前の日付取得
                     if(his_order_date < OrderCloseTime())
                     {
                        bool begin_flag = false;
                        for(int x = 0;x<OpenOrderMax;x++)
                        {
                           if((OrderMagicNumber() == exception[x][0]) && (OrderCloseTime() == exception[x][1]))
                           {
                              begin_flag = true;
                              break;
                           }
                        }
                        if (begin_flag == true) continue;
                        his_order_date = OrderCloseTime();
                     }
                     else
                     { 
                        continue;
                     }

                     //変数設定
                     order_count = 0;    //最新情報で上書き  
                               
                     //マジックナンバー取得
                     order[order_count][0] = OrderMagicNumber();

                     //オーダータイプ取得
                     order[order_count][1] = OrderType();
            
                     //オープンプライス
                     order[order_count][2] = OrderOpenPrice();
            
                     //ストップロス
                     order[order_count][3] = OrderStopLoss();
               
                     //テイクプロフィット
                     order[order_count][4] = OrderTakeProfit();
               
                     //ロット数
                     order[order_count][5] = OrderLots();
               
                     //約定時刻
                     order[order_count][6] = OrderOpenTime();
               
                     //決済時刻
                     order[order_count][7] = OrderCloseTime();
               
                     //決済価格
                     order[order_count][8] = OrderClosePrice();
               
                     //評価損益
                     order[order_count][9] = OrderProfit();
                                 
                     //スワップ損益
                     order[order_count][10] = OrderSwap();
               
                     //手数料
                     order[order_count][11] = OrderCommission();

                     order_count++;
                  }
               break;
               default:
                  Print(err_title,OrderType()," 不明なオーダータイプが選択されました。");
                  order_count = R_ERROR;
               break;
            }
         }
      }
      //エラー処理
      else          
      {
         err_code = GetLastError();
         Print(err_title,err_code, " ", ErrorDescription(err_code));
         order_count = R_ERROR;
         break;
      }
   }
   return(order_count);
}
//+------------------------------------------------------------------+
//| 処理名  ：ロット正規化処理                                       |
//| 処理詳細：ロットの正規化を行う。                                 |
//| 引数    ：lots 正規化前ロット数                                  |
//| 戻り値  ：lots 0以上…正規化後ロット数                           |
//|                R_ERROR…エラー                                   |
//| 備考    ：                                                       |
//+------------------------------------------------------------------+
double LotNorm(double lots)
{
   //変数宣言
   double min_lots = MarketInfo(Symbol(), MODE_MINLOT);     //ロット最小値
   double max_lots = MarketInfo(Symbol(), MODE_MAXLOT);     //ロット最大値   
   double lot_step = MarketInfo(Symbol(), MODE_LOTSTEP);    //ロットステップ幅   
   
   //ロット数正規化
   lots = MathRound(lots / lot_step) * lot_step;
   
   //最小・最大値設定
   if(lots < min_lots) lots = min_lots;
   if(lots > max_lots) lots = max_lots; 

   return(lots);
}


//+------------------------------------------------------------------+
//| 処理名  ：オーダー送信処理                                       |
//| 処理詳細：オーダーの送信を行う。                                 |
//| 引数    ：type 取引区分                                          |
//|           lots ロット数                                          |
//|           price 取引提示価格                                     |
//|           slippage 最大スリッページ                              |
//|           stop_loss 損切り価格                                   |
//|           take_profit 利食い価格                                 |
//|           comment オーダーのコメント                             |
//|           magic_num マジックナンバー                             |
//|           mail_flag メールお知らせ機能(true:有効、false:無効)    |
//|           alert_flag アラートお知らせ機能(true:有効、false:無効) |
//|           arrow_color 矢印の色                                   |
//| 戻り値  ：ticket_num 0以上…チケット番号                         |
//|                      R_ERROR…エラー                             |
//|                      R_ALERT…Alert                              |
//| 備考    ：                                                       |
//+------------------------------------------------------------------+
int OrderSendOrg(int type,double lots,double price,int slippage,double stop_loss,
double take_profit,string comment,int magic_num,bool mail_flag,bool alert_flag,color arrow_color)
{
   //変数宣言
   int ticket_num   = R_ERROR;                           //チケット番号
   int err_code     = 0;                                 //エラーコード取得用
   int s_time       = 0;                                 //開始時刻取得用
   string err_title = "[オーダー送信エラー] ";           //エラーメッセージタイトル
   string str_type  = "";                                //オーダー種別

   //開始時刻取得
   s_time = GetTickCount();

   //オーダー送信
   while(true)
   {
      //タイムアウト判定
      if(GetTickCount() - s_time > RETRY_TIMEOUT * 1000)
      {
         Print(err_title,"オーダー送信処理がタイムアウトしました。");
         ticket_num = R_ALERT;
         break;
      }
      if(IsTradeAllowed() == true)
      {       
         //レート更新
         RefreshRates();

         //小数点の正規化
         price       = NormalizeDouble(price,Digits);          //取引価格
         stop_loss   = NormalizeDouble(stop_loss,Digits);      //損切り価格
         take_profit = NormalizeDouble(take_profit,Digits);    //利食い価格

         //オーダー送信
         switch(type)
         {
            case OP_BUY:
               ticket_num = OrderSend(Symbol(),type,lots,Ask,slippage,stop_loss,take_profit,comment,magic_num,0,arrow_color);
            break;
            case OP_SELL:
               ticket_num = OrderSend(Symbol(),type,lots,Bid,slippage,stop_loss,take_profit,comment,magic_num,0,arrow_color);
            break;
            default:
               ticket_num = OrderSend(Symbol(),type,lots,price,slippage,stop_loss,take_profit,comment,magic_num,0,arrow_color);
            break;
         }
         
         //エラーコード取得
         err_code = GetLastError();

         //正常終了
         if(ticket_num >= 0)
         {
            break;
         }
         //異常終了
         else
         {
            //エラー処理
            Print(err_title,err_code, " ", ErrorDescription(err_code));
            ticket_num  = R_ALERT;
            
            //例外エラー
            if(err_code == ERR_INVALID_PRICE) break;
            if(err_code == ERR_INVALID_STOPS) break;
            if(IsTesting()) break;
         }
      }
      Sleep(RETRY_INTERVAL);    //リトライインターバル
   }
   

   return(ticket_num);
}

//+------------------------------------------------------------------+
//| 処理名  ：オーダー変更処理                                       |
//| 処理詳細：オーダーの変更を行う。                                 |
//| 引数    ：stop_loss 損切り価格                                   |
//|           take_profit 利食い価格                                 |
//|           magic_num マジックナンバー                             |
//|           mail_flag メールお知らせ機能(true:有効、false:無効)    |
//|           alert_flag アラートお知らせ機能(true:有効、false:無効) |
//|           arrow_color 矢印の色                                   |
//| 戻り値  ：err_ck_num 0…正常終了                                 |
//|                      R_ERROR…エラー                             |
//|                      R_ALERT…Alert                              |
//|                      R_WARNING…Warning                          |
//| 備考    ：                                                       |
//+------------------------------------------------------------------+
int OrderModifyOrg(double stop_loss,double take_profit,int magic_num,bool mail_flag,bool alert_flag,color arrow_color)
{
   //変数宣言
   int ticket_num   = 0;                          //チケット番号
   int err_code     = 0;                          //エラーコード取得用
   int err_ck_num   = R_ERROR;                    //エラーチェック用
   int s_time       = 0;                          //開始時刻取得用
   string str_type  = "";                         //オーダー種別
   string err_title = "[オーダー変更エラー] ";    //エラーメッセージタイトル

   //引数チェック
   if(stop_loss == 0 && take_profit == 0)
   {
      err_ck_num = R_WARNING;
      return(err_ck_num);
   }

   //チケット番号取得
   for(int i=0; i<OrdersTotal(); i++)
   {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
      {
         if(OrderSymbol() == Symbol() && OrderMagicNumber() == magic_num)
         {
            if(OrderType() == OP_BUY)
            {
               //チケット番号取得
               ticket_num = OrderTicket();
               str_type   = "Buy";     //買いオーダー
               break;
            }
            if(OrderType() == OP_SELL)
            {
               //チケット番号取得
               ticket_num = OrderTicket();
               str_type   = "Sell";    //売りオーダー
               break;
            }
         }
      }
      //エラー処理
      else          
      {
         err_code = GetLastError();
         Print(err_title,err_code, " ", ErrorDescription(err_code));
         err_ck_num  = R_ERROR;
         return(err_ck_num);
      }
   }
   
   //1件も存在しなかった場合
   if(ticket_num == 0)
   {
      err_ck_num = R_WARNING;
      return(err_ck_num);
   }
   
   //現在値取得(パラメータが0の場合のみ)
   if(stop_loss == 0) stop_loss = OrderStopLoss();
   if(take_profit == 0) take_profit = OrderTakeProfit();

   //小数点の正規化
   stop_loss = NormalizeDouble(stop_loss, Digits);
   take_profit = NormalizeDouble(take_profit, Digits);

   //開始時刻取得
   s_time = GetTickCount();

   //オーダー変更
   while(true)
   {
      //タイムアウト判定
      if(GetTickCount() - s_time > RETRY_TIMEOUT * 1000)
      {
         Print(err_title,"オーダー変更処理がタイムアウトしました。");
         err_ck_num = R_ALERT;
         break;
      }
      if(IsTradeAllowed() == true)
      {       
         //レート更新
         RefreshRates();

         //オーダー変更
         bool err_ck_flag = OrderModify(ticket_num,0,stop_loss,take_profit,0,arrow_color);
      
         //エラーコード取得
         err_code = GetLastError();

         //正常終了
         if(err_ck_flag == true)
         {
            err_ck_num = R_SUCCESS;
            break;
         }
         //異常終了
         else
         {
            //エラー処理
            err_ck_num = R_ERROR;
            Print(err_title,err_code, " ", ErrorDescription(err_code));

            //例外エラー
            if(err_code == ERR_NO_RESULT) break;
            if(err_code == ERR_INVALID_STOPS) break;
            if(IsTesting()) break;
         }
      }
      Sleep(RETRY_INTERVAL);    //リトライインターバル
   }
   

   return(err_ck_num);
}
//+------------------------------------------------------------------+
//| 処理名  ：オーダー決済処理                                       |
//| 処理詳細：オーダーの決済を行う。                                 |
//| 引数    ：slippage 最大スリッページ                              |
//|           magic_num マジックナンバー                             |
//|           lots ロット数                                          |
//|           mail_flag メールお知らせ機能(true:有効、false:無効)    |
//|           alert_flag アラートお知らせ機能(true:有効、false:無効) |
//|           arrow_color 矢印の色                                   |
//| 戻り値  ：err_ck_num 0…正常終了                                 |
//|                      R_ERROR…エラー                             |
//|                      R_ALERT…Alert                              |
//|                      R_WARNING…Warning                          |
//| 備考    ：                                                       |
//+------------------------------------------------------------------+
int OrderCloseOrg(int slippage,int magic_num,double lots,bool mail_flag,bool alert_flag,color arrow_color)
{
   //変数宣言
   int ticket_num   = 0;                          //チケット番号
   int err_code     = 0;                          //エラーコード取得用
   int err_ck_num   = R_ERROR;                    //エラーチェック用
   int s_time       = 0;                          //開始時刻取得用
   double op        = 0;                          //プロフィット格納用
   double swap      = 0;                          //スワップ損益格納用  
   double comm      = 0;                          //手数料格納用
   double pl        = 0;                          //合計損益格納用
   datetime sv_time = 0;                          //オーダー決済時刻
   bool err_ck_flag = false;                      //エラーチェックフラグ
   string str_type  = "";                         //オーダー種別
   string err_title = "[オーダー決済エラー] ";    //エラーメッセージタイトル

   //チケット番号取得
   for(int i=0; i<OrdersTotal(); i++)
   {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
      {
         if(OrderSymbol() == Symbol() && OrderMagicNumber() == magic_num)
         {
            if(OrderType() == OP_BUY)
            {
               ticket_num = OrderTicket();
               str_type   = "Buy";
               break;
            }
            if(OrderType() == OP_SELL)
            {
               ticket_num = OrderTicket();
               str_type   = "Sell";
               break;
            }
         }
      }
      //エラー処理
      else          
      {
         err_code = GetLastError();
         Print(err_title,err_code, " ", ErrorDescription(err_code));
         err_ck_num  = R_ERROR;
         return(err_ck_num);
      }
   }
 
   //1件も存在しなかった場合
   if(ticket_num == 0)
   {
      err_ck_num = R_WARNING;
      return(err_ck_num);
   }
   
   //ロット数調整
   if((lots > OrderLots()) || (lots == 0)) lots = OrderLots();
   
   //開始時刻取得
   s_time = GetTickCount();

   //オーダー決済
   while(true)
   {
      //タイムアウト判定
      if(GetTickCount() - s_time > RETRY_TIMEOUT * 1000)
      {
         Print(err_title,"オーダー決済処理がタイムアウトしました。");
         err_ck_num = R_ALERT;
         break;
      }
      if(IsTradeAllowed() == true)
      {       
         //レート更新
         RefreshRates();
         double close_price = NormalizeDouble(OrderClosePrice(),Digits);    //小数点正規化

         //オーダー決済
         err_ck_flag = OrderClose(ticket_num,lots,close_price,slippage,arrow_color);
         
         //エラーコード取得
         err_code = GetLastError();
           
         //正常終了
         if(err_ck_flag == true)
         {
            err_ck_num = R_SUCCESS;
            break;
         }
         //異常終了
         else
         {
            //エラー処理
            err_ck_num = R_ERROR;
            Print(err_title,err_code, " ", ErrorDescription(err_code));
            
            //例外エラー
            if(err_code == ERR_INVALID_PRICE) break;
            if(IsTesting()) break;
         }
      }
      Sleep(RETRY_INTERVAL);    //リトライインターバル
   }
   
   //オーダー履歴検索
   if(OrderSelect(ticket_num,SELECT_BY_TICKET,MODE_HISTORY)==true)
   {
      sv_time = OrderCloseTime();                              //オーダー決済時刻
      op      = NormalizeDouble(OrderProfit(),PLDigits);        //オーダープロフィット
      swap    = NormalizeDouble(OrderSwap(),PLDigits);          //スワップ損益
      comm    = NormalizeDouble(OrderCommission(),PLDigits);    //手数料
      pl      = op + swap + comm;                              //合計損益
   }
   //エラー処理
   else Print(err_title,"オーダー決済時刻の取得に失敗しました。");
   

   return(err_ck_num);
}
//+------------------------------------------------------------------+