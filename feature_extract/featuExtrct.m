% ��ȡĿ¼������ͼ�������
%%
cDir= 'E:\astego\Images\standard_images\covers\';
sDir = 'E:\astego\Images\StandExpers\czl4\';
name= '195.pgm';
cPath=[sDir,name];
% S_CZL4_SRM_04 = getFeatures(sDir, -1);

%% ���ش�C++��������ȡ��������������

path1 = 'E:\astego\StandExpers\����CPP\CZL\';
% path2 = 'E:\astego\����CPP\MiPOD_04\2\';
% path3 = 'E:\astego\����CPP\HUGOOPT1_04\3\';
% path4 = 'E:\astego\����CPP\HUGOOPT1_04\4\';

F1 = LoadFeature(path1);
% F2 = LoadFeature(path2);
% F3 = LoadFeature(path3);
% F4 = LoadFeature(path4);

S_CZL04_SRM.names= F1.names;
S_CZL04_SRM.F= single(F1.F);
clear F1 F2 F3 F4;
[S_CZL04_SRM.names, ind]= sort(S_CZL04_SRM.names);
S_CZL04_SRM.F = S_CZL04_SRM.F(ind, :);
% save('S_MiPOD_04_SRM', 'S_MiPOD_04_SRM');
%}