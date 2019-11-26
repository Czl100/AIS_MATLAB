function immuSchemeTest()
clc;
startTime = datetime('now');
%% �����޸����ĺ���
calculNumOfModified = @(cQdct,sQdct) nnz((cQdct-sQdct));
%% ������������������
[streamAlg,streamAntb,s3] = RandStream.create('mrg32k3a', 'NumStreams', 3);

imgRoot = 'D:\MATLAB_Software\myInstall\bin\images\tmp\';
imgName = '8';
payLoad = single(0.40);                          % bpac:����Acϵ��
coverPath = [imgRoot,imgName,'.jpg'];
%%
indAlg = 2;
algNames = {'F5', 'nsF5', 'Juniwd'};
algHands = {@F5, @nsf5_simulation, @J_UNIWARD};
stegoPath = [imgRoot,imgName,'-',algNames{indAlg},'.jpg'];
immunPath = [imgRoot,imgName,'-immuned','.jpg'];
immunedStegoPath = [imgRoot,imgName,'-immuned-',algNames{indAlg},'.jpg'];

[cJobj, Q, ~] = getQDCT(coverPath);  cQdct = cJobj.coef_arrays{1};
Fc = ccpev548(coverPath, Q);
algObj = struct('algOperat',algHands{indAlg},'Q',Q,'Fc',Fc,'payLoad',payLoad,...
    'cJobj',cJobj, 'immunedStegoPath', immunedStegoPath);
%{
algHands{indAlg}(coverPath, stegoPath, payLoad);
Fs = ccpev548(stegoPath, Q);
fprintf('δ����\n dist: %.3f\n', calcu_fitness(Fc, Fs));
% [~, dist] = analyze_feature(Fc, Fs,  '����ǰ');
sQdct = getQDCT(stegoPath); sQdct = sQdct.coef_arrays{1};
fprintf('cQdct-sQdct: %.d\n', calculNumOfModified(cQdct,sQdct));
fprintf('------------------------------\n');
%}
%%
[rImg, cImg] = size(cQdct);
nBlocks = size(cQdct,1) * size(cQdct,2) / 64;

%% ѡ�з���ACϵ���ĸ�������threshold��8*8(��Ķ�ά����)
%  ����ÿ��8x8���з���ACϵ���ĸ���
nnzOfBlockHandle = @(truct_data) nnz(truct_data.data)-1;
numnzOfBlock = (blockproc(cQdct, [8,8], nnzOfBlockHandle));    
[sordNnzOfBlocks, indexBlocks] = sort(numnzOfBlock(:), 'descend');
%  ��ѡ�е�QDCT��**********************
% thresholdInd = round(0.1 * length(indexBlocks));
thresholdInd = 10;
indOfBlockSelected = indexBlocks(1:thresholdInd);
[r,c] = ind2sub(size(numnzOfBlock), indOfBlockSelected);
r = r-1;  c = c-1;
%  ��ѡ�е�ϵ��
selectedAllBlocksCoeff = zeros(size(cQdct));
indSelectedCoeff = [];
for i=1:length(r)
    t = zeros(size(cQdct));
    t( r(i)*8+1:r(i)*8+8, c(i)*8+1:c(i)*8+8) = 1;
    indSelectedCoeff = [indSelectedCoeff; find(t==1)];
    selectedAllBlocksCoeff( r(i)*8+1:r(i)*8+8, c(i)*8+1:c(i)*8+8) = 1;
end
%  ��ѡ�еĿ��ȫ��ϵ������������
%  indSelectedCoeff = find(selectedAllBlocksCoeff==1);
%  ƽ�����ϵ������������
indNoSelectedBlocksCoeff = find(selectedAllBlocksCoeff==0);

%% indOfExclude: ���в�����������ϵ������������
t1 = zeros(size(cQdct)); 
t1(1:8:end,1:8:end) = 1;
indOfDc = find(t1);                                 % DCϵ������������
indOfZeros = find(cQdct==0);                        % ��ϵ������������
indOfExcludes = unique([indOfDc; indOfZeros; indNoSelectedBlocksCoeff]);
indSelectedCoeff = setdiff(indSelectedCoeff, indOfExcludes, 'stable');

%% ���ߴ�����

