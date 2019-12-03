close all;clc;
% clear;clc;
Root = 'E:\astego\Images\test\';
srcImg = single(imread([Root, 'cover\195.pgm']));

D0= calcuDist(single(imread([Root, '������\195.pgm'])),...
    single(imread([Root, '�񻯺���\195.pgm'])));
% psnr0= cacul_psnr(imread([Root, 'cover\195.pgm']),...
%     imread([Root, '�񻯺���\195.pgm']));
%% ͼ����ǿ
[sharpImg1,HF1] = sharpen(srcImg, 1);
[sharpImg2,HF2] = imgLaplace(srcImg, 1);

% ��д
stegoImg1 = HUGO_like(uint8(sharpImg1), single(0.4));stegoImg1=single(stegoImg1);
stegoImg2 = HUGO_like(uint8(sharpImg2), single(0.4));stegoImg2=single(stegoImg2);
% ���ܼ���
D1 =  calcuDist(sharpImg1,stegoImg1);
D2 =  calcuDist(sharpImg2,stegoImg2);
psnr1 = cacul_psnr(srcImg, stegoImg1);
psnr2 = cacul_psnr(srcImg, stegoImg2);
% figure('name','HF0'); imshow(round(HF0));
% figure('name','HF-1'); imshow(round(HF1));
% figure('name','HF2'); imshow(round(HF2));
%}

%% ������ǿ
inRoot = 'E:\astego\Images\BOSS_ALL\';
outRoot = 'E:\astego\Images\covers\��G3����_Am1\';
imgDir  = dir([inRoot '*.*']);    % ��������**��ʽ�ļ�
imgDir(1)=[];imgDir(1)=[];
Names = cell(length(imgDir),1);    % ͼ����,����ȫ��·��

old='';
total = length(imgDir);
for i = 1:total                % �����ṹ��Ϳ���һһ����ͼƬ��    
    imgPath=[inRoot, imgDir(i).name];
    Names{i} = imgDir(i).name;
    srcImg = double(imread(imgPath));
    [sharpImg2, ~] = sharpen(srcImg, 1);
    imwrite(uint8(sharpImg2), [outRoot,Names{i}], 'pgm');
    
    msg=sprintf('- count: %3d/%d',i, total);
    fprintf([repmat('\b',1,length(old)),msg]);
    old=msg;
end
%}