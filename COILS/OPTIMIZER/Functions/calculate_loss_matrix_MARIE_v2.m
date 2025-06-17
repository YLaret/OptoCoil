function [q,LOSS] = calculate_loss_matrix_MARIE_v2(nCoil,stepsize,E,sigma_e)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%% *** CALCULATE LOSS MATRIX *** %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% input (nCoil,stepsize,E)
% output (q)
%q = zeros(nCoil,nCoil);

nC = size(E(:,:,:,:,:),1);
nx = size(E(:,:,:,:,:),2);
ny = size(E(:,:,:,:,:),3);
nz = size(E(:,:,:,:,:),4);
%{
for z = 1:nz
    for y = 1:ny
        for x = 1:nx
            %[x, y, z] = ind2sub([nx, ny, nz],i);
            Etmp = reshape(E(:,x,y,z,:),[nCoil,3]);
            q = q + (Etmp*Etmp')*sigma_e(x,y,z);
        end
    end
end
q = q*(stepsize^3);
%}
Ebasis = reshape(E,nC,nx*ny*nz,3);
pvol = stepsize^3;
sigma_e = reshape(sigma_e,nx*ny*nz,1);
SIGDIAG = spdiags(sigma_e,0,nx*ny*nz,nx*ny*nz) * pvol;
LOSS = (squeeze(Ebasis(:,:,1)))*(SIGDIAG*(squeeze(Ebasis(:,:,1))')) + (squeeze(Ebasis(:,:,2)))*(SIGDIAG*(squeeze(Ebasis(:,:,2))')) + (squeeze(Ebasis(:,:,3)))*(SIGDIAG*(squeeze(Ebasis(:,:,3))'));
q = LOSS;
