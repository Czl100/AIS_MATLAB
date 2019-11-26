% close all;
clear;clc;
Root = 'E:\astego\Images\test\';
imgData = double(imread([Root, '195.pgm']));
%% ͼ����ǿ
%����1
% Radius=5;
% dstImg = multiScaleSharpen(src, Radius);
%����2
% [dstImg, highFreq] = sharpen(imgData, 1);
% figure('name','sharpened');imshow(uint8(dstImg));
% figure('name','highFreq');imshow(highFreq, []);
% imwrite(uint8(dstImg), [Root, '195_Sharp.pgm'], 'pgm');
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
    imgData = double(imread(imgPath));
    [dstImg, ~] = sharpen(imgData, 1);
    imwrite(uint8(dstImg), [outRoot,Names{i}], 'pgm');
    
    msg=sprintf('- count: %3d/%d',i, total);
    fprintf([repmat('\b',1,length(old)),msg]);
    old=msg;
end
%}