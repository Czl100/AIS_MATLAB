cRoot = 'E:\astego\Images\BOSS_ALL\';
sRoot = 'E:\astego\Images\stegos\SUNIWAD\SUNIWD_04\';
D_SUNWD = 0;

% ��������**��ʽ�ļ�
format='pgm';
cDirs = dir([cRoot,'*.',format]);
sDirs = dir([sRoot,'*.',format]);
num = length(cDirs);
D_SUNWD = zeros(num,1,'single');
count=0;  old=''; t0=datetime('now');
for i = 1:num
  % names{i}=coverDirs(i).name;
  cPath = [cRoot, cDirs(i).name];
  sPath = [sRoot, sDirs(i).name];
%   if(i==9819)
%     D =  calcuDist(single(imread(cPath)),single(imread(sPath)));
%   end
  % ����stego �� cover ֮���ʧ��ֵ
  D_SUNWD(i) =  calcuDist(single(imread(cPath)),single(imread(sPath)));
    
  % ��ӡ
  count=count+1;
  msg=sprintf('- count: %3d/%d',count,num);
  fprintf([repmat('\b',1,length(old)),msg]);
  old=msg;
end

clear i cPath sPath num count old t0 msg cRoot sRoot...
  cDirs sDirs format;
% save('SUNWD_04.mat','SUNWD_04');
% fprintf('\n��ʱ: ');  disp(datetime('now')-t0);