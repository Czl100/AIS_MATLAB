function Key = getKey(Ab)
% Ab:  1*N array -- N��������ʽ
%%
Key = "";
for i=1:length(Ab)
    Key = strjoin([Key,string(Ab(i))],'_');
end
% Key = mat2str(Ab);
end