function [preResult,passMac_all,securityResult,passTime,error] = Predicate_new(posData,securityData,secArea,minin,minout,preWin,percentage)
%���ܣ����ÿռ�λ���жϹ˿��Ŷ�ʱ������1���ӹ˿�λ�ý��밲������ʼ����������밲����֮�󡢳�������֮ǰ�������ٷֱ�percentage
%�ĵ㶼�ڰ������ڣ�����Ϊ�ÿ�δ������������2�����ý��밲����֮ǰ���һ��������밲����֮���һ����֮��ʱ����һ�룬���뿪������֮ǰ
%���һ������뿪������֮��ĵ�һ����֮��ʱ����һ�룬�Եȴ�ʱ������������
%���룺
% posData��Ԥ����֮��Ķ�λ���ݣ�securityData��բ���Ͱ������ݣ�secArea:��������Χ����Σ�preWin������Ԥ���ʱ�䴰�ڣ�ʱ������
% minin:�ж��ÿ�ͨ����������Ҫ���ڰ������ڼ�⵽�����ٵ�����minout���жϹ˿��ѳ�����������ĳ����������⵽�����ٵ���
%percentage�������жϹ˿��Ƿ��ڰ������ĵ����ٷֱ�
timeSeries = cell2mat(posData(:,1));
[timeSeries,index] = sort(timeSeries);
posData = posData(index,:);
securityData = sortrows(securityData,1);
securityData(:,1) = securityData(:,1)/60;
timeSeries = timeSeries/60;
preResult = zeros((1440 - preWin)/preWin,3);
securityResult = zeros(length(preResult),3);
passMac_all = cell(1440 - preWin,2);
PASSMACALL = cell(0,1);
ind = 1;
for i = preWin:preWin:1440
    macInd = 0; %�ж��Ƿ�����ͨ��
    tic
    passTime = zeros(0,1); %���ڴ洢ÿ��Ԥ��׶�ͨ��mac��ͨ��ʱ��
    preResult(ind,1) = i; %���ڴ洢Ԥ����
    securityResult(ind,1) = i; %���ڴ洢բ����¼���
    passMac_all{ind,1} = i;
    [r0,c0] = find(timeSeries >= i - preWin & timeSeries < i); %�ҳ�����Ԥ���ʱ�䷶Χ
    [r00,c00] = find(timeSeries >= i - 60); %�����ǰʱ��࿪ʼ����ʱ�䳬��1��Сʱ������һ��Сʱ��Ϊ����ʱ����Χ
    preMac = unique(posData(r0,2));
    passMac = cell(0,3);
    if ~isempty(preMac)
        for j = 1:length(preMac)
            if timeSeries(r0(1)) < 60
                [r1,c1] = find(strcmp(posData(1:r0(end),2),preMac{j,1}));
            else
                [r1,c1] = find(strcmp(posData(r00(1):r0(end),2),preMac{j,1}));
                r1 = r1 + r00(1) - 1; %���ű껹ԭ��ԭʼ����
            end
            if length(r1) > minin + minout + 1 %���밲����֮ǰ���ٻ����¼��3���㣬������Ҫ��3
                locData = cell2mat(posData(r1,3:5)); %mac��Ӧ�Ŀռ�λ�õ�
                in = inpolygon(locData(:,2),locData(:,3),secArea(:,1),secArea(:,2));
                on = locData(:,1) == 20030;
                in = in&on;
                [x0,y0] = find(in); %�ҳ��ڰ������ڵ������λ��
                [x1,y1] = find(~in); %�ҳ����ڰ������ڵ������λ��
                if ~isempty(x0) && ~isempty(x1)
%                     if length(x0) >= minin && length(x0)/(x0(end) - x0(1)) >= percentage && x1(end) - x0(end) >= minout
                    if x0(1) - x1(1) >= 1 && length(x0) >= minin && length(x0)/(x0(end) - x0(1) + 1) >= percentage && x1(end) - x0(end) >= minout
%                         [p1,q1] = find(strcmp(inMac,posData{r1(x0(1)),7}));
%                         [p2,q2] = find(strcmp(outMac,posData{r1(x0(end)),7}));
%                         if ~isempty(p1) && ~isempty(p2) %�жϽ�����뿪�ĵ��Ƿ������ڶ�Ӧ�ı߽�mac
                            if posData{r1(x0(1)-1),4} < 323.5 && posData{r1(x0(end)+1),4} > 340.8 %�ж��Ƿ����������Ҳ��뿪
                                perPositon = cell2mat(posData(r1(x1),4)); %��¼λ�õ�ĺ����꣬���ж��Ƿ��ڰ�����������Ư
                                for s = 2:length(perPositon)
                                    if (perPositon(s-1) < 323.5 && perPositon(s) > 340.8) || (perPositon(s) > 340.8 && perPositon(s-1) < 323.5)
                                        break;
                                    end
                                end
%                                 perPassTimeInterval = perPassTime(2:end) - perPassTime(1:end-1) ; %�ÿ�ÿ������֮���ʱ����
                                if 60*(i - preWin) <= 0.5*(posData{r1(x0(end)+1),1} + posData{r1(x0(end)),1}) < i*60 %�ж��뿪������ʱ���Ƿ��ڸ���ʱ�䷶Χ��
%                                 if max(perPassTimeInterval) <= 300 %���ÿ͹켣���¼���ʱ����С��������ʱ������Ϊ����Ч�Ĺ켣
                                    passTime(end+1,1) = 0.5*(posData{r1(x0(1)),1} - posData{r1(x0(1)-1),1}) + posData{r1(x0(end)),1} - posData{r1(x0(1)),1} + 0.5*(posData{r1(x0(end)+1),1} - posData{r1(x0(end)),1}); %ĳ�ÿ�ͣ��ʱ��
