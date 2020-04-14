

% Face selective neurons

function [sel_data] = faceSelFun(resp_face, resp_cface, resp_noface, respToTraingImages)


	thrshld_value = 0.01;

	[face_nrns, non_faces_nrns] = faceSel(resp_face,resp_noface, respToTraingImages,thrshld_value);
    [cface_nrns, non_cfaces_nrns]=faceSel(resp_cface,resp_noface, respToTraingImages,thrshld_value);

	comm_nrns = intersect(cface_nrns, face_nrns));


	num_face_nrns = length (face_nrns);
	num_non_face_nrns = length (non_faces_nrns);
	num_cface_nrns = length(cface_nrns);
	num_non_cface_nrns = length (non_cfaces_nrns);
	num_common=length(comm_nrns);

	sel_data.nmbrs.tot_nrns = size(resp_face,1);
    sel_data.nmbrs.face_nrns = num_face_nrns;
    sel_data.nmbrs.cface_nrns = num_cface_nrns;
    sel_data.nmbrs.comm_nrns = num_common;
    sel_data.nmbrs.noface_nrns = num_non_face_nrns;
    sel_data.nmbrs.noCface_nrns = num_non_cface_nrns;


    sel_data.index.face_nrns = face_nrns;
    sel_data.index.cface_nrns = cface_nrns;
    sel_data.index.comm_nrns = comm_nrns;

end

%--------------------------------------------------------
function [varargout]  = faceSel(resp_face,resp_noface, respToTraingImages, thrshld_value)
%---------------------------------------------------------

    
    avg_resp_face = mean(resp_face,2);
	avg_resp_nonface = mean(resp_noface,2);


	avg_minus = avg_resp_face - avg_resp_nonface;
	avg_plus = avg_resp_face + avg_resp_nonface;
	fsel_idx = avg_minus./avg_plus;

	posit_negat_combi = sign(avg_resp_face)>0 & sign(avg_resp_nonface) < 0;
	negative_positve_combi = sign(avg_resp_face)<0 & sign(avg_resp_nonface) > 0;

	fsel_idx(posit_negat_combi) = 1;
	fsel_idx(negative_positve_combi) = -1; %% Friewald 2010 

	face_nrns = find(fsel_idx >=1/3);
	% non_faces_nrns = find(fsel_idx <- 1/3);
	% non_faces_nrns = find(fsel_idx < 1/3 & fsel_idx > -1/3);
	non_faces_nrns = find(fsel_idx < 1/3);

	%new_addition

	resnsv_nrns = find(avg_resp_face > thrshld_value* respToTraingImages);
	new_face_nrns = intersect(face_nrns, resnsv_nrns);

	varargout = {new_face_nrns; non_faces_nrns};

end

