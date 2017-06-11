% ADDED:
%  add main biomarker extraction to cluster main_biomarker+ (e.g. S100+)

clc; clear ;
setPath();
%% parameters
maxclust = 20;
main_biomarker = 'S100';

%% load data
if strcmp(main_biomarker, 'NeuN')
    load LiVPA_NeuN_multi_3.mat         ; new_db{1} = db{1};
    load LiVPA_GAD67_multi_3.mat        ; new_db{2} = db{1};
    load LiVPA_Parvalbumin_multi_3.mat  ; new_db{3} = db{1};
    load LiVPA_Claretinin_multi_3.mat   ; new_db{4} = db{1};
    default_title_name = ('using NeuN / GAD67 / Parvalbumin / Claretinin features');
elseif strcmp(main_biomarker, 'S100')
    load LiVPA_S100_multi_3.mat         ; new_db{1} = db{1};
%     load LiVPA_APC_multi_3.mat          ; new_db{2} = db{1};
    load LiVPA_GFAP_multi_3.mat         ; new_db{2} = db{1};
%     load LiVPA_GLAST_multi_3.mat        ; new_db{4} = db{1};
    default_title_name = ('using S100 / APC / GFAP / GLAST features');
    default_title_name = ('using GFAP features');
elseif strcmp(main_biomarker, 'APC')
    load LiVPA_APC_multi_3.mat          ; new_db{1} = db{3};
    load LiVPA_S100_multi_3.mat         ; new_db{2} = db{3};
    load LiVPA_MBP_multi_3.mat          ; new_db{3} = db{3};
    load LiVPA_PLP_multi_3.mat          ; new_db{4} = db{3};
    default_title_name = ('using APC / S100 / MBP / PLP features');
elseif strcmp(main_biomarker, 'IBA1')
    load LiVPA_IBA1_multi_3.mat         ; new_db{1} = db{3};
    load LiVPA_S100_multi_3.mat         ; new_db{2} = db{3};
    load LiVPA_APC_multi_3.mat          ; new_db{3} = db{3};
    load LiVPA_TomatoLectin_multi_3.mat ; new_db{4} = db{3};
    default_title_name = ('using IBA1 / S100 / APC / TomatLectin features');
    default_title_name = ('using TomatoLectin features');

elseif strcmp(main_biomarker, 'RECA1')
    load LiVPA_RECA1_multi_3.mat        ; new_db{1} = db{2};
    load LiVPA_S100_multi_3.mat         ; new_db{2} = db{2};
    load LiVPA_APC_multi_3.mat          ; new_db{3} = db{2};
    load LiVPA_TomatoLectin_multi_3.mat ; new_db{4} = db{2};
    default_title_name = ('using RECA1 / S100 / APC / TomatoLectin features');
end

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
old_dataset = dataset;                                                      % keep the dataset to retrive positive and negative cells
for i = 1: 2
    if i == 1
        pos = find (old_dataset.labels(:,1) ~=0);                           % find the main_biomarker positive cells
        dataset = old_dataset;                                              % create a new dataset based on poisitives
        dataset.features = old_dataset.features(pos,:);                       
        dataset.centers  = old_dataset.centers(pos,:);                             
        dataset.labels   = old_dataset.labels(pos,:);
        title_name = sprintf('clustering of %s+ %s', main_biomarker, default_title_name);
    else
        neg = find (old_dataset.labels(:,1) ==0);                           % find the main_biomarker negative cells
        dataset = old_dataset;                                              % create a new dataset based on negatives
        dataset.features = old_dataset.features(neg,:);
        dataset.centers  = old_dataset.centers(neg,:);                             
        dataset.labels   = old_dataset.labels(neg,:);
        title_name = sprintf('clustering of %s- %s', main_biomarker, default_title_name);
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
    % comparison_vis( image , dataset.centers , hcluster.tree , dataset.labels )
    % cluster_size_vis( image , dataset.centers , hcluster.tree )
    dend_opt.plot_type = 'dot';
    dend_opt.title_name = title_name;
%     dendrogram_vis_V4( dataset, hcluster , maxclust , dend_opt )
    dendrogram_vis_V5( dataset, hcluster , maxclust , dend_opt )

end
%% clustergram
% cgo = clustergram(dataset.features,'Standardize','Row')
% set(cgo,'Linkage','complete','Dendrogram',50)


