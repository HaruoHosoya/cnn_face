function layer_counted = layers_count(netw, layer_type)
    layer_counted = 0;
    for layer = 1:length(netw.Layers)
        layerType = class(netw.Layers(layer));
        if isequal(layerType(16:end),layer_type)                
            layer_counted = layer_counted+1;
        end
    end
end