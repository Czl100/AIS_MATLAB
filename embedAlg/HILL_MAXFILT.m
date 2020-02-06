function stego = HILL_MAXFILT(cover,payload)
cover = single(imread(cover));
wetCost = 10^8;
%% ��ͨH-KB�˲���
KB = [-1,2,-1; 2,-4,2; -1,2,-1];
Y = imfilter(cover, KB, 'symmetric','conv','same');
% Y = filter2(H, cover, 'same');
%% ��ͨL1
L1 = ones(3);
Y = imfilter(abs(Y), L1,'symmetric','conv','same')./9;
% Y = filter2(L1, abs(Y), 'same');
%% ��ͨL2
Cost = ordfilt2((Y+1e-20).^-1, 11*11, true(11), 'symmetric');
% L2 = ones(15);
% Cost = imfilter(Y.^-1, L2,'symmetric','conv','same')./sum(L2(:));

%% adjust embedding costs
Cost(Cost > wetCost) = wetCost;
Cost(isnan(Cost)) = wetCost;
rhoP1 = Cost;  % +1 �Ĵ���
rhoM1 = Cost;
rhoP1(cover==255) = wetCost;
rhoM1(cover==0) = wetCost;

%% Embedding simulator
stego = EmbeddingSimulator(cover, rhoP1, rhoM1, payload*numel(cover), false);

end