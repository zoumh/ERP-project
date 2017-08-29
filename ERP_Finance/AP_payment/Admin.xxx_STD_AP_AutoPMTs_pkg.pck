CREATE OR REPLACE Package xxx_STD_AP_AutoPMTs_pkg Is
  /*===============================================================
  *   Copyright (C) 
  * ===============================================================
  *    Program Name:   xxx_STD_AP_AutoPMTs_pkg
  *    Author      :   Doris ZOU
  *    Date        :   2013-02-28
  *    Purpose     :   Pl/Sql Html Report PKG
  *                    To Aotu PMTs The Invoiis.
  *
  *    Update History
  *    Version    Date          Name                              Description
  *    --------  ----------  ----------------------------------  --------------------
  *     V1.0     2013-02-28     Doris ZOU.         Creation
  *
    ===============================================================*/
  ----  ----
  P_FULLPMT_DFlag varchar2(2) := 'P';
  L_Check_PName   varchar2(50) := 'AutoPMTs@Doris.Com:';

  L_Check_Auto_PPMTs  varchar2(30) := 'Auto_PPMTs*';
  L_Check_Auto_FOPMTs varchar2(30) := 'Auto_FOPMTs*';
  L_Check_Auto_FMPMTs varchar2(30) := 'Auto_FMPMTs*';

  P_PMTsTii_FlagM varchar2(2) := 'M';
  P_PMTsTii_FlagQ varchar2(2) := 'Q';
  P_PMTsTii_FlagR varchar2(2) := 'R';

  type DCAmount is table Of Number index by binary_integer;
  type DCVarChar is table Of varchar2(30000) index by binary_integer;

  P_CPMTsLookup_Code varchar2(20) := 'NEGOTIABLE';
  P_WPMTsLookup_Code varchar2(20) := 'ISSUED';

  P_STDInvoii_Status varchar2(20) := 'APPROVED';
  P_PREInvoii_Status varchar2(20) := 'UNPAID';
  /*===========================================================
  ---- Function Name:    get_BankUseID()
  ---- To get the BankUseID.
  =============================================================*/
  Function get_BankUseID(P_Org_ID in Number, P_BankAcc_Number in varchar2)
    Return Number;

  /*===========================================================
  ---- Function Name:    get_BankAccID()
  ---- To get the get_BankAccID.
  =============================================================*/
  Function get_BankAccID(P_Org_ID in Number, P_BankAcc_Number in varchar2)
    Return Number;

  /*===========================================================
  ---- Function Name:    get_BankDocID()
  ---- To get the get_BankDocID.
  =============================================================*/
  Function get_BankDocID(P_BankAcc_ID   in Number,
                         P_BankDoc_Name in varchar2) Return Number;

  /*===========================================================
  ---- Function Name:    get_xxxRate()
  ---- To get the get_xxxRate.
  =============================================================*/
  Function get_xxxRate(P_From_Curr       in varchar2,
                       P_To_Curr         in varchar2,
                       P_xRate_Ti        varchar2,
                       P_Accounting_Date in Date) Return Number;

  /*===========================================================
  ---- Procedure Name:    Build_PMTISs()
  ---- To Build the PMTs Of The Details.
  =============================================================*/
  Procedure Build_PMTISs(P_Batch_ID Out Number,
                         P_Org_ID   in Number,
                         P_TPName   in varchar2,
                         P_PMT_Mode in varchar2);

  /*===========================================================
  ---- Procedure Name:    Build_InvISs()
  ---- To Build the Invoices Need to Be Paid Of The Details.
  =============================================================*/
  Procedure Build_InvISs(P_Batch_ID In Number,
                         P_Org_ID   In Number,
                         P_TPName   in varchar2,
                         P_PMT_Mode in varchar2);

  /*===========================================================
  ---- Procedure Name:    Auto_PPMTs()
  =============================================================*/
  Procedure Auto_PPMTs(P_Suc_Flag Out Varchar2,
                       P_Suc_Log  Out Varchar2,
                       P_Batch_ID in Number,
                       P_Org_ID   In Number,
                       P_TPName   in varchar2,
                       P_PMT_Mode in varchar2);

  /*===========================================================
  ---- Procedure Name:    Auto_FOPMTs() Of FullPMTs. For One Installment
  =============================================================*/
  Procedure Auto_FOPMTs(P_Suc_Flag Out Varchar2,
                        P_Suc_Log  Out Varchar2,
                        P_Batch_ID In Number,
                        P_Org_ID   In Number,
                        P_TPName   in varchar2,
                        P_PMT_Mode in varchar2);

  /*===========================================================
  ---- Procedure Name:    xxxMain()
  ---- The Main Procedure Of This pkg.
  =============================================================*/
  Procedure xxxMain(P_Suc_Flag     Out Varchar2,
                    P_Suc_Log      Out Varchar2,
                    P_Org_ID       in Number,
                    P_TPName       in varchar2,
                    P_PMT_Mode     in varchar2,
                    P_FULLPMT_Flag in varchar2 Default P_FULLPMT_DFlag);

