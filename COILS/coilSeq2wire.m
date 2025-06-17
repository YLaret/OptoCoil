function coilSeq2wire(coilSeq3D,coilName,wireDiameter,resistivity)
[rows, columns] = size(coilSeq3D);
if columns ~= 3
    error('Error. Wrong dimension coilSeq2D. Expected Mx3, got Mx%d',columns)
end
% wire thicknes [m]
%wireDiameter = 0.001;

% copper resistivity [Ohm/m]
%resistivity = 1.2579e-08;
                
% file name
filename = sprintf("%s",coilName);
fileID = fopen(sprintf("%s.wsd",filename),'w');
for i=1:rows-1
    % add only one excitation port
    s = 0;
    if i == 1
        s = 1;
    end
    fprintf(fileID,'%f\t%f\t%f\t%f\t%f\t%f\t%f\n',coilSeq3D(i,1),coilSeq3D(i,2),coilSeq3D(i,3),coilSeq3D(i+1,1),coilSeq3D(i+1,2),coilSeq3D(i+1,3),s);
end
fclose(fileID);

% wmm (overview) file
fileID = fopen(sprintf("%s.wmm",filename),"w");
fprintf(fileID, sprintf("%s\n",filename));
fprintf(fileID, sprintf("%0.5e %f\n",resistivity,wireDiameter));
fprintf(fileID, sprintf("../COILS/%s.wsd",filename));
fclose(fileID);
