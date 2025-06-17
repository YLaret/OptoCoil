function X = import_MARIE_data_v3(fieldfolder,coils,str)
tmp = load(sprintf("%s/%d%sField.mat",fieldfolder,coils(1),str));
if str == "E"
    X = zeros([1,size(tmp.E)]);
    X(1,:,:,:,:) = tmp.E;
    parfor i = 2:length(coils)
        tmp = load(sprintf("%s/%d%sField.mat",fieldfolder,coils(i),str));
        X(i,:,:,:,:) = tmp.E;
    end
elseif str == "B"
    X = zeros([size(tmp.B),1]);
    X(:,:,:,:,1) = tmp.B;
    parfor i = 2:length(coils)
        tmp = load(sprintf("%s/%d%sField.mat",fieldfolder,coils(i),str));
        X(:,:,:,:,i) = tmp.B;
    end
end