function embedInRoot(coverRoot, payload, stegoRoot, numSample)
% ������д�㷨��Ŀ¼�е�ͼ�������д
% coverRoot       ͼ��Ŀ¼
% stegRoot      �������ͼ��Ŀ¼
% numSample:    ������������
% addpath(genpath('./featureFile'));      % ����ļ�·��
t0 = datetime('now');
coverRoot = 'E:\astego\Images\standard_test_images\bmp\';
stegoRoot = 'E:\astego\Images\test\stegos\';
payload = single(0.4);
numSample = -1;

dirs  = dir([coverRoot, '*.bmp']);
% imgFiles(1)=[];imgFiles(1)=[];
names=cell(length(dirs),1);           % ͼ����,����ȫ��·��
if (~exist('numSample', 'var') || numSample<1)
    numSample=length(dirs);
end
nImages = length(dirs);
old='';
for i = 1:nImages                % �����ṹ��Ϳ���һһ����ͼƬ��
    names{i}=dirs(i).name;
    cPath=[coverRoot,dirs(i).name];
    % Ƕ���㷨
    stego = HUGO_like(imread(cPath), payload);
    imwrite(uint8(stego), [stegoRoot,names{i}], 'bmp');
    %stego = S_UNIWARD(imread([coverRoot,Names{i}]), payLoad);
    %stego = HILL([coverRoot,Names{i}], payLoad);
    % J_UNIWARD([coverRoot,Names{i}], [stegRoot,Names{i}], single(payLoad));
    % F5([coverRoot,Names{i}], payLoad, [stegRoot,Names{i}]);
    % nsf5_simulation([coverRoot,Names{i}], [stegRoot,Names{i}], payLoad,seed);
    % I = double(imread(imgName));
    % steg =LSBM(I, payLoad);imwrite(uint8(steg), [stegRoot, Names{i}]);
    
    % ��ӡ
    msg=sprintf('- count: %3d/%d',i,numSample);
    fprintf([repmat('\b',1,length(old)),msg]);
    old=msg;    
    if i>=numSample
        break;
    end
end
fprintf('\nnumbel of img: %d\n', i);
fprintf('\n��ʱ: '); disp(datetime('now')-t0);
end