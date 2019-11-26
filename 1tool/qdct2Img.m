function imgData = qdct2Img(QDCT, QTable, Cb, Cr)
% QDCTת��Img

% ������
iquan_fun = @(block_struct)( block_struct.data .* QTable); 
coef_quaned_recon=blockproc(QDCT, [8 8], iquan_fun);
% DCT���任
idct_fun = @(block_struct)idct2(block_struct.data, [8,8]);
I = (blockproc(coef_quaned_recon,[8 8], idct_fun));
% ��ɫͼ��
if(exist('Cb','var') && length(Cb)>1)
    Y = I;
    [R,G,B] = yCbCr2rgb( Y,Cb,Cr );
    imgData(:,:,1)=R;   
    imgData(:,:,2)=G;
    imgData(:,:,3)=B;
else
    imgData = I;
end
imgData = double(uint8(imgData+128));
end