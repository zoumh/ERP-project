Create Table xxx_STD_GL_Jmport_IFace as

---- ---- ---- ----
Create Table xxx_STD_GL_Jmport_IFace
(
  PERIOD_NAME           VARCHAR2(15) NOT NULL,
  ACCOUNTING_DATE       DATE NOT NULL,
  CURRENCY_CODE         VARCHAR2(15) NOT NULL,
  JOURNAL_BATCHNAME     VARCHAR2(233),
  JOURNAL_NAME          VARCHAR2(100),
  JOURNALLINE_NUMBER    NUMBER(15),
  CONCATENATED_SEGMENTS VARCHAR2(233),
  SEGMENT1              VARCHAR2(25),
  SEGMENT2              VARCHAR2(25),
  SEGMENT3              VARCHAR2(25),
  SEGMENT4              VARCHAR2(25),
  SEGMENT5              VARCHAR2(25),
  SEGMENT6              VARCHAR2(25),
  SEGMENT7              VARCHAR2(25),
  SEGMENT8              VARCHAR2(25),
  SEGMENT9              VARCHAR2(25),
  SEGMENT10             VARCHAR2(25),
  ENTERED_DR            NUMBER,
  ENTERED_CR            NUMBER,
  JOURNAL_LINE_DESC     VARCHAR2(240),
  XX_STATUS             VARCHAR2(1) NOT NULL
)
tablespace APPS_TS_TX_DATA
  pctfree 10
  initrans 1
  maxtrans 255;
