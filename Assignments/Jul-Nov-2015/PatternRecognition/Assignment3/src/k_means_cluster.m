function [ mu_k, assignments ] = k_means_cluster( data, K )
%K_MEANS_CLUSTER cluster the given data into K different clusters

    % run k-means algorithm to get the initial clusters
    %[IDX, C, SUMD] = kmeans(data, K);
   
    [N, D] = size(data);
    
    [assignments, mu_k] = kmeans(data, K);
       
    return;
    
    % select K random points as mu_k
    mu_k = data(randsample(1:N, K), :);
    
    iterations = 0;
    x = []; y = [];
    
    while(iterations <= 20)
        squaredError = getSquaredError(data, mu_k);
        
        % assign the data point to nearest cluster
        [~, clusterAssignments] = min(squaredError, [], 2);
        
        % calculate the centroid based on new assignment of points
        parfor index = 1:K
            mu_k (index, :) = mean(data((clusterAssignments == index), :)); 
        end
        
        x = [x; iterations];
        y = [y; sum(squaredError(:))];
        iterations = iterations + 1;
    end
    
    % make sure to fill the output data
    assignments = clusterAssignments;
    
    plot(x, y);
end

