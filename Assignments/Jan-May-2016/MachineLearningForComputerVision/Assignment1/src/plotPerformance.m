function [] = plotPerformance(dVsN1, dVsN2, descriptions)

    global REPORTFOLDER;
    
    fig = figure;
    plot(2:length(dVsN1) + 1, dVsN1, 'g','LineWidth', 2);
    hold on;
    plot(2:length(dVsN2) + 1, dVsN2, 'r','LineWidth', 2);
    
    title(descriptions{3});
    legend(descriptions{1}, descriptions{2}); legend show; 
    xlabel('Number of examples'); ylabel('Bhattacharya distance between estimated \mu and Ground truth');
    saveas(fig, fullfile(strcat(REPORTFOLDER, descriptions{1}, '-', descriptions{2}, '.png')));
end