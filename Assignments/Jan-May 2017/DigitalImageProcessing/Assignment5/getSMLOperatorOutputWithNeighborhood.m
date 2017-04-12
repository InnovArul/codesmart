function [SMLoutput] = getSMLOperatorOutputWithNeighborhood(SMLxxAndyy, neighborhood)

    % based on the 'neighborhood' value, convolve with appropriate filter
    SMLxxNeighborhoodOutput = conv2(SMLxxAndyy{1}, ones(2 * neighborhood + 1), 'same');
    SMLyyNeighborhoodOutput = conv2(SMLxxAndyy{2}, ones(2 * neighborhood + 1), 'same');
    
    % add xx and yy outputs
    SMLoutput = SMLxxNeighborhoodOutput + SMLyyNeighborhoodOutput;
end