% ����ͼ��
fig = gcf;
fig.WindowStyle='normal';
fig.PaperPositionMode = 'manual';
fig.Units =  'pixels';
fig.PaperUnits = 'inches';
% fig.PaperPosition = [0, 0, 300, 100];
fig.Renderer = 'painters';
imgRoot = 'E:\�����ļ�\����\';
print([imgRoot, '2'],'-dpng', '-painters','-r0');