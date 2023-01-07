%%%%%%%%%%%%%%%%%%%%%%Modulation Classify%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
function label = Modulation_Classify(sig)
% sig: input modulated signal 1*N Complex
% label: output label 0-9

%clear all; close all;
addpath(genpath('Functions'));
addpath(genpath('hermite_s_method'));
load trainedNetwork.mat;        %%加载训练过的CNN分类网络


tfr = sig_preprocess(sig);       %%hermite_s_method时频分析
tfr = image_process(tfr);        %%Normalization, resize to 128*128 using bicubic
tfr = uint8(tfr*255);            %%uint-255
% imshow(tfr)
label = classify(trainedNetwork,tfr);   %%label为categorical类型
label = string(label);
label = double(label);           %%转换为double类型

end
