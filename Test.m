%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Test%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This code runs about 3 minutes.
clear all; close all;
rng('shuffle','twister');
addpath(genpath('Functions'));


%% set up
ns = 10;    %信号类
n = 10;      %每类信号个数
RF = (8*ones(ns,n) + (12-8)*rand(ns,n))*10^(9);   %RF:8-12GHz
PW = (ones(ns,n) + (20-1)*rand(ns,n))*10^(-6);    %PW:1-20us
BW = (5*ones(ns,n)+(100-5)*rand(ns,n))*10^(6);    %BW:5-100MHz
SNR_dB = 2*randi(5,ns,n);                         %SNR:{0,2,4,6,8,10}dB
SNR = 10.^(SNR_dB./10);
AM = 1;
power = 10*log10(AM^2./(2*SNR));


%%
YLabel = ones(ns,n);      %%类别
YPred = ones(ns,n);       %%预测值

for i =1:1:ns
    YLabel(i,:)=YLabel(i,:).*(i-1);
    for j=1:1:n
        sig = Intra_pulse_IF_sig(RF(i,j),BW(i,j),PW(i,j),i-1);
        sig = sig + wgn(1,length(sig),power(i,j));          %每类信号生成10个，共100个测试样本
        YPred(i,j) = Modulation_Classify(sig);
    end
end
dif = find(YPred~=YLabel);
sprintf("The classification is done. The error rate is %.1f%%.",length(dif)/(ns*n)*100)

