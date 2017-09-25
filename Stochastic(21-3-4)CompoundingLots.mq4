//+------------------------------------------------------------------+
//|                            Stochastic(21-3-4)CompoundingLots.mq4 |
//|                                     Copyright 2017 Addingdollars |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Addingdollars"
#property version   "1.00"
#property strict

//this is the stochastic 4 hour and 1 hour check trade. With a scaled lot size based on risk %

//open of new bar check
extern bool EnterOpenBar = true;

//TP, SL, and Lot size
input double TakeProfit =  100;
input double StopLoss = 100;
input double risk = 0.02;

//input double LotSize = 0.1;

//important price info
//Ex ASK: 1.15127, POINT:0.00001, DIGITS: 5, SPREAD: 67

//input for iStochastic parameters
input int k = 21;
input int d = 3;
input int slow = 4;

//indicator calculations
double FourhrSlow,OnehrFastPrevious,OnehrFastCurrent;

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
         //check if the 4 hour slower line Stochastic(21,3,4) line is above 80%
         FourhrSlow = iStochastic(NULL,PERIOD_H4,k,d,slow,MODE_SMA,1,MODE_SIGNAL,0);
         
         //Compounding Lot size calculated by RISK %
         double actualLots;
         actualLots = (((risk*AccountBalance())/(StopLoss/10))*10000)/100000;

         if(FourhrSlow > 80.0 || FourhrSlow < 20.0)
           {
            //check if 1 hour faster line Stochastic(21,3,4) crossing the 80% line (CURRENT 2 CANDLE SHIFT BACK)
            OnehrFastPrevious = iStochastic(NULL,PERIOD_H1,k,d,slow,MODE_SMA,1,MODE_MAIN, 2);
            OnehrFastCurrent = iStochastic(NULL,PERIOD_H1,k,d,slow,MODE_SMA,1,MODE_MAIN, 1);
            
            //sell order check
            if(OnehrFastPrevious > 80.0 && OnehrFastCurrent < 80.0)
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
            if(OnehrFastPrevious < 20.0 && OnehrFastCurrent > 20.0)
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

            //Print(StringConcatenate("Previous :",OnehrFastPrevious,"------Current :",OnehrFastCurrent));
           }
        }
     }
     
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
