% reset environment
close all
clear
clc

% define the coil fields HERE:
chosenCoils = 0:31;

% add the MARIE functions
addpath(genpath("../MARIE"))

% import phantom
RHBM = Import_RHBM("../FIELDS/Cylinder_6mm.vmm");
mask = RHBM.sigma_e>0;

% find limits of phantom
ind_nzv = find(mask>0);
ind_nzp = RHBM.idxS;
ind_tzp = find(RHBM.rho>0);

for i = 1:length(ind_tzp)
    if ind_nzp(i) ~= ind_tzp(i)
        disp("NOTOK")
    end
end

[indx, indy, indz] = ind2sub( size(RHBM.sigma_e),ind_nzp );

xmin = min(indx); xmax = max(indx);  % object' bounding box so we don't store more data than needed
ymin = min(indy); ymax = max(indy);
zmin = min(indz); zmax = max(indz);

% read the raw coil fields
filia = 0;
mu0 = 4*pi*1e-7;
freq = 300;
nCoil = 0;
E_raw = [];
H_raw = [];

folder = 'Export';
for i = 1:length(chosenCoils)
    E_string = sprintf('macroSegmentCoils/%s/%dE.txt',folder,chosenCoils(i));
    H_string = sprintf('macroSegmentCoils/%s/%dH.txt',folder,chosenCoils(i));

    E_raw(i,:,:) = readmatrix(E_string);
    H_raw(i,:,:) = readmatrix(H_string);
end

% determine stepsize in [mm]
stepsize = abs(E_raw(1,1,1)-E_raw(1,2,1));

xlim = min(E_raw(1,:,1)):stepsize:max(E_raw(1,:,1));
ylim = min(E_raw(1,:,2)):stepsize:max(E_raw(1,:,2));
zlim = min(E_raw(1,:,3)):stepsize:max(E_raw(1,:,3));

% complex e-field
Ee = zeros(length(xlim),length(ylim),length(zlim),3);
Bb = zeros(length(xlim),length(ylim),length(zlim),3);

% output folder
odir = "../FIELDS";

% loop for every datapoint and every coil
for n=1:length(chosenCoils)
    % restart index for every coil
    i = 1;
    for z=1:length(zlim)
        for y=1:length(ylim)
            for x=1:length(xlim)
                % E field (complex 3D vector per index)
                for h=1:3
                    Ee(x,y,z,h) = E_raw(n,i,2*h+2)+E_raw(n,i,2*h+3)*1j;
                    Bb(x,y,z,h) = mu0*(H_raw(n,i,2*h+2)+H_raw(n,i,2*h+3)*1j);
                end
                % increment counter every pixel
                i = i + 1;
            end
        end
    end
    E = Ee(xmin:xmax,ymin:ymax,zmin:zmax,:);
    B = Bb(xmin:xmax,ymin:ymax,zmin:zmax,:);
    save(sprintf("%s/%dEField.mat",odir,chosenCoils(n)),"E","-v7.3")
    save(sprintf("%s/%dBField.mat",odir,chosenCoils(n)),"B","-v7.3")
end
