function stego=detection(Tais,T,B)
% ��ensemble�������ṩ�����ݾ��������㷨����,���������������ڼ��,
% ��֤���ߴ����Ч��

% -------------------------------------------------------------------------
% �޸�C��ֵ
%{
cover = load('cover.mat');
stego = load('stego.mat');
C=cover.F;

fs_ais=zeros(size(C));
nsamp=size(C,1);
for i=1:nsamp
    fs_ais(i,:)=C(i,:)*Tais*T+B;   %��Ӧһ������ͼ������
end
stego.F=fs_ais;
%}


cover = load('cover.mat');
stego = load('stego.mat');
names = intersect(cover.names,stego.names);             %����
names = sort(names);

% Prepare cover features C,imgCove��imgStegҪ��Ӧ
cover_names = cover.names(ismember(cover.names,names));
[cover_names,ix] = sort(cover_names);
C = cover.F(ismember(cover.names,names),:);
C = C(ix,:);

% Prepare stego features S
stego_names = stego.names(ismember(stego.names,names));
[stego_names,ix] = sort(stego_names);
S = stego.F(ismember(stego.names,names),:);
S = S(ix,:);

savaRelatCs(C,S,'E:\astego\�㷨��������Ӱ��\nsF5--CC-PEV\','CC-PEV');
% -------------------------------------------------------------------------
% ��֤nsF5������-����������Ӱ��
%{

ndw=size(C,2);              %����ά��
count=0;
while(count<=ndw)    
    close all;fh=figure;    
    set(fh,'visible','off');
    for i=1:4
        count=count+1;
        if(count>ndw)  
            break;
        end
        subplot(2,2,i);plot(C(:,count),S(:,count),'k.');
        title(['spam686-','��ά������:',int2str(count)]);
        %hold on;plot(cf(:,i),polyval(p(i,:),cf(:,i)),'r-');    %��Ӧ�������            
    end    
    filename=[int2str(count),'.jpg'];
    saveas(fh,['.\feature\',filename]);                     %����Figure 2���ڵ�ͼ��
    if mod(count,10)==0
        fprintf('--%d:\n', count);
    end
end
%}

% -------------------------------------------------------------------------
% ��֤���ߴ���
fs_ais=zeros(size(C));
nsamp=size(C,1);
for i=1:nsamp
    fs_ais(i,:)=C(i,:)*Tais*T+B;   %��Ӧһ������ͼ������
end

% ����fs��fc�����ƶ�
d_c_s=zeros(nsamp,1);
for i=1:nsamp
    d_c_s(i)=pdist([S(i,:);C(i,:)],'euclidean');
end
d_c_s=mean(d_c_s);

% ����fs_ais��fc�����ƶ�
d_fsais=zeros(nsamp,1);
for i=1:nsamp
    d_fsais(i)=pdist([fs_ais(i,:);C(i,:)],'euclidean');
end
d_fs_ais=mean(d_fsais);

figure;
plot(S(:,1),'k.');hold on;plot(fs_ais(:,1),'bo');
legend({'ԭ��������','���ߺ���������'});

figure;
plot(C(:,1),'k.');hold on;plot(fs_ais(:,1),'bo');
legend({'��������','���ߺ���������'});

fprintf('ԭʼ����-������������:%.2f\n',d_c_s);
fprintf('��������-������������:%.2f\n',d_fs_ais);
end
%}

%{
count=0;
TXT='';
while(count<4)
    TXT = updateTXT(TXT,sprintf(' - d_sub %d',count));
    count=count+1;
end  
%}