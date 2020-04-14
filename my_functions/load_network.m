
function netw = load_network(netwrk) 

caffePath = '../networks/caffe';
kerasPath = '../networks/keras';
netPath = '../networks/mlabs';

switch(netwrk)
    case 'alexnet_pretrained'
        netw = alexnet; 

    case 'vgg_face_pretrained_remBase'
        protofile = fullfile(caffePath, 'vgg_face_caffe', 'VGG_FACE_deploy.prototxt');
        datafile = fullfile(caffePath,'vgg_face_caffe','VGG_FACE.caffemodel');  
        netw = importCaffeNetwork(protofile, datafile);

    case 'PAM_alexnet'
        protofile = fullfile(caffePath, 'PAM_frontal_AlexNet', 'PAM_frontal_deploy.prototxt');
        datafile = fullfile(caffePath,'PAM_frontal_AlexNet','PAM_frontal.caffemodel');  
        netw = importCaffeNetwork(protofile, datafile);

    case 'PAM_vgg'
        protofile = fullfile(caffePath, 'PAM_frontal_VGGNet', 'PAM_frontal_deploy.prototxt');
        datafile = fullfile(caffePath,'PAM_frontal_VGGNet','PAM_frontal_VGG19.caffemodel');  
        netw = importCaffeNetwork(protofile, datafile);

    case 'alexnet_caffe_remBase'
        protofile = fullfile(caffePath, 'alexnet_caffe_imagenet', 'alexnet_caffe_deploy.prototxt');
        datafile = fullfile(caffePath,'alexnet_caffe_imagenet','alexnet_caffe.caffemodel');  
        netw = importCaffeNetwork(protofile, datafile);
       
    case 'oxford102'       
        protofile = fullfile(caffePath, 'oxford102', 'oxford102.prototxt');
        datafile = fullfile(caffePath,'oxford102','oxford102.caffemodel');  
        netw = importCaffeNetwork(protofile, datafile); 
        
    case 'vggtexture'
        protofile = fullfile(caffePath, 'vggtexture', 'vgg_texture_deploy.prototxt');
        datafile = fullfile(caffePath,'vggtexture','vgg_texture.caffemodel');  
        netw = importCaffeNetwork(protofile, datafile); 
        
    case 'alexnet_trained'
        netw = load(fullfile(netPath, 'alexnet_vggFace_2.mat'));
        netw = netw.net;

    case 'vgg_face_trained'
        netw = load(fullfile(netPath, 'vgg16_vggFace_2.mat'));
        netw = netw.net;
        
    case 'vgg8_trained'
        netw = load(fullfile(netPath, 'vgg8_vggFace_1.mat'));
        netw=netw.net;
        
    case 'alexnet224_augmented'
        netw = load(fullfile(netPath, 'alexnet224_vggFace_augmeted_52.mat'));
        netw=netw.net;
        
    case 'alexnet224'
        netw = load(fullfile(netPath, 'alexnet224_vggface_78.mat'));
        netw=netw.net;  
        
    case 'alexnet224_leakyRelu'
        netw = load(fullfile(netPath, 'alexnet224_vggface_leakyRelu_78.mat'));
        netw=netw.net;
        recordLayerType = 'LeakyReLULayer';
        
    case 'alexnet224_noBiasNorm'        
        netw = load(fullfile(netPath, 'alexnet224_vggFace_noBiasNorm_77.mat'));
        netw=netw.net;
       
    case 'alexnet224_augNobais'        
        netw = load(fullfile(netPath, 'alexnet224_vggface_augmNoBiasNorm_70.mat'));
        netw=netw.net;
         
    case 'alexnet224_aug025'
        netw = load(fullfile(netPath, 'alexnet224_vggface_aug025NoBiasNorm_65.mat'));
        netw=netw.net;
        
    case 'alexnet224_aug010'
        netw = load(fullfile(netPath, 'alexnet224_vggface_aug010NoBiasNorm_60.mat'));
        netw=netw.net;

    case 'alexnet227_dtdTexture'        
        netw = load(fullfile(netPath, 'alexnet227_dtd_30.mat'));
        netw=netw.net;
        
    case 'alexnet224_6layered'        
        netw = load(fullfile(netPath, 'alexnet224_vggface_6layered_73.mat'));
        netw=netw.net;
        
    case 'alexnet224_7layered'        
        netw = load(fullfile(netPath, 'alexnet224_vggface_7layered_75.mat'));
        netw=netw.net;

    case 'alexnet224_9layered'
        netw = load(fullfile(netPath, 'alexnet224_vggface_9layered_75.mat'));
        netw=netw.net;
              
    case 'alexnet224_10layered'
        netw = load(fullfile(netPath, 'alexnet224_vggface_10layered_73.mat'));
        netw=netw.net;
      
    case 'alexnet224_6layeredAug025'        
        netw = load(fullfile(netPath, 'alexnet224_vggface_6layered_55_aug025.mat'));
        netw=netw.net;
        
    case 'alexnet224_7layeredAug025'        
        netw = load(fullfile(netPath, 'alexnet224_vggface_7layered_60_aug025.mat'));
        netw=netw.net;

    case 'alexnet224_9layeredAug025'
        netw = load(fullfile(netPath, 'alexnet224_vggface_9layered_62_aug025.mat'));
        netw=netw.net;
        
    case 'alexnet224_9layeredAug025_maxIncluded'
        netw = load(fullfile(netPath, 'alexnet224_vggface_9layered_62_aug025_maxInclude.mat'));
        netw=netw.net;
        
    case 'alexnet224_10layeredAug025'
        netw = load(fullfile(netPath, 'alexnet224_vggface_10layered_63_aug025.mat'));
        netw=netw.net;
        
    case 'alexnet224_halfdepthAug025'        
        netw = load(fullfile(netPath, 'alexnet224_vggface_halfwidth_64_aug025.mat'));
        netw=netw.net;

    case 'alexnet224_doubledepthAug025'        
        netw = load(fullfile(netPath, 'alexnet224_vggface_doublewidth_70_aug025.mat'));
        netw=netw.net;
       
    case 'alexnet224_untrained'        
        netw = load(fullfile(netPath, 'alexnet224_untrained_2.mat'));
        netw=netw.netx;
        
	case 'alexbet224_10pDataSize'
        netw = load(fullfile(netPath, 'alexnet224_vggface_datasize10p_77.mat'));
        netw=netw.net;
        
    case 'alexnet224_augmented_keras'
        netw = importKerasNetwork(fullfile(kerasPath, 'keras_alexnetVggFace_test.h5'),...
            'OutputLayerType', 'classification');
        
    case 'alexnet_caffe_remBase_withNoise'
        protofile = fullfile(caffePath, 'alexnet_caffe_imagenet', 'alexnet_caffe_deploy.prototxt');
        datafile = fullfile(caffePath,'alexnet_caffe_imagenet','alexnet_caffe.caffemodel');  
        netw = importCaffeNetwork(protofile, datafile);

    case 'eig_net'
        netw = load(fullfile(netPath, 'eig_net.mat'));
        netw=netw.net;

    case 'eig_net_plus'
        netw = load(fullfile(netPath, 'eig_net_plus.mat'));
        netw=netw.net;

end

fprintf(sprintf('%s network loaded\n', netwrk)); 


