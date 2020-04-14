
layers = [...

	imageInputLayer([224 224 3], 'Name', 'input', 'Normalization', 'none')
    
	convolution2dLayer(11, 96, 'NumChannels', 3, 'Stride', 4, 'Name', 'conv1', 'BiasLearnRateFactor', 0)
	reluLayer('Name', 'relu1')
	crossChannelNormalizationLayer(5, 'Name', 'norm1')	
	maxPooling2dLayer(3, 'Stride', 2, 'Name', 'pool1')

    
	convolution2dLayer(5, 256,'NumChannels', 48, 'Name', 'conv2', 'Padding', [2 2],  'BiasLearnRateFactor', 0)
	reluLayer('Name', 'relu2')
	crossChannelNormalizationLayer(5, 'Name', 'norm2')	
	maxPooling2dLayer(3, 'Stride', 2, 'Name', 'pool2')
	
    
	convolution2dLayer(3, 384, 'NumChannels', 256, 'Name', 'conv3', 'Padding', [1 1], 'BiasLearnRateFactor', 0)
	reluLayer('Name', 'relu3')
    
	convolution2dLayer(3, 384, 'NumChannels', 192, 'Name', 'conv4', 'Padding', [1 1], 'BiasLearnRateFactor', 0)
	reluLayer('Name', 'relu4')
    
	convolution2dLayer(3, 256, 'NumChannels', 192, 'Name', 'conv5', 'Padding', [1 1], 'BiasLearnRateFactor', 0)
	reluLayer('Name', 'relu5')

	convolution2dLayer(3, 384, 'NumChannels', 192, 'Name', 'conv6', 'Padding', [1 1], 'BiasLearnRateFactor', 0)
	reluLayer('Name', 'relu6')
    
	convolution2dLayer(3, 256, 'NumChannels', 192, 'Name', 'conv7', 'Padding', [1 1], 'BiasLearnRateFactor', 0)
	reluLayer('Name', 'relu7')
    
	maxPooling2dLayer(3, 'Stride', 2, 'Name', 'pool3')
    
	fullyConnectedLayer(4096, 'Name', 'fc8', 'BiasLearnRateFactor', 0)
	reluLayer('Name', 'relu8')
	dropoutLayer('Name', 'drop8')
	fullyConnectedLayer(4096, 'Name', 'fc9', 'BiasLearnRateFactor', 0)
	reluLayer('Name', 'relu9')
	dropoutLayer('Name', 'drop9')
	fullyConnectedLayer(2614, 'Name', 'fc10', 'BiasLearnRateFactor', 0)
	softmaxLayer('Name', 'prob')
	classificationLayer('Name', 'Classification Output')];