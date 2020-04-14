


dataPath = '../image_database/VggFace';
checkPath = 'checkpoint';
imds = imageDatastore(dataPath, ...
    'IncludeSubfolders',true, ...
    'LabelSource','foldernames');

[imdsTrain,imdsValidation] = splitEachLabel(imds,0.9,'randomize');

% imageAugmenter = imageDataAugmenter(...
%         'RandXReflection', true,...  
% 		'RandXTranslation', [-30 30], ...
% 		'RandYTranslation', [-30 30],...    
% 	   	'RandXScale', [0.3 1],...
% 	    'RandYScale', [0.3 1]);
 %%   
imageSize = [224 224 3];

% 
% augimdsTrain = augmentedImageDatastore(imageSize(1:2),imdsTrain, 'ColorPreprocessing', 'gray2rgb');
% augimdsTest = augmentedImageDatastore(imageSize(1:2),imdsValidation, 'ColorPreprocessing', 'gray2rgb');
% 
augimdsTrain = augmentedImageSource(imageSize(1:2),imdsTrain, 'ColorPreprocessing', 'gray2rgb');
augimdsValidation = augmentedImageSource(imageSize(1:2),imdsValidation, 'ColorPreprocessing', 'gray2rgb');


f = figure;
for i=1:3
    subplot(1,3,i)
    xlabel('Iteration');
    ylabel('Training accuracy');
    lines(i) = animatedline;
end

D = parallel.pool.DataQueue;
afterEach(D, @(opts) updatePlot(lines, opts{:}));

netDepths = 1:3;
addAttachedFiles(gcp,mfilename);

for idx = 1:numel(netDepths)

    miniBatchSize = 128;
    initialLearnRate = 1e-1 * miniBatchSize/256; % Scale the learning rate according to the mini-batch size.
    validationFrequency = floor(numel(imdsTrain.Labels)/miniBatchSize);

    options = trainingOptions('sgdm', ...
        'OutputFcn',@(state) sendTrainingProgress(D,idx,state), ... % Set an output function to send intermediate results to the client.
	    'MiniBatchSize',miniBatchSize, ... % Set the corresponding MiniBatchSize in the sweep.
	    'InitialLearnRate',0.01, ... % Set the scaled learning rate.
	    'MaxEpochs',15, ...
	    'Shuffle','every-epoch', ...
	    'CheckpointPath', checkPath, ...
	    'Plots','training-progress');

    networksFuture(idx) = parfeval(@trainNetwork, 1, ...
    augimdsTrain, createNetworkArchitecture(netDepths(idx)), options);
end

accuraciesFuture = afterEach(networksFuture, @(network) mean(classify(network,augimdsValidation) == imdsValidation.Labels), 1);


function layers = createNetworkArchitecture(netDepth)
    imageSize = [224 224 3];
    numClasses = 2614;
    netWidth = 64; % netWidth controls the number of filters in a convolutional block

    layers = [
        imageInputLayer(imageSize)

        convolutionalBlock(netWidth,netDepth)
        maxPooling2dLayer(2,'Stride',2, 'Name', 'pool1')

        convolutionalBlock(2*netWidth,netDepth)
        maxPooling2dLayer(2,'Stride',2, 'Name', 'pool2')

        convolutionalBlock(4*netWidth,netDepth)
        maxPooling2dLayer(2,'Stride',2, 'Name', 'pool3')

        convolutionalBlock(8*netWidth,netDepth)
        maxPooling2dLayer(2,'Stride',2, 'Name', 'pool4')

        convolutionalBlock(8*netWidth,netDepth)
        maxPooling2dLayer(2,'Stride',2, 'Name', 'pool5')
        

		fullyConnectedLayer(4096, 'Name', 'fc6')
		reluLayer('Name', 'relu6')
		dropoutLayer('Name', 'drop6')
		fullyConnectedLayer(4096, 'Name', 'fc7')
		reluLayer('Name', 'relu7')
		dropoutLayer('Name', 'drop7')
		fullyConnectedLayer(numClasses, 'Name', 'fc8')
		softmaxLayer('Name', 'prob')
		classificationLayer('Name', 'output')
	    ];
end


function layers = convolutionalBlock(numFilters,numConvLayers)
    layers = [
        convolution2dLayer(3,numFilters,'Padding', [1 1], 'Normalization', 'none')
        reluLayer
    ];

    layers = repmat(layers,numConvLayers,1);
end

function sendTrainingProgress(D,idx,info)
    if info.State == "iteration"
        send(D,{idx,info.Iteration,info.TrainingAccuracy});
    end
end

function updatePlot(lines,idx,iter,acc)
    addpoints(lines(idx),iter,acc);
    drawnow limitrate nocallbacks
end