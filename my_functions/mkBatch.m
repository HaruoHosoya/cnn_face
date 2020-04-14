function [cdata_batch, no_batch] = mkBatch(cdata, batch_size)


num_cdata = size(cdata,4);
no_cbatch = floor(num_cdata/batch_size);
remi = rem(num_cdata,batch_size);
cdata_batch={};

for i = 1:no_cbatch
	cdata_batch{i} = cdata(:,:,:,(i-1)*batch_size+1:batch_size*i);

end

if exist('remi', 'var') ==1
	cdata_batch{no_cbatch+1} = cdata(:,:,:,batch_size*no_cbatch+1 : end);
end

no_batch= no_cbatch +1;
end