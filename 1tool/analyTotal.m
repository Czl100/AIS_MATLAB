function analyTotal(Fc, Fs)
% �ܷ���,�����Ͳ�������(ֱ��ͼ)
% 
diff=analyze_feature(Fc, Fs, '80');

absDiff = abs(diff);
[~, ind] = sort(absDiff, 'descend');
maxInd = ind( 1:round(0.02 * length(diff)) );


Fc(166:168) = 0;   Fs(166:168) = 0;
Fc(166+274 : 168+274) = 0;   Fs(166+274 : 168+274) = 0;
analyze_histogram(Fc(min(maxInd)-2 : max(maxInd)+2), Fs(min(maxInd)-2 : max(maxInd)+2));

end