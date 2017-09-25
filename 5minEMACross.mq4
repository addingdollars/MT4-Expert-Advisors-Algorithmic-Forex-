//+------------------------------------------------------------------+
//|                                                 5minEMACross.mq4 |
//|                                    Copyright 2017, Addingdollars |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, Addingdollars"
#property link      ""
#property version   "1.00"
#property strict

//not very succesful even when optimizing the parameters
//most likely cause: 2 pip spread is too much for scalping profits, espcially if waiting for candle close instead of doing it based on ticks

//open of new bar check toggle
extern bool EnterOpenBar = true;

//TP, SL, and Lot Size
input double TakeProfit = 50;
input double StopLoss = 50;
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
   //check if there is no trade currently open
   if(OrdersTotal() < 1)
      {
       //check if a new 5 min candle just opened
       bool OpenBar = true;
       
       //"EnterOpenBar turns on or off the completion of a bar close check
       if(EnterOpenBar)
         {
          if(iVolume(NULL, PERIOD_M5, 0) > 1)
            {
             OpenBar = false;
            }
         }
       
       if(OpenBar)
         {
          
          //side note, emaCurrent may not be the right value to use but instead I should be using the ema corresponding to each candle
          double emaCurrent, candle2Back, candle1Back;
          
          emaCurrent = iMA(NULL, PERIOD_M5,emaVal, 0, MODE_EMA, PRICE_CLOSE, 0);
          candle2Back = iClose(NULL, PERIOD_M5, 2);
          candle1Back = iClose(NULL, PERIOD_M5, 1);
          
             //check in 2 candle back is > than ema, and 1 candle back is < ema
             if(candle2Back > emaCurrent && candle1Back < emaCurrent)
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
               //end brack for BUY check
               }
               
             //check if candle has crossed abovet the EMA line
             if(candle2Back < emaCurrent && candle1Back > emaCurrent)
               {
                //place a SELL order
                int ticket = OrderSend(Symbol(), OP_SELL, LotSize, Bid, 2, Ask+StopLoss*Point, Bid+TakeProfit*Point, "SUCCESS", 12345);
                
                //only for manually setting take profit and stoploss
                //int ticket = OrderSend(Symbol(), OP_SELL, LotSize, Bid, 2, 0, 0, "SUCCESS", 12345);
                //OrderSelect(ticket, SELECT_BY_TICKET);
                // bool res = OrderModify(OrderTicket(), OrderOpenPrice(), Ask+StopLoss*Point, Bid-TakeProfit*Point,0, Blue);
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
         //OpenBar ending bracket 
         }
       
       //OrdersTotal ending bracket
       }
  //OnTick ending bracket 
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
