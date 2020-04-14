function tnsr = mktnsr (imgs_all)

num_imgs=size(imgs_all,3);
size1= size(imgs_all, 1);

tnsr = zeros(size1,size1, 3, num_imgs);

for k = 1:num_imgs
	imges = imgs_all(:,:,k);
	imges=imresize(imges, [size1 size1]);
	imges=repmat(imges,[1 1 3]);
	tnsr(:,:,:,k) = imges;
end
 





