function tredObj = testTreat(cover, changeRates, tredPath, correlaRata, Dests)
% ���߲���, �޸ķ���
% cover������·��, jobj�ṹ��
% tredPath, Dests�ǿ�ѡ��
% ���tredObj
% changeRates:        ���޸ĵ�ϵ���ı���
% correlaRata         ����Ա���
% -------------------------------------------------------------------------
seed=99;rng('default');rng(seed);
if(ischar(cover))
    [jobj, quality, QTable, Cb, Cr] = getQDCT(cover);
    QDCT=jobj.coef_arrays{1};
else
    QDCT = cover.coef_arrays{1};
    jobj = cover;
end
% 4 1;3 2;2 3;1 4
mode=[
    2 1;1 2;    
   3 1;2 2;1 3;
  4 1;3 2;2 3;1 4      % Q=90
  ];
o=QDCT;

marks=zeros(size(QDCT));
for i=1:size(mode,1)   
    marks(mode(i,1):8:end, mode(i,2):8:end) = true;
end
% ��Ƶϵ����������
LFInd = find(marks);

%--------------------------------------------------------------------------
nChange = length(changeRates);
Srcs = 0:nChange-1;
if(~exist('Dsts', 'var') || length(Dests)~=length(Srcs))
    Dests = Srcs+1;
end
for i=1:nChange
    % ָ��ϵ���±�
    embedMarks = ( abs(QDCT)==Srcs(i) );
    embedMarks(1:8:end,1:8:end) = false;
    specificInd = find(embedMarks);
    linearInd = intersect(LFInd, specificInd);
    specificInd = linearInd(randperm(length(linearInd)));   % ָ��ϵ��λ��
    if(changeRates(i)>0)
        QDCT = moverValue(QDCT, specificInd, Srcs(i), Dests(i), changeRates(i));
    end
end

% ��ǿ��������
if(exist('correlaRata', 'var') && correlaRata>0 && correlaRata<1)
    QDCT=VCO_QDCT(QDCT, correlaRata);
end


% QDCT=HCO_QDCT(QDCT, 0.025);

%{
lenaͼ�����
% ��20%����ϵ������[1,2,3]
QDCT = moverValue(QDCT, lfInd, 0, [1,2,3],0.2);
QDCT=VCO_QDCT(QDCT, 0.5);

manͼ�����
QDCT = moverValue(QDCT, lfInd, 0, [4,6,6],0.5);
QDCT=VCO_QDCT(QDCT, 0.5);
%}
% ������������ͼ��
tredObj = jobj;
tredObj.coef_arrays{1} = QDCT;
if(exist('tredPath', 'var') && ischar(tredPath))
    jpeg_write(tredObj, tredPath);
end
end

%% ָ��ֵ��ϵ����-0
function QDCT=moverValue(QDCT, specificInd, Rst, Dsts, changeRate)
% �ƶ�һ��ֵΪRst��ϵ����Dsts���罫20%����ֵϵ������[1,2,3]

T = zeros(2*length(Dsts), 1);
T(1:2:end)=Dsts; T(2:2:end)=-1*Dsts;
Dsts=T;

linearInd = specificInd( 1:round(length(specificInd)* changeRate) );
% ��linearInd��nSections��,һ��һ�Σ�ÿ���ƶ���dst��һ��ֵ
nSections = length(Dsts);
% �޳�����Ĳ���
rest = mod(length(linearInd), nSections);
linearInd(1:rest)=[];
linearInd = reshape(linearInd, nSections,[]);

% �ƶ�
if(Rst==0)
    for i=1:nSections
        QDCT( linearInd(i,:) ) = Dsts(i);
    end
else
    for i=1:nSections
        character = sign(QDCT( linearInd(i,:)));        
        QDCT( linearInd(i,:)) = character .* abs(Dsts(i));
    end
end
end

%% 25Ϊ��������,��ǿ��ֱ�����������
function QDCT=VCO_QDCT(QDCT, changeRate)
% 
seed=99;rng('default');rng(seed);
QDCT_O = QDCT;
DC = QDCT(9:end,:); DC = DC(1:8:end, 1:8:end);
QDCT(1:8:end,1:8:end) = 1e8;
% vertical part
mBlockV = reshape(QDCT(1:end-8,:), [],1);
nBlockV = reshape(QDCT(9:end,:), [],1);
% Mv:7*7�� Mv(i,j)��ʾ��k��ֵΪi����k+1��ֵΪj��Ƶ����i,j��ΧΪ[-3,3]

% ��k��ֵ=1����k+1��ֵ=0
ind = [];
BUF = find( (abs(mBlockV)==1) & (nBlockV==0) );
BUF = BUF(randperm(length(BUF)));
BUF = BUF( 1: round(length(BUF)*changeRate) );
ind = [ind;BUF];

BUF = find((mBlockV==2) & (nBlockV==1));
BUF = BUF(randperm(length(BUF)));
BUF = BUF( 1: round(length(BUF)*changeRate) );
ind = [ind;BUF];

BUF = find((mBlockV==-2) & (nBlockV==-1));
BUF = BUF(randperm(length(BUF)));
BUF = BUF( 1: round(length(BUF)*changeRate) );
ind = [ind;BUF];
% �޸�
nBlockV(ind) = mBlockV(ind);
nBlockV=reshape(nBlockV, size(QDCT(9:end,:)) );
nBlockV(1:8:end, 1:8:end) = DC;
QDCT = [QDCT_O(1:8,:);nBlockV];
end

%% 25Ϊ��������,��ǿˮƽ�����������
function QDCT=HCO_QDCT(QDCT, changeRate)
% 
QDCT_O = QDCT;  DC = QDCT(:,9:end);
DC = DC(1:8:end, 1:8:end);
QDCT(1:8:end,1:8:end) = 1e8;
% ˮƽ����
mBlockV = reshape(QDCT(:, 1:end-8), [],1);
nBlockV = reshape(QDCT(:, 9:end), [],1);
% Mv:7*7�� Mv(i,j)��ʾ��k��ֵΪi����k+1��ֵΪj��Ƶ����i,j��ΧΪ[-3,3]

% ��k��ֵ=1����k+1��ֵ=0
ind = [];
BUF = find( (abs(mBlockV)==1) & (nBlockV==0) );
BUF = BUF(randperm(length(BUF)));
BUF = BUF( 1: round(length(BUF)*changeRate) );
ind = [ind;BUF];

BUF = find((mBlockV==2) & (nBlockV==1));
BUF = BUF(randperm(length(BUF)));
BUF = BUF( 1: round(length(BUF)*changeRate) );
ind = [ind;BUF];

BUF = find((mBlockV==-2) & (nBlockV==-1));
BUF = BUF(randperm(length(BUF)));
BUF = BUF( 1: round(length(BUF)*changeRate) );
ind = [ind;BUF];
% �޸�
nBlockV(ind) = mBlockV(ind);
nBlockV=reshape(nBlockV, size(QDCT(:,9:end)) );
nBlockV(1:8:end, 1:8:end) = DC;
QDCT = [QDCT_O(:,1:8), nBlockV];
end