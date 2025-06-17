% add the MARIE functions
addpath(genpath("../MARIE"))

% import phantom
RHBM = Import_RHBM("Cylinder_6mm.vmm");
mask = RHBM.sigma_e>0;
% (Zpar, Coilbasis, Bodybasis, SAR, E, B, GSAR, Pabs, inAir)
flags = [0,0,0,0,1,1,0,0,0,];


% larmor frequency
freq = 298.0320e6;

% precision (tolerance)
tol = 1e-3;

% find limits of phantom
ind_nzv = find(mask>0);
ind_nzp = RHBM.idxS;
ind_tzp = find(RHBM.rho>0);


%%
[indx, indy, indz] = ind2sub( size(RHBM.sigma_e),ind_nzp );

xmin = min(indx); xmax = max(indx);  % object' bounding box so we don't store more data than needed
ymin = min(indy); ymax = max(indy);
zmin = min(indz); zmax = max(indz);

% loop over each coil
for i = 0:31
    % import current coil
    COIL = Import_COIL(sprintf('../COILS/%d.wmm',i));

    % calculate fields (only H and E in phantom)
    [ZP,Jc,Jb,Sb,Eb,Bb,Gsar,Pabs] = MR_Solver(RHBM,COIL,freq,tol,flags);

    %save(sprintf("%dFIELD.mat",i),"Eb","Bb","-v7.3")
    % save E-field
    E = Eb(xmin:xmax,ymin:ymax,zmin:zmax,:);
    save(sprintf("%dEField.mat",i),"E","-v7.3")

    % save B-field
    B = Bb(xmin:xmax,ymin:ymax,zmin:zmax,:);
    save(sprintf("%dBField.mat",i),"B","-v7.3")
end

disp("Done!")
