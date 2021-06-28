function H = findGoodHomography(corresp1, corresp2)

totalPoints = size(corresp1, 1);

for index = 1:totalPoints
    [corresp, remainingPoints] = getRandom4Points(corresp1, corresp2);
    % corresp will contain 4 random points
    % remainingPoints will contain the remaining points

    %get Homography matrix H
    H = getHomography(corresp);

    %find the number of consensus points
    numOfConsensusPoints = getNumberOfConsensusPoints(H, remainingPoints);

    %return the current H if the consensus points are 80% of total points
    if(numOfConsensusPoints >= 0.8 * totalPoints)
        return;
    end
end

end