% ADDED:
%  add main biomarker extraction to cluster main_biomarker+ (e.g. S100+)

clc; clear ;
setPath();
%% parameters
maxclust = 20;
cell_type = 'oligodendrocyte';
cell_class = 'neg';
%% load data
if strcmp(cell_type, 'costum')
    main_biomarker = 'S100';
    load LiVPA_NeuN_multi_3.mat         ; new_db{1} = db{1};
    load LiVPA_GFAP_multi_3.mat         ; new_db{2} = db{3};
    load LiVPA_GLAST_multi_3.mat        ; new_db{3} = db{3};
elseif strcmp(cell_type, 'neuron')
    main_biomarker = 'NeuN';
    load LiVPA_NeuN_multi_3.mat         ; new_db{1} = db{1};
    load LiVPA_GAD67_multi_3.mat        ; new_db{2} = db{1};
    load LiVPA_Parvalbumin_multi_3.mat  ; new_db{3} = db{1};
    load LiVPA_Claretinin_multi_3.mat   ; new_db{4} = db{1};
elseif strcmp(cell_type, 'astrocyte')
        main_biomarker = 'S100';
    load LiVPA_S100_multi_3.mat         ; new_db{1} = db{3};
    load LiVPA_APC_multi_3.mat          ; new_db{2} = db{3};
    load LiVPA_GFAP_multi_3.mat         ; new_db{3} = db{3};
    load LiVPA_GLAST_multi_3.mat        ; new_db{4} = db{3};
elseif strcmp(cell_type, 'oligodendrocyte')
        main_biomarker = 'APC';
    load LiVPA_APC_multi_3.mat          ; new_db{1} = db{3};
    load LiVPA_S100_multi_3.mat         ; new_db{2} = db{3};
    load LiVPA_MBP_multi_3.mat          ; new_db{3} = db{3};
    load LiVPA_PLP_multi_3.mat          ; new_db{4} = db{3};
elseif strcmp(cell_type, 'microglia')
        main_biomarker = 'IBA1';
    load LiVPA_IBA1_multi_3.mat         ; new_db{1} = db{3};
    load LiVPA_S100_multi_3.mat         ; new_db{2} = db{3};
    load LiVPA_APC_multi_3.mat          ; new_db{3} = db{3};
    load LiVPA_TomatoLectin_multi_3.mat ; new_db{4} = db{3};

elseif strcmp(cell_type, 'endothelial')
        main_biomarker = 'RECA1';
    load LiVPA_RECA1_multi_3.mat        ; new_db{1} = db{2};
    load LiVPA_S100_multi_3.mat         ; new_db{2} = db{2};
    load LiVPA_APC_multi_3.mat          ; new_db{3} = db{2};
    load LiVPA_TomatoLectin_multi_3.mat ; new_db{4} = db{2};
end
biomarkers = cellfun(@(S) S.biomarker, new_db, 'UniformOutput', false);
biomarkers_title_name = sprintf('using %s features', strjoin(biomarkers, ' / '));

%% create dataset
type = 'vert';
dataset = concatenate( new_db, type );


% remove the outliers for more acurate clustering
% img = imread('ARBc_#4_Li+VPA_37C_4110_C6_IlluminationCorrected_stitched.tif');
% outlier_centers = polygon_cells(imadjust(img) , dataset.centers);
% save( './input/LiVPA/LiVPA_outliers', 'outlier_centers', '-v7.3' )

% load LiVPA_outliers.mat
% outliers = find(ismember(dataset.centers,outlier_centers,'rows'));
% dataset.centers (outliers,:) = [];
% dataset.labels  (outliers,:) = [];
% dataset.features(outliers,:) = [];
%% hierachical clustering
if strcmp(cell_class , 'pos')
    pos = find (dataset.labels(:,1) ~=0);                                   % find the main_biomarker positive cells
    dataset.features = dataset.features(pos,:);
    dataset.centers  = dataset.centers(pos,:);
    dataset.labels   = dataset.labels(pos,:);
    title_name = sprintf('clustering of %s+ cells %s', main_biomarker, biomarkers_title_name);
elseif strcmp(cell_class , 'neg')
    neg = find (dataset.labels(:,1) ==0);                                   % find the main_biomarker negative cells
    dataset.features = dataset.features(neg,:);
    dataset.centers  = dataset.centers(neg,:);
    dataset.labels   = dataset.labels(neg,:);
    title_name = sprintf('clustering of %s- cells %s', main_biomarker, biomarkers_title_name);
elseif strcmp(cell_class , 'all')
    title_name = sprintf('clustering of all cells %s', biomarkers_title_name);
end

fprintf('starting hierachical clustering...\t');
% 1. calculate the distance between points
hcluster.dist = pdist(dataset.features);                                % calculate the distance in vector format
hcluster.dist = squareform(hcluster.dist);                              % convert the vector format to matrix

% 2. linking pair of objects close to eachother
hcluster.links = linkage(hcluster.dist,'ward');                         % the first two columns identify the objects that have been linked.
% the third column contains the distance between these objects.
% 'average' 'centroid' 'complete' 'median' 'single' 'ward' 'weighted'
% 3. set cut-off value
% hcluster.tree = cluster(hcluster.links,'maxclust',maxclust);

fprintf('done!\n')
% save('./results/LiVPA_S100_scatnet_complete_50' , 'dataset', 'img', 'hcluster', 'maxclust', '-v7.3')
%% visualizations
    dend_opt.plot_type = 'text';
    dend_opt.title_name = title_name;
    dendrogram_vis( dataset, hcluster , maxclust , dend_opt )
%% OTHER
% comparison_vis( image , dataset.centers , hcluster.tree , dataset.labels )
% cluster_size_vis( image , dataset.centers , hcluster.tree )
% cgo = clustergram(dataset.features,'Standardize','Row')
% set(cgo,'Linkage','complete','Dendrogram',50)


