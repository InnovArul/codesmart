function data = getFractionOfData(mapContainer, key, percent)
    data = [];
    for classNumber = 1:4 
       currentData = mapContainer{classNumber}(key);
       dataCount = ceil(size(currentData, 1) * percent);
       randomPermutation = randperm(size(currentData, 1));
       
       labels = ones(dataCount, 1);
       if(classNumber ~= 1)
           labels = labels * -1;
       end
       data = [data; [currentData(randomPermutation(1:dataCount), :) labels]];
    end
end