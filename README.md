# Momentum Trading Strategy on Matlab

The goal of this project is to calculate returns on a long-short momentum portfolio, using monthly data retrieved from the CRSP database. Momentum is a trading strategy in which investors buy securities that are rising and sell them when they look to have peaked. The goal is to work with volatility by finding buying opportunities in short-term uptrends and then sell when the securities start to lose momentum. In this case, the loser portfolio is defined as securities where the yearly return is less than the 1st quantile and the winner portfolio is the one where the yearly return is larger than the 9th momentum quantile.

The strategy works in a 3 major steps: 
- Build a function to calculate the returns of each security over the span of 4 years.
- For each trading month, define the winners portfolio to long and the losers portfolio to short based on performance quantiles.
- Plot the results and compare it to a buy & hold strategy of winners and losers portfolios.

Results: The long-short strategy worked well for the dataset between 2004 and 2008. Over 4 years, the cumulative return of the long-short strategy yielded a 2x return (100%) compared to a -60% for the losers stocks and -3% for the winners stocks. 

However, It's important to understand that momentum trading involves a great amount of risk. There is no guarantee that buying pressures will continue to push the price higher. News development may impact investor market perception and lead to widespread selling. 



<p align="center">
  <img width="460" height="300" src="https://github.com/codebyvictor/Momentum-Trading-Strategy-on-Matlab/blob/d68ba2421dbd53aa8a2139763ead09243dd0e30a/strat-performance-dataset.png">
</p>
