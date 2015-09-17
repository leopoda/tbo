function [GAT_T3_E,SCK_T3_E] = ReadSecurityData(date)
%���ܣ�����բ����¼�Ͱ������ʱ�䣬ȷ���ÿ�ͨ�������������ʱ��
%���룺dateΪ�����ַ����������ţ����确20150330��
%�޸����ڣ�20150710 10��46��00
%�޸����ݣ�SCK���ݸ�ʽ��ͬ����Ӧ��ȡ���ݵ�λ�ò�ͬ
tic;
%��ȡբ����¼����
GAT_T3_E = cell(500000,4);
fid1 = fopen('E:\���ڶ�λ\������λ\�켣����0819\��ҵ����\apdb_gat_0814.txt');
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
%GAT_T3_E��1�д洢�˿�ID����2�д洢����ID����3�д洢բ���ţ���4�д洢ͨ��բ��ʱ��

%��ȡ��������
SCK_T3_E = cell(500000,4);
fid2 = fopen('E:\���ڶ�λ\������λ\�켣����0819\ʵ������\apdb_sck_0814.txt');
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
%SCK_T3_E��1�д洢�˿�ID����2�д洢����ID����3�д洢ͨ������ʱ�䣬��4�д洢����ͨ�����
toc;
end