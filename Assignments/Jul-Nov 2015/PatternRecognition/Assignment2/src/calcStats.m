function [] = calcStats( actual, predicted )
%CALCSTATS Summary of this function goes here
%   Detailed explanation goes here

%confusion = plotconfusion(actual, predicted)

%calculate accuracy (ACC) = (TP + TN) / (TP + TN + FP + FN)
%calculate F1 score = 2TP / (2TP + FP + FN)

%calculate Precision (positive predictive value (PPV)) = TP / (TP + FP)
%negative predictive value (NPV) = TN / (TN + FN)
%false discovery rate = FP / (TP + FP)
% false omission rate = FN / (FN + TN)

% true positive rate / sensitivity / recall = TP / (TP + FN)
% true negative rate = TN / (TN + FP)
% false positive rate = FP / (FP + TN)
% false negative rate = FN / (FN + TP)

global titleString;

confusionMatrix = confusionmat(actual, predicted);

numOfClasses = size(confusionMatrix,1);
totalSamples = sum(confusionMatrix(:));

accuracy = trace(confusionMatrix)/(totalSamples);

[TP,TN,FP,FN,sensitivity,specificity,precision,f_score] = deal(zeros(numOfClasses,1));

% for each class, note down the TP, TN, FP, FN counts
for class = 1:numOfClasses
   TP(class) = confusionMatrix(class,class);
   
   %calculation of TN is tricky. i.e., samples other than class's row and
   %class's column are TNs
   tempMat = confusionMatrix;
   tempMat(:,class) = []; % remove column
   tempMat(class,:) = []; % remove row
   TN(class) = sum(sum(tempMat));
   
   % FP will be in the column of class
   FP(class) = sum(confusionMatrix(:,class))-TP(class);
   
   % FN will be in the row of class
   FN(class) = sum(confusionMatrix(class,:))-TP(class);
end

details = [];

% for each class, calculate specificity, sensitivity, precision, f1_score
for class = 1:numOfClasses
    sensitivity(class) = TP(class) / (TP(class) + FN(class));
    specificity(class) = TN(class) / (FP(class) + TN(class));
    precision(class) = TP(class) / (TP(class) + FP(class));
    f_score(class) = 2*TP(class)/(2*TP(class) + FP(class) + FN(class));
    details(:, end + 1) = [sensitivity(class); specificity(class); precision(class); f_score(class);];
end

%give titles, row names to confusion matrix & details
disp(' ')
printmat(confusionMatrix, strcat('Confusion matrix (Trgt = Target, pred = Predicted) (', titleString{:}, ')'), 'Class1_Trgt Class2_Trgt Class3_Trgt', 'Class1_pred Class2_pred Class3_pred');
printmat(details, strcat('performance measures (', titleString{:}, ')'), 'Sensitivity Specificity Precision F1_Score', 'Class1 Class2 Class3');
disp(strcat('Overall accuracy : ', num2str(accuracy)));

end

