function image = image_composition(dataset)

if strcmp(dataset , 'LiVPa')
    % read the images
    image_names{1}  = 'ARBc_#4_Li+VPA_37C_4110_C10_IlluminationCorrected_stitched.tif';
    image_names{2}  = 'ARBc_#4_Li+VPA_37C_4110_C4_IlluminationCorrected_stitched.tif';
    image_names{3}  = 'ARBc_#4_Li+VPA_37C_4110_C5_IlluminationCorrected_stitched.tif';
    image_names{4}  = 'ARBc_#4_Li+VPA_37C_4110_C6_IlluminationCorrected_stitched.tif';
    image_names{5}  = 'ARBc_#4_Li+VPA_37C_4110_C7_IlluminationCorrected_stitched.tif';
    image_names{6}  = 'ARBc_#4_Li+VPA_37C_4110_C8_IlluminationCorrected_stitched.tif';
    image_names{7}  = 'ARBc_#4_Li+VPA_37C_4110_C1_IlluminationCorrected_stitched.tif';
    image_names{8}  = 'ARBc_#4_Li+VPA_37C_4110_C2_IlluminationCorrected_stitched.tif';
    image_names{9}  = 'ARBc_#4_Li+VPA_37C_4111_C2_IlluminationCorrected_stitched_registered.tif';
    image_names{10} = 'ARBc_#4_Li+VPA_37C_4111_C5_IlluminationCorrected_stitched_registered.tif';
    image_names{11} = 'ARBc_#4_Li+VPA_37C_4111_C8_IlluminationCorrected_stitched_registered.tif';
    image_names{12} = 'ARBc_#4_Li+VPA_37C_4112_C5_IlluminationCorrected_stitched_registered.tif';
    image_names{13} = 'ARBc_#4_Li+VPA_37C_4113_C4_IlluminationCorrected_stitched_registered.tif';
    image_names{14} = 'ARBc_#4_Li+VPA_37C_4113_C6_IlluminationCorrected_stitched_registered.tif';
    image_names{15} = 'ARBc_#4_Li+VPA_37C_4113_C8_IlluminationCorrected_stitched_registered.tif';
elseif strcmp(dataset , 'sham')
    % read the images
    image_names{1}  = 'ARBc_#29_Sham_1C_4110_C10_IlluminationCorrected_stitched.tif';
    image_names{2}  = 'ARBc_#29_Sham_1C_4110_C4_IlluminationCorrected_stitched.tif';
    image_names{3}  = 'ARBc_#29_Sham_1C_4110_C5_IlluminationCorrected_stitched.tif';
    image_names{4}  = 'ARBc_#29_Sham_1C_4110_C6_IlluminationCorrected_stitched.tif';
    image_names{5}  = 'ARBc_#29_Sham_1C_4110_C7_IlluminationCorrected_stitched.tif';
    image_names{6}  = 'ARBc_#29_Sham_1C_4110_C8_IlluminationCorrected_stitched.tif';
    image_names{7}  = 'ARBc_#29_Sham_1C_4110_C1_IlluminationCorrected_stitched.tif';
    image_names{8}  = 'ARBc_#29_Sham_1C_4110_C2_IlluminationCorrected_stitched.tif';
    image_names{9}  = 'ARBc_#29_Sham_1C_4111_C2_IlluminationCorrected_stitched_registered.tif';
    image_names{10} = 'ARBc_#29_Sham_1C_4111_C5_IlluminationCorrected_stitched_registered.tif';
    image_names{11} = 'ARBc_#29_Sham_1C_4111_C8_IlluminationCorrected_stitched_registered.tif';
    image_names{12} = 'ARBc_#29_Sham_1C_4112_C5_IlluminationCorrected_stitched_registered.tif';
    image_names{13} = 'ARBc_#29_Sham_1C_4113_C4_IlluminationCorrected_stitched_registered.tif';
    image_names{14} = 'ARBc_#29_Sham_1C_4113_C6_IlluminationCorrected_stitched_registered.tif';
    image_names{15} = 'ARBc_#29_Sham_1C_4113_C8_IlluminationCorrected_stitched_registered.tif';
elseif strcmp(dataset , 'vehicle')
    % read the images
    image_names{1}  = 'ARBc_FPI#6_Vehicle_20C_4110_C10_IlluminationCorrected_stitched.tif';
    image_names{2}  = 'ARBc_FPI#6_Vehicle_20C_4110_C4_IlluminationCorrected_stitched.tif';
    image_names{3}  = 'ARBc_FPI#6_Vehicle_20C_4110_C5_IlluminationCorrected_stitched.tif';
    image_names{4}  = 'ARBc_FPI#6_Vehicle_20C_4110_C6_IlluminationCorrected_stitched.tif';
    image_names{5}  = 'ARBc_FPI#6_Vehicle_20C_4110_C7_IlluminationCorrected_stitched.tif';
    image_names{6}  = 'ARBc_FPI#6_Vehicle_20C_4110_C8_IlluminationCorrected_stitched.tif';
    image_names{7}  = 'ARBc_FPI#6_Vehicle_20C_4110_C1_IlluminationCorrected_stitched.tif';
    image_names{8}  = 'ARBc_FPI#6_Vehicle_20C_4110_C2_IlluminationCorrected_stitched.tif';
    image_names{9}  = 'ARBc_FPI#6_Vehicle_20C_4111_C2_IlluminationCorrected_stitched_registered.tif';
    image_names{10} = 'ARBc_FPI#6_Vehicle_20C_4111_C5_IlluminationCorrected_stitched_registered.tif';
    image_names{11} = 'ARBc_FPI#6_Vehicle_20C_4111_C8_IlluminationCorrected_stitched_registered.tif';
    image_names{12} = 'ARBc_FPI#6_Vehicle_20C_4112_C5_IlluminationCorrected_stitched_registered.tif';
    image_names{13} = 'ARBc_FPI#6_Vehicle_20C_4113_C4_IlluminationCorrected_stitched_registered.tif';
    image_names{14} = 'ARBc_FPI#6_Vehicle_20C_4113_C6_IlluminationCorrected_stitched_registered.tif';
    image_names{15} = 'ARBc_FPI#6_Vehicle_20C_4113_C8_IlluminationCorrected_stitched_registered.tif';
elseif strcmp(dataset , 'xiaoyang_crops')
    % read the images
    image_names{1}  ='DAPI.tif';
    image_names{2}  ='Histone.tif';
    image_names{3}  ='NeuN.tif';
    image_names{4}  ='Parv.tif';
    image_names{5}  ='Glut.tif';
end

ch = get_channels(dataset);                                                 % get the channel names and color codes
imSize = size(imread(image_names{1,2}));                                    % get the size of the image

for i = 1:length(image_names)
    image{i,1} = ch{ismember(ch(:,2),image_names{i}),1};                    % first elemet = channel name
    %     im = imread(image_names{i});                                            % read the image
    %     im = imadjust(im);                                                      % adjust the histogram of the image for better visualization
    %     im = double(im)./2^16;                                                  % cast to double and normalize between 0 and 1
    %     image{i,2} = im;                                                        % second element = image of the channel
    if i<=6                                                                 % just for the cell type read the image
        image{i,2} = imadjust(double(imread(image_names{i}))./2^16);        % second element = image of the channel
        chColor = cell2mat( ch(ismember(ch(:,2),image_names{i}),3) );       % get the color code of the channel
        image{i,3} = cat(3, ...                                             % third element = color of the channel
            chColor(1) * ones(imSize),...
            chColor(2) * ones(imSize), ...
            chColor(3) * ones(imSize));
    end
end




