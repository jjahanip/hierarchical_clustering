function setPath()
% setPath()
%
% Update the search path with all the directories
% necessary for running the algorithm.
%
% 

basepath = cd();
parent_path = fileparts(basepath);
parent_parent_path = fileparts(parent_path);
images_path = 'D:\Jahandar\Lab\images';

addpath(genpath([basepath, '\lib']));
addpath(genpath([basepath, '\input']));
addpath(genpath([basepath, '\results']));
addpath(genpath([images_path , '\crops_for_badri_proposal']));
