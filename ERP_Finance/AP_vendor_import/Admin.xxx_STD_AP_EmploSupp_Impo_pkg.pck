CREATE OR REPLACE Package xxx_STD_AP_EmploSupp_Impo_pkg Is
  /*===============================================================
  *   Copyright (C)
  * ===============================================================
  *    Program Name:   xxx_STD_AP_EmploSupp_Impo_pkg
  *    Author      :   Doris ZOU
  *    Date        :   2013-02-28
  *    Purpose     :   Pl/Sql Html Report PKG
  *                    To Import the Emploii Supplier Auto.
  *
  *    Update History
  *    Version    Date          Name                              Description
  *    --------  ----------  ----------------------------------  --------------------
  *     V1.0     2013-02-28     Doris ZOU.         Creation
  *
    ===============================================================*/
  ----  ----
  type DCAmount is table Of Number index by binary_integer;
  type DCVarChar is table Of varchar2(100) index by binary_integer;

  /*===========================================================
  ---- Procedure Name:    xxxMain()
  ---- The Main Procedure Of This pkg.
  =============================================================*/
  Procedure xxxMain(P_msg_Data    Out Varchar2,
                    P_msg_Count   Out Number,
                    P_TPName      in varchar2,
                    P_vImpot_Mode Varchar2);

