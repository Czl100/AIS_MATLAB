function genes = initAb(num,len)
% ��ʼ������
% num: �������
% len: ������볤��
%%
num = round(num);
genes = 2 .* rand(num,len) - 1;
genes(genes<0) = 0;
genes(genes>0) = 1;
genes= single(genes);
% genes = hardlim(genes);  % ����Ϊ��ֵ,ӳ��Ϊ{0,1}
% Ab = hardlims(Ab);  % ����Ϊ��ֵ,ӳ��Ϊ{-1,1}
end