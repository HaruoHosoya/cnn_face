imageSize = [224 224 3];
numClasses = 2614;


layers = [...
	imageInputLayer(imageSize, 'Name', 'input')

	convolution2dLayer(11, 96, 'NumChannels', 3, 'Stride', 4, 'Name', 'conv1')
	leakyReluLayer('Name', 'Lrelu1')
	crossChannelNormalizationLayer(5, 'Name', 'norm1')	
	maxPooling2dLayer(3, 'Stride', 2, 'Name', 'pool1')

	convolution2dLayer(5, 256,'NumChannels', 48, 'Name', 'conv2', 'Padding', [2 2])
	leakyReluLayer('Name', 'Lrelu2')
	crossChannelNormalizationLayer(5, 'Name', 'norm2')	
	maxPooling2dLayer(3, 'Stride', 2, 'Name', 'pool2')

	convolution2dLayer(3, 384, 'NumChannels', 256, 'Name', 'conv3', 'Padding', [1 1])
	leakyReluLayer('Name', 'Lrelu3')
	convolution2dLayer(3, 384, 'NumChannels', 192, 'Name', 'conv4', 'Padding', [1 1])
	leakyReluLayer('Name', 'Lrelu4')
	convolution2dLayer(3, 256, 'NumChannels', 192, 'Name', 'conv5', 'Padding', [1 1])
	leakyReluLayer('Name', 'Lrelu5')
	maxPooling2dLayer(3, 'Stride', 2, 'Name', 'pool3')
	
	fullyConnectedLayer(4096, 'Name', 'fc6')
	leakyReluLayer('Name', 'Lrelu6')
	dropoutLayer('Name', 'drop6')
	fullyConnectedLayer(4096, 'Name', 'fc7')
	leakyReluLayer('Name', 'Lrelu7')
	dropoutLayer('Name', 'drop7')
	fullyConnectedLayer(numClasses, 'Name', 'fc8')
	softmaxLayer('Name', 'prob')
	classificationLayer('Name', 'Classification Output')];

	
