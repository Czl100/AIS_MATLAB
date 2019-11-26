function fetuStruct = getFeatures(imgRoot, numSample, Q)
% ����ͼ������
% imgPath       ͼ��Ŀ¼
% numSample:    ������������
% fetuStruct    ȫ��ά������
% addpath(genpath('./featureFile'));    % ����ļ�·��
%%
F=[];
count=0;  old='';
ImgLists = dir([imgRoot, '*.pgm']);  % ��������**��ʽ�ļ�
% ImgLists(1)=[];ImgLists(1)=[];
if isempty(ImgLists)
    Names = split(imgRoot, '\');
    Names = Names(end);
    F = structProce(SRM({imgRoot}),0);
else
    
    Names = cell(length(ImgLists),1);         % ͼ����,����ȫ��·��
    if numSample<=0
        numSample=length(ImgLists);
    end
    for i = 1:length(ImgLists)                % �����ṹ��Ϳ���һһ����ͼƬ��
        imgPath=[imgRoot ImgLists(i).name];
        Names{i}=ImgLists(i).name;
        % pgm��ʽ
        %{
        [~,~,format]=fileparts(imgName);    
        if(~isequal(format,'.pgm'))
            continue;
        end
        %}
        %F=[F;ccpev548(imgName,Q)];
        %F=[F;chen486(imgName)'];
        %F=[F;cchen972(imgName,80)'];
        %F=[F;SPAM686(imgName)'];
        %F=[F;mainDctrMex(imgName)];
        %F=[F;mainDctrMatlab(imgName)];
        %F=[F;CSR(imgName)];
        %F=[F;structProce(CFstar(imgName,80),1)];
        F=[F;structProce(SRMexample({imgPath}),0)];
        %F=[F;structProce(PSRM(imgName), 0)];
        %isstruct()    
        count=count+1;
        msg=sprintf('- count: %3d/%d',count,numSample);
        fprintf([repmat('\b',1,length(old)),msg]);
        old=msg;
        if count>=numSample
            break;
        end
    end
    fprintf('\nnumbel of img: %d\n', count);
end
[fetuStruct.names,ind]=sort(Names);
fetuStruct.F=F(ind, :);
end

%%
function F=structProce(S, reversal)
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