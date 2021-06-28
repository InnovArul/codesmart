function [] = savePatch(patch, prepender, appender, X, Y)
    global outputFolder;
   imshow(patch, 'InitialMagnification', 1000);
   saveas(gca, fullfile(outputFolder, strcat(prepender, '-X:', num2str(X), '-Y:', ...
            num2str(Y), '-', appender, '.png')));
   close all;  
end