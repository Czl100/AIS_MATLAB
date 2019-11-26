function Abs = decodeAbs(genes,NumParas,Vmin,Vmax)
% genes:  ���뿹��
% Val:    real value (precision: 6)
%%
[N, LS] = size(genes);
L = LS/NumParas;
Abs = [];
aux = 0:1:L-1;
aux = ones(N,1) * aux;    % ��Absͬ��С��ָ������: [0,1,2;0,1,2]
for i=1:L:LS
    x = sum( (genes(:,i:i+L-1) .* 2.^aux), 2);    % һ��֮��
    Vals = Vmin + x .* ( (Vmax-Vmin)/(2.^L-1) );
    Vals = round(single(Vals), 3);  % ������
    Abs = [Abs, Vals];  % һ��Ϊһ������
end
Abs = mat2cell(Abs, ones(size(Abs,1),1));  % N*NumParas cell
end