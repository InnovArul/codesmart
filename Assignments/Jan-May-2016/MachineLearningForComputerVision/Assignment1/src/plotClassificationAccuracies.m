function [] = plotClassificationAccuracies(accuracyPercentages, testCasesStrings, numberOfEigenBasis)

    global REPORTFOLDER;
    legends = {};
    
    fig = figure;
    
    colors=hsv(10);
    
    %plot all the classification accuracies
    for index = 1:size(accuracyPercentages, 1)
       accuracy = accuracyPercentages(index, :);
       plot(1:length(testCasesStrings), accuracy, 'color', colors(index, :));
       hold on;
       
       legends(index) = {strcat(num2str(numberOfEigenBasis(index)), '-eigenvectors')};   
    end
    
    % assign legend strings
    legend(legends);
    legend show;
    set(gca,'XTick',1:length(testCasesStrings), 'XTickLabel',testCasesStrings);     
    title('number of eigen vectors vs. train-data:test-data partition');
    xlabel('train-data:test-data partition'); ylabel('classification accuracy');
    saveas(fig, strcat(REPORTFOLDER, num2str(size(accuracyPercentages, 1)), 'Accuracies.png'));
    close(fig);
end