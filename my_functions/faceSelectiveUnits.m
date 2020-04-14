
function faceNeuronsAll = faceSelectiveUnits(netw, recordLayerType, varargin)

%%% function to obtain the indices of the face-selective units,
%%% arguments (network,  layer-type, and t_value (ranges 0-0.1)

    pr = inputParser;
    pr.addParameter('t_value', 0.0, @isnumeric);
    pr.addParameter('large_net', false, @islogical);
    pr.parse(varargin{:});
  
    options = pr.Results;

    layerDepth = layers_count(netw, recordLayerType);
    inputSize = netw.Layers(1).InputSize;
    networkDepth = length(netw.Layers); % network depth
    databasePath = '../imageDatabase';
    faceImage_ = load(fullfile(databasePath, 'face_256_color_50', 'color_image.mat'));
    nofaceImage_ = load(fullfile(databasePath, 'noface_256_color_50', 'color_image.mat'));
    faceImage = faceImage_.color_image;
    nofaceImage = nofaceImage_.color_image;

    faceImage = f_varNormalised(faceImage);
    nofaceImage = f_varNormalised(nofaceImage);
    
    augimdsFace = imresize(faceImage,inputSize(1:2));
    augimdsNoFace = imresize(nofaceImage,inputSize(1:2));
    
    faceNeuronsAll = cell(1, layerDepth);
    layerIndex = 0; 
    for layer = 1: networkDepth       
        layerType = class(netw.Layers(layer));        
        if isequal(layerType(16:end),recordLayerType)
            layerIndex = layerIndex+1;
            respFace = activations(netw, augimdsFace, layer,...
                'OutputAs', 'row');
            respNoFace = activations(netw, augimdsNoFace, layer,...
                'OutputAs','row');
            respBase = activations(netw, single(zeros(inputSize)), layer,...
                'OutputAs', 'row');       
            respBase_sub = repmat(respBase, [size(respFace, 1), 1]); 
            netRespFace = respFace -respBase_sub ;
            netRespNoFace = respNoFace - respBase_sub;                 
            % Estimate face-selective neurons (on efi images)
            [faceNeurons, ~] = faceSelective(netRespFace,netRespNoFace, options.t_value);
            
            if options.large_net 
                if length(faceNeurons)>30000
                    faceNeurons = randperm(length(faceNeurons), 30000);
                end
            end
            faceNeuronsAll{layerIndex} = faceNeurons;
        end
    end
end

%--------------------------------------------------------
function [varargout]  = faceSelective(netRespFace,netRespNoFace,thrshldValue)

%---------------------------------------------------------

%     absRespFace = abs(respFace);
%     absRespNoFace = abs(respNoFace);
        
    absRespFace = netRespFace;
    absRespNoFace = netRespNoFace;
        
    avg_resp_face = mean(absRespFace,1);
    avg_resp_nonface = mean(absRespNoFace,1);

    avg_minus = avg_resp_face - avg_resp_nonface;
    avg_plus = avg_resp_face + avg_resp_nonface;
    fsel_idx = avg_minus./avg_plus;
    
    posit_negat_combi = sign(avg_resp_face)>0 & sign(avg_resp_nonface) < 0;
	negative_positve_combi = sign(avg_resp_face)<0 & sign(avg_resp_nonface) > 0;

	fsel_idx(posit_negat_combi) = 1;
	fsel_idx(negative_positve_combi) = -1; %% Friewald 2010 

    face_nrns = find(fsel_idx >=1/3);
    non_faces_nrns = find(fsel_idx < 1/3);
    
    % thresldVale = 0.05;
%     thrshldValue = 0.0; % used for vgg_face in the manuscript

    resnsv_nrns = find(avg_resp_face > max(max(absRespFace,[],1))*thrshldValue);
    new_face_nrns = intersect(face_nrns, resnsv_nrns);

    varargout = {new_face_nrns; non_faces_nrns};
end
