//+------------------------------------------------------------------+
//|                                                2EMACrossover.mq4 |
//|                                    Copyright 2017, Addingdollars |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, Addingdollars"
#property link      ""
#property version   "1.00"
#property strict

//STARTING WITH A 1 HOUR EMA CROSS*********

//open of new bar check
extern bool EnterOpenBar = true;

//TP, SL, and Lot size
//10 pips
input double TakeProfit =  100; 
input double StopLoss = 100;
input double risk = 0.02;

//input double LotSize = 0.1;

//important price info
//Ex ASK: 1.15127, POINT:0.00001, DIGITS: 5, SPREAD: 67

//input for EMA values
input int ema1 = 8;
input int ema2 = 20;

//indicator calculations
double ema1Oneback, ema1Twoback, ema2Oneback, ema2Twoback;

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
//check if there is a trade currently open
   if(OrdersTotal()> 0)
     {

     }

   else
     {
      //check if a new candle has just opened on the 1 hour time frame
      bool OpenBar = true;

      //"EnterOpenBar turns on or off the completion of a bar check
      if(EnterOpenBar)
        {
         if(iVolume(NULL,PERIOD_H1,0)>1)
           {
            OpenBar = false;
           }
        }

      //if true then a new bar has opened
      if(OpenBar)
        {
         //calculate and assign all EMA values
         ema1Oneback = iMA(NULL, PERIOD_H1,ema1, 0, MODE_EMA, PRICE_CLOSE, 1);
         ema1Twoback = iMA(NULL, PERIOD_H1,ema1, 0, MODE_EMA, PRICE_CLOSE, 2);
         
         ema2Oneback = iMA(NULL, PERIOD_H1,ema2, 0, MODE_EMA, PRICE_CLOSE, 1);
         ema2Twoback = iMA(NULL, PERIOD_H1,ema2, 0, MODE_EMA, PRICE_CLOSE, 2);

         //Compounding Lot size calculated by RISK %
         double actualLots;
         actualLots = (((risk*AccountBalance())/(StopLoss/10))*10000)/100000;

         //sell order check
         if(ema1Twoback > ema2Twoback && ema1Oneback < ema2Oneback)
           {
             //place a sell trade at market price
             //NOTE: slippage is in points (0.00001)
             //int ticket = OrderSend(Symbol(), OP_SELL, LotSize, Bid, 2, Ask+StopLoss*Point, Bid-TakeProfit*Point, "SUCCESS", 12345);
             int ticket = OrderSend(Symbol(), OP_SELL, actualLots, Bid, 2, Ask+StopLoss*Point, Bid-TakeProfit*Point, "SUCCESS", 12345);
             if(ticket < 0)
               {
                Print("OrderSend failed with error#", GetLastError());
               }
             else
               {
                Print("OrderSend placed successfully");
               }
            } 
               
         //buy order check  
         if(ema1Twoback < ema2Twoback && ema1Oneback > ema2Oneback)
            {
             //place a sell trade at market price
             //NOTE: slippage is in points (0.00001)
             //int ticket = OrderSend(Symbol(), OP_BUY, LotSize, Ask, 2, Bid-StopLoss*Point, Ask+TakeProfit*Point, "SUCCESS", 12345);
             int ticket = OrderSend(Symbol(), OP_BUY, actualLots, Ask, 2, Bid-StopLoss*Point, Ask+TakeProfit*Point, "SUCCESS", 12345);
             if(ticket < 0)
               {
                Print("OrderSend failed with error#", GetLastError());
               }
             else
               {
                Print("OrderSend placed successfully");
               } 
            }

        }//closing brace of OpenBar
     }//closing brace of ELSE statement
     
  //OnTick closing bracket
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
