function QDCT = changeLFQDCT(QDCT, indSubBlockLF, changeRate, changeRateZero, debug)
% �޸ĵ�ƵQDCTϵ��
% indSubBlockLF:һ���ӿ�ĵ�Ƶϵ������
% changeRate:      ֵΪ1��ϵ���޸ĸ���
% changeRateZero   ֵΪ0��ϵ���޸ĸ���
% indSubBlockLF = [8,8; 8,7; 7,8; 8,6;7,7;6,8;8,5;7,6;6,7;5,8];

% ��ѡ�ĵ�Ƶϵ���ĸ���
nLF = size(indSubBlockLF, 1);
rQDCT = size(QDCT,1);
cQDCT = size(QDCT,2);
nBlock = floor(size(QDCT,1)/8) * floor(size(QDCT,2)/8);
% �ӿ��ά����
nRR = floor(size(QDCT,1)/8);
nCC = floor(size(QDCT,2)/8);
% ��һ�б�ʾ��һά������
indBlock = zeros(nBlock,2);
k=1;
for i=1:nRR
    indBlock(k:k+nCC-1, 1) = i;
    indBlock(k:k+nCC-1, 2) = 1:nCC;
    k = k+nCC;
end
% ȫ��QDCT��Ƶϵ������,һ�д���һ����Ƶϵ��������
indAllCoefLF = zeros(nBlock*nLF, 2);
offSet = (indBlock - ones(size(indBlock))) .* 8;
k=1;
for i=1:nBlock
    indAllCoefLF(k:k+nLF-1, :) = indSubBlockLF + ones(nLF,1) * offSet(i,:);
    k=k+nLF;
end

% ȫ����Ƶϵ���ĸ���
nAllLF = size(indAllCoefLF,1);
% ת��Ϊ��������
buf = zeros(nAllLF,1);
for i=1:nAllLF
    buf(i) = sub2ind([rQDCT,cQDCT], indAllCoefLF(i,1), indAllCoefLF(i,2));
end
indAllCoefLF = buf;
% ȫ���ĵ�Ƶϵ��
coeffLF = QDCT(indAllCoefLF);

% -------------------------------------------------------------------------
% �޸ĵ�Ƶϵ��
% ��Ƶϵ������
indCoefHF = setxor(indAllCoefLF, linspace(1,rQDCT*cQDCT,rQDCT*cQDCT));
% ���޸�ϵ������ indChangeable
mask = QDCT;
mask(indCoefHF) = inf;
% ���޸�ϵ��������
indZero = find(mask==0);
nZeroLF = length(indZero);
indChangeable = find(abs(mask) == 1);

% ���޸�ϵ���ĸ���
nChangeable = length(indChangeable);
% ���޸ĵ�ϵ������
nChange = ceil(changeRate * nChangeable);
% ����
indChangeable = indChangeable(randperm(nChangeable));
indBeChanged = indChangeable(1:nChange);
% �޸ľ���ֵΪ1��ϵ��
QDCT(indBeChanged) = QDCT(indBeChanged) + sign(QDCT(indBeChanged));

% �޸���ϵ��
if(~isnumeric(changeRateZero) || ~exist('changeRateZero','var'))
    changeRateZero=0;
else
    indZero = indZero(randperm(nZeroLF));
    nChangeZero = round(changeRateZero * nZeroLF);
    indBeChangedZero = indZero(1:nChangeZero);
    half = round(length(indBeChangedZero)/2);
    indN = indBeChangedZero(1:half);
    indP = indBeChangedZero(half+1:end);
    QDCT(indP) = 1;
    QDCT(indN) = -1;
end

% ����Ƕ��F5
QDCT = ReverseF5(QDCT, 0.0);
if(exist('debug', 'var'))
    fprintf('���޸�ϵ��1�ĸ���%d\n',nChangeable);
    fprintf('��Ƶ��ϵ������%d\n', nZeroLF)
    fprintf('���޸�ϵ��1�ĸ���%d\n', nChange);
    fprintf('���޸�ϵ��0�ĸ���%d\n', nChangeZero);
end
end

% ����Ƕ��F5
function QDCT = ReverseF5(QDCT, changeRate)
% 
% [QDCT, QTable, Cb, Cr] = getQDCT(cover, quality);
%% ----------------------------------------------------------------
% ����ACϵ��
nzAC = nnz(QDCT)-nnz(QDCT(1:8:end,1:8:end));
% ���޸ĵ�ϵ���ĸ���
nChanges = ceil(changeRate*nzAC);
if(nChanges<1)
    return;
end
% nChanges = ceil(nzAC / 2^k);
changeable = (QDCT~=0);
changeable(1:8:end,1:8:end) = false;
% ���޸ĵ�ϵ����λ��
changeable = find(changeable);
%rng('state',seed);
% ����
changeable = changeable(randperm(nzAC)); % create a pseudorandom walk over nonzero AC coefficients
to_be_changed = changeable(1:nChanges);   % coefficients to be changed

% ����ֵ��һ    
QDCT(to_be_changed) = QDCT(to_be_changed) + sign(QDCT(to_be_changed));

end

function k = getEfficiency(payload)
% ����Ƕ��Ч��k
switch(payload)
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
        fprintf('Unexpected payload:%f.2\n', payload);
        pause;
end
end