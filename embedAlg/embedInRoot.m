function embedInRoot(coverRoot,stegoRoot,payLoad,startInd,endInd)
% ������д�㷨��Ŀ¼�е�ͼ�������д
%%

% coverRoot = 'E:\astego\StandExpers\covers\';
% stegoRoot = 'E:\astego\StandExpers\CZL\';
format = 'pgm';
dirs  = dir([coverRoot,'*.',format]);
nImages = length(dirs);
if(exist('payLoad','var') && str2double(payLoad)>0)
  payLoad = single(str2double(payLoad));
else
  payLoad = single(0.4);
end
if(exist('startInd','var') && str2double(startInd)>0)
  startInd = single(str2double(startInd));
else
  startInd = 1;
end
if(exist('endInd','var'))
  endInd=single(str2double(endInd));
else 
  endInd=single(nImages);
end

% names=cell(length(dirs),1);
fprintf('# count: %d - %d\npayload: %.1f\n',startInd,endInd,payLoad);

old=''; t0 = datetime('now');
for i=startInd : endInd
  cPath=[coverRoot,dirs(i).name]; %names{i}=dirs(i).name;
  
  % Ƕ���㷨
  stego = embedAlgCZL(cPath, payLoad);
  imwrite(uint8(stego), [stegoRoot,dirs(i).name],format);
  %stego=embedAlgCZL(cPath, payLoad);
  %stego = MiPOD( single(imread(cPath)), payLoad);
  %stego = HILL(cPath, payLoad);
  %stego = HUGO_like(imread(cPath), payLoad);
  %stego = HUGO(cPath, payLoad, []);
  %stego = S_UNIWARD(imread(cPath), payLoad);
  % J_UNIWARD([coverRoot,Names{i}], [stegRoot,Names{i}], single(payLoad));
  % steg =LSBM(I, payLoad);imwrite(uint8(steg), [stegRoot, Names{i}]);
  %stego = MG( single(imread(cPath)), payLoad );
  
  % ��ӡ
  msg=sprintf('- count: %3d/%d',i,nImages);
  fprintf([repmat('\b',1,length(old)),msg]);
  old=msg;
end
fprintf('\nnumbel of img: %d\n', i);
fprintf('\n��ʱ: '); disp(datetime('now')-t0);
end