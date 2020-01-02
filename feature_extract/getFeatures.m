function fetuStruct = getFeatures(imgRoot, nSamp)
% ����ͼ������
% imgPath       ͼ��Ŀ¼
% numSample:    ������������
% fetuStruct    ȫ��ά������
% addpath(genpath('./featureFile'));    % ����ļ�·��
%%
F=[];
count=0;  old='';
imgDirs = dir([imgRoot, '*.pgm']);  % ��������**��ʽ�ļ�
% ImgLists(1)=[];ImgLists(1)=[];
if isempty(imgDirs)
  names = split(imgRoot, '\');
  names = names(end);
  F = structProce(SRM({imgRoot}),0);
else
  names = cell(length(imgDirs),1); % ͼ����,����ȫ��·��
  if nSamp<=0
    nSamp=length(imgDirs);
  end
  for i = 1:length(imgDirs)
    imgPath=[imgRoot imgDirs(i).name];
    names{i}=imgDirs(i).name;
    F=[F;SRMProces( SRM({imgPath}), 0)];
    %F=[F;ccpev548(imgName,Q)];
    %F=[F;chen486(imgName)'];
    %F=[F;cchen972(imgName,80)'];
    %F=[F;SPAM686(imgName)'];
    %F=[F;mainDctrMex(imgName)];
    %F=[F;mainDctrMatlab(imgName)];
    %F=[F;CSR(imgName)];
    %F=[F;structProce(CFstar(imgName,80),1)];
    %F=[F;structProce(PSRM(imgName), 0)];
    
    % ��ӡ
    count=count+1;
    msg=sprintf('- count: %3d/%d',count,nSamp);
    fprintf([repmat('\b',1,length(old)),msg]);
    old=msg;
    if count>=nSamp
      break;
    end
  end
  fprintf('\nnumbel of img: %d\n', count);
end
[fetuStruct.names,ind]=sort(names);
fetuStruct.F=F(ind, :);
end