
dataPath = '../image_database/VggFace';
% dataPath = '../image_database/dtdDatabase';
checkPath = 'checkpoint';
imds = imageDatastore(dataPath, ...
    'IncludeSubfolders',true, ...
    'LabelSource','foldernames');

% figure
% numImages = 10000;
% perm = randperm(numImages,20);
% for i = 1:20
%     subplot(4,5,i);
%     imshow(augimdsTrain.Files{perm(i)});
% end

% netPath = '../../Nets/Caffe/';
% % protofile = fullfile(netPath,'vgg_face_caffe', 'VGG_FACE_deploy.prototxt');
% protofile = fullfile(netPath, 'alexnet_caffe_imagenet', 'alexnet_caffe_deploy.prototxt');
% importedLayer = importCaffeLayers(protofile)';
% imageSize = importedLayer(1).InputSize;

% importedLayer= alexnet;
% importedLayer = importedLayer.Layers;
% imageSize = importedLayer(1).InputSize;

numClasses = 2614;
% numClasses = 47;
imageSize = [224 224 3];

%%

% run Vgg_face_layers.m

[imdsTrain,imdsTest] = splitEachLabel(imds,0.9,'randomize');

imageAugmenter = imageDataAugmenter(...
        'RandXReflection', true,...
        'RandXTranslation', [-30 30], ...
        'RandYTranslation', [-30 30],...    
        'RandXScale', [0.25 1],...
        'RandYScale', [0.25 1]);
        
    
% 	'RandXTranslation', [-30 30], ...
% 	'RandYTranslation', [-30 30],...    
%     'RandXScale', [0.3 1],...
%     'RandYScale', [0.3 1]);

augimdsTrain = augmentedImageDatastore(imageSize(1:2),...
    imdsTrain, 'ColorPreprocessing', 'gray2rgb',...
    'DataAugmentation', imageAugmenter);
 
augimdsValidation = augmentedImageDatastore(imageSize(1:2),...
    imdsTest, 'ColorPreprocessing', 'gray2rgb');

% augimdsTrain = augmentedImageSource(imageSize(1:2),...
%   imdsTrain,'ColorPreprocessing', 'gray2rgb');
% 
% augimdsValidation = augmentedImageSource(imageSize(1:2),...
%   imdsTest, 'ColorPreprocessing', 'gray2rgb');


% previewAugImage = preview(augimdsTrain);
% figure; montage(previewAugImage.input);


%%
 
% layers = [ importedLayer(1:end-3)
%     fullyConnectedLayer(numClasses,'Name', 'fc8')
%     softmaxLayer('Name', 'prob')
%     classificationLayer('Name', 'output')];


%%
miniBatchSize = 1024; % 384 768 %1536

validationFrequency = floor(numel(imdsTrain.Labels)/miniBatchSize);


options = trainingOptions('sgdm', ...
    'MiniBatchSize',miniBatchSize, ... 
    'InitialLearnRate',eps, ... 
    'MaxEpochs', 1, ...
    'ExecutionEnvironment', 'multi-gpu',...
    'CheckpointPath', checkPath, ...
    'Plots','training-progress');


% , ...
%     'ValidationData', augimdsValidation,...
%     'ValidationFrequency', validationFrequency,...
%     'ValidationPatience', Inf

%     'OutputFcn', saveTraingPlot
% ,...
%     'LearnRateSchedule','piecewise', ...
%     'LearnRateDropFactor',0.1, ...
%     'LearnRateDropPeriod',8);


% options = trainingOptions('sgdm', ...
%     'MaxEpochs',20,...
%     'InitialLearnRate',1e-2, ...
%     'MiniBatchSize',768,...
%     'ExecutionEnvironment', 'multi-gpu',...
%     'CheckpointPath', checkPath, ...
%     'Plots','training-progress');

%     'ValidationData', augimdsValidation,...
%     'ValidationFrequency', 1000,...
%     'ValidationPatience', Inf,...


 net = trainNetwork(augimdsTrain,layers,options);
 
%%
%--Save network--
networkName = 
fullfileName = fullfile('../networks/mlabs/', 'networkName');
save(fullfileName, 'net');

%%
%%--Measure validation accuracy--
[YPred, scores] = classify(net,augimdsValidation, 'ExecutionEnvironment', 'gpu');
YTest = imdsTest.Labels;
accuracy = sum(YPred == YTest)/numel(YTest);
fprintf(sprintf('Validation accuracy = %f\n', accuracy));
%%
% function  saveTraingPlot() 
%     plotfig = findall(groot, 'Type', 'Figure')
%     savefig(plotfig);
% end








 
 
