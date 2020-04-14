%%
% Ploting size-invariance plot directly from response data

% respSizeVar_fs(:, ~any(respSizeVar_fs, 1)) = [];
respSizeVar_fs = respSizeVar_fs_all{2};
respSizeVar_fs(:, ~any(respSizeVar_fs, 1)) = [];

face = repmat({'face'}, 24, 1);
noface = repmat({'noface'}, 16, 1);

stype = [face; noface];
stype_ = repmat(stype, 7, 1);
sz_ = repmat(1:7, 40, 1);
sz = sz_(:);

xval = repmat(sz, 1, size(respSizeVar_fs, 2));
colorval = repmat(stype_, 1, size(respSizeVar_fs, 2));

figure;
g = gramm('x', xval(:), 'y', respSizeVar_fs(:), 'color',colorval(:));
g.stat_summary('type', 'std', 'geom',{'bar', 'black_errorbar'});
g.axe_property('YLim', [0, 20],...
               'XLim', [0, 8]);
g.stat_violin('half', true, 'fill', 'transparent');
% g.geom_point()
% g.stat_boxplot()
g.draw();
