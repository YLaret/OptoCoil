function [SNRu,rfmean] = calculate_snr_unaccelerated_MARIE_v3(nCoil,B,q,usnr_map,idS,al)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%% *** CALCULATE SNR (unaccelerated) *** %%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% input (nCoil,mask,xlim,ylim,zlim,B,q)
% output (SNRu)
xl = al(1);
yl = al(2);
zl = al(3);
SNRu = zeros(xl,yl,zl);
b1target = 1;
rfmean = zeros(nCoil,1);
%rfmean = zeros(1,nCoil);
% find perfect weights for each voxel
%Bx = reshape(B(:,:,:,1,:),xl*yl*zl,1,nCoil);
%By = reshape(B(:,:,:,2,:),xl*yl*zl,1,nCoil);

parfor i = 1:size(idS,1)
    %tic
    %disp(fprintf("[%d/%d]",i,size(idS)))
    % using optimization from uiSNR by Guerin et al
    %A = squeeze(((Bx(idS(i),:)-1i*By(idS(i),:))/(2)));
    A = B(i,:);
    A2 = [q A.' ; conj(A) 0];
    b2 = [zeros(nCoil,1); b1target];

    sol = A2 \ b2;
    %sol = pinv(A2) * b2;

    rf = conj( sol(1:nCoil) );

    b1=A*rf;
    loss_=real( (rf.')*q*conj(rf) );
    tmp(i) = real(b1)/sqrt(loss_);
    %SNRu(idS(i)) = real(b1)/sqrt(loss_);
    % see relative coil strength with respect to usnr
    b11=A.'.*rf;
    SNRuu = real(b11)/sqrt(loss_);
    %rfmean = rfmean + SNRuu/usnr_map(i);
    rfmean = rfmean + A.';%/usnr_map(i);
    %toc
end
SNRu(idS) = tmp;
end