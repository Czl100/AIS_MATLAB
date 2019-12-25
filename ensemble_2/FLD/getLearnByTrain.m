function [learner]=getLearnByTrain(FC, FS, learner)
% ����: ��������ͼ������
% ���: ���ɷ������Ĳ���-ͶӰ�������߽�
% ��֤���������Ŀ�������
%% 
if(exist('learner','var'))
  FC = FC(:, learner.subspace);
  FS = FS(:, learner.subspace);
end

%% ��׼��  sigma = std(x);
% [FC, mu, sigma] = zscore(FC, 1, 1);
% FS = bsxfun(@minus, FS, mu);
% FS = bsxfun(@rdivide, FS, sigma);
% CMuSigma.mu = mu; CMuSigma.sigma = sigma;

%% FLD
if(~exist('learner','var'))
  learner = FLD_Ensemble(FC, FS);
end

%% �������ߴ����Ч��
% load('learner.mat');    load('CMuSigma.mat');
%{
vC = getValProjected(coverPath, learner, mu, sigma);
vS = getValProjected(stegoPath, learner, mu, sigma);
vS2 = getValProjected([imgRoot,'8-Juniwd.jpg'], learner, mu, sigma);
vT = getValProjected(immunedStegoPath, learner, mu, sigma);

pos = round(size(PC,1)*0.5);
plot(vC, pos, '*b');hold on;
plot(vS, pos, '*r');hold on;
plot(vS2, pos, 'dr');hold on;
plot(vT, pos, 'xr');hold on;
%}

%% ��������
%{
plot(PC2, nTrain+1:nSamp, '*b');hold on;
plot(PS2, nTrain+1:nSamp, 'or');hold on;
hp = plot([border, border],[0,nSamp], '-r');
legend('c','s','c','s',['b: ', num2str(learner.b)]);
title(algName,'Interpreter','none');
% legend(hp,{['b: ', num2str(learner.b)]}, 'FontSize',12);
%}
end

%% ���㵥��ͼ�������ͶӰ���ֵ
function vProjected = getValProjected(imgPath, learner, mu, sigma)
Q = getQuality(imgPath);
F = ccpev548(imgPath, Q);

C = bsxfun(@minus, F, mu);  C = bsxfun(@rdivide, C, sigma);
vProjected = C * learner.w;
end

%% ������������ͶӰ�����ĽǶ�
%{
cosangle = (mS * learner.w) / ( norm(mS)*norm(learner.w) );
angle = acos(cosangle) * 180 / pi;          % �Ƕ�
fprintf('diag: %f\n',angle);
%}