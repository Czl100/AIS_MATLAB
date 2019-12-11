root = 'E:\astego\Images\standard_test_images\bmp\';
name = '195.bmp';
srcImg = single(imread([root,name]));
[rhoP1,rhoM1] = CostHILL(srcImg);


% ����cover �Ĵ��ۺ�ʧ��
coverRoot = 'E:\astego\Images\standard_test_images\bmp\';
stegoRoot = 'E:\astego\Images\test\stegos\';

% ��������**��ʽ�ļ�
coverDirs = dir([coverRoot, '*.bmp']);
stegoDirs = dir([stegoRoot, '*.bmp']);
% names = cell(length(coverDirs),1); % ͼ����,����ȫ��·��
num = length(coverDirs);
DFixed = zeros(num,1,'single');
count=0;  old=''; t0=datetime('now');
for i = 1:num
    % names{i}=coverDirs(i).name;
    cPath = [coverRoot, coverDirs(i).name];
    sPath = [stegoRoot, stegoDirs(i).name];
    % ����stego �� cover ֮���ʧ��ֵ
    % G1(i) = cacul_psnr(cPath, sPath);
    [DFixed(i),resid] =  calcuDist(single(imread(cPath)),single(imread(sPath)));
    
    % ��ӡ
    count=count+1;
    msg=sprintf('- count: %3d/%d',count,num);
    fprintf([repmat('\b',1,length(old)),msg]);
    old=msg;    
end
% save('��T1.mat','T1');
% fprintf('\n��ʱ: ');  disp(datetime('now')-t0);