function HUGO_OPT_EMBEDS(coverRoot, stegoRoot,payload)
% ������д�㷨��Ŀ¼�е�ͼ�������д
% coverRoot       ͼ��Ŀ¼
% stegRoot      �������ͼ��Ŀ¼
%%
t0 = datetime('now');
payload = single(str2double(payload));
dirs  = dir([coverRoot, '*.pgm']);
nImages = length(dirs);
old='';
for i = 1:nImages                % �����ṹ��Ϳ���һһ����ͼƬ��
  cPath=[coverRoot,dirs(i).name];
  stego = HUGO(single(imread(cPath)), payload);
  imwrite(uint8(stego), [stegoRoot,dirs(i).name], 'pgm');
  
  % ��ӡ
  msg=sprintf('- count: %3d/%d',i,nImages);
  fprintf([repmat('\b',1,length(old)),msg]);
  old=msg;    
end
fprintf('\n��ʱ: '); disp(datetime('now')-t0);
end