%                                     passTime(end+1,1) = posData{r1(x0(end)),1} - posData{r1(x0(1)),1}; %ĳ�ÿ�ͣ��ʱ��
                                    passMac{end+1,1} = preMac{j}; %��ʱ�η��ϼ���������mac
                                    passMac{end,3} = length(x0)/(x0(end) - x0(1) + 1); %û��Ư���ı���
                                    macInd = macInd + 1;
                                end
                            end
%                         end
                    end
                end
            end
        end
%         passMac_all{ind,2} = passMac;
        [r2,c2] = find(passTime > 1800);
        passTime(r2,:) = [];
        passMac(r2,:) = [];
        [r3,c3] = find(passTime < mean(passTime) - 2*std(passTime) | passTime > mean(passTime) + 2*std(passTime));
        if ~isempty(r3)
            passTime(r3,:) = [];
            passMac(r3,:) = [];
        end
        if ~isempty(PASSMACALL)
            ind2 = zeros(1,0);
            for s = 1:length(passMac)
                [xt,yt] = find(strcmp(PASSMACALL,passMac{s}));
                if ~isempty(xt)
                    ind2(end+1) = s; %��¼֮ǰ�Ѿ�ͨ��mac�ı��
                end
            end
            if ~isempty(ind2)
                passMac(ind2,:) = []; %�ų�֮ǰ�Ѿ�ͨ����mac
                passTime(ind2,:) = [];
            end
        end
        if macInd > 0
            [x,y] = size(passMac);
            for k = 1:x
                passMac{k,2} = passTime(k);
            end
        end
        passMac_all{ind,2} = passMac;
        PASSMACALL = [PASSMACALL;passMac(:,1)];
        preResult(ind,2) = median(passTime); %��ͨ����Ⱥ�ȴ�ʱ������λ����ΪԤ��ֵ
%         if ~isempty(passTime)
%             preResult(ind,2) = (max(passTime)+min(passTime))/2;
%         end
        [m,n] = size(passMac);
        preResult(ind,3) = m;
    end
    [r3,c3] = find(securityData(:,1) >= i  & securityData(:,1) < i + preWin);
    if ~isempty(r3)
        securityResult(ind,2) = round(median(securityData(r3,2)));
        securityResult(ind,3) = length(r3);
    end
    securityResult(find(securityResult>1800)) = 1800; %������1500s��ֵ��Ϊ1500s
    ind = ind + 1;
    disp(i);
    toc
end
% securityResult(:,1) = securityResult(:,1) + 10; %�����ǹ��㣬����Ҫ��ʱ������Ӧ�ĵ���
percent_People_Num = preResult(:,3)./securityResult(:,3);
figure(2);
h1 = subplot(2,1,1);
plot(preResult(:,1),preResult(:,2),'^-','color','r','LineWidth',1.5,'MarkerSize',5);
hold on;
plot(securityResult(:,1),securityResult(:,2),'s-','color','b','LineWidth',1.5,'MarkerSize',5);
set(gca,'FontSize',15);
set(gca,'Xtick',0:60:1440);
set(gca,'XtickLabel',0:1:24);
% xlabel('��λ��h');
ylabel('��λ��s');
h0 = legend('8��13��WiFiԤ��ʱ��','�����¼ʱ��','Location','NorthWest');
set(h0,'FontSize',10);
h2 = subplot(2,1,2);
percent = preResult(:,3)./securityResult(:,3);
percent(find(percent >= 1)) = 1;
[AX,H1,H2] = plotyy(preResult(:,1),preResult(:,3),preResult(:,1),percent,'plot');

set(h1,'position',[0.1,0.3,0.8,0.6]);
set(h2,'position',[0.1,0.08,0.8,0.15]);

set(AX(1),'XColor','k','YColor','k');
set(AX(2),'XColor','k','YColor','k');
set(AX(1),'FontSize',15);
set(AX(1),'Xtick',0:60:1440);
set(AX(1),'XtickLabel',0:1:24);
set(AX(1),'Ytick',0:25:50);
set(AX(1),'YtickLabel',0:25:50);
set(AX(2),'FontSize',15);
set(AX(2),'Xtick',0:60:1440);
set(AX(2),'XtickLabel',[]);
set(AX(2),'Ytick',0:0.5:1);
set(AX(2),'YtickLabel',0:50:100);
set(H1,'color',[160/255,30/255,10/255],'LineWidth',1.5);
set(H2,'color','b','LineWidth',1.5);

HH1 = get(AX(1),'Ylabel');
set(HH1,'String','��λ������');
set(HH1,'FontSize',15);
HH2 = get(AX(2),'Ylabel');
set(HH2,'String','��λ��%');
set(HH2,'FontSize',15);
h3 = legend([H1,H2],'���������������','��������ռբ�������ٷֱ�','Location','NorthWest');
set(h3,'FontSize',10);


error = preResult(:,2) - securityResult(:,2);
figure(3);
plot(preResult(:,1),error,'-b','LineWidth',1.5);
hold on;
plot([0,1440],[0,0],'-k');
set(gca,'FontSize',15);
set(gca,'Xtick',0:60:1440);
set(gca,'XtickLabel',0:1:24);
xlabel('��λ��h');
ylabel('��λ��s');
legend('�������ͼ');
hold off;
end