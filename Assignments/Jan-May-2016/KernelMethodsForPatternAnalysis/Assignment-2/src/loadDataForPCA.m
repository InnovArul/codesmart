function [ data ] = loadDataForPCA(  )
%LOADDATAFORPCA Summary of this function goes here
%   Detailed explanation goes here

dataCache = 'imageDataForTask2.mat';

if(exist(dataCache, 'file'))
    dataStruct = load(dataCache);
    data = dataStruct.data;
else
    datapath = '../data/task3/imagedata';
    groupdata = './Group_14_data.mat';

    groupContents = load(groupdata);
    data = [];
    allLabels = groupContents.final_labels;

    for contentIndex = 1:length(allLabels)
        disp(contentIndex);
        content = allLabels(contentIndex, :);
        filename = fullfile(datapath, strcat(num2str(content(1)), '.jpg'));
        [~, classNumber] = max(content(2:end), [], 2);

        features = featureextraction_task2(filename);

        data = [data; [content(1) features classNumber]; ];
    end
end

end

