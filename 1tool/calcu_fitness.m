function [fit, diff, fits]=calcu_fitness(Fc, Fs)
% ��Ӧ�ȼ���
%% 
numSamp = size(Fc,1);
% ������������
if(numSamp == 1)    
    [fit,diff] = singSample(Fc,Fs);
else    
    fits = zeros(numSamp, 1);
    for i=1:numSamp        
        fits(i) = singSample(Fc(i,:), Fs(i,:));
    end
    % �޳��쳣����
    ind= find(fits > 1e2);
    fits(ind)=0;    
    Fc(ind, :)=0;
    Fs(ind, :)=0;
    
    fit = mean(fits);    
    diff = mean(Fs-Fc, 1);    
end
end

function [fit, diff] = singSample(Fc, Fs)
%% ������������Ӧ��
%  ����1: ŷʽ����
%  diff = ( Fs - Fc) ./ (Fc+eps);
%  ind = isinf(diff);
%  diff(ind)=Fs(ind);
diff = Fs-Fc;
% fitness = norm(diff);

%  ����2: FLDͶӰ����
load('learner.mat');    load('CMuSigma.mat');
C = bsxfun(@minus, Fc, CMuSigma.mu);  C = bsxfun(@rdivide, C, CMuSigma.sigma);
vC = C * learner.w;
S = bsxfun(@minus, Fs, CMuSigma.mu);  S = bsxfun(@rdivide, S, CMuSigma.sigma);
vS = S * learner.w;
fit = abs(vS - vC);
fit = round(fit, 3);        % ����3ΪС��, ֵԽСԽ��
end