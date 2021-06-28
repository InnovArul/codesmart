function [] = saveFigureLocal(fig, path, isEPS)
    if(~exist('isEPS'))
        isEPS = 0;
    end
    
    %if(isEPS == 1)
     
    %saveas(fig, strcat(path, '.eps'), 'epsc2');    
    %saveas(fig, strcat(path, '.fig'));
   % else
    saveas(fig, strcat(path, '.png'));
    %end
end