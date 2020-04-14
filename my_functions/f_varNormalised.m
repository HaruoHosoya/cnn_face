
function [flData] = f_varNormalised(training_images)


training_images = single (training_images);
imsize = size(training_images);
inImsz = imsize(1);

if  ndims(training_images)>3
	images_ = reshape(training_images, [], size(training_images, 4));
	flData=bsxfun(@minus,images_,mean(images_,1));
	flData=bsxfun(@rdivide,flData,std(flData,0,1));
	flData=reshape(flData,inImsz,inImsz, 3, []);
else    
    images_ = reshape(training_images, [], size(training_images, 3));
	flData=bsxfun(@minus,images_,mean(images_,1));
	flData=bsxfun(@rdivide,flData,std(flData,0,1));
	flData=reshape(flData,inImsz,inImsz, []);

end