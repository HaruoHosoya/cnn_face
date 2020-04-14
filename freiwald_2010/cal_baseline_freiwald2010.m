
%%%%--Loding datas--
load('expdata/sorted_RSAfov.mat'); % experimental RSA data


%%-- correlations to the systhetic RSAs
n_Boot = 1000;
synth_RSAs = [];
for i = 1:n_Boot   
synth_RSA = std(newAM2(:))*randn(175,  175) + mean(mean(newAM2(:)));
synth_RSA = synth_RSA + diag(diag(ones(175)) - diag(synth_RSA));
synth_RSA_tril = tril(synth_RSA);
synth_RSA_sym = (synth_RSA_tril+synth_RSA_tril')-eye(size(synth_RSA_tril, 1)).* diag(synth_RSA_tril);
synth_RSAs(:, i) = synth_RSA_sym(:);
end

ML_corr_to_rndRSA = corr([reshape(newML2, 175*175,1), synth_RSAs]);
ML_corr_value = ML_corr_to_rndRSA(1, 2:end);

AL_corr_to_rndRSA = corr([reshape(newAL2, 175*175,1), synth_RSAs]);
AL_corr_value = AL_corr_to_rndRSA(1, 2:end);

AM_corr_to_rndRSA = corr([reshape(newAM2, 175*175,1), synth_RSAs]);
AM_corr_value = AM_corr_to_rndRSA(1, 2:end);

summarydata_2010.RSA.basline.ML = ML_corr_value;
summarydata_2010.RSA.basline.AL = AL_corr_value;
summarydata_2010.RSA.basline.AM = AM_corr_value;

baseline_data_2010.RSA.basline.ML = ML_corr_value;
baseline_data_2010.RSA.basline.AL = AL_corr_value;
baseline_data_2010.RSA.basline.AM = AM_corr_value;
save('output_data/baseline_data_2010.mat', 'baseline_data_2010');