function effectDims = featEffect(Fc, Fs, rate)
% ����diff=Fs-Fc,�ĸ������������,���ĸ�������������д�޸�������
% diff�����ǵ���������Ҳ�����Ƕ������
% ������ƫ�������Ǹ�����������ֵĴ���
if(~exist('rate','var'))
    rate = 0.1;
end
nd = size(Fc,2);            % ά��
nMax = round(rate*nd);          % �����е�n������
diff = (Fs-Fc)./(Fc+eps);   % diff�Ǿ���
D = abs(diff);
[~,dims] = sort(D,2,'descend');    % ���н�������
components = dims(:, 1:nMax);
components = components(:);
[freqs,dims] = histFreqs(components);
[~,ind] = sort(freqs, 'descend');
dimSored = dims(ind);
effectDims = dimSored(1:nMax);
% saveImgDiffeature(diff(1:4), dirSavaImg, 'CCPEV');

end

function saveImgDiffeature(D, dirSavaImg, featureName)
% ����ÿ��������(Fs-Fc)./Fc
% һ�д���һ������

numSamp = size(D,1);
count=0;
old='';
while(count<=numSamp)
    close all;fh=figure;    
    set(fh,'visible','off');
    for i=1:1
        count=count+1;
        if(count>numSamp)
            break;
        end
        %subplot(2,2,i);
        plot( D(count,:), '-kx');
        title([featureName,'-',int2str(count)]);
        xlabel('����ά��');
        ylabel('Fs-Fc');
    end  
    filename=[int2str(count),'.jpg'];
    saveas(fh,[dirSavaImg, filename]);
    msg=sprintf('- count: %3d/%d',count,numSamp);
    fprintf([repmat('\b',1,length(old)),msg]);
    old=msg;
end

end

function [freqs,ind]=histFreqs(D)
% ����������Ƶ������ֵ������ freqs��ind
% D:����,
% [freqs,edges,bin] = histcounts(D,'BinMethod','integers');
% ind = ceil( edges(1:end-1) );
D=D(:);
[freqs, ind]=hist(D, min(D):max(D));

end
