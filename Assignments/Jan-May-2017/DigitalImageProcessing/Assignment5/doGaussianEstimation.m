function [gaussIndices] = doGaussianEstimation(SMLoutput, indices)
    totalDs = size(SMLoutput, 3);
    gaussIndices = zeros(size(indices));
    deltaD = 50.5;
    
    for i = 1 : size(indices, 1)
        for j = 1 : size(indices, 2)
            m = indices(i, j);
            
            F_m = SMLoutput(i, j, m);
            F_mMinus1 = 0; F_mPlus1 = 0;
            
            %handle lower boundary condition
            if(m - 1 <= 0) 
                F_mMinus1 = SMLoutput(i, j, 1);
            else 
                F_mMinus1 = SMLoutput(i, j, m - 1);
            end
            
            %handle upper boundary condition
            if(m + 1 > totalDs) 
                F_mPlus1 = SMLoutput(i, j, totalDs);
            else 
                F_mPlus1 = SMLoutput(i, j, m + 1);
            end            
            
            gaussIndices(i, j) = (1 / 2) * (2 * m + (log(F_mPlus1/F_mMinus1) / log((F_m^2)/(F_mMinus1 * F_mPlus1))));
        end
    end
end