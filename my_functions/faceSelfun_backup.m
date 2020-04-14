	


	function [varargout]  = faceSelfun(resp_face,resp_noface, respToTraingImages)


	thrshld_value = 0.01;
    % thrshld_value = 0.1;

	% abs_resp_face = abs(resp_face);
	% abs_resp_noface = abs(resp_noface);

    
    avg_resp_face = mean(resp_face,2);
	avg_resp_nonface = mean(resp_noface,2);


	avg_minus = avg_resp_face - avg_resp_nonface;
	avg_plus = avg_resp_face + avg_resp_nonface;
	fsel_idx = avg_minus./avg_plus;

	face_nrns = find(fsel_idx >=1/3);
	% non_faces_nrns = find(fsel_idx <- 1/3);
	% non_faces_nrns = find(fsel_idx < 1/3 & fsel_idx > -1/3);
	non_faces_nrns = find(fsel_idx < 1/3);

	%new_addition

	resnsv_nrns = find(avg_resp_face > thrshld_value* respToTraingImages);
	new_face_nrns = face_nrns(ismember(face_nrns, resnsv_nrns));

	varargout = {new_face_nrns; non_faces_nrns};

end