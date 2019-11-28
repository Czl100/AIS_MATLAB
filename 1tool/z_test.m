function z_test()
srcRoot = 'E:\astego\Images\standard_test_images\bmp\';
dstRoot = 'E:\astego\Images\standard_test_images\pgm\';
numSample = -1;

imgFiles  = dir([srcRoot, '*.bmp']);       % ��������jpg��ʽ�ļ�
Names=cell(length(imgFiles),1);           % ͼ����,����ȫ��·��
if (~exist('numSample', 'var') || numSample<1)
    numSample=length(imgFiles);
end
nImages = length(imgFiles);
old='';
for i = 1:nImages                % �����ṹ��Ϳ���һһ����ͼƬ��   
    Names{i}=imgFiles(i).name;
    src = imread([srcRoot,Names{i}]);
    name = split(Names{i},'.');  name = name{1};
    imwrite(src, [dstRoot,name,'.pgm'], 'pgm');
    % ��ӡ
    msg=sprintf('- count: %3d/%d',i,numSample);
    fprintf([repmat('\b',1,length(old)),msg]);
    old=msg;    
    if i>=numSample
        break;
    end
end
end

%% Ƶ����д, nsF5
function ztest()
close all;
clear all;
seed = 99;rng('default');rng(seed);tic;   
imgRoot = 'E:\astego\embedAlg\img_jpg_500\';
imgName = '41';
payLoad = single(0.40);                          % bpac:����Acϵ��
coverPath = [imgRoot, imgName, '.jpg'];
payLoads = single([0.1,0.2,0.3,0.4]);

quality = getQuality(coverPath);
Fc = ccpev548(coverPath, quality);
%% ��д
algNames = {'F5', 'nsF5', 'Juniwd'};
stegoPath = [imgRoot, 'z-',algNames{3},'-',imgName,'.jpg'];
algHands = {@F5, @nsf5_simulation, @J_UNIWARD};
getDiffOfFeature(coverPath,stegoPath,algHands{3}, payLoad)

Fs = cell(length(algHands), 1);
fits = zeros(length(algHands), 1);
% ��ͬ�㷨
for i=1:length(algHands)    
    stegoPath = [imgRoot, 'z-',algNames{i},'-',imgName,'.jpg'];    
    algHands{i}(coverPath, stegoPath, payLoad);
    % ��ȡ����
    Fs{i} = ccpev548(stegoPath, quality);
    fits(i) = calcu_fitness(Fc, Fs{i});
    fprintf('%8s:  %.3f\n',algNames{i}, fits(i));
end
%}
% ��ͬǶ����
%{
Fs = cell(length(payLoads), 1);
fits = zeros(length(payLoads), 1);
i = 1;
for j=1:length(payLoads)
    break;
    stegoPath = [imgRoot, 'z-',algNames{i},'-',imgName,'.jpg'];    
    algHands{i}(coverPath, stegoPath, payLoads(j));
    % ��ȡ����
    Fs{j} = ccpev548(stegoPath, quality);
    fits(j) = calcu_fitness(Fc, Fs{j});
    fprintf('%.2f:    %.3f\n',payLoads(j), fits(j));
end
%}
%% ��ȡ����

%% ��������
%{
nameAlg = 'F5'; nameFea = 'CCPEV';
Fc = ccpev548(coverPath, quality);
Fs = ccpev548(stegoPath, quality);
% Fts = ccpev548(tredStegoPath, quality);
analyze_feature(Fc, Fs,  '����ǰ');
% analyze_feature(Fc, Fts, '�����');


Fc(166:168)=0;  Fs(166:168)=0;  Fts(166:168)=0;
Fc(166+274:168+274)=0;  Fs(166+274:168+274)=0;  Fts(166+274:168+274)=0;
% analyze_histogram(Fc(1:274), Fs(1:274), '����ǰ����������');
% analyze_histogram(Fc(1:274), Fts(1:274),'���������������');
analyze_histogram(Fc, Fs, '����ǰ����������');
analyze_histogram(Fc, Fts,'���������������');

% T = toc;    fprintf('��ʱ:%f\n', T);
%}

%% ֱ��ͼͳ��
%{
jobj = getQDCT(coverPath, quality);coverQDCT = jobj.coef_arrays{1};
jobj = getQDCT(stegoPath, quality);stegoQDCT = jobj.coef_arrays{1};
% jobj = getQDCT(treatedStegoPath, quality);treatedStegoQDCT = jobj.coef_arrays{1};
statistic(coverQDCT, stegoQDCT, -8:8);
% statistic(coverQDCT, treatedStegoQDCT, -8:8);

% ����PSNR

ps_nr=cacul_psnr(coverName, stegoName)
ps_nr=cacul_psnr(coverName, treatedStegoName)
%}

%% ������Ӧ��
end

%% �Ա�����������ͼ����������Ա仯��
function getDiffOfFeature(coverPath,stegoPath,algHandle,payload)
Q = getQuality(coverPath);
algHandle(coverPath, stegoPath, payload);
Fc = ccpev548(coverPath, Q);
Fs = ccpev548(coverPath, Q);
analyze_feature(Fc, Fs);
end