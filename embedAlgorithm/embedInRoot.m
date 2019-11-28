function embedInRoot(coverRoot, payLoad, stegoRoot, numSample)
% ������д�㷨��Ŀ¼�е�ͼ�������д
% coverRoot       ͼ��Ŀ¼
% stegRoot      �������ͼ��Ŀ¼
% numSample:    ������������
% addpath(genpath('./featureFile'));      % ����ļ�·��
t0 = datetime('now');
coverRoot = 'E:\astego\Images\Experis\covers\';
stegoRoot = 'E:\astego\Images\Experis\stegos\UNWD\';
payLoad = single(0.3);
numSample = -1;

imgFiles  = dir([coverRoot, '*.pgm']);       % ��������jpg��ʽ�ļ�
% imgFiles(1)=[];imgFiles(1)=[];
Names=cell(length(imgFiles),1);           % ͼ����,����ȫ��·��
if (~exist('numSample', 'var') || numSample<1)
    numSample=length(imgFiles);
end
nImages = length(imgFiles);
old='';
for i = 1:nImages                % �����ṹ��Ϳ���һһ����ͼƬ��
    imgName=[coverRoot imgFiles(i).name];
    Names{i}=imgFiles(i).name;
    % Ƕ���㷨
    stego = S_UNIWARD(imread([coverRoot,Names{i}]), payLoad);
    %stego = HILL([coverRoot,Names{i}], payLoad);
    imwrite(uint8(stego), [stegoRoot,Names{i}], 'pgm');
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