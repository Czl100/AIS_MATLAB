function [T,Tais,constant]=matx_calcu(coeff,fc)
% ������cover-img-->steg-img��ת������T����ά����y=ax+b
% coeff:    һ����ϵ���ͳ�����
% fc:       ������������
% B:        ������
% T��       n*nת������,n������ά��
% T2:       n*n���߾���
% a=coeff(:,1)   b=coeff(:,2);������������

ndw=size(coeff,1);      %����ά��
nsmp=size(fc,1);        %��������

% for i=1:ndw    
%     T(j,i)=a(i);        % ��д�㷨����    
% end
T=coeff(1:end-1,1:end);      %regress��ϵõ�
B=coeff(end,1:end);          % 1*ndw������

% �����ߴ������:AX=Y ��:X=A\Y
Y=[];
for i=1:nsmp
    Y=[Y;(fc(i,:)-B)];
end
X=fc\Y;
Tais=(T'\X')';
constant=B;             %������
end