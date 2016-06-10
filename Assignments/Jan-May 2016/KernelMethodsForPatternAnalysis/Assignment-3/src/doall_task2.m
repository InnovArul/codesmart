function [  ] = doall_task2( dataType )
%DOALL Summary of this function goes here
%   Detailed explanation goes here

addpath('./libsvm/matlab/');
global REPORTPICSFOLDER;
REPORTPICSFOLDER = '../report/pics';
Output.level(Output.DISP_VERBOSE)
Output.place(strcat('task2_', num2str(dataType), '.log'),true);

[trainData, validationData, testData] = loadData(dataType);

options = '-s 2 -t 2 -h 0 -e 0.00001 ';
allModels = {};
accuracies = [];

count = 1;
for gamma = 0.001 : 0.05: 1
    currentOptions = strcat(options, {' -g '}, num2str(gamma));
    for nu = 0.05 : 0.05: 0.25
    %for nu = 0.1 : 0.05: 0.2        
        currentModel = containers.Map;
        
        currentOptions1 = strcat(currentOptions, {' -n '}, num2str(nu));
        Output.DEBUG(currentOptions1{:}); disp(currentOptions1{:});
        
        % train the multi-class SVM
        model = svmtrain(trainData(:, end), trainData(:, 1:end-1), currentOptions1{:});
        [predictedLabels, currentAccuracy, ~] = svmpredict(double(validationData(:, end)), validationData(:, 1:end-1), model);
        accuracies(count) = calcStats(double(validationData(:, end)), predictedLabels, 2, 'validation Data');
        
        %store the model
        currentModel('nu') = nu;
        currentModel('gamma') = gamma;
        currentModel('model') = model;
        currentModel('accuracy') = accuracies(count);
        allModels{count} = currentModel;
        count = count + 1;
    end
end

%choose best model based on validation accuracy
bestModel = getBestModel(allModels);
model = bestModel('model');
gamma = bestModel('gamma');
nu = bestModel('nu');
disp(values(bestModel));

% test the testdata
[testlabels, accuracy, ~] = svmpredict(double(testData(:, end)), testData(:, 1:end-1), model);
calcStats(double(testData(:, end)), testlabels, 2, 'test data');


% for 2D data, draw decision boundary
if(size(trainData, 2) == 3) 
    minData = min([trainData; validationData; testData]);
    maxData = max([trainData; validationData; testData]);

    x = linspace(minData(1), maxData(1), 200);
    y = linspace(minData(2), maxData(2), 200);
    data = combvec(x, y)';
    [labels, accuracy, ~] = svmpredict(ones(size(data, 1), 1), data, model);

    color = repmat([0.3 0.8 0], sum(labels==1), 1);
    % plot the decision boundary
    fig = figure;
    scatter(data(labels==1, 1), data(labels==1, 2), 5, color, 'filled')
    
    color = repmat([0.5 0.5 1], sum(labels==-1), 1);
    hold on;
    scatter(data(labels==-1, 1), data(labels==-1, 2), 5, color, 'filled')

    hold on    
    % plot the data
    color = repmat([0 0.3 0], sum(testData(:, end)==1), 1);
    scatter(testData(testData(:, end)==1, 1), testData(testData(:, end)==1, 2), 15, color, 'filled');
    
    hold on;
    color = repmat([1 1 0], sum(testData(:, end)==-1), 1);
    scatter(testData(testData(:, end)==-1, 1), testData(testData(:, end)==-1, 2), 15, color, 'filled');    
    
    hold on
    
    % mark the bounded support vectors
    scatter(model.SVs(:, 1), model.SVs(:, 2), 20, 'green', 'filled', 'MarkerEdgeColor',[0 0 1],...
        'MarkerFaceColor',[0 .8 1],...
        'LineWidth',1.5);    

    %mark the unbounded support vectors
    uSVs = model.SVs(model.sv_coef ~= 1, :);
    scatter(uSVs(:, 1), uSVs(:, 2), 20, 'red', 'filled', 'MarkerEdgeColor',[0 0 1],...
        'MarkerFaceColor',[1 0 0],...
        'LineWidth',1.5); 
    
    legend('Normal region', 'Abnormal region', 'Normal data points', 'Abnormal data points', 'bounded SVs', 'unbounded SVs');
    legend show;

    saveas(fig, fullfile(REPORTPICSFOLDER, strcat('task2_decisionregion_g=', num2str(gamma), '_n=', num2str(nu), '.jpg')));
    close(fig);
end

end

