function [ classAssignments] = parzenWindowClassify( k_means_mu_k, testInputs, h, numClasses )
%parzenWindowClassify classify the test input based on training examples

k_means_classes = k_means_mu_k(:, end);
k_means_mus = k_means_mu_k(:, 1:end - 1);
total_mus = size(k_means_mus, 1);


testInputFlattened = collectAllDataFromStruct(testInputs);
totalTestInputs = size(testInputFlattened, 1);
distances = zeros(totalTestInputs, total_mus);

for mu_index = 1 : total_mus
    differences = (testInputFlattened - repmat(k_means_mus(mu_index, :), totalTestInputs, 1)) .^ 2;
    distances(:, mu_index) = sum(differences, 2) - h.^2;
end

[~, minDistanceIndices] = min(distances, [], 2);
labels = k_means_classes(minDistanceIndices);

% determine the labels based on majority of labels in a particular test
% data
countSoFar = 0;
for testDataIndex = 1 : numel(testInputs)
    startCount = countSoFar + 1;
    endCount = countSoFar + size(testInputs(testDataIndex).contents, 1);

    % collect the labels & their likelihoods for current example image (or)
    % speech
    currentLabels = labels(startCount : endCount);

    classAssignments(testDataIndex, :) = mode(currentLabels);

    % for each class, calculate the class scores from individual points
    for classIndex = 1 : numClasses
       classLogLikelihoods(testDataIndex, classIndex) = sum(currentLabels == classIndex) / size(currentLabels, 1);
    end

    countSoFar = endCount;    
end
end
