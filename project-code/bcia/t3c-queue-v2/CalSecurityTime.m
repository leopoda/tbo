function [securityTime,securityData,sck] = CalSecurityTime(GAT,SCK)
tic;
GAT = [GAT,cell(length(GAT),1)];
SCK = [SCK,cell(length(SCK),1)];
% n = min(length(GAT),length(SCK));
securityTime = cell(length(GAT),9); %��1�д洢�˿�ID�ţ���2�д洢����բ��ʱ�䣬��3�д洢����ʱ�����ֵ��ʽ����4�д洢�������ʱ��
%��5�д洢�������ʱ����ֵ��ʽ�������д洢�˿�ͨ������������ʱ��
ind = 1;
for i = 1:length(GAT)
    GAT{i,5} = 3600*str2double(GAT{i,3}(9:10)) + 60*str2double(GAT{i,3}(11:12)) + str2double(GAT{i,3}(13:14));
end

for i = 1:length(SCK)
    SCK{i,5} = 3600*str2double(SCK{i,3}(9:10)) + 60*str2double(SCK{i,3}(11:12)) + str2double(SCK{i,3}(13:14));
end
cuntomerID = unique(SCK(:,1));
for i = 1:length(GAT)
    [r,c] = find(strcmp(SCK(:,1),GAT{i,1}));
    if length(r) == 1
        securityTime(ind,1:5) = GAT(i,:);
        securityTime(ind,6:8) = SCK(r,3:5);
        securityTime{ind,9} = securityTime{ind,8} - securityTime{ind,5};
        ind = ind + 1;
    end
    if mod(i,100) == 0
        disp(i);
    end
end
sck = [securityTime(:,8),securityTime(:,7)];
securityData = cell2mat(securityTime(:,8:9));
[r,c] = find(securityData(:,2) <= 0);
securityData(r,:) = [];
toc;
end