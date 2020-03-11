function embedInRoot(cRoot,sRoot,payLoad,startInd,endInd,Am)
% ������д�㷨��Ŀ¼�е�ͼ�������д
%%
% sharpRoot= 'E:\astego\Images\sharpImg\';
% cRoot= 'E:\astego\Images\BOSS_ALL\';
% sRoot = 'E:\astego\StandExpers\CZL\';
format = 'pgm';
dirs  = dir([cRoot,'*.',format]);
nImgs = length(dirs);
names=cell(length(dirs),1);
for i=1:nImgs
  names{i}=dirs(i).name;
end
clear dirs; names= sort(names);

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
  endInd=single(nImgs);
end
fprintf('# count: %d - %d\npayload: %.1f  Am: %.1f\n',...
  startInd,endInd,payLoad,str2double(Am));

old=''; t0 = datetime('now');
for i=startInd : endInd
  cPath= [cRoot,names{i}];
  stego= embedAlgCZL(cPath, payLoad, str2double(Am));
  imwrite(uint8(stego), [sRoot,names{i}],format);
  %imwrite(uint8(sharpImg), [sharpRoot,names{i}],format);
  
  %stego = MiPOD( single(imread(cPath)), payLoad);
  %stego = HILL(cPath, payLoad);
  %stego = HUGO_like(imread(cPath), payLoad);
  %stego = HUGO(cPath, payLoad, []);
  %stego = S_UNIWARD(imread(cPath), payLoad);
  % J_UNIWARD([coverRoot,Names{i}], [stegRoot,Names{i}], single(payLoad));
  %stego = MG( single(imread(cPath)), payLoad );
  
  % print
  msg=sprintf('- count: %3d/%d',i,nImgs);
  fprintf([repmat('\b',1,length(old)),msg]);
  old=msg;
end
fprintf('\nnumbel of img: %d\n', i);
fprintf('\n��ʱ: '); disp(datetime('now')-t0);
end