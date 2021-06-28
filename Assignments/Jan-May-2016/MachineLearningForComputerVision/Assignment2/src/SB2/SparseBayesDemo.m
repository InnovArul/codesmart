clear all
close all
clc
%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% --- VALIDATE INPUT ARGUMENTS ---
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

load('../data/Problem-5/data.mat');
global REPORT_PICS_FOLDER;
REPORT_PICS_FOLDER = '../report/pics/task5';


N = size(trainX,1);

likelihood_ = 'Gaussian';
dimension = size(trainX,2);

% --- SET UP PARAMETERS ---
% Set up default for "noiseToSignal" variable.
% For ease of use, we'll just ignore it in the case of a non-Gaussian
% likelihood model.
%
if ~exist('noiseToSignal','var')
  noiseToSignal	= 0.2;
end

iterations	= 500;
basisWidth	= 0.08;	% lambda
% Heuristically adjust basis width to account for 
% distance scaling with dimension.
lambdas = linspace(0.0001, 1, 5);
for lambdaIndex = 1:5
    lambda = lambdas(lambdaIndex);
    basisWidth	= lambda;%asisWidth^(1/dimension); % lambda

    % Now define the basis or design matrix 
    C = trainX; % Locate basis functions at data points
    % Compute ("Gaussian") basis (design) matrix
    BASIS	= exp(-SB2_distSquared(trainX,C)/(basisWidth));
    % 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % 
    % --- SPARSE BAYES INFERENCE SECTION ---
    % 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Set up the options:
    % 
    % - we set the diagnostics level to 2 (reasonable)
    % - we will monitor the progress every 10 iterations
    % 
    OPTIONS		= SB2_UserOptions('iterations',iterations,...
                                  'diagnosticLevel', 2,...
                                  'monitor', 10);
    %
    % Set initial parameter values:
    % 
    % - this specification of the initial noise standard deviation is not
    % necessary, but included here for illustration. If omitted, SPARSEBAYES
    % will call SB2_PARAMETERSETTINGS itself to obtain an appropriate default
    % for the noise (and other SETTINGS fields).
    % 
    SETTINGS = SB2_ParameterSettings('NoiseStd',0.1);
    %
    % Now run the main SPARSEBAYES function
    %
    LIKELIHOOD	= SB2_Likelihoods(likelihood_);
    [PARAMETER, HYPERPARAMETER, DIAGNOSTIC] = ...
        SparseBayes(likelihood_, BASIS, trainY, OPTIONS, SETTINGS)
    %
    % Manipulate the returned weights for convenience later
    %
    M = size(BASIS,2);
    w_infer						= zeros(M,1);
    w_infer(PARAMETER.Relevant)	= PARAMETER.Value;
    %
    % Compute the inferred prediction function
    % 
    y				= BASIS*w_infer;
    %
    % Convert the output according to the likelihood (i.e. apply link function)
    % 
    y_l = y;

    testBASIS	= exp(-SB2_distSquared(testX,C)/(basisWidth));
    testPredicted				= testBASIS*w_infer;
        
    % train MSE 
    trainError(lambdaIndex, 1) = lambda;
    trainError(lambdaIndex, 2) = sum((y-trainY).^2)/N;
    trainError(lambdaIndex, 3) = sum((testPredicted-testY).^2)/size(testY, 1);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % 
    % --- PLOT THE RESULTS ---
    % 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Compare the data and the predictive model (post link-function)
    % 
    figure(1)
    hold on
    TITLE_SIZE = 12;
    plot(trainX,trainY,'k.','linewidth',1);
    grid on  
    plot(trainX,y_l,'r-','linewidth',2);
    plot(trainX(PARAMETER.Relevant),trainY(PARAMETER.Relevant),'b*','MarkerSize',10)
    legend('given train data','predicted model','Relevent data');
    hold off

    title('Data and predictor','FontSize',TITLE_SIZE)
    saveas(gcf, fullfile(REPORT_PICS_FOLDER, strcat('rvc_predicted_lambda=', num2str(lambda), '.png')));
    close all;
    
    %
    % Show the inferred weights
    % 
    figure(2)
    h	= stem(w_infer,'filled');
    set(h,'Markersize',3,'Color','r')
    set(gca,'Xlim',[0 N+1])
    t_	= sprintf('Inferred weights (%d)', length(PARAMETER.Relevant));
    title(t_,'FontSize',TITLE_SIZE)
    saveas(gcf, fullfile(REPORT_PICS_FOLDER, strcat('rvc_weights_lambda=', num2str(lambda), '.png')));
    close all;

    %plot test data
    figure(1)
    hold on
    TITLE_SIZE = 12;
    plot(testX,testY,'k.','linewidth',1);
    grid on  
    plot(testX,testPredicted,'r-','linewidth',2);
    plot(trainX(PARAMETER.Relevant),trainY(PARAMETER.Relevant),'b*','MarkerSize',10)
    legend('given test data','predicted model','Relevent data');
    hold off

    title('Data and predictor','FontSize',TITLE_SIZE)
    saveas(gcf, fullfile(REPORT_PICS_FOLDER, strcat('rvc_test_predicted_lambda=', num2str(lambda), '.png')));
    close all;

end

plot(trainError(:, 1), trainError(:, 2), '-bo', 'LineWidth', 1.5, 'MarkerFaceColor', 'r');
hold on;
plot(trainError(:, 1), trainError(:, 3), '-go', 'LineWidth', 1.5, 'MarkerFaceColor', 'r');

title('\lambda vs. training and test error');
xlabel('\lambda');
ylabel('Mean squared error');
legend('training error', 'test error');
legend show;
saveas(gcf, fullfile(REPORT_PICS_FOLDER, strcat('rvr_train and test error.png')));
close all;

disp(trainError);