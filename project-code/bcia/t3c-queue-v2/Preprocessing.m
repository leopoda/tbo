function [posData] = Preprocessing(fileName)
%功能：对原始定位数据进行预处理，包括数值类型转换，是否在安检区域内的判断，是否有对应品牌等
%输入：定位数据文件名，例如：'2015-07-03'
secArea = xlsread('E:\室内定位\机场定位\轨迹分析0819\实验数据\Security_area_point.xlsx'); %读取T3C安检区范围数据
load('E:\室内定位\机场定位\轨迹分析0819\实验数据\brand.mat'); %读取品牌与MAC对应数据
posData = cell(5000000,9);
fid = fopen(['E:\室内定位\机场定位\轨迹分析0819\实验数据\',fileName,'.dat']); %读取定位数据
ind = 1;
drawArea = [250,-500;250,-380;450,-380;450,-500;250,-500]; %用于绘制轨迹的范围

fprintf('开始读取数据\n');
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
[c,ia] = setdiff(posData(:,6),brand(:,1)); %找出无法对应品牌的记录
posData(ia,:) = []; %去除无法对应品牌的记录
clear c;
clear locData;
end