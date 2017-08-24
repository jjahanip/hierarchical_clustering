% ADDED:
%   composition of images (several channels)

function  dendrogram_vis( dataset , hcluster , maxclust, opt )
% maxclust = 3;

%% checking the inputs
if nargin < 3
    fprintf ('Not enough input arguments\n')
    return
elseif nargin == 3
    plot_type = 'dot';
    title_name = '';
elseif nargin == 4
    plot_type = opt.plot_type;
    title_name = opt.title_name;
end
%% loading the inputs
images = image_composition(dataset.name);

%% plotting the figures
figure_handle = figure('Tag', 'main_figure');


% 1) cluster figure
clusterPlot_hanlde = subplot(121,...
                            'Tag','cluster_plot',...                        % define a handle for plotting the clusters
                            'Units', 'normalized');
imshow(zeros(size(images{1,2}))); hold on;                                  % show the background
clusterPlot_hanlde.Position = [.002 0.03 .493 .917];                        % set the position to the left side of the screan

% setting colormap information
cl_map_clust = hsv (maxclust);                                              % create a color map based on different clusters
rng(0);                                                                     % set the seed for the random
cl_map_clust = cl_map_clust(randperm(size(cl_map_clust,1)),:);              % shuffle the colors to have random colors


% 2) dendrogram figure
dend_handle = subplot(122,...
                      'Tag', 'dendrogram',...
                      'Units','normalized',...                               % define handle for the dendrogram figure
                      'Position',[.51 0.03 .496 .917]);
[~ , T] = dendrogram(hcluster.links , maxclust);                            % plot the dendrogram      

%% create a text and go button to change the number of clusters
uicontrol('style', 'text',...
          'Units', 'normalized',...
          'Position', [.52 .9 .06 .01],...
          'String','choose the number of clusters');
uicontrol('style', 'edit',...
          'Tag', 'num_clusters',...
          'Units', 'normalized',...
          'Position', [.52 .88 .04 .02]);
uicontrol('style', 'pushbutton',...
          'Units', 'normalized',...
          'Position', [.56 .88 .02 .02],...
          'String','go',...
          'Callback',@go_Callback)
%% create pushbotton user interfaces for the channel visualizations
for m = 1: 6
    uicontrol(figure_handle,'Style', 'checkbox',...
        'String', images{m,1},...
        'Tag', images{m,1},...
        'Units','normalized',...
        'Position',[0.01+(m-1)/20 .15 .05 .02],...
        'Callback', @biomarker_Callback);
    
end

for m = 7: size(images, 1)
    uicontrol(figure_handle,'Style', 'checkbox',...
        'String', images{m,1},...
        'Tag', images{m,1},...
        'Units','normalized',...
        'Position',[0.01+(m-7)/20 .12 .05 .02],...
        'Callback', @biomarker_Callback);
end
%% create a text and go button to import the selected clusters indices
uicontrol('style', 'text',...
          'Units', 'normalized',...
          'Position', [.52 .84 .08 .01],...
          'String','import the indices of the selected cluster');
uicontrol('style', 'pushbutton',...
          'Units', 'normalized',...
          'Position', [.52 .82 .02 .02],...
          'String','import',...
          'Callback',@import_Callback);
%% save handles
handles.fig = guihandles(figure_handle);
handles.dendrogram = dend_handle;
handles.clusterPlot_hanlde = clusterPlot_hanlde;
handles.T = T;
handles.dataset = dataset;
handles.images = images;
handles.cl_map_clust = cl_map_clust;
handles.plot_type = plot_type;
handles.hcluster = hcluster;
handles.title_name = title_name;
guidata(figure_handle,handles)
end






%--------------------------------------------------------------------------
function cellSelection_callback(cellData, ~)
pause(0.5)

handles = guidata(gcf);
tree = handles.T;
dataset = handles.dataset;
cl_map_clust = handles.cl_map_clust;
plot_type = handles.plot_type;

if isfield(handles,'points_handle')
    cellfun(@delete, handles.points_handle, 'UniformOutput', 0);
    legend off
end

