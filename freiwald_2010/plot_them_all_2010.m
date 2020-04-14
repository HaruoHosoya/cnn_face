
%%--data formating--
VarianceAnalysisAll = data_freiwald_2010.varAnalysis;
respBase_fs_all = data_freiwald_2010.resp.respBase;
corCoeffAll = data_freiwald_2010.corCoeffall;
layerName_All = data_freiwald_2010.layerName_All;
ml_corrSimalarity = data_freiwald_2010.corrSimilarity.ml;
al_corrSimalarity = data_freiwald_2010.corrSimilarity.al;
am_corrSimalarity = data_freiwald_2010.corrSimilarity.am;

%%
% ---plot: RSA---
n_figures = size(corCoeffAll, 3);
n_rows= floor(sqrt(n_figures));
n_cols = ceil(n_figures/n_rows);
figure;
set(gcf, 'units', 'inches', 'position', [0 0 n_cols n_rows]*3)

[ha, pos] = tight_subplot(n_rows,n_cols, [0.01 0.01], [0.01 0.01], [0.01 0.01]);
for plt = 1:n_figures
    axes(ha(plt));
    imshow(flipud(corCoeffAll(:,:,plt)))
    colormap(flipud(gray));   
    c= colorbar;
    c.Ticks = [0, 0.5, 1];
    c.FontSize = 14;
    title(sprintf('%s', layerName_All{plt}), 'Interpreter', 'none');
end
fullfilename =fullfile(plotPath,'RSAs.pdf');
print(gcf, '-dpdf',fullfilename, '-r300', '-bestfit');

