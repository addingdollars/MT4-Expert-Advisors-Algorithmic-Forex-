//+------------------------------------------------------------------+
//|                                                DailyEmaCross.mq4 |
//|                                    Copyright 2017, Addingdollars |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Addingdollars"
#property version   "1.00"
#property strict

//open of new bar check toggle
extern bool EnterOpenBar = true;

//TP, SL, and Lot Size
input double TakeProfit = 1000;
input double StopLoss = 1000;
input double LotSize = 0.1;

//important sample price info
//Ex ASK: 1.15127, POINT:0.00001, DIGITS: 5, SPREAD: 67

//indicator variable
input double emaVal = 8.0;


//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   
  }

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
//check if there is no trade currently open
   if(OrdersTotal() < 1)
      {
       //check if a new DAILY candle just opened
       bool OpenBar = true;
       
       //"EnterOpenBar turns on or off the completion of a bar close check
       if(EnterOpenBar)
         {
          if(iVolume(NULL, PERIOD_D1, 0) > 1)
            {
             OpenBar = false;
            }
         }
         
         //if true then a new DAILY candle has just opened
         if(OpenBar)
            {
             double candle2Back, candle1Back, emaCurrent;
             
             //calculate closing price of 1 and 2 candles back, and current EMA value
             candle2Back = iClose(NULL, PERIOD_D1, 2);
             candle1Back = iClose(NULL, PERIOD_D1, 1);
             emaCurrent = iMA(NULL, PERIOD_D1, emaVal, 0, MODE_EMA, PRICE_CLOSE, 0);
             
             //check if candle 2 back is less than ema and candle 1 back has crossed up the ema
             if(candle2Back < emaCurrent && candle1Back > emaCurrent)
               {
                //place a BUY order
                int ticket = OrderSend(Symbol(), OP_BUY, LotSize, Ask, 2, Bid-StopLoss*Point, Ask+TakeProfit*Point, "SUCCESS", 12345);
                if(ticket < 0)
                  {
                   Print("OrderSend failed with error#", GetLastError());
                  }
                else
                  {
                   Print("OrderSend placed successfully");
                  }
               //end bracket for BUY check
               }
               
               //check if candle 2 back is greater than ema and candle 1 back has crossed down the ema
             if(candle2Back > emaCurrent && candle1Back < emaCurrent)
               {
                //place a SELL order
                int ticket = OrderSend(Symbol(), OP_SELL, LotSize, Bid, 2, Ask+StopLoss*Point, Bid-TakeProfit*Point, "SUCCESS", 12346);
                //int ticket = OrderSend(Symbol(), OP_SELL, LotSize, Bid, 2, 0, 0, "SUCCESS", 12346);
                
                //manually  modifying stoploss and takeprofit for SELL Orders, only if needed
                //OrderSelect(ticket, SELECT_BY_TICKET);
                //bool res = OrderModify(OrderTicket(), OrderOpenPrice(), Ask+StopLoss*Point, Bid-TakeProfit*Point,0, Blue);
                //if(res){Print("TRUE");}
                
                if(ticket < 0)
                  {
                   Print("OrderSend failed with error#", GetLastError());
                  }
                else
                  {
                   Print("OrderSend placed successfully");
                  }
               //end bracket for SELL check
               }
             
            //ending bracket of OpenBar check
            }
         
       //OrdersTotal() ending bracket
      }

  //last bracket of OnTick function
  }
//+------------------------------------------------------------------+
//| Tester function                                                  |
//+------------------------------------------------------------------+
double OnTester()
  {
//---
   double ret=0.0;
//---

//---
   return(ret);
  }
//+------------------------------------------------------------------+
