function savaRelatCs(cf,sf,pathSavaImg,featureName,reduce)
% ��������-��������ÿһά����������
% cf,sf  ��������
if(nargin<5)
    savaRelatCs_(cf,sf,pathSavaImg,featureName);
else
    savaRelatCs_error(cf,sf,pathSavaImg,featureName);
end    
end

function savaRelatCs_(cf,sf,pathSavaImg,featureName)
% ��������-��������ÿһά����������
% cf,sf  ��������
ndw=size(cf,2);              %����ά��
count=0;

old='';
while(count<=ndw)    %ndw
    close all;fh=figure;    
    set(fh,'visible','off');
    for i=1:4
        count=count+1;
        if(count>ndw)  
            break;
        end
        subplot(2,2,i);plot(cf(:,count),sf(:,count),'k.');
        title([featureName,'-',int2str(count)]);
        xlabel(sprintf('Fc(:,%d)',count));
        ylabel(sprintf('Fs(:,%d)',count));
        %hold on;plot(cf(:,i),polyval(p(i,:),cf(:,i)),'r-');    %��Ӧ�������            
    end  
    filename=[int2str(count),'.jpg'];
    saveas(fh,[pathSavaImg,filename]);
    msg=sprintf('- count: %3d/%d',count,ndw);
    fprintf([repmat('\b',1,length(old)),msg]);
    old=msg;
end

%{
%-������ά���������
figure;
title('�������');xlabel('cover-img feature');ylabel('steg-img feature');
axis([0,1,0,1]);
for i=1:size(cf,2)
    hold on;
    plot(cf(:,i),polyval(p(i,:),cf(:,i)));
end
fprintf('���߸���: %d', i);
%}
end

function savaRelatCs_error(cf,sf,pathSavaImg,featureName)
% ����fs-fc��������

ndw=size(cf,2);              %����ά��
error=sf-cf;
count=0;

old='';
while(count<=ndw)    %ndw
    close all;fh=figure;    
    set(fh,'visible','off');
    for i=1:4
        count=count+1;
        if(count>ndw)  
            break;
        end
        subplot(2,2,i);plot(error(:,count),'k.');
        title([featureName,'-',int2str(count)]);
        xlabel(sprintf('Fc(:,%d)',count));
        ylabel(sprintf('Fs(:,%d)',count));
        %hold on;plot(cf(:,i),polyval(p(i,:),cf(:,i)),'r-');    %��Ӧ�������            
    end  
    filename=[int2str(count),'.jpg'];
    saveas(fh,[pathSavaImg,filename]);
    msg=sprintf('- count: %3d/%d',count,ndw);
    fprintf([repmat('\b',1,length(old)),msg]);
    old=msg;
end

end