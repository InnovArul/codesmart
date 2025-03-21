function blurImage()
    addpath('../Assignment2/');
    outputPath = './output';
    
    fd_combinations = [ %500, 200;
                        %500, 1000;
                        500, 5000;
                        %100, 1000;
                        %500, 1000;
                        %1000, 1000
                        ];
    
	for index = 1 : size(fd_combinations, 1)
        f = fd_combinations(index, 1);
        d = fd_combinations(index, 2);
        
        outFilePrefix = strcat(outputPath, '/f=', int2str(f), '_d=', int2str(d));        
        disp(strcat(int2str(index), ' : f = ', int2str(f), ', d = ', int2str(d))) 
        [imgB1, allB1Images] = getBlurredImageMethod1(f, d);
        [imgB2, allB2Images] = getBlurredImageMethod2(f, d);
        disp('total error between B1 and B2 : ');
        disp(norm(imgB1 - imgB2));
        
        writeGifImage(allB1Images, strcat(outFilePrefix, '_B1.gif'));
        writeGifImage(allB2Images, strcat(outFilePrefix, '_B2.gif'));
    end 
end