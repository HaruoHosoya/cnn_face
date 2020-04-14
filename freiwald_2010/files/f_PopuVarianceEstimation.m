function avgRespVar = f_PopuVarianceEstimation(respSizeVar_fs, respPosiVar_fs)
%%
respSizeVar_ini = respSizeVar_fs';
respPosiVar_ini = respPosiVar_fs';

% removing not responding neurons;
respSizeVar_ini_nz = respSizeVar_ini(any(respSizeVar_ini, 2), :);
respPosiVar_ini_nz = respPosiVar_ini(any(respPosiVar_ini, 2), :);

%%
sz_Size_var = size(respSizeVar_ini_nz, 2);
sz_Pos_var = size(respPosiVar_ini_nz, 2);

itr_size = sz_Size_var/40;

for j = 1:sz_Size_var/40

    idx1 = 40*(j-1)+1;
    idx2 = (idx1+ 40) -1;
    resp_size_var = respSizeVar_ini_nz(:, idx1:idx2);
            
    avg_face_size_resp(j) = mean(mean(resp_size_var(:,1:24)));
    avg_noface_size_resp(j) = mean(mean(resp_size_var(:, 25:40)));
end

%%
resp_hor_posi_var_ = respPosiVar_ini(:,1:200);
resp_ver_posi_var_ = respPosiVar_ini(:,201:400);
    
%%%%% calculating average response corresponding to position variation
for j = 1:sz_Pos_var/(40*2)

    idx1 = 40*(j-1)+1;
	idx2 = (idx1+ 40) -1;
	
    resp_hor_posi_var= resp_hor_posi_var_(:, idx1:idx2);
	resp_ver_posi_var= resp_ver_posi_var_(:, idx1:idx2);
	
    avg_face_posi_hor_resp(j) = mean(mean(resp_hor_posi_var(:,1:24)));
    avg_face_posi_ver_resp(j) = mean(mean(resp_ver_posi_var(:,1:24)));

    avg_noface_posi_hor_resp(j) = mean(mean(resp_hor_posi_var(:, 25:40)));
    avg_noface_posi_ver_resp(j) = mean(mean(resp_ver_posi_var(:, 25:40)));
end
    
%%
%%% calculating invariant identity index    
avg_coCoeff_size = [];
for l=1:size(respSizeVar_ini_nz, 1)    
    resp_per_neruons = respSizeVar_ini_nz(l,:);
    resp_per_neruons = resp_per_neruons';
    respMatrix_perneuron = reshape(resp_per_neruons, 40, []);
    coCoeff_per_neurons = corrcoef(respMatrix_perneuron);
    temp_vect_1 = coCoeff_per_neurons(2:end,1);
    avg_coCoeff_per_neurrons = nanmean(temp_vect_1);
    avg_coCoeff_size(l) = avg_coCoeff_per_neurrons;
end

%%
avg_coCoeff_posi =[];

for k=1:size(respPosiVar_ini_nz, 1)
	resp_per_neruons_posi = respPosiVar_ini_nz(k,:);
	resp_per_neruons_posi = resp_per_neruons_posi';
	respMatrix_perneuron_posi = reshape(resp_per_neruons_posi, 40, []);
	coCoeff_per_neurons_posi = corrcoef(respMatrix_perneuron_posi);
	temp_vect_1_posi = coCoeff_per_neurons_posi(:,3);
	temp_vect_2_posi = temp_vect_1_posi([1:2, 4:7, 9:10]);
	avg_coCoeff_per_neurrons_posi = nanmean(temp_vect_2_posi);
	avg_coCoeff_posi(k) = avg_coCoeff_per_neurrons_posi;
end

%%

baseline_calculation = true;
if baseline_calculation 
% for basline 
n_boot = 1000;
bline_avg_coCoeff_size_all = [];
bline_avg_coCoeff_posi_all = [];

parfor bstep = 1:n_boot
bine_respSizeVar_ini_nz = rand(size(respSizeVar_ini_nz));
bline_avg_coCoeff_size = [];
for l=1:size(bine_respSizeVar_ini_nz, 1)    
    resp_per_neruons = bine_respSizeVar_ini_nz(l,:);
    resp_per_neruons = resp_per_neruons';
    respMatrix_perneuron = reshape(resp_per_neruons, 40, []);
    coCoeff_per_neurons = corrcoef(respMatrix_perneuron);
    temp_vect_1 = coCoeff_per_neurons(2:end,1);
    avg_coCoeff_per_neurrons = nanmean(temp_vect_1);
    bline_avg_coCoeff_size(l) = avg_coCoeff_per_neurrons;
end
bline_avg_coCoeff_size_all(bstep, :) = mean(bline_avg_coCoeff_size);
end

parfor bstep = 1:n_boot
bline_respPosiVar_ini_nz = rand(size(respPosiVar_ini_nz));
bline_avg_coCoeff_posi = [];
for k=1:size(bline_respPosiVar_ini_nz, 1)
	resp_per_neruons_posi = bline_respPosiVar_ini_nz(k,:);
	resp_per_neruons_posi = resp_per_neruons_posi';
	respMatrix_perneuron_posi = reshape(resp_per_neruons_posi, 40, []);
	coCoeff_per_neurons_posi = corrcoef(respMatrix_perneuron_posi);
	temp_vect_1_posi = coCoeff_per_neurons_posi(:,3);
	temp_vect_2_posi = temp_vect_1_posi([1:2, 4:7, 9:10]);
	avg_coCoeff_per_neurrons_posi = nanmean(temp_vect_2_posi);
	bline_avg_coCoeff_posi(k) = avg_coCoeff_per_neurrons_posi;
end
bline_avg_coCoeff_posi_all(bstep, :) = mean(bline_avg_coCoeff_posi);
end
avgRespVar.size.bline_coCoeff = bline_avg_coCoeff_posi_all;
avgRespVar.position.bline_coCoeff = bline_avg_coCoeff_posi_all;
end
%%

avgRespVar.size.face = avg_face_size_resp;
avgRespVar.size.noface = avg_noface_size_resp;
avgRespVar.size.coCoeff = avg_coCoeff_size;

avgRespVar.position.face.hor = avg_face_posi_hor_resp;
avgRespVar.position.face.ver = avg_face_posi_ver_resp;
avgRespVar.position.noface.hor = avg_noface_posi_hor_resp;
avgRespVar.position.noface.ver = avg_noface_posi_ver_resp;
avgRespVar.position.coCoeff = avg_coCoeff_posi;

end


