function [rhoP1,rhoM1] = CostHILL(coverImg)
% coverImg: single or char
% 
%%
if(ischar(coverImg))
   coverImg = single(imread(coverImg)); 
end
wetCost = 10^8;
%% ��ͨH-KB�˲���
H = single([-1,2,-1; 2,-4,2; -1,2,-1]);
Y = filter2(H, coverImg, 'same');
%% ��ͨL1
L1 = ones(3,'single');
Y = filter2(L1, abs(Y), 'same');
%% ��ͨL2
L2 = ones(15,'single');
Cost = filter2(L2, Y.^-1, 'same');
Cost = Cost./sum(L1(:))./sum(L2(:));
%% adjust embedding costs
Cost(Cost > wetCost) = wetCost;
Cost(isnan(Cost)) = wetCost;
rhoP1 = Cost;  % +1 �Ĵ���
rhoM1 = Cost;
rhoP1(coverImg==255) = wetCost;
rhoM1(coverImg==0) = wetCost;
end