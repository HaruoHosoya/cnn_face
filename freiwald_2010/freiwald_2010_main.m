close all;
clear all;
initpath_freiwald_2010;
exEnviroment = 'cpu'; % 'gpu' or 'cpu'
halfwidth_compuutation = false;
plotOnly = true;


%%%%--Loding datas--
load('expdata/sorted_RSAfov.mat'); % experimental RSA data

%%Face-view stimuli for RSA computations 
path_stimuli = fullfile('input_data', 'face_views');
fvImDatabase = imageDatastore(path_stimuli);

%%Images for size and postion invariance computations
sizeVarImages = load('input_data/size_vari_images_2ndSet_norm.mat');
positionIndex = 4; % half of original images
positionImageSIze =224/8*positionIndex; % 256 for other positionIndex
varPositonfile = sprintf('posi_vari_images_%d_norm.mat', positionImageSIze);
PostVarImages = load(fullfile('input_data', varPositonfile));

sizeVarImages_ = sizeVarImages.all_imges;
PostVarImages_ = PostVarImages.all_imges_posi;

%%%--networks--
networks = {'alexnet224_aug025',...
'vgg_face_pretrained_remBase',...
'alexnet_caffe_remBase',...
'oxford102',...
'alexnet224_6layeredAug025',...
'alexnet224_7layeredAug025',...
'alexnet224_9layeredAug025',...
'alexnet224_10layeredAug025',...
'alexnet224_halfdepthAug025',...
'alexnet224_doubledepthAug025'...
'alexnet224_untrained'};
%%
% for alexnet_face network = netoworks(1)
for network = networks
%%
% netwrk = 'alexnet224_aug025'; % use for plot only
netwrk = char(network);
outputPath = 'output_data';
plotPath = fullfile(outputPath,sprintf( '%s/figures', netwrk));
dataPath = fullfile(outputPath,sprintf( '%s/data', netwrk));

if ~exist(plotPath, 'dir')
mkdir(plotPath);
end
if ~exist(dataPath, 'dir')
mkdir(dataPath);
end

% loadining network and obtaing its properties 
netw = load_network(netwrk);
inputSize = netw.Layers(1).InputSize;
networkDepth = length(netw.Layers); % network depth
recordLayerType = 'ReLULayer';
layerDepth = layers_count(netw, recordLayerType);
nLayers = layerDepth;

%%
% trying variance normalised images [leading to different results])
variance_normalised_faces = false;
if variance_normalised_faces     
    for i = 1: length(fvImDatabase.Files)
        baseFileName = fvImDatabase.Files{i};
        fvImage_i = imresize(imread( baseFileName), [224, 224]);
        fvImages(:,:,i) = fvImage_i;
    end
        fvImages_vn = f_varNormalised(fvImages);
        augFvImDatabase = mktnsr(fvImages_vn);
%         figure;montage(augFvImDatabase, 'Size', [25 8])
        n_images = size(augFvImDatabase, 4);
else    
    augFvImDatabase = augmentedImageDatastore(inputSize(1:2),...
        fvImDatabase, 'ColorPreprocessing', 'gray2rgb');
    n_images  = augFvImDatabase.NumObservations;
%     figure; montage(fvImDatabase.Files, 'Size', [25 8])
end

sizeVarImages = imresize(sizeVarImages_,inputSize(1:2));
PostVarImages = imresize(PostVarImages_,inputSize(1:2));

sizeVarImages = f_varNormalised(sizeVarImages);
PostVarImages = f_varNormalised(PostVarImages);

% figure; montage(sizeVarImages)
% figure; montage(PostVarImages)

augimdsSizeVarFaces = mktnsr(sizeVarImages);
augimdsPosiVarFaces = mktnsr(PostVarImages);