%%
%--- model RSA correlation to expt. ones---
% basline values
load('output_data/baseline_data_2010.mat', 'baseline_data_2010');
ML_corr_value = baseline_data_2010.RSA.basline.ML;
AL_corr_value = baseline_data_2010.RSA.basline.AL;
AM_corr_value = baseline_data_2010.RSA.basline.AM;
all_corr_value = [ML_corr_value';AL_corr_value'; AM_corr_value'];
all_corr_value_layers = repmat(all_corr_value,1, nLayers); 
areas_ = repmat({'ML', 'AL', 'AM'}, 1000, 1);
areas = areas_(:);

btd_cor_all = [ml_corrSimalarity; al_corrSimalarity; am_corrSimalarity];
area_name_ = repmat({'ML', 'AL', 'AM'}, size(btd_cor_all, 1)/3, 1);
area_name = area_name_(:);

% % data from models
% btd_cor_all = [btd_cor_ml_all; btd_cor_al_all; btd_cor_am_all];
% area_name_ = repmat({'ML', 'AL', 'AM'}, boot_itr, 1);
% area_name = area_name_(:);
two_std = @(y)([mean(y); mean(y)-2*std(y); mean(y)+2*std(y)]);
figure('Position', [0, 0, 500, 300]);
gm = gramm('x', 1:nLayers, 'y', btd_cor_all, 'color', area_name);
% gm.stat_summary('type', 'ci', 'geom', {'line', 'area'})
gm.geom_line();
gm.geom_point();
gm.set_color_options('map', 'matlab')
gm.set_order_options('color', {'AM', 'ML', 'AL'})
gm.set_names('color', '',  'y', 'Correlation', 'x', 'Layer');
gm.axe_property('TickDir', 'out',...
    'Ygrid', 'on',...
    'Xgrid', 'on',...
    'Xlim', [1, nLayers],...
    'GridColor',[0.4, 0.4 0.4 0.4],...
    'XTick', 1:nLayers);

gm.set_text_options('font', 'Helvetica', 'base_size', 12, 'label_scaling', 1, 'facet_scaling', 1);
gm.draw()
gm.update('x', 1:nLayers, 'y', all_corr_value_layers, 'color', areas);
gm.stat_summary('type', two_std, 'geom', {'area', 'line'});
gm.set_line_options('styles', {'--'});
gm.axe_property('YLim', [0.1, 0.7])
gm.no_legend();
gm.draw();
gm.export('export_path', plotPath, 'file_name', 'RSA_summary', 'file_type', 'pdf');

%%
%%%---size and poition invariance--
%%-- calculating Size invariance indces:
thresh = 1.4;
finalIndx = zeros(1, nLayers);
all_size_d_all = [];
all_posi_d_all = [];
baseResp = [];
indexini = [];

for i = 1:nLayers
% size-invariance
face_size_d = fliplr(VarianceAnalysisAll{i}.size.face);
object_size_d = fliplr(VarianceAnalysisAll{i}.size.noface);
all_size_d = [face_size_d; object_size_d];
all_size_d_all = [all_size_d_all; all_size_d];
baseResp(i) = mean(respBase_fs_all{i});

% position-invariance
face_pos_d_horVer = VarianceAnalysisAll{i}.position.face;
object_pos_d_horVer = VarianceAnalysisAll{i}.position.noface;

face_pos_d = mean(cell2mat(struct2cell(face_pos_d_horVer)));
object_pos_d = mean(cell2mat(struct2cell(object_pos_d_horVer)));
all_posi_d = [face_pos_d; object_pos_d];
all_posi_d_all = [all_posi_d_all; all_posi_d];

indexini(:, i) = [face_size_d-baseResp(i)] > thresh*[object_size_d-baseResp(i)];
indexValIni = find([0; indexini(:, i)]==1);
indexVal = min(indexValIni);
if ~isempty(indexVal)
    finalIndx(i) = indexVal*(1/8);  
else 
    finalIndx(i) = 1;
end
end

% data arrangement for size
unitSize = inputSize(1)/8;
size_Xvalue_3_ini_1 = linspace(2*unitSize, inputSize(1), 7);
size_Xvalue_3_ini= cellstr(["bline", string(size_Xvalue_3_ini_1)]);

bline_resp_ = repmat(baseResp, 2, 1);
bline_resp = bline_resp_(:);
all_size_d_all_withbase = [bline_resp, all_size_d_all];
%%
s_type_ = repmat({'face', 'noface'}, 1, 1);
s_type = repmat(s_type_(:), nLayers, 1);
layers_ = repmat(1:nLayers, 2, 1);
layers = layers_(:);

% data arrangement for position
all_posi_d_all_folded = [all_posi_d_all(:, 3), (all_posi_d_all(:, 1:2)+ all_posi_d_all(:, 4:5))/2]; 
posi_Xvalue_3_ini = linspace(0, 112/2, 3);
layers_pos_ = repmat(1:nLayers, 2, 1);
layers_pos = layers_pos_(:);
stype_2 = repmat({'face'; 'object'}, nLayers, 1);

unitPlotWidth = 200;
% custom_ci = @(y)([mean(y); bootci(100, {@(ty)mean(ty), y}, 'alpha', 0.01)]);
figure('Position', [100 100 unitPlotWidth*nLayers 400]);
g(1,1) = gramm('x', 1:8, 'y', all_size_d_all_withbase, 'color', s_type);
g(1,1).facet_grid([], layers,'scale', 'independent')
g(1, 1).geom_bar( 'Width', 0.8, 'FaceAlpha', 0.5, 'dodge', 0.8);
g(1, 1).axe_property('TickDir', 'out',...
    'Ygrid', 'on',...
    'GridColor', [0.4, 0.4 0.4 0.4],...
    'XTickLabelRotation', 90,...
    'Xlim', [1-0.5, 8+0.5],...
    'XTick', 1:8,...
    'XtickLabel', size_Xvalue_3_ini);
g(1, 1).set_names('column', '', 'row', '', 'y', 'Avg. Response', 'x', 'Size Variation (pixels)');
g(1, 1).set_text_options('font', 'Helvetica', 'base_size', 12, 'label_scaling', 1, 'facet_scaling', 1);
% g3(1, 1).coord_flip();
g(1, 1).set_order_options('x', 0, 'color', [2 1]);
g(1, 1).set_color_options('map', 'matlab', 'lightness', 80);
g(1, 1).no_legend;

g(2,1)= gramm('x', posi_Xvalue_3_ini, 'y',all_posi_d_all_folded, 'color', stype_2);
g(2,1).facet_grid([], layers_pos,'scale', 'independent');
% g(2,1).geom_bar('dodge', 0.7);
g(2, 1).geom_bar( 'Width', 0.8, 'dodge', 0.8);
g(2, 1).axe_property('TickDir', 'out','Ygrid', 'on',...
    'GridColor', [0.4, 0.4 0.4 0.4], 'XTick', posi_Xvalue_3_ini, 'xlim', [-20 max(posi_Xvalue_3_ini)+20] );
g(2,1).set_names('column', '', 'row', '', 'y', 'Avg. Response', 'x', 'Position Variation (pixels)');
g(2,1).set_order_options('x', 0, 'color', [2 1]);
g(2,1).no_legend;

g.set_color_options('map', 'matlab');
g.set_text_options('font', 'Helvetica', 'base_size', 12, 'label_scaling', 1, 'facet_scaling', 1);
g.draw();

% fixing Y-axis tick.
for i =1: nLayers
    
ax = g(1,1).facet_axes_handles(i);
ayvalue = max(ax.YTick);
index1 = ayvalue.*20.^(1:5);
index2 = find(index1'==round(index1)', 1);
    if 2|| 17 ==index2 
        ax.YAxis.Exponent =-2;
    elseif index2 == 3
        ax.YAxis.Exponent =-3;
    end      
 
ax2 = g(2,1).facet_axes_handles(i);
ayvalue = max(ax2.YTick);
index1 = ayvalue.*20.^(1:5);
index2 = find(index1'==round(index1)', 1);
    if 2|| 17 ==index2 
        ax2.YAxis.Exponent =-2;
    elseif index2 == 3
        ax2.YAxis.Exponent =-3;
    end      
       
end
g.export('export_path', plotPath, 'file_name', 'sizePosiInvariancePlot', 'file_type', 'pdf');

%%
%%%-- size and position invariant identity selectivity
count_sz_all = [];
count_ps_all = [];
mu_sz = [];
mu_ps = [];
bline_sz_coff = [];
bline_ps_coff = [];

for i = 1:nLayers 
coeff_sz = VarianceAnalysisAll{i}.size.coCoeff;
coeff_ps = VarianceAnalysisAll{i}.position.coCoeff;
[count_sz, cent_sz] = hist(coeff_sz);
[count_ps, cent_ps] = hist(coeff_ps);
count_sz_all(i, :) = count_sz;
count_ps_all(i, :) = count_ps;
mu_sz(i) = nanmean(coeff_sz);
mu_ps(i) = nanmean(coeff_ps);
bline_sz_coff(:, i) = VarianceAnalysisAll{i}.size.bline_coCoeff;
bline_ps_coff(:, i) = VarianceAnalysisAll{i}.position.bline_coCoeff;
end

layer = 1:nLayers;
nrm_count_sz_all = count_sz_all./(sum(count_sz_all, 2));
nrm_count_ps_all = count_ps_all./(sum(count_ps_all, 2));
if nLayers == 7
pltlayer = [1,3, 5, 7];
else
pltlayer = [1:nLayers];
end
    
subset_val = ismember(1:nLayers, pltlayer);

figure('Position', [0, 0, nLayers*100, 700]);
g2(1,1) = gramm('x', cent_sz, 'y',  nrm_count_ps_all, 'lightness', layer, 'subset', subset_val);
g2(1,1).geom_bar('dodge', 0.7);
g2(1,1).set_color_options('lightness_range', [95, 0],'chroma_range', [0 0]);
g2(1,1).set_names('column', '', 'lightness', 'Layer', 'y', '# of units(%)', 'x', 'Position-invariant identity selectivity index');

g2(2,1) = gramm('x', cent_sz, 'y',  nrm_count_sz_all, 'lightness', layer,  'subset', subset_val);
g2(2,1).geom_bar('dodge', 0.7);
g2(2,1).set_color_options('lightness_range', [95, 0],'chroma_range', [0 0]);
g2(2,1).set_layout_options('position', [0, 0.31, 0.89, 0.33]) 
g2(2,1).set_names('column', '', 'lightness', 'Layer', 'y', '# of units(%)', 'x', 'Size-invariant identity selectivity index');
g2(2,1).no_legend();


ty_ = repmat({'Size';'Position'}, 1000, 1);
ty = ty_(:);

g2(3,1) = gramm('x', 1:nLayers, 'y', [bline_sz_coff; bline_ps_coff]);
g2(3,1).facet_grid([], ty)
g2(3,1).stat_summary('type', two_std);
g2(3,1).set_names('color', '',  'y', 'mean index', 'x', 'Layer', 'column', '');
g2(3,1).draw()

g2(3,1).update('x', 1:nLayers, 'y', [mu_sz;mu_ps]);
g2(3,1).facet_grid([], {'Size';'Position'}); 
g2(3,1).geom_line();
g2(3,1).geom_point();
g2(3,1).set_names('color', '',  'y', 'mean index', 'x', 'Layer', 'column', '');
g2(3,1).axe_property('YLim', [-0.1, 0.9],...
    'Xtick', 1:nLayers);
g2(3,1).set_color_options('chroma', 0, 'Lightness', 20);
g2.set_text_options('font', 'Helvetica', 'base_size', 12, 'label_scaling', 1, 'facet_scaling', 1);
g2.axe_property('Xgrid' , 'on', 'Ygrid', 'on');
g2.draw()

sz_ml = 0.64;
sz_al = 0.78;
sz_am = 0.78;

ps_ml = 0.42;
ps_al = 0.53;
ps_am = 0.61;

c3  = [0.5 0.5 0.5];


line([0 nLayers], [sz_ml sz_ml], 'Parent', g2(3,1).facet_axes_handles(2), ...
    'Color', c3, 'lineWIdth', 1.5, 'LineStyle', '--');
line([0 nLayers], [sz_al sz_al], 'Parent', g2(3,1).facet_axes_handles(2), ...
    'Color', c3, 'lineWIdth', 1.5, 'LineStyle', '-.');
line([0 nLayers], [sz_am sz_am], 'Parent', g2(3,1).facet_axes_handles(2),...
    'Color', c3, 'lineWIdth', 1.5, 'LineStyle', ':');

line([0 nLayers], [ps_ml ps_ml], 'Parent', g2(3,1).facet_axes_handles(1),...
    'Color', c3, 'lineWIdth', 1.5, 'LineStyle', '--');
line([0 nLayers], [ps_al ps_al], 'Parent', g2(3,1).facet_axes_handles(1),...
    'Color', c3, 'lineWIdth', 1.5, 'LineStyle', '-.');
line([0 nLayers], [ps_am ps_am], 'Parent', g2(3,1).facet_axes_handles(1),...
    'Color', c3, 'lineWIdth', 1.5, 'LineStyle', ':');

text(1.1, sz_ml+0.05, {'ML'}, 'Parent', g2(3,1).facet_axes_handles(2));
text(1.1, sz_al+0.05, {'AL/AM'}, 'Parent', g2(3,1).facet_axes_handles(2));

text(1.5, ps_ml+0.05, {'ML'}, 'Parent', g2(3,1).facet_axes_handles(1));
text(1.5, ps_al+0.05, {'AL'}, 'Parent', g2(3,1).facet_axes_handles(1));
text(1.5, ps_am+0.05, {'AM'}, 'Parent', g2(3,1).facet_axes_handles(1));

g2.export('export_path', plotPath, 'file_name', 'identity_select_index_2', 'file_type', 'pdf');


%%
figure;
g22 = gramm('x', 1:nLayers, 'y', finalIndx);
g22.geom_line();
g22.set_line_options('base_size', 2);
g22.geom_point();
g22.set_point_options('markers', {'o'}, 'base_size', 4);
g22.axe_property('ytick', [1/8 2/8, 4/8,  1],...
    'yticklabels', {'1/8', '1/4', '1/2',  '1'},...
    'Ylim', [0, 1],...
    'Xlim', [1 nLayers],...
    'Xgrid', 'on',...
    'Ygrid', 'on');
g22.set_names('y', 'SI index', 'x', 'layer');
% g22.geom_polygon('y', {[0 1/8]});
g22.set_layout_options('position', [0.004 0.35 0.43 0.32 ])
g22.set_title('(B) size invariance',  'FontSize', 10);
g22.set_color_options('chroma', 0, 'lightness', 40 );
g22.draw()

line([0 nLayers], [1/8 1/8], 'Parent', g22.facet_axes_handles,...
    'Color', 'k', 'lineWIdth', 1.5, 'LineStyle', '--');
text(1.1, 1/8+0.07, {'AM/AL/ML'}, 'Parent', g22.facet_axes_handles);


%%
if halfwidth_compuutation
%%%-- tuning depth (halfwidth)---
norm_width_count_all = bsxfun(@rdivide, width_count_all, sum(width_count_all, 1));
norm_depth_count_all_profile = bsxfun(@rdivide,...
    Depth_Count_all_profile, sum(Depth_Count_all_profile, 1));
norm_depth_count_all_HalfProfile = bsxfun(@rdivide,...
    Depth_Count_all_HalfProfile, sum(Depth_Count_all_HalfProfile, 1));
norm_depth_count_all = [norm_depth_count_all_profile(:);...
    norm_depth_count_all_HalfProfile(:)];

x_value = repmat((linspace(-1,1, 10))', 14, 1);
layerName_All_new = {'layer 1', 'layer 2','layer 3',...
    'layer 4','layer 5','layer 6','layer 7'};
layerN_ = repmat(layerName_All_new, 10, 1);
layerNN = layerN_(:);
layerN = [layerNN;layerNN];
expName_ = repmat({'profile', 'half profile'}, 70, 1);
expName = expName_(:);

figure('Position', [100 100 600 800]);
g3(1,1) = gramm('x', 1:25, 'y', (norm_width_count_all)');
g3(1,1).facet_grid((1:7)',[], 'row_labels', false);
g3(1,1).geom_bar;
g3(1,1).set_names('color', '', 'x', 'identity tuning depth',...
   'y', 'fraction units')

%        g(1,1).draw();

g3(1,2) = gramm('x', x_value, 'y', norm_depth_count_all, 'color', expName);
g3(1,2).facet_grid(layerN,[]);
g3(1,2).geom_bar('dodge', 0.6);
g3(1,2).set_layout_options('legend_pos', [0.71 0.925 0.3 0.1])
g3(1,2).set_names('color', '', 'x' , 'head orientation tuning depth',...
   'row', '', 'y', 'fraction units')

g3.set_color_options('map', 'lch')
g3.set_text_options('base_size', 12, 'facet_scaling', 1)
g3.draw();

filename3 = sprintf('viewInvariance_%s', layerName); 
g3.export('export_path', plotPath, 'file_name', filename3, 'file_type', 'pdf');

end
