function [ ] = BetaMLE( )
%BETAMLE Summary of this function goes here
%   Detailed explanation goes here

% read the dataset
X = load('Continuous.txt');
N = size(X,1);

% estimate beta distribution params
[alpha, beta] = estimateBetaParams(X, 'MOM'); % 'MLE' or 'MOM' 

%for each bin count, calculate the chi-square value
for BINS = 26 : 4 : 100
    % get the observation numbers and means values of the bins in the
    % histograms
    [observation_numbers, bin_means]=hist(X, BINS);
    hist(X, BINS);
    
    %data means sequence
    binSequence = [0 bin_means];

    % determine cumulative pdf
    cumulative_pdf = betacdf(binSequence, alpha, beta);

    %calculate expected number of points inside each bin
    for i=1:BINS
        expectedCount(1,i)=(cumulative_pdf(1,i+1) - cumulative_pdf(1,i))* N;
    end

    % chi-square value calculation
    chiSquareStatistic = sum((expectedCount - observation_numbers).^2 ./ expectedCount);
    
    figure;
    bar(expectedCount);
    hold on;
    scatter(1:BINS, observation_numbers, 50, 'd', 'MarkerEdgeColor',[0 .5 .5],...
                'MarkerFaceColor', 'red',...
                'LineWidth',1.5);
    chiSquareTableStatistic = chi2inv(0.95, BINS - 1);
    
    nullHypStatus = 'FAILED';
    
    %decision on null hypothesis
    if(chiSquareStatistic < chiSquareTableStatistic)
        nullHypStatus = 'PASSED';
    end
        
    disp(strcat('Tesing Beta distribution: Number of Bins=', num2str(BINS)));
    disp(strcat('calculated chi-square statistic : ', num2str(chiSquareStatistic), ... 
        ', chi-square statistic from table:', num2str(chiSquareTableStatistic)));
    disp(strcat('Null hypothesis - ', nullHypStatus));
    
    title({strcat('Tesing Beta distribution (\alpha= ', num2str(alpha), ', \beta= ', num2str(beta), '): Number of Bins=', num2str(BINS)), strcat('calculated chi-square statistic : ', num2str(chiSquareStatistic), ... 
        ', chi-square statistic from table:', num2str(chiSquareTableStatistic)), ...
        strcat('Null hypothesis - ', nullHypStatus)});
    
    legend('Expected count', 'Observed count');
    legend show;
            
    close all;
end
end

