%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% code to generate the coils as individual files %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

wL = 0.1*pi;            % circular loop with 10 cm radius [m]
g = 5e-3;               % gap between ends [m]

% corner points of shapes
triangle = [[-g/2,0];[-(wL+g)/6,0];[0,(wL+g)/3*sin(pi/3)];[(wL+g)/6,0];[g/2,0]];

% curve radius and position
centerxy = [0,0];
r = 0.12;

% coil count (used for output names)
count = 0;

% wire thicknes [m]
wireDiameter = 0.001;
% copper resistivity [Ohm/m]
resistivity = 1.2579e-08;

%%% TRIANGLES %%%
% different heights the coils are placed
h = [-0.10,-0.033];
% amount of coils per height (rotated around center)
red = 4;
% amount of segments
n = 100;
% subdivide the wire segments, t is the wire length
[coilSeq2D, t] = subdivideCorners(triangle,n);
for i = 1:red
    for j = 1:length(h)
        rho = (i-1)/red*2*pi;
        % function to curve the coil and position it at a certain radius
        % and angle
        coilSeq3D = curveCoil(coilSeq2D,[centerxy,h(j)],r,rho);
        % outputs the wire format used by the MARIE solver
        coilSeq2wire(coilSeq3D,string(count),wireDiameter,resistivity)
        count = count + 1;
    end
end
% function to rotate coils in the 2D plane
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
% special function to create loop coils
[coilSeq2D, t] = create2DloopCoil(0.1,g,n);

for i = 1:red
    for j = 1:length(h)
        rho = (i-1)/red*2*pi;
        coilSeq3D = curveCoil(coilSeq2D,[centerxy,h(j)],r,rho);
        coilSeq2wire(coilSeq3D,string(count),wireDiameter,resistivity)
        count = count + 1;
    end
end
% special function to create figure-8 coils
%%% FIGURE 8 COILS %%%
[coilSeq2D, t] = create2DfigureEight(0.045,g,2.45,n);
for i = 1:red
    for j = 1:length(h)
        rho = (i-1)/red*2*pi;
        coilSeq3D = curveCoil(coilSeq2D,[centerxy,h(j)],r,rho);
        coilSeq2wire(coilSeq3D,string(count),wireDiameter,resistivity)
        count = count + 1;
    end
end
