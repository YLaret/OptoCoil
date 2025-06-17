function [coilSeq2D,totaLength] = create2DfigureEight(diameter,gap,ratio,n)
rhoStart = 2*asin(gap/diameter);
rhoStop = 12*pi/ratio - rhoStart;

coilSeq2D = [];

rhoList = linspace(rhoStart,rhoStop,n);
alpha = (1/ratio-1/4)*2*pi;
iSwitch = 1;
jSwitch = 1;
hSwitch = 1;
kSwitch = 1;
rho1 = 0;
rho2 = 0;
rho3 = 0;
rho4 = 0;
rAlphaStop = -pi/2+rhoStart;
for i = 1:n
    if rhoList(i) < 2*pi/ratio
        coilSeq2D(i,:) = diameter/2*[-sin(rhoList(i)),-cos(rhoList(i))+1];
        iSwitch = i;
    elseif rho1 > -alpha
        rho1 = alpha - (rhoList(i)-rhoList(iSwitch));
        center = diameter*[-cos(alpha),1/2+sin(alpha)];
        coilSeq2D(i,:) = diameter/2*[cos(rho1),-sin(rho1)]+center;
        jSwitch = i;
    elseif rho2 > -pi-alpha
        rho2 = alpha - (rhoList(i)-rhoList(jSwitch));
        coilSeq2D(i,:) = diameter/2*[-cos(rho2),-sin(rho2)+1+4*sin(alpha)];
        hSwitch = i;
    elseif rho3 > -alpha
        rho3 = alpha - (rhoList(i)-rhoList(hSwitch));
        center = diameter*[cos(alpha),1/2+sin(alpha)];
        coilSeq2D(i,:) = diameter/2*[-cos(rho3),sin(rho3)]+center;
        kSwitch = i;
    elseif rho4 > rAlphaStop
        rho4 = alpha - (rhoList(i)-rhoList(kSwitch));
        coilSeq2D(i,:) = diameter/2*[cos(rho4),sin(rho4)+1];
    end
end
totaLength = 0;
for i = 2:length(coilSeq2D)
    totaLength = totaLength + sqrt((coilSeq2D(i,1)-coilSeq2D(i-1,1))^2+(coilSeq2D(i,2)-coilSeq2D(i-1,2))^2);
end