function resp_ = fourd2twod(resp)

	[aa,bb,cc,dd] = size(resp);
	resp_ = reshape(resp, [aa*bb*cc, dd]);
	

end