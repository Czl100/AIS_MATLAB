function [xaxis,yaxis]=DrawLineChart(D)
% ������ͳ������ͼ
% D:����
D = D(:);
xaxis = min(D):max(D);
yaxis = zeros(length(xaxis),1);

j=1;
for v=xaxis(1):1:xaxis(end)
    yaxis(j) = length(find(D==v));
    j=j+1;
end

figure;
xlabel('Data');
ylabel('Frequency');
plot(xaxis,yaxis, '-kx')

% Ƶ������ֵ������
% [maxFrequency, maxInd] = max(yaxis);
end