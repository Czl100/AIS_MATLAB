function FLD_Test(MFc, MFs, learner)
% ����: ��������ͼ������
% ���: ���ɷ������Ĳ���-ͶӰ�������߽�
% ��֤���������Ŀ�������
%% 
nTrain = 700;
C = MFc.FC_BOSS_SRM;
S = MFs.FS_HUGO_04_SRM;
if(exist('learner','var'))
    C = C(:, learner.subspace);
    S = S(:, learner.subspace);
end
% ����ľ�ֵ����
mC = mean(C);   mS = mean(S);
D = norm(mC-mS);

%% ��׼��  sigma = std(x);
[C, mu, sigma] = zscore(C, 1, 1);
S = bsxfun(@minus, S, mu);
S = bsxfun(@rdivide, S, sigma);
CMuSigma.mu = mu; CMuSigma.sigma = sigma;
% save('CMuSigma', 'CMuSigma');

%% FLD
nTrain = size(C, 1);
CTrain = C(1:nTrain,:);  STrain = S(1:nTrain, :);
%  S = C(nTrain+1:end,:);  STest = S(nTrain+1:end,:);
if(~exist('learner','var'))
    learner = FLD_Ensemble(CTrain, STrain);
end
%  ��׼��ͶӰ����w
scale = 10/norm(learner.w);
% learner.b = learner.b .* scale;  % ����2λС��
% learner.w = learner.w .* scale;  % ʹw����Ϊ10
fprintf('S��ͶӰ���ģ�%.3f\n',mean(S,1) * learner.w);
fprintf('��ֵ�����ľ���:%.3f\n',norm(mean(S)-mean(C)));
save('learner','learner');
%}

%% ���ӻ�
%{
figure;
PC = C * learner.w;     PS = S * learner.w;     border = learner.b;
vmin = min(min(PC),min(PS));    vmax = max(max(PC),max(PS));
% axis([0,length(PC), vmin, vmax]);
plot(PC, 1:size(PC,1), '.k');hold on;
plot(PS, 1:size(PS,1), '.r');hold on;
hp = plot([border, border],[0,size(PS,1)], '-r');hold on;
legend('c','s', ['b: ', num2str(border)]);
axis([-65, -50, 0,length(PC)]);
%}

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