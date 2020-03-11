function [imgData,HF] = sharpen(imgData, Amplitude)
% ͼ����, �ḻ��������
% Amplitude: ����
%%
if(ischar(imgData))
   imgData= single(imread(imgData));
end
[t, ~]= wiener2(imgData, [3,3]);
HF= imgData - t;
% ԭT=8; T=3ʱ, PSNR�Ϻ�, ��һ���㷨ʱȡ��ע��
% T= 8; HF(HF>T)=T; HF(HF<-1*T)=-1*T;
HF= round(HF * Amplitude);
imgData= imgData + HF;
imgData(imgData<0)= 0;  imgData(imgData>255)= 255;