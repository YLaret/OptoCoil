% total time
sa = tic;
% get optimization functions
addpath("Functions");
addpath(genpath("../MARIE"))

% LOAD ALL COILS AND FIELDS
fieldfolder = "../FIELDS/";
% voxel size of phantom, assumed to be known
allCoils = 0:31;

% acceleration (set accYes to 1 for acceleration)
accYes = 0;
rx = 2;
ry = 1;
rz = 1;

%%% LOAD E-FIELDS
tic
disp("Importing E fields...           [1/4]")
E = import_MARIE_data_v3(fieldfolder,allCoils,"E");
toc

RHBM = Import_RHBM("../FIELDS/Cylinder_6mm.vmm");
mask = RHBM.rho>0;

% find relevant indices
ind_nzp = find(mask>0);
[indx, indy, indz] = ind2sub( size(mask),ind_nzp );

% figure out limits
xmin = min(indx); xmax = max(indx);
ymin = min(indy); ymax = max(indy);
zmin = min(indz); zmax = max(indz);

xlim = squeeze(RHBM.r(:,1,1,1))';
ylim = squeeze(RHBM.r(1,:,1,2));
zlim = squeeze(RHBM.r(1,1,:,3))';

stepsize = xlim(2)-xlim(1);

xlim = xlim(xmin:xmax);
ylim = ylim(ymin:ymax);
zlim = zlim(zmin:zmax);

% slice maskl and sigma_e
sigma_e = RHBM.sigma_e(xmin:xmax,ymin:ymax,zmin:zmax);
mask = mask(xmin:xmax,ymin:ymax,zmin:zmax);
maskTot = sum(sum(sum(mask)));
idS = find(mask>0);
totalIndices = (xmax-xmin+1)*(ymax-ymin+1)*(zmax-zmin+1);
al = [(xmax-xmin+1),(ymax-ymin+1),(zmax-zmin+1)];
% calculate the total Q matrix
tic
disp("Computing loss matrix...      [2/4]")
qFull = calculate_loss_matrix_MARIE_v2(length(allCoils),stepsize,E,sigma_e);
toc
% free up some memory
clear E sigma_e xmin xmax ymin ymax zmin zmax ind_nzp indx indy indz

%%% LOAD B-FIELDS
tic
disp("Importing B fields...           [3/4]")
BFull = import_MARIE_data_v3(fieldfolder,allCoils,"B");

Btmp = reshape(BFull,totalIndices,3,length(allCoils));
B1minACC = squeeze((Btmp(:,1,:)-1i*Btmp(:,2,:))/sqrt(2));
B1min = squeeze((Btmp(idS,1,:)-1i*Btmp(idS,2,:))/sqrt(2));
% clear B-field remains
clear BFull Btmp
toc

%%% LOAD uiSNR
load usnr_map_Cylinder_6mm_1600.mat
usnar_map = usnr_map(idS);

%% START HERE FOR NO RELOAD %%
% starting coils
prevDel = -1;
chosenCoils = [];

% arrays to stor mean and max values per coil addition
for cCoil = 1:8
    coilCandit = -1;
    maxRound = 0;
    meanRound = 0;
    for coil = 0:(length(allCoils)-1)
        if ~any(chosenCoils==coil)
            % number of coils, assumed to be known
            coils = [chosenCoils,coil];
            nCoil = length(coils);

            % calculating loss covariance matrix
            q = qFull(coils+1,coils+1);
            % compute the optimum snr and weights
            B = B1min(:,coils+1);
            Bacc = B1minACC(:,coils+1);
            
            tic
            %disp("Computing SNR and weights...  [4/4]")
            [snr,rfmean] = calculate_snr_unaccelerated_MARIE_v3(nCoil,B,q,usnar_map,idS,al);
            [mx,I] = max(reshape(snr,totalIndices,1));
            [psnr,rfmax] = calculate_snr_unaccelerated_MARIE_v3(nCoil,B,q,usnar_map,I,al); 
            % calculate accellerated snr
            if accYes
                [SNRdR,gdR] = calculate_snr_accelerated_4(nCoil,mask,xlim,ylim,zlim,snr,Bacc,q,rx,ry,rz);
            end
            %toc
            % find mean in center (-5cm < z < 5cm, r < 6cm)
            % find mean in periphary (-5cm < z < 5cm, r > 8cm)
            periMean = 0;
            acciMean = 0;
            voxelCount = 0;
            % not hardware accelrated, but allows for precise zoning
            for z = 1:length(zlim)
                if abs(zlim(z)) < 1
                    for y = 1:length(ylim)
                        for x = 1:length(xlim)
                            if sqrt(xlim(x)^2+ylim(y)^2) < 1
                                periMean = periMean + snr(x,y,z)/(usnr_map(x,y,z)+~mask(x,y,z));
                                if accYes
                                    acciMean = acciMean + SNRdR(x,y,z)/(usnr_map(x,y,z)+~mask(x,y,z));
                                end
                                voxelCount = voxelCount+mask(x,y,z);
                            end
                        end
                    end
                end
            end

            periMean = periMean/voxelCount;
            acciMean = acciMean/voxelCount;

            if periMean > meanRound
                meanRound = periMean;
                % comment below for acceleration mean selection
                coilCandit = coil;
            end
            if accYes
                if acciMean > maxRound
                    maxRound = acciMean;
                    % uncomment below for acceleration mean selection
                    %coilCandit = coil;
                end
            end
        end
    end
    % add candidate permanently to array
    chosenCoils = [chosenCoils,coilCandit];

    % display round output
    disp(fprintf("%d ACC: %f%%\tMEAN: %f%%",cCoil,100*maxRound,100*meanRound));
end
toc(sa)
