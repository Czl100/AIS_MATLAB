% ��ȡĿ¼������ͼ�������
%%
clc;close all;
imgPath = 'E:\astego\Images\BOSS_SUB\1.pgm';
% F = getFeatures(imgPath, 1, 0);

% norm(T.F(1,:) - T.F(2,:));
% save('S_HUGO04_SRM', 'S_HUGO04_SRM');


%% ���ش�C++��������ȡ��������������
path1 = 'E:\astego\����CPP\��T2_HUGO04\';
path2 = 'E:\astego\����CPP\��T1_HUGO04\2\';
path3 = 'E:\astego\����CPP\��T1_HUGO04\3\';
path4 = 'E:\astego\����CPP\��T1_HUGO04\4\';

F1 = LoadFeature(path1);
% F2 = LoadFeature(path2);
% F3 = LoadFeature(path3);
% F4 = LoadFeature(path4);

% S_SharpedT1_HUGO04_SRM.names= [F1.names;F2.names; F3.names;F4.names;];
% S_SharpedT1_HUGO04_SRM.F= single([F1.F; F2.F; F3.F;F4.F;]);
S_SharpedT2_HUGO04_SRM.names = F1.names;
S_SharpedT2_HUGO04_SRM.F = single(F1.F);
clear F1 F2 F3 F4;
[S_SharpedT2_HUGO04_SRM.names, ind]= sort(S_SharpedT2_HUGO04_SRM.names);
S_SharpedT2_HUGO04_SRM.F = S_SharpedT2_HUGO04_SRM.F(ind, :);
save('S_SharpedT2_HUGO04_SRM', 'S_SharpedT2_HUGO04_SRM');