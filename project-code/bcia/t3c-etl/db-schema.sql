use ${hiveconf:db_name};

CREATE EXTERNAL TABLE IF NOT EXISTS barcode_record (
       id                      bigint,
       passager_name           string,
       flight                  string,
       flight_date             string,
       ship                    string,
       seat_no                 string,
       boarding_no             string,
       start_city              string,
       end_city                string,
       gate_name               string,
       first_scan_time         string,
       last_scan_time          string,
       scan_number             bigint,
       error_code              string)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
LOCATION '${hiveconf:hdfs_path}/BARCODE_RECORD';

CREATE VIEW IF NOT EXISTS vw_barcode_record AS
SELECT id,
       trim(passager_name) passager_name,
       CASE
           WHEN (substr(trim(flight), 2, 1) RLIKE '([A-Z]+|[A-Z])') AND substr(trim(flight), 3, 2) = '00' THEN concat(substr(trim(flight), 1, 2), substr(trim(flight), 5))
           WHEN (substr(trim(flight), 2, 1) RLIKE '([A-Z]+|[A-Z])') AND substr(trim(flight), 3, 1) = '0' THEN concat(substr(trim(flight), 1, 2), substr(trim(flight), 4))
           WHEN length(trim(flight)) = 7 AND substr(trim(flight), length(trim(flight)), 1) = '0' THEN substr(trim(flight), 1, length(trim(flight))-1)
       ELSE
           regexp_replace(trim(flight), ' ', '')
       END as flight,
       trim(flight_date) flight_date,
       trim(ship) ship,
       trim(seat_no) seat_no,
       trim(boarding_no) boarding_no,
       trim(start_city) start_city,
       trim(end_city) end_city,
       trim(gate_name) gate_name,
       trim(first_scan_time) first_scan_time,
       trim(last_scan_time) last_scan_time,
       scan_number ,
       trim(error_code) error_code
FROM barcode_record;

CREATE EXTERNAL TABLE IF NOT EXISTS log_sec_scosprsc (
       SC_FFID					string,
       SC_BRDNO					string,
       OPERATION_DATE			string,
       FLIGHT_NO				string,
       SC_SEAT					string,
       SC_DEPT					string,
       SC_INOUT					string,
       SC_PASSFLAG				string,
       SC_SCTM					string,
       SC_FIELD					string,
       SC_SCCM					string,
       SC_SCLOC					string,
       SC_HANDFLAG				string,
       SC_CTYPE					string,
       SC_CNUMBER				string,
       SC_CVALIDATE				string,
       SC_CDEP					string,
       SC_ADDRESS				string,
       SC_BIRTHDAR				string,
       SC_NATION				string,
       SC_CHNNAME				string,
       SC_NAME					string,
       SC_GENDER				string,
--       SC_PSRPHOTO				binary, -- sqoop does not support to import blob field from oracle
       SC_PSCID					string,
       FLGT_ID					string,
       MB_ID					bigint,
       PROCESS_STATUS			string,
       LAST_UPDATE_DATE	    	string)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
LOCATION '${hiveconf:hdfs_path}/LOG_SEC_SCOSPRSC';

CREATE EXTERNAL TABLE IF NOT EXISTS log_sec_ajxxb (
       sysid                   string,
       ajxxb_id                bigint,
       lk_id                   bigint,
       safe_flag               string,
       safe_no                 string,
       safe_oper               string,
       safe_time               string,
       bag_open                string,
       safe_out                string,
       safe_outno              string,
       safe_outtime            string,
       file_name               string,
       lk_date                 string,
       lk_flight               string,
       flgt_id                 string,
       process_status          string,
       last_update_date        string)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
LOCATION '${hiveconf:hdfs_path}/LOG_SEC_AJXXB';

CREATE VIEW IF NOT EXISTS vw_log_sec_ajxxb AS
SELECT
       trim(sysid) sysid,
       ajxxb_id ,
       lk_id ,
       trim(safe_flag) safe_flag,
       trim(safe_no) safe_no,
       trim(safe_oper) safe_oper,
       trim(safe_time) safe_time,
       trim(bag_open) bag_open,
       trim(safe_out) safe_out,
       trim(safe_outno) safe_outno,
       trim(safe_outtime) safe_outtime,
       trim(file_name) file_name,
       trim(lk_date) lk_date, 
       CASE
           WHEN (substr(trim(lk_flight), 2, 1) RLIKE '([A-Z]+|[A-Z])') AND substr(trim(lk_flight), 3, 2) = '00' THEN concat(substr(trim(lk_flight), 1, 2), substr(trim(lk_flight), 5))
           WHEN (substr(trim(lk_flight), 2, 1) RLIKE '([A-Z]+|[A-Z])') AND substr(trim(lk_flight), 3, 1) = '0' THEN concat(substr(trim(lk_flight), 1, 2), substr(trim(lk_flight), 4))
           WHEN length(trim(lk_flight)) = 7 AND substr(trim(lk_flight), length(trim(lk_flight)), 1) = '0' THEN substr(trim(lk_flight), 1, length(trim(lk_flight))-1)
       ELSE
           regexp_replace(trim(lk_flight), ' ', '')
       END as lk_flight,
       trim(flgt_id) flgt_id,
       trim(process_status) process_status,
       trim(last_update_date) last_update_date
