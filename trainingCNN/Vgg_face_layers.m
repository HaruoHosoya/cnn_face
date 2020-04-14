imageSize = [224 224 3];
numClasses = 2614;

%%

% layers = [...
% 	imageInputLayer(imageSize, 'Name', 'input')
% 	convolution2dLayer(3, 64, 'Padding', [1 1], 'Name', 'conv1_1')
% 	reluLayer('Name', 'relu1_1')
% 	convolution2dLayer(3, 64, 'Padding', [1 1], 'Name', 'conv1_2')
% 	reluLayer('Name', 'relu1_2')
% 	maxPooling2dLayer(2, 'Stride', 2, 'Name', 'pool1')
% 
% 
% 	convolution2dLayer(3, 128, 'Padding', [1 1], 'Name', 'conv2_1')
% 	reluLayer('Name', 'relu2_1')
% 	convolution2dLayer(3, 128, 'Padding', [1 1], 'Name', 'conv2_2' )
% 	reluLayer('Name', 'relu2_2')
% 	maxPooling2dLayer(2, 'Stride', 2, 'Name', 'pool2')
% 
% 	convolution2dLayer(3, 256, 'Padding', [1 1], 'Name', 'conv3_1')
% 	reluLayer('Name', 'relu3_1')
% 	convolution2dLayer(3, 256, 'Padding', [1 1], 'Name', 'conv3_2' )
% 	reluLayer('Name', 'relu3_2')
% 	convolution2dLayer(3, 256, 'Padding', [1 1], 'Name', 'conv3_3' )
% 	reluLayer('Name', 'relu3_3')
% 	maxPooling2dLayer(2, 'Stride', 2, 'Name', 'pool3')
% 
% 	convolution2dLayer(3, 512, 'Padding', [1 1], 'Name', 'conv4_1')
% 	reluLayer('Name', 'relu4_1')
% 	convolution2dLayer(3, 512, 'Padding', [1 1], 'Name', 'conv4_2' )
% 	reluLayer('Name', 'relu4_2')
% 	convolution2dLayer(3, 512, 'Padding', [1 1], 'Name', 'conv4_3' )
% 	reluLayer('Name', 'relu4_3')
% 	maxPooling2dLayer(2, 'Stride', 2, 'Name', 'pool4')
% 
% 	convolution2dLayer(3, 512, 'Padding', [1 1], 'Name', 'conv5_1')
% 	reluLayer('Name', 'relu5_1')
% 	convolution2dLayer(3, 512, 'Padding', [1 1], 'Name', 'conv5_2' )
% 	reluLayer('Name', 'relu5_2')
% 	convolution2dLayer(3, 512, 'Padding', [1 1], 'Name', 'conv5_3' )
% 	reluLayer('Name', 'relu5_3')
% 	maxPooling2dLayer(2, 'Stride', 2, 'Name', 'pool5')
% 
% 	fullyConnectedLayer(4096, 'Name', 'fc6')
% 	reluLayer('Name', 'relu6')
% 	dropoutLayer('Name', 'drop6')
% 	fullyConnectedLayer(4096, 'Name', 'fc7')
% 	reluLayer('Name', 'relu7')
% 	dropoutLayer('Name', 'drop7')
% 	fullyConnectedLayer(numClasses, 'Name', 'fc8')
% 	softmaxLayer('Name', 'prob')
% 	classificationLayer('Name', 'output')];


%%

