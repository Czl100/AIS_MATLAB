% ����cover �Ĵ��ۺ�ʧ��
coverRoot = 'E:\astego\Images\covers\��G3����_Am1\';
stegoRoot = 'E:\astego\Images\stegos\HUGO\��G3_Am1_HUGO_04\';

% ��������**��ʽ�ļ�
coverDirs = dir([coverRoot, '*.pgm']); % coverDirs(1)=[];coverDirs(1)=[];
stegoDirs = dir([stegoRoot, '*.pgm']); % stegoDirs(1)=[];stegoDirs(1)=[];
% names = cell(length(coverDirs),1);           % ͼ����,����ȫ��·��
num = length(coverDirs);
D3 = zeros(num,1,'single');
count=0;  old=''; t0=datetime('now');
for i = 1:num
    % names{i}=coverDirs(i).name;
    cPath = [coverRoot, coverDirs(i).name];
    sPath = [stegoRoot, stegoDirs(i).name];
    % ����stego �� cover ֮���ʧ��ֵ
    % G1(i) = cacul_psnr(cPath, sPath);
    [D3(i),resid] =  calcuDist(cPath, sPath);
    
    
    % ��ӡ
    count=count+1;
    msg=sprintf('- count: %3d/%d',count,num);
    fprintf([repmat('\b',1,length(old)),msg]);
    old=msg;    
end
% save('HILL_04','HILL_04');
% fprintf('\n��ʱ: ');  disp(datetime('now')-t0);