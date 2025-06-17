function [SNRdR,gdR] = calculate_snr_accelerated_4(nCoil,mask,xlim,ylim,zlim,SNRu,B,q,Rx,Ry,Rz)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%% *** CALCULATE SNR (accelerated) (2) *** %%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% input (nCoil,mask,xlim,ylim,zlim,SNRu,B,q,Rx,Ry,Rz)
% output (SNRdR, gdR)
% direct method of calculating g
% set reduction in x-direction
B = reshape(B,length(xlim),length(ylim),length(zlim),nCoil);
gdR = ones(length(xlim),length(ylim),length(zlim));
for z=1:floor(length(zlim)/Rz)
    for y=1:floor(length(ylim)/Ry)
        for x=1:floor(length(xlim)/Rx)
            S = [];%zeros(nCoil,Rx*Ry*Rz);
            cunta = 1;
            for rz = 1:Rz
                for ry = 1:Ry
                    for rx = 1:Rx
                        ix = 1 + (x-1)+(rx-1)*floor(length(xlim)/Rx);
                        iy = 1 + (y-1)+(ry-1)*floor(length(ylim)/Ry);
                        iz = 1 + (z-1)+(rz-1)*floor(length(zlim)/Rz);
                        if mask(ix,iy,iz)
                            S(:,cunta) = B(ix,iy,iz,:);
                            cunta = cunta + 1;
                        end
                    end
                end
            end
            % if no sensitivity for given voxel
            if cunta ~= 1
                M = ctranspose(S) * inv(q) * S;
                M_inv = inv(M);
                cunta = 1;
                for rz = 1:Rz
                    for ry = 1:Ry
                        for rx = 1:Rx
                            ix = 1 + (x-1)+(rx-1)*floor(length(xlim)/Rx);
                            iy = 1 + (y-1)+(ry-1)*floor(length(ylim)/Ry);
                            iz = 1 + (z-1)+(rz-1)*floor(length(zlim)/Rz);
                            if mask(ix,iy,iz)
                                gdR(ix,iy,iz) = abs(sqrt(M_inv(cunta,cunta)*M(cunta,cunta)));
                                cunta = cunta + 1;
                            end
                        end
                    end
                end
            end
        end
    end
end

% direct method looks more promising
% work back snr map from g map
SNRdR = zeros(length(xlim),length(ylim),length(zlim));
for z=1:length(zlim)
    for y=1:length(ylim)
        for x=1:length(xlim)
            SNRdR(x,y,z) = SNRu(x,y,z)/sqrt(Rx+Ry)/gdR(x,y,z);
        end
    end
end
end