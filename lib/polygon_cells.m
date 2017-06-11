function selected_cells = polygon_cells(image , centers )
% this function finds the indices of the cells inside a drawn ploygon
% inputs:
% 1. image
% 2. coordinate of the centers of the cells
% output:
% indices of the selected cells
f = figure;
imshow(image); hold on;                                                     % plot the image
plot (centers(:,1) , centers(:,2) , 'b.' , 'markersize', 15);               % plot the centers of the cells

h = impoly();                                                               % start the ploygon
nodes = getPosition(h);                                                     % get the vertices of the polygon

cells = inpolygon(centers(:,1), centers(:,2),...                            % find the cells inside the polygon
                           nodes(:,1), nodes(:,2));

selected_cells = centers (cells,:);
close(f)
end