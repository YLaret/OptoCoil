function coilSeq3D = curveCoil(coilSeq2D,offset,radius,rotation)
[rows, columns] = size(coilSeq2D);
if columns ~= 2
    error('Error. Wrong dimension coilSeq2D. Expected Mx2, got Mx%d',columns)
end
coilSeq3D = zeros(rows,3);
%%% CURVE %%%%
xPrev = coilSeq2D(1,1);
alpha = 0;
for i = 1:rows
    dx = coilSeq2D(i,1)-xPrev;
    alpha = alpha + 2*asin(dx/2/radius);
    coilSeq3D(i,:) = [radius*cos(alpha),radius*sin(alpha),coilSeq2D(i,2)];
    xPrev = coilSeq2D(i,1);
end

%%% ROTATE %%%
for i = 1:rows
    phi = atan(coilSeq3D(i,2)/coilSeq3D(i,1));
    r = sqrt(coilSeq3D(i,2)^2+coilSeq3D(i,1)^2);
    coilSeq3D(i,:) = [r*cos(phi+rotation),radius*sin(phi+rotation),coilSeq2D(i,2)];
end

%%% OFFSET %%%
coilSeq3D = coilSeq3D + offset;