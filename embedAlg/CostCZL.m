function [rhoP1,rhoM1] = CostCZL(cover)
% HUGO ���ۺ���
% ����+1 -1 �Ĵ���
%% 
% disp('CZL7-Max!');
cover = single(cover);
wetCost = 10^8;
% create mirror padded cover image
padSize = double(3);
cPadded = padarray(cover, [padSize,padSize], 'symmetric');
% create residuals
%{
rezH = cPadded(:, 1:end-1)- cPadded(:, 2:end);
rezV = cPadded(1:end-1, :)- cPadded(2:end, :);
rezD = cPadded(1:end-1, 1:end-1) - cPadded(2:end, 2:end);
rezMD= cPadded(1:end-1, 2:end) - cPadded(2:end, 1:end-1);
%}

%% �ָ�,���㲻ͬ�������ض�
gap= 64;
%{
nBlockH= size(cover,1)/gap; nBlockV=size(cover,2)/gap;
rows= 0:gap:size(cover,1);
cols= 0:gap:size(cover,2);
cH= zeros(nBlockH,nBlockV); cV=zeros(nBlockH,nBlockV);
for i=1:nBlockH
  r= rows(i)+1 : rows(i+1);
  for j=1:nBlockV
    c= cols(j)+1 : cols(j+1);
    subImg= cover(r, c);
    [cH(i,j),cV(i,j)]= correl(subImg);
  end
end
%}
%% distortion cost
T= 5; G=(T-1)*0.5;  % T������, T=3,5,7
a=1; cH=1; cV=1; 
rhoM1 = zeros(size(cover),'single');
rhoP1 = zeros(size(cover),'single');
% optP1= zeros(size(cover),'logical'); optM1= zeros(size(cover),'logical');
for row=1:size(cover, 1)
  i=ceil(row/gap);
  r= row+3;
  for col=1:size(cover, 2)
    j= ceil(col/gap);
    c=col+3;
    rs= r-G:r+G; cs= (c-G:c+G); % -2; %ƫ��
    subMatri= cPadded(rs,cs);

    %�Գ�Ƕ��; rhoP1=rhoM1;
    resH= subMatri(:,1:end-1)-subMatri(:,2:end);
    resV= subMatri(1:end-1,:)-subMatri(2:end,:);
    
    resH(G+1,:)= resH(G+1,:).* a;
    resV(:,G+1)= resV(:,G+1).* a;
    resH=resH(:); resV=resV(:);
    
    rhoP1(row,col)= 1/(min(norm(resH),norm(resV)) +  1);
    %rhoP1(row,col)= 1/(cH*norm(resH) + cV*norm(resV)+ 1);
    %}
    
    %�ǶԳ�Ƕ��; rhoP1!=rhoM1;
    %{
    resP1H= resHmatri(subP1); resP1V= resVmatri(subP1);
    resM1H= resHmatri(subM1); resM1V= resVmatri(subM1);
    resP1H=resP1H(:); resP1V=resP1V(:); resM1H=resM1H(:); resM1V=resM1V(:);
    
    rhoP1(row,col)= 1/(cH(i,j)*norm(resP1H) + cV(i,j)*norm(resP1V)+ 1);
    rhoM1(row,col)= 1/(cH(i,j)*norm(resM1H) + cV(i,j)*norm(resM1V)+ 1);
    %}
    
    % CZL8 T=3
    %{
    subH= [rezH(r-1, c-T:c+T-1); 2.* rezH(r, c-T:c+T-1); rezH(r+1, c-T:c+T-1)];
    subV= [rezV(r-T:r+T-1, c-1); 2.* rezV(r-T:r+T-1, c); rezV(r-T:r+T-1, c+1)];
    rhoP1(row,col)= 1/ (cH*norm(subH(:))+ cV*norm(subV(:))+ 1e-20);
    %}
    % CZL7
    %{
    %DCover = norm( reshape([arrDH;a*rezH],[],1) );
    %rhoP1(row,col)= 1./(DCover+1e-20);
    %}
    % �ֲ�Ƕ��, Ƕ������ضȸ���
    %{
    vcenter=subMatri(G+1,G+1);
    subMatri(G+1,G+1)=nan; 
    subMatri(1,1)=nan; subMatri(1,end)=nan; 
    subMatri(end,1)=nan; subMatri(end,end)=nan; 
    x=sort(subMatri(:));
    if( var(x(1:end-5))==0)
      if(vcenter-x(1)>1)
        optM1(row,col)=1;
      elseif(vcenter-x(1)<-1)
        optP1(row,col)=1;
      end
    end
    %}
  end
end

%% ƽ���˲�
TFilter = 9;
L= ones(TFilter);
rhoP1= imfilter(rhoP1, L,'symmetric','conv','same')./sum(L(:));
% rhoP1 = ordfilt2(rhoP1,81,true(9),'symmetric');

rhoM1= rhoP1;
rhoM1(rhoM1>wetCost) = wetCost;
rhoP1(rhoP1>wetCost) = wetCost;
rhoP1(cover == 255) = wetCost;
rhoM1(cover == 0) = wetCost;

%% �ֲ� 
%{
rhoP1(optP1)=min(rhoP1(:));
rhoM1(optM1)=min(rhoM1(:));
%}
%{
  function resH=resHmatri(x)
    resH= x(:,1:end-1)- x(:,2:end);
    resH(G+1,:)= resH(G+1,:).* 2;
  end
  function resV=resVmatri(x)
    resV= x(1:end-1,:)- x(2:end,:);
    resV(:,G+1)= resV(:,G+1).* 2;
  end
%}
end