function imgs_out=imresize_all(imgs,sz, varargin)

pr = inputParser;
pr.addParameter('pad', [] ,@isnumeric);
pr.parse(varargin{:});
options = pr.Results;

if ndims(imgs)==3
    [sy,sx,len]=size(imgs);
else
    [sy,sx,~,len]=size(imgs);
end;

% imgs_out=zeros(sz(1),sz(2),len);

for I=1:len
    if ndims(imgs)<=3
        im=imgs(:,:,I);
    else
        im=rgb2gray(imgs(:,:,:,I));
    end;

    im_ = imresize(im,sz);

    if ~isempty(options.pad)
    	im_ = padarray(im_, [0, 32], options.pad, 'both');
    end

    imgs_out(:,:,I)= im_;
end;

end


    