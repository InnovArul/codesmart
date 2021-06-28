function [ ] = doall_task1_2(task, imageOption, K, meanSelectionOption)
%DOALL_TASK1 K-means clustering

MAXIMUM_ITERATIONS = 100;
global DATAFOLDER REPORT_PICS_FOLDER IMAGEFILE MEAN_SELECTION;
DATAFOLDER = '../data/Problem-1-2/clustering_img/';
REPORT_PICS_FOLDER = '../report/pics/task1and2';

imgData = getDataForTask1(imageOption);

if(task == options.TASK_1)

    %define class assignment labels holder for pixels in the image
    prevlabels = zeros(size(imgData, 1), size(imgData, 2));
    mu_i = selectMeanForClusters(imgData, meanSelectionOption, K);

    changedPoints = [];
    totalCost = [];

    for iteration = 1 : MAXIMUM_ITERATIONS
        % do K-means clustering update once
        [mu_i, labels, currentCost] = doKMeansClustering(imgData, mu_i);

        % find out how many points changed it's class and total cost in the
        % current iteration
        currentChanges = sum(sum(prevlabels ~= labels, 1), 2);

        % note down the current changes and total cost
        changedPoints = [changedPoints currentChanges];
        totalCost = [totalCost currentCost];

        %save the previous label assignments
        prevlabels = labels;

        saveSegmentedImage(imgData, labels, mu_i, strcat('K=', num2str(K), '_iteration_', num2str(iteration), '_', MEAN_SELECTION, IMAGEFILE));

        %break if there are no changes in the cluster assignments
        if(currentChanges == 0)
            break;
        end
    end

    % plot the total cost graph, changed points graph
    plotGraph([1:length(totalCost)]', totalCost', 'iterations (t)', 'total cost d^{(t)}', ...
        'iterations (t) vs. total cost d^{(t)}', {'t vs. d^{(t)}'}, strcat('t_vs_d_', MEAN_SELECTION, IMAGEFILE));

    plotGraph([1:length(changedPoints)]', changedPoints', 'iterations (t)', 'cluster assignment changes s^{(t)}', ...
        'iterations (t) vs. cluster assignment changes s^{(t)}', {'t vs. s^{(t)}'}, strcat('t_vs_s_', MEAN_SELECTION, IMAGEFILE));
else
   % call the EM algorithm for GMM
   segmentedImage = kGaussian_color_EM(imgData, K);
  
   imshow(segmentedImage);
   
   % save the segmented image returned by GMM EM algorithm
   saveas(gcf, fullfile(REPORT_PICS_FOLDER, strcat('EM_K=', num2str(K), '_', MEAN_SELECTION, IMAGEFILE)));
   close all;
end

end

