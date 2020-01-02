function [rhoP1,rhoM1] = CostHILL(cover)
% coverImg: single or char
% 
%%
if(ischar(cover))
   cover = single(imread(cover)); 
end
wetCost = 10^8;
%% ��ͨH-KB�˲���
H = [-1,2,-1; 2,-4,2; -1,2,-1];
Y = imfilter(cover, H, 'symmetric','conv','same');
% Y = filter2(H, cover, 'same');
%% ��ͨL1
L1 = ones(3);
Y = imfilter(abs(Y), L1,'symmetric','conv','same')./9;
% Y = filter2(L1, abs(Y), 'same');
%% ��ͨL2
L2 = ones(15);
Cost = imfilter(Y.^-1, L2,'symmetric','conv','same')./sum(L2(:));
% Cost = filter2(L2, Y.^-1, 'same');

%% adjust embedding costs
Cost(Cost > wetCost) = wetCost;
Cost(isnan(Cost)) = wetCost;
rhoP1 = Cost;  % +1 �Ĵ���
rhoM1 = Cost;
rhoP1(cover==255) = wetCost;
rhoM1(cover==0) = wetCost;
end

% ����HILLʵ��
% R = imfilter(cover, F, 'symmetric', 'conv', 'same');