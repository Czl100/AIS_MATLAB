function [FcPcaed, FsPcaed, k] = PcaFunction(Fc,Fs,setDimension)
% PCA��ά
% Fc��Fs     ������������
% k         ��ά���ά��
% [coeff,score,latent,tsquared,explained,mu] = pca(X, Name, Value)
%    X: n*m ����, ��ʾn�������۲�ֵ, ÿ������Ϊmάʸ��, Ҫ��n>=m
%    coeff: m*m��ת������
%    score: ��ά���n*m����, һ�ж�Ӧһ������, һ�ж�Ӧһ�����ɷ�
%%
T = 0.98;
%% ��׼��
[Fc, mu, sigma] = zscore(Fc);
Fs = bsxfun(@minus, Fs, mu);
Fs = bsxfun(@rdivide, Fs, sigma);

%% pca��ά
[Tc,FcPcaed,latent_c,~,~,mu] = pca(Fc);
rank_c = cumsum(latent_c)./sum(latent_c);
FsTmp= bsxfun(@minus, Fs, mu);
FsPcaed = FsTmp * Tc;

% ���ּ�ά��ʽ, ���ָ���
% border = size(Fc,1);
% [Tc,pcaed,latent_c,~,~,mu] = pca([Fc;Fs]);
% rank_c = cumsum(latent_c)./sum(latent_c);
% FcPcaed = pcaed(1:border,:);
% FsPcaed = pcaed(border+1:end,:);

%% ��Ȩ�صļ�ά
%{
W = 1./var(Fc);
[Tc,FcPcaed,latent_c,~,~,mu] = pca(Fc,'VariableWeights',W);
rank_c = cumsum(latent_c)./sum(latent_c);
coefforth = diag(sqrt(W)) * Tc;
FsPcaed = zscore(Fs) * coefforth;
%}

for k=1:length(rank_c)
   if rank_c(k)>=T
       break;
   end
end
if(nargin<3)
    FcPcaed=FcPcaed(:,1:k);
    FsPcaed=FsPcaed(:,1:k);
else
    FcPcaed=FcPcaed(:,1:setDimension);
    FsPcaed=FsPcaed(:,1:setDimension);
end
end

%% ��ͼ
function draw(Fc, Fs, dim, nSample)
% ��ͼ:2ά
if(dim==2)
    figure;
    scatter(Fc(1:nSample, 1), Fc(1:nSample, 2), 20, 'x', 'filled',...
        'MarkerEdgeColor','k', 'MarkerFaceColor','blue');
    hold on;
    scatter(Fs(1:nSample, 1), Fs(1:nSample, 2), 20, 'o', 'filled',...
        'MarkerEdgeColor','k', 'MarkerFaceColor','red');
    xlabel('X');ylabel('Y');zlabel('Z');
% ��ͼ��3ά
else
    hs1 = figure;
%     hs1 = subplot(2,1,1); hs2 = subplot(2,1,2);
    scatter3(Fc(1:nSample, 1), Fc(1:nSample, 2), Fc(1:nSample, 3), 20, 'x', 'filled',...
        'MarkerEdgeColor','k', 'MarkerFaceColor','blue');
    hold on;
    scatter3(Fs(1:nSample, 1), Fs(1:nSample,2), Fs(1:nSample,3), 20, 'o', 'filled',...
        'MarkerEdgeColor','k', 'MarkerFaceColor','red');
    xlabel('X');ylabel('Y');zlabel('Z');
    view(-0.7,90);       % �ı�������ĽǶ�
end
%{
figure;
ind = 1;
for dim=1:reserve    
    subplot(1,2,ind);
    plot(FcPcaed(1:200, dim), '.r');hold on;
    plot(FsPcaed(1:200, dim), 'ob');
    title(['Fc & Fs in dimension ',num2str(dim)]);
    ind = ind + 1;
    if(mod(dim,2)==0)
        figure;
        ind = 1;
    end
end
%}
end