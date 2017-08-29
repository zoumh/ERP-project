
---- ---- ----
-- Create Sequence 
Create Sequence xxx_PMTSelect_s
minvalue 1
maxvalue 9999999999
start with 10000
increment by 1
cache 10;

Create Sequence xxx_BatchID_s
minvalue 1
maxvalue 9999999999
start with 10000
increment by 1
cache 10;

---- ---- ----
---- ---- ---- Create table xxx_ap_AutoPMTs_iFace
Create Table xxx_ap_AutoPMTs_iFace
(
  BATCH_ID            NUMBER(15)NULL,
  BATCH_NUMBER        NUMBER(15) NOT NULL,
  ORG_ID              NUMBER(15) NOT NULL,
  COM_CODE            VARCHAR2(8) NOT NULL,
  ORG_NAME            VARCHAR2(240) NOT NULL,
  PMT_TYPE            VARCHAR2(8) NOT NULL,
  VENDOR_NAME         VARCHAR2(240) NOT NULL,
  VENDOR_NUMBER       VARCHAR2(30) NOT NULL,
  VENDOR_SITE_CODE    VARCHAR2(15) NOT NULL,
  PMT_DATE            DATE NOT NULL,
  FUTUREPMT_DUEDATE DATE,
  PMT_CURR            VARCHAR2(15) NOT NULL,
  PMT_AMOUNT          NUMBER NOT NULL,
  BANK_ACCOUNT_NAME   VARCHAR2(80) NOT NULL,
  BANK_ACCOUNT_NUMBER VARCHAR2(30) NOT NULL,
  PMT_METHOD          VARCHAR2(30) NOT NULL,
  PMT_DOC             VARCHAR2(30) NOT NULL,
  PMT_PROFILE         VARCHAR2(100),
  CHECK_NUM           NUMBER(15),
  INVOICE_NUM         VARCHAR2(50),
  PMTINV_AMOUNT       NUMBER,
  IMPORTED_STATUS     VARCHAR2(1) NOT NULL
)
tablespace APPS_TS_TX_DATA
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 128K
    next 128K
    minextents 1
    maxextents unlimited
    pctincrease 0
  );

---- ---- ---- Create table xxx_ap_AutoPMTs_selected
Create table xxx_ap_AutoPMTs_selected
(
  BATCH_ID            NUMBER(15) NOT NULL,
  BATCH_NUMBER        NUMBER(15) NOT NULL,
  ORG_ID              NUMBER(15) NOT NULL,
  COM_CODE            VARCHAR2(8) NOT NULL,
  PMTSELECT_ID        NUMBER(15) NOT NULL,
  ORG_NAME            VARCHAR2(240) NOT NULL,
  PMT_TYPE            VARCHAR2(8) NOT NULL,
  PMT_MODE VARCHAR2(4) NOT NULL,
  PERIOD_NAME         VARCHAR2(15) NOT NULL,
  VENDOR_NAME         VARCHAR2(240) NOT NULL,
  VENDOR_NUMBER       VARCHAR2(30) NOT NULL,
  VENDOR_SITE_CODE    VARCHAR2(15) NOT NULL,
  VENDOR_ID           NUMBER NOT NULL,
  VENDOR_SITE_ID      NUMBER NOT NULL,
  PMT_DATE            DATE NOT NULL,
  FUTUREPMT_DUEDATE DATE,
  PMT_CURR            VARCHAR2(15) NOT NULL,
  PMT_AMOUNT          NUMBER NOT NULL,
  BANK_ACCOUNT_NAME   VARCHAR2(80) NOT NULL,
  BANK_ACCOUNT_NUMBER VARCHAR2(30) NOT NULL,
  PMT_METHOD          VARCHAR2(30) NOT NULL,
  PMT_DOC             VARCHAR2(30) NOT NULL,
  PMT_PROFILE         VARCHAR2(100),
  CHECK_NUM           NUMBER(15) NOT NULL,
  CHECK_XNUM           NUMBER(15) NOT NULL,
  CHECK_ID            NUMBER(15),
  PMT_STATUS          VARCHAR2(1) NOT NULL,
  CREATED_BY          NUMBER(15) NOT NULL,
  CREATION_DATE       DATE NOT NULL,
  LAST_UPDATED_BY     NUMBER(15) NOT NULL,
  LAST_UPDATE_DATE    DATE NOT NULL,
  LAST_UPDATE_LOGIN   NUMBER(15) NOT NULL
)
tablespace APPS_TS_TX_DATA
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 128K
    next 128K
    minextents 1
    maxextents unlimited
    pctincrease 0
  );
---- ---- ---- xxx_ap_AutoInvs_selected
Create table xxx_ap_AutoInvs_selected
(
  BATCH_ID          NUMBER(15) NOT NULL,
  ORG_ID            NUMBER(15) NOT NULL,
  PMTSELECT_ID      NUMBER(15) NOT NULL,
  PERIOD_NAME       VARCHAR2(15) NOT NULL,
  VENDOR_ID         NUMBER NOT NULL,
  VENDOR_SITE_ID    NUMBER NOT NULL,
  CHECK_NUM         NUMBER(15) NOT NULL,
  CHECK_XNUM           NUMBER(15) NOT NULL, 
  INVOICE_NUM       VARCHAR2(50) NOT NULL,
  INV_CATE          VARCHAR2(25) NOT NULL,
  INVOICE_ID        NUMBER(15) NOT NULL,
  PMT_METHOD        VARCHAR2(30) NOT NULL,
  INV_CURR          VARCHAR2(15) NOT NULL,
  PMT_AMOUNT        NUMBER NOT NULL,
  PMTINV_AMOUNT     NUMBER NOT NULL,
  INV_AMOUNT        NUMBER NOT NULL,
  AMOUNT_PAID       NUMBER NOT NULL,
  REMAINING_AMOUNT  NUMBER NOT NULL,
  PMT_MODE VARCHAR2(4) NOT NULL,
  PMT_STATUS        VARCHAR2(1) NOT NULL,
  CREATED_BY        NUMBER(15) NOT NULL,
  CREATION_DATE     DATE NOT NULL,
  LAST_UPDATED_BY   NUMBER(15) NOT NULL,
  LAST_UPDATE_DATE  DATE NOT NULL,
  LAST_UPDATE_LOGIN NUMBER(15) NOT NULL
)
tablespace APPS_TS_TX_DATA
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 128K
    next 128K
    minextents 1
    maxextents unlimited
    pctincrease 0
  );


---- ---- ---- View xxx_PMTselected_v
Create Or Replace view xxx_PMTselected_v as
select distinct xxx.batch_number,
                xxx.org_id,
                xxx.Com_Code,
                xxx.Org_Name,
                xxx.PMT_TYPE,
                xxx.vendor_name,
                xxx.vendor_number,
                xxx.vendor_site_code,
                xxx.PMT_Date,
                xxx.PMT_Curr,
                xxx.PMT_Amount,
                xxx.bank_account_name,
                xxx.bank_account_number,
                xxx.PMT_METHOD,
                xxx.PMT_Doc,
                xxx.PMT_Profile,
                xxx.Check_Num,
                xxx.imported_status
  from xxx_ap_AutoPMTs_iFace xxx
 where xxx.imported_status = 'I';
