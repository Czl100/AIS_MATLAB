function statistic(coverData, stegData, edges, nameAlg)
% ͳ��Data������ͼ
% ����QDCT����    
% edges = edges - 0.5;
binWidth = 0.4;
coverData=coverData(:);
stegData=stegData(:);
[count_c,center_c]=hist(coverData, max(coverData)-min(coverData)+1 );
[count_s,center_s]=hist(stegData, max(stegData)-min(stegData)+1 );

fig=figure;
hb=bar(center_c-0.5*binWidth, count_c, binWidth, 'FaceColor', ([173,217,226])/255,...
    'EdgeColor','black', 'LineWidth',1.2, 'LineStyle', '-');
% bar(center_c-0.5*binWidth, count_c, binWidth);
hold on;
bar(center_s+0.5*binWidth, count_s, binWidth, 'FaceColor', ([43,50,128])/255,...
    'EdgeColor',([43,50,128])/255, 'LineWidth',1.2, 'LineStyle', '-');
% bar(center_s+0.5*binWidth, count_s, binWidth);

xlabel('QDCTϵ��');ylabel('����Ƶ��');
legend({'ԭʼͼ��','����ͼ��'}, 'Interpreter', 'none');

ax = gca;
spreadAxes(ax);
ax.XLim = [edges(1)-binWidth, edges(end)+binWidth];
ax.XTick = edges(1):edges(end);

% ���
% hp = findobj(hb,'Type','bar'); 
% hatchfill(hp(1),'single',45,3,'r');
% hatchfill(hp(2),'single',180,3,'b');


%{
h1 = histogram(coverData, max(coverData)-min(coverData)+1);
h1.BinEdges = edges-binWidth;
h1.BinWidth=binWidth;
h1.FaceColor='blue';
h1.LineStyle='-';

hold on;
h2=histogram(coverData, max(coverData)-min(coverData)+1, 'BinEdges', edges+binWidth);
h2.BinWidth=binWidth;
h2.FaceColor='red';
h2.LineStyle='--';
h2 = histogram(stegData, 'BinEdges', edges+0.5, 'BinCounts', count_s);
%}
end

% ͳ������ͼ
%{
function [index, count]=statistic(coverData, stegData, nameAlg)
% ͳ��Data������ͼ
% ����QDCT����
%% 
if(~exist('nameAlg', 'var'))
    nameAlg='stego';
end
coverData = coverData(:);
if(exist('stegData', 'var'))
    stegData = stegData(:);
    [cover_ind, cover_count] = sub_statistic(coverData);
    [steg_ind,  steg_count] = sub_statistic(stegData);
    %cover_count = cover_count .* (1/length(coverData(:)));
    %steg_count = steg_count .* (1/length(stegData(:)));    
    % �ҵ�0ϵ����λ��
    % p1=find(index_1==0);
    p_cover = cover_ind==0;
    p_steg = steg_ind==0;    
    ymax1=max(steg_count)*1.1;
    figure;
    plot(cover_ind,cover_count,'-kx');
    hold on;
    plot(steg_ind,steg_count,'-bo');
    % title([nameAlg, '��ͳ��ֱ��ͼ��Ӱ��']);
    %title('payload=0.4');
    xlabel('�������DCTϵ��ֵ');ylabel('Ƶ��');                
    % text(.2, double(cover_count(p_cover)), num2str(cover_count(p_cover)));
    % text(-0.7, double(steg_count(p_steg)), num2str(steg_count(p_steg)));
    legend({'cover',nameAlg}, 'Interpreter', 'none')    
    %fprintf('row: %d\nsteg:%d\n',cover_count(p_cover), steg_count(p_steg));
else
    [index,count] = sub_statistic(coverData);
    p = find(index == 0);
    ymax1 = max(count)*1.05;
    figure;
    plot(index, count, '-ko');
    title([nameAlg, '��ͳ��ֱ��ͼ��Ӱ��']);
    xlabel('Quantized DCT coefficient');ylabel('frequency');    
    text(double(index(p)),double(count(p)),num2str(count(p)));
    % legend('QDCT', 'Interpreter', 'none');    
end
ax = gca;
spreadAxes(ax);
ax.XLim = [-5,5];
ax.XTick = -5:5;
ax.YLim = [0, ymax1];
end
%}

function [index,count]=sub_statistic(Data)
% ͳ��Data��ֱ��ͼ
% index:ϵ��ȡֵ����
% count:Ƶ��
minData=min(min(Data));
maxData=max(max(Data));
index=minData:1:maxData;
count=int64(zeros(1,length(index)));
j=1;
for index=minData:1:maxData    
    count(j)=length(find(Data==index));
    j=j+1;
end
num_zero=length(find(Data==0));
index=minData:1:maxData;
% fprintf('the numle of 0 is: %d\n',num_zero)
end