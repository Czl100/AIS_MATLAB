function [rhoP1,rhoM1] = CostHILL(coverImg)
%COSTUNIWD �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
%%
if(ischar(coverImg))
   coverImg = imread(coverImg); 
end
coverImg = single(coverImg);
% [M,N] = size(coverImg);
wetCost = 10^8;
%% ��ͨH-KB�˲���
H = single([-1,2,-1; 2,-4,2; -1,2,-1]);
Y = filter2(H, coverImg, 'same');
%% ��ͨL1
L1 = single(ones(3));
Y = filter2(L1, abs(Y), 'same');
%% ��ͨL2
L2 = single(ones(15));
Cost = filter2(L2, Y.^-1, 'same');
%% adjust embedding costs
Cost(Cost > wetCost) = wetCost; % threshold on the costs
Cost(isnan(Cost)) = wetCost; % if all xi{} are zero threshold the cost
rhoP1 = Cost;  % +1 �Ĵ���
rhoM1 = Cost;
rhoP1(coverImg==255) = wetCost; % do not embed +1 if the pixel has max value
rhoM1(coverImg==0) = wetCost; % do not embed -1 if the pixel has min value
end