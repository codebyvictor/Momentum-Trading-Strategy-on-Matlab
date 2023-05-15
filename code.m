
% MOMENTUM ASSIGNMENT
% 1) Clear windows and import data from file
clear
clc
crsp = readtable('crsp20042008 - Copy.csv');

% 2) Add datenum, year, and month column to the crsp data

crsp.datenum = datenum(num2str(crsp.DateOfObservation),"yyyymmdd" );
crsp.year = year(crsp.datenum);
crsp.month = month(crsp.datenum);

% 3) Function for momentum is at the end of the script

% 4) Calculate Momentum
% Based on the function written in the getMomentum file, add a column that calculates momentum for each stock and month
tStart=tic;
tic
for i = 1:size(crsp,1);
    %next if statement is the teacher's code to see the progression of the data when running
    if ~mod(i,10);
        completion=i/size(crsp,1);
        fprintf("Getting Signals - %2.2f %% \r", completion*100);
    end
    crsp.momentum(i) = getMomentum(crsp.PERMNO(i), crsp.year(i), crsp.month(i), crsp);

end
toc(tStart);

% 5) Calculate Momentum Returns
date = unique(crsp.DateOfObservation);
momentum = table(date);

momentum.datenum = datenum(num2str(momentum.date),"yyyymmdd" );
momentum.year = year(momentum.datenum);
momentum.month = month(momentum.datenum);

momentum.m10=NaN(size(momentum.date));
momentum.m1=NaN(size(momentum.date));
momentum.m=NaN(size(momentum.date));

for i = 1:size(momentum,1)
    thisYear=momentum.year(i);
    thisMonth=momentum.month(i);
    
    Investible = crsp.year == thisYear & crsp.month == thisMonth & ~isnan(crsp.Returns);
    
    thisMomentum = crsp.momentum(Investible);
    
    momentumQuantiles = quantile(thisMomentum, 9);
    
    isWinner = crsp.momentum>=momentumQuantiles(9);
    isWinner = isWinner & Investible;
    
    isLoser = crsp.momentum<=momentumQuantiles(1);
    isLoser = isLoser & Investible;
    
    momentum.m1(i) = mean(crsp.Returns(isLoser));
    momentum.m10(i) = mean(crsp.Returns(isWinner));
end

momentum.m = momentum.m10 - momentum.m1;

% 6) Calculate Cumulative Returns
momentum = momentum(13:end,:);

cumulativeReturn = momentum(:,5:end);
cumulativeReturn{1,:}=0;

cumulativeReturn{:,:} = 1+cumulativeReturn{:,:};
cumulativeReturn{:,:} = cumprod(cumulativeReturn{:,:});

% plot the winners, losers, and the strategy's cumulative return
plot(momentum.datenum(1:end),cumulativeReturn{1:end,1},...
     momentum.datenum(1:end),cumulativeReturn{1:end,2},...
     momentum.datenum(1:end),cumulativeReturn{1:end,3})
datetick('x','yyyy mmm')
legend("winners","losers","long short strategy")
grid on;


% 3) Function for Momentum
function [y] = getMomentum(thisPermno, thisYear, thisMonth, crsp)
    
    EndMonth = thisMonth-1;
    EndYear = thisYear;
    if EndMonth ==0
        EndMonth = 12;
        EndYear = thisYear-1;
    end
    endPrice = crsp.adjustedPrice(crsp.year==EndYear & crsp.month==EndMonth & crsp.PERMNO ==thisPermno);

    StartMonth = thisMonth;
    StartYear = thisYear - 1;
    startPrice = crsp.adjustedPrice(crsp.year == StartYear & crsp.month == StartMonth & crsp.PERMNO ==thisPermno);

    if isempty(startPrice) || isempty(endPrice)
        y=NaN ; 
    else 
        y = (endPrice/startPrice)-1 ; 
    end
end