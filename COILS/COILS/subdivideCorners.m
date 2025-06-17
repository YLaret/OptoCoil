function [coilSeq2D,totaLength] = subdivideCorners(corners,n)
coilSeq2D = zeros(n,2);
totaLength = 0;
segLength = zeros(length(corners) - 1,1);
cumaLength = zeros(length(corners) - 1,1);
% calculate lengths
for i = 2:length(corners)
    segLength(i-1) = sqrt((corners(i,1)-corners(i-1,1))^2 + (corners(i,2)-corners(i-1,2))^2);
    cumaLength(i) = cumaLength(i-1) + segLength(i-1);
    totaLength = totaLength + segLength(i-1);
end
cornerIndices = round(cumaLength/totaLength*(n-1)+1);
if length(unique(cornerIndices)) ~= length(cornerIndices)
    error('Error. Please increase n')
end
% fix corners points
for i = 1:length(corners)
    indi = cornerIndices(i);
    coilSeq2D(indi,:) = corners(i,:);
end

% fill in segments
for i = 2:length(cornerIndices)
    counter = 1;
    for j = cornerIndices(i-1)+1:cornerIndices(i)-1
        dindi = cornerIndices(i)-cornerIndices(i-1);
        coilSeq2D(j,2) = corners(i-1,2)+(corners(i,2)-corners(i-1,2))*counter/dindi;
        coilSeq2D(j,1) = corners(i-1,1)+(corners(i,1)-corners(i-1,1))*counter/dindi;
        counter = counter + 1;
    end
end