function [D1, D2] = calcu_antibperfom(coverPath, stegoPath, immuneStegoPath, isfigure)
% �Ƚ���������ͼ������Ȼͼ���������ŷʽ����
%%
calculNumOfModified = @(cQdct,sQdct) nnz((cQdct-sQdct));

Q = getQuality(coverPath);
cJobj = getQDCT(coverPath);  cQdct = cJobj.coef_arrays{1};
sJobj = getQDCT(stegoPath);  sQdct = sJobj.coef_arrays{1};
tJobj = getQDCT(immuneStegoPath);  tQdct = tJobj.coef_arrays{1};

Fc = ccpev548(coverPath, Q);
Fs = ccpev548(stegoPath, Q);
Ft = ccpev548(immuneStegoPath, Q);

%%
[D1, ~] = calcu_fitness(Fc, Fs);
[D2, ~] = calcu_fitness(Fc, Ft);
if(exist('isfigure', 'var'))
    analyze_feature(Fc, Fs);
    analyze_feature(Fc, Ft);
end

fprintf('cQdct-sQdct: %d\n', calculNumOfModified(cQdct, sQdct));
fprintf('cQdct-tQdct: %d\n', calculNumOfModified(cQdct, tQdct));
fprintf('δ����D1: %.3f\n', D1);
fprintf('�����D2: %.3f\n', D2);
end