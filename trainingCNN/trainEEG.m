%%

train_from_scracth = true;

basePath = '../image_database/basel_face_model/bfmGenerated';
dataPath = fullfile(basePath, 'resized_faces');
featPath = fullfile(basePath, 'bfmFeatures.mat');
load(featPath);

% sorting files names in natural order

S = dir(fullfile(dataPath,'*.jpg'));
N = natsortfiles({S.name});
dataPath_sorted = cellfun(@(n)fullfile(dataPath,n),N,'uni',0);
features = transpose(bfmFeatures); % multiplying by 10 for large gradient

imds = imageDatastore(dataPath_sorted);

imagePath = imds.Files;
data_table = table(imagePath, features);

train_dTable = data_table(1:190000, :);
test_dTavle = data_table(190001:end, :);

imageSize = [227, 227, 3];
nFeatures = size(features, 2);
%% 

% 
% nImages = 50000;
% images = zeros([imageSize,nImages]);
% 
% for i = 1:nImages
%     image = single(imread(dataPath_sorted{i}));
%     mean_image=mean(image(:));
%     std_image=std(image(:));
%     image=image-mean_image;
%     image=image/std_image;
%     image=reshape(image, [size(image,1), size(image,2), size(image,3)]);    
%     images(:,:,:, i) = image;
% end

%%

if train_from_scracth
    
layers = [...
    
    imageInputLayer([227 227 3], 'Name', 'input', 'Normalization', 'none')
    
	convolution2dLayer(11, 96, 'NumChannels', 3, 'Stride', 4, 'Name', 'conv1', 'BiasLearnRateFactor', 0)
	reluLayer('Name', 'relu1')
	crossChannelNormalizationLayer(5, 'Name', 'norm1')	
	maxPooling2dLayer(3, 'Stride', 2, 'Name', 'pool1')

    
	convolution2dLayer(5, 256,'NumChannels', 96, 'Name', 'conv2', 'Padding', [2 2],  'BiasLearnRateFactor', 0)
	reluLayer('Name', 'relu2')
	crossChannelNormalizationLayer(5, 'Name', 'norm2')	
	maxPooling2dLayer(3, 'Stride', 2, 'Name', 'pool2')
	
    
	convolution2dLayer(3, 384, 'NumChannels', 256, 'Name', 'conv3', 'Padding', [1 1], 'BiasLearnRateFactor', 0)
	reluLayer('Name', 'relu3')
    
	convolution2dLayer(3, 384, 'NumChannels', 384, 'Name', 'conv4', 'Padding', [1 1], 'BiasLearnRateFactor', 0)
	reluLayer('Name', 'relu4')
    
	convolution2dLayer(3, 256, 'NumChannels', 384, 'Name', 'conv5', 'Padding', [1 1], 'BiasLearnRateFactor', 0)
	reluLayer('Name', 'relu5')
    
	maxPooling2dLayer(3, 'Stride', 2, 'Name', 'pool3')
    
	fullyConnectedLayer(4096, 'Name', 'fc6', 'BiasLearnRateFactor', 0)
	reluLayer('Name', 'relu6')
	dropoutLayer('Name', 'drop6')
	fullyConnectedLayer(4096, 'Name', 'fc7', 'BiasLearnRateFactor', 0)
	reluLayer('Name', 'relu7')
	dropoutLayer('Name', 'drop7')
    
% 	fullyConnectedLayer(4096, 'Name', 'fc8', 'BiasLearnRateFactor', 0)
% 	reluLayer('Name', 'relu8')
% 	dropoutLayer('Name', 'drop8')
    
    fullyConnectedLayer(nFeatures, 'Name', 'fc9')
%     reluLayer('Name', 'relu8')
   	regressionLayer('Name', 'Regression Output')];
else
    net = alexnet;
    LayersTrasnfer = net.Layers(1:end-3);
    Layers = [
        LayersTrasnfer
        fullyConnectedLayer(nFeatures, 'WeightLearnRateFactor', 20,...
        'BiasLearnRateFactor', 20, 'Name', 'fc8')
        regressionLayer('Name', 'Regression Output')];
end

miniBatchSize  = 128*4;
options = trainingOptions('sgdm', ...
    'MiniBatchSize',miniBatchSize, ...
    'MaxEpochs',30, ...
    'InitialLearnRate',1e-2, ...
    'ExecutionEnvironment', 'multi-gpu',...
    'Plots','training-progress');

net = trainNetwork(train_dTable, layers,options);
% net = trainNetwork(images, features(1:nImages, :), layers,options);
save('eig_net_plus.mat', 'net');