set(gcf,'CurrentAxes',handles.clusterPlot_hanlde)                           % set current axis to the cluster plot
hold on;
for i = 1: size(cellData.SelectedRows,1)
    culsterNo = cellData.SelectedRows(i,1)+1;                               % get the cluster number
    ind = tree == culsterNo;                                                % find the indices of that cluster
    % plot by cluster number
    if strcmp (plot_type , 'text')
        points_handle{i} = text( ...
                                 dataset.centers(ind,1), ...
                                 dataset.centers(ind,2), ...
                                 num2str(culsterNo), ...
                                 'color', cl_map_clust(culsterNo,:), ...
                                 'FontSize',20 ...
                                );
    % plot by dot
    elseif strcmp(plot_type , 'dot')
        points_handle{i} = plot(....
                                dataset.centers(ind,1), ...                                    
                                dataset.centers(ind,2), ...
                                '.', ...
                                'color', cl_map_clust(culsterNo,:),...
                                'markersize' , 15);
    end
    legendCell(i,1) = cellstr(num2str(culsterNo', 'cluster %-d'));          % get the cluster number for the legend
end
if strcmp(plot_type , 'dot')
    legend (legendCell)                                                     % print the legend
end
hold off;                                                                   % so that the legend does not show previous colors


handles.points_handle = points_handle;
handles.cellData = cellData;
guidata(gcf,handles)

end
%--------------------------------------------------------------------------
function biomarker_Callback(hObject,~)
pause(0.5)

handles = guidata(hObject);                                                 % get the handles of the current figure
images = handles.images;                                                    % set the images as an independent variable
ch = get_channels(handles.dataset.name);

set(gcf,'CurrentAxes',handles.clusterPlot_hanlde)                           % set current axis to the cluster plot
imshow(zeros(size(images{1,2}))); hold on;                                  % show the background

for m = 1:size(images,1)
    checkboxStatus = handles.fig.(images{m,1}).Value;                       % check whether the biomarker is chosen
    if checkboxStatus ==1
        if(isempty(images{m,3}))
            imSize = size(images{1,2});                                     % get the size of the image
            image_name = ch{ismember(ch(:,1),images{m,1}),2};
            images{m,2} = imadjust(double(imread(image_name))./2^16);      % second element = image of the channel
            chColor = cell2mat( ch(ismember(ch(:,1),images{m,1}),3) );      % get the color code of the channel
            images{m,3} = cat(3, ...                                        % third element = color of the channel
                chColor(1) * ones(imSize),...
                chColor(2) * ones(imSize), ...
                chColor(3) * ones(imSize));
        end
        h = imshow(images{m,3}./(1));                                       % show the color image
        set (h, 'AlphaData', images{m,2})                                   % set the transparecy of the color image to the image of the channel
    end
end
hold off;
title(handles.title_name)
guidata(hObject, handles);

if isfield(handles,'cellData')
    cellSelection_callback(handles.cellData);
end
end
%--------------------------------------------------------------------------
function go_Callback(hObject,~)
handles = guidata(hObject);
maxclust = str2double( handles.fig.num_clusters.String );                   % get the number from editor ui
set(gcf,'CurrentAxes',handles.dendrogram)                                   % set the current axis to the dendrogram
[~ , T] = dendrogram(handles.hcluster.links , maxclust);                    % plot the dendrogram



% setting colormap information
cl_map_clust = hsv (maxclust);                                              % create a color map based on different clusters
rng(0);                                                                     % set the seed for the random
cl_map_clust = cl_map_clust(randperm(size(cl_map_clust,1)),:);              % shuffle the colors to have random colors
cl_map_clust(1,:) = [1 1 0];
cl_map_clust(2,:) = [0 1 0];
cl_map_clust(3,:) = [1 0 0];

% get the number of samples in each cluster
for i = 1: maxclust
    temp(i,1) = length(find (T == i));
end
data(:,1) = cellfun(@num2str,num2cell((1:maxclust)'),'un',0);               % table data : first column is cluster number
data(:,2) = cellfun(@num2str,num2cell(temp),'un',0);                        % table data : first column is cluster number

% create the table user interface (which cluster to be visualized)
if isfield(handles, 'table_handle')
   delete(handles.table_handle);
   rmfield(handles, 'table_handle');
end
table_handle = uitable(handles.fig.main_figure,...                          % create a table in the dendrogram figure
             'Data', data,...
             'Units', 'normalized',...
             'Position', [.9 .7 .076 .27],...
             'ColumnName', {'cluster number' , ' # of samples'});
             
hJScroll = findjobj(table_handle);                                          % findjobj is from file exchange
hJTable = hJScroll.getViewport.getView;                                     % get the table component within the scroll object
hJTable.setNonContiguousCellSelection(false);
hJTable.setColumnSelectionAllowed(false);
hJTable.setRowSelectionAllowed(true);

hJTable = handle(hJTable, 'CallbackProperties');
set(hJTable, 'MousePressedCallback', @cellSelection_callback);

% remove the points from the previous visualization
if isfield(handles,'points_handle')
    set(gcf,'CurrentAxes',handles.clusterPlot_hanlde)                       % set current axis to the cluster plot
    cellfun(@delete, handles.points_handle, 'UniformOutput', 0);
    legend off
end

handles.T = T;
handles.cl_map_clust = cl_map_clust;
handles.table_handle = table_handle;
guidata(hObject,handles)
end
%--------------------------------------------------------------------------
function import_Callback(hObject,~)
% extract the needed information
handles = guidata(hObject);
cellData = handles.cellData;
tree = handles.T;

culsterNo = cellData.SelectedRows+1;                                        % get the number of selected clusters 
ind = ismember(tree, culsterNo);                                            % set True for the selected clusters
assignin('base', 'indices', ind);                                           % import the indices to the base workspace
    
end


