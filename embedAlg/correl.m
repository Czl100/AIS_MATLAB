function correl(x)
% ��ض�: ����Զ���
resH= x(:,1:end-1)- x(:,2:end);
resV= x(1:end-1,:)- x(2:end,:);

varH= var(resH(:));varV= var(resV(:));
nH= norm(resH(:));nV= norm(resV(:));
stdH= std(resH(:));stdV= std(resV(:));

mH= mean(resH(:));  mV= mean(resV(:));
end