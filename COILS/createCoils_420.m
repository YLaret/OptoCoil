% define corner points for straight coils
wL = 0.1*pi;            % circular loop with 10 cm radius [m]
g = 5e-3;               % gap between ends [m]
% shapes
triangle = [[-g/2,0];[-(wL+g)/6,0];[0,(wL+g)/3*sin(pi/3)];[(wL+g)/6,0];[g/2,0]];
itriangle = [[-g/2,(wL+g)/3*sin(pi/3)];[-(wL+g)/6,(wL+g)/3*sin(pi/3)];[0,0];[(wL+g)/6,(wL+g)/3*sin(pi/3)];[g/2,(wL+g)/3*sin(pi/3)]];
diamond = [[-g/2,0];[-(wL+g)/sqrt(2)/4,(wL+g)/sqrt(2)/4];[0,(wL+g)*2/sqrt(2)/4-1.05e-3];[(wL+g)/sqrt(2)/4,(wL+g)/sqrt(2)/4];[g/2,0]];
square = [[-g/2,0];[-(wL+g)/8,0];[-(wL+g)/8,(wL+g)/4];[(wL+g)/8,(wL+g)/4];[(wL+g)/8,0];[g/2,0]];
r = 4;
c = (wL+g)/(2*(1+1/r));
b = c/r;
rectHori = [[-g/2,0];[-c/2,0];[-c/2,b];[c/2,b];[c/2,0];[g/2,0]];
r = 1/r;
c = (wL+g)/(2*(1+1/r));
b = c/r;
rectVerti = [[-g/2,0];[-c/2,0];[-c/2,b];[c/2,b];[c/2,0];[g/2,0]];

% coil type
coilType = zeros(1,286);

% curve and position
count = 0;
r = 0.12;
% wire thicknes [m]
wireDiameter = 0.001;

% copper resistivity [Ohm/m]
%%% TRIANGLES %%%
resistivity = 1.2579e-08;
centerxy = [0,0];
h = [-0.10,-0.066,-0.033,0];
red = 8;
n = 100;
[coilSeq2D, t] = subdivideCorners(triangle,n);
for i = 1:red
    for j = 1:length(h)
        rho = (i-1)/red*2*pi;
        coilSeq3D = curveCoil(coilSeq2D,[centerxy,h(j)],r,rho);
        coilSeq2wire(coilSeq3D,string(count),wireDiameter,resistivity)
        count = count + 1;
        coilType(count) = 1;
    end
end
%%% UPSIDE DOWN TRIANGLES %%%
[coilSeq2D, t] = subdivideCorners(itriangle,n);
for i = 1:red
    for j = 1:length(h)
        rho = (i-1)/red*2*pi;
        coilSeq3D = curveCoil(coilSeq2D,[centerxy,h(j)],r,rho);
        coilSeq2wire(coilSeq3D,string(count),wireDiameter,resistivity)
        count = count + 1;
        coilType(count) = 2;
    end
end
%%% DIAMONDS %%%
[coilSeq2D, t] = subdivideCorners(diamond,n);
for i = 1:red
    for j = 1:length(h)
        rho = (i-1)/red*2*pi;
        coilSeq3D = curveCoil(coilSeq2D,[centerxy,h(j)],r,rho);
        coilSeq2wire(coilSeq3D,string(count),wireDiameter,resistivity)
        count = count + 1;
        coilType(count) = 3;
    end
end
%%% SQUARES %%%
[coilSeq2D, t] = subdivideCorners(square,n);
for i = 1:red
    for j = 1:length(h)
        rho = (i-1)/red*2*pi;
        coilSeq3D = curveCoil(coilSeq2D,[centerxy,h(j)],r,rho);
        coilSeq2wire(coilSeq3D,string(count),wireDiameter,resistivity)
        count = count + 1;
        coilType(count) = 4;
    end
end
%%% HORIZONTAL RECTANGLES %%%
[coilSeq2D, t] = subdivideCorners(rectHori,n);
red = 3;
h = [-0.10,-0.066,-0.033,0,0.033,0.066];
for i = 1:red
    for j = 1:length(h)
        rho = (i-1)/red*2*pi;
        coilSeq3D = curveCoil(coilSeq2D,[centerxy,h(j)],r,rho);
        coilSeq2wire(coilSeq3D,string(count),wireDiameter,resistivity)
        count = count + 1;
        coilType(count) = 5;
    end
end
coilSeq2D = rotate2Dcoil(coilSeq2D,pi/4);
for i = 1:red
    for j = 1:length(h)
        rho = (i-1)/red*2*pi;
        coilSeq3D = curveCoil(coilSeq2D,[centerxy,h(j)],r,rho);
        coilSeq2wire(coilSeq3D,string(count),wireDiameter,resistivity)
        count = count + 1;
        coilType(count) = 6;
    end
end
%%% VERTICAL RECTANGLES %%%
[coilSeq2D, t] = subdivideCorners(rectVerti,n);
red = 16;
h = [-0.1,0];
for i = 1:red
    for j = 1:length(h)
        rho = (i-1)/red*2*pi;
        coilSeq3D = curveCoil(coilSeq2D,[centerxy,h(j)],r,rho);
        coilSeq2wire(coilSeq3D,string(count),wireDiameter,resistivity)
        count = count + 1;
        coilType(count) = 7;
    end
end
coilSeq2D = rotate2Dcoil(coilSeq2D,pi/4);
for i = 1:red
    for j = 1:length(h)
        rho = (i-1)/red*2*pi;
        coilSeq3D = curveCoil(coilSeq2D,[centerxy,h(j)],r,rho);
        coilSeq2wire(coilSeq3D,string(count),wireDiameter,resistivity)
        count = count + 1;
        coilType(count) = 8;
    end
end
%%% LOOP COILS %%%
h = [-0.10,-0.066,-0.033,0];
[coilSeq2D, t] = create2DloopCoil(0.1,g,n);
lc = [];
for i = 1:red
    for j = 1:length(h)
        rho = (i-1)/red*2*pi;
        coilSeq3D = curveCoil(coilSeq2D,[centerxy,h(j)],r,rho);
        coilSeq2wire(coilSeq3D,string(count),wireDiameter,resistivity)
        count = count + 1;
        coilType(count) = 9;
        if mod(i+1,2)==0 && mod(j+2,3)==0
            lc = [lc,count-1]; 
        end
    end
end
%%% FIGURE 8 COILS %%%
[coilSeq2D, t] = create2DfigureEight(0.045,g,2.45,n);
for i = 1:red
    for j = 1:length(h)
        rho = (i-1)/red*2*pi;
        coilSeq3D = curveCoil(coilSeq2D,[centerxy,h(j)],r,rho);
        coilSeq2wire(coilSeq3D,string(count),wireDiameter,resistivity)
        count = count + 1;
        coilType(count) = 10;
    end
end
coilSeq2D = rotate2Dcoil(coilSeq2D,pi/4);
for i = 1:red
    for j = 1:length(h)
        rho = (i-1)/red*2*pi;
        coilSeq3D = curveCoil(coilSeq2D,[centerxy,h(j)],r,rho);
        coilSeq2wire(coilSeq3D,string(count),wireDiameter,resistivity)
        count = count + 1;
        coilType(count) = 11;
    end
end
