---- ---- ---- ----
-- Create table
Create Table xxx_xla_Sum_Log
(
  ORG_ID            NUMBER(15) NOT NULL,
  SOB_ID            NUMBER(15) NOT NULL,
  PD_NAME           VARCHAR2(15) NOT NULL,
  APPLICATION_ID    NUMBER(15) NOT NULL,
  CUR_CODE          VARCHAR2(15) NOT NULL,
  GCC_CCID          NUMBER(15) NOT NULL,
  PARTY_CODE        VARCHAR2(1),
  PARTY_ID          NUMBER(15),
  SITE_USE_ID       NUMBER(15),
  STATUS            VARCHAR2(1) NOT NULL,
  SC_MARK           VARCHAR2(1) NOT NULL,
  BALNC_START       NUMBER NOT NULL,
  BALNC_END         NUMBER NOT NULL,
  BALNC_ACCTD_START NUMBER NOT NULL,
  BALNC_ACCTD_END   NUMBER NOT NULL,
  ENTERED_DR        NUMBER NOT NULL,
  ENTERED_CR        NUMBER NOT NULL,
  ACCOUNTED_DR      NUMBER NOT NULL,
  ACCOUNTED_CR      NUMBER NOT NULL
)
TABLESPACE APPS_TS_TX_DATA
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