FROM log_sec_ajxxb;



CREATE EXTERNAL TABLE IF NOT EXISTS log_sec_dcspnck (
       ck_ffid                 string,
       ck_brdno                int,
       operation_date          string,
       flight_no               string,
       ck_loc                  string,
       ck_dept                 string,
       ck_prsta                string,
       ck_dest                 string,
       ck_name                 string,
       ck_chnname              string,
       ck_gender               string,
       ck_ics                  string,
       ck_vip                  string,
       ck_seat                 string,
       ck_class                string,
       ck_inf                  string,
       ck_gates                string,
       ck_ctct                 string,
       ck_cert                 string,
       ck_etfl                 string,
       ck_etno                 string,
       ck_fffr                 string,
       ck_group                string,
       ck_bags                 int,
       ck_bagwgt               int,
       ck_depttm               string,
       ck_sip                  string,
       ck_ckipid               string,
       ck_ckiagt               string,
       ck_ckitm                string,
       ck_ckiofc               string,
       ck_tsflag               string,
       flgt_id                 string,
       mb_id                   bigint,
       process_status          string,
       last_update_date        string)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
LOCATION '${hiveconf:hdfs_path}/LOG_SEC_DCSPNCK';

CREATE EXTERNAL TABLE IF NOT EXISTS log_sec_lkxxb (
       sysid                   string,
       lk_id                   string,
       lk_flight               string,
       lk_date                 string,
       lk_seat                 string,
       lk_strt                 string,
       lk_dest                 string,
       lk_bdno                 string,
       lk_ename                string,
       lk_cname                string,
       lk_card                 string,
       lk_cardid               string,
       lk_nation               string,
       lk_sex                  string,
       lk_tel                  string,
       lk_resr                 string,
       lk_inf                  string,
       lk_infname              string,
       lk_class                string,
       lk_chkn                 string,
       lk_chkt                 string,
       lk_gateno               string,
       lk_vip                  string,
       lk_insur                string,
       lk_outtime              string,
       lk_del                  string,
       ajxxb_id                string,
       safe_time               string,
       flgt_id                 string,
       file_name               string,
       process_status          string,
       last_update_date        string)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
LOCATION '${hiveconf:hdfs_path}/LOG_SEC_LKXXB';

CREATE VIEW IF NOT EXISTS vw_log_sec_lkxxb AS
SELECT 
       trim(sysid) sysid,
       trim(lk_id) lk_id,
       CASE
           WHEN (substr(trim(lk_flight), 2, 1) RLIKE '([A-Z]+|[A-Z])') AND substr(trim(lk_flight), 3, 2) = '00' THEN concat(substr(trim(lk_flight), 1, 2), substr(trim(lk_flight), 5))
           WHEN (substr(trim(lk_flight), 2, 1) RLIKE '([A-Z]+|[A-Z])') AND substr(trim(lk_flight), 3, 1) = '0' THEN concat(substr(trim(lk_flight), 1, 2), substr(trim(lk_flight), 4))
           WHEN length(trim(lk_flight)) = 7 AND substr(trim(lk_flight), length(trim(lk_flight)), 1) = '0' THEN substr(trim(lk_flight), 1, length(trim(lk_flight))-1)
       ELSE
           regexp_replace(trim(lk_flight), ' ', '')
       END as lk_flight,
       trim(lk_date) lk_date,
       trim(lk_seat) lk_seat,
       trim(lk_strt) lk_strt,
       trim(lk_dest) lk_dest,
       trim(lk_bdno) lk_bdno,
       trim(lk_ename) lk_ename,
       trim(lk_cname) lk_cname,
       trim(lk_card) lk_card,
       trim(lk_cardid) lk_cardid,
       trim(lk_nation) lk_nation,
       trim(lk_sex) lk_sex,
       trim(lk_tel) lk_tel,
       trim(lk_resr) lk_resr,
       trim(lk_inf) lk_inf,
       trim(lk_infname) lk_infname,
       trim(lk_class) lk_class,
       trim(lk_chkn) lk_chkn,
       trim(lk_chkt) lk_chkt,
       trim(lk_gateno) lk_gateno,
       trim(lk_vip) lk_vip,
       trim(lk_insur) lk_insur,
       trim(lk_outtime) lk_outtime,
       trim(lk_del) lk_del,
       trim(ajxxb_id) ajxxb_id,
       trim(safe_time) safe_time,
       trim(flgt_id) flgt_id,
       trim(file_name) file_name,
       trim(process_status) process_status,
       trim(last_update_date) last_update_date
FROM log_sec_lkxxb;

CREATE EXTERNAL TABLE IF NOT EXISTS apdb_pid (
       cki_type string,
       cki_sub_type string,
       cki_pid string,
       cki_cntr_nbr string,
       cki_area string,
       cki_terminal string,
       cki_ew string,
       cki_di string,
       cki_iagt string,
       last_update string)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
LOCATION '${hiveconf:hdfs_path}/APDB_PID';
