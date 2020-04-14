
function warp_im = affine_warp(im, from_pts, to_pts, tri)
%AFFINE_WARP Affine warp.
%   [WARP_IM] = AFFINE_WARP(IM,FROM_PTS,TO_PTS,TRI) 
%   returns an affine warp for each triangle in the triangulation from the
%   original image into a new shape using point correspondences defined 
%   in from_pts and to_pts (which are both n-by-2 matrices of (x,y) 
%   locations) and the triangulation structure tri.
%%
    warning off;
    warp_im = 0.5*ones(size(im));
    [h, w, channel] = size(im);
    [Y, X] = meshgrid(1:h, 1:w);
    %t(i) gives the index(into tri)of the first triangle containing (X(i),Y(i))
    t = mytsearch(to_pts(:, 1), to_pts(:, 2), tri, X, Y); %search triangulation
    tri_index_map = zeros(size(t));
    valid_tri_idx = ~isnan(t); % t(i) is NaN for points not in any triangle
    tri_index_map(valid_tri_idx) = t(valid_tri_idx);
    % inverse warp of all pixels
    for i = 1:size(tri,1) % for each triangle
        [col, row] = find(tri_index_map == i); % find out all points in it
        p2 = transpose([col, row, ones(size(col,1),1)]); % [x';y';1]
        % computing an affine transformation matrix A between two triangles
        A = computeAffine(from_pts(tri(i,:),:), to_pts(tri(i,:),:));
        p = pinv(A) * p2; % p2=Ap -> p=A^(-1)p2
        p = floor(p); % index should be integer

        % avoid out of bound
        % omit......

        indices2 = find((p(2, :)>size(im, 1)) | (p(2, :)<1));
        indices1 = find((p(1, :)>size(im, 2)) | (p(1, :)<1));
        p(:,[indices1,indices2]) = [];
        p2(:,[indices1,indices2]) =[];

    %     warp_im(p2(1,:),p2(2,:),:)=im(p(1,:),p(2,:),:); % large memory&time!

        p_ind = sub2ind([h, w], p(2,:), p(1,:)); % convert to linear indices
        p2_ind = sub2ind([h, w], p2(2,:), p2(1,:));    
        warp_im(p2_ind) = im(p_ind); % first channel

        if channel == 3
            warp_im(p2_ind + w*h) = im(p_ind + w*h); % second channel
            warp_im(p2_ind + 2*w*h) = im(p_ind + 2*w*h); % third channel
        end

    end
end
