
imageSize = [224 224 3];
numClasses = 2614;
layers = [...

	imageInputLayer([224 224 3], 'Name', 'input', 'Normalization', 'none')
    
	convolution2dLayer(11, 96/2, 'NumChannels', 3, 'Stride', 4, 'Name', 'conv1', 'BiasLearnRateFactor', 0)
	reluLayer('Name', 'relu1')
	crossChannelNormalizationLayer(5, 'Name', 'norm1')	
	maxPooling2dLayer(3, 'Stride', 2, 'Name', 'pool1')

    
	convolution2dLayer(5, 256/2,'NumChannels', 48, 'Name', 'conv2', 'Padding', [2 2],  'BiasLearnRateFactor', 0)
	reluLayer('Name', 'relu2')
	crossChannelNormalizationLayer(5, 'Name', 'norm2')	
	maxPooling2dLayer(3, 'Stride', 2, 'Name', 'pool2')
	
    
	convolution2dLayer(3, 384/2, 'NumChannels', 256/2, 'Name', 'conv3', 'Padding', [1 1], 'BiasLearnRateFactor', 0)
	reluLayer('Name', 'relu3')
    
	convolution2dLayer(3, 384/2, 'NumChannels', 192, 'Name', 'conv4', 'Padding', [1 1], 'BiasLearnRateFactor', 0)
	reluLayer('Name', 'relu4')
    
	convolution2dLayer(3, 256/2, 'NumChannels', 192, 'Name', 'conv5', 'Padding', [1 1], 'BiasLearnRateFactor', 0)
	reluLayer('Name', 'relu5')
    
	maxPooling2dLayer(3, 'Stride', 2, 'Name', 'pool3')
    
	fullyConnectedLayer(4096/2, 'Name', 'fc6', 'BiasLearnRateFactor', 0)
	reluLayer('Name', 'relu6')
	dropoutLayer('Name', 'drop6')
	fullyConnectedLayer(4096/2, 'Name', 'fc7', 'BiasLearnRateFactor', 0)
	reluLayer('Name', 'relu7')
	dropoutLayer('Name', 'drop7')
	fullyConnectedLayer(numClasses, 'Name', 'fc8', 'BiasLearnRateFactor', 0)
	softmaxLayer('Name', 'prob')
	classificationLayer('Name', 'Classification Output')];