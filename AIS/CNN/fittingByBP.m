% fittingByBP.m
%% ��������(BP)�����������

% 1.newff��������������ú���
% net=newff(P,T,S,TF,BTF,PF,IPF,OPF,DDF)
    % P:�������ݾ��� T��������ݾ��� S:������ڵ����� TF:�ڵ㴫�ݺ���
    % BTF��ѵ�������������ݶ��½�BP�㷨ѵ������traingd, 
        % �����������ݶ��½�BP�㷨traingdm,��̬����Ӧѧϰ�ʵ��ݶ��½�BP�㷨ѵ������traingda,
        % ���������Ͷ�̬����Ӧѧϰ�ʵ��ݶ��½�BP�㷨ѵ������traingdx, Levenberg_Marquardt��BP�㷨ѵ������trainlm��
    % BLF:����ѧϰ����
    % PF�����ܷ���������������ֵ�������mae��������mse��
    % IPF�����봦������OPF�������������DDF����֤���ݻ��ֺ���
% feedforwardnet()

% 2.train:BP������ѵ������
% [net,tr]=train(NET, X,T,Pi, Ai)
    % NET:��ѵ�����硣X���������ݾ���T��������ݾ���
    % Pi:��ʼ�������������Ai:��ʼ�������������
    % net:ѵ���õ����硣tr:ѵ�����̼�¼
    
% 3.sim:BP������Ԥ�⺯��
% y=sim(net,x)
    % x:�������ݡ�y:����Ԥ�����ݡ�
%% ================================================================
close all;clc; 
strName = 'x .* sin(pi .* x) - y.* sin(pi .* y)';
funcStr = ['@(x,y)', strName];
fh = str2func(funcStr);
[x,y] = meshgrid(-1:0.05:1,-1:0.05:1);
z = fh(x,y);
mesh(x,y,z,'FaceColor',[0.5,0.5,0.5]);
xlabel('x');ylabel('y');zlabel('f(x,y)');title(strName);

%{
vy = y(:)';
dataInput = [x(:)';y(:)']; 
dataTarg = z(:)';
% ��һ��ӳ��(������)
dataInput = mapminmax(dataInput);
vy = mapminmax(vy);
dataTarg = mapminmax(dataTarg);
% �ܵ���������
numSamp = size(dataInput,2);
% Ĭ������
paramConfi.Q = numSamp;
paramConfi.trainRatio = 0.7;
paramConfi.valRatio   = 0.15;
paramConfi.testRatio  = 0.15;
% �������ݼ�(ѵ��\��֤\����)
[paramConfi.trainInd, paramConfi.verInd, paramConfi.testInd] = ...
    dividerand(paramConfi.Q, paramConfi.trainRatio, paramConfi.valRatio, paramConfi.testRatio);
in.train = dataInput(:, paramConfi.trainInd);
in.ver = dataInput(:, paramConfi.verInd);
in.test = dataInput(:, paramConfi.testInd);
targ.train = dataTarg(:, paramConfi.trainInd);
targ.ver = dataTarg(:, paramConfi.verInd);
targ.test = dataTarg(:, paramConfi.testInd);

% ��������
TF1='tansig';TF2='purelin';
net=newff(in.train, targ.train, 1000, {TF1 TF2},'traingdm');
% �������������
net.trainParam.epochs=10000;    %ѵ����������
net.trainParam.goal=1e-7;       %ѵ��Ŀ������
net.trainParam.lr=0.01;         %ѧϰ������
net.trainParam.mc=0.9;          %�������ӵ����ã�Ĭ��Ϊ0.9
net.trainParam.show=25;         %��ʾ�ļ������
% ָ��ѵ������
net.trainFcn = 'traingd';       %�ݶ��½��㷨
% net.trainFcn = 'traingdm';      %�����ݶ��½��㷨
% net.trainFcn = 'trainlm';
% ��ʼѵ��
[net,tr]=train(net, in.train, targ.train);

% ������棬��һ����sim����
[outVer,trainPerf]=sim(net, in.ver);
mse(outVer-targ.ver);
% ��֤�����ݣ���BP�õ��Ľ��
% [normvalidateoutput,validatePerf]=sim(net,valsample.p,[],[],valsample.t);
% �������ݣ���BP�õ��Ľ��
% [normtestoutput,testPerf]=sim(net,testsample.p,[],[],testsample.t);

% �����õĽ�����з���һ�����õ�����ϵ�����
% trainoutput=mapminmax('reverse',normtrainoutput,ts);
% validateoutput=mapminmax('reverse',normvalidateoutput,ts);
% testoutput=mapminmax('reverse',normtestoutput,ts);

% ������������ݵķ���һ���Ĵ����õ�����ʽֵ
trainvalue=mapminmax('reverse',trainsample.t,ts);   % ��������֤����
validatevalue=mapminmax('reverse',valsample.t,ts);  % ��������֤������
testvalue=mapminmax('reverse',testsample.t,ts);     % �����Ĳ�������

% ����
pnew=[313,256,239]';
pnewn=mapminmax(pnew);
anewn=sim(net,pnewn);
anew=mapminmax('reverse',anewn,ts);
% �������ļ���
errors=trainvalue-trainoutput;
% plotregression���ͼ
figure,plotregression(trainvalue,trainoutput)
% ���ͼ
figure,plot(1:length(errors),errors,'-b')
title('���仯ͼ')
% ���ֵ����̬�Եļ���
figure,hist(errors);%Ƶ��ֱ��ͼ
figure,normplot(errors);%Q-Qͼ
[muhat,sigmahat,muci,sigmaci]=normfit(errors); %�������� ��ֵ,����,��ֵ��0.95��������,�����0.95��������
[h1,sig,ci]= ttest(errors,muhat);%�������
figure, ploterrcorr(errors);%�������������ͼ
figure, parcorr(errors);%����ƫ���ͼ
%}
%{
k=rand(1,2000);
[m,n]=sort(k);
input_train=input(n(1:1900),:)';
output_train=output(n(1:1900),:)';
input_test=input(n(1901:2000),:)';
output_test=output(n(1901:2000),:);
[inputn,inputps]=mapminmax(input_train);
[outputn,outputps]=mapminmax(output_train);
%BP�����繹��
net=newff(inputn,outputn,5);
%����������ã�����������ѧϰ�ʣ�Ŀ�꣩
net.trainParam.epochs=100;
net.trainParam.lr=0.1;
net.trainParam.goal=0.00004;

%������ѵ��
net=train(net,inputn,outputn);

%Ԥ���������ݹ�һ��
inputn_test=mapminmax('apply',input_test,inputps);
%������Ԥ�����
an=sim(net,inputn_test);
%�������һ��
BPoutput=mapminmax('reverse',an,outputps);

%����Ԥ����ͼ��
figure(1)
plot(BPoutput,':og')
hold on
plot(output_test,'-*')
legend('Ԥ�����','�������')
title('BP����Ԥ�����','fontsize',12)
ylabel('�������','fontsize',12)
xlabel('����','fontsize',12)

%����Ԥ�����ͼ��
figure(2)
plot(error,'-*')
title('BPԤ�����','fontsize',12)
ylabel('���',fontsize,12)
ylabel('����',fontsize,12)
%}