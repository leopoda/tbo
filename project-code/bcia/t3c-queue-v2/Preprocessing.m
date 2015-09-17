function [posData] = Preprocessing(fileName)
%���ܣ���ԭʼ��λ���ݽ���Ԥ����������ֵ����ת�����Ƿ��ڰ��������ڵ��жϣ��Ƿ��ж�ӦƷ�Ƶ�
%���룺��λ�����ļ��������磺'2015-07-03'
secArea = xlsread('E:\���ڶ�λ\������λ\�켣����0819\ʵ������\Security_area_point.xlsx'); %��ȡT3C��������Χ����
load('E:\���ڶ�λ\������λ\�켣����0819\ʵ������\brand.mat'); %��ȡƷ����MAC��Ӧ����
posData = cell(5000000,9);
fid = fopen(['E:\���ڶ�λ\������λ\�켣����0819\ʵ������\',fileName,'.dat']); %��ȡ��λ����
ind = 1;
drawArea = [250,-500;250,-380;450,-380;450,-500;250,-500]; %���ڻ��ƹ켣�ķ�Χ

fprintf('��ʼ��ȡ����\n');
while ~feof(fid)
    textLine = fgetl(fid);
    splitStr = regexp(textLine,'	','split');
    str_date_time = regexp(splitStr{1},' ','split');
    str_time = regexp(str_date_time{2},':','split');
    splitStr{1} = 3600*str2double(str_time{1}) + 60*str2double(str_time{2}) + str2double(str_time{3});
    splitStr{4} = str2double(splitStr{4});
    splitStr{5} = str2double(splitStr{5})/1000;
    splitStr{6} = str2double(splitStr{6})/(-1000);
    in = inpolygon(splitStr{5},splitStr{6},drawArea(:,1),drawArea(:,2));
    if in
        posData(ind,1:7) = splitStr;
        ind = ind + 1;
    end
    if mod(ind,100) == 0
        disp(ind);
    end
end
fclose(fid);
[r,c] = find(cellfun(@isempty,posData(:,1)));
posData(r,:) = [];
posData(:,3) = [];
% locData = cell2mat(posData(:,3:4));
% in = inpolygon(locData(:,1),locData(:,2),secArea(:,1),secArea(:,2));
% posData = posData(in,:);
% figure(1);
% plot(secArea(:,1),secArea(:,2),'-b');
% hold on;
% plot(locData(in,1),locData(in,2),'.r',locData(~in,1),locData(~in,2),'.k');
% set(gca,'FontSize',15);
% axis equal;
n = length(posData);
for i = 1:n
    posData{i,7} = posData{i,2}(1:6);
    posData{i,8} = posData{i,6}(end-3:end);
    if mod(i,100) == 0
        disp(i);
    end
end
posData(:,6) = [];
[c,ia] = setdiff(posData(:,6),brand(:,1)); %�ҳ��޷���ӦƷ�Ƶļ�¼
posData(ia,:) = []; %ȥ���޷���ӦƷ�Ƶļ�¼
clear c;
clear locData;
end