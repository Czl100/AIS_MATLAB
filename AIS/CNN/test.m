% test file
close all;clc; 
% strName = 'x .* sin(pi .* x) - y.* sin(pi .* y)';
% strName = 'x .* sin(pi .* x) - y.* sin(pi .* y)';
% funcStr = ['@(x,y)', strName];
% fh = str2func(funcStr);
% [x,y] = meshgrid(-1:0.05:1,-1:0.05:1);
% z = fh(x,y);
% mesh(x,y,z,'FaceColor',[0.5,0.5,0.5]);
% xlabel('x');ylabel('y');zlabel('f(x,y)');title(strName);

syms x y;
f = x .* sin(pi .* x) - y.* sin(pi .* y);
x0=[0.1;0.3];
e=10^(-20);
[k ender]=steepest(f,x0,e);
% plot3([x(1),ender], y,fx,'k*');


% ��������ģ�ͼ���matlab���������ơ�
%{
close all;clc;
% һά����,һ�д���һ������
[input,targ] = simplefit_dataset;
funcName = '2.*sin(x) + cos(y)';
% funcName = '-1 * x .* sin(2 * pi .* x) + y.* sin(2 * pi .* y) + 1'; 
funcName = 'sin(2 * pi .* x) + cos(2 * pi .* y) + 1'; 
funcStr = ['@(x, y)', funcName];
fh = str2func(funcStr);
[x,y] = meshgrid(-1:0.05:1,-1:0.05:1);
z = fh(x, y);

% ����ģ��
targ = z(:)';
input = [x(:)';y(:)'];
% ���ز���10����Ԫ,
% feedforwardnet�Զ����������ݷ�Ϊѵ��\��֤\�����Ӽ�
net = feedforwardnet(10, 'trainlm');
% �������������
% net.divideParam.trainRatio = 0.8;
% net.divideParam.valRatio   = 0.1;
% net.divideParam.testRatio  = 0.1;

% net.trainParam.epochs=10000;    %ѵ����������
% net.trainParam.goal=1e-7;       %ѵ��Ŀ������
% net.trainParam.lr=0.01;         %ѧϰ������
% net.trainParam.mc=0.9;          %�������ӵ����ã�Ĭ��Ϊ0.9
% net.trainParam.show=25;         %��ʾ�ļ������
% �������ز������

% ��ʼѵ��
net = train(net, input, targ);
% view(net)
outTest = net(input);
% perf = mse(y-t);
perf = perform(net, outTest, targ);
fprintf('perfor:%f\n', perf);

% ��ͼ��֤
mesh(x,y,z,'FaceColor','r');hold on;
mesh(x,y,reshape(outTest, size(x)),'FaceColor','b');
legend('target','test');
xlabel('x');ylabel('y');zlabel('f(x,y)');title(funcName);
%}