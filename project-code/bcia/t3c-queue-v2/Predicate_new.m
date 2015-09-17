function [preResult,passMac_all,securityResult,passTime,error] = Predicate_new(posData,securityData,secArea,minin,minout,preWin,percentage)
%功能：利用空间位置判断顾客排队时长，（1）从顾客位置进入安检区域开始算起，如果进入安检区之后、出安检区之前，超过百分比percentage
%的点都在安检区内，则认为旅客未出安检区；（2）利用进入安检区之前最后一个点与进入安检区之后第一个点之间时长的一半，即离开安检区之前
%最后一个点和离开安检区之后的第一个点之间时长的一半，对等待时长进行修正。
%输入：
% posData：预处理之后的定位数据；securityData：闸机和安检数据；secArea:安检区范围多边形；preWin：用于预测的时间窗口（时长）；
% minin:判断旅客通过安检区需要的在安检区内检测到的最少点数；minout：判断顾客已出安检区所需的出安检区后检测到的最少点数
%percentage：用于判断顾客是否在安检区的点数百分比
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
    macInd = 0; %判断是否有人通过
    tic
    passTime = zeros(0,1); %用于存储每个预测阶段通过mac的通过时长
    preResult(ind,1) = i; %用于存储预测结果
    securityResult(ind,1) = i; %用于存储闸机记录结果
    passMac_all{ind,1} = i;
    [r0,c0] = find(timeSeries >= i - preWin & timeSeries < i); %找出用于预测的时间范围
    [r00,c00] = find(timeSeries >= i - 60); %如果当前时间距开始计算时间超过1个小时，则以一个小时作为搜索时长范围
    preMac = unique(posData(r0,2));
    passMac = cell(0,3);
    if ~isempty(preMac)
        for j = 1:length(preMac)
            if timeSeries(r0(1)) < 60
                [r1,c1] = find(strcmp(posData(1:r0(end),2),preMac{j,1}));
            else
                [r1,c1] = find(strcmp(posData(r00(1):r0(end),2),preMac{j,1}));
                r1 = r1 + r00(1) - 1; %将脚标还原成原始序列
            end
            if length(r1) > minin + minout + 1 %进入安检区之前至少还需记录到3个点，所以需要加3
                locData = cell2mat(posData(r1,3:5)); %mac对应的空间位置点
                in = inpolygon(locData(:,2),locData(:,3),secArea(:,1),secArea(:,2));
                on = locData(:,1) == 20030;
                in = in&on;
                [x0,y0] = find(in); %找出在安检区内点的序列位置
                [x1,y1] = find(~in); %找出不在安检区内点的序列位置
                if ~isempty(x0) && ~isempty(x1)
%                     if length(x0) >= minin && length(x0)/(x0(end) - x0(1)) >= percentage && x1(end) - x0(end) >= minout
                    if x0(1) - x1(1) >= 1 && length(x0) >= minin && length(x0)/(x0(end) - x0(1) + 1) >= percentage && x1(end) - x0(end) >= minout
%                         [p1,q1] = find(strcmp(inMac,posData{r1(x0(1)),7}));
%                         [p2,q2] = find(strcmp(outMac,posData{r1(x0(end)),7}));
%                         if ~isempty(p1) && ~isempty(p2) %判断进入和离开的点是否来自于对应的边界mac
                            if posData{r1(x0(1)-1),4} < 323.5 && posData{r1(x0(end)+1),4} > 340.8 %判断是否从左侧进入从右侧离开
                                perPositon = cell2mat(posData(r1(x1),4)); %记录位置点的横坐标，以判断是否在安检区外左右漂
                                for s = 2:length(perPositon)
                                    if (perPositon(s-1) < 323.5 && perPositon(s) > 340.8) || (perPositon(s) > 340.8 && perPositon(s-1) < 323.5)
                                        break;
                                    end
                                end
%                                 perPassTimeInterval = perPassTime(2:end) - perPassTime(1:end-1) ; %旅客每两个点之间的时间间隔
                                if 60*(i - preWin) <= 0.5*(posData{r1(x0(end)+1),1} + posData{r1(x0(end)),1}) < i*60 %判断离开安检区时间是否在给定时间范围内
%                                 if max(perPassTimeInterval) <= 300 %当旅客轨迹点记录的最长时间间隔小于两分钟时，才认为是有效的轨迹
                                    passTime(end+1,1) = 0.5*(posData{r1(x0(1)),1} - posData{r1(x0(1)-1),1}) + posData{r1(x0(end)),1} - posData{r1(x0(1)),1} + 0.5*(posData{r1(x0(end)+1),1} - posData{r1(x0(end)),1}); %某旅客停留时长
%                                     passTime(end+1,1) = posData{r1(x0(end)),1} - posData{r1(x0(1)),1}; %某旅客停留时长
                                    passMac{end+1,1} = preMac{j}; %该时段符合计算条件的mac
                                    passMac{end,3} = length(x0)/(x0(end) - x0(1) + 1); %没有漂出的比例
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
                    ind2(end+1) = s; %记录之前已经通过mac的编号
                end
            end
            if ~isempty(ind2)
                passMac(ind2,:) = []; %排除之前已经通过的mac
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
        preResult(ind,2) = median(passTime); %用通过人群等待时长的中位数作为预测值
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
    securityResult(find(securityResult>1800)) = 1800; %将超过1500s的值赋为1500s
    ind = ind + 1;
    disp(i);
    toc
end
% securityResult(:,1) = securityResult(:,1) + 10; %这里是估算，所以要把时间做相应的调整
percent_People_Num = preResult(:,3)./securityResult(:,3);
figure(2);
h1 = subplot(2,1,1);
plot(preResult(:,1),preResult(:,2),'^-','color','r','LineWidth',1.5,'MarkerSize',5);
hold on;
plot(securityResult(:,1),securityResult(:,2),'s-','color','b','LineWidth',1.5,'MarkerSize',5);
set(gca,'FontSize',15);
set(gca,'Xtick',0:60:1440);
set(gca,'XtickLabel',0:1:24);
% xlabel('单位：h');
ylabel('单位：s');
h0 = legend('8月13日WiFi预测时长','安检记录时长','Location','NorthWest');
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
set(HH1,'String','单位：人数');
set(HH1,'FontSize',15);
HH2 = get(AX(2),'Ylabel');
set(HH2,'String','单位：%');
set(HH2,'FontSize',15);
h3 = legend([H1,H2],'满足计算条件人数','计算人数占闸机人数百分比','Location','NorthWest');
set(h3,'FontSize',10);


error = preResult(:,2) - securityResult(:,2);
figure(3);
plot(preResult(:,1),error,'-b','LineWidth',1.5);
hold on;
plot([0,1440],[0,0],'-k');
set(gca,'FontSize',15);
set(gca,'Xtick',0:60:1440);
set(gca,'XtickLabel',0:1:24);
xlabel('单位：h');
ylabel('单位：s');
legend('误差曲线图');
hold off;
end