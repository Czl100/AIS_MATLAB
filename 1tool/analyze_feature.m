function [diff,fitness] = analyze_feature(Fc, Fs, nameAlg, nameFea)
% ������д��������Ӱ��
% 
if(~exist('nameAlg', 'var'))
    nameAlg = '';
end
if(~exist('nameFea', 'var'))
    nameFea = '';
end
if(ischar(Fc))
    Q = getQuality(Fc);
    Fc = ccpev548(Fc, Q);
    Fs = ccpev548(Fs, Q);
end
%% ��Ӧ�Զ���
[fitness, diff] = calcu_fitness(Fc, Fs);
%%
diff = diff ./ mean(Fc,1);
absDiff = abs(diff);
[~, ind] = sort(absDiff, 'descend');
maxInd = ind( 1:round(0.02 * length(diff)) );
maxDiff = diff(maxInd);
ind = maxInd>274;
a = zeros(size(maxInd));
a(ind) = 274;
mark = maxInd-a;        % dim,ά�ȷ���
% ��markӳ��Ϊ��Ӧ��ϵ��ֵ


% RendererMode: manual; Renderer:'painters'; ��Ⱦ��
% GraphicsSmoothing: on; ƽ������
% 'Position', [0,0,300,300]

fig=figure('DockControls','off','Color', 'white');
fig.WindowStyle='normal';
fig.PaperPositionMode = 'manual';
fig.Units =  'pixels';

hp = plot(diff, 'x-k');
hold on;
% plot([0 length(diff)], [fitness, fitness], '--r');
title([nameAlg,'-',nameFea], 'Interpreter','none','FontSize',10);
xlabel('CCPEV����ά��' ,'FontSize',14);
ylabel('������Ա仯��','FontSize',14);
for i=1:length(mark)
    %text(double(maxInd(i)),double(maxDiff(i)), num2str(mark(i)));
end
legend(hp,{['L=', num2str(fitness)]}, 'FontSize',14);
ax = gca;
spreadAxes(ax);
ax.XLim = [1,length(diff)];
xaxis = [1,11,66,165,193];
% ax.XTick = [1:50:length(Fc), length(Fc)];
ax.XTick = [xaxis, xaxis+274];

% ax.YLim = [-0.4,0.6]; ax.YTick = -0.4:0.1:0.6;

end