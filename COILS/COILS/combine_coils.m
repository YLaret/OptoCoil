%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% code to combine the coils %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% the names of the coils to be combined
coils = 0:31;

% wire thicknes [m]
wirediameter = 0.001;

% copper resistivity [Ohm/m]
resistivity = 1.2579e-08;

filenameO = "combinedCoils";
fileIDO = fopen(sprintf("%s.wsd",filenameO),'w');

for i = 1:length(coils)
    segments = fileread(sprintf("%d.wsd",coils(i)));
    fprintf(fileIDO, sprintf("%s\n",segments));
end


fclose(fileIDO);
fileIDO = fopen(sprintf("%s.wmm",filenameO),"w");
fprintf(fileIDO, sprintf("%s\n",filenameO));
fprintf(fileIDO, sprintf("%0.5e %f\n",resistivity,wirediameter));
fprintf(fileIDO, sprintf("%s.wsd",filenameO));
fclose(fileIDO);