%  512*2���󣬵�һ�б�ʾ�б��룬�ڶ��б�ʾ�б��룬��ʱֻ����������ͬ��ͼ��
%  ���DCϵ���Ķ�ά����
%% ����õ�modifiedMap
memory = struct('antibs',[],'fits',[]);
pInit = 0.2;
nAntib = 15;                            % �������
nGener = 10;
bestAntibs = [];
bestFits = zeros(nGener,1);
nReplace = round(nAntib*0.3);
lenCode = length(indSelectedCoeff);
antibs = initCodes(nAntib, lenCode, pInit, streamAntb);
for i=1:nGener
    %% ����һ����Ⱥ����Ӧ��       
    [fits,memory] = populaOperat(antibs, indSelectedCoeff, algObj, memory);
    [fits, ind] = sort(fits, 'ascend');     antibs = antibs(ind, :);
    %% �ռ���ѻ���Ƭ��
    priorGenes = gatherPriorGenes(antibs);
    
    %% ��¡ ����
    [pClones, pMus] = calcuPcloneMu(fits, pInit);        
    newAntibs = cloneMuOperat(antibs, priorGenes, pClones, pMus, streamAntb);   
    newAntibs = unique(newAntibs, 'rows');
    %% �ڶ��׶�
    [newFits,memory] = populaOperat(newAntibs, indSelectedCoeff, algObj, memory);
    allFits = [fits; newFits];  allAntibs = [antibs; newAntibs];
    [allFits, indFits] = sort(allFits, 'ascend');
    allAntibs = allAntibs(indFits, :);
    priorGenes = gatherPriorGenes(allAntibs);
        
    bestAntibs = [bestAntibs; allAntibs(1,:)];
    bestFits(i) = min(allFits);
    %% ���µĿ����滻���ֿ���
    allAntibs(nAntib+1:end, :) = [];    allFits(nAntib+1:end, :) = [];
    allAntibs(end-nReplace+1:end, :) = initCodes(nReplace, lenCode, pInit, streamAntb);

    [pClones, pMus] = calcuPcloneMu(allFits, pInit);    
    antibs = cloneMuOperat(allAntibs,priorGenes, pClones, pMus, streamAntb);
    antibs(end,:) = bestAntibs(end, :);
    antibs = unique(antibs, 'rows');
    fprintf('  %d:   %.3f\n', i, bestFits(i));
    fprintf('---------------------------------------------\n');
end
%}

%% ���Կ���
%{
load('bestAntibs.mat');
antib = bestAntibs(end, :);
fit = populaOperat(antib, indSelectedCoeff, algObj);
[D1, D2] = calcu_antibperfom(coverPath, stegoPath, immunedStegoPath);
analyze_feature(coverPath, [imgRoot,'8-Juniwd.jpg']);
%}

%% ��������ʱ��
endTime = datetime('now');
duraTime = endTime-startTime;
% minuTime=minutes(duraTime);
fprintf('����ʱ����');disp(duraTime);
%}
save('bestFits','bestFits');
save('bestAntibs','bestAntibs');
save('memory','memory');
end

%% һ����Ⱥ�ļ������
function [fits, memory] = populaOperat(antibs, indSelectedCoeff, algObj,memory)
cJobj = algObj.cJobj;   Fc = algObj.Fc;     Q = algObj.Q;
payLoad = algObj.payLoad;
immunedStegoPath = algObj.immunedStegoPath;
cQdct = cJobj.coef_arrays{1};
nAntib = size(antibs, 1);
fits = zeros(nAntib,1);
old_msg = '';
for j=1:nAntib
    %  ��ȥ�Ѿ�������Ŀ���
    if(~isempty(memory.antibs))
        [~,ind] = ismember( antibs(j,:), memory.antibs, 'rows');
        if( ind>0 )
            fits(j) = memory.fits(ind);
            continue;
        end
    end
    immunQdct = cQdct;
    immunQdct(indSelectedCoeff) = immunQdct(indSelectedCoeff) + antibs(j,:)';
    immunJobj = cJobj;  immunJobj.coef_arrays{1} = immunQdct;

    %% ��д
    algObj.algOperat(immunJobj, immunedStegoPath, payLoad);
    fits(j) = calcu_fit(Fc, immunedStegoPath, Q);
    %  ��¼���弰����Ӧ��
    memory.antibs = [memory.antibs; antibs(j,:)];
    memory.fits = [memory.fits; fits(j,:)];
    %  ��ӡ    
    msg = sprintf('- count: %d        %2.3f\n',j, fits(j));
    fprintf([repmat('\b',1,length(old_msg)), msg]);
    old_msg = msg;
end
fprintf('\n');
end

%% һ������ļ������
function fit = calcu_fit(Fc, immunedStegoPath, Q)
%% ͼ������
% PSNR = cacul_psnr(coverPath, immunedStegoPath);
% fprintf('PSNR: %.3f\n', PSNR);

%% ����������
Fts = ccpev548(immunedStegoPath, Q);
fit = calcu_fitness(Fc, Fts);
end

%% �ռ���ѻ���Ƭ��
function [priorGenes,geneStatic] = gatherPriorGenes(antibs)
%% ����1���Ƚ���Ӧ��������������, ��ȡ��ͬ�Ĳ���

n = size(antibs,1);
geneStatic = zeros(n-1,size(antibs,2)) + nan;
for i=1:n-1
    ind = find(antibs(i,:) - antibs(i+1,:));
    geneStatic(i,ind) = antibs(i,ind);
