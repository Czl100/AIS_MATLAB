% cRoot = 'E:\astego\StandExpers\covers\';
% sRoot = 'E:\astego\StandExpers\CZL\';
cRoot='E:\astego\Images\standard_images\bmp\';
sRoot='E:\astego\Images\stegos\HUGO\��T2_HUGO04\';
D_T2 = 0;

% ��������**��ʽ�ļ�
format='bmp';
cDirs = dir([cRoot,'*.',format]);
% sDirs = dir([sRoot,'*.',format]);
num = length(cDirs);
D_T2 = zeros(num,1,'single');
PSNR = zeros(num,1); names=cell(num,1);
count=0;  old=''; t0=datetime('now');
for i = 1:num
  names{i}=cDirs(i).name;
  cPath = [cRoot, cDirs(i).name];
  %sPath = [sRoot, sDirs(i).name];

  % ����stego �� cover ֮���ʧ��ֵ
  src= single(imread(cPath));
  Am = 0.7;
  [sharped, HF] = sharpen(src, Am);
  stego = HUGO_like(uint8(sharped), single(0.4)); stego=single(stego);

  PSNR(i) = round(cacul_psnr(stego,src) ,3);
  %D_T2(i) =  calcuDist(single(imread(cPath)),single(imread(sPath)));
    
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