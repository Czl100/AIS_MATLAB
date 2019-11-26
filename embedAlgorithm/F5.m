function [stegObj, nChanges, nzAC,k] = F5(cover, stegoPath, payload)
% -------------------------------------------------------------------------
% cover������·����jobj�ṹ��
% ����Ƕ��Ч�ʼ�����޸���, Ƕ��Ч�ʿ���������ЧӦ
% -------------------------------------------------------------------------

% ����Ϊ�ļ�·��
if( ischar(cover) )
    jobj = jpeg_read(cover);    % JPEG image structure
    % QDCT = jobj.coef_arrays{1};  % DCT plane    
    [QDCT,nChanges, nzAC,k] = modify(jobj.coef_arrays{1}, payload);
    jobj.coef_arrays{1} = QDCT;
    jobj.optimize_coding = 1;
    stegObj = jobj;
% ����Ϊjobj�ṹ��
elseif( isstruct(cover) )
    [QDCT,nChanges, nzAC,k] = modify(cover.coef_arrays{1}, payload);
    stegObj = cover;
    stegObj.coef_arrays{1} = QDCT;
    stegObj.optimize_coding = 1;
% ����Ϊͼ������
else
    [QDCT, QTable, Cb, Cr] = getQDCT(cover, quality);
    [QDCT,nChanges, nzAC,k] = modify(QDCT, payload, isreduce);
    stegoPixel = qdct2Img(QDCT, QTable, Cb, Cr);
end
% changeRata = nChanges/numel(QDCT);
% fprintf('F5 changeRata:%d\n', changeRata);
jpeg_write(stegObj, stegoPath);
end

% �޸�QDCT
function [QDCT,numChanged, numNzAC,k] = modify(QDCT, payload)
% payload:          Ƕ���ʻ�����ҪǶ���������
seed = 99;rng('default');rng(seed);
if (payload > 0)    
	[numChanged, k, nEmbed] = getEfficiency(QDCT,payload);  % nEmbed:��ҪǶ���������
    % numChanged�����޸�ϵ��������
    changeableInd = (QDCT~=0);
    changeableInd(1:8:end,1:8:end) = false;
    numNzAC = nnz(changeableInd);                     % ����Acϵ��������
    % ���޸ĵ�ϵ����λ��
    changeableInd = find(changeableInd);              % indexes of the changeable coefficients
    %rand('state',seed);                              % initialize PRNG using given SEED    
    % ����
    changeableInd = changeableInd(randperm(numNzAC)); % create a pseudorandom walk over nonzero AC coefficients        
    to_be_changed = changeableInd(1:numChanged);      % coefficients to be changed    
    % ����ֵ��һ    
    QDCT(to_be_changed) = QDCT(to_be_changed) - sign(QDCT(to_be_changed));
end
end

function [numChanged,k,nEmbed,effci] = getEfficiency(Qdct,payload)
% numChanged:       ���޸ĵ�����
% payload:          Ƕ���ʻ�����ҪǶ���������
% nEmbed��           ��ҪǶ���������
%{
����Ƕ��Ч��k
switch(double(payload))
    case 0.6
        k=2;
    case 0.5
        k=2;
    case 0.4
        k=3;
    case 0.3
        k=3;
    case 0.2
        k=4;
    case 0.1
        k=5;
    otherwise
        k =1;
        fprintf('Unexpected payload:%f\n', payload);
        pause;
end
%}

% -------------------------------------------------------------------------
% ����f5-java�����޸�Ƕ��Ч�ʵļ��㹫ʽ
% ����Acϵ��, ���ڼ���ʵ��Ƕ����
numNzAc = nnz(Qdct~=0)-nnz(Qdct(1:8:end,1:8:end)~=0);
Qdct(1:8:end,1:8:end) = inf;
numZero = nnz(Qdct==0);         % ֵΪ0��Ac����
numOne = nnz(abs(Qdct)==1);     % ֵΪ1�ĸ���
numDc = nnz(Qdct==inf);         % DCϵ���ĸ���
large = numel(Qdct) - numZero - numOne - numDc;
capcity = large + 0.49*numOne;  % Ƕ������
% ��ҪǶ���������nEmbed
if(payload>5)
    nEmbed = payload;
else
    nEmbed = numNzAc*payload;       % payload: bpac-ÿ������Acϵ��Я��������Ϣ
end

% ��Ƕ��������canEmbed
canEmbed = 0;
for k=7:-1:1                    % ע��k==1
    % kԽС, canEmbedԽ��
    n = 2^k-1;
    canEmbed = (capcity/n)*k - mod((capcity/n)*k, n);
    if(canEmbed>=nEmbed)
        break;
    end
end

switch(k)
    case 1 
        effci=1.4;
    case 2 
        effci=1.6;
    case 3 
        effci=2.0;
    case 4 
        effci=2.3;
    case 5 
        effci=2.6;
    case 6 
        effci=3.2;
    case 7 
        effci=3.2;
end
%{
% ����Ƕ��Ч��(�����java����Ľ����ͬ)
t = large - mod(large,n+1);
t = (t + numOne*1.5 - numOne/(n+1)) / (n+1);
effci=canEmbed/t + 0.1*mod( canEmbed*10/t, 10);
%}
% ���޸ĵ�����
numChanged = round(nEmbed/effci);
end