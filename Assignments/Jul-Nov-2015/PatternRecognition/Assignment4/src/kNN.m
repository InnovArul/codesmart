function [likelihoods] = kNN(trainingFeatures, trainClasses, testingFeatures, K, numClasses)
%KNN 

likelihoods = [];
disp(strcat('total test features=', num2str(size(testingFeatures, 1)), ', train features =', ...
        num2str(size(trainingFeatures, 1))));

tic
for testIndex = 1 : size(testingFeatures, 1)
    difference = trainingFeatures - repmat(testingFeatures(testIndex, :), size(trainingFeatures, 1), 1);
    euclidean = sum(difference .* difference, 2);
    [~, sortOrder] = sort(euclidean, 1);

    %select first K labels
    classLabelsNearby = trainClasses(sortOrder(1:K));
    
    if(mod(testIndex, 500) == 0)
       disp(strcat('test index-', num2str(testIndex)));
       toc 
    end
    
    for classIndex = 1:numClasses
       likelihoods(testIndex, classIndex) = sum(classLabelsNearby==classIndex) / size(classLabelsNearby, 1); 
    end
end

end

