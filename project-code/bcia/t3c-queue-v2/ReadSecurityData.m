function [GAT_T3_E,SCK_T3_E] = ReadSecurityData(date)
%功能：根据闸机记录和安检盖章时间，确定旅客通过安检区域的是时长
%输入：date为日期字符串（加引号），如‘20150330’
%修改日期：20150710 10：46：00
%修改内容；SCK数据格式不同，对应读取数据的位置不同
tic;
%读取闸机记录数据
GAT_T3_E = cell(500000,4);
fid1 = fopen('E:\室内定位\机场定位\轨迹分析0819\行业数据\apdb_gat_0814.txt');
ind = 1;
i = 1;
while ~feof(fid1)
    textline = fgetl(fid1);
    splitStr = regexp(textline,'	','split');
    if length(splitStr{5}) > 8
        if strcmp(splitStr{5}(1:8),date) && strcmp(splitStr{10},'E')
            GAT_T3_E(ind,:) = [splitStr(1,2),splitStr(1,3),splitStr(1,5),splitStr(1,7)];
            ind = ind + 1;
        end
    end
    i = i + 1;
    if mod(i,100) == 0
        disp(i);
    end
end
fclose(fid1);
[r0,c0] = find(cellfun(@isempty,GAT_T3_E(:,1)));
GAT_T3_E(r0,:) = [];
%GAT_T3_E第1列存储顾客ID，第2列存储航班ID，第3列存储闸机号，第4列存储通过闸机时间

%读取盖章数据
SCK_T3_E = cell(500000,4);
fid2 = fopen('E:\室内定位\机场定位\轨迹分析0819\实验数据\apdb_sck_0814.txt');
ind = 1;
i = 1;
while ~feof(fid2)
    textline = fgetl(fid1);
    splitStr = regexp(textline,'	','split');
    if length(splitStr{6}) > 8
        if strcmp(splitStr{6}(1:8),date) && strcmp(splitStr{19},'E')
            SCK_T3_E(ind,:) = [splitStr(1,1),splitStr(1,6),splitStr(1,6),splitStr(1,7)];
            ind = ind + 1;
        end
    end
    i = i + 1;
    if mod(i,100) == 0
        disp(i);
    end
end
fclose(fid2);
[r0,c0] = find(cellfun(@isempty,SCK_T3_E(:,1)));
SCK_T3_E(r0,:) = [];
%SCK_T3_E第1列存储顾客ID，第2列存储航班ID，第3列存储通过安检时间，第4列存储安检通道编号
toc;
end