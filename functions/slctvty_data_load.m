
% % data prepartaion for to explore selctivity

% load the face and non_face data

df_imgs128 = h5read('../lfw/images.h5','/data');
oimgdata = h5read('~/datasets/caltech101/images64/images.h5','/data');

inImsz=224;
nImges=1000;


[ix,iy]=ndgrid(1:inImsz,1:inImsz);
filt=min(1,gauss2(ix,iy,111,112,70,70)*3);


% Preprocessing natural face images

face_imgs = df_imgs128(:,:,1:nImges);
imgdata=imresize_all(df_imgs128(20:99,26:105,:),[inImsz inImsz]);
imgdata_filt=bsxfun(@times,filt,imgdata);
ndata=reshape(imgdata_filt,size(imgdata,1)*size(imgdata,2),size(imgdata,3));
ndata=bsxfun(@minus,ndata,mean(ndata,1));
ndata=bsxfun(@rdivide,ndata,std(ndata,0,1));

ndata=reshape(ndata, [size(imgdata_filt,1), size(imgdata_filt,2), size(imgdata_filt,3)]);
ndata=single(ndata);


% Preprocessing non-face images

non_face_imgs = oimgdata(:,:,1:nImges);
oimgdata_filt=bsxfun(@times,filt,oimgdata);
odata=reshape(oimgdata_filt,size(oimgdata,1)*size(oimgdata,2),size(oimgdata,3));
odata=bsxfun(@minus,odata,mean(odata,1));
odata=bsxfun(@rdivide,odata,std(odata,0,1));

odata=reshape(odata, [size(oimgdata_filt,1), size(oimgdata_filt,2), size(oimgdata_filt,3)]);
odata=single(odata);