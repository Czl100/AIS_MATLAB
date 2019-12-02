function [fits,Mem]=calcuFit(Abs,embedParas,Mem)
% ���㿹����Ӧ��
%%
srcData = single(imread(embedParas.srcPath));
num = size(Abs,1);
fits = zeros(num,1,'single'); old='';
for i=1:num
  K = getKey(Abs(i,:));
  [~, ind] = ismember(K,Mem.K);
  if(ind>0)
    fits(i) = Mem.V(ind);
  else
    % ��
    % [sharpedData, ~] = sharpen(srcData, Abs{i});
    sharpedData =  imgLaplace(srcData, Abs(i,:));
    % ��д
    sharpedStegoData = HUGO_like(uint8(sharpedData), embedParas.payLoad);
    fits(i) =  calcuDist(sharpedData, single(sharpedStegoData));
    Mem.K{Mem.last}=K; Mem.V(Mem.last)=fits(i); Mem.last=Mem.last+1;
    
    if(Mem.last > length(Mem.V))
      last = Mem.last;
      VT=Mem.V;
      Mem.V = zeros(last+20,1,'single');
      Mem.V(1:last-1) = VT;
      Mem.last = last;
      clear VT;
    end
    % ��ӡ
    %msg=sprintf('- count: %3d/%d',i,num);
    %fprintf([repmat('\b',1,length(old)),msg]);
    %old=msg;
  % if--end
  end
% for-end  
end
% clearvars -except fits Memory;
end

function ind = getIndex(k,Keys)
% ����Memory ��ָ��K��index
[~, ind] = ismember(k,Keys);
end
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

% imwrite(sharpedData, sharpedPath, 'pgm');
% imwrite(uint8(sharpedStegoData),sharpedStegoPath, 'pgm');
%fetuStruct = getFeatures(sharpedPath);  Fc2 = fetuStruct.F;
%fetuStruct = getFeatures(sharpedStegoPath);  Fs2 = fetuStruct.F;
%fits(i) = norm(Fs2- Fc2);
%fits(i) = cacul_psnr(sharpedPath, sharpedStegoPath);