End xxx_STD_AP_EmploSupp_Impo_pkg;
/
CREATE OR REPLACE Package Body xxx_STD_AP_EmploSupp_Impo_pkg Is
  /*===============================================================
  *   Copyright (C) Doris ZOU. Consulting Co., Ltd All rights reserved
  * ===============================================================
  *    Program Name:   xxx_STD_AP_EmploSupp_Impo_pkg
  *    Author      :   Doris ZOU
  *    Date        :   2013-02-28
  *    Purpose     :   Pl/Sql Html Report PKG
  *                    To Import the Emploii Supplier Auto.
  *
  *    Update History
  *    Version    Date          Name                              Description
  *    --------  ----------  ----------------------------------  --------------------
  *     V1.0     2013-02-28     Doris ZOU.         Creation
  *
    ===============================================================*/
  ----  ----

  /*===========================================================
  ---- Procedure Name:    Print_Logs()
  ---- To Create the AR Print_Logs Finished Program.
  =============================================================*/
  Procedure Print_Logs(P_Logs In Varchar2) Is
  Begin
    fnd_file.put_line(fnd_file.log, P_Logs);
  End;
  /*===========================================================
  ---- Procedure Name:    Print_Output()
  =============================================================*/
  Procedure Print_Output(P_Output In Varchar2) Is
  
    L_HTM_BR varchar2(7) := '<BR>';
  
  Begin
    fnd_file.put_line(fnd_file.Output, L_HTM_BR || P_Output);
  End;

  /*===========================================================
  ---- Procedure Name:    Submit_Request()
  ---- To Submit The Request Program.
  =============================================================*/
  Procedure Submit_Request(P_Comcode      In Varchar2,
                           P_TPName       In Varchar2,
                           P_Rturn_Status OUT VARCHAR2,
                           P_msg_Data     OUT VARCHAR2,
                           P_Request_ID   OUT VARCHAR2) IS
  
    L_Request_ID Number;
    L_TPName     varchar2(7) := P_TPName;
  
  Begin
  
    L_Request_ID := fnd_request.submit_request(application => 'SQLGL',
                                               program     => 'PRINT_CFTOTAL',
                                               description => NULL,
                                               start_time  => to_char(SYSDATE,
                                                                      'YYYY/MM/DD HH24:MI:SS'),
                                               sub_request => FALSE,
                                               argument1   => P_Comcode,
                                               argument2   => L_TPName);
  
    if L_Request_ID <= 0 OR L_Request_ID IS NULL THEN
      P_Rturn_Status := fnd_api.g_ret_sts_error;
      P_msg_Data     := 'Failed the xxx_STD_GLCFlow.Print_CFTotal Triggered';
    else
      P_Rturn_Status := fnd_api.g_ret_sts_success;
      P_msg_Data     := 'xxx_STD_GLCFlow.Print_CFTotal Triggered SuccessFully.';
      P_Request_ID   := L_Request_ID;
    End If;
  
  End Submit_Request;

  /*===========================================================
  ---- Procedure Name:    Build_Emploii()
  ---- To Build The Emploii Data From The HRMS.
  =============================================================*/
  Procedure Build_Emploii(P_Start_Date Date, P_End_Date Date) is
  
    L_Start_Date      Date;
    L_End_Date        Date;
    L_Imported_Flag   varchar2(2) := 'I';
    L_Vendor_ID       Number := -9999;
    L_Imported_Number Number := 0;
  
    Cursor Emploii(P_Start_Date Date, P_End_Date Date) is
      select ppf.employee_number, ppf.last_name, ppf.person_id
        from per_people_f ppf, per_person_types ppt
       where ppf.person_type_id = ppt.person_type_id
         and ppt.system_person_type = 'EMP'
         and ppf.Creation_date >= P_Start_Date
         and ppf.Creation_date < = P_End_Date
         and ppf.effective_start_date <= SYSDATE
         and SYSDATE < ppf.effective_end_date
         and NOT Exists (select 1
                from xxx_STD_AP_EmploiiSupp_iFaceH iH
               where iH.Emploii_Id = ppf.person_id);
  Begin
  
    L_Start_Date := P_Start_Date;
    L_End_Date   := P_End_Date;
  
    Delete from xxx_STD_AP_EmploiiSupp_iFaceH iD
     where (iD.Vendor_ID = L_Vendor_ID Or
           iD.Imported_Flag = L_Imported_Flag);
    Commit;
  
    For iii in Emploii(L_Start_Date, L_End_Date) Loop
    
      insert into xxx_STD_AP_EmploiiSupp_iFaceH
        select L_Vendor_ID,
               iii.employee_number,
               iii.last_name,
               iii.person_id,
               L_Imported_Flag,
               
               fnd_global.user_id,
               SYSDATE,
               fnd_global.user_id,
               SYSDATE,
               fnd_global.login_id
          from dual;
      L_Imported_Number := L_Imported_Number + 1;
    End Loop;
    Commit;
  
    dbms_output.put_line('L_Imported_Num:' || L_Imported_Number);
    Print_Logs('L_Imported_Num:' || L_Imported_Number);
    Print_Output('L_Imported_Num:' || L_Imported_Number);
  
  End Build_Emploii;

  /*===========================================================
  ---- Procedure Name:    Build_EmploiiSite()
  ---- To Build The EmploiiSite Data From The HRMS.
  =============================================================*/
  Procedure Build_EmploiiSite(P_Org_ID In Number) is
  
    L_Org_ID          Number;
    L_VendorSite_Code Varchar2(20);
    Cursor EVendorSite(P_Org_ID In Number, P_VendorSite_Code in Varchar2) is
      select *
        from xxx_STD_AP_EmploiiSupp_iFaceH iH
       where NOT Exists
       (Select 1
                from xxx_STD_SupplierInfo_v xv
               where xv.org_id = P_Org_ID
                 and xv.vendor_id = iH.Vendor_ID
                 and xv.VendorSite_Code = P_VendorSite_Code);
  
    L_Imported_Flag varchar2(2) := 'I';
    L_VendorSite_ID Number := -9999;
    L_Expense_CodeA Varchar2(10) := 'HOME';
    L_Expense_CodeB Varchar2(10) := 'OFFICE';
  
  Begin
    L_Org_ID := P_Org_ID;
    select Decode(fpp.exclusive_payment_flag,
                  'H',
                  L_Expense_CodeA,
                  'O',
                  L_Expense_CodeB,
                  L_Expense_CodeA)
      into L_VendorSite_Code
      from financials_system_params_all fpp
     where fpp.ORG_ID = L_Org_ID;
  
    Delete from xxx_STD_AP_EmploiiSupp_iFaceSi Si
     where Si.Org_ID = L_Org_ID
       and (Si.Imported_Flag = L_Imported_Flag Or
           Si.Vendor_SiteID = L_VendorSite_ID);
    Commit;
  
    For xxx in EVendorSite(L_Org_ID, L_VendorSite_Code) Loop
      insert into xxx_STD_AP_EmploiiSupp_iFaceSi
        select L_Org_ID,
               xxx.Vendor_ID,
               L_VendorSite_ID,
               xxx.Emploii_Number,
               xxx.Emploii_Name,
               xxx.Emploii_ID,
               L_VendorSite_Code,
               L_Imported_Flag,
               
               fnd_global.user_id,
               SYSDATE,
               fnd_global.user_id,
               SYSDATE,
               fnd_global.login_id
        
          from Dual;
    End Loop;
  
    Commit;
  
  End Build_EmploiiSite;

  /*===========================================================
  ---- Procedure Name:    EmploiiSupH_Import()
  ---- To Imported the Emploii Supplier Header Info.
  ----P_Rturn_Status OUT Varchar2,
  ----P_msg_Count    OUT Number,
  ----P_msg_Data     OUT Varchar2
  =============================================================*/
  Procedure EmploiiSup_iFace(P_Org_ID in Number) is
  
  Begin
  
    Commit;
  
  End EmploiiSup_iFace;
  /*===========================================================
  ---- Procedure Name:    EmploiiSupH_Import()
  ---- To Imported the Emploii Supplier Header Info.
  ----P_Rturn_Status OUT Varchar2,
  ----P_msg_Count    OUT Number,
  ----P_msg_Data     OUT Varchar2
  =============================================================*/
  Procedure EmploiiSupH_Import is
  
    Cursor EmploiiSupH is
      select *
        from xxx_STD_AP_EmploiiSupp_iFaceH iH
       where iH.Vendor_ID = -9999
         and iH.Imported_Flag = 'I'
         and NOT Exists (select 1
                from xxx_STD_SupplierInfo_v iiv
               where iH.Emploii_ID = iiv.Emploii_ID)
         For Update Of iH.Vendor_ID, iH.Imported_Flag;
  
    L_Vendor_ID         Number;
    L_Party_ID          Number;
    L_Vendor_Num        Varchar2(50);
    L_Vendor_Name       Varchar2(100);
    L_PMTTerms_ID       Number := 10020;
    L_Vendor_LookupCode varchar2(20) := 'EMPLOYEE';
    L_Conn_Char         varchar2(5) := '-';
    L_Emploii_ID        Number;
    L_Appd_ID           Number := fnd_global.resp_appl_id;
    L_ProgAppd_ID       number := fnd_global.prog_appl_id;
    L_Request_ID        Number := fnd_global.conc_request_id;
    L_Program_ID        Number := fnd_global.conc_program_id;
  
    L_PAYMent_LookUpCode  Varchar2(10) := 'PG000000';
    L_WithHoldTax_Flag    varchar2(5) := 'Y';
    L_WithHoldTax_GroupID number := 10001;
  
    L_Return_Status Varchar2(10);
    L_msg_Data      Varchar2(5000);
    L_msg_Count     Number;
  
    L_Vendor_Rec ap_vendor_pub_pkg.r_vendor_rec_type;
  
  Begin
  
    For HHi in EmploiiSupH Loop
      L_Emploii_ID  := HHi.Emploii_ID;
      L_Vendor_Name := HHi.Emploii_ID || L_Conn_Char || HHi.Emploii_Name;
      ---- ---- ---- ----Parameter
      L_Vendor_ID     := Null;
      L_Party_ID      := Null;
      L_msg_Data      := Null;
      L_Return_Status := fnd_api.g_ret_sts_success;
    
      ---- ---- ---- ----
      L_Vendor_Rec                         := NULL;
      L_Vendor_Rec.vendor_id               := L_Vendor_ID;
      L_Vendor_Rec.employee_id             := L_Emploii_ID;
      L_Vendor_Rec.segment1                := L_Vendor_Num;
      L_Vendor_Rec.vendor_name             := L_Vendor_Name;
      L_Vendor_Rec.vendor_name_alt         := L_Vendor_Name;
      L_Vendor_Rec.vendor_type_lookup_code := L_Vendor_LookupCode;
      L_Vendor_Rec.terms_id                := L_PMTTerms_ID;
    
      L_Vendor_Rec.vat_registration_num := L_Vendor_Name;
    
      L_Vendor_Rec.pay_group_lookup_code := L_PAYMent_LookUpCode;
      L_Vendor_Rec.allow_awt_flag        := L_WithHoldTax_Flag;
      L_Vendor_Rec.awt_group_id          := L_WithHoldTax_GroupID;
    
      ap_vendor_pub_pkg.create_vendor(p_vendor_rec => L_Vendor_Rec,
                                      
                                      p_api_version      => 1.0,
                                      p_init_msg_list    => fnd_api.g_true,
                                      p_commit           => fnd_api.g_false,
                                      p_validation_level => fnd_api.g_valid_level_full,
                                      x_return_status    => L_Return_Status,
                                      x_msg_count        => L_msg_Count,
                                      x_msg_data         => L_msg_Data,
                                      x_vendor_id        => L_Vendor_ID,
                                      x_party_id         => L_Party_ID);
    
      /*ap_vendors_pkg.Insert_Row(p_vendor_rec => L_Vendor_Rec,
      
      p_created_by        => fnd_global.USER_ID,
      p_creation_date     => SYSDATE,
      p_last_updated_by   => fnd_global.USER_ID,
      p_last_update_date  => SYSDATE,
      p_last_update_login => fnd_global.LOGIN_ID,
      
      p_request_id             => L_Request_ID,
      p_program_application_id => L_Appd_ID,
      p_program_id             => L_Program_ID,
      p_program_update_date    => SYSDATE,
      
      x_rowid     => L_RowID,
      x_vendor_id => L_Vendor_ID);*/
    
      If L_Return_Status = fnd_api.g_ret_sts_success Then
        Update xxx_STD_AP_EmploiiSupp_iFaceH xxx
           Set xxx.vendor_id = L_Vendor_ID, xxx.imported_flag = 'Y'
         where Current of EmploiiSupH;
      End if;
    
      If L_Return_Status <> fnd_api.g_ret_sts_success Then
        For i In 1 .. L_msg_Count LOOP
          L_msg_Data := 'AutoCreated SupplierE:';
          L_msg_Data := L_msg_Data || fnd_msg_pub.get_detail(i, 'F');
        END LOOP;
        dbms_output.put_line('L_Return_Status:' || L_Return_Status);
        Print_Logs('L_Return_Status:' || L_Return_Status);
        Print_Output('L_Return_Status:' || L_Return_Status);
        dbms_output.put_line('L_msg_Count:' || L_msg_Count);
        Print_Logs('L_msg_Count:' || L_msg_Count);
        Print_Output('L_msg_Count:' || L_msg_Count);
        dbms_output.put_line('L_msg_Data:' || L_msg_Data);
        Print_Logs('L_msg_Data:' || L_msg_Data);
        Print_Output('L_msg_Data:' || L_msg_Data);
      End if;
    
    End Loop;
    Commit;
  
  End EmploiiSupH_Import;

  /*===========================================================
  ---- Procedure Name:    EmploiiSupSite_Import()
  ---- To Imported the Emploii Supplier Site Info.
  =============================================================*/
  Procedure EmploiiSupSite_Import(P_Org_ID in Number) is
  
    Cursor EmploiiSupiS(P_Org_ID in Number) is
      select *
        from xxx_STD_AP_EmploiiSupp_iFaceSi Si
       where Si.Vendor_SiteID = -9999
         and Si.Imported_Flag = 'I'
         and Si.Org_ID = P_Org_ID
      /* and NOT Exists (select 1
       from xxx_STD_SupplierInfo_v iiv
      where Si.Emploii_ID = iiv.Emploii_ID
        and Si.Org_ID = iiv.Org_ID)*/
         For Update Of Si.Vendor_SiteID, Si.Imported_Flag;
  
    L_Org_ID        Number;
    L_Conn_Char     varchar2(5) := '-';
    L_Emploii_ID    Number;
    L_Vendor_ID     Number;
    L_VendorSite_ID Number;
    L_PartySite_ID  Number;
    L_Locations_ID  Number;
  
    L_AcctsPAY_CCID       Number;
    L_AcctsPrePAY_CCID    Number;
    L_AcctsFuturePAY_CCID Number;
    L_PMTTerms_ID         Number := 10020;
    L_Vatxxx_Num          varchar2(30);
    L_VendorSite_Code     varchar2(50);
    L_POY_Falg            varchar2(2) := 'Y';
    L_PON_Falg            varchar2(2) := 'N';
  
    L_PAYMent_LookUpCode       Varchar2(10) := 'PG000000';
    L_PAYDate_Basis_LookUpCode varchar2(10) := 'DISCOUNT';
    L_PAYMethod_LookUpCode     varchar2(10) := 'CHECK';
    L_WithHoldTax_Flag         varchar2(5) := 'Y';
    L_WithHoldTax_GroupID      number := 10001;
    L_Adress_STYLE             varchar2(50) := 'POSTAL_ADDR_US';
    L_Adress_LineA             varchar2(50) := 'AutoSite:';
    L_Adress_COUNTRY           varchar2(5) := 'US';
    L_Adress_STATE             varchar2(5) := 'CA';
    L_Adress_CITY              varchar2(15) := 'Shenzhen';
  
    L_Appd_ID     Number := fnd_global.resp_appl_id;
    L_ProgAppd_ID number := fnd_global.prog_appl_id;
    L_Request_ID  Number := fnd_global.conc_request_id;
    L_Program_ID  Number := fnd_global.conc_program_id;
  
    L_Return_Status Varchar2(10);
    L_msg_Data      Varchar2(5000);
    L_msg_Count     Number;
  
    L_Vendorsite_Rec ap_vendor_pub_pkg.r_vendor_site_rec_type;
  
  Begin
  
    L_Org_ID := P_Org_ID;
    For iSite in EmploiiSupiS(L_Org_ID) Loop
      L_VendorSite_ID   := Null;
      L_Locations_ID    := Null;
      L_PartySite_ID    := Null;
      L_Vendor_ID       := iSite.Vendor_ID;
      L_Vatxxx_Num      := to_Char(SYSTIMESTAMP, 'YYYYMMDDHH24MISSFF3');
      L_VendorSite_Code := iSite.VendorSite_Code;
      L_msg_Data        := Null;
      L_Return_Status   := fnd_api.g_ret_sts_success;
    
      ---- ---- ---- ----
      L_Vendorsite_Rec                            := Null;
      L_Vendorsite_Rec.vendor_id                  := L_Vendor_ID;
      L_Vendorsite_Rec.org_id                     := L_Org_ID;
      L_Vendorsite_Rec.party_site_id              := L_PartySite_ID;
      L_Vendorsite_Rec.location_id                := L_Locations_ID;
      L_Vendorsite_Rec.vendor_site_code           := L_VendorSite_Code;
      L_Vendorsite_Rec.pay_group_lookup_code      := L_PAYMent_LookUpCode;
      L_Vendorsite_Rec.pay_date_basis_lookup_code := L_PAYDate_Basis_LookUpCode;
      L_Vendorsite_Rec.allow_awt_flag             := L_WithHoldTax_Flag;
      L_Vendorsite_Rec.awt_group_id               := L_WithHoldTax_GroupID;
    
      L_Vendorsite_Rec.address_style := L_Adress_STYLE;
      L_Vendorsite_Rec.address_line1 := L_Adress_LineA || L_Vatxxx_Num;
      L_Vendorsite_Rec.COUNTRY       := L_Adress_COUNTRY;
      L_Vendorsite_Rec.STATE         := L_Adress_STATE;
      L_Vendorsite_Rec.CITY          := L_Adress_CITY;
    
      L_Vendorsite_Rec.accts_pay_code_combination_id := L_AcctsPAY_CCID;
      L_Vendorsite_Rec.prepay_code_combination_id    := L_AcctsPrePAY_CCID;
      L_Vendorsite_Rec.future_dated_payment_ccid     := L_AcctsFuturePAY_CCID;
      L_Vendorsite_Rec.terms_id                      := L_PMTTerms_ID;
      L_Vendorsite_Rec.purchasing_site_flag          := L_POY_Falg;
      L_Vendorsite_Rec.pay_site_flag                 := L_POY_Falg;
      L_Vendorsite_Rec.rfq_only_site_flag            := L_PON_Falg;
      L_Vendorsite_Rec.vat_registration_num          := L_Vatxxx_Num;
    
      ---- ---- ---- Trigger the Standard API For Vendor Site Ipmorting.
      ap_vendor_pub_pkg.create_vendor_site(p_api_version      => 1.0,
                                           p_init_msg_list    => fnd_api.g_true,
                                           p_commit           => fnd_api.g_false,
                                           p_validation_level => fnd_api.g_valid_level_full,
                                           
                                           p_vendor_site_rec => L_Vendorsite_Rec,
                                           x_vendor_site_id  => L_VendorSite_ID,
                                           x_party_site_id   => L_PartySite_ID,
                                           x_location_id     => L_Locations_ID,
                                           
                                           x_return_status => L_Return_Status,
                                           x_msg_count     => L_msg_Count,
                                           x_msg_data      => L_msg_Data);
    
      If L_Return_Status = fnd_api.g_ret_sts_success Then
        Update xxx_STD_AP_EmploiiSupp_iFaceSi xxx
           Set xxx.vendor_siteid = L_VendorSite_ID, xxx.imported_flag = 'Y'
         where Current of EmploiiSupiS;
      End if;
    
      If L_Return_Status <> fnd_api.g_ret_sts_success Then
        For i In 1 .. L_msg_Count LOOP
          L_msg_Data := 'AutoCreated SupplierSiteE:';
          L_msg_Data := L_msg_Data || fnd_msg_pub.get_detail(i, 'F');
        END LOOP;
        dbms_output.put_line('L_Return_Status:' || L_Return_Status);
        Print_Logs('L_Return_Status:' || L_Return_Status);
        Print_Output('L_Return_Status:' || L_Return_Status);
        dbms_output.put_line('L_msg_Count:' || L_msg_Count);
        Print_Logs('L_msg_Count:' || L_msg_Count);
        Print_Output('L_msg_Count:' || L_msg_Count);
        dbms_output.put_line('L_msg_Data:' || L_msg_Data);
        Print_Logs('L_msg_Data:' || L_msg_Data);
        Print_Output('L_msg_Data:' || L_msg_Data);
      End if;
    End Loop;
    Commit;
  
  End EmploiiSupSite_Import;

  /*===========================================================
  ---- Procedure Name:    xxxMain()
  ---- The Main Procedure Of This pkg.
  =============================================================*/
  Procedure xxxMain(P_msg_Data    Out Varchar2,
                    P_msg_Count   Out Number,
                    P_TPName      in varchar2,
                    P_vImpot_Mode Varchar2) is
  
    x_msg_Data     varchar2(1000);
    x_Rturn_Status varchar2(2);
    x_Request_ID   Number;
  
    L_Org_ID     Number;
    L_TPName     varchar2(7) := P_TPName;
    L_Start_Date Date;
    L_End_Date   Date;
  
    L_vImpot_ModeA varchar2(2) := 'A';
    L_vImpot_ModeI varchar2(2) := 'I';
    L_vImpot_Mode  varchar2(2) := P_vImpot_Mode;
  
  Begin
  
    ---- ---- ---- ---- Get the Org_ID
    L_Org_ID := fnd_global.Org_ID;
  
    if L_Org_ID is Null Then
      Print_Output('PLS Set the OU Of the Profile!');
    End if;
    ---- ---- ---- ---- The Other Operations Defined Here Starting.
    select min(gdd.accounting_date), max(gdd.accounting_date)
      into L_Start_Date, L_End_Date
      from gl_ledgers gll, gl_date_period_map gdd
     where gll.ledger_id = fnd_profile.value('GL_SET_OF_BKS_ID')
       and gdd.period_set_name = gll.period_set_name
       and gdd.period_name = L_TPName;
    ---- ---- ---- ----
    Build_Emploii(L_Start_Date, L_End_Date);
    if L_vImpot_Mode = L_vImpot_ModeA Then
      EmploiiSupH_Import;
      Build_EmploiiSite(L_Org_ID);
      EmploiiSupSite_Import(L_Org_ID);
    End if;
    if L_vImpot_Mode = L_vImpot_ModeI Then
      EmploiiSup_iFace(L_Org_ID);
    End if;
    ---- ---- ---- ----
  
  End xxxMain;

End xxx_STD_AP_EmploSupp_Impo_pkg;
/
