% read the config file
conf = load('config.mat');

% for each class, collect all the files and their features
num_classes = size(conf.classes, 1);

max_features = [];
avg_features = [];
class_labels = [];
file_names = {};

for classIndex = 1:num_classes
    className = conf(1).classes(classIndex, :)
    
    classFiles = conf.config.(strtrim(className));
    
    % read all the features for current video
    for fileIndex = 1:size(classFiles, 1)
        filename = classFiles(fileIndex, :);
        [~, filename, extn] = fileparts(filename);
        current_features = [];
            
        featureIndex = 0;
        readFile = true;
        current_file_to_read = strcat('./features/', className, '-', filename, extn, '-', num2str(featureIndex), '.pool5');
        while(readFile)
            if(~exist(current_file_to_read, 'file'))
                break
            end
            
            [siz, feature] = read_binary_blob(current_file_to_read);
            current_features = [current_features; feature];
            featureIndex = featureIndex + 1;
            current_file_to_read = strcat('./features/', className, '-', filename, extn, '-', num2str(featureIndex), '.pool5');
        end
        
        max_features = [max_features; max(current_features, [], 1)];
        avg_features = [avg_features; mean(current_features, 1)];
        class_labels = [class_labels; classIndex];
        file_names{end+1} = {className, strcat(filename, extn)};
        disp(current_file_to_read)
    end
end

save('olympic_features.mat', 'max_features','avg_features','class_labels','file_names');