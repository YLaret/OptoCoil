function [coilSeq2D, totaLength] = create2DloopCoil(diameter,gap,n)
rhoStart = 2*asin(gap/diameter);
rhoStop = 2*pi - rhoStart;

coilSeq2D = zeros(n,2);

rhoList = linspace(rhoStart,rhoStop,n);
for i = 1:n
    coilSeq2D(i,:) = diameter/2*[-sin(rhoList(i)),-cos(rhoList(i))+1];
end
totaLength = 0;
for i = 2:length(coilSeq2D)
    totaLength = totaLength + sqrt((coilSeq2D(i,1)-coilSeq2D(i-1,1))^2+(coilSeq2D(i,2)-coilSeq2D(i-1,2))^2);
end
