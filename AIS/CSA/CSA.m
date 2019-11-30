function [bestFits,bestAbs,meanFits,Memory] = CSA(srcPath,payLoad)
% ��¡ѡ���㷨, ��ͼ���񻯲��������Ż�
% 
%%
payLoad = single(payLoad);
Root = [pwd,'\Experis\'];
% name = split(srcPath, '\');  name = name(end);
name = 'xx.pgm';
% srcStegoPath= [Root,'stegos\', name];
sharpedPath = [Root,'sharpeds\',name];
sharpedStegoPath = [Root,'sharpedStegos\',name];
embedParas = struct('srcPath',srcPath,'sharpedPath',sharpedPath,...
    'sharpedStegoPath',sharpedStegoPath,'payLoad',payLoad);
% srcData = single(imread(srcPath));
% srcStegoData = HUGO_like(uint8(srcData), payLoad);
% imwrite(uint8(srcStegoData),srcStegoPath, 'pgm');

Precision = 0.001;
Vmin = 0;  Vmax = 1.4;
L = log2( ((Vmax-Vmin)/Precision) + 1);
L = ceil(L);  % ���볤��
NumParas = 1;  % ��������
NumTotal = single(15);  % �������
Iters = 8;  % ��������
Memory = containers.Map('KeyType','char','ValueType','double');
% save([pwd,'\Memory.mat'],'Memory');clear Memory;
% output
bestFits = zeros(Iters, 1);
bestAbs = cell(Iters, 1);
meanFits = zeros(Iters,1);
% ��ʼ��
MultRata = 0.3;
PClone = 0.3;  NumCloned = round(NumTotal * PClone);
PMuMin = 0.02;  PMuMax = 0.1;  PMu = PMuMin;
PNewMin = 0.1; PNewMax = 0.3; PNew= NumTotal*PNewMin;
T = 6;
genes = initAb(NumTotal, NumParas*L);
% 0ֵ����
genes(1,:) = zeros(1,NumParas*L);
% ------------------����Castro---------------------------------
%{
f = '1 * x .* sin(4 * pi .* x) - 1 * y.* sin(4 * pi .* y + pi) + 1';
[x,y] = meshgrid(-1:0.05:1,-1:0.05:1); vxp = x; vyp = y;
vzp = eval(f);  % ����ֵ
NumParas=2;
Abs = decodeAbs(genes, NumParas, Vmin, Vmax);
Abs = cell2mat(Abs);
x = Abs(:,1);
y = Abs(:,2);
fit = eval(f);
imprime(1,vxp,vyp,vzp,x,y,fit,1,1); title('Initial Population');
% ------------------����end---------------------------------
%}

%% ��ʼ����
for i=1:Iters
%% ������Ӧ��
Abs = decodeAbs(genes, NumParas,Vmin,Vmax);  % N*NumParas cell
% save([pwd,'\genes.mat'], 'genes'); clear genes;
% load([pwd,'\Memory.mat']);
[fits, Memory] = calcuFit(Abs, embedParas, Memory);

% load([pwd,'\genes.mat']);
[fits, sortInd]= sort(fits, 'ascend');  % descend:����, Ҫ�����������ǰ��
Abs= Abs(sortInd, :);
genes= genes(sortInd, :);
% ����
if(size(genes,1) > NumTotal)
    genes(NumTotal+1:end,:) = []; Abs(NumTotal+1:end,:)=[];
    fits(NumTotal+1:end,:)=[];
end
% ��־
bestFits(i) = fits(1);
bestAbs(i) = Abs(1);  % Abs: cell
meanFits(i) = mean(fits);
% fprintf('\nIter:%d - best fit: %5.3f\n', i,fits(1));

if(fits(1) <=bestFits(end))
    countBreak = countBreak+1;
else
    countBreak = 1;
    PMu = PMuMin;
    PNew = PNewMin;
end
if(countBreak > T)
    break;
elseif(countBreak > 0.5*T)
    PMu = PMuMax;
    PNew = PNewMax;
end
%% ��¡
[tmpGenes, pcs] = reprod(genes, NumCloned, MultRata);
% ����
M = rand(size(tmpGenes)) <= PMu;  % M=1, 0,1��ת, ���򲻱�
tmpGenes = tmpGenes - 2 .* (tmpGenes.*M) + M;
% ά����������Ab
tmpGenes(pcs,:) = genes(1:NumCloned, :);
genes = [tmpGenes; initAb(NumTotal*PNew, NumParas*L)];
clear tmpGenes;
% for-end
end
% load([pwd,'\Memory.mat']);
clearvars -except bestFits bestAbs meanFits Memory;
end