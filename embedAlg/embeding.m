root = 'E:\astego\Images\BOSS_ALL\';
name = '1013.pgm';
cpath = [root,name];
SUNWDPath = ['E:\astego\��׼ͼ��ʵ��\SUNWD_04\',name];
HILLPpath = ['E:\astego\��׼ͼ��ʵ��\HILL_04\',name];
payLoad = single(0.4);

cover = single(imread([root,name]));

%% ��д
stego=embedAlgCZL(cover,payLoad);
% stego = S_UNIWARD(uint8(cover), payLoad);
% imwrite(uint8(stego), SUNWDPath, 'pgm');
% stego = HILL(cover, payLoad);
% imwrite(uint8(stego), HILLPpath, 'pgm');

%% ��ȡ����
t0=tic;
Fc = SRM({cpath}); fprintf('SRM��ʱ��');disp(toc(t0));
S_HILL=SRM({HILLPpath});
S_SUNWD=SRM({SUNWDPath});

clear t0 root name payLoad;
%%
%{
stego = HUGO_like(uint8(cover), payLoad);
stego = S_UNIWARD(uint8(cover), payLoad);
stego = HILL(cover, payLoad);

[rhoP1,rhoM1] = CostHILL(cover);
[stego,rhoP1]=embedAlgCZL(cover, payLoad);
P = 1./rhoP1;
figure;histogram(P);
%}