%%

netx = constructInitializedNetwork(layers);
save('alexnet_224_untrained_2.mat', 'netx');

function net = constructInitializedNetwork(layers)
layers = freezeLayers(layers);

X = rand(224, 224, 3);
Y = categorical(1,1:2614);

options = trainingOptions('sgdm','MaxEpochs',1,'InitialLearnRate',eps);
net = trainNetwork(X, Y,layers,options);

end

function layers = freezeLayers(layers)

for idx = 1:length(layers)
    if isprop(layers(idx),'WeightLearnRateFactor')
       layers(idx).WeightLearnRateFactor = 0;
    end

    if isprop(layers(idx),'BiasLearnRateFactor')
           layers(idx).BiasLearnRateFactor = 0; 
    end
end
end


%%