�㷨���̣�
1.���ø�����

2.���������ʼȺ�塪��pop=initpop(popsize,chromlength)

3.�������ͱ��룬ÿһ��Ϊһ�֣�code(1,:)��������code(2,:)��50����code(3,:)��150����ʵ�ʹ��ϲ�����ݱ��룬����Unnoralcode,188%

4.��ʼ������M�Σ���
     1������Ŀ�꺯��ֵ��ŷ�Ͼ���[objvalue]=calobjvalue(pop,i)
     2������Ⱥ����ÿ���������Ӧ��fitvalue=calfitvalue(objvalue)
     3��ѡ��newpop=selection(pop,fitvalue); objvalue=calobjvalue(newpop,i); %
        ����newpop=crossover(newpop,pc,k);  objvalue=calobjvalue(newpop,i); %
        ����newpop=mutation(newpop,pm);     objvalue=calobjvalue(newpop,i); %

5.���Ⱥ������Ӧֵ���ĸ��弰����Ӧֵ

6.����ֹͣ�жϡ