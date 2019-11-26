function F = LoadFeature(FeatRoot)
% ���ش�C++��������ȡ�����ĵ���ͼ���SRM����
% ��������ϼ��������������
%% 
% FeatDir  = dir([FeatRoot '*.*']);         % ��������**��ʽ�ļ�
% FeatDir(1)=[];   FeatDir(1)=[];
load('D:\Program Files\Matlab2017b\bin\featureExtract\SRMFeatOrder.mat');
f = [];
num = size(SRMFeatOrder, 1);
old='';
for i = 1:num                % �����ṹ��Ϳ���һһ����ͼƬ��    
    path = [FeatRoot, SRMFeatOrder{i}, '.fea'];
    featmp = load(path);
    featmp(:, end) = [];
    f = [f, featmp];
    
    msg=sprintf('- count: %3d/%d', i, num);
    fprintf([repmat('\b',1,length(old)),msg]);
    old=msg;
end
% ͼ�������
path = [FeatRoot, SRMFeatOrder{1}, '.fea'];
featmps = load(path);  featmps(:, 1:end-1) = [];
names = cell(length(featmps), 1);
for i=1:size(names,1)
    names{i} = [num2str(featmps(i)), '.pgm'];
end
F.names = names;  F.F = f;
end

%%
function F = structProce(S, reversal)
% reversal���Ƿ�ת��
    propertys=fieldnames(S);
    len=length(propertys);
    F=[];
    if(reversal)
        for i=1:len
            F=[F; getfield(S,propertys{i})];
        end
        F=F';
    else
        for i=1:len
            F=[F, getfield(S,propertys{i})];
        end
    end
end