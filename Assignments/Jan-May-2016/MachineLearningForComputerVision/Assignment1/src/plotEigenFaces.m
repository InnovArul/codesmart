function [] = plotEigenFaces(sortedEigVectors, width, height)

global REPORTFOLDER;

%create top 5 eigen faces for report
for i = 1 : 2
    figure;
    
    for k = 1 : 10
        subplot(5, 2, k);
        eigenface = sortedEigVectors(:, (i-1) * 10 +k);
        reshaped = reshape(eigenface, width, height);
        imagesc(reshaped);
        title(strcat('Eigenface ', num2str((i-1) * 10 +k)));
        set(gca,'Visible','off')
        set(get(gca,'Title'),'visible','on')
        colormap gray;
    end
    
    set(gcf,'PaperUnits','inches','PaperPosition',[2 2 15 15])
    saveas(gca, strcat(REPORTFOLDER, 'eigenfaceset', num2str(i), '.png'));
    close all;
    
end

end