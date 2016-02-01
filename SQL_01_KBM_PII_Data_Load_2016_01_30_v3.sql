/*
 * ========================================================================
 * Filename:    SQL_01_KBM_Data_Load_PII_LKP
 * Description: This file helps with loading fixed width files into SQL
 *              Server database
 * Author:      Vishwa Kolla
 * Version(s):
 *  V1: 2016/01/30  Initial version
 *  V2: 2016/01/30  Updated with code
 * ========================================================================
 */

/*
 * 01: Create a shell.
 *
 * This shell captures the entire string. Once the data is in the database
 * we can split the data into different tables as we see fit.
 */

USE INS_DS_MKTG;

DROP  TABLE   T_KBM_PII_LKP_STG;
CREATE TABLE  T_KBM_PII_LKP_STG (
  RAW_DAT varchar(max)
);

/*
 * 02: Bulk load data.
 */
BULK INSERT
  T_KBM_PII_LKP_STG
FROM
  'Z:\02 - KBM Decrypted Files\01 - PII LKP\1511_ID3963P_FILE05_Top';

DELETE FROM T_KBM_PII_LKP_STG;

BULK INSERT
  T_KBM_PII_LKP_STG
FROM
  'Z:\02 - KBM Decrypted Files\01 - PII LKP\1511_ID3963P_FILE01';

BULK INSERT
  T_KBM_PII_LKP_STG
FROM
  'Z:\02 - KBM Decrypted Files\01 - PII LKP\1511_ID3963P_FILE02';

BULK INSERT
  T_KBM_PII_LKP_STG
FROM
  'Z:\02 - KBM Decrypted Files\01 - PII LKP\1511_ID3963P_FILE03';

BULK INSERT
  T_KBM_PII_LKP_STG
FROM
  'Z:\02 - KBM Decrypted Files\01 - PII LKP\1511_ID3963P_FILE04';

BULK INSERT
  T_KBM_PII_LKP_STG
FROM
  'Z:\02 - KBM Decrypted Files\01 - PII LKP\1511_ID3963P_FILE05';

BULK INSERT
  T_KBM_PII_LKP_STG
FROM
  'Z:\02 - KBM Decrypted Files\01 - PII LKP\1511_ID3963P_FILE06';


/*
 * 03: QC.
 */
SELECT COUNT(1) FROM  T_KBM_PII_LKP_STG;
SELECT TOP 10 * FROM  T_KBM_PII_LKP_STG;

/*
 * 04: Create tables shell with extract.
 */
DROP TABLE    T_KBM_PII_LKP;
CREATE TABLE  T_KBM_PII_LKP (
  FNAME VARCHAR(15),
  MNAME VARCHAR(1),
  LNAME VARCHAR(15),
  FILLER VARCHAR(10),
  SUFFIX VARCHAR(15),
  ADR1 VARCHAR(40),
  CITY VARCHAR(13),
  ST VARCHAR(2),
  ZIP VARCHAR(5),
  P4 VARCHAR(4),
  APTF VARCHAR(1),
  NONO2 VARCHAR(12),
  TELE VARCHAR(10),
  DOBMM VARCHAR(2),
  DOBDD VARCHAR(2),
  DOBCCYY VARCHAR(4),
  KLNK VARCHAR(15),
);

INSERT T_KBM_PII_LKP
SELECT
  FNAME = SUBSTRING(RAW_DAT,1,15),
  MNAME = SUBSTRING(RAW_DAT,16,1),
  LNAME = SUBSTRING(RAW_DAT,17,15),
  FILLER = SUBSTRING(RAW_DAT,32,10),
  SUFFIX = SUBSTRING(RAW_DAT,42,15),
  ADR1 = SUBSTRING(RAW_DAT,57,40),
  CITY = SUBSTRING(RAW_DAT,97,13),
  ST = SUBSTRING(RAW_DAT,110,2),
  ZIP = SUBSTRING(RAW_DAT,112,5),
  P4 = SUBSTRING(RAW_DAT,117,4),
  APTF = SUBSTRING(RAW_DAT,121,1),
  NONO2 = SUBSTRING(RAW_DAT,122,12),
  TELE = SUBSTRING(RAW_DAT,134,10),
  DOBMM = SUBSTRING(RAW_DAT,144,2),
  DOBDD = SUBSTRING(RAW_DAT,146,2),
  DOBCCYY = SUBSTRING(RAW_DAT,148,4),
  KLNK = SUBSTRING(RAW_DAT,152,15)
FROM
  T_KBM_PII_LKP_STG
;

/*
 * 05: QC.
 */
SELECT COUNT(1) FROM  T_KBM_PII_LKP;
SELECT TOP 10 * FROM  T_KBM_PII_LKP;

/*
 * 06: Create index for faster data load
 */
CREATE INDEX T_KBM_PII_LKP_KLNK_IDX   ON T_KBM_PII_LKP(KLNK);
CREATE INDEX T_KBM_PII_LKP_NONO2_IDX  ON T_KBM_PII_LKP(NONO2);
CREATE INDEX T_KBM_PII_LKP_LNAME_IDX  ON T_KBM_PII_LKP(LNAME);