% layers = [...
% 	imageInputLayer(imageSize, 'Name', 'input')
% 	convolution2dLayer(3, 64, 'Padding', [1 1], 'Name', 'conv1_1')
% 	reluLayer('Name', 'relu1_1')
% 	maxPooling2dLayer(2, 'Stride', 2, 'Name', 'pool1')
% 
% 	convolution2dLayer(3, 128, 'Padding', [1 1], 'Name', 'conv2_1')
% 	reluLayer('Name', 'relu2_1')
% 	maxPooling2dLayer(2, 'Stride', 2, 'Name', 'pool2')
% 
% 	convolution2dLayer(3, 256, 'Padding', [1 1], 'Name', 'conv3_1')
% 	reluLayer('Name', 'relu3_1')
% 	maxPooling2dLayer(2, 'Stride', 2, 'Name', 'pool3')
% 
% 	convolution2dLayer(3, 512, 'Padding', [1 1], 'Name', 'conv4_1')
% 	reluLayer('Name', 'relu4_1')
% 	maxPooling2dLayer(2, 'Stride', 2, 'Name', 'pool4')
% 
% 	convolution2dLayer(3, 512, 'Padding', [1 1], 'Name', 'conv5_1')
% 	reluLayer('Name', 'relu5_1')
% 	maxPooling2dLayer(2, 'Stride', 2, 'Name', 'pool5')
% 
% 	fullyConnectedLayer(4096, 'Name', 'fc6')
% 	reluLayer('Name', 'relu6')
% 	dropoutLayer('Name', 'drop6')
% 	fullyConnectedLayer(4096, 'Name', 'fc7')
% 	reluLayer('Name', 'relu7')
% 	dropoutLayer('Name', 'drop7')
% 	fullyConnectedLayer(numClasses, 'Name', 'fc8')
% 	softmaxLayer('Name', 'prob')
% 	classificationLayer('Name', 'output')];


%%

layers = [...
	imageInputLayer(imageSize, 'Name', 'input')
	convolution2dLayer(3, 64, 'Padding', [1 1], 'Name', 'conv1_1')
	reluLayer('Name', 'relu1_1')
	convolution2dLayer(3, 64, 'Padding', [1 1], 'Name', 'conv1_2')
	reluLayer('Name', 'relu1_2')
	maxPooling2dLayer(2, 'Stride', 2, 'Name', 'pool1')


	convolution2dLayer(3, 128, 'Padding', [1 1], 'Name', 'conv2_1')
	reluLayer('Name', 'relu2_1')
	convolution2dLayer(3, 128, 'Padding', [1 1], 'Name', 'conv2_2' )
	reluLayer('Name', 'relu2_2')
	maxPooling2dLayer(2, 'Stride', 2, 'Name', 'pool2')

	convolution2dLayer(3, 256, 'Padding', [1 1], 'Name', 'conv3_1')
	reluLayer('Name', 'relu3_1')
	convolution2dLayer(3, 256, 'Padding', [1 1], 'Name', 'conv3_2' )
	reluLayer('Name', 'relu3_2')
	maxPooling2dLayer(2, 'Stride', 2, 'Name', 'pool3')

	convolution2dLayer(3, 512, 'Padding', [1 1], 'Name', 'conv4_1')
	reluLayer('Name', 'relu4_1')
	convolution2dLayer(3, 512, 'Padding', [1 1], 'Name', 'conv4_2' )
	reluLayer('Name', 'relu4_2')
	maxPooling2dLayer(2, 'Stride', 2, 'Name', 'pool4')

	convolution2dLayer(3, 512, 'Padding', [1 1], 'Name', 'conv5_1')
	reluLayer('Name', 'relu5_1')
	convolution2dLayer(3, 512, 'Padding', [1 1], 'Name', 'conv5_2' )
	reluLayer('Name', 'relu5_2')
	maxPooling2dLayer(2, 'Stride', 2, 'Name', 'pool5')

	fullyConnectedLayer(4096, 'Name', 'fc6')
	reluLayer('Name', 'relu6')
	dropoutLayer('Name', 'drop6')
	fullyConnectedLayer(4096, 'Name', 'fc7')
	reluLayer('Name', 'relu7')
	dropoutLayer('Name', 'drop7')
	fullyConnectedLayer(numClasses, 'Name', 'fc8')
	softmaxLayer('Name', 'prob')
	classificationLayer('Name', 'output')];