end
[counts,centers] = hist(geneStatic, [-1:1]);
[~,ind] = max(counts);
priorGenes = centers(ind)';


%% ����2���Ƚ���Ӧ��������������, ��ȡ��ͬ�Ĳ���
%{
priorGenes = zeros(1,size(antibs,2)) + nan;
ind = find( (antibs(1,:)-antibs(2,:)) == 0 );
priorGenes(ind) = antibs(1,ind);
geneStatic =0;
%}
end

%% ÿ�������Ӧ�Ŀ�¡���ʺͱ������
function [pClones, pMus] = calcuPcloneMu(fits, pInit)
bestFit = min(fits);
maxFit = max(fits);
range = max(fits) - min(fits);
nAntib = length(fits);
pClones = zeros(nAntib,1);
pMus = zeros(nAntib,1);
for i=1:nAntib
    pClones(i) = ((nAntib-i+1)/nAntib) * (maxFit - fits(i)) / range;
    pMus(i) = (fits(i) - bestFit) / range;
end
pClones = pClones * 0.5;
pClones(isnan(pClones)) = pInit;
pClones(isinf(pClones)) = pInit;

pMus(1) = pMus(2);
pMus(isnan(pMus)) = pInit;
pMus(isinf(pMus)) = pInit;
end

%% ��¡
function newAntibs = cloneMuOperat(antibs,priorGenes, pClones, pMus,randStrm)
num = size(antibs, 1);
newAntibs = [];
for i=1:num
    n = ceil(num*pClones(i));
    t = ones(n, 1) * antibs(i,:);
    t = muOperat(t, pMus(i), randStrm);
    % ע����ѻ���Ƭ��
    ind = find( isnan(priorGenes) );
    t(1:ceil(0.2*n), ind) = ones(ceil(0.2*n),1) * priorGenes(ind);
    newAntibs = [newAntibs; t];
end
newAntibs = unique(newAntibs, 'rows');
end

%% ����
function antibs = muOperat(antibs, P, randStrm)
% pMuԽ�󣬱���ĸ���Խ��
num = size(antibs,1);
codes = single(rand(randStrm, num, size(antibs,2), 'single'));
codes(codes < P*0.5) = -1;
codes(codes > P) = 0;
codes(codes > 0) = 1;
antibs = mod(antibs + codes, 2);
end

%% ��ʼ���������
function codes = initCodes(num, lenCode, P, randStrm)
% PԽ���޸ĵĸ���Խ��
codes = [];
PS = [0.2, 0.4, 0.6, 0.8];
for i=1:4
    code = single(rand(randStrm, floor(num/4), lenCode, 'single'));
    code(code < PS(i)*0.5) = -1;
    code(code > PS(i) ) = 0;
    code(code > 0) = 1;
    codes = [codes; code];
end
n = num - size(codes,1);
if(n>0)
    code = single(rand(randStrm, n, lenCode, 'single'));
    code(code < P*0.5) = -1;
    code(code > P ) = 0;
    code(code > 0) = 1;
    codes = [codes; code];
end
end


%%  ����1������codes
%{
%% ��Ч��������
t2 = ones(size(cQdct))*111;
t2(indOfExcludes) = 0;
%  ��Ч�б���
validRowsInd = find( sum(t2,2) > 0 );
%  ��Ч�б���
validColsInd = find( sum(t2) > 0 );


%% ��ʼ������
function [rCodes,cCodes] = initCodes(rows,cols,P, validRowsInd, validColsInd)
r = length(validRowsInd);
c = length(validColsInd);
validCodes = single(rand(r+c, 1,'single') > P);

rCodes = zeros(rows,1);
cCodes = zeros(cols,1);
rCodes(validRowsInd) = validCodes(1:r);    
cCodes(validColsInd) = validCodes(r+1:end);
end

%% ���±��룬����
function [rCodes, cCodes] = updataCodes(rCodes, cCodes,P, validRowsInd,validColsInd)
rLen = length(validRowsInd);
cLen = length(validColsInd);
t = single(rand(rLen+cLen, 1,'single') < P);

rCodes(validRowsInd) = mod( rCodes(validRowsInd) + t(1:rLen), 2);
cCodes(validColsInd) = mod( cCodes(validColsInd) + t(rLen+1:end), 2);
end

%% ������ת��Ϊ�޸�map
function modifiedMaps = codes2modfiedMap(rCodes, cCodes)
rLen = length(rCodes);
cLen = length(cCodes);
v = zeros(rLen, cLen);
for i=1:rLen
    for j=1:cLen
        v(i,j) = rCodes(i) * 2 + cCodes(j);
    end
end
modifiedMaps = rem(v-2, 2);
end
%}






