function rotatedCoilSeq2D = rotate2Dcoil(coilSeq2D,rho)
xMax = max(coilSeq2D(:,1));
xMin = min(coilSeq2D(:,1));

yMax = max(coilSeq2D(:,2));
yMin = min(coilSeq2D(:,2));

rotatedCoilSeq2D = zeros(length(coilSeq2D),2);
center = [(xMax+xMin)/2,(yMax+yMin)/2];
%center = [1,1]
for i = 1:length(coilSeq2D)
    xNew = (coilSeq2D(i,1)-center(1))*cos(rho) - (coilSeq2D(i,2)-center(2))*sin(rho) + center(1);
    yNew = (coilSeq2D(i,1)-center(1))*sin(rho) + (coilSeq2D(i,2)-center(2))*cos(rho) + center(2);
    rotatedCoilSeq2D(i,:) = [xNew,yNew];
end