%%
% obtaining indices for the face-slective units from the loaded network
fs_idx_filename = sprintf('faceNeuronsAll_%s_%s.mat',netwrk,recordLayerType);
faceUnitsPath = fullfile('../networks/face_selective_indices/',fs_idx_filename);
if ~exist(faceUnitsPath, 'file')
    faceNeuronsAll = faceSelectiveUnits(netw, recordLayerType, 'large_net', true);
    save(faceUnitsPath, 'faceNeuronsAll'); 
    fprintf('calculated and saved face-selective indices\n')
else 
    fprintf('loading existing face-selective indices\n')
    load(faceUnitsPath);
end

reorder_indices = [3, 2, 1, 4, 5, 6, 7, 8]; % face-view order similar to freiwald 2010
boot_itr = 100;
[btd_cor_ml_all, btd_cor_al_all, btd_cor_am_all] = deal(zeros(boot_itr, nLayers));

layerName_All = cell(nLayers, 1);
corCoeffAll = zeros(n_images, n_images, nLayers);
VarianceAnalysisAll = cell(1,nLayers);
respBase_fs_all = cell(1,nLayers);
ml_corrSimalarity = [];
al_corrSimalarity = [];
am_corrSimalarity = [];
respFV_fs_all = cell(1, nLayers);
respSizeVar_fs_all = cell(1, nLayers);
respPosiVar_fs_all = cell(1, nLayers);
layerIndex = 0;
for layer = 1:networkDepth
    layerType = class(netw.Layers(layer));
    if isequal(layerType(16:end),recordLayerType)                
        layerIndex = layerIndex+1;
        layerName = netw.Layers(layer).Name;
        fprintf(sprintf('Computing %s output\n', layerName));
        layerName_All{layerIndex} = layerName;
        
        % Computing response of the network-
        respFV = activations(netw, augFvImDatabase, layer,...
            'OutputAs','row', 'ExecutionEnvironment', 'cpu');        
        respSizeVar = activations(netw, augimdsSizeVarFaces, layer,...
            'OutputAs', 'row');
        respPosiVar = activations(netw, augimdsPosiVarFaces, layer,...
            'OutputAs', 'row');
        respBase = activations(netw, single(zeros(inputSize)), layer,...
            'OutputAs', 'row');
        
        respBase_sub = repmat(respBase, [size(respFV, 1), 1]);

        % retaining response of face-selective units-
        faceNeurons = faceNeuronsAll{layerIndex};
        respFV_fs = respFV(:, faceNeurons)-respBase(:,faceNeurons);
        respBase_fs = respBase(:, faceNeurons);
        respSizeVar_fs = respSizeVar(:, faceNeurons);
        respPosiVar_fs = respPosiVar(:, faceNeurons);
        
        % sorting resoponse in similarly to expt.
        sorted_res = sort_res(respFV_fs, reorder_indices);
        respFVsortT = transpose(sorted_res);
                
        
        bootstraped_RSA = false;
        if bootstraped_RSA 
            % bootstrping for 100 times
            bootstat = bootstrp(boot_itr, @corr, respFVsortT, 'Options', statset('useParallel', true));
            btd_corCoreff = reshape(bootstat', [200, 200, boot_itr]);
            mean_btd_corCoeff = mean(btd_corCoreff, 3); % keeping mean of RSAs for display.
            corCoeffAll(:,:,layerIndex) = mean_btd_corCoeff; 

            % correlation of model RSAs and expt. RSAs
            cprd_btd_corCoeff = reshape(btd_corCoreff(1:175, 1:175, :), 175*175, boot_itr);
            boot_corr_corr_ml = corr([reshape(newML2, 175*175,1), cprd_btd_corCoeff]);
            boot_corr_corr_al = corr([reshape(newAL2, 175*175,1), cprd_btd_corCoeff]);
            boot_corr_corr_am = corr([reshape(newAM2, 175*175,1), cprd_btd_corCoeff]);     
            btd_cor_ml_all(:, layerIndex) = boot_corr_corr_ml(2:end,1);
            btd_cor_al_all(:, layerIndex) = boot_corr_corr_al(2:end,1);
            btd_cor_am_all(:, layerIndex) = boot_corr_corr_am(2:end,1);
        
        else            
            corCoeff = corr(respFVsortT);
            corCoeffAll(:,:,layerIndex) = corCoeff;
            crpd_corCoeff = corCoeff(1:175, 1:175);
            ml_corrSimalarity(layerIndex) = corr(crpd_corCoeff(:),newML2(:));
            al_corrSimalarity(layerIndex) = corr(crpd_corCoeff(:),newAL2(:));
            am_corrSimalarity(layerIndex) = corr(crpd_corCoeff(:),newAM2(:));
        end
        % size and positon invariance analysis
        varianceAnalysis = f_PopuVarianceEstimation(respSizeVar_fs, respPosiVar_fs);

        
        % halfwidth computation       
        if halfwidth_compuutation 
            [width_count, depth_count_profile, depth_count_Halfprofile]  = compute_tuning_halfwidth(sorted_res);
            width_count_all(:, layerIndex) = width_count;
            Depth_Count_all_profile(:, layerIndex) = depth_count_profile;
            Depth_Count_all_HalfProfile(:, layerIndex) = depth_count_Halfprofile;
        end 
        
        VarianceAnalysisAll{layerIndex} = varianceAnalysis;        
        respFV_fs_all{layerIndex}=respFV_fs;
        respSizeVar_fs_all{layerIndex} = respSizeVar_fs;
        respPosiVar_fs_all{layerIndex} = respPosiVar_fs;
        respBase_fs_all{layerIndex} = respBase_fs;
    end
end

if bootstraped_RSA
    ml_corrSimalarity = mean(btd_cor_ml_all);
    al_corrSimalarity = mean(btd_cor_al_all);
    am_corrSimalarity = mean(btd_cor_am_all);
end
%%

data_freiwald_2010.resp.respFV = respFV_fs_all;
data_freiwald_2010.resp.respSIzeVar = respSizeVar_fs_all;
data_freiwald_2010.resp.respPosiVar = respPosiVar_fs_all;
data_freiwald_2010.resp.respBase = respBase_fs_all;
data_freiwald_2010.corCoeffall = corCoeffAll;
data_freiwald_2010.varAnalysis = VarianceAnalysisAll;
data_freiwald_2010.layerName_All = layerName_All;
data_freiwald_2010.corrSimilarity.ml = ml_corrSimalarity;
data_freiwald_2010.corrSimilarity.al = al_corrSimalarity;
data_freiwald_2010.corrSimilarity.am = am_corrSimalarity;

save(fullfile(dataPath, 'data_freiwald_2010.mat'),'data_freiwald_2010');

%%
%%--load data
load(fullfile(dataPath, 'data_freiwald_2010.mat'));

%%--plot--
fprintf(sprintf('Generating plots\n'));
% figure; montage(corCoeffAll); colormap(flipud(gray))
plot_them_all_2010;

%% generated summary data
%%--saving summary data--
summarydata_2010.RSA.corr.ML = ml_corrSimalarity;
summarydata_2010.RSA.corr.AL = al_corrSimalarity;
summarydata_2010.RSA.corr.AM = am_corrSimalarity;
summarydata_2010.invaraince.SII = finalIndx;
save(fullfile(dataPath, 'summarydata_2010.mat'),'summarydata_2010');
fprintf('data saved\n');
close all;
end
%%
%%%%%%%---- utility functions ------ %%%%%%%%%%%
% fn used for view-wise sorting of response
function sorted_res =  sort_res(res, reorder)
    a = 1:size(res, 1);
    respFVsort = [];
    step_sort = 0:24;
    for i =1:length(reorder)
        a_val = a(step_sort*length(reorder)+reorder(i));
        respFVsort = [respFVsort, a_val];
    end
    sorted_res = res(respFVsort, :);   
end

% fn used for counting the number of layers in a network by layer type
function layer_counted = layers_count(netw, layer_type)
    layer_counted = 0;
    for layer = 1:length(netw.Layers)
        layerType = class(netw.Layers(layer));
        if isequal(layerType(16:end),layer_type)                
            layer_counted = layer_counted+1;
        end
    end
end