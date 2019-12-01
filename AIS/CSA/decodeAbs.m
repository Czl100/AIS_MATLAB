function Abs = decodeAbs(genes,NumParas,Vmin,Vmax)
% genes:  ���뿹��
% Val:    real value (precision: 6)
%%
[N, LS] = size(genes);
L = LS/NumParas;
Abs = zeros(N,NumParas,'single'); % һ��Ϊһ������
aux = 0:1:L-1;
aux = ones(N,1) * aux;    % ��Absͬ��С��ָ������: [0,1,2;0,1,2]
j = 1;
for i=1:L:LS
    x = sum( (genes(:,i:i+L-1) .* 2.^aux), 2);    % һ��֮��
    Vals = Vmin + x .* ( (Vmax-Vmin)/(2.^L-1) );
    Abs(:,j) = round(single(Vals), 3);  % ������
    j = j+1;
end
end