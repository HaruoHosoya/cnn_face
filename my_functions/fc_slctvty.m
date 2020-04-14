


run  ../vlfeat-0.9.20/toolbox/vl_setup.m
run ../matconvnet-1.0-beta24/matlab/vl_setupnn.m

net = load('../vgg-face.mat');
net = vl_simplenn_tidy(net);


ndata=reshape(ndata, [size(imgdata_filt,1), size(imgdata_filt,2), size(imgdata_filt,3)]);
ndata=single(ndata);
ndata = mktnsr(ndata);


odata=reshape(odata, [size(oimgdata_filt,1), size(oimgdata_filt,2), size(oimgdata_filt,3)]);
odata=single(odata);
odata = mktnsr(odata);


no_layer = 12;
respn = cell (1,no_layer);
respo = cell (1,no_layer);


num_nimgs = size(ndata,3);
num_oimgs = size(ndata,3);


fprintf('calculating network response to  natural imgs...\n');
parfor_progress(num_nimgs);

for k=1:num_nimgs

    nface1=ndata(:,:,k);
    imc=imresize(nface1, [224 224]);
    imc=repmat(imc,[1 1 3]);
    imc=single(imc);
    respn_ = vl_simplenn(net, imc) ; % netowork response to 'imgs'
    
    
    resn_ = cell (1, no_layer);
    
    for i = 1:no_layer;
        
        respn = respn_(i+20).x; 
        resn_{i} = respn(:);
   
        
    end
    
    respn = cellfun(@(x,y) [x y],respn, resn_,'UniformOutput', false);
    parfor_progress;
    
end

save('resp_all_nat.mat', 'respn','-v7.3');




fprintf('calculating network response to  natural imgs...\n');
parfor_progress(num_nimgs);

for k=1:num_oimgs

    oface1=odata(:,:,k);
    imc=imresize(oface1, [224 224]);
    imc=repmat(imc,[1 1 3]);
    imc=single(imc);
    respo_ = vl_simplenn(net, imc) ; % netowork response to 'imgs'
    
    
    resn_ = cell (1, no_layer);
    
    for i = 1:no_layer;
        
        respo = respo_(i+20).x; 
        reso_{i} = respo(:);  
        
    end
    
    respo = cellfun(@(x,y) [x y],respo, reso_,'UniformOutput', false);
    parfor_progress;
    
end

save('resp_all_obj.mat', 'respo','-v7.3');




