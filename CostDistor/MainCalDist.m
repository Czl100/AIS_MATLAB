coverRoot = 'E:\astego\Images\Experis\1covers\';
stegoRoot = 'E:\astego\Images\Experis\UNWD04\';
DUNWD = 0;

% ��������**��ʽ�ļ�
coverDirs = dir([coverRoot, '*.bmp']);
stegoDirs = dir([stegoRoot, '*.bmp']);
num = length(coverDirs);
DUNWD = zeros(num,1,'single');
count=0;  old=''; t0=datetime('now');
for i = 1:num
  % names{i}=coverDirs(i).name;
  cPath = [coverRoot, coverDirs(i).name];
  sPath = [stegoRoot, stegoDirs(i).name];
  % ����stego �� cover ֮���ʧ��ֵ
  [DUNWD(i),R] =  calcuDist(single(imread(cPath)),single(imread(sPath)));
  %DHILL(i) = cacul_psnr(cPath, sPath);

  % ��ӡ
  count=count+1;
  msg=sprintf('- count: %3d/%d',count,num);
  fprintf([repmat('\b',1,length(old)),msg]);
  old=msg;
end
clearvars -except DUNWD DHUGO DHILL;
% save('DHILL.mat','DHILL');
% fprintf('\n��ʱ: ');  disp(datetime('now')-t0);