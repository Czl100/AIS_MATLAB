function [fits,Memory]=calcuFit(Abs,embedParas,Memory)
% ���㿹����Ӧ��
% 
%%
srcData = single(imread(embedParas.srcPath));
num = length(Abs);
fits = zeros(num,1);
old='';
for i=1:num
    K = getKey(Abs(i,:));
    if(Memory{1,1}==K)
        vals = Memory{1,2};
        fits(i) = vals(Memory{1,1}==K);
    else
    % ��
    % [sharpedData, ~] = sharpen(srcData, Abs{i});
    sharpedData =  laplace(srcData, Abs(i,:));
    % ��д
    sharpedStegoData = HUGO_like(uint8(sharpedData), embedParas.payLoad);
    % imwrite(sharpedData, sharpedPath, 'pgm');
    % imwrite(uint8(sharpedStegoData),sharpedStegoPath, 'pgm');
    %% ��ȡ����   
    %fetuStruct = getFeatures(sharpedPath);  Fc2 = fetuStruct.F;
    %fetuStruct = getFeatures(sharpedStegoPath);  Fs2 = fetuStruct.F;
    %fits(i) = norm(Fs2- Fc2);
    %fits(i) = cacul_psnr(sharpedPath, sharpedStegoPath);
    fits(i) =  calcuDist(sharpedData, sharpedStegoData);
    Memory = [Memory];
    % ��ӡ
    msg=sprintf('- count: %3d/%d',i,num);
    fprintf([repmat('\b',1,length(old)),msg]);
    old=msg;
    % if--end
    end
% for--end
end
%}

%  -------------------����Castro----------
%{
f = '1 * x .* sin(4 * pi .* x) - 1 * y.* sin(4 * pi .* y + pi) + 1';
[x,y] = meshgrid(-1:0.05:1,-1:0.05:1); vxp = x; vyp = y;
vzp = eval(f);  % ����ֵ
Abs = cell2mat(Abs);
x = Abs(:,1);
y = Abs(:,2);
fits = eval(f);
imprime(1,vxp,vyp,vzp,x,y,fits,1,1);
% -------------------����Castro----------
%}
% clearvars -except fits Memory;
end