function stegObj = stegOperate(cover, payLoad, stegoPath)

% -------------------------------------------------------------------------
% ��д����, cover������jobj�ṹ��, Ҳ�������ļ�·��
% ���jobj
% -------------------------------------------------------------------------
stegObj = F5(cover, payLoad, stegoPath);

% J_UNIWARD(cover_path, stego_path, payload);
% treat.steg = LSBM(treat.cover, payLoad);
% treat.steg=double( S_UNIWARD( uint8(treat.cover), single(payLoad)));
% nsf5_simulation(treatName, treatStegName, payLoad, 99);
% treat.steg = F5(treat.cover, quality, payLoad, seed);
% imwrite(uint8(treat.steg), [imgRoot,'treat-steg.jpg'], 'jpg','Quality',100);
end