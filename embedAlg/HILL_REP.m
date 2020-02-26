function stego=HILL_REP(cover, payload)
% ���HILL��repairPixel
cover= single(imread(cover));

[optP1,optM1] = repairPixel(cover); % ѡ�е�Ϊ1������Ϊ0
[rhoP1,rhoM1] = CostHILL(cover);
vmin= min(min(rhoP1(:)), min(rhoM1(:)));

% �޸ĵĴ���
rhoP1(optP1)= vmin*0.1;
rhoM1(optM1)= vmin*0.1;

cover(optP1)= cover(optP1)+1;
cover(optM1)= cover(optM1)-1;

stego = EmbeddingSimulator(cover, rhoP1, rhoM1, payload*numel(cover), false);
end