function [stego, distortion] = HUGO_Input(cover, payload)
% HUGO�㷨������ļ�
% author: czl
% 
%% 
% set params
params.gamma = 1;
params.sigma = 1;

[stego, distortion] = HUGO_like(cover, payload, params);
end