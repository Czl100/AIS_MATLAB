function [bestFits,bestAbs,meanFits] = CSA(srcPath,payLoad)
% ��¡ѡ���㷨, ��ͼ���񻯲��������Ż�
%%
payLoad = single(payLoad);
Root = 'E:\astego\CSA\';
name = 'xx.pgm';
sharpedPath = [Root,'sharpeds\',name];
sharpedStegoPath = [Root,'sharpedStegos\',name];
embedParas = struct('srcPath',srcPath,'sharpedPath',sharpedPath,...
    'sharpedStegoPath',sharpedStegoPath,'payLoad',payLoad);

NumParas = 4;  % ��������
NumTotal = 15; % �������
Iters = 10;    % ��������
Precision = 0.01;
Vmin = 0.5;  Vmax = 1.5;
L = log2( ((Vmax-Vmin)/Precision) + 1);
L = ceil(L);  % ���볤��
Memory.K = {};  Memory.V = zeros(20,1,'single');
Memory.last=uint8(1);

% output
bestAbs  = zeros(Iters, NumParas,'single');
bestFits = zeros(Iters, 1,'single');
meanFits = zeros(Iters,1,'single');
% ��ʼ��
MultRata = 0.3;
PClone = 0.3;  NumCloned = round(NumTotal * PClone);
PMuMin = 0.02;  PMuMax = 0.1;  PMu = PMuMin;
PNewMin = 0.1; PNewMax = 0.3; PNew= NumTotal*PNewMin;
genes = initAb(NumTotal, NumParas*L);
% ָ��ֵ����
genes(1,:)=zeros(1,size(genes,2));
genes(1,L:L:end)=1;
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
countBreak = 1; T = round(0.5*Iters);
for i=1:Iters
%% ������Ӧ��
  Abs = decodeAbs(genes, NumParas,Vmin,Vmax);  % N*NumParas array
  [fits, Memory]= fitOfAlg2(Abs, embedParas,Memory);
  % [fits, Memory]= calcuFit(Abs, embedParas,Memory);

  [fits, sortInd]= sort(fits, 'ascend');  % descend:����, Ҫ�����������ǰ��
  Abs= Abs(sortInd, :);
  genes= genes(sortInd, :);
  % ����
  if(size(genes,1) > NumTotal)
    genes(NumTotal+1:end,:) = []; Abs(NumTotal+1:end,:)=[];
    fits(NumTotal+1:end,:)=[];
  end
  % ��־
  bestAbs(i,:) = Abs(1,:);  % Abs array
  bestFits(i) = fits(1);
  meanFits(i) = mean(fits);
  fprintf('\nIter:%d - best fit: %5.3f\n', i,fits(1));

  if(fits(1) <=bestFits(end))
    countBreak = countBreak+1;
  else
    countBreak = 1;
    PMu = PMuMin;
    PNew = PNewMin;
  end
  if(countBreak >T)
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
clearvars -except bestFits bestAbs meanFits;
end