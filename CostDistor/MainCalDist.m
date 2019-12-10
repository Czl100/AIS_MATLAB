% ����cover �Ĵ��ۺ�ʧ��
coverRoot = 'E:\astego\Images\covers\��T1Cover\';
stegoRoot = 'E:\astego\Images\stegos\HUGO\��T1_HUGO04\';

% ��������**��ʽ�ļ�
coverDirs = dir([coverRoot, '*.pgm']);
stegoDirs = dir([stegoRoot, '*.pgm']);
% names = cell(length(coverDirs),1); % ͼ����,����ȫ��·��
num = length(coverDirs);
T1 = zeros(num,1,'single');
count=0;  old=''; t0=datetime('now');
for i = 1:num
    % names{i}=coverDirs(i).name;
    cPath = [coverRoot, coverDirs(i).name];
    sPath = [stegoRoot, stegoDirs(i).name];
    % ����stego �� cover ֮���ʧ��ֵ
    % G1(i) = cacul_psnr(cPath, sPath);
    [T1(i),resid] =  calcuDist(single(imread(cPath)),single(imread(sPath)));
    
    % ��ӡ
    count=count+1;
    msg=sprintf('- count: %3d/%d',count,num);
    fprintf([repmat('\b',1,length(old)),msg]);
    old=msg;    
end
save('��T1.mat','T1');
% fprintf('\n��ʱ: ');  disp(datetime('now')-t0);