End xxx_STD_AP_AutoPMTs_pkg;
/
CREATE OR REPLACE Package Body xxx_STD_AP_AutoPMTs_pkg Is
  /*===============================================================
  *   Copyright (C) Doris ZOU. Consulting Co., Ltd All rights reserved
  * ===============================================================
  *    Program Name:   xxx_STD_AP_AutoPMTs_pkg
  *    Author      :   Doris ZOU
  *    Date        :   2013-02-28
  *    Purpose     :   Pl/Sql Html Report PKG
  *                    To Aotu PMTs The Invoiis.
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
  
  Begin
    fnd_file.put_line(fnd_file.output, P_Output);
  End;

  /*===========================================================
  ---- Procedure Name:    Submit_Request()
  ---- To Submit The Request Program.
  =============================================================*/
  Procedure Submit_Request(P_TPName       In Varchar2,
                           P_Rturn_Status OUT VARCHAR2,
                           P_msg_Data     OUT VARCHAR2,
                           P_Request_ID   OUT VARCHAR2) IS
  
    L_Request_ID Number;
    L_TPName     varchar2(7) := P_TPName;
  
  Begin
  
    L_Request_ID := fnd_request.submit_request(application => 'SQLAP',
                                               program     => 'AutoPMTs',
                                               description => NULL,
                                               start_time  => to_char(SYSDATE,
                                                                      'YYYY/MM/DD HH24:MI:SS'),
                                               sub_request => FALSE,
                                               argument1   => L_TPName);
  
    if L_Request_ID <= 0 OR L_Request_ID IS NULL THEN
      P_Rturn_Status := fnd_api.g_ret_sts_error;
      P_msg_Data     := 'Failed the xxx_STD_AutoPMTs Triggered';
    else
      P_Rturn_Status := fnd_api.g_ret_sts_success;
      P_msg_Data     := 'xxx_STD_AutoPMTs Triggered SuccessFully.';
      P_Request_ID   := L_Request_ID;
    End If;
  
  End Submit_Request;

  /*===========================================================
  ---- Function Name:    get_BankUseID()
  ---- To get the BankUseID.
  =============================================================*/
  Function get_BankUseID(P_Org_ID in Number, P_BankAcc_Number in varchar2)
    Return Number is
  
    L_Org_ID         Number;
    L_BankAcc_Number varchar2(50);
    L_xxx_BankUseID  Number;
  
  Begin
    L_Org_ID         := P_Org_ID;
    L_BankAcc_Number := P_BankAcc_Number;
  
    Begin
      select x.bank_acct_use_id
        into L_xxx_BankUseID
        from xxx_STD_CE_BankInfo_v x
       where x.org_id = L_Org_ID
         and x.bank_account_num = L_BankAcc_Number
         and nvl(x.bank_end_date, SYSDATE + 1) > SYSDATE;
    
    EXCEPTION
      WHEN OTHERS THEN
        Print_Output('The L_xxx_BankUseID of L_BankAcc_Number is Not Exsited Or Double!');
        Print_Logs('The L_xxx_BankUseID of L_BankAcc_Number is Not Exsited Or Double!!');
        L_xxx_BankUseID := -9999;
    END;
  
    Return(L_xxx_BankUseID);
  
  End get_BankUseID;

  /*===========================================================
  ---- Function Name:    get_BankAccID()
  ---- To get the get_BankAccID.
  =============================================================*/
  Function get_BankAccID(P_Org_ID in Number, P_BankAcc_Number in varchar2)
    Return Number is
  
    L_Org_ID         Number;
    L_BankAcc_Number varchar2(50);
    L_xxx_BankAccID  Number;
  
  Begin
    L_Org_ID         := P_Org_ID;
    L_BankAcc_Number := P_BankAcc_Number;
  
    Begin
      select x.bank_account_id
        into L_xxx_BankAccID
        from xxx_STD_CE_BankInfo_v x
       where x.org_id = L_Org_ID
         and x.bank_account_num = L_BankAcc_Number
         and nvl(x.bank_end_date, SYSDATE + 1) > SYSDATE;
    
    EXCEPTION
      WHEN OTHERS THEN
        Print_Output('The L_xxx_BankAccID of L_BankAcc_Number is Not Exsited Or Double!');
        Print_Logs('The L_xxx_BankAccID of L_BankAcc_Number is Not Exsited Or Double!!');
        L_xxx_BankAccID := -9999;
    END;
  
    Return(L_xxx_BankAccID);
  
  End get_BankAccID;

  /*===========================================================
  ---- Function Name:    get_BankDocID()
  ---- To get the get_BankDocID.
  =============================================================*/
  Function get_BankDocID(P_BankAcc_ID   in Number,
                         P_BankDoc_Name in varchar2) Return Number is
  
    L_BankAcc_ID    Number;
    L_BankDoc_Name  varchar2(100);
    L_xxx_BankDocID Number;
  
  Begin
    L_BankAcc_ID   := P_BankAcc_ID;
    L_BankDoc_Name := P_BankDoc_Name;
  
    Begin
      select x.payment_document_id
        into L_xxx_BankDocID
        from ce_payment_documents x
       where x.internal_bank_account_id = L_BankAcc_ID
         and Upper(x.payment_document_name) = Upper(L_BankDoc_Name)
         and nvl(x.inactive_date, SYSDATE + 1) > SYSDATE;
    
    EXCEPTION
      WHEN OTHERS THEN
        Print_Output('The L_xxx_BankDocID of L_BankAcc_Number is Not Exsited Or Double!');
        Print_Logs('The L_xxx_BankDocID of L_BankAcc_Number is Not Exsited Or Double!!');
        L_xxx_BankDocID := -9999;
    END;
  
    Return(L_xxx_BankDocID);
  
  End get_BankDocID;

  /*===========================================================
  ---- Function Name:    get_BankLEntiiiID()
  ---- To get the get_BankLEntiiiID.
  =============================================================*/
  Function get_BankLEntiiiID(P_Org_ID         in Number,
                             P_BankAcc_Number in varchar2) Return Number is
  
    L_Org_ID            Number;
    L_BankAcc_Number    varchar2(50);
    L_xxx_BankLEntiiiID Number;
  
  Begin
    L_Org_ID         := P_Org_ID;
    L_BankAcc_Number := P_BankAcc_Number;
  
    Begin
      select x.Legal_Entity
        into L_xxx_BankLEntiiiID
        from xxx_STD_CE_BankInfo_v x
       where x.org_id = L_Org_ID
         and x.bank_account_num = L_BankAcc_Number
         and nvl(x.bank_end_date, SYSDATE + 1) > SYSDATE;
    
    EXCEPTION
      WHEN OTHERS THEN
        Print_Output('The L_xxx_BankLEntiiiID of L_BankAcc_Number is Not Exsited Or Double!');
        Print_Logs('The L_xxx_BankLEntiiiID of L_BankAcc_Number is Not Exsited Or Double!!');
        L_xxx_BankLEntiiiID := -9999;
    END;
  
    Return(L_xxx_BankLEntiiiID);
  
  End get_BankLEntiiiID;

  /*===========================================================
  ---- Function Name:    get_PMTsMethod_Code()
  ---- To get the get_PMTsMethod_Code.
  =============================================================*/
  Function get_PMTsMethod_Code(P_PMTsMethod_Name in varchar2) Return varchar2 is
  
    L_PMTsMethod_Code varchar2(25);
    L_PMTsMethod_Name varchar2(25);
  
  Begin
  
    L_PMTsMethod_Name := P_PMTsMethod_Name;
  
    Begin
      select xxx.payment_method_code
        into L_PMTsMethod_Code
        from IBY_PAYMENT_METHODS_TL xxx
       where xxx.payment_method_name = L_PMTsMethod_Name;
    EXCEPTION
      WHEN OTHERS THEN
        Print_Output('The L_PMTsMethod_Code of Doc is Not Exsited Or Double!');
        Print_Logs('The L_PMTsMethod_Code of Doc is Not Exsited Or Double!!');
        L_PMTsMethod_Code := 'xxxxxxPMTsMethod';
    END;
  
    Return(L_PMTsMethod_Code);
  End;

  /*===========================================================
  ---- Function Name:    get_xxxRate()
  ---- To get the get_xxxRate.
  =============================================================*/
  Function get_xxxRate(P_From_Curr       in varchar2,
                       P_To_Curr         in varchar2,
                       P_xRate_Ti        varchar2,
                       P_Accounting_Date in Date) Return Number is
  
    L_From_Curr varchar2(5);
    L_To_Curr   varchar2(5);
    L_xxx_xRate Number;
  
  Begin
  
    L_From_Curr := P_From_Curr;
    L_To_Curr   := P_To_Curr;
  
    Begin
    
      select gdd.conversion_rate
        into L_xxx_xRate
        from gl_daily_rates gdd
       where gdd.conversion_date = P_Accounting_Date
         and gdd.conversion_type = P_xRate_Ti
         and gdd.from_currency = L_From_Curr
         and gdd.to_currency = L_To_Curr;
    
    EXCEPTION
      WHEN OTHERS THEN
        Print_Output('The L_xxx_xRate of xxxx is Not Exsited Or Double!');
        Print_Logs('The L_xxx_xRate of xxxx is Not Exsited Or Double!!');
        L_xxx_xRate := -9999;
    END;
  
    Return(L_xxx_xRate);
  
  End get_xxxRate;

  /*===========================================================
  ---- Procedure Name:    Build_PMTISs()
  ---- To Build the PMTs Of The Details.
  =============================================================*/
  Procedure Build_PMTISs(P_Batch_ID Out Number,
                         P_Org_ID   In Number,
                         P_TPName   in varchar2,
                         P_PMT_Mode in varchar2) is
  
    L_Org_ID        Number := P_Org_ID;
    L_Vendor_ID     Number;
    L_Vendor_SiteID Number;
    L_PMTSelect_ID  Number;
    L_Batch_ID      Number;
  
    L_PMTsMethod_Code varchar2(25);
    L_Check_ID        Number := -9999;
  
    L_PMT_Status        varchar2(2) := 'U';
    L_PMT_StatusY       varchar2(2) := 'Y';
    L_PMT_Mode          varchar2(4) := P_PMT_Mode;
    L_PMTsTii_Flag      varchar2(2);
    L_FuturePMT_dueDate Date;
  
    Cursor xxPMTselected(P_Org_ID in Number, P_Batch_ID in Number) is
      select distinct xxx.batch_Number,
                      xxx.org_id,
                      xxx.Com_Code,
                      xxx.Org_Name,
                      xxx.PMT_TYPE,
                      xxx.vendor_name,
                      xxx.vendor_number,
                      xxx.vendor_site_code,
                      xxx.PMT_Date,
                      xxx.FuturePMT_DueDate,
                      xxx.PMT_Curr,
                      xxx.PMT_Amount,
                      xxx.bank_account_name,
                      xxx.bank_account_number,
                      xxx.PMT_METHOD,
                      xxx.PMT_Doc,
                      xxx.PMT_Profile,
                      xxx.Check_Num
      
        from xxx_ap_AutoPMTs_iFace xxx
       where xxx.imported_status = 'I'
         and xxx.batch_id = P_Batch_ID
         and xxx.invoice_num is not null
         and xxx.pmtinv_amount is not null
         and xxx.org_id = P_Org_ID;
  
  Begin
  
    L_Batch_ID := xxx_BatchID_s.Nextval;
    P_Batch_ID := L_Batch_ID;
    Print_Logs('L_Batch_ID:' || L_Batch_ID);
  
    Update xxx_ap_AutoPMTs_iFace xii
       set xii.batch_id = L_Batch_ID
     where xii.org_id = L_Org_ID
       and xii.batch_id is null;
    Commit;
  
    Delete from xxx_ap_AutoPMTs_selected x
     where x.org_id = L_Org_ID
       and x.period_name = P_TPName
       and x.pmt_mode = L_PMT_Mode
       and x.pmt_status <> L_PMT_StatusY;
  
    For xxx in xxPMTselected(L_Org_ID, L_Batch_ID) Loop
    
      select x.vendor_id, x.vendor_SiteID
        into L_Vendor_ID, L_Vendor_SiteID
        from xxx_STD_SupplierInfo_v x
       where x.org_id = xxx.org_id
         and x.sup_name = xxx.vendor_name
         and x.VendorSite_Code = xxx.vendor_site_code
         and x.sup_num = xxx.vendor_number
         and x.enable_flag = 'Y';
    
      --L_PMTsTii_Flag := xxx.PMT_TYPE;
      if xxx.PMT_Amount < 0 Then
        L_PMTsTii_Flag := P_PMTsTii_FlagR;
      End if;
      if xxx.PMT_Amount > 0 Then
        L_PMTsTii_Flag := P_PMTsTii_FlagQ;
      End if;
    
      L_PMTSelect_ID      := xxx_PMTSelect_s.Nextval;
      L_PMTsMethod_Code   := get_PMTsMethod_Code(xxx.PMT_METHOD);
      L_FuturePMT_dueDate := xxx.futurepmt_duedate;
    
      if L_PMTsMethod_Code = 'CHECK' and xxx.futurepmt_duedate is NOT Null Then
        L_FuturePMT_dueDate := Null;
      End if;
      if L_PMTsMethod_Code = 'WIRE' and xxx.futurepmt_duedate is Null Then
        L_FuturePMT_dueDate := xxx.PMT_Date + 100;
      End if;
    
      insert into xxx_ap_AutoPMTs_selected
        select L_Batch_ID,
               xxx.Batch_Number,
               xxx.org_id,
               xxx.Com_Code,
               L_PMTSelect_ID,
               xxx.Org_Name,
               L_PMTsTii_Flag,
               L_PMT_Mode,
               P_TPName,
               xxx.vendor_name,
               xxx.vendor_number,
               xxx.vendor_site_code,
               L_Vendor_ID,
               L_Vendor_SiteID,
               xxx.PMT_Date,
               L_FuturePMT_dueDate,
               xxx.PMT_Curr,
               xxx.PMT_Amount,
               xxx.bank_account_name,
               xxx.bank_account_number,
               L_PMTsMethod_Code,
               Upper(xxx.PMT_Doc),
               xxx.PMT_Profile,
               xxx.Check_Num,
               L_Check_ID,
               L_Check_ID,
               L_PMT_Status,
               
               fnd_global.user_id,
               SYSDATE,
               fnd_global.user_id,
               SYSDATE,
               fnd_global.login_id
          from dual;
    
    End Loop;
    Update xxx_ap_AutoPMTs_iFace xii
       set xii.imported_status = L_PMT_StatusY
     where xii.org_id = L_Org_ID
       and xii.batch_id = L_Batch_ID;
    Commit;
    Print_Logs('Build_PMTiSs:xxxxxx');
  End Build_PMTISs;

  /*===========================================================
  ---- Procedure Name:    Build_PMTASs()
  ---- To Build the PMTs Of The Details.
  =============================================================*/
  Procedure Build_PMTASs(P_Batch_ID Out Number,
                         P_Org_ID   In Number,
                         P_TPName   in varchar2,
                         P_PMT_Mode in varchar2) is
  
    L_Org_ID          Number := P_Org_ID;
    L_Vendor_ID       Number;
    L_Vendor_SiteID   Number;
    L_PMTSelect_ID    Number;
    L_Batch_ID        Number;
    L_PMTsMethod_Code varchar2(25);
    L_Check_ID        Number := -9999;
  
    L_PMT_Status        varchar2(2) := 'U';
    L_PMT_StatusY       varchar2(2) := 'Y';
    L_PMT_Mode          varchar2(4) := P_PMT_Mode;
    L_PMTsTii_Flag      varchar2(2);
    L_FuturePMT_dueDate Date;
  
    Cursor xxPMTselected(P_Org_ID in Number, P_Batch_ID in Number) is
      select distinct xxx.batch_Number,
                      xxx.org_id,
                      xxx.Com_Code,
                      xxx.Org_Name,
                      xxx.PMT_TYPE,
                      xxx.vendor_name,
                      xxx.vendor_number,
                      xxx.vendor_site_code,
                      xxx.PMT_Date,
                      xxx.FuturePMT_DueDate,
                      xxx.PMT_Curr,
                      xxx.PMT_Amount,
                      xxx.bank_account_name,
                      xxx.bank_account_number,
                      xxx.PMT_METHOD,
                      xxx.PMT_Doc,
                      xxx.PMT_Profile,
                      xxx.Check_Num
      
        from xxx_ap_AutoPMTs_iFace xxx
       where xxx.imported_status = 'I'
         and xxx.batch_id = P_Batch_ID
            ---and xxx.invoice_num is Null
            ---and xxx.pmtinv_amount is Null
         and xxx.org_id = P_Org_ID;
  
  Begin
  
    L_Batch_ID := xxx_BatchID_s.Nextval;
    P_Batch_ID := L_Batch_ID;
    Print_Logs('L_Batch_ID:' || L_Batch_ID);
  
    Update xxx_ap_AutoPMTs_iFace xii
       set xii.batch_id = L_Batch_ID
     where xii.org_id = L_Org_ID
       and xii.batch_id is null;
    Commit;
  
    Delete from xxx_ap_AutoPMTs_selected x
     where x.org_id = L_Org_ID
       and x.period_name = P_TPName
       and x.pmt_mode = L_PMT_Mode
       and x.pmt_status <> L_PMT_StatusY;
  
    For xxx in xxPMTselected(L_Org_ID, L_Batch_ID) Loop
    
      select x.vendor_id, x.vendor_SiteID
        into L_Vendor_ID, L_Vendor_SiteID
        from xxx_STD_SupplierInfo_v x
       where x.org_id = xxx.org_id
         and x.sup_name = xxx.vendor_name
         and x.VendorSite_Code = xxx.vendor_site_code
         and x.sup_num = xxx.vendor_number
         and x.enable_flag = 'Y';
      L_PMTsTii_Flag := xxx.PMT_TYPE;
      if xxx.PMT_Amount < 0 Then
        L_PMTsTii_Flag := P_PMTsTii_FlagR;
      End if;
    
      L_PMTSelect_ID      := xxx_PMTSelect_s.Nextval;
      L_PMTsMethod_Code   := get_PMTsMethod_Code(xxx.PMT_METHOD);
      L_FuturePMT_dueDate := xxx.futurepmt_duedate;
    
      if L_PMTsMethod_Code = 'CHECK' and xxx.futurepmt_duedate is NOT Null Then
        L_FuturePMT_dueDate := Null;
      End if;
      if L_PMTsMethod_Code = 'WIRE' and xxx.futurepmt_duedate is Null Then
        L_FuturePMT_dueDate := xxx.PMT_Date + 100;
      End if;
    
      insert into xxx_ap_AutoPMTs_selected
        select L_Batch_ID,
               xxx.Batch_Number,
               xxx.org_id,
               xxx.Com_Code,
               L_PMTSelect_ID,
               xxx.Org_Name,
               L_PMTsTii_Flag,
               L_PMT_Mode,
               P_TPName,
               xxx.vendor_name,
               xxx.vendor_number,
               xxx.vendor_site_code,
               L_Vendor_ID,
               L_Vendor_SiteID,
               xxx.PMT_Date,
               L_FuturePMT_dueDate,
               xxx.PMT_Curr,
               xxx.PMT_Amount,
               xxx.bank_account_name,
               xxx.bank_account_number,
               L_PMTsMethod_Code,
               Upper(xxx.PMT_Doc),
               xxx.PMT_Profile,
               xxx.Check_Num,
               L_Check_ID,
               L_Check_ID,
               L_PMT_Status,
               
               fnd_global.user_id,
               SYSDATE,
               fnd_global.user_id,
               SYSDATE,
               fnd_global.login_id
          from dual;
    
    End Loop;
    Update xxx_ap_AutoPMTs_iFace xii
       set xii.imported_status = L_PMT_StatusY
     where xii.org_id = L_Org_ID
       and xii.batch_id = L_Batch_ID;
    Commit;
    Print_Logs('Build_PMTASs:xxxxxx');
  End Build_PMTASs;

  /*===========================================================
  ---- Procedure Name:    Build_InvISs()
  ---- To Build the Invoices Need to Be Paid Of The Details.
  =============================================================*/
  Procedure Build_InvISs(P_Batch_ID In Number,
                         P_Org_ID   In Number,
                         P_TPName   in varchar2,
                         P_PMT_Mode in varchar2) is
  
    L_Org_ID       Number := P_Org_ID;
    L_Batch_ID     Number := P_Batch_ID;
    L_TPName       varchar2(7) := P_TPName;
    L_PMT_Status   varchar2(1) := 'U';
    L_PMT_StatusY  varchar2(1) := 'Y';
    L_PMT_Mode     varchar2(4) := P_PMT_Mode;
    L_Check_Number Number := -9999;
  
    Cursor xxInxslectdH(P_Batch_ID In Number,
                        P_Org_ID   In Number,
                        P_TPName   in varchar2) is
      select xxx.org_id,
             xxx.pmtselect_id,
             xxx.period_name,
             xxx.vendor_id,
             xxx.vendor_site_id,
             xxx.check_num,
             xii.invoice_num,
             aia.invoice_type_lookup_code Inv_Cate,
             aia.invoice_id,
             aia.payment_method_code PMT_Method,
             aia.invoice_currency_code inv_curr,
             xii.pmt_amount,
             xii.pmtinv_amount,
             aia.invoice_amount inv_amount,
             nvl(aia.amount_paid, 0) amount_paid,
             xpp.Remain_Amount remaining_amount
      
        from xxx_ap_AutoPMTs_iFace xii,
             xxx_ap_AutoPMTs_selected xxx,
             ap_invoices_all aia,
             (select app.org_id,
                     app.invoice_id,
                     Sum(app.amount_remaining) Remain_Amount
                from ap_payment_schedules_all app
               group by app.invoice_id, app.org_id) xpp
      
       where aia.org_id = xii.org_id
         and aia.org_id = xpp.org_id
         and aia.invoice_id = xpp.invoice_id
         and xii.org_id = xxx.org_id
         and xii.org_id = P_Org_ID
         and xii.batch_Number = xxx.batch_Number
         and xii.com_code = xxx.com_code
         and xii.bank_account_name = xxx.bank_account_name
         and xii.bank_account_number = xxx.bank_account_number
         and xii.pmt_curr = xxx.pmt_curr
         and xii.pmt_amount = xxx.pmt_amount
         and xii.pmt_type = xxx.pmt_type
         and xii.invoice_num = aia.invoice_num
         and xii.check_num = xxx.check_num
         and xii.pmt_profile = xxx.pmt_profile
         and xxx.pmt_mode = L_PMT_Mode
         and xxx.vendor_id = aia.vendor_id
         and xxx.vendor_site_id = aia.vendor_site_id
         and xxx.pmt_status = 'U'
         and xxx.batch_id = P_Batch_ID
         and aia.payment_status_flag <> 'Y'
         and Upper(xxx.PMT_Method) = Upper(aia.payment_method_code)
         and ap_invoices_utility_pkg.get_approval_status(aia.invoice_id,
                                                         aia.invoice_amount,
                                                         aia.payment_status_flag,
                                                         aia.invoice_type_lookup_code) in
             (P_STDInvoii_Status, P_PREInvoii_Status);
  
  Begin
    Delete from xxx_ap_AutoInvs_selected x
     where x.org_id = L_Org_ID
       and x.pmt_mode = L_PMT_Mode
       and x.period_name = P_TPName
       and x.pmt_mode = L_PMT_Mode
       and x.pmt_status <> L_PMT_StatusY;
  
    For xxx in xxInxslectdH(P_Batch_ID, L_Org_ID, L_TPName) Loop
    
      Insert into xxx_ap_AutoInvs_selected
        select L_Batch_ID,
               xxx.org_id,
               xxx.pmtselect_id,
               xxx.period_name,
               xxx.vendor_id,
               xxx.vendor_site_id,
               xxx.check_num,
               L_Check_Number,
               xxx.invoice_num,
               xxx.Inv_Cate,
               xxx.invoice_id,
               xxx.PMT_Method,
               xxx.inv_curr,
               xxx.pmt_amount,
               xxx.pmtinv_amount,
               xxx.inv_amount,
               xxx.amount_paid,
               xxx.remaining_amount,
               L_PMT_Mode,
               L_PMT_Status,
               
               fnd_global.user_id,
               SYSDATE,
               fnd_global.user_id,
               SYSDATE,
               fnd_global.login_id
          from dual;
    
    End Loop;
    Commit;
    Print_Logs('Build_InvISs:xxxxxx');
  End Build_InvISs;

  /*===========================================================
  ---- Procedure Name:    Build_InvASs()
  ---- To Build the Invoices Need to Be Paid Of The Details.AutoSelect Invs
  =============================================================*/
  Procedure Build_InvASs(P_Batch_ID In Number,
                         P_Org_ID   In Number,
                         P_TPName   in varchar2,
                         P_PMT_Mode in varchar2) is
  
    L_Org_ID       Number := P_Org_ID;
    L_Batch_ID     Number := P_Batch_ID;
    L_TPName       varchar2(7) := P_TPName;
    L_PMT_Status   varchar2(1) := 'U';
    L_PMT_StatusY  varchar2(1) := 'Y';
    L_PMT_Mode     varchar2(4) := P_PMT_Mode;
    L_Check_Number number := -9999;
  
    Cursor xxInxslectdH(P_Batch_ID In Number,
                        P_Org_ID   In Number,
                        P_TPName   in varchar2) is
      select xxx.org_id,
             xxx.pmtselect_id,
             xxx.period_name,
             xxx.vendor_id,
             xxx.vendor_site_id,
             xxx.check_num,
             aia.invoice_num,
             aia.invoice_type_lookup_code Inv_Cate,
             aia.invoice_id,
             aia.payment_method_code PMT_Method,
             aia.invoice_currency_code inv_curr,
             xxx.pmt_amount,
             xxx.pmt_amount pmtinv_amount,
             aia.invoice_amount inv_amount,
             nvl(aia.amount_paid, 0) amount_paid,
             xpp.Remain_Amount remaining_amount
      
        from xxx_ap_AutoPMTs_selected xxx,
             ap_invoices_all aia,
             (select app.org_id,
                     app.invoice_id,
                     Sum(app.amount_remaining) Remain_Amount
                from ap_payment_schedules_all app
               group by app.invoice_id, app.org_id) xpp
       where aia.org_id = xxx.org_id
         and aia.org_id = xpp.org_id
         and aia.invoice_id = xpp.invoice_id
         and aia.org_id = P_Org_ID
         and xxx.batch_id = P_Batch_ID
         and xxx.pmt_mode = L_PMT_Mode
         and xxx.pmt_status = 'U'
         and xxx.vendor_id = aia.vendor_id
         and xxx.vendor_site_id = aia.vendor_site_id
         and aia.payment_status_flag <> 'Y'
         and Upper(xxx.PMT_Method) = Upper(aia.payment_method_code)
         and ap_invoices_utility_pkg.get_approval_status(aia.invoice_id,
                                                         aia.invoice_amount,
                                                         aia.payment_status_flag,
                                                         aia.invoice_type_lookup_code) in
             (P_STDInvoii_Status, P_PREInvoii_Status);
  
  Begin
    Delete from xxx_ap_AutoInvs_selected x
     where x.org_id = L_Org_ID
       and x.pmt_mode = L_PMT_Mode
       and x.period_name = P_TPName
       and x.pmt_mode = L_PMT_Mode
       and x.pmt_status <> L_PMT_StatusY;
  
    For xxx in xxInxslectdH(P_Batch_ID, L_Org_ID, L_TPName) Loop
    
      Insert into xxx_ap_AutoInvs_selected
        select L_Batch_ID,
               xxx.org_id,
               xxx.pmtselect_id,
               xxx.period_name,
               xxx.vendor_id,
               xxx.vendor_site_id,
               xxx.check_num,
               L_Check_Number,
               xxx.invoice_num,
               xxx.Inv_Cate,
               xxx.invoice_id,
               xxx.PMT_Method,
               xxx.inv_curr,
               xxx.pmt_amount,
               xxx.pmtinv_amount,
               xxx.inv_amount,
               xxx.amount_paid,
               xxx.remaining_amount,
               L_PMT_Mode,
               L_PMT_Status,
               
               fnd_global.user_id,
               SYSDATE,
               fnd_global.user_id,
               SYSDATE,
               fnd_global.login_id
          from dual;
    
    End Loop;
    Commit;
    Print_Logs('Build_InvASs:xxxxxx');
  End Build_InvASs;

  /*===========================================================
  ---- Procedure Name:    Auto_PPMTs() Of Partial PMTs.
  ---- Need Check the PMTs Amount.
  =============================================================*/
  Procedure Auto_PPMTs(P_Suc_Flag Out Varchar2,
                       P_Suc_Log  Out Varchar2,
                       P_Batch_ID In Number,
                       P_Org_ID   In Number,
                       P_TPName   in varchar2,
                       P_PMT_Mode in varchar2) is
  
    L_Batch_ID          Number := P_Batch_ID;
    L_User_ID           Number := fnd_global.user_id;
    L_SOB_ID            Number := fnd_profile.value('GL_SET_OF_BKS_ID');
    L_Org_ID            Number := P_Org_ID;
    L_ii_OrgID          Number;
    L_iii_OrgID         number;
    L_Appl_ID           Number := fnd_global.Resp_Appl_ID;
    L_Request_ID        Number := fnd_global.conc_request_id;
    L_Program_ID        Number := fnd_global.conc_program_id;
    L_TPName            varchar2(7) := P_TPName;
    L_gl_TPName         varchar2(7);
    L_gl_Date           Date;
    L_Accounting_Date   Date;
    L_FuturePMT_dueDate Date;
  
    L_PMTs_RowsID       varchar2(2000);
    L_PMTs_TrxTi        varchar2(30) := 'PAYMENT CREATED';
    L_xxx_BankUseID     Number;
    L_xxx_BankAccID     Number;
    L_xxx_BankDocID     Number;
    L_xxx_BankLEntiiiID Number;
    L_Invoii_ID         Number;
  
    L_SOB_Curr     varchar2(5);
    L_PMTs_Curr    varchar2(5);
    L_Curr_Prii    Number;
    L_xRate_Ti     varchar2(30);
    L_xRate_TUi    varchar2(30);
    L_xxx_xDate    Date;
    L_xxx_xRate    Number;
    L_xBase_Amount Number;
  
    L_VParty_ID     Number;
    L_VParty_SiteID Number;
  
    L_Check_ID     Number;
    L_Profile_ID   Number;
    L_PMTx_ID      Number;
    L_Inv_PMTxID   Number;
    L_Check_Amount Number;
    L_Check_Num    varchar2(30);
    L_Check_Name   varchar2(50);
    L_PMTs_Num     varchar2(30);
    L_Null         varchar2(3);
  
    L_Paid_Amount   Number;
    L_TPaid_Amount  Number;
    L_RemPMT_Amount Number;
  
    L_Import_Flag        varchar2(2) := 'Y';
    L_PMTs_FlagY         varchar2(2) := 'Y';
    L_PMTs_FlagE         varchar2(2) := 'E';
    L_attribute_category varchar2(100);
    L_atrrii_A           varchar2(100);
  
    L_All_Num          Number := 0;
    L_AllChecks_Num    Number := 0;
    L_ImportedS        Number := 0;
    L_ImportedE        Number := 0;
    L_PMT_Mode         varchar2(4) := P_PMT_Mode;
    L_Conn_Char        varchar2(2) := ':';
    L_PMTsLookup_Code  varchar2(20);
    L_PMTSelect_ID     Number;
    L_PMTs_EventsID    Number;
    L_PMTs_xxxEventsID Number := -9999;
  
    Cursor xx_PMTs(P_Batch_ID in Number,
                   P_Org_ID   In Number,
                   P_TPName   in varchar2,
                   P_PMT_Mode in varchar2) is
      select *
        from xxx_ap_AutoPMTs_selected xip
       where xip.org_id = P_Org_ID
         and xip.period_name = P_TPName
         and xip.batch_id = P_Batch_ID
         and xip.check_id = -9999
         and xip.pmt_status <> 'Y'
         and xip.pmt_mode = P_PMT_Mode
         For Update Of xip.check_id, xip.check_xnum, xip.pmt_status;
  
    Cursor xx_iivois(P_Batch_ID     in Number,
                     P_PMTSelect_ID in Number,
                     P_Org_ID       In Number,
                     P_TPName       in varchar2,
                     P_PMTs_Curr    in varchar2,
                     P_PMT_Mode     in varchar2) is
      select *
        from xxx_ap_AutoInvs_selected xii
       where xii.org_id = P_Org_ID
         and xii.pmtselect_id = P_PMTSelect_ID
         and xii.period_name = P_TPName
         and xii.inv_curr = P_PMTs_Curr
         and xii.batch_id = P_Batch_ID
         and xii.pmt_status <> 'Y'
         and xii.pmt_mode = P_PMT_Mode
         For Update Of xii.pmt_status, xii.check_xnum;
  
    Cursor xx_iiscdu(P_Org_ID in Number, P_iivois_ID In Number) is
      select iis.invoice_id,
             iis.payment_num,
             iis.amount_remaining,
             iis.payment_method_lookup_code,
             iis.payment_priority,
             iis.payment_status_flag,
             iis.attribute_category,
             iis.attribute1 atrrii_A
      
        from ap_payment_schedules_all iis
       where iis.org_id = P_Org_ID
         and iis.invoice_id = P_iivois_ID
         and iis.payment_status_flag <> 'Y';
  
  Begin
  
    select app.base_currency_code, app.default_exchange_rate_type
      into L_SOB_Curr, L_xRate_Ti
      from ap_system_parameters_all app
     where app.org_id = L_Org_ID;
  
    select fnn.precision
      into L_Curr_Prii
      from fnd_currencies fnn
     where fnn.currency_code = L_SOB_Curr;
  
    ---- For Each PMTs Create the Checks.
    For xxp in xx_PMTs(L_Batch_ID, L_Org_ID, L_TPName, L_PMT_Mode) Loop
    
      L_ii_OrgID     := mo_global.get_current_org_id;
      L_iii_OrgID    := fnd_global.Org_ID;
      L_PMTSelect_ID := xxp.pmtselect_id;
    
      L_Accounting_Date   := xxp.pmt_date;
      L_FuturePMT_dueDate := xxp.FuturePMT_dueDate;
      ap_utilities_pkg.get_only_open_gl_date(L_Accounting_Date,
                                             L_gl_TPName,
                                             L_gl_Date,
                                             L_Org_ID);
    
      L_xxx_BankUseID     := get_BankUseID(L_Org_ID,
                                           xxp.bank_account_number);
      L_xxx_BankAccID     := get_BankAccID(L_Org_ID,
                                           xxp.bank_account_number);
      L_xxx_BankDocID     := get_BankDocID(L_xxx_BankAccID, xxp.pmt_doc);
      L_xxx_BankLEntiiiID := get_BankLEntiiiID(L_Org_ID,
                                               xxp.bank_account_number);
    
      L_Check_Amount := xxp.pmt_amount;
      L_PMTs_Curr    := xxp.pmt_curr;
    
      ---- Set it=Blank
      L_xxx_xDate    := L_Null;
      L_xRate_TUi    := L_Null;
      L_xxx_xRate    := L_Null;
      L_xBase_Amount := L_Null;
    
      if L_PMTs_Curr <> L_SOB_Curr Then
        L_xxx_xDate    := L_Accounting_Date;
        L_xRate_TUi    := L_xRate_Ti;
        L_xxx_xRate    := get_xxxRate(P_From_Curr       => L_PMTs_Curr,
                                      P_To_Curr         => L_SOB_Curr,
                                      P_xRate_Ti        => L_xRate_TUi,
                                      P_Accounting_Date => L_xxx_xDate);
        L_xBase_Amount := Round(L_Check_Amount * L_xxx_xRate, L_Curr_Prii);
      End if;
    
      select iby_payments_all_s.nextval into L_PMTx_ID from dual;
      if xxp.pmt_method = 'WIRE' Then
        L_PMTsLookup_Code := P_WPMTsLookup_Code;
      End if;
      if xxp.pmt_method = 'CHECK' Then
        L_PMTsLookup_Code := P_CPMTsLookup_Code;
      End if;
    
      L_Check_Num := xxp.check_num;
      if L_Check_Num is null then
        L_Check_Num := to_Char(SYSTIMESTAMP, 'YYYYMMDDHH24MISSFF1');
      End if;
    
      L_AllChecks_Num := L_AllChecks_Num + 1;
      ---- ReVuale the L_Check_Num
      L_Check_Num := to_Char(SYSTIMESTAMP, 'YYYYMMDDHH24MISSFF1');
      /*L_Check_Num := to_Char(SYSTIMESTAMP, 'YYYYMMDD') ||
      LPAD(L_AllChecks_Num, 7, '0');*/
    
      select ap_checks_s.nextval INTO L_Check_ID from dual;
      L_Check_Name := L_Check_PName || L_Check_Auto_PPMTs || L_Check_ID;
      select xx.payment_profile_id
        into L_Profile_ID
        from IBY_ACCT_PMT_PROFILES_B xx
       where xx.system_profile_code = xxp.pmt_profile;
    
      select v.VParty_ID, v.VParty_SiteID
        into L_VParty_ID, L_VParty_SiteID
        from xxx_STD_SupplierInfo_v v
       where v.org_id = xxp.org_id
         and v.vendor_id = xxp.vendor_id
         and v.vendor_SiteID = xxp.vendor_site_id;
    
      ---- to PMTs the Each iivoices.Loop
      L_Paid_Amount   := 0;
      L_TPaid_Amount  := 0;
      L_RemPMT_Amount := L_Check_Amount;
    
      For xxi in xx_iivois(P_Batch_ID     => L_Batch_ID,
                           P_PMTSelect_ID => L_PMTSelect_ID,
                           P_Org_ID       => L_Org_ID,
                           P_TPName       => L_TPName,
                           P_PMTs_Curr    => L_PMTs_Curr,
                           P_PMT_Mode     => L_PMT_Mode) Loop
      
        Exit When L_RemPMT_Amount = 0;
      
        L_Invoii_ID := xxi.invoice_id;
      
        ---- To Selected and PMT the iivoices.Loop and Update ap_invoice_payments_all
        For iis in xx_iiscdu(L_Org_ID, L_Invoii_ID) Loop
        
          Exit When L_RemPMT_Amount = 0;
          select ap_invoice_payments_s.nextval into L_Inv_PMTxID from dual;
        
          L_Paid_Amount := iis.amount_remaining;
          if L_RemPMT_Amount < L_Paid_Amount Then
            L_Paid_Amount := L_RemPMT_Amount;
          End if;
        
          L_PMTs_Num           := iis.payment_num;
          L_attribute_category := iis.attribute_category;
          L_atrrii_A           := iis.atrrii_a;
        
          Savepoint xxxRollBackA;
          if L_Check_Amount != 0 then
            Begin
              ap_pay_invoice_pkg.ap_pay_invoice(P_invoice_id         => L_Invoii_ID,
                                                P_check_id           => L_Check_ID,
                                                P_payment_num        => L_PMTs_Num,
                                                P_invoice_payment_id => L_Inv_PMTxID,
                                                P_period_name        => L_TPName,
                                                P_invoice_type       => xxi.inv_cate,
                                                P_accounting_date    => L_Accounting_Date,
                                                P_amount             => L_Paid_Amount,
                                                P_Discount_taken     => 0,
                                                
                                                P_attribute_category => L_attribute_category,
                                                P_attribute1         => L_atrrii_A,
                                                
                                                P_accrual_posted_flag    => 'N',
                                                P_cash_posted_flag       => 'N',
                                                P_posted_flag            => 'N',
                                                P_payment_dists_flag     => 'N',
                                                P_exclusive_payment_flag => 'N',
                                                P_payment_mode           => 'PAY',
                                                P_replace_flag           => 'N',
                                                
                                                P_set_of_books_id   => L_SOB_ID,
                                                P_last_updated_by   => L_User_ID,
                                                P_last_update_login => fnd_global.LOGIN_ID,
                                                P_currency_code     => L_PMTs_Curr,
                                                
                                                P_base_currency_code => L_SOB_Curr,
                                                P_exchange_rate      => L_xxx_xRate,
                                                P_exchange_rate_type => L_xRate_TUi,
                                                P_exchange_date      => L_xxx_xDate,
                                                
                                                P_ce_bank_acct_use_id => L_xxx_BankUseID,
                                                P_bank_account_num    => xxp.bank_account_number,
                                                P_accounting_Event_id => L_PMTs_xxxEventsID,
                                                P_org_id              => L_Org_ID);
            
              ---- ---- ----Loop Caculate the Invoii want to Be PAID.
              L_RemPMT_Amount := L_RemPMT_Amount - L_Paid_Amount;
              L_TPaid_Amount  := L_TPaid_Amount + L_Paid_Amount;
            
              Print_Logs('L_Check_ID-ParPMTs:' || L_Check_ID);
              Print_Logs('L_Check_Num:' || L_Check_Num);
              Print_Logs('L_Check_Amount:' || L_Check_Amount);
              Print_Logs('L_PMTSelect_ID:' || L_PMTSelect_ID);
              Print_Logs('L_Paid_Amount:' || L_Paid_Amount);
              Print_Logs('L_Invoii_ID:' || L_Invoii_ID || L_Conn_Char ||
                         L_PMTs_Num);
              Print_Logs('L_Inv_PMTxID:' || L_Inv_PMTxID);
            
            Exception
              when others then
                P_Suc_Flag := fnd_api.g_ret_sts_error;
                P_Suc_Log  := P_Suc_Log ||
                              dbms_utility.format_error_backtrace() || ':' ||
                              SQLERRM || P_Suc_Flag;
                dbms_output.put_line('L_Import_Flag-ap_pay_invoice_pkg :' ||
                                     SQLCODE);
                dbms_output.put_line('L_Import_Flag-ap_pay_invoice_pkg :' ||
                                     SQLERRM);
                dbms_output.put_line('fnd_message.get is :' ||
                                     fnd_message.get);
                Print_Logs('L_Import_Flag-ap_pay_invoice_pkg :' || SQLCODE);
                Print_Logs('L_Import_Flag-ap_pay_invoice_pkg :' || SQLERRM);
                Print_Logs('L_Import_Flag-ap_pay_invoice_pkg :' ||
                           fnd_message.get);
              
                L_Import_Flag := 'N';
              
                Print_Logs(P_Suc_Log);
                Print_Logs('L_xxx_BankUseID:' || L_xxx_BankUseID);
                Print_Logs('L_Check_ID:' || L_Check_ID);
                Print_Logs('L_Check_Num:' || L_Check_Num);
                Print_Logs('L_Check_Name:' || L_Check_Name);
                print_Logs('L_xxx_BankNum:' || xxp.bank_account_number);
                Print_Logs('L_xxx_BankAccID:' || L_xxx_BankAccID);
                Print_Logs('L_Paid_Amount :' || L_Paid_Amount);
                Print_Logs('L_PMTs_Amount:' || iis.amount_remaining);
                Print_Logs('L_Inv_PMTxID:' || L_Inv_PMTxID);
                Print_Logs('L_PMTs_EventsID:' || L_PMTs_xxxEventsID);
              
            End;
          End if;
        
        ---- ---- ----End Loop xx_iiscdu()
        End Loop;
        if L_Import_Flag = 'Y' Then
          Update xxx_ap_AutoInvs_selected xxi
             set xxi.check_xnum = L_Check_Num,
                 xxi.pmt_status = L_PMTs_FlagY
           where Current Of xx_iivois;
        End if;
        if L_Import_Flag = 'N' Then
          Update xxx_ap_AutoInvs_selected xxi
             set xxi.pmt_status = L_PMTs_FlagE
           where Current Of xx_iivois;
        End if;
        ---- ---- ----End Loop xx_iivois()
      End Loop;
    
      if L_Check_Amount <> L_TPaid_Amount Then
        L_Check_Amount := L_TPaid_Amount;
      End if;
      if L_PMTs_Curr <> L_SOB_Curr Then
        L_xBase_Amount := Round(L_Check_Amount * L_xxx_xRate, L_Curr_Prii);
      End if;
    
      Savepoint xxxRollBackB;
      if L_Check_Amount != 0 then
        Begin
        
          ---- To Create the Checks.Update ap_checks_all
          ap_checks_pkg.Insert_Row(X_Rowid               => L_PMTs_RowsID,
                                   X_Org_Id              => xxp.org_id,
                                   X_Amount              => L_Check_Amount,
                                   X_CE_Bank_Acct_Use_Id => L_xxx_BankUseID,
                                   X_Bank_Account_Name   => xxp.bank_account_name,
                                   X_Bank_Account_Num    => xxp.bank_account_number,
                                   
                                   X_Vendor_Name      => xxp.vendor_name,
                                   X_Vendor_Site_Code => xxp.vendor_site_code,
                                   X_Vendor_Id        => xxp.vendor_id,
                                   X_Vendor_Site_Id   => xxp.vendor_site_id,
                                   x_party_id         => L_VParty_ID,
                                   x_party_site_id    => L_VParty_SiteID,
                                   
                                   X_Check_Date               => L_Accounting_Date,
                                   X_Future_Pay_Due_Date      => L_FuturePMT_dueDate,
                                   X_Check_Id                 => L_Check_ID,
                                   X_Check_Number             => L_Check_Num,
                                   X_Checkrun_Name            => L_Check_Name,
                                   X_External_Bank_Account_Id => L_xxx_BankAccID,
                                   x_legal_entity_id          => L_xxx_BankLEntiiiID,
                                   X_Currency_Code            => L_PMTs_Curr,
                                   
                                   X_Payment_Type_Flag   => xxp.pmt_type,
                                   x_payment_method_code => xxp.pmt_method,
                                   x_payment_profile_id  => L_Profile_ID,
                                   x_payment_document_id => L_xxx_BankDocID,
                                   x_payment_id          => L_PMTx_ID,
                                   
                                   X_description        => L_Check_Name,
                                   X_Status_Lookup_Code => L_PMTsLookup_Code,
                                   X_Calling_Sequence   => 'xxx_Auto_PPMTs',
                                   
                                   --X_Cleared_Base_Amount        => xxp.pmt_amount,
                                   --X_Cleared_Exchange_Rate      => L_Null,
                                   --X_Cleared_Exchange_Date      => L_Null,
                                   --X_Cleared_Exchange_Rate_Type => 'User',
                                   X_Base_Amount        => L_xBase_Amount,
                                   X_Exchange_Rate      => L_xxx_xRate,
                                   X_Exchange_Date      => L_xxx_xDate,
                                   X_Exchange_Rate_Type => L_xRate_TUi,
                                   
                                   X_Created_By        => L_User_ID,
                                   X_Creation_Date     => SYSDATE,
                                   X_Last_Updated_By   => L_User_ID,
                                   X_Last_Update_Date  => SYSDATE,
                                   X_Last_Update_Login => fnd_global.LOGIN_ID);
        
        Exception
          when others then
            P_Suc_Flag := fnd_api.g_ret_sts_error;
            P_Suc_Log  := P_Suc_Log ||
                          dbms_utility.format_error_backtrace() || ':' ||
                          SQLERRM || P_Suc_Flag;
            dbms_output.put_line('L_Import_Flag-ap_checks_pkg :' ||
                                 SQLCODE);
            dbms_output.put_linE('L_Import_Flag-ap_checks_pkg :' ||
                                 substr(SQLERRM, 1, 150));
            dbms_output.put_linE('fnd_message.get is :' ||
                                 substr(fnd_message.get, 1, 150));
            Print_Logs('L_Import_Flag-ap_checks_pkg :' || SQLCODE);
            Print_Logs('L_Import_Flag-ap_checks_pkg :' ||
                       substr(SQLERRM, 1, 150));
            Print_Logs('L_Import_Flag-ap_checks_pkg :' ||
                       substr(fnd_message.get, 1, 150));
            L_Import_Flag := 'N';
            Print_Logs('L_xxx_BankUseID:' || L_xxx_BankUseID);
            Print_Logs('L_Check_ID:' || L_Check_ID);
            Print_Logs('L_Check_Num:' || L_Check_Num);
            Print_Logs('L_Check_Name:' || L_Check_Name);
            Print_Logs('L_xxx_BankAccID:' || L_xxx_BankAccID);
            Print_Logs('L_PMTx_ID:' || L_PMTx_ID);
          
            RollBack to xxxRollBackA;
        End;
      End if;
    
      Savepoint xxxRollBackC;
      if L_Check_Amount != 0 then
        BEGIN
          ---- To Create the History Record.Update ap_payment_history_all
          ap_reconciliation_pkg.insert_payment_history(x_check_id         => L_Check_ID,
                                                       x_transaction_type => L_PMTs_TrxTi,
                                                       x_accounting_date  => L_Accounting_Date,
                                                       --x_accounting_event_id     => L_PMTs_EventsID,
                                                       x_trx_bank_amount         => L_Null,
                                                       x_errors_bank_amount      => L_Null,
                                                       x_charges_bank_amount     => L_Null,
                                                       x_bank_currency_code      => L_Null,
                                                       x_bank_to_base_xrate_type => L_Null,
                                                       x_bank_to_base_xrate_date => L_Null,
                                                       x_bank_to_base_xrate      => L_Null,
                                                       x_errors_pmt_amount       => L_Null,
                                                       x_charges_pmt_amount      => L_Null,
                                                       
                                                       x_pmt_currency_code => L_PMTs_Curr,
                                                       x_trx_pmt_amount    => L_Check_Amount,
                                                       
                                                       x_pmt_to_base_xrate_type => L_xRate_TUi,
                                                       x_pmt_to_base_xrate_date => L_xxx_xDate,
                                                       x_pmt_to_base_xrate      => L_xxx_xRate,
                                                       x_trx_base_amount        => L_xBase_Amount,
                                                       
                                                       x_errors_base_amount  => NULL,
                                                       x_charges_base_amount => NULL,
                                                       x_matched_flag        => NULL,
                                                       x_rev_pmt_hist_id     => NULL,
                                                       
                                                       x_created_by        => L_User_ID,
                                                       x_creation_date     => SYSDATE,
                                                       x_last_updated_by   => L_User_ID,
                                                       x_last_update_date  => SYSDATE,
                                                       x_last_update_login => fnd_global.LOGIN_ID,
                                                       
                                                       x_program_update_date    => SYSDATE,
                                                       x_program_application_id => L_Appl_ID,
                                                       x_program_id             => L_Program_ID,
                                                       x_request_id             => L_Request_ID,
                                                       x_calling_sequence       => 'xxx_Auto_PPMTs',
                                                       x_org_id                 => L_Org_ID);
        
        Exception
          when others then
            P_Suc_Flag := fnd_api.g_ret_sts_error;
            P_Suc_Log  := P_Suc_Log ||
                          dbms_utility.format_error_backtrace() || ':' ||
                          SQLERRM || P_Suc_Flag;
            dbms_output.put_line('L_Import_Flag-ap_reconciliation_pkg :' ||
                                 SQLCODE);
            dbms_output.put_linE('L_Import_Flag-ap_reconciliation_pkg :' ||
                                 SQLERRM);
            dbms_output.put_linE('fnd_message.get is :' || fnd_message.get);
            Print_Logs('L_Import_Flag-ap_reconciliation_pkg :' || SQLCODE);
            Print_Logs('L_Import_Flag-ap_reconciliation_pkg :' || SQLERRM);
            Print_Logs('L_Import_Flag-ap_reconciliation_pkg :' ||
                       fnd_message.get);
            L_Import_Flag := 'N';
            RollBack to xxxRollBackB;
            RollBack to xxxRollBackA;
        End;
        ---- ---- ---- To Update the Record.
        if L_Import_Flag = 'Y' Then
          L_ImportedS := L_ImportedS + 1;
          Update xxx_ap_AutoPMTs_selected xxp
             set xxp.check_id   = L_Check_ID,
                 xxp.check_xnum = L_Check_Num,
                 xxp.pmt_status = L_PMTs_FlagY
           Where Current Of xx_PMTs;
        
          select app.accounting_event_id
            into L_PMTs_EventsID
            from ap_payment_history_all app
           where app.org_id = L_Org_ID
             and app.check_id = L_Check_ID
             and app.transaction_type = L_PMTs_TrxTi;
          update ap_invoice_payments_all xap
             set xap.accounting_event_id = L_PMTs_EventsID
           where xap.org_id = L_Org_ID
             and xap.check_id = L_Check_ID
             and xap.accounting_event_id = L_PMTs_xxxEventsID;
          Print_Logs('L_PMTs_xxxEventsID:' || L_PMTs_EventsID);
        End if;
        if L_Import_Flag = 'N' Then
          L_ImportedE := L_ImportedE + 1;
          Update xxx_ap_AutoPMTs_selected xxp
             set xxp.pmt_status = L_PMTs_FlagE
           Where Current Of xx_PMTs;
        End if;
        ---- ---- ---- To Update the Record.
      
      End if;
      Print_Logs('L_Import_Flag ***-++++++++-***:' || L_Import_Flag);
    
    ---- ---- ----End Loop xx_PMTs()
    End Loop;
    Commit;
    L_All_Num := L_ImportedS + L_ImportedE;
    ---- ---- ---- ----
    dbms_output.put_line('L_All_Num :' || L_All_Num);
    dbms_output.put_line('L_ImportedS :' || L_ImportedS);
    dbms_output.put_line('L_ImportedE :' || L_ImportedE);
    Print_Logs('L_All_Num :' || L_All_Num);
    Print_Logs('L_ImportedS :' || L_ImportedS);
    Print_Logs('L_ImportedE :' || L_ImportedE);
    Print_Output('L_All_Num :' || L_All_Num);
    Print_Output('L_ImportedS :' || L_ImportedS);
    Print_Output('L_ImportedE :' || L_ImportedE);
  
  End Auto_PPMTs;

  /*===========================================================
  ---- Procedure Name:    Auto_FOPMTs() Of FullPMTs. For One Installment
  ---- To Get the Amount From the invoii Of Remainning Amount.
  =============================================================*/
  Procedure Auto_FOPMTs(P_Suc_Flag Out Varchar2,
                        P_Suc_Log  Out Varchar2,
                        P_Batch_ID In Number,
                        P_Org_ID   In Number,
                        P_TPName   in varchar2,
                        P_PMT_Mode in varchar2) is
    L_Batch_ID          Number := P_Batch_ID;
    L_User_ID           Number := fnd_global.user_id;
    L_SOB_ID            Number := fnd_profile.value('GL_SET_OF_BKS_ID');
    L_Org_ID            Number := P_Org_ID;
    L_ii_OrgID          Number;
    L_iii_OrgID         number;
    L_Appl_ID           Number := fnd_global.Resp_Appl_ID;
    L_Request_ID        Number := fnd_global.conc_request_id;
    L_Program_ID        Number := fnd_global.conc_program_id;
    L_TPName            varchar2(7) := P_TPName;
    L_gl_TPName         varchar2(7);
    L_gl_Date           Date;
    L_Accounting_Date   Date;
    L_FuturePMT_dueDate Date;
  
    L_PMTs_RowsID  varchar2(2000);
    L_PMTs_TrxTi   varchar2(30) := 'PAYMENT CREATED';
    L_PMTsTii_Flag varchar2(2);
  
    L_xxx_BankUseID     Number;
    L_xxx_BankAccID     Number;
    L_xxx_BankDocID     Number;
    L_xxx_BankLEntiiiID Number;
    L_Invoii_ID         Number;
  
    L_SOB_Curr     varchar2(5);
    L_PMTs_Curr    varchar2(5);
    L_Curr_Prii    Number;
    L_xRate_Ti     varchar2(30);
    L_xRate_TUi    varchar2(30);
    L_xxx_xDate    Date;
    L_xxx_xRate    Number;
    L_xBase_Amount Number;
  
    L_VParty_ID     Number;
    L_VParty_SiteID Number;
  
    L_Check_ID   Number;
    L_Profile_ID Number;
    L_PMTx_ID    Number;
    L_Inv_PMTxID Number;
    L_Check_Num  varchar2(30);
    L_Check_Name varchar2(50);
    L_Null       varchar2(30);
  
    L_Paid_Amount  Number;
    L_TPaid_Amount Number;
  
    L_Import_Flag varchar2(2) := 'Y';
    L_PMTs_FlagY  varchar2(2) := 'Y';
    L_PMTs_FlagS  varchar2(2) := 'S';
    L_PMTs_FlagE  varchar2(2) := 'E';
  
    L_All_Num         Number := 0;
    L_AllChecks_Num   Number := 0;
    L_ImportedS       Number := 0;
    L_ImportedE       Number := 0;
    L_PMT_Mode        varchar2(4) := P_PMT_Mode;
    L_PMTsLookup_Code varchar2(20);
    L_Conn_Chariivois varchar2(2) := chr(32);
    L_ivoii_List      varchar2(5000);
  
    L_PMTSelect_ID  Number;
    L_PMTs_EventsID Number;
  
    Cursor xx_PMTs(P_Batch_ID in Number,
                   P_Org_ID   In Number,
                   P_TPName   in varchar2,
                   P_PMT_Mode in varchar2) is
      select *
        from xxx_ap_AutoPMTs_selected xip
       where xip.org_id = P_Org_ID
         and xip.period_name = P_TPName
         and xip.batch_id = P_Batch_ID
         and xip.check_id = -9999
         and xip.pmt_status <> 'Y'
         and xip.pmt_mode = P_PMT_Mode
         For Update Of xip.check_id, xip.check_xnum, xip.pmt_status;
  
    Cursor xx_iivois(P_Batch_ID     in Number,
                     P_PMTSelect_ID in Number,
                     P_Org_ID       In Number,
                     P_TPName       in varchar2,
                     P_PMTs_Curr    in varchar2,
                     P_PMT_Mode     in varchar2) is
      select *
        from xxx_ap_AutoInvs_selected xii
       where xii.org_id = P_Org_ID
         and xii.pmtselect_id = P_PMTSelect_ID
         and xii.period_name = P_TPName
         and xii.inv_curr = P_PMTs_Curr
         and xii.batch_id = P_Batch_ID
         and xii.pmt_status <> 'Y'
         and xii.pmt_mode = P_PMT_Mode
         For Update Of xii.pmt_status, xii.check_xnum;
  
  Begin
  
    select app.base_currency_code, app.default_exchange_rate_type
      into L_SOB_Curr, L_xRate_Ti
      from ap_system_parameters_all app
     where app.org_id = L_Org_ID;
  
    select fnn.precision
      into L_Curr_Prii
      from fnd_currencies fnn
     where fnn.currency_code = L_SOB_Curr;
  
    ---- For Each PMTs Create the Checks.
    For xxp in xx_PMTs(L_Batch_ID, L_Org_ID, L_TPName, L_PMT_Mode) Loop
    
      L_ii_OrgID     := mo_global.get_current_org_id;
      L_iii_OrgID    := fnd_global.Org_ID;
      L_PMTSelect_ID := xxp.pmtselect_id;
    
      L_Accounting_Date   := xxp.pmt_date;
      L_FuturePMT_dueDate := xxp.FuturePMT_dueDate;
      ap_utilities_pkg.get_only_open_gl_date(L_Accounting_Date,
                                             L_gl_TPName,
                                             L_gl_Date,
                                             L_Org_ID);
    
      L_xxx_BankUseID     := get_BankUseID(L_Org_ID,
                                           xxp.bank_account_number);
      L_xxx_BankAccID     := get_BankAccID(L_Org_ID,
                                           xxp.bank_account_number);
      L_xxx_BankDocID     := get_BankDocID(L_xxx_BankAccID, xxp.pmt_doc);
      L_xxx_BankLEntiiiID := get_BankLEntiiiID(L_Org_ID,
                                               xxp.bank_account_number);
    
      L_PMTs_Curr := xxp.pmt_curr;
    
      ---- Set it=Blank
      L_xxx_xDate    := L_Null;
      L_xRate_TUi    := L_Null;
      L_xxx_xRate    := L_Null;
      L_xBase_Amount := L_Null;
    
      select iby_payments_all_s.nextval into L_PMTx_ID from dual;
      if xxp.pmt_method = 'WIRE' Then
        L_PMTsLookup_Code := P_WPMTsLookup_Code;
      End if;
      if xxp.pmt_method = 'CHECK' Then
        L_PMTsLookup_Code := P_CPMTsLookup_Code;
      End if;
    
      L_Check_Num := xxp.check_num;
      if L_Check_Num is null then
        L_Check_Num := to_Char(SYSTIMESTAMP, 'YYYYMMDDHH24MISSFF1');
      End if;
    
      L_AllChecks_Num := L_AllChecks_Num + 1;
      ---- ReVuale the L_Check_Num
      L_Check_Num := to_Char(SYSTIMESTAMP, 'YYYYMMDDHH24MISSFF1');
      /*L_Check_Num := to_Char(SYSTIMESTAMP, 'YYYYMMDD') ||
      LPAD(L_AllChecks_Num, 7, '0');*/
    
      select ap_checks_s.nextval INTO L_Check_ID from dual;
      L_Check_Name := L_Check_PName || L_Check_Auto_FOPMTs || L_Check_ID;
      select xx.payment_profile_id
        into L_Profile_ID
        from IBY_ACCT_PMT_PROFILES_B xx
       where xx.system_profile_code = xxp.pmt_profile;
    
      select v.VParty_ID, v.VParty_SiteID
        into L_VParty_ID, L_VParty_SiteID
        from xxx_STD_SupplierInfo_v v
       where v.org_id = xxp.org_id
         and v.vendor_id = xxp.vendor_id
         and v.vendor_SiteID = xxp.vendor_site_id;
    
      ---- to PMTs the Each iivoices.Loop
      L_Paid_Amount  := 0;
      L_TPaid_Amount := 0;
      L_ivoii_List   := Null;
    
      ----To Recalculate the Amount Ready to PMTs.
      For xxi in xx_iivois(P_Batch_ID     => L_Batch_ID,
                           P_PMTSelect_ID => L_PMTSelect_ID,
                           P_Org_ID       => L_Org_ID,
                           P_TPName       => L_TPName,
                           P_PMTs_Curr    => L_PMTs_Curr,
                           P_PMT_Mode     => L_PMT_Mode) Loop
      
        L_Invoii_ID    := xxi.invoice_id;
        L_TPaid_Amount := L_TPaid_Amount + xxi.remaining_amount;
        L_ivoii_List   := L_Invoii_ID || L_Conn_Chariivois || L_ivoii_List;
        ---- ---- ----End Loop xx_iivois()
      
        Update xxx_ap_AutoInvs_selected xxi
           set xxi.check_xnum = L_Check_Num, xxi.pmt_status = L_PMTs_FlagS
         where Current Of xx_iivois;
      
      End Loop;
    
      L_ivoii_List := SUBSTR(L_ivoii_List, 1, LENGTH(L_ivoii_List) - 1);
    
      if L_PMTs_Curr <> L_SOB_Curr Then
        L_xxx_xDate    := L_Accounting_Date;
        L_xRate_TUi    := L_xRate_Ti;
        L_xxx_xRate    := get_xxxRate(P_From_Curr       => L_PMTs_Curr,
                                      P_To_Curr         => L_SOB_Curr,
                                      P_xRate_Ti        => L_xRate_TUi,
                                      P_Accounting_Date => L_xxx_xDate);
        L_xBase_Amount := Round(L_TPaid_Amount * L_xxx_xRate, L_Curr_Prii);
      End if;
    
      if L_TPaid_Amount < 0 Then
        L_PMTsTii_Flag := P_PMTsTii_FlagR;
      End if;
      if L_TPaid_Amount > 0 Then
        L_PMTsTii_Flag := P_PMTsTii_FlagQ;
      End if;
    
      Savepoint xxxRollBackA;
      if L_TPaid_Amount != 0 Then
        Begin
          ---- To Create the Checks.Update ap_checks_all
          ap_checks_pkg.Insert_Row(X_Rowid               => L_PMTs_RowsID,
                                   X_Org_Id              => xxp.org_id,
                                   X_Amount              => L_TPaid_Amount,
                                   X_CE_Bank_Acct_Use_Id => L_xxx_BankUseID,
                                   X_Bank_Account_Name   => xxp.bank_account_name,
                                   X_Bank_Account_Num    => xxp.bank_account_number,
                                   
                                   X_Vendor_Name      => xxp.vendor_name,
                                   X_Vendor_Site_Code => xxp.vendor_site_code,
                                   X_Vendor_Id        => xxp.vendor_id,
                                   X_Vendor_Site_Id   => xxp.vendor_site_id,
                                   x_party_id         => L_VParty_ID,
                                   x_party_site_id    => L_VParty_SiteID,
                                   
                                   X_Check_Date               => L_Accounting_Date,
                                   X_Future_Pay_Due_Date      => L_FuturePMT_dueDate,
                                   X_Check_Id                 => L_Check_ID,
                                   X_Check_Number             => L_Check_Num,
                                   X_Checkrun_Name            => L_Check_Name,
                                   X_External_Bank_Account_Id => L_xxx_BankAccID,
                                   x_legal_entity_id          => L_xxx_BankLEntiiiID,
                                   X_Currency_Code            => L_PMTs_Curr,
                                   
                                   X_Payment_Type_Flag   => L_PMTsTii_Flag,
                                   x_payment_method_code => xxp.pmt_method,
                                   x_payment_profile_id  => L_Profile_ID,
                                   x_payment_document_id => L_xxx_BankDocID,
                                   x_payment_id          => L_PMTx_ID,
                                   
                                   X_description        => L_Check_Name,
                                   X_Status_Lookup_Code => L_PMTsLookup_Code,
                                   X_Calling_Sequence   => 'APXPAWKB',
                                   
                                   --X_Cleared_Base_Amount        => xxp.pmt_amount,
                                   --X_Cleared_Exchange_Rate      => L_Null,
                                   --X_Cleared_Exchange_Date      => L_Null,
                                   --X_Cleared_Exchange_Rate_Type => 'User',
                                   X_Base_Amount        => L_xBase_Amount,
                                   X_Exchange_Rate      => L_xxx_xRate,
                                   X_Exchange_Date      => L_xxx_xDate,
                                   X_Exchange_Rate_Type => L_xRate_TUi,
                                   
                                   X_Created_By        => L_User_ID,
                                   X_Creation_Date     => SYSDATE,
                                   X_Last_Updated_By   => L_User_ID,
                                   X_Last_Update_Date  => SYSDATE,
                                   X_Last_Update_Login => fnd_global.LOGIN_ID);
        
        Exception
          when others then
            P_Suc_Flag := fnd_api.g_ret_sts_error;
            P_Suc_Log  := P_Suc_Log ||
                          dbms_utility.format_error_backtrace() || ':' ||
                          SQLERRM || P_Suc_Flag;
            dbms_output.put_line('L_Import_Flag-ap_checks_pkg :' ||
                                 SQLCODE);
            dbms_output.put_linE('L_Import_Flag-ap_checks_pkg :' ||
                                 substr(SQLERRM, 1, 150));
            dbms_output.put_linE('fnd_message.get is :' ||
                                 substr(fnd_message.get, 1, 150));
            Print_Logs('L_Import_Flag-ap_checks_pkg :' || SQLCODE);
            Print_Logs('L_Import_Flag-ap_checks_pkg :' ||
                       substr(SQLERRM, 1, 150));
            Print_Logs('L_Import_Flag-ap_checks_pkg :' ||
                       substr(fnd_message.get, 1, 150));
          
            L_Import_Flag := 'N';
            Print_Logs('L_xxx_BankUseID:' || L_xxx_BankUseID);
            Print_Logs('L_Check_ID:' || L_Check_ID);
            Print_Logs('L_Check_Num:' || L_Check_Num);
            Print_Logs('L_Check_Name:' || L_Check_Name);
            Print_Logs('L_xxx_BankAccID:' || L_xxx_BankAccID);
            Print_Logs('L_PMTx_ID:' || L_PMTx_ID);
        End;
      End if;
    
      Savepoint xxxRollBackB;
      if L_TPaid_Amount != 0 then
        BEGIN
          ---- To Create the History Record.Update ap_payment_history_all
          ap_reconciliation_pkg.insert_payment_history(x_check_id         => L_Check_ID,
                                                       x_transaction_type => L_PMTs_TrxTi,
                                                       x_accounting_date  => L_Accounting_Date,
                                                       --x_accounting_event_id     => L_PMTs_EventsID,
                                                       x_trx_bank_amount         => L_Null,
                                                       x_errors_bank_amount      => L_Null,
                                                       x_charges_bank_amount     => L_Null,
                                                       x_bank_currency_code      => L_Null,
                                                       x_bank_to_base_xrate_type => L_Null,
                                                       x_bank_to_base_xrate_date => L_Null,
                                                       x_bank_to_base_xrate      => L_Null,
                                                       x_errors_pmt_amount       => L_Null,
                                                       x_charges_pmt_amount      => L_Null,
                                                       
                                                       x_pmt_currency_code => L_PMTs_Curr,
                                                       x_trx_pmt_amount    => L_TPaid_Amount,
                                                       
                                                       x_pmt_to_base_xrate_type => L_xRate_TUi,
                                                       x_pmt_to_base_xrate_date => L_xxx_xDate,
                                                       x_pmt_to_base_xrate      => L_xxx_xRate,
                                                       x_trx_base_amount        => L_xBase_Amount,
                                                       
                                                       x_errors_base_amount  => NULL,
                                                       x_charges_base_amount => NULL,
                                                       x_matched_flag        => NULL,
                                                       x_rev_pmt_hist_id     => NULL,
                                                       
                                                       x_created_by        => L_User_ID,
                                                       x_creation_date     => SYSDATE,
                                                       x_last_updated_by   => L_User_ID,
                                                       x_last_update_date  => SYSDATE,
                                                       x_last_update_login => fnd_global.LOGIN_ID,
                                                       
                                                       x_program_update_date    => SYSDATE,
                                                       x_program_application_id => L_Appl_ID,
                                                       x_program_id             => L_Program_ID,
                                                       x_request_id             => L_Request_ID,
                                                       x_calling_sequence       => 'APXPAWKB (pay_sum_folder_pkg_i.insert_row)',
                                                       x_org_id                 => L_Org_ID);
        
        Exception
          when others then
            P_Suc_Flag := fnd_api.g_ret_sts_error;
            P_Suc_Log  := P_Suc_Log ||
                          dbms_utility.format_error_backtrace() || ':' ||
                          SQLERRM || P_Suc_Flag;
            dbms_output.put_line('L_Import_Flag-ap_reconciliation_pkg :' ||
                                 SQLCODE);
            dbms_output.put_linE('L_Import_Flag-ap_reconciliation_pkg :' ||
                                 SQLERRM);
            dbms_output.put_linE('fnd_message.get is :' || fnd_message.get);
            Print_Logs('L_Import_Flag-ap_reconciliation_pkg :' || SQLCODE);
            Print_Logs('L_Import_Flag-ap_reconciliation_pkg :' || SQLERRM);
            Print_Logs('L_Import_Flag-ap_reconciliation_pkg :' ||
                       fnd_message.get);
            L_Import_Flag := 'N';
            RollBack to xxxRollBackA;
        End;
      End if;
    
      if L_TPaid_Amount != 0 Then
        Begin
          select app.accounting_event_id
            into L_PMTs_EventsID
            from ap_payment_history_all app
           where app.org_id = L_Org_ID
             and app.check_id = L_Check_ID
             and app.transaction_type = L_PMTs_TrxTi;
        
          ap_pay_in_full_pkg.ap_create_payments(P_invoice_id_list => L_ivoii_List,
                                                
                                                P_payment_num_list    => L_Null,
                                                P_check_id            => L_Check_ID,
                                                P_payment_type_flag   => L_PMTsTii_Flag,
                                                P_payment_method      => xxp.pmt_method,
                                                P_ce_bank_acct_use_id => L_xxx_BankUseID,
                                                P_bank_account_num    => xxp.bank_account_number,
                                                P_bank_account_type   => L_Null,
                                                P_bank_num            => L_Null,
                                                P_check_date          => L_Accounting_Date,
                                                P_period_name         => L_TPName,
                                                
                                                P_currency_code      => L_PMTs_Curr,
                                                P_base_currency_code => L_SOB_Curr,
                                                P_exchange_rate      => L_xxx_xRate,
                                                P_exchange_rate_type => L_xRate_TUi,
                                                P_exchange_date      => L_xxx_xDate,
                                                
                                                P_checkrun_name          => L_Check_Name,
                                                P_doc_sequence_value     => L_Null,
                                                P_doc_sequence_id        => L_Null,
                                                P_take_discount          => 0,
                                                P_sys_auto_calc_int_flag => L_Null,
                                                P_auto_calc_int_flag     => L_Null,
                                                P_set_of_books_id        => L_SOB_ID,
                                                P_future_pay_ccid        => L_Null,
                                                P_last_updated_by        => L_User_ID,
                                                P_last_update_login      => fnd_global.LOGIN_ID,
                                                P_calling_sequence       => 'APXPAWKB',
                                                P_sequential_numbering   => fnd_profile.VALUE('UNIQUE:SEQ_NUMBERS'),
                                                P_accounting_event_id    => L_PMTs_EventsID,
                                                P_org_id                 => L_Org_ID);
        
          Print_Logs('L_Check_ID-FULLPMTs:' || L_Check_ID);
          Print_Logs('L_PMTSelect_ID:' || L_PMTSelect_ID);
          Print_Logs('L_Check_Num:' || L_Check_Num);
          Print_Logs('L_Check_Name:' || L_Check_Name);
          Print_Logs('L_TPaid_Amount :' || L_TPaid_Amount);
          Print_Logs('L_Inv_PMTxID:' || L_Inv_PMTxID);
          Print_Logs('L_PMTs_EventsID---- **** ---- **** ---- :' ||
                     L_PMTs_EventsID);
        
          Update xxx_ap_AutoInvs_selected xxi
             set xxi.pmt_status = L_PMTs_FlagY
           where xxi.pmtselect_id = L_PMTSelect_ID;
        
        Exception
          when others then
            P_Suc_Flag := fnd_api.g_ret_sts_error;
            P_Suc_Log  := P_Suc_Log ||
                          dbms_utility.format_error_backtrace() || ':' ||
                          SQLERRM || P_Suc_Flag;
            dbms_output.put_line('L_Import_Flag-ap_pay_in_full_pkg :' ||
                                 SQLCODE);
            dbms_output.put_line('L_Import_Flag-ap_pay_in_full_pkg :' ||
                                 SQLERRM);
            dbms_output.put_line('fnd_message.get is :' || fnd_message.get);
            Print_Logs('L_Import_Flag-ap_pay_in_full_pkg :' || SQLCODE);
            Print_Logs('L_Import_Flag-ap_pay_in_full_pkg :' || SQLERRM);
            Print_Logs('L_Import_Flag-ap_pay_in_full_pkg :' ||
                       fnd_message.get);
          
            RollBack to xxxRollBackB;
            RollBack to xxxRollBackA;
            L_Import_Flag := 'N';
          
        End;
      
      End if;
      ---- To Selected and PMT the iivoices.Loop and Update ap_invoice_payments_all
      /*For iis in xx_iiscdu(L_Org_ID, L_Invoii_ID) Loop      
        Exit When L_RemPMT_Amount <= 0;
        select ap_invoice_payments_s.nextval into L_Inv_PMTxID from dual;
      
        L_Paid_Amount := iis.amount_remaining;
        if L_RemPMT_Amount < L_Paid_Amount Then
          L_Paid_Amount := L_RemPMT_Amount;
        End if;
      
        L_PMTs_Num           := iis.payment_num;
        L_attribute_category := iis.attribute_category;
        L_atrrii_A           := iis.atrrii_a;      
      ---- ---- ----End Loop xx_iiscdu()
      End Loop;*/
    
      ---- ---- ---- To Update the Record.
      if L_Import_Flag = 'Y' Then
        L_ImportedS := L_ImportedS + 1;
        Update xxx_ap_AutoPMTs_selected xxp
           set xxp.check_id   = L_Check_ID,
               xxp.check_xnum = L_Check_Num,
               xxp.pmt_status = L_PMTs_FlagY
         Where Current Of xx_PMTs;
      End if;
      if L_Import_Flag = 'N' Then
        L_ImportedE := L_ImportedE + 1;
        Update xxx_ap_AutoPMTs_selected xxp
           set xxp.pmt_status = L_PMTs_FlagE
         Where Current Of xx_PMTs;
      
        Update xxx_ap_AutoInvs_selected xxi
           set xxi.pmt_status = L_PMTs_FlagE
         where xxi.pmtselect_id = L_PMTSelect_ID;
      End if;
      ---- ---- ---- To Update the Record.
      Print_Logs('L_Import_Flag ***-++++++++-***:' || L_Import_Flag);
    
    ---- ---- ----End Loop xx_PMTs()
    End Loop;
    Commit;
    L_All_Num := L_ImportedS + L_ImportedE;
    ---- ---- ---- ----
    dbms_output.put_line('L_All_Num :' || L_All_Num);
    dbms_output.put_line('L_ImportedS :' || L_ImportedS);
    dbms_output.put_line('L_ImportedE :' || L_ImportedE);
    Print_Logs('L_All_Num :' || L_All_Num);
    Print_Logs('L_ImportedS :' || L_ImportedS);
    Print_Logs('L_ImportedE :' || L_ImportedE);
    Print_Output('L_All_Num :' || L_All_Num);
    Print_Output('L_ImportedS :' || L_ImportedS);
    Print_Output('L_ImportedE :' || L_ImportedE);
  
  End Auto_FOPMTs;

  /*===========================================================
  ---- Procedure Name:    Auto_FOPMTs() Of FullPMTs. For Muti Installment
  ---- To Get the Amount From the invoii Of Remainning Amount.
  =============================================================*/
  Procedure Auto_FMPMTs(P_Suc_Flag Out Varchar2,
                        P_Suc_Log  Out Varchar2,
                        P_Batch_ID In Number,
                        P_Org_ID   In Number,
                        P_TPName   in varchar2,
                        P_PMT_Mode in varchar2) is
  
    L_Batch_ID          Number := P_Batch_ID;
    L_User_ID           Number := fnd_global.user_id;
    L_SOB_ID            Number := fnd_profile.value('GL_SET_OF_BKS_ID');
    L_Org_ID            Number := P_Org_ID;
    L_ii_OrgID          Number;
    L_iii_OrgID         number;
    L_Appl_ID           Number := fnd_global.Resp_Appl_ID;
    L_Request_ID        Number := fnd_global.conc_request_id;
    L_Program_ID        Number := fnd_global.conc_program_id;
    L_TPName            varchar2(7) := P_TPName;
    L_gl_TPName         varchar2(7);
    L_gl_Date           Date;
    L_Accounting_Date   Date;
    L_FuturePMT_dueDate Date;
  
    L_PMTs_RowsID  varchar2(2000);
    L_PMTs_TrxTi   varchar2(30) := 'PAYMENT CREATED';
    L_PMTsTii_Flag varchar2(2);
  
    L_xxx_BankUseID     Number;
    L_xxx_BankAccID     Number;
    L_xxx_BankDocID     Number;
    L_xxx_BankLEntiiiID Number;
    L_Invoii_ID         Number;
  
    L_SOB_Curr     varchar2(5);
    L_PMTs_Curr    varchar2(5);
    L_Curr_Prii    Number;
    L_xRate_Ti     varchar2(30);
    L_xRate_TUi    varchar2(30);
    L_xxx_xDate    Date;
    L_xxx_xRate    Number;
    L_xBase_Amount Number;
  
    L_VParty_ID     Number;
    L_VParty_SiteID Number;
  
    L_Check_ID   Number;
    L_Profile_ID Number;
    L_PMTx_ID    Number;
    L_Inv_PMTxID Number;
    L_Check_Num  varchar2(30);
    L_Check_Name varchar2(50);
    L_Null       varchar2(30);
  
    L_iisPaid_Amount Number;
    L_TPaid_Amount   Number;
    L_Check_Amount   Number;
    L_Diff_Amount    Number;
  
    L_Import_Flag        varchar2(2) := 'Y';
    L_PMTs_FlagY         varchar2(2) := 'Y';
    L_PMTs_FlagS         varchar2(2) := 'S';
    L_PMTs_FlagE         varchar2(2) := 'E';
    L_attribute_category varchar2(100);
    L_atrrii_A           varchar2(100);
  
    L_All_Num         Number := 0;
    L_AllChecks_Num   Number := 0;
    L_ImportedS       Number := 0;
    L_ImportedE       Number := 0;
    L_PMT_Mode        varchar2(4) := P_PMT_Mode;
    L_Conn_Char       varchar2(2) := ':';
    L_PMTsLookup_Code varchar2(20);
    L_Conn_Chariivois varchar2(2) := chr(32);
    L_Conn_Chariiscdu varchar2(2) := chr(32);
  
    L_ivoii_Num      Number;
    L_ivoii_xxx      DCAmount;
    L_PMTsNum_List   DCVarChar;
    L_PMTsivoii_List varchar2(5000);
  
    L_PMTSelect_ID  Number;
    L_PMTs_EventsID Number;
  
    Cursor xx_PMTs(P_Batch_ID in Number,
                   P_Org_ID   In Number,
                   P_TPName   in varchar2,
                   P_PMT_Mode in varchar2) is
      select *
        from xxx_ap_AutoPMTs_selected xip
       where xip.org_id = P_Org_ID
         and xip.period_name = P_TPName
         and xip.batch_id = P_Batch_ID
         and xip.check_id = -9999
         and xip.pmt_status <> 'Y'
         and xip.pmt_mode = P_PMT_Mode
         For Update Of xip.check_id, xip.check_xnum, xip.pmt_status;
  
    Cursor xx_iivois(P_Batch_ID     in Number,
                     P_PMTSelect_ID in Number,
                     P_Org_ID       In Number,
                     P_TPName       in varchar2,
                     P_PMTs_Curr    in varchar2,
                     P_PMT_Mode     in varchar2) is
      select *
        from xxx_ap_AutoInvs_selected xii
       where xii.org_id = P_Org_ID
         and xii.pmtselect_id = P_PMTSelect_ID
         and xii.period_name = P_TPName
         and xii.inv_curr = P_PMTs_Curr
         and xii.batch_id = P_Batch_ID
         and xii.pmt_status <> 'Y'
         and xii.pmt_mode = P_PMT_Mode
         For Update Of xii.pmt_status, xii.check_xnum;
  
    Cursor xx_iiscdu(P_Org_ID in Number, P_iivois_ID In Number) is
      select iis.invoice_id,
             iis.payment_num,
             iis.amount_remaining,
             iis.payment_method_lookup_code,
             iis.payment_priority,
             iis.payment_status_flag,
             iis.attribute_category,
             iis.attribute1 atrrii_A
      
        from ap_payment_schedules_all iis
       where iis.org_id = P_Org_ID
         and iis.invoice_id = P_iivois_ID
         and iis.payment_status_flag <> 'Y';
  
  Begin
  
    select app.base_currency_code, app.default_exchange_rate_type
      into L_SOB_Curr, L_xRate_Ti
      from ap_system_parameters_all app
     where app.org_id = L_Org_ID;
  
    select fnn.precision
      into L_Curr_Prii
      from fnd_currencies fnn
     where fnn.currency_code = L_SOB_Curr;
  
    ---- For Each PMTs Create the Checks.
    For xxp in xx_PMTs(L_Batch_ID, L_Org_ID, L_TPName, L_PMT_Mode) Loop
    
      L_ii_OrgID     := mo_global.get_current_org_id;
      L_iii_OrgID    := fnd_global.Org_ID;
      L_PMTSelect_ID := xxp.pmtselect_id;
    
      L_Accounting_Date   := xxp.pmt_date;
      L_FuturePMT_dueDate := xxp.FuturePMT_dueDate;
      ap_utilities_pkg.get_only_open_gl_date(L_Accounting_Date,
                                             L_gl_TPName,
                                             L_gl_Date,
                                             L_Org_ID);
    
      L_xxx_BankUseID     := get_BankUseID(L_Org_ID,
                                           xxp.bank_account_number);
      L_xxx_BankAccID     := get_BankAccID(L_Org_ID,
                                           xxp.bank_account_number);
      L_xxx_BankDocID     := get_BankDocID(L_xxx_BankAccID, xxp.pmt_doc);
      L_xxx_BankLEntiiiID := get_BankLEntiiiID(L_Org_ID,
                                               xxp.bank_account_number);
    
      L_PMTs_Curr := xxp.pmt_curr;
    
      ---- Set it=Blank
      L_xxx_xDate    := L_Null;
      L_xRate_TUi    := L_Null;
      L_xxx_xRate    := L_Null;
      L_xBase_Amount := L_Null;
    
      select iby_payments_all_s.nextval into L_PMTx_ID from dual;
      if xxp.pmt_method = 'WIRE' Then
        L_PMTsLookup_Code := P_WPMTsLookup_Code;
      End if;
      if xxp.pmt_method = 'CHECK' Then
        L_PMTsLookup_Code := P_CPMTsLookup_Code;
      End if;
    
      L_Check_Num := xxp.check_num;
      if L_Check_Num is null then
        L_Check_Num := to_Char(SYSTIMESTAMP, 'YYYYMMDDHH24MISSFF1');
      End if;
    
      L_AllChecks_Num := L_AllChecks_Num + 1;
      ---- ReVuale the L_Check_Num
      L_Check_Num := to_Char(SYSTIMESTAMP, 'YYYYMMDDHH24MISSFF1');
      /*L_Check_Num := to_Char(SYSTIMESTAMP, 'YYYYMMDD') ||
      LPAD(L_AllChecks_Num, 7, '0');*/
    
      select ap_checks_s.nextval INTO L_Check_ID from dual;
      L_Check_Name := L_Check_PName || L_Check_Auto_FMPMTs || L_Check_ID;
      select xx.payment_profile_id
        into L_Profile_ID
        from IBY_ACCT_PMT_PROFILES_B xx
       where xx.system_profile_code = xxp.pmt_profile;
    
      select v.VParty_ID, v.VParty_SiteID
        into L_VParty_ID, L_VParty_SiteID
        from xxx_STD_SupplierInfo_v v
       where v.org_id = xxp.org_id
         and v.vendor_id = xxp.vendor_id
         and v.vendor_SiteID = xxp.vendor_site_id;
    
      ---- to PMTs the Each iivoices.Loop
      L_TPaid_Amount := 0;
      L_ivoii_Num    := 0;
      L_Diff_Amount  := -9999;
      L_Check_Amount := xxp.pmt_amount;
    
      ----To Recalculate the Amount Ready to PMTs.
      For xxi in xx_iivois(P_Batch_ID     => L_Batch_ID,
                           P_PMTSelect_ID => L_PMTSelect_ID,
                           P_Org_ID       => L_Org_ID,
                           P_TPName       => L_TPName,
                           P_PMTs_Curr    => L_PMTs_Curr,
                           P_PMT_Mode     => L_PMT_Mode) Loop
      
        Exit when L_Diff_Amount = 0;
      
        L_Invoii_ID := xxi.invoice_id;
        L_ivoii_Num := L_ivoii_Num + 1;
        L_ivoii_xxx(L_ivoii_Num) := L_Invoii_ID;
      
        L_iisPaid_Amount := 0;
      
        L_PMTsNum_List(L_ivoii_Num) := Null;
        For iis in xx_iiscdu(L_Org_ID, L_Invoii_ID) Loop
          L_iisPaid_Amount := L_iisPaid_Amount + iis.amount_remaining;
        
          L_PMTsivoii_List := iis.payment_num || L_Conn_Chariivois ||
                              L_PMTsivoii_List;
        End Loop;
        ---- ---- ----End Loop xx_iiscdu()
      
        L_TPaid_Amount := L_TPaid_Amount + L_iisPaid_Amount;
        L_PMTsNum_List(L_ivoii_Num) := SUBSTR(L_PMTsivoii_List,
                                              1,
                                              LENGTH(L_PMTsivoii_List) - 1);
      
        if L_Check_Amount > 0 Then
          L_Diff_Amount := L_Check_Amount - L_TPaid_Amount +
                           abs(L_Check_Amount - L_TPaid_Amount);
        End if;
        if L_Check_Amount < 0 Then
          L_Diff_Amount := L_TPaid_Amount - L_Check_Amount +
                           abs(L_Check_Amount - L_TPaid_Amount);
        End if;
      
        Update xxx_ap_AutoInvs_selected xxi
           set xxi.check_xnum = L_Check_Num, xxi.pmt_status = L_PMTs_FlagS
         where Current Of xx_iivois;
      
      End Loop;
      --L_ivoii_List := SUBSTR(L_ivoii_List, 1, LENGTH(L_ivoii_List) - 1);
    
      if L_PMTs_Curr <> L_SOB_Curr Then
        L_xxx_xDate    := L_Accounting_Date;
        L_xRate_TUi    := L_xRate_Ti;
        L_xxx_xRate    := get_xxxRate(P_From_Curr       => L_PMTs_Curr,
                                      P_To_Curr         => L_SOB_Curr,
                                      P_xRate_Ti        => L_xRate_TUi,
                                      P_Accounting_Date => L_xxx_xDate);
        L_xBase_Amount := Round(L_TPaid_Amount * L_xxx_xRate, L_Curr_Prii);
      End if;
    
      Savepoint xxxRollBackA;
      if L_TPaid_Amount < 0 Then
        L_PMTsTii_Flag := P_PMTsTii_FlagR;
      End if;
      if L_TPaid_Amount > 0 Then
        L_PMTsTii_Flag := P_PMTsTii_FlagQ;
      End if;
    
      if L_TPaid_Amount != 0 Then
      
        Begin
          ---- To Create the Checks.Update ap_checks_all
          ap_checks_pkg.Insert_Row(X_Rowid               => L_PMTs_RowsID,
                                   X_Org_Id              => xxp.org_id,
                                   X_Amount              => L_TPaid_Amount,
                                   X_CE_Bank_Acct_Use_Id => L_xxx_BankUseID,
                                   X_Bank_Account_Name   => xxp.bank_account_name,
                                   X_Bank_Account_Num    => xxp.bank_account_number,
                                   
                                   X_Vendor_Name      => xxp.vendor_name,
                                   X_Vendor_Site_Code => xxp.vendor_site_code,
                                   X_Vendor_Id        => xxp.vendor_id,
                                   X_Vendor_Site_Id   => xxp.vendor_site_id,
                                   x_party_id         => L_VParty_ID,
                                   x_party_site_id    => L_VParty_SiteID,
                                   
                                   X_Check_Date               => L_Accounting_Date,
                                   X_Future_Pay_Due_Date      => L_FuturePMT_dueDate,
                                   X_Check_Id                 => L_Check_ID,
                                   X_Check_Number             => L_Check_Num,
                                   X_Checkrun_Name            => L_Check_Name,
                                   X_External_Bank_Account_Id => L_xxx_BankAccID,
                                   x_legal_entity_id          => L_xxx_BankLEntiiiID,
                                   X_Currency_Code            => L_PMTs_Curr,
                                   
                                   X_Payment_Type_Flag   => L_PMTsTii_Flag,
                                   x_payment_method_code => xxp.pmt_method,
                                   x_payment_profile_id  => L_Profile_ID,
                                   x_payment_document_id => L_xxx_BankDocID,
                                   x_payment_id          => L_PMTx_ID,
                                   
                                   X_description        => L_Check_Name,
                                   X_Status_Lookup_Code => L_PMTsLookup_Code,
                                   X_Calling_Sequence   => 'xxx_Auto_FMPMTs',
                                   
                                   --X_Cleared_Base_Amount        => xxp.pmt_amount,
                                   --X_Cleared_Exchange_Rate      => L_Null,
                                   --X_Cleared_Exchange_Date      => L_Null,
                                   --X_Cleared_Exchange_Rate_Type => 'User',
                                   X_Base_Amount        => L_xBase_Amount,
                                   X_Exchange_Rate      => L_xxx_xRate,
                                   X_Exchange_Date      => L_xxx_xDate,
                                   X_Exchange_Rate_Type => L_xRate_TUi,
                                   
                                   X_Created_By        => L_User_ID,
                                   X_Creation_Date     => SYSDATE,
                                   X_Last_Updated_By   => L_User_ID,
                                   X_Last_Update_Date  => SYSDATE,
                                   X_Last_Update_Login => fnd_global.LOGIN_ID);
        
        Exception
          when others then
            P_Suc_Flag := fnd_api.g_ret_sts_error;
            P_Suc_Log  := P_Suc_Log ||
                          dbms_utility.format_error_backtrace() || ':' ||
                          SQLERRM || P_Suc_Flag;
            dbms_output.put_line('L_Import_Flag-ap_checks_pkg :' ||
                                 SQLCODE);
            dbms_output.put_linE('L_Import_Flag-ap_checks_pkg :' ||
                                 substr(SQLERRM, 1, 150));
            dbms_output.put_linE('fnd_message.get is :' ||
                                 substr(fnd_message.get, 1, 150));
            Print_Logs('L_Import_Flag-ap_checks_pkg :' || SQLCODE);
            Print_Logs('L_Import_Flag-ap_checks_pkg :' ||
                       substr(SQLERRM, 1, 150));
            Print_Logs('L_Import_Flag-ap_checks_pkg :' ||
                       substr(fnd_message.get, 1, 150));
            L_Import_Flag := 'N';
            Print_Logs('L_xxx_BankUseID:' || L_xxx_BankUseID);
            Print_Logs('L_Check_ID:' || L_Check_ID);
            Print_Logs('L_Check_Num:' || L_Check_Num);
            Print_Logs('L_Check_Name:' || L_Check_Name);
            Print_Logs('L_xxx_BankAccID:' || L_xxx_BankAccID);
            Print_Logs('L_PMTx_ID:' || L_PMTx_ID);
        End;
      End if;
    
      Savepoint xxxRollBackB;
      if L_TPaid_Amount != 0 then
      
        BEGIN
          ---- To Create the History Record.Update ap_payment_history_all
          ap_reconciliation_pkg.insert_payment_history(x_check_id         => L_Check_ID,
                                                       x_transaction_type => L_PMTs_TrxTi,
                                                       x_accounting_date  => L_Accounting_Date,
                                                       --x_accounting_event_id     => L_PMTs_EventsID,
                                                       x_trx_bank_amount         => L_Null,
                                                       x_errors_bank_amount      => L_Null,
                                                       x_charges_bank_amount     => L_Null,
                                                       x_bank_currency_code      => L_Null,
                                                       x_bank_to_base_xrate_type => L_Null,
                                                       x_bank_to_base_xrate_date => L_Null,
                                                       x_bank_to_base_xrate      => L_Null,
                                                       x_errors_pmt_amount       => L_Null,
                                                       x_charges_pmt_amount      => L_Null,
                                                       
                                                       x_pmt_currency_code => L_PMTs_Curr,
                                                       x_trx_pmt_amount    => L_TPaid_Amount,
                                                       
                                                       x_pmt_to_base_xrate_type => L_xRate_TUi,
                                                       x_pmt_to_base_xrate_date => L_xxx_xDate,
                                                       x_pmt_to_base_xrate      => L_xxx_xRate,
                                                       x_trx_base_amount        => L_xBase_Amount,
                                                       
                                                       x_errors_base_amount  => NULL,
                                                       x_charges_base_amount => NULL,
                                                       x_matched_flag        => NULL,
                                                       x_rev_pmt_hist_id     => NULL,
                                                       
                                                       x_created_by        => L_User_ID,
                                                       x_creation_date     => SYSDATE,
                                                       x_last_updated_by   => L_User_ID,
                                                       x_last_update_date  => SYSDATE,
                                                       x_last_update_login => fnd_global.LOGIN_ID,
                                                       
                                                       x_program_update_date    => SYSDATE,
                                                       x_program_application_id => L_Appl_ID,
                                                       x_program_id             => L_Program_ID,
                                                       x_request_id             => L_Request_ID,
                                                       x_calling_sequence       => 'xxx_Auto_FMPMTs',
                                                       x_org_id                 => L_Org_ID);
        
        Exception
          when others then
            P_Suc_Flag := fnd_api.g_ret_sts_error;
            P_Suc_Log  := P_Suc_Log ||
                          dbms_utility.format_error_backtrace() || ':' ||
                          SQLERRM || P_Suc_Flag;
            dbms_output.put_line('L_Import_Flag-ap_reconciliation_pkg :' ||
                                 SQLCODE);
            dbms_output.put_linE('L_Import_Flag-ap_reconciliation_pkg :' ||
                                 SQLERRM);
            dbms_output.put_linE('fnd_message.get is :' || fnd_message.get);
            Print_Logs('L_Import_Flag-ap_reconciliation_pkg :' || SQLCODE);
            Print_Logs('L_Import_Flag-ap_reconciliation_pkg :' || SQLERRM);
            Print_Logs('L_Import_Flag-ap_reconciliation_pkg :' ||
                       fnd_message.get);
            L_Import_Flag := 'N';
            RollBack to xxxRollBackA;
        End;
      End if;
    
      if L_TPaid_Amount != 0 Then
        Begin
          select app.accounting_event_id
            into L_PMTs_EventsID
            from ap_payment_history_all app
           where app.org_id = L_Org_ID
             and app.check_id = L_Check_ID
             and app.transaction_type = L_PMTs_TrxTi;
        
          For i in 1 .. L_ivoii_Num Loop
            ap_pay_in_full_pkg.ap_create_payments(P_invoice_id_list     => L_ivoii_xxx(i),
                                                  P_payment_num_list    => L_PMTsNum_List(i),
                                                  P_check_id            => L_Check_ID,
                                                  P_payment_type_flag   => L_PMTsTii_Flag,
                                                  P_payment_method      => xxp.pmt_method,
                                                  P_ce_bank_acct_use_id => L_xxx_BankUseID,
                                                  P_bank_account_num    => xxp.bank_account_number,
                                                  P_bank_account_type   => L_Null,
                                                  P_bank_num            => L_Null,
                                                  P_check_date          => L_Accounting_Date,
                                                  P_period_name         => L_TPName,
                                                  
                                                  P_currency_code      => L_PMTs_Curr,
                                                  P_base_currency_code => L_SOB_Curr,
                                                  P_exchange_rate      => L_xxx_xRate,
                                                  P_exchange_rate_type => L_xRate_TUi,
                                                  P_exchange_date      => L_xxx_xDate,
                                                  
                                                  P_checkrun_name          => L_Check_Name,
                                                  P_doc_sequence_value     => L_Null,
                                                  P_doc_sequence_id        => L_Null,
                                                  P_take_discount          => 0,
                                                  P_sys_auto_calc_int_flag => L_Null,
                                                  P_auto_calc_int_flag     => L_Null,
                                                  P_set_of_books_id        => L_SOB_ID,
                                                  P_future_pay_ccid        => L_Null,
                                                  P_last_updated_by        => L_User_ID,
                                                  P_last_update_login      => fnd_global.LOGIN_ID,
                                                  P_calling_sequence       => 'xxx_Auto_FMPMTs',
                                                  P_sequential_numbering   => fnd_profile.VALUE('UNIQUE:SEQ_NUMBERS'),
                                                  P_accounting_event_id    => L_PMTs_EventsID,
                                                  P_org_id                 => L_Org_ID);
          
            Print_Logs('L_Check_ID-FULLPMTs:' || L_Check_ID);
            Print_Logs('L_PMTSelect_ID:' || L_PMTSelect_ID);
            Print_Logs('L_Check_Num:' || L_Check_Num);
            Print_Logs('L_Check_Name:' || L_Check_Name);
            Print_Logs('L_TPaid_Amount :' || L_TPaid_Amount);
            Print_Logs('L_Inv_PMTxID:' || L_Inv_PMTxID);
            Print_Logs('L_PMTs_EventsID---- **** ---- **** ---- :' ||
                       L_PMTs_EventsID);
          
            Update xxx_ap_AutoInvs_selected xxi
               set xxi.pmt_status = L_PMTs_FlagY
             where xxi.pmtselect_id = L_PMTSelect_ID;
            ----L_ivoii_Num Loop
          End Loop;
        Exception
          when others then
            P_Suc_Flag := fnd_api.g_ret_sts_error;
            P_Suc_Log  := P_Suc_Log ||
                          dbms_utility.format_error_backtrace() || ':' ||
                          SQLERRM || P_Suc_Flag;
            dbms_output.put_line('L_Import_Flag-ap_pay_in_full_pkg :' ||
                                 SQLCODE);
            dbms_output.put_line('L_Import_Flag-ap_pay_in_full_pkg :' ||
                                 SQLERRM);
            dbms_output.put_line('fnd_message.get is :' || fnd_message.get);
            Print_Logs('L_Import_Flag-ap_pay_in_full_pkg :' || SQLCODE);
            Print_Logs('L_Import_Flag-ap_pay_in_full_pkg :' || SQLERRM);
            Print_Logs('L_Import_Flag-ap_pay_in_full_pkg :' ||
                       fnd_message.get);
          
            RollBack to xxxRollBackB;
            RollBack to xxxRollBackA;
            L_Import_Flag := 'N';
          
        End;
      
      End if;
    
      ---- ---- ---- To Update the Record.
      if L_Import_Flag = 'Y' Then
        L_ImportedS := L_ImportedS + 1;
        Update xxx_ap_AutoPMTs_selected xxp
           set xxp.check_id   = L_Check_ID,
               xxp.check_xnum = L_Check_Num,
               xxp.pmt_status = L_PMTs_FlagY
         Where Current Of xx_PMTs;
      End if;
      if L_Import_Flag = 'N' Then
        L_ImportedE := L_ImportedE + 1;
        Update xxx_ap_AutoPMTs_selected xxp
           set xxp.pmt_status = L_PMTs_FlagE
         Where Current Of xx_PMTs;
      
        Update xxx_ap_AutoInvs_selected xxi
           set xxi.pmt_status = L_PMTs_FlagE
         where xxi.pmtselect_id = L_PMTSelect_ID;
      End if;
      ---- ---- ---- To Update the Record.
      Print_Logs('L_Import_Flag ***-++++++++-***:' || L_Import_Flag);
    
    ---- ---- ----End Loop xx_PMTs()
    End Loop;
    Commit;
    L_All_Num := L_ImportedS + L_ImportedE;
    ---- ---- ---- ----
    dbms_output.put_line('L_All_Num :' || L_All_Num);
    dbms_output.put_line('L_ImportedS :' || L_ImportedS);
    dbms_output.put_line('L_ImportedE :' || L_ImportedE);
    Print_Logs('L_All_Num :' || L_All_Num);
    Print_Logs('L_ImportedS :' || L_ImportedS);
    Print_Logs('L_ImportedE :' || L_ImportedE);
    Print_Output('L_All_Num :' || L_All_Num);
    Print_Output('L_ImportedS :' || L_ImportedS);
    Print_Output('L_ImportedE :' || L_ImportedE);
  
  End Auto_FMPMTs;
  /*===========================================================
  ---- Procedure Name:    xxxMain()
  ---- The Main Procedure Of This pkg.
  =============================================================*/
  Procedure xxxMain(P_Suc_Flag     Out Varchar2,
                    P_Suc_Log      Out Varchar2,
                    P_Org_ID       in Number,
                    P_TPName       in varchar2,
                    P_PMT_Mode     in varchar2,
                    P_FULLPMT_Flag in varchar2 Default P_FULLPMT_DFlag) is
  
    L_Suc_Log    varchar2(32000);
    L_Suc_Flag   varchar2(2);
    x_Request_ID Number;
  
    L_Org_ID         Number := P_Org_ID;
    L_TPName         varchar2(7) := P_TPName;
    L_Period_Opening Number;
    L_Start_Date     Date;
    L_End_Date       Date;
    L_Batch_ID       Number;
    L_PMT_Mode       varchar2(4) := P_PMT_Mode;
    L_FULLPMT_Flag   varchar2(4) := P_FULLPMT_Flag;
  
    Cursor xx_AccountingDate(P_Org_ID in Number) is
      select *
        from xxx_ap_AutoPMTs_iFace xxx
       where xxx.imported_status = 'I'
         and xxx.org_id = P_Org_ID
         For Update Of xxx.pmt_date;
  
  Begin
    ---- ---- ---- ---- Get the Org_ID
    if L_Org_ID is Null Or L_Org_ID <> fnd_global.Org_ID Then
      L_Org_ID := fnd_global.Org_ID;
    End If;
    if L_Org_ID is Null Then
      Print_Output('PLS Set the OU Of the Profile!');
    End if;
    Print_Logs('L_Org_ID:xxxxxx' || L_Org_ID);
  
    if L_FULLPMT_Flag is null Then
      L_FULLPMT_Flag := P_FULLPMT_DFlag;
    End if;
    Print_Logs('xxx_vFullPMTs_Flag:' || L_FULLPMT_Flag);
    ---- ---- ---- ---- To Check the Period and gl Accounting Date.
    select Sum(1)
      into L_Period_Opening
      from gl_period_statuses gps
     where gps.set_of_books_id = fnd_profile.value('GL_SET_OF_BKS_ID')
       and gps.application_id = fnd_global.resp_appl_id
       and gps.period_name = L_TPName
       and gps.adjustment_period_flag = 'N'
       and gps.closing_status = 'O';
  
    ---- ---- ---- ---- To Build The PMTs Data Info.
    if L_Period_Opening < 0 Then
      dbms_output.put_line('Then Periodx U Selected is Not Openning');
      Print_Logs('Then Periodx U Selected is Not Openning');
      Print_Output('Then Periodx U Selected is Not Openning');
    End if;
  
    if L_Period_Opening > 0 then
      select min(gdd.accounting_date), max(gdd.accounting_date)
        into L_Start_Date, L_End_Date
        from gl_ledgers gll, gl_date_period_map gdd
       where gll.ledger_id = fnd_profile.value('GL_SET_OF_BKS_ID')
         and gdd.period_set_name = gll.period_set_name
         and gdd.period_name = L_TPName;
    
      For xoo in xx_AccountingDate(L_Org_ID) Loop
        if xoo.pmt_date < L_Start_Date Or xoo.pmt_date > L_End_Date Then
          Update xxx_ap_AutoPMTs_iFace iii
             Set iii.pmt_date = L_End_Date
           Where Current Of xx_AccountingDate;
        End if;
      End Loop;
      Commit;
    
      if L_PMT_Mode = 'IS' Then
        Build_PMTISs(L_Batch_ID, L_Org_ID, L_TPName, L_PMT_Mode);
        Build_InvISs(L_Batch_ID, L_Org_ID, L_TPName, L_PMT_Mode);
      End if;
      if L_PMT_Mode = 'AS' Then
        Build_PMTASs(L_Batch_ID, L_Org_ID, L_TPName, L_PMT_Mode);
        Build_InvASs(L_Batch_ID, L_Org_ID, L_TPName, L_PMT_Mode);
      End if;
    
      if L_FULLPMT_Flag = 'P' Then
        Auto_PPMTs(L_Suc_Flag,
                   L_Suc_Log,
                   L_Batch_ID,
                   L_Org_ID,
                   L_TPName,
                   L_PMT_Mode);
      End if;
      if L_FULLPMT_Flag = 'FM' Then
        Auto_FMPMTs(L_Suc_Flag,
                    L_Suc_Log,
                    L_Batch_ID,
                    L_Org_ID,
                    L_TPName,
                    L_PMT_Mode);
      End if;
      if L_FULLPMT_Flag = 'FO' Then
        Auto_FOPMTs(L_Suc_Flag,
                    L_Suc_Log,
                    L_Batch_ID,
                    L_Org_ID,
                    L_TPName,
                    L_PMT_Mode);
      End if;
    
    End if;
    ---- ---- ---- ----    
    /*Submit_Request(P_TPName       => L_TPName,
    P_Rturn_Status => x_Rturn_Status,
    P_msg_Data     => x_msg_Data,
    P_Request_ID   => x_Request_ID);*/
  
    Print_Logs('L_Suc_Flag:' || L_Suc_Flag);
    Print_Logs('L_Suc_Log:' || L_Suc_Log);
  
  End xxxMain;

End xxx_STD_AP_AutoPMTs_pkg;
/
