coverRoot = 'E:\astego\Images\BOSS_ALL\';
stegoRoot = 'E:\astego\Images\stegos\HILL_04\';
HILL_04 = 0;

% ��������**��ʽ�ļ�
coverDirs = dir([coverRoot, '*.pgm']);
stegoDirs = dir([stegoRoot, '*.pgm']);
num = length(coverDirs);
HILL_04 = zeros(num,1,'single');
count=0;  old=''; t0=datetime('now');
for i = 1:num
  % names{i}=coverDirs(i).name;
  cPath = [coverRoot, coverDirs(i).name];
  sPath = [stegoRoot, stegoDirs(i).name];
  % ����stego �� cover ֮���ʧ��ֵ
  %[HILL_04(i),R] =  calcuDist(single(imread(cPath)),single(imread(sPath)));
  
  % ��ӡ
  count=count+1;
  msg=sprintf('- count: %3d/%d',count,num);
  fprintf([repmat('\b',1,length(old)),msg]);
  old=msg;
end
% save('SUNWD_04.mat','SUNWD_04');
clear i cPath sPath num count old t0 msg coverRoot stegoRoot...
  coverDirs stegoDirs;
% fprintf('\n��ʱ: ');  disp(datetime('now')-t0);