# MT4-Expert-Advisors-Algorithmic-Forex-
Expert Advisors created in MT4, which are algorithmic strategies for trading Forex

I have coded a few Expert Advisors in MetaTrader 4 (MT4). I created them to test out various Forex trading strategies. The Take Profit, Stoploss, and some indicator parameters are not exact, and are just initial values that are used to run the algorithm and then optimize in MT4's backtester functionality. 

Below are the Expert Advisors (filenames) that I have coded with descriptions of the trading strategy being used. I have backtested these strategies and may post backtesting results and optimized parameters later on.

## MT4 Expert Advisors

###### Stochastic(21-3-4).mq4
Strategy: Check to see if Stochastic(21, 3, 4) indicator is above 80% on a 4 hour chart. If it is above 80% then check the Stochastic(21, 3, 4) on a 1 hour chart. If the 1 hour chart shows the Stochastic(21, 3, 4) above 80%, then wait till the faster Stochastic line crosses below 80% and enter into a SELL trade, based on the 1 hour chart. The opposite is applied for BUY trades using the 20% line.

###### Stochastic(21-3-4)CompoundingLots.mq4
Strategy: This is the exact same strategy as the one above, except it uses a compounding lot size based on a fixed risk percentage. So as the account size grows, more lots are used on each trade and both the profit and loss on each trade increase, however the risk percentage stays the same.

###### DailyEmaCross.mq4
Strategy: On Daily chart, if a candle closes below the 8 Exponential Moving Average (EMA) indicator and then the next candle close above the 8 EMA, the code enters into a BUY trade. If a candle closes above the 8 EMA and the next candle closes below the 8 EMA, the code enters into a SELL trade.

###### 5minEMACross.mq4
Strategy: On 5 minute chart, if a candle closes below the 8 Exponential Moving Average (EMA) indicator and then the next candle close above the 8 EMA, the code enters into a SELL trade, hoping for a quick pullback in price. If a candle closes above the 8 EMA and the next candle closes below the 8 EMA, the code enters into a BUY trade, hoping for a quick pullback in price.

###### 2EMACrossover.mq4
Strategy: This strategy looks the crosses of two Exponential Moving Averages (EMA). On a 1 hour chart, if the faster EMA crosses above the slower EMA then the code enters into a BUY trade. If the faster EMA crosses below the slower EMA then the code enters into a SELL trade.


In all the strategies above, only 1 trade is open at a time. A new trade does not open unless there are no other trades open.

Feel free to message me with questions or suggestions in regards to the Expert Advisors above. I would love to discuss new Expert Advisors and Strategies!


