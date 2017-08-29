Create Table xxx_STD_AP_EmploiiSupp_iFaceH as 
select xxv.vendor_id,
       ppf.employee_number   Emploii_Number,
       ppf.last_name         Emploii_Name,
       ppf.person_id         Emploii_ID,
       xxv.Enable_Flag       Imported_Flag,
       ppf.created_by,
       ppf.creation_date,
       ppf.last_updated_by,
       ppf.last_update_date,
       ppf.last_update_login

  from xxx_STD_SupplierInfo_v xxv, per_people_f ppf
 where 1 = 2


Create Table xxx_STD_AP_EmploiiSupp_iFaceSi as 
select xxv.Org_ID,
       xxv.Vendor_ID,
       xxv.Vendor_SiteID,
       ppf.employee_number   Emploii_Number,
       ppf.last_name         Emploii_Name,
       ppf.person_id         Emploii_ID,
       xxv.VendorSite_Code VendorSite_Code,
       xxv.Enable_Flag       Imported_Flag,
       ppf.created_by,
       ppf.creation_date,
       ppf.last_updated_by,
       ppf.last_update_date,
       ppf.last_update_login

  from xxx_STD_SupplierInfo_v xxv, per_people_f ppf
 where 1 = 2


---- ---- ----
Create Table xxx_STD_AP_EmploiiSupp_iFaceH
(
  vendor_id         NUMBER not null,
  emploii_number    VARCHAR2(30),
  emploii_name      VARCHAR2(150) not null,
  emploii_id        NUMBER(10) not null,
  imported_flag     VARCHAR2(1) not null,
  created_by        NUMBER(15),
  creation_date     DATE,
  last_updated_by   NUMBER(15),
  last_update_date  DATE,
  last_update_login NUMBER(15)
)
tablespace APPS_TS_TX_DATA
  pctfree 10
  initrans 1
  maxtrans 255;
  
 ---- ---- ----
Create Table xxx_STD_AP_EmploiiSupp_iFaceSi
(
  org_id            NUMBER not null,
  vendor_id         NUMBER not null,
  vendor_siteid     NUMBER,
  emploii_number    VARCHAR2(30) not null,
  emploii_name      VARCHAR2(150) not null,
  emploii_id        NUMBER(10) not null,
  vendorsite_code   VARCHAR2(15) not null,
  imported_flag     VARCHAR2(1) not null,
  created_by        NUMBER(15) not null,
  creation_date     DATE not null,
  last_updated_by   NUMBER(15) not null,
  last_update_date  DATE not null,
  last_update_login NUMBER(15) not null
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
