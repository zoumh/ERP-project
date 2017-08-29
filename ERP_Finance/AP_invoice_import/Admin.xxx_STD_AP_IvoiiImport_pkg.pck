CREATE OR REPLACE Package xxx_STD_AP_IvoiiImport_pkg Is
  /*===============================================================
  *   Copyright (C) Doris ZOU
  * ===============================================================
  *    Program Name:   xxx_STD_AP_IvoiiImport_pkg
  *    Author      :   Doris ZOU
  *    Date        :   2013-02-28
  *    Purpose     :   Pl/Sql Html Report PKG
  *                    To Import the AP invoii info to the AP interface.
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
  P_AutoInvoii_PName varchar2(50) := 'AutoInvoiis@Doris.Com:';
  L_xxx_iHeaders     ap_invoices_interface%ROWTYPE;
  L_xxx_iLines       ap_invoice_lines_interface%ROWTYPE;
  P_Null             varchar2(3) := NULL;
  P_Imported_Source  varchar2(50) := 'MANUAL_IMPORTED';
  P_xxx_ITEM         varchar2(15) := 'ITEM';
  P_xxx_Tax          varchar2(15) := 'TAX';

  /*===========================================================
  ---- Procedure Name:    xxxMain()
  ---- The Main Procedure Of This pkg.
  =============================================================*/
  Procedure xxxMain(P_msg_Data  Out Varchar2,
                    P_msg_Count Out Number,
                    P_Com_Code  in varchar2,
                    P_TPName    in varchar2);

End xxx_STD_AP_IvoiiImport_pkg;
/
CREATE OR REPLACE Package Body xxx_STD_AP_IvoiiImport_pkg Is
  /*===============================================================
  *   Copyright (C) Doris ZOU
  * ===============================================================
  *    Program Name:   xxx_STD_AP_IvoiiImport_pkg
  *    Author      :   Doris ZOU
  *    Date        :   2013-02-28
  *    Purpose     :   Pl/Sql Html Report PKG
  *                    To Import the AP invoii info to the AP interface.
  *
  *    Update History
  *    Version    Date          Name                              Description
  *    --------  ----------  ----------------------------------  --------------------
  *     V1.0     2013-02-28     Doris ZOU.         Creation
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
  ---- Function Name:    get_TaxRate_ID()
  ---- To get the get_TaxRate_ID.
  =============================================================*/
  Function get_TaxRate_ID(P_TaxRate_Code in varchar2) Return Number is
  
    L_TaxRate_Code varchar2(150);
    L_TaxRate_ID   Number;
  
  Begin
  
    L_TaxRate_Code := P_TaxRate_Code;
    Begin
    
      select zbb.tax_rate_id
        into L_TaxRate_ID
        from zx_rates_b zbb
       where zbb.tax_rate_code = L_TaxRate_Code;
    
    EXCEPTION
      WHEN OTHERS THEN
        Print_Output('The L_TaxRate_Code of xxxx is Not Exsited Or Double!');
        Print_Logs('The L_TaxRate_Code of xxxx is Not Exsited Or Double!!');
        L_TaxRate_ID := -9999;
    END;
  
    Return(L_TaxRate_ID);
  End get_TaxRate_ID;

  /*===========================================================
  ---- Procedure Name:    get_SuppID()
  ---- To get the Supplier ID and Site ID Info.
  =============================================================*/
  Procedure get_SuppID(x_Vendor_ID       Out Number,
                       x_Vendor_SiteID   Out Number,
                       P_Org_ID          in Number,
                       P_Vendor_Name     in varchar2,
                       P_Vendor_Number   in varchar2,
                       P_Vendor_SiteCode in varchar2) IS
  
    L_Org_ID          Number;
    L_Vendor_ID       Number;
    L_Vendor_SiteID   Number;
    L_Vendor_Name     varchar2(250);
    L_Vendor_Number   varchar2(50);
    L_Vendor_SiteCode varchar2(50);
  
  Begin
  
    L_Org_ID          := P_Org_ID;
    L_Vendor_Name     := P_Vendor_Name;
    L_Vendor_Number   := P_Vendor_Number;
    L_Vendor_SiteCode := P_Vendor_SiteCode;
  
    Begin
      select x.vendor_id, x.vendor_SiteID
        into L_Vendor_ID, L_Vendor_SiteID
        from xxx_STD_SupplierInfo_v x
       where x.org_id = L_Org_ID
         and x.sup_name = L_Vendor_Name
         and x.VendorSite_Code = L_Vendor_SiteCode
         and x.sup_num = L_Vendor_Number
         and x.enable_flag = 'Y';
    
    EXCEPTION
      WHEN OTHERS THEN
        Print_Output('The L_Vendor_Name of Suppliers is Not Exsited Or Double!');
        Print_Logs('The L_Vendor_Name of Suppliers is Not Exsited Or Double!');
        L_Vendor_ID     := -9999;
        L_Vendor_SiteID := -9999;
    END;
    x_Vendor_ID     := L_Vendor_ID;
    x_Vendor_SiteID := L_Vendor_SiteID;
  
  End get_SuppID;

  /*===========================================================
  ---- Procedure Name:    Build_InvoiiHeader()
  ---- To Build the invoii Header info.
  =============================================================*/
  Procedure Build_InvoiiHeader(P_Batch_ID Out Number,
                               P_Org_ID   in Number,
                               P_Com_Code in varchar2,
                               P_TPName   in varchar2) IS
  
    Cursor xxx_iHeaders(P_Batch_ID In Number,
                        P_Org_ID   in Number,
                        P_Com_Code in varchar2,
                        P_TPName   in varchar2) is
      select distinct xii.org_id,
                      nvl(xii.batch_number, '-9999') batch_number,
                      xii.com_code,
                      xii.period_name,
                      xii.invoii_tii,
                      xii.invoice_num,
                      xii.invoii_curr,
                      xii.invoiiheader_amount,
                      xii.invoiiitax_amount,
                      xii.invoii_date,
                      xii.invoii_gl_date,
                      xii.supp_name,
                      xii.supp_number,
                      xii.supp_sitecode,
                      xii.withhold_taxcode,
                      xii.pmts_terms,
                      xii.pmts_method,
                      xii.pmts_group
        from xxx_STD_AP_IvoiiImport_iFace xii
       where xii.batch_id = P_Batch_ID
         and xii.org_id = P_Org_ID
         and xii.com_code = P_Com_Code
         and xii.period_name = P_TPName
         and xii.imported_flag = 'I';
  
    L_Org_ID   Number;
    L_Com_Code varchar2(15);
    L_Batch_ID Number;
    L_TPName   varchar2(15);
  
    L_Imported_Flag varchar2(2) := 'I';
  
    L_Vendor_ID      Number;
    L_Vendor_SiteID  Number;
    L_Invoii_iFaceID Number;
    L_WithHold_TaxID Number;
    L_PMTsTerms_ID   Number;
  
  Begin
    L_Org_ID   := P_Org_ID;
    L_Com_Code := P_Com_Code;
    L_TPName   := P_TPName;
    L_Batch_ID := xxx_BatchID_s.Nextval;
    P_Batch_ID := L_Batch_ID;
  
    Update xxx_STD_AP_IvoiiImport_iFace xii
       set xii.batch_id = L_Batch_ID
     where xii.org_id = L_Org_ID
       and xii.period_name = L_TPName
       and xii.batch_id is null;
    Commit;
  
    Print_Logs('L_Org_ID:' || L_Org_ID);
    Print_Logs('L_Com_Code:' || L_Com_Code);
    Print_Logs('L_Batch_ID:' || L_Batch_ID);
    Print_Logs('L_TPName:' || L_TPName);
  
    For xxh in xxx_iHeaders(L_Batch_ID, L_Org_ID, L_Com_Code, L_TPName) Loop
    
      get_SuppID(x_Vendor_ID       => L_Vendor_ID,
                 x_Vendor_SiteID   => L_Vendor_SiteID,
                 P_Org_ID          => L_Org_ID,
                 P_Vendor_Name     => xxh.supp_name,
                 P_Vendor_Number   => xxh.supp_number,
                 P_Vendor_SiteCode => xxh.supp_sitecode);
    
      select agg.group_id
        into L_WithHold_TaxID
        from ap_awt_groups agg
       where agg.name = xxh.withhold_taxcode;
      select att.term_id
        into L_PMTsTerms_ID
        from ap_terms_tl att
       where att.name = xxh.pmts_terms;
    
      select ap_invoices_interface_s.nextval
        into L_Invoii_iFaceID
        from dual;
    
      Insert into xxx_STD_AP_IvoiiImport_Headers
        select L_Org_ID,
               L_Batch_ID,
               xxh.batch_number,
               L_Com_Code,
               L_TPName,
               xxh.invoii_tii,
               L_Invoii_iFaceID,
               xxh.invoice_num,
               P_Null,
               xxh.invoii_curr,
               xxh.invoiiheader_amount,
               xxh.invoiiitax_amount,
               xxh.invoii_date,
               xxh.invoii_gl_date,
               xxh.supp_name,
               xxh.supp_number,
               xxh.supp_sitecode,
               L_Vendor_ID,
               L_Vendor_SiteID,
               xxh.withhold_taxcode,
               L_WithHold_TaxID,
               xxh.pmts_terms,
               L_PMTsTerms_ID,
               xxh.pmts_method,
               xxh.pmts_group,
               L_Imported_Flag,
               
               fnd_global.user_id,
               SYSDATE,
               fnd_global.user_id,
               SYSDATE,
               fnd_global.login_id
          from dual;
    End Loop;
    Commit;
  End Build_InvoiiHeader;

  /*===========================================================
  ---- Procedure Name:    Build_InvoiiLine()
  ---- To Build the invoii Lines info.
  =============================================================*/
  Procedure Build_InvoiiLine(P_Batch_ID in Number,
                             P_Org_ID   in Number,
                             P_Com_Code in varchar2,
                             P_TPName   in varchar2) IS
  
    Cursor xxx_iLines(P_Batch_ID In Number,
                      P_Org_ID   in Number,
                      P_Com_Code in varchar2,
                      P_TPName   in varchar2) is
    
      select xii.*,
             xhh.batch_number batch_num,
             xhh.invoii_ifaceid,
             xhh.withhold_taxid
        from xxx_STD_AP_IvoiiImport_iFace   xii,
             xxx_STD_AP_IvoiiImport_Headers xhh
       where xii.batch_id = P_Batch_ID
         and xii.batch_id = xhh.batch_id
         and xii.supp_name = xhh.supp_name
         and xii.supp_number = xhh.supp_number
         and xii.supp_sitecode = xhh.supp_sitecode
         and xii.invoice_num = xhh.invoice_num
         and xii.org_id = P_Org_ID
         and xii.com_code = P_Com_Code
         and xii.period_name = P_TPName
         and xii.imported_flag = 'I';
  
    Cursor xxx_iTLines(P_Batch_ID In Number,
                       P_Org_ID   in Number,
                       P_Com_Code in varchar2,
                       P_TPName   in varchar2) is
    
      select xii.org_id,
             xii.batch_id,
             xii.invoice_num,
             xii.com_code,
             xii.period_name,
             xii.invoii_curr,
             xii.invoii_tii,
             xii.taxvat_code,
             xii.taxvat_rate,
             xii.withhold_taxcode,
             xii.supp_number,
             xii.supp_sitecode,
             Sum(xii.l_invoiiline_amount) l_invoiiline_amount,
             Sum(xii.l_invoiilinetax_amount) l_invoiilinetax_amount,
             xhh.batch_number batch_num,
             xhh.invoii_ifaceid,
             xhh.withhold_taxid,
             xhh.invoii_gl_date
        from xxx_STD_AP_IvoiiImport_iFace   xii,
             xxx_STD_AP_IvoiiImport_Headers xhh
       where xii.batch_id = P_Batch_ID
         and xii.batch_id = xhh.batch_id
         and xii.supp_name = xhh.supp_name
         and xii.supp_number = xhh.supp_number
         and xii.supp_sitecode = xhh.supp_sitecode
         and xii.invoice_num = xhh.invoice_num
         and xii.org_id = P_Org_ID
         and xii.com_code = P_Com_Code
         and xii.period_name = P_TPName
         and xii.imported_flag = 'I'
         and xii.taxvat_code is NOT null
       Group by xii.org_id,
                xii.batch_id,
                xii.invoice_num,
                xii.com_code,
                xii.taxvat_rate,
                xii.withhold_taxcode,
                xii.supp_number,
                xii.supp_sitecode,
                xii.period_name,
                xii.invoii_curr,
                xii.invoii_tii,
                xii.taxvat_code,
                xhh.batch_number,
                xhh.invoii_ifaceid,
                xhh.withhold_taxid,
                xhh.invoii_gl_date;
  
    L_Batch_ID Number := P_Batch_ID;
    L_Org_ID   Number := P_Org_ID;
    L_Com_Code varchar2(15) := P_Com_Code;
    L_TPName   varchar2(15) := P_TPName;
  
    L_COA_Code         varchar2(1000);
    L_COA_ID           Number;
    L_CCID             Number;
    L_KFF_Code         varchar2(20) := 'GL#';
    L_Delimiter_Limits varchar2(5);
  
    L_Invoii_iFaceLineID Number;
    L_SInvoiiLine_Num    Number;
    L_MInvoiiLine_Num    Number;
    L_Imported_Flag      varchar2(2) := 'I';
  
  Begin
  
    select gld.chart_of_accounts_id
      into L_COA_ID
      From ap_system_parameters_all apa, gl_ledgers gld
     where apa.set_of_books_id = gld.ledger_id
       and apa.org_id = L_Org_ID;
    select fii.concatenated_segment_delimiter
      into L_Delimiter_Limits
      from fnd_id_flex_structures fii
     where fii.id_flex_num = L_COA_ID
       and fii.id_flex_code = L_KFF_Code
       and fii.application_id = 101;
  
    For xxl in xxx_iLines(L_Batch_ID, L_Org_ID, L_Com_Code, L_TPName) Loop
    
      L_COA_Code := xxl.gl_coa_code;
      L_CCID     := xxx_commonchecking_pkg.get_CCID(L_COA_ID, L_COA_Code);
      if L_CCID < 0 Then
        L_COA_Code := xxl.segment1 || L_Delimiter_Limits || xxl.segment2 ||
                      L_Delimiter_Limits || xxl.segment3 ||
                      L_Delimiter_Limits || xxl.segment4 ||
                      L_Delimiter_Limits || xxl.segment5 ||
                      L_Delimiter_Limits || xxl.segment6 ||
                      L_Delimiter_Limits || xxl.segment7 ||
                      L_Delimiter_Limits || xxl.segment8 ||
                      L_Delimiter_Limits || xxl.segment9;
        L_CCID     := xxx_commonchecking_pkg.get_CCID(L_COA_ID, L_COA_Code);
      End if;
      if L_CCID < 0 Then
        L_CCID := -9999;
      End if;
    
      select ap_invoice_lines_interface_s.nextval
        into L_Invoii_iFaceLineID
        from dual;
      Insert into xxx_STD_AP_IvoiiImport_Lines
        select L_Org_ID,
               L_Batch_ID,
               xxl.batch_num,
               L_Com_Code,
               L_TPName,
               xxl.invoii_tii,
               P_xxx_ITEM,
               xxl.invoice_num,
               xxl.invoii_ifaceid,
               L_Invoii_iFaceLineID,
               xxl.invoii_curr,
               xxl.invoiiheader_amount,
               xxl.invoiiitax_amount,
               xxl.invoii_gl_date,
               xxl.withhold_taxcode,
               xxl.withhold_taxid,
               xxl.taxvat_code,
               xxx_commonchecking_pkg.get_TaxRate_ID(xxl.taxvat_code),
               xxl.taxvat_rate,
               xxl.l_invoiiline_number,
               L_COA_Code,
               L_CCID,
               xxl.segment1,
               xxl.segment2,
               xxl.segment3,
               xxl.segment4,
               xxl.segment5,
               xxl.segment6,
               xxl.segment7,
               xxl.segment8,
               xxl.segment9,
               xxl.l_invoiiline_amount,
               xxl.l_invoiilinetax_amount,
               L_Imported_Flag,
               
               fnd_global.user_id,
               SYSDATE,
               fnd_global.user_id,
               SYSDATE,
               fnd_global.login_id
          from dual;
    End Loop;
  
    For xxTl in xxx_iTLines(L_Batch_ID, L_Org_ID, L_Com_Code, L_TPName) Loop
      L_SInvoiiLine_Num := 0;
      L_MInvoiiLine_Num := 0;
    
      select Sum(1)
        into L_SInvoiiLine_Num
        from xxx_STD_AP_IvoiiImport_iFace iix
       where iix.org_id = xxTl.org_id
         and iix.batch_id = xxTl.batch_id
         and iix.invoice_num = xxTl.invoice_num
         and iix.supp_number = xxTl.supp_number
         and iix.supp_sitecode = xxTl.supp_sitecode;
    
      select max(iix.l_invoiiline_number)
        into L_MInvoiiLine_Num
        from xxx_STD_AP_IvoiiImport_iFace iix
       where iix.org_id = xxTl.org_id
         and iix.batch_id = xxTl.batch_id
         and iix.invoice_num = xxTl.invoice_num
         and iix.supp_number = xxTl.supp_number
         and iix.supp_sitecode = xxTl.supp_sitecode
         and iix.taxvat_code = xxTl.Taxvat_Code;
    
      select ap_invoice_lines_interface_s.nextval
        into L_Invoii_iFaceLineID
        from dual;
      Insert into xxx_STD_AP_IvoiiImport_Lines
        select L_Org_ID,
               L_Batch_ID,
               xxTl.batch_num,
               L_Com_Code,
               L_TPName,
               xxTl.invoii_tii,
               P_xxx_Tax,
               xxTl.invoice_num,
               xxTl.invoii_ifaceid,
               L_Invoii_iFaceLineID,
               xxTl.invoii_curr,
               xxTl.l_invoiiline_amount * xxTl.taxvat_rate / 100,
               xxTl.l_invoiiline_amount * xxTl.taxvat_rate / 100,
               xxTl.invoii_gl_date,
               xxTl.withhold_taxcode,
               xxTl.withhold_taxid,
               xxTl.taxvat_code,
               xxx_commonchecking_pkg.get_TaxRate_ID(xxTl.taxvat_code),
               xxTl.taxvat_rate,
               L_MInvoiiLine_Num + L_SInvoiiLine_Num,
               P_Null,
               P_Null,
               P_Null,
               P_Null,
               P_Null,
               P_Null,
               P_Null,
               P_Null,
               P_Null,
               P_Null,
               P_Null,
               xxTl.l_invoiiline_amount * xxTl.taxvat_rate / 100,
               xxTl.l_invoiiline_amount * xxTl.taxvat_rate / 100,
               L_Imported_Flag,
               
               fnd_global.user_id,
               SYSDATE,
               fnd_global.user_id,
               SYSDATE,
               fnd_global.login_id
          from dual;
    End Loop xxTl;
  
    Commit;
  End Build_InvoiiLine;

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
  ---- Procedure Name:    iFaceAutoTax()
  ---- To AutoCalculate the VAT Tax.
  ---- CALC_TAX_DURING_IMPORT_FLAG=Y
  ---- ADD_TAX_TO_INV_AMT_FLAG=Y
  =============================================================*/
  Procedure iFaceAutoTaxYY(P_Batch_ID In Number,
                           P_Org_ID   in Number,
                           P_Com_Code in varchar2,
                           P_TPName   in varchar2) IS
  
    Cursor iHeaders(P_Batch_ID In Number,
                    P_Org_ID   in Number,
                    P_Com_Code in varchar2,
                    P_TPName   in varchar2) is
      select *
        from xxx_STD_AP_IvoiiImport_Headers iH
       where iH.Batch_ID = P_Batch_ID
         and iH.Org_ID = P_Org_ID
         and iH.Com_Code = P_Com_Code
         and iH.Period_Name = P_TPName
         and iH.Imported_Flag = 'I'
         For Update Of iH.Imported_Flag, iH.Invoice_Xnum;
  
    Cursor iLines(P_Batch_ID In Number,
                  --P_iHeaders_ID in Number,
                  P_Org_ID   in Number,
                  P_Com_Code in varchar2,
                  P_TPName   in varchar2) is
      select *
        from xxx_STD_AP_IvoiiImport_Lines iL
       where iL.Batch_ID = P_Batch_ID
            --and iL.Invoii_iFaceID = P_iHeaders_ID
         and iL.Org_ID = P_Org_ID
         and iL.Com_Code = P_Com_Code
         and iL.Period_Name = P_TPName
         and iL.Invoii_Linetii = P_xxx_ITEM
         and iL.Imported_Flag = 'I'
         For Update Of iL.Imported_Flag;
  
    L_Org_ID   Number := P_Org_ID;
    L_Com_Code varchar2(15) := P_Com_Code;
    L_Batch_ID Number := P_Batch_ID;
    L_TPName   varchar2(15) := P_TPName;
  
    L_Imported_FlagY varchar2(2) := 'Y';
    L_xxx_FlagY      varchar2(2) := 'Y';
  
    L_SOB_Curr        varchar2(5);
    L_PMTs_Curr       varchar2(5);
    L_Curr_Prii       Number;
    L_xRate_Ti        varchar2(30);
    L_xRate_TUi       varchar2(30);
    L_xxx_xDate       Date;
    L_Accounting_Date Date;
    L_xxx_xRate       Number;
    L_Invoii_Amount   Number;
    L_xBase_Amount    Number;
    L_xxi_Amount      Number;
    L_xxii_Amount     Number;
    L_Invoii_Num      varchar2(30);
    L_AWT_GroupName   varchar2(30);
    L_AWT_GroupID     Number;
  
    L_AutoInvoii_PName varchar2(100);
  
  Begin
  
    select app.base_currency_code, app.default_exchange_rate_type
      into L_SOB_Curr, L_xRate_Ti
      from ap_system_parameters_all app
     where app.org_id = L_Org_ID;
  
    select fnn.precision
      into L_Curr_Prii
      from fnd_currencies fnn
     where fnn.currency_code = L_SOB_Curr;
  
    For iiHeaders in iHeaders(L_Batch_ID, L_Org_ID, L_Com_Code, L_TPName) Loop
    
      L_AutoInvoii_PName := P_AutoInvoii_PName || iiHeaders.invoii_ifaceid;
      L_xxx_xDate        := P_Null;
      L_xRate_TUi        := P_Null;
      L_xxx_xRate        := P_Null;
      L_xBase_Amount     := P_Null;
    
      L_PMTs_Curr       := iiHeaders.invoii_curr;
      L_Accounting_Date := iiHeaders.invoii_gl_date;
      --Exclusive Tax Amount
      L_Invoii_Amount := iiHeaders.Invoiiheader_Amount;
      L_xxi_Amount    := Round(L_Invoii_Amount, L_Curr_Prii);
      L_Invoii_Num    := to_Char(SYSTIMESTAMP, 'YYYYMMDDHH24MISSFF4');
    
      L_AWT_GroupName := iiHeaders.withhold_taxcode;
      L_AWT_GroupID   := iiHeaders.withhold_taxid;
    
      if L_PMTs_Curr <> L_SOB_Curr Then
        L_xxx_xDate     := L_Accounting_Date;
        L_xRate_TUi     := L_xRate_Ti;
        L_xxx_xRate     := xxx_commonchecking_pkg.get_xxx_Rate(P_From_Curr       => L_PMTs_Curr,
                                                               P_To_Curr         => L_SOB_Curr,
                                                               P_xRate_Ti        => L_xRate_TUi,
                                                               P_Accounting_Date => L_xxx_xDate);
        L_xBase_Amount  := Round(L_Invoii_Amount * L_xxx_xRate, L_Curr_Prii);
        L_xxii_Amount   := Round(L_xBase_Amount, L_Curr_Prii);
        L_AWT_GroupName := P_Null;
        L_AWT_GroupID   := P_Null;
      End if;
    
      L_xxx_iHeaders.org_id     := iiHeaders.org_id;
      L_xxx_iHeaders.invoice_id := iiHeaders.invoii_ifaceid;
      --L_xxx_iHeaders.invoice_num              := iiHeaders.invoice_num;
      L_xxx_iHeaders.invoice_num              := L_Invoii_Num;
      L_xxx_iHeaders.invoice_type_lookup_code := iiHeaders.invoii_tii;
      L_xxx_iHeaders.invoice_currency_code    := iiHeaders.invoii_curr;
      L_xxx_iHeaders.exchange_rate_type       := L_xRate_TUi;
      L_xxx_iHeaders.exchange_date            := L_xxx_xDate;
      L_xxx_iHeaders.exchange_rate            := L_xxx_xRate;
      L_xxx_iHeaders.invoice_amount           := L_xxi_Amount;
      L_xxx_iHeaders.invoice_date             := iiHeaders.invoii_date;
      L_xxx_iHeaders.gl_date                  := L_Accounting_Date;
      L_xxx_iHeaders.vendor_id                := iiHeaders.supp_id;
      L_xxx_iHeaders.vendor_site_id           := iiHeaders.supp_siteid;
      L_xxx_iHeaders.vendor_name              := iiHeaders.supp_name;
      L_xxx_iHeaders.vendor_num               := iiHeaders.supp_number;
      L_xxx_iHeaders.vendor_site_code         := iiHeaders.supp_sitecode;
      L_xxx_iHeaders.awt_group_name           := L_AWT_GroupName;
      L_xxx_iHeaders.awt_group_id             := L_AWT_GroupID;
      L_xxx_iHeaders.terms_name               := iiHeaders.pmts_terms;
      L_xxx_iHeaders.terms_id                 := iiHeaders.pmtsterms_id;
      L_xxx_iHeaders.terms_date               := iiHeaders.invoii_date;
      L_xxx_iHeaders.payment_method_code      := iiHeaders.pmts_method;
      L_xxx_iHeaders.pay_group_lookup_code    := iiHeaders.pmts_group;
    
      ---- ---- Auto Caculate the Tax and SO the Flag marked Y.
      L_xxx_iHeaders.calc_tax_during_import_flag := L_xxx_FlagY;
      L_xxx_iHeaders.add_tax_to_inv_amt_flag     := L_xxx_FlagY;
      L_xxx_iHeaders.group_id                    := iiHeaders.batch_id;
      L_xxx_iHeaders.description                 := L_AutoInvoii_PName;
      L_xxx_iHeaders.source                      := P_Imported_Source;
    
      L_xxx_iHeaders.request_id        := fnd_global.conc_request_id;
      L_xxx_iHeaders.created_by        := fnd_global.user_id;
      L_xxx_iHeaders.creation_date     := SYSDATE;
      L_xxx_iHeaders.last_updated_by   := fnd_global.user_id;
      L_xxx_iHeaders.last_update_date  := SYSDATE;
      L_xxx_iHeaders.last_update_login := fnd_global.login_id;
    
      insert into ap_invoices_interface VALUES L_xxx_iHeaders;
      Update xxx_STD_AP_IvoiiImport_Headers xxx
         set xxx.imported_flag = L_Imported_FlagY,
             xxx.invoice_xnum  = L_Invoii_Num
       Where Current Of iHeaders;
      ---- ---- ---- ----End Loop the Invoii Headers
    End Loop iiHeaders;
  
    For iiLines in iLines(L_Batch_ID, L_Org_ID, L_Com_Code, L_TPName) Loop
    
      L_AutoInvoii_PName := P_AutoInvoii_PName ||
                            iiLines.Invoii_Ifacelineid;
      L_Invoii_Amount    := iiLines.Invoiiheader_Amount;
      L_xxi_Amount       := Round(L_Invoii_Amount, L_Curr_Prii);
    
      L_PMTs_Curr     := iiLines.Invoii_Curr;
      L_AWT_GroupName := iiLines.withhold_taxcode;
      L_AWT_GroupID   := iiLines.withhold_taxid;
      if L_PMTs_Curr <> L_SOB_Curr Then
        L_AWT_GroupName := P_Null;
        L_AWT_GroupID   := P_Null;
      End if;
    
      L_xxx_iLines.ORG_ID                := iiLines.Org_ID;
      L_xxx_iLines.invoice_id            := iiLines.Invoii_Ifaceid;
      L_xxx_iLines.invoice_line_id       := iiLines.Invoii_Ifacelineid;
      L_xxx_iLines.line_number           := iiLines.L_Invoiiline_Number;
      L_xxx_iLines.line_type_lookup_code := iiLines.Invoii_Linetii;
      L_xxx_iLines.amount                := L_xxi_Amount;
      L_xxx_iLines.accounting_date       := iiLines.Invoiiline_GL_Date;
    
      L_xxx_iLines.dist_code_concatenated   := iiLines.GL_Coa_Code;
      L_xxx_iLines.dist_code_combination_id := iiLines.GL_CCID;
      L_xxx_iLines.default_dist_ccid        := iiLines.GL_CCID;
      L_xxx_iLines.awt_group_name           := L_AWT_GroupName;
      L_xxx_iLines.awt_group_id             := L_AWT_GroupID;
      L_xxx_iLines.tax_classification_code  := iiLines.Taxvat_Code;
    
      L_xxx_iLines.description := L_AutoInvoii_PName;
    
      L_xxx_iLines.created_by        := fnd_global.user_id;
      L_xxx_iLines.creation_date     := SYSDATE;
      L_xxx_iLines.last_updated_by   := fnd_global.user_id;
      L_xxx_iLines.last_update_date  := SYSDATE;
      L_xxx_iLines.last_update_login := fnd_global.login_id;
    
      insert into ap_invoice_lines_interface VALUES L_xxx_iLines;
      Update xxx_STD_AP_IvoiiImport_Lines xxx
         set xxx.imported_flag = L_Imported_FlagY
       Where Current Of iLines;
    End Loop iiLines;
  
    Commit;
  End iFaceAutoTaxYY;

  /*===========================================================
  ---- Procedure Name:    iFaceAutoTax()
  ---- To AutoCalculate the VAT Tax.
  ---- CALC_TAX_DURING_IMPORT_FLAG=Y
  ---- ADD_TAX_TO_INV_AMT_FLAG=N
  =============================================================*/
  Procedure iFaceAutoTaxYN(P_Batch_ID In Number,
                           P_Org_ID   in Number,
                           P_Com_Code in varchar2,
                           P_TPName   in varchar2) IS
  
    Cursor iHeaders(P_Batch_ID In Number,
                    P_Org_ID   in Number,
                    P_Com_Code in varchar2,
                    P_TPName   in varchar2) is
      select *
        from xxx_STD_AP_IvoiiImport_Headers iH
       where iH.Batch_ID = P_Batch_ID
         and iH.Org_ID = P_Org_ID
         and iH.Com_Code = P_Com_Code
         and iH.Period_Name = P_TPName
         and iH.Imported_Flag = 'I'
         For Update Of iH.Imported_Flag, iH.Invoice_Xnum;
  
    Cursor iLines(P_Batch_ID In Number,
                  --P_iHeaders_ID in Number,
                  P_Org_ID   in Number,
                  P_Com_Code in varchar2,
                  P_TPName   in varchar2) is
      select *
        from xxx_STD_AP_IvoiiImport_Lines iL
       where iL.Batch_ID = P_Batch_ID
            --and iL.Invoii_iFaceID = P_iHeaders_ID
         and iL.Org_ID = P_Org_ID
         and iL.Com_Code = P_Com_Code
         and iL.Period_Name = P_TPName
         and iL.Invoii_Linetii = P_xxx_ITEM
         and iL.Imported_Flag = 'I'
         For Update Of iL.Imported_Flag;
  
    L_Org_ID   Number := P_Org_ID;
    L_Com_Code varchar2(15) := P_Com_Code;
    L_Batch_ID Number := P_Batch_ID;
    L_TPName   varchar2(15) := P_TPName;
  
    L_Imported_FlagY varchar2(2) := 'Y';
    L_xxx_FlagY      varchar2(2) := 'Y';
    L_xxx_FlagN      varchar2(2) := 'N';
  
    L_SOB_Curr        varchar2(5);
    L_PMTs_Curr       varchar2(5);
    L_Curr_Prii       Number;
    L_xRate_Ti        varchar2(30);
    L_xRate_TUi       varchar2(30);
    L_xxx_xDate       Date;
    L_Accounting_Date Date;
    L_xxx_xRate       Number;
    L_Invoii_Amount   Number;
    L_xBase_Amount    Number;
    L_xxi_Amount      Number;
    L_xxii_Amount     Number;
    L_Invoii_Num      varchar2(30);
    L_AWT_GroupName   varchar2(30);
    L_AWT_GroupID     Number;
  
    L_AutoInvoii_PName varchar2(100);
  
  Begin
  
    select app.base_currency_code, app.default_exchange_rate_type
      into L_SOB_Curr, L_xRate_Ti
      from ap_system_parameters_all app
     where app.org_id = L_Org_ID;
  
    select fnn.precision
      into L_Curr_Prii
      from fnd_currencies fnn
     where fnn.currency_code = L_SOB_Curr;
  
    For iiHeaders in iHeaders(L_Batch_ID, L_Org_ID, L_Com_Code, L_TPName) Loop
    
      L_AutoInvoii_PName := P_AutoInvoii_PName || iiHeaders.invoii_ifaceid;
      L_xxx_xDate        := P_Null;
      L_xRate_TUi        := P_Null;
      L_xxx_xRate        := P_Null;
      L_xBase_Amount     := P_Null;
    
      L_PMTs_Curr       := iiHeaders.invoii_curr;
      L_Accounting_Date := iiHeaders.invoii_gl_date;
      --L_Invoii_Amount   := iiHeaders.Invoiiheader_Amount;
      --Inclusive Tax Amount
      L_Invoii_Amount := iiHeaders.InvoiiiTax_Amount;
      L_xxi_Amount    := Round(L_Invoii_Amount, L_Curr_Prii);
      L_Invoii_Num    := to_Char(SYSTIMESTAMP, 'YYYYMMDDHH24MISSFF4');
    
      L_AWT_GroupName := iiHeaders.withhold_taxcode;
      L_AWT_GroupID   := iiHeaders.withhold_taxid;
    
      if L_PMTs_Curr <> L_SOB_Curr Then
        L_xxx_xDate     := L_Accounting_Date;
        L_xRate_TUi     := L_xRate_Ti;
        L_xxx_xRate     := xxx_commonchecking_pkg.get_xxx_Rate(P_From_Curr       => L_PMTs_Curr,
                                                               P_To_Curr         => L_SOB_Curr,
                                                               P_xRate_Ti        => L_xRate_TUi,
                                                               P_Accounting_Date => L_xxx_xDate);
        L_xBase_Amount  := Round(L_Invoii_Amount * L_xxx_xRate, L_Curr_Prii);
        L_xxii_Amount   := Round(L_xBase_Amount, L_Curr_Prii);
        L_AWT_GroupName := P_Null;
        L_AWT_GroupID   := P_Null;
      End if;
    
      L_xxx_iHeaders.org_id     := iiHeaders.org_id;
      L_xxx_iHeaders.invoice_id := iiHeaders.invoii_ifaceid;
      --L_xxx_iHeaders.invoice_num              := iiHeaders.invoice_num;
      L_xxx_iHeaders.invoice_num              := L_Invoii_Num;
      L_xxx_iHeaders.invoice_type_lookup_code := iiHeaders.invoii_tii;
      L_xxx_iHeaders.invoice_currency_code    := iiHeaders.invoii_curr;
      L_xxx_iHeaders.exchange_rate_type       := L_xRate_TUi;
      L_xxx_iHeaders.exchange_date            := L_xxx_xDate;
      L_xxx_iHeaders.exchange_rate            := L_xxx_xRate;
      L_xxx_iHeaders.invoice_amount           := L_xxi_Amount;
      L_xxx_iHeaders.invoice_date             := iiHeaders.invoii_date;
      L_xxx_iHeaders.gl_date                  := L_Accounting_Date;
      L_xxx_iHeaders.vendor_id                := iiHeaders.supp_id;
      L_xxx_iHeaders.vendor_site_id           := iiHeaders.supp_siteid;
      L_xxx_iHeaders.vendor_name              := iiHeaders.supp_name;
      L_xxx_iHeaders.vendor_num               := iiHeaders.supp_number;
      L_xxx_iHeaders.vendor_site_code         := iiHeaders.supp_sitecode;
      L_xxx_iHeaders.awt_group_name           := L_AWT_GroupName;
      L_xxx_iHeaders.awt_group_id             := L_AWT_GroupID;
      L_xxx_iHeaders.terms_name               := iiHeaders.pmts_terms;
      L_xxx_iHeaders.terms_id                 := iiHeaders.pmtsterms_id;
      L_xxx_iHeaders.terms_date               := iiHeaders.invoii_date;
      L_xxx_iHeaders.payment_method_code      := iiHeaders.pmts_method;
      L_xxx_iHeaders.pay_group_lookup_code    := iiHeaders.pmts_group;
    
      ---- ---- Auto Caculate the Tax and SO the Flag marked Y.
      L_xxx_iHeaders.calc_tax_during_import_flag := L_xxx_FlagY;
      L_xxx_iHeaders.add_tax_to_inv_amt_flag     := L_xxx_FlagN;
      L_xxx_iHeaders.group_id                    := iiHeaders.batch_id;
      L_xxx_iHeaders.description                 := L_AutoInvoii_PName;
      L_xxx_iHeaders.source                      := P_Imported_Source;
    
      L_xxx_iHeaders.request_id        := fnd_global.conc_request_id;
      L_xxx_iHeaders.created_by        := fnd_global.user_id;
      L_xxx_iHeaders.creation_date     := SYSDATE;
      L_xxx_iHeaders.last_updated_by   := fnd_global.user_id;
      L_xxx_iHeaders.last_update_date  := SYSDATE;
      L_xxx_iHeaders.last_update_login := fnd_global.login_id;
    
      insert into ap_invoices_interface VALUES L_xxx_iHeaders;
      Update xxx_STD_AP_IvoiiImport_Headers xxx
         set xxx.imported_flag = L_Imported_FlagY,
             xxx.invoice_xnum  = L_Invoii_Num
       Where Current Of iHeaders;
      ---- ---- ---- ----End Loop the Invoii Headers
    End Loop iiHeaders;
  
    For iiLines in iLines(L_Batch_ID, L_Org_ID, L_Com_Code, L_TPName) Loop
    
      L_AutoInvoii_PName := P_AutoInvoii_PName ||
                            iiLines.Invoii_Ifacelineid;
      L_Invoii_Amount    := iiLines.Invoiiheader_Amount;
      L_xxi_Amount       := Round(L_Invoii_Amount, L_Curr_Prii);
    
      L_PMTs_Curr     := iiLines.Invoii_Curr;
      L_AWT_GroupName := iiLines.withhold_taxcode;
      L_AWT_GroupID   := iiLines.withhold_taxid;
      if L_PMTs_Curr <> L_SOB_Curr Then
        L_AWT_GroupName := P_Null;
        L_AWT_GroupID   := P_Null;
      End if;
    
      L_xxx_iLines.ORG_ID                := iiLines.Org_ID;
      L_xxx_iLines.invoice_id            := iiLines.Invoii_Ifaceid;
      L_xxx_iLines.invoice_line_id       := iiLines.Invoii_Ifacelineid;
      L_xxx_iLines.line_number           := iiLines.L_Invoiiline_Number;
      L_xxx_iLines.line_type_lookup_code := iiLines.Invoii_Linetii;
      L_xxx_iLines.amount                := L_xxi_Amount;
      L_xxx_iLines.accounting_date       := iiLines.Invoiiline_GL_Date;
    
      L_xxx_iLines.dist_code_concatenated   := iiLines.GL_Coa_Code;
      L_xxx_iLines.dist_code_combination_id := iiLines.GL_CCID;
      L_xxx_iLines.default_dist_ccid        := iiLines.GL_CCID;
      L_xxx_iLines.awt_group_name           := L_AWT_GroupName;
      L_xxx_iLines.awt_group_id             := L_AWT_GroupID;
      L_xxx_iLines.tax_classification_code  := iiLines.Taxvat_Code;
    
      L_xxx_iLines.description := L_AutoInvoii_PName;
    
      L_xxx_iLines.created_by        := fnd_global.user_id;
      L_xxx_iLines.creation_date     := SYSDATE;
      L_xxx_iLines.last_updated_by   := fnd_global.user_id;
      L_xxx_iLines.last_update_date  := SYSDATE;
      L_xxx_iLines.last_update_login := fnd_global.login_id;
    
      insert into ap_invoice_lines_interface VALUES L_xxx_iLines;
      Update xxx_STD_AP_IvoiiImport_Lines xxx
         set xxx.imported_flag = L_Imported_FlagY
       Where Current Of iLines;
    End Loop iiLines;
  
    Commit;
  End iFaceAutoTaxYN;

  /*===========================================================
  ---- Procedure Name:    iFaceAutoTax()
  ---- To AutoCalculate the VAT Tax.
  ---- CALC_TAX_DURING_IMPORT_FLAG=N
  ---- ADD_TAX_TO_INV_AMT_FLAG=Y
  =============================================================*/
  Procedure iFaceAutoTaxNY(P_Batch_ID In Number,
                           P_Org_ID   in Number,
                           P_Com_Code in varchar2,
                           P_TPName   in varchar2) IS
  
    Cursor iHeaders(P_Batch_ID In Number,
                    P_Org_ID   in Number,
                    P_Com_Code in varchar2,
                    P_TPName   in varchar2) is
      select *
        from xxx_STD_AP_IvoiiImport_Headers iH
       where iH.Batch_ID = P_Batch_ID
         and iH.Org_ID = P_Org_ID
         and iH.Com_Code = P_Com_Code
         and iH.Period_Name = P_TPName
         and iH.Imported_Flag = 'I'
         For Update Of iH.Imported_Flag, iH.Invoice_Xnum;
  
    Cursor iLines(P_Batch_ID In Number,
                  P_Org_ID   in Number,
                  P_Com_Code in varchar2,
                  P_TPName   in varchar2) is
      select *
        from xxx_STD_AP_IvoiiImport_Lines iL
       where iL.Batch_ID = P_Batch_ID
         and iL.Org_ID = P_Org_ID
         and iL.Com_Code = P_Com_Code
         and iL.Period_Name = P_TPName
         and iL.Imported_Flag = 'I'
         For Update Of iL.Imported_Flag;
  
    L_Org_ID   Number := P_Org_ID;
    L_Com_Code varchar2(15) := P_Com_Code;
    L_Batch_ID Number := P_Batch_ID;
    L_TPName   varchar2(15) := P_TPName;
  
    L_Imported_FlagY varchar2(2) := 'Y';
    L_xxx_FlagY      varchar2(2) := 'Y';
    L_xxx_FlagN      varchar2(2) := 'N';
    L_xxx_AcrossFlag varchar2(2) := 'N';
  
    L_Regime_Code       varchar2(200);
    L_xxx_Tax           varchar2(200);
    L_Jurisdiction_Code varchar2(200);
    L_Status_Code       varchar2(200);
    L_Rate_Code         varchar2(200);
    L_Tax_Rate          Number;
    L_Rate_ID           Number;
  
    L_SOB_Curr        varchar2(5);
    L_PMTs_Curr       varchar2(5);
    L_Curr_Prii       Number;
    L_xxx_GLCCID      Number;
    L_xxx_GLCCIDCode  varchar2(300);
    L_xRate_Ti        varchar2(30);
    L_xRate_TUi       varchar2(30);
    L_xxx_xDate       Date;
    L_Accounting_Date Date;
    L_xxx_xRate       Number;
    L_Invoii_Amount   Number;
    L_xBase_Amount    Number;
    L_xxi_Amount      Number;
    L_xxii_Amount     Number;
    L_Invoii_Num      varchar2(30);
    L_AWT_GroupName   varchar2(30);
    L_AWT_GroupID     Number;
  
    L_AutoInvoii_PName varchar2(100);
  
  Begin
  
    select app.base_currency_code, app.default_exchange_rate_type
      into L_SOB_Curr, L_xRate_Ti
      from ap_system_parameters_all app
     where app.org_id = L_Org_ID;
  
    select fnn.precision
      into L_Curr_Prii
      from fnd_currencies fnn
     where fnn.currency_code = L_SOB_Curr;
  
    For iiHeaders in iHeaders(L_Batch_ID, L_Org_ID, L_Com_Code, L_TPName) Loop
    
      L_AutoInvoii_PName := P_AutoInvoii_PName || iiHeaders.invoii_ifaceid;
      L_xxx_xDate        := P_Null;
      L_xRate_TUi        := P_Null;
      L_xxx_xRate        := P_Null;
      L_xBase_Amount     := P_Null;
    
      L_PMTs_Curr       := iiHeaders.invoii_curr;
      L_Accounting_Date := iiHeaders.invoii_gl_date;
      --Exclusive Tax Amount
      L_Invoii_Amount := iiHeaders.Invoiiheader_Amount;
      L_xxi_Amount    := Round(L_Invoii_Amount, L_Curr_Prii);
      L_Invoii_Num    := to_Char(SYSTIMESTAMP, 'YYYYMMDDHH24MISSFF4');
    
      L_AWT_GroupName := iiHeaders.withhold_taxcode;
      L_AWT_GroupID   := iiHeaders.withhold_taxid;
    
      if L_PMTs_Curr <> L_SOB_Curr Then
        L_xxx_xDate     := L_Accounting_Date;
        L_xRate_TUi     := L_xRate_Ti;
        L_xxx_xRate     := xxx_commonchecking_pkg.get_xxx_Rate(P_From_Curr       => L_PMTs_Curr,
                                                               P_To_Curr         => L_SOB_Curr,
                                                               P_xRate_Ti        => L_xRate_TUi,
                                                               P_Accounting_Date => L_xxx_xDate);
        L_xBase_Amount  := Round(L_Invoii_Amount * L_xxx_xRate, L_Curr_Prii);
        L_xxii_Amount   := Round(L_xBase_Amount, L_Curr_Prii);
        L_AWT_GroupName := P_Null;
        L_AWT_GroupID   := P_Null;
      End if;
    
      L_xxx_iHeaders.org_id     := iiHeaders.org_id;
      L_xxx_iHeaders.invoice_id := iiHeaders.invoii_ifaceid;
      --L_xxx_iHeaders.invoice_num              := iiHeaders.invoice_num;
      L_xxx_iHeaders.invoice_num              := L_Invoii_Num;
      L_xxx_iHeaders.invoice_type_lookup_code := iiHeaders.invoii_tii;
      L_xxx_iHeaders.invoice_currency_code    := iiHeaders.invoii_curr;
      L_xxx_iHeaders.exchange_rate_type       := L_xRate_TUi;
      L_xxx_iHeaders.exchange_date            := L_xxx_xDate;
      L_xxx_iHeaders.exchange_rate            := L_xxx_xRate;
      L_xxx_iHeaders.invoice_amount           := L_xxi_Amount;
      L_xxx_iHeaders.invoice_date             := iiHeaders.invoii_date;
      L_xxx_iHeaders.gl_date                  := L_Accounting_Date;
      L_xxx_iHeaders.vendor_id                := iiHeaders.supp_id;
      L_xxx_iHeaders.vendor_site_id           := iiHeaders.supp_siteid;
      L_xxx_iHeaders.vendor_name              := iiHeaders.supp_name;
      L_xxx_iHeaders.vendor_num               := iiHeaders.supp_number;
      L_xxx_iHeaders.vendor_site_code         := iiHeaders.supp_sitecode;
      L_xxx_iHeaders.awt_group_name           := L_AWT_GroupName;
      L_xxx_iHeaders.awt_group_id             := L_AWT_GroupID;
      L_xxx_iHeaders.terms_name               := iiHeaders.pmts_terms;
      L_xxx_iHeaders.terms_id                 := iiHeaders.pmtsterms_id;
      L_xxx_iHeaders.terms_date               := iiHeaders.invoii_date;
      L_xxx_iHeaders.payment_method_code      := iiHeaders.pmts_method;
      L_xxx_iHeaders.pay_group_lookup_code    := iiHeaders.pmts_group;
    
      ---- ---- Auto Caculate the Tax and SO the Flag marked Y/N.
      L_xxx_iHeaders.calc_tax_during_import_flag := L_xxx_FlagN;
      L_xxx_iHeaders.add_tax_to_inv_amt_flag     := L_xxx_FlagY;
    
      L_xxx_iHeaders.group_id    := iiHeaders.batch_id;
      L_xxx_iHeaders.description := L_AutoInvoii_PName;
      L_xxx_iHeaders.source      := P_Imported_Source;
    
      L_xxx_iHeaders.request_id        := fnd_global.conc_request_id;
      L_xxx_iHeaders.created_by        := fnd_global.user_id;
      L_xxx_iHeaders.creation_date     := SYSDATE;
      L_xxx_iHeaders.last_updated_by   := fnd_global.user_id;
      L_xxx_iHeaders.last_update_date  := SYSDATE;
      L_xxx_iHeaders.last_update_login := fnd_global.login_id;
    
      insert into ap_invoices_interface VALUES L_xxx_iHeaders;
      Update xxx_STD_AP_IvoiiImport_Headers xxx
         set xxx.imported_flag = L_Imported_FlagY,
             xxx.invoice_xnum  = L_Invoii_Num
       Where Current Of iHeaders;
      ---- ---- ---- ----End Loop the Invoii Headers
    End Loop iiHeaders;
  
    For iiLines in iLines(L_Batch_ID, L_Org_ID, L_Com_Code, L_TPName) Loop
    
      L_AutoInvoii_PName := P_AutoInvoii_PName ||
                            iiLines.Invoii_Ifacelineid;
      L_Invoii_Amount    := iiLines.l_Invoiiline_Amount;
      L_xxi_Amount       := Round(L_Invoii_Amount, L_Curr_Prii);
    
      L_PMTs_Curr     := iiLines.Invoii_Curr;
      L_AWT_GroupName := iiLines.withhold_taxcode;
      L_AWT_GroupID   := iiLines.withhold_taxid;
      if L_PMTs_Curr <> L_SOB_Curr Then
        L_AWT_GroupName := P_Null;
        L_AWT_GroupID   := P_Null;
      End if;
    
      L_xxx_iLines.ORG_ID                := iiLines.Org_ID;
      L_xxx_iLines.invoice_id            := iiLines.Invoii_Ifaceid;
      L_xxx_iLines.invoice_line_id       := iiLines.Invoii_Ifacelineid;
      L_xxx_iLines.line_number           := iiLines.L_Invoiiline_Number;
      L_xxx_iLines.line_type_lookup_code := iiLines.Invoii_Linetii;
      L_xxx_iLines.amount                := L_xxi_Amount;
      L_xxx_iLines.accounting_date       := iiLines.Invoiiline_GL_Date;
    
      L_xxx_GLCCID     := iiLines.GL_CCID;
      L_xxx_GLCCIDCode := iiLines.GL_Coa_Code;
    
      L_xxx_iLines.awt_group_name := L_AWT_GroupName;
      L_xxx_iLines.awt_group_id   := L_AWT_GroupID;
    
      ---- Insert the Tax info.
      L_xxx_iLines.line_group_number       := iiLines.Line_GroupNum;
      L_xxx_iLines.tax_classification_code := iiLines.Taxvat_Code;
    
      L_Regime_Code       := P_Null;
      L_xxx_Tax           := P_Null;
      L_Jurisdiction_Code := P_Null;
      L_Status_Code       := P_Null;
      L_Rate_Code         := P_Null;
      L_Tax_Rate          := P_Null;
      L_Rate_ID           := P_Null;
      L_xxx_AcrossFlag    := P_Null;
      if iiLines.Invoii_Linetii = P_xxx_Tax Then
        SELECT zbb.tax_regime_code,
               zbb.tax,
               zbb.tax_jurisdiction_code,
               zbb.tax_status_code,
               zbb.tax_rate_code,
               zbb.percentage_rate,
               zbb.tax_rate_id
          into L_Regime_Code,
               L_xxx_Tax,
               L_Jurisdiction_Code,
               L_Status_Code,
               L_Rate_Code,
               L_Tax_Rate,
               L_Rate_ID
        
          FROM zx_rates_b zbb
         where zbb.tax_rate_code = iiLines.Taxvat_Code;
        L_xxx_GLCCID     := P_Null;
        L_xxx_GLCCIDCode := P_Null;
        L_xxx_AcrossFlag := L_Imported_FlagY;
      End if;
      L_xxx_iLines.tax_regime_code       := L_Regime_Code;
      L_xxx_iLines.tax                   := L_xxx_Tax;
      L_xxx_iLines.tax_jurisdiction_code := L_Jurisdiction_Code;
      L_xxx_iLines.tax_status_code       := L_Status_Code;
      L_xxx_iLines.tax_rate_code         := L_Rate_Code;
      L_xxx_iLines.tax_rate              := L_Tax_Rate;
      L_xxx_iLines.tax_rate_id           := L_Rate_ID;
    
      L_xxx_iLines.prorate_across_flag      := L_xxx_AcrossFlag;
      L_xxx_iLines.dist_code_combination_id := L_xxx_GLCCID;
      L_xxx_iLines.default_dist_ccid        := L_xxx_GLCCID;
      L_xxx_iLines.dist_code_concatenated   := L_xxx_GLCCIDCode;
    
      L_xxx_iLines.description := L_AutoInvoii_PName;
    
      L_xxx_iLines.created_by        := fnd_global.user_id;
      L_xxx_iLines.creation_date     := SYSDATE;
      L_xxx_iLines.last_updated_by   := fnd_global.user_id;
      L_xxx_iLines.last_update_date  := SYSDATE;
      L_xxx_iLines.last_update_login := fnd_global.login_id;
    
      insert into ap_invoice_lines_interface VALUES L_xxx_iLines;
      Update xxx_STD_AP_IvoiiImport_Lines xxx
         set xxx.imported_flag = L_Imported_FlagY
       Where Current Of iLines;
    End Loop iiLines;
  
    Commit;
  End iFaceAutoTaxNY;

  /*===========================================================
  ---- Procedure Name:    iFaceAutoTax()
  ---- To AutoCalculate the VAT Tax.
  ---- CALC_TAX_DURING_IMPORT_FLAG=N
  ---- ADD_TAX_TO_INV_AMT_FLAG=N
  =============================================================*/
  Procedure iFaceAutoTaxNN(P_Batch_ID In Number,
                           P_Org_ID   in Number,
                           P_Com_Code in varchar2,
                           P_TPName   in varchar2) IS
  
    Cursor iHeaders(P_Batch_ID In Number,
                    P_Org_ID   in Number,
                    P_Com_Code in varchar2,
                    P_TPName   in varchar2) is
      select *
        from xxx_STD_AP_IvoiiImport_Headers iH
       where iH.Batch_ID = P_Batch_ID
         and iH.Org_ID = P_Org_ID
         and iH.Com_Code = P_Com_Code
         and iH.Period_Name = P_TPName
         and iH.Imported_Flag = 'I'
         For Update Of iH.Imported_Flag, iH.Invoice_Xnum;
  
    Cursor iLines(P_Batch_ID In Number,
                  P_Org_ID   in Number,
                  P_Com_Code in varchar2,
                  P_TPName   in varchar2) is
      select *
        from xxx_STD_AP_IvoiiImport_Lines iL
       where iL.Batch_ID = P_Batch_ID
         and iL.Org_ID = P_Org_ID
         and iL.Com_Code = P_Com_Code
         and iL.Period_Name = P_TPName
         and iL.Imported_Flag = 'I'
         For Update Of iL.Imported_Flag;
  
    L_Org_ID   Number := P_Org_ID;
    L_Com_Code varchar2(15) := P_Com_Code;
    L_Batch_ID Number := P_Batch_ID;
    L_TPName   varchar2(15) := P_TPName;
  
    L_Imported_FlagY varchar2(2) := 'Y';
    L_xxx_FlagN      varchar2(2) := 'N';
    L_xxx_AcrossFlag varchar2(2) := 'N';
  
    L_Regime_Code       varchar2(200);
    L_xxx_Tax           varchar2(200);
    L_Jurisdiction_Code varchar2(200);
    L_Status_Code       varchar2(200);
    L_Rate_Code         varchar2(200);
    L_Tax_Rate          Number;
    L_Rate_ID           Number;
  
    L_SOB_Curr        varchar2(5);
    L_PMTs_Curr       varchar2(5);
    L_Curr_Prii       Number;
    L_xxx_GLCCID      Number;
    L_xxx_GLCCIDCode  varchar2(300);
    L_xRate_Ti        varchar2(30);
    L_xRate_TUi       varchar2(30);
    L_xxx_xDate       Date;
    L_Accounting_Date Date;
    L_xxx_xRate       Number;
    L_Invoii_Amount   Number;
    L_xBase_Amount    Number;
    L_xxi_Amount      Number;
    L_xxii_Amount     Number;
    L_Invoii_Num      varchar2(30);
    L_AWT_GroupName   varchar2(30);
    L_AWT_GroupID     Number;
  
    L_AutoInvoii_PName varchar2(100);
  
  Begin
  
    select app.base_currency_code, app.default_exchange_rate_type
      into L_SOB_Curr, L_xRate_Ti
      from ap_system_parameters_all app
     where app.org_id = L_Org_ID;
  
    select fnn.precision
      into L_Curr_Prii
      from fnd_currencies fnn
     where fnn.currency_code = L_SOB_Curr;
  
    For iiHeaders in iHeaders(L_Batch_ID, L_Org_ID, L_Com_Code, L_TPName) Loop
    
      L_AutoInvoii_PName := P_AutoInvoii_PName || iiHeaders.invoii_ifaceid;
      L_xxx_xDate        := P_Null;
      L_xRate_TUi        := P_Null;
      L_xxx_xRate        := P_Null;
      L_xBase_Amount     := P_Null;
    
      L_PMTs_Curr       := iiHeaders.invoii_curr;
      L_Accounting_Date := iiHeaders.invoii_gl_date;
      --L_Invoii_Amount   := iiHeaders.Invoiiheader_Amount;
      --Inclusive Tax Amount
      L_Invoii_Amount := iiHeaders.Invoiiitax_Amount;
      L_xxi_Amount    := Round(L_Invoii_Amount, L_Curr_Prii);
      L_Invoii_Num    := to_Char(SYSTIMESTAMP, 'YYYYMMDDHH24MISSFF4');
    
      L_AWT_GroupName := iiHeaders.withhold_taxcode;
      L_AWT_GroupID   := iiHeaders.withhold_taxid;
    
      if L_PMTs_Curr <> L_SOB_Curr Then
        L_xxx_xDate     := L_Accounting_Date;
        L_xRate_TUi     := L_xRate_Ti;
        L_xxx_xRate     := xxx_commonchecking_pkg.get_xxx_Rate(P_From_Curr       => L_PMTs_Curr,
                                                               P_To_Curr         => L_SOB_Curr,
                                                               P_xRate_Ti        => L_xRate_TUi,
                                                               P_Accounting_Date => L_xxx_xDate);
        L_xBase_Amount  := Round(L_Invoii_Amount * L_xxx_xRate, L_Curr_Prii);
        L_xxii_Amount   := Round(L_xBase_Amount, L_Curr_Prii);
        L_AWT_GroupName := P_Null;
        L_AWT_GroupID   := P_Null;
      End if;
    
      L_xxx_iHeaders.org_id     := iiHeaders.org_id;
      L_xxx_iHeaders.invoice_id := iiHeaders.invoii_ifaceid;
      --L_xxx_iHeaders.invoice_num              := iiHeaders.invoice_num;
      L_xxx_iHeaders.invoice_num              := L_Invoii_Num;
      L_xxx_iHeaders.invoice_type_lookup_code := iiHeaders.invoii_tii;
      L_xxx_iHeaders.invoice_currency_code    := iiHeaders.invoii_curr;
      L_xxx_iHeaders.exchange_rate_type       := L_xRate_TUi;
      L_xxx_iHeaders.exchange_date            := L_xxx_xDate;
      L_xxx_iHeaders.exchange_rate            := L_xxx_xRate;
      L_xxx_iHeaders.invoice_amount           := L_xxi_Amount;
      L_xxx_iHeaders.invoice_date             := iiHeaders.invoii_date;
      L_xxx_iHeaders.gl_date                  := L_Accounting_Date;
      L_xxx_iHeaders.vendor_id                := iiHeaders.supp_id;
      L_xxx_iHeaders.vendor_site_id           := iiHeaders.supp_siteid;
      L_xxx_iHeaders.vendor_name              := iiHeaders.supp_name;
      L_xxx_iHeaders.vendor_num               := iiHeaders.supp_number;
      L_xxx_iHeaders.vendor_site_code         := iiHeaders.supp_sitecode;
      L_xxx_iHeaders.awt_group_name           := L_AWT_GroupName;
      L_xxx_iHeaders.awt_group_id             := L_AWT_GroupID;
      L_xxx_iHeaders.terms_name               := iiHeaders.pmts_terms;
      L_xxx_iHeaders.terms_id                 := iiHeaders.pmtsterms_id;
      L_xxx_iHeaders.terms_date               := iiHeaders.invoii_date;
      L_xxx_iHeaders.payment_method_code      := iiHeaders.pmts_method;
      L_xxx_iHeaders.pay_group_lookup_code    := iiHeaders.pmts_group;
    
      ---- ---- If Auto Caculate the Tax and SO the Flag marked Y.
      L_xxx_iHeaders.calc_tax_during_import_flag := L_xxx_FlagN;
      L_xxx_iHeaders.add_tax_to_inv_amt_flag     := L_xxx_FlagN;
      L_xxx_iHeaders.group_id                    := iiHeaders.batch_id;
      L_xxx_iHeaders.description                 := L_AutoInvoii_PName;
      L_xxx_iHeaders.source                      := P_Imported_Source;
    
      L_xxx_iHeaders.request_id        := fnd_global.conc_request_id;
      L_xxx_iHeaders.created_by        := fnd_global.user_id;
      L_xxx_iHeaders.creation_date     := SYSDATE;
      L_xxx_iHeaders.last_updated_by   := fnd_global.user_id;
      L_xxx_iHeaders.last_update_date  := SYSDATE;
      L_xxx_iHeaders.last_update_login := fnd_global.login_id;
    
      insert into ap_invoices_interface VALUES L_xxx_iHeaders;
      Update xxx_STD_AP_IvoiiImport_Headers xxx
         set xxx.imported_flag = L_Imported_FlagY,
             xxx.invoice_xnum  = L_Invoii_Num
       Where Current Of iHeaders;
      ---- ---- ---- ----End Loop the Invoii Headers
    End Loop iiHeaders;
  
    For iiLines in iLines(L_Batch_ID, L_Org_ID, L_Com_Code, L_TPName) Loop
    
      L_AutoInvoii_PName := P_AutoInvoii_PName ||
                            iiLines.Invoii_Ifacelineid;
      L_Invoii_Amount    := iiLines.l_Invoiiline_Amount;
      L_xxi_Amount       := Round(L_Invoii_Amount, L_Curr_Prii);
    
      L_PMTs_Curr     := iiLines.Invoii_Curr;
      L_AWT_GroupName := iiLines.withhold_taxcode;
      L_AWT_GroupID   := iiLines.withhold_taxid;
      if L_PMTs_Curr <> L_SOB_Curr Then
        L_AWT_GroupName := P_Null;
        L_AWT_GroupID   := P_Null;
      End if;
    
      L_xxx_iLines.ORG_ID                := iiLines.Org_ID;
      L_xxx_iLines.invoice_id            := iiLines.Invoii_Ifaceid;
      L_xxx_iLines.invoice_line_id       := iiLines.Invoii_Ifacelineid;
      L_xxx_iLines.line_number           := iiLines.L_Invoiiline_Number;
      L_xxx_iLines.line_type_lookup_code := iiLines.Invoii_Linetii;
      L_xxx_iLines.amount                := L_xxi_Amount;
      L_xxx_iLines.accounting_date       := iiLines.Invoiiline_GL_Date;
    
      L_xxx_GLCCID     := iiLines.GL_CCID;
      L_xxx_GLCCIDCode := iiLines.GL_Coa_Code;
    
      L_xxx_iLines.awt_group_name := L_AWT_GroupName;
      L_xxx_iLines.awt_group_id   := L_AWT_GroupID;
    
      ---- Insert the Tax info.
      L_xxx_iLines.line_group_number       := iiLines.Line_GroupNum;
      L_xxx_iLines.tax_classification_code := iiLines.Taxvat_Code;
    
      L_Regime_Code       := P_Null;
      L_xxx_Tax           := P_Null;
      L_Jurisdiction_Code := P_Null;
      L_Status_Code       := P_Null;
      L_Rate_Code         := P_Null;
      L_Tax_Rate          := P_Null;
      L_Rate_ID           := P_Null;
      L_xxx_AcrossFlag    := P_Null;
      if iiLines.Invoii_Linetii = P_xxx_Tax Then
        SELECT zbb.tax_regime_code,
               zbb.tax,
               zbb.tax_jurisdiction_code,
               zbb.tax_status_code,
               zbb.tax_rate_code,
               zbb.percentage_rate,
               zbb.tax_rate_id
          into L_Regime_Code,
               L_xxx_Tax,
               L_Jurisdiction_Code,
               L_Status_Code,
               L_Rate_Code,
               L_Tax_Rate,
               L_Rate_ID
        
          FROM zx_rates_b zbb
         where zbb.tax_rate_code = iiLines.Taxvat_Code;
        L_xxx_GLCCID     := P_Null;
        L_xxx_GLCCIDCode := P_Null;
        L_xxx_AcrossFlag := L_Imported_FlagY;
      End if;
    
      L_xxx_iLines.prorate_across_flag      := L_xxx_AcrossFlag;
      L_xxx_iLines.dist_code_combination_id := L_xxx_GLCCID;
      L_xxx_iLines.default_dist_ccid        := L_xxx_GLCCID;
      L_xxx_iLines.dist_code_concatenated   := L_xxx_GLCCIDCode;
    
      L_xxx_iLines.tax_regime_code       := L_Regime_Code;
      L_xxx_iLines.tax                   := L_xxx_Tax;
      L_xxx_iLines.tax_jurisdiction_code := L_Jurisdiction_Code;
      L_xxx_iLines.tax_status_code       := L_Status_Code;
      L_xxx_iLines.tax_rate_code         := L_Rate_Code;
      L_xxx_iLines.tax_rate              := L_Tax_Rate;
      L_xxx_iLines.tax_rate_id           := L_Rate_ID;
    
      L_xxx_iLines.description := L_AutoInvoii_PName;
    
      L_xxx_iLines.created_by        := fnd_global.user_id;
      L_xxx_iLines.creation_date     := SYSDATE;
      L_xxx_iLines.last_updated_by   := fnd_global.user_id;
      L_xxx_iLines.last_update_date  := SYSDATE;
      L_xxx_iLines.last_update_login := fnd_global.login_id;
    
      insert into ap_invoice_lines_interface VALUES L_xxx_iLines;
      Update xxx_STD_AP_IvoiiImport_Lines xxx
         set xxx.imported_flag = L_Imported_FlagY
       Where Current Of iLines;
    End Loop iiLines;
  
    Commit;
  End iFaceAutoTaxNN;

  /*===========================================================
  ---- Procedure Name:    iFaceAutoTaxINY()
  ---- To AutoCalculate the VAT Tax.
  ---- CALC_TAX_DURING_IMPORT_FLAG=N
  ---- ADD_TAX_TO_INV_AMT_FLAG=Y
  ---- INCL_IN_TAXABLE_LINE_FLAG=Y
  =============================================================*/
  Procedure iFaceAutoTaxINY(P_Batch_ID In Number,
                            P_Org_ID   in Number,
                            P_Com_Code in varchar2,
                            P_TPName   in varchar2) IS
  
    Cursor iHeaders(P_Batch_ID In Number,
                    P_Org_ID   in Number,
                    P_Com_Code in varchar2,
                    P_TPName   in varchar2) is
      select *
        from xxx_STD_AP_IvoiiImport_Headers iH
       where iH.Batch_ID = P_Batch_ID
         and iH.Org_ID = P_Org_ID
         and iH.Com_Code = P_Com_Code
         and iH.Period_Name = P_TPName
         and iH.Imported_Flag = 'I'
         For Update Of iH.Imported_Flag, iH.Invoice_Xnum;
  
    Cursor iLines(P_Batch_ID In Number,
                  P_Org_ID   in Number,
                  P_Com_Code in varchar2,
                  P_TPName   in varchar2) is
      select *
        from xxx_STD_AP_IvoiiImport_Lines iL
       where iL.Batch_ID = P_Batch_ID
         and iL.Org_ID = P_Org_ID
         and iL.Com_Code = P_Com_Code
         and iL.Period_Name = P_TPName
         and iL.Imported_Flag = 'I'
         For Update Of iL.Imported_Flag;
  
    L_Org_ID   Number := P_Org_ID;
    L_Com_Code varchar2(15) := P_Com_Code;
    L_Batch_ID Number := P_Batch_ID;
    L_TPName   varchar2(15) := P_TPName;
  
    L_Imported_FlagY varchar2(2) := 'Y';
    L_xxx_FlagY      varchar2(2) := 'Y';
    L_xxx_FlagN      varchar2(2) := 'N';
    L_xxx_AcrossFlag varchar2(2) := 'N';
  
    L_Regime_Code       varchar2(200);
    L_xxx_Tax           varchar2(200);
    L_Jurisdiction_Code varchar2(200);
    L_Status_Code       varchar2(200);
    L_Rate_Code         varchar2(200);
    L_Tax_Rate          Number;
    L_Rate_ID           Number;
  
    L_SOB_Curr        varchar2(5);
    L_PMTs_Curr       varchar2(5);
    L_Curr_Prii       Number;
    L_xxx_GLCCID      Number;
    L_xxx_GLCCIDCode  varchar2(300);
    L_xRate_Ti        varchar2(30);
    L_xRate_TUi       varchar2(30);
    L_xxx_xDate       Date;
    L_Accounting_Date Date;
    L_xxx_xRate       Number;
    L_Invoii_Amount   Number;
    L_xBase_Amount    Number;
    L_xxi_Amount      Number;
    L_xxii_Amount     Number;
    L_Invoii_Num      varchar2(30);
    L_AWT_GroupName   varchar2(30);
    L_AWT_GroupID     Number;
  
    L_AutoInvoii_PName varchar2(100);
  
  Begin
  
    select app.base_currency_code, app.default_exchange_rate_type
      into L_SOB_Curr, L_xRate_Ti
      from ap_system_parameters_all app
     where app.org_id = L_Org_ID;
  
    select fnn.precision
      into L_Curr_Prii
      from fnd_currencies fnn
     where fnn.currency_code = L_SOB_Curr;
  
    For iiHeaders in iHeaders(L_Batch_ID, L_Org_ID, L_Com_Code, L_TPName) Loop
    
      L_AutoInvoii_PName := P_AutoInvoii_PName || iiHeaders.invoii_ifaceid;
      L_xxx_xDate        := P_Null;
      L_xRate_TUi        := P_Null;
      L_xxx_xRate        := P_Null;
      L_xBase_Amount     := P_Null;
    
      L_PMTs_Curr       := iiHeaders.invoii_curr;
      L_Accounting_Date := iiHeaders.invoii_gl_date;
      --Exclusive Tax Amount
      L_Invoii_Amount := iiHeaders.Invoiiheader_Amount;
      L_xxi_Amount    := Round(L_Invoii_Amount, L_Curr_Prii);
      L_Invoii_Num    := to_Char(SYSTIMESTAMP, 'YYYYMMDDHH24MISSFF4');
    
      L_AWT_GroupName := iiHeaders.withhold_taxcode;
      L_AWT_GroupID   := iiHeaders.withhold_taxid;
    
      if L_PMTs_Curr <> L_SOB_Curr Then
        L_xxx_xDate     := L_Accounting_Date;
        L_xRate_TUi     := L_xRate_Ti;
        L_xxx_xRate     := xxx_commonchecking_pkg.get_xxx_Rate(P_From_Curr       => L_PMTs_Curr,
                                                               P_To_Curr         => L_SOB_Curr,
                                                               P_xRate_Ti        => L_xRate_TUi,
                                                               P_Accounting_Date => L_xxx_xDate);
        L_xBase_Amount  := Round(L_Invoii_Amount * L_xxx_xRate, L_Curr_Prii);
        L_xxii_Amount   := Round(L_xBase_Amount, L_Curr_Prii);
        L_AWT_GroupName := P_Null;
        L_AWT_GroupID   := P_Null;
      End if;
    
      L_xxx_iHeaders.org_id     := iiHeaders.org_id;
      L_xxx_iHeaders.invoice_id := iiHeaders.invoii_ifaceid;
      --L_xxx_iHeaders.invoice_num              := iiHeaders.invoice_num;
      L_xxx_iHeaders.invoice_num              := L_Invoii_Num;
      L_xxx_iHeaders.invoice_type_lookup_code := iiHeaders.invoii_tii;
      L_xxx_iHeaders.invoice_currency_code    := iiHeaders.invoii_curr;
      L_xxx_iHeaders.exchange_rate_type       := L_xRate_TUi;
      L_xxx_iHeaders.exchange_date            := L_xxx_xDate;
      L_xxx_iHeaders.exchange_rate            := L_xxx_xRate;
      L_xxx_iHeaders.invoice_amount           := L_xxi_Amount;
      L_xxx_iHeaders.invoice_date             := iiHeaders.invoii_date;
      L_xxx_iHeaders.gl_date                  := L_Accounting_Date;
      L_xxx_iHeaders.vendor_id                := iiHeaders.supp_id;
      L_xxx_iHeaders.vendor_site_id           := iiHeaders.supp_siteid;
      L_xxx_iHeaders.vendor_name              := iiHeaders.supp_name;
      L_xxx_iHeaders.vendor_num               := iiHeaders.supp_number;
      L_xxx_iHeaders.vendor_site_code         := iiHeaders.supp_sitecode;
      L_xxx_iHeaders.awt_group_name           := L_AWT_GroupName;
      L_xxx_iHeaders.awt_group_id             := L_AWT_GroupID;
      L_xxx_iHeaders.terms_name               := iiHeaders.pmts_terms;
      L_xxx_iHeaders.terms_id                 := iiHeaders.pmtsterms_id;
      L_xxx_iHeaders.terms_date               := iiHeaders.invoii_date;
      L_xxx_iHeaders.payment_method_code      := iiHeaders.pmts_method;
      L_xxx_iHeaders.pay_group_lookup_code    := iiHeaders.pmts_group;
    
      ---- ---- Auto Caculate the Tax and SO the Flag marked Y/N.
      L_xxx_iHeaders.calc_tax_during_import_flag := L_xxx_FlagN;
      L_xxx_iHeaders.add_tax_to_inv_amt_flag     := L_xxx_FlagY;
    
      L_xxx_iHeaders.group_id    := iiHeaders.batch_id;
      L_xxx_iHeaders.description := L_AutoInvoii_PName;
      L_xxx_iHeaders.source      := P_Imported_Source;
    
      L_xxx_iHeaders.request_id        := fnd_global.conc_request_id;
      L_xxx_iHeaders.created_by        := fnd_global.user_id;
      L_xxx_iHeaders.creation_date     := SYSDATE;
      L_xxx_iHeaders.last_updated_by   := fnd_global.user_id;
      L_xxx_iHeaders.last_update_date  := SYSDATE;
      L_xxx_iHeaders.last_update_login := fnd_global.login_id;
    
      insert into ap_invoices_interface VALUES L_xxx_iHeaders;
      Update xxx_STD_AP_IvoiiImport_Headers xxx
         set xxx.imported_flag = L_Imported_FlagY,
             xxx.invoice_xnum  = L_Invoii_Num
       Where Current Of iHeaders;
      ---- ---- ---- ----End Loop the Invoii Headers
    End Loop iiHeaders;
  
    For iiLines in iLines(L_Batch_ID, L_Org_ID, L_Com_Code, L_TPName) Loop
    
      L_AutoInvoii_PName := P_AutoInvoii_PName ||
                            iiLines.Invoii_Ifacelineid;
      L_Invoii_Amount    := iiLines.l_Invoiiline_Amount;
      L_xxi_Amount       := Round(L_Invoii_Amount, L_Curr_Prii);
    
      L_PMTs_Curr     := iiLines.Invoii_Curr;
      L_AWT_GroupName := iiLines.withhold_taxcode;
      L_AWT_GroupID   := iiLines.withhold_taxid;
      if L_PMTs_Curr <> L_SOB_Curr Then
        L_AWT_GroupName := P_Null;
        L_AWT_GroupID   := P_Null;
      End if;
    
      L_xxx_iLines.ORG_ID                := iiLines.Org_ID;
      L_xxx_iLines.invoice_id            := iiLines.Invoii_Ifaceid;
      L_xxx_iLines.invoice_line_id       := iiLines.Invoii_Ifacelineid;
      L_xxx_iLines.line_number           := iiLines.L_Invoiiline_Number;
      L_xxx_iLines.line_type_lookup_code := iiLines.Invoii_Linetii;
      L_xxx_iLines.amount                := L_xxi_Amount;
      L_xxx_iLines.accounting_date       := iiLines.Invoiiline_GL_Date;
    
      L_xxx_GLCCID     := iiLines.GL_CCID;
      L_xxx_GLCCIDCode := iiLines.GL_Coa_Code;
    
      L_xxx_iLines.awt_group_name := L_AWT_GroupName;
      L_xxx_iLines.awt_group_id   := L_AWT_GroupID;
    
      ---- Insert the Tax info.
      L_xxx_iLines.line_group_number       := iiLines.Line_GroupNum;
      L_xxx_iLines.tax_classification_code := iiLines.Taxvat_Code;
    
      L_Regime_Code       := P_Null;
      L_xxx_Tax           := P_Null;
      L_Jurisdiction_Code := P_Null;
      L_Status_Code       := P_Null;
      L_Rate_Code         := P_Null;
      L_Tax_Rate          := P_Null;
      L_Rate_ID           := P_Null;
      L_xxx_AcrossFlag    := P_Null;
      if iiLines.Invoii_Linetii = P_xxx_Tax Then
        SELECT zbb.tax_regime_code,
               zbb.tax,
               zbb.tax_jurisdiction_code,
               zbb.tax_status_code,
               zbb.tax_rate_code,
               zbb.percentage_rate,
               zbb.tax_rate_id
          into L_Regime_Code,
               L_xxx_Tax,
               L_Jurisdiction_Code,
               L_Status_Code,
               L_Rate_Code,
               L_Tax_Rate,
               L_Rate_ID
        
          FROM zx_rates_b zbb
         where zbb.tax_rate_code = iiLines.Taxvat_Code;
        L_xxx_GLCCID                           := P_Null;
        L_xxx_GLCCIDCode                       := P_Null;
        L_xxx_AcrossFlag                       := L_Imported_FlagY;
        L_xxx_iLines.incl_in_taxable_line_flag := L_Imported_FlagY;
      End if;
      L_xxx_iLines.tax_regime_code       := L_Regime_Code;
      L_xxx_iLines.tax                   := L_xxx_Tax;
      L_xxx_iLines.tax_jurisdiction_code := L_Jurisdiction_Code;
      L_xxx_iLines.tax_status_code       := L_Status_Code;
      L_xxx_iLines.tax_rate_code         := L_Rate_Code;
      L_xxx_iLines.tax_rate              := L_Tax_Rate;
      L_xxx_iLines.tax_rate_id           := L_Rate_ID;
    
      L_xxx_iLines.prorate_across_flag      := L_xxx_AcrossFlag;
      L_xxx_iLines.dist_code_combination_id := L_xxx_GLCCID;
      L_xxx_iLines.default_dist_ccid        := L_xxx_GLCCID;
      L_xxx_iLines.dist_code_concatenated   := L_xxx_GLCCIDCode;
    
      L_xxx_iLines.description := L_AutoInvoii_PName;
    
      L_xxx_iLines.created_by        := fnd_global.user_id;
      L_xxx_iLines.creation_date     := SYSDATE;
      L_xxx_iLines.last_updated_by   := fnd_global.user_id;
      L_xxx_iLines.last_update_date  := SYSDATE;
      L_xxx_iLines.last_update_login := fnd_global.login_id;
    
      insert into ap_invoice_lines_interface VALUES L_xxx_iLines;
      Update xxx_STD_AP_IvoiiImport_Lines xxx
         set xxx.imported_flag = L_Imported_FlagY
       Where Current Of iLines;
    End Loop iiLines;
  
    Commit;
  End iFaceAutoTaxINY;

  /*===========================================================
  ---- Procedure Name:    iFaceAutoTaxINN()
  ---- To AutoCalculate the VAT Tax.
  ---- CALC_TAX_DURING_IMPORT_FLAG=N
  ---- ADD_TAX_TO_INV_AMT_FLAG=N
  ---- INCL_IN_TAXABLE_LINE_FLAG=Y
  =============================================================*/
  Procedure iFaceAutoTaxINN(P_Batch_ID In Number,
                            P_Org_ID   in Number,
                            P_Com_Code in varchar2,
                            P_TPName   in varchar2) IS
  
    Cursor iHeaders(P_Batch_ID In Number,
                    P_Org_ID   in Number,
                    P_Com_Code in varchar2,
                    P_TPName   in varchar2) is
      select *
        from xxx_STD_AP_IvoiiImport_Headers iH
       where iH.Batch_ID = P_Batch_ID
         and iH.Org_ID = P_Org_ID
         and iH.Com_Code = P_Com_Code
         and iH.Period_Name = P_TPName
         and iH.Imported_Flag = 'I'
         For Update Of iH.Imported_Flag, iH.Invoice_Xnum;
  
    Cursor iLines(P_Batch_ID In Number,
                  P_Org_ID   in Number,
                  P_Com_Code in varchar2,
                  P_TPName   in varchar2) is
      select *
        from xxx_STD_AP_IvoiiImport_Lines iL
       where iL.Batch_ID = P_Batch_ID
         and iL.Org_ID = P_Org_ID
         and iL.Com_Code = P_Com_Code
         and iL.Period_Name = P_TPName
         and iL.Imported_Flag = 'I'
         For Update Of iL.Imported_Flag;
  
    L_Org_ID   Number := P_Org_ID;
    L_Com_Code varchar2(15) := P_Com_Code;
    L_Batch_ID Number := P_Batch_ID;
    L_TPName   varchar2(15) := P_TPName;
  
    L_Imported_FlagY varchar2(2) := 'Y';
    L_xxx_FlagN      varchar2(2) := 'N';
    L_xxx_AcrossFlag varchar2(2) := 'N';
  
    L_Regime_Code       varchar2(200);
    L_xxx_Tax           varchar2(200);
    L_Jurisdiction_Code varchar2(200);
    L_Status_Code       varchar2(200);
    L_Rate_Code         varchar2(200);
    L_Tax_Rate          Number;
    L_Rate_ID           Number;
  
    L_SOB_Curr        varchar2(5);
    L_PMTs_Curr       varchar2(5);
    L_Curr_Prii       Number;
    L_xxx_GLCCID      Number;
    L_xxx_GLCCIDCode  varchar2(300);
    L_xRate_Ti        varchar2(30);
    L_xRate_TUi       varchar2(30);
    L_xxx_xDate       Date;
    L_Accounting_Date Date;
    L_xxx_xRate       Number;
    L_Invoii_Amount   Number;
    L_xBase_Amount    Number;
    L_xxi_Amount      Number;
    L_xxii_Amount     Number;
    L_Invoii_Num      varchar2(30);
    L_AWT_GroupName   varchar2(30);
    L_AWT_GroupID     Number;
  
    L_AutoInvoii_PName varchar2(100);
  
  Begin
  
    select app.base_currency_code, app.default_exchange_rate_type
      into L_SOB_Curr, L_xRate_Ti
      from ap_system_parameters_all app
     where app.org_id = L_Org_ID;
  
    select fnn.precision
      into L_Curr_Prii
      from fnd_currencies fnn
     where fnn.currency_code = L_SOB_Curr;
  
    For iiHeaders in iHeaders(L_Batch_ID, L_Org_ID, L_Com_Code, L_TPName) Loop
    
      L_AutoInvoii_PName := P_AutoInvoii_PName || iiHeaders.invoii_ifaceid;
      L_xxx_xDate        := P_Null;
      L_xRate_TUi        := P_Null;
      L_xxx_xRate        := P_Null;
      L_xBase_Amount     := P_Null;
    
      L_PMTs_Curr       := iiHeaders.invoii_curr;
      L_Accounting_Date := iiHeaders.invoii_gl_date;
      --L_Invoii_Amount   := iiHeaders.Invoiiheader_Amount;
      --Inclusive Tax Amount
      L_Invoii_Amount := iiHeaders.Invoiiitax_Amount;
      L_xxi_Amount    := Round(L_Invoii_Amount, L_Curr_Prii);
      L_Invoii_Num    := to_Char(SYSTIMESTAMP, 'YYYYMMDDHH24MISSFF4');
    
      L_AWT_GroupName := iiHeaders.withhold_taxcode;
      L_AWT_GroupID   := iiHeaders.withhold_taxid;
    
      if L_PMTs_Curr <> L_SOB_Curr Then
        L_xxx_xDate     := L_Accounting_Date;
        L_xRate_TUi     := L_xRate_Ti;
        L_xxx_xRate     := xxx_commonchecking_pkg.get_xxx_Rate(P_From_Curr       => L_PMTs_Curr,
                                                               P_To_Curr         => L_SOB_Curr,
                                                               P_xRate_Ti        => L_xRate_TUi,
                                                               P_Accounting_Date => L_xxx_xDate);
        L_xBase_Amount  := Round(L_Invoii_Amount * L_xxx_xRate, L_Curr_Prii);
        L_xxii_Amount   := Round(L_xBase_Amount, L_Curr_Prii);
        L_AWT_GroupName := P_Null;
        L_AWT_GroupID   := P_Null;
      End if;
    
      L_xxx_iHeaders.org_id     := iiHeaders.org_id;
      L_xxx_iHeaders.invoice_id := iiHeaders.invoii_ifaceid;
      --L_xxx_iHeaders.invoice_num              := iiHeaders.invoice_num;
      L_xxx_iHeaders.invoice_num              := L_Invoii_Num;
      L_xxx_iHeaders.invoice_type_lookup_code := iiHeaders.invoii_tii;
      L_xxx_iHeaders.invoice_currency_code    := iiHeaders.invoii_curr;
      L_xxx_iHeaders.exchange_rate_type       := L_xRate_TUi;
      L_xxx_iHeaders.exchange_date            := L_xxx_xDate;
      L_xxx_iHeaders.exchange_rate            := L_xxx_xRate;
      L_xxx_iHeaders.invoice_amount           := L_xxi_Amount;
      L_xxx_iHeaders.invoice_date             := iiHeaders.invoii_date;
      L_xxx_iHeaders.gl_date                  := L_Accounting_Date;
      L_xxx_iHeaders.vendor_id                := iiHeaders.supp_id;
      L_xxx_iHeaders.vendor_site_id           := iiHeaders.supp_siteid;
      L_xxx_iHeaders.vendor_name              := iiHeaders.supp_name;
      L_xxx_iHeaders.vendor_num               := iiHeaders.supp_number;
      L_xxx_iHeaders.vendor_site_code         := iiHeaders.supp_sitecode;
      L_xxx_iHeaders.awt_group_name           := L_AWT_GroupName;
      L_xxx_iHeaders.awt_group_id             := L_AWT_GroupID;
      L_xxx_iHeaders.terms_name               := iiHeaders.pmts_terms;
      L_xxx_iHeaders.terms_id                 := iiHeaders.pmtsterms_id;
      L_xxx_iHeaders.terms_date               := iiHeaders.invoii_date;
      L_xxx_iHeaders.payment_method_code      := iiHeaders.pmts_method;
      L_xxx_iHeaders.pay_group_lookup_code    := iiHeaders.pmts_group;
    
      ---- ---- If Auto Caculate the Tax and SO the Flag marked Y.
      L_xxx_iHeaders.calc_tax_during_import_flag := L_xxx_FlagN;
      L_xxx_iHeaders.add_tax_to_inv_amt_flag     := L_xxx_FlagN;
      L_xxx_iHeaders.group_id                    := iiHeaders.batch_id;
      L_xxx_iHeaders.description                 := L_AutoInvoii_PName;
      L_xxx_iHeaders.source                      := P_Imported_Source;
    
      L_xxx_iHeaders.request_id        := fnd_global.conc_request_id;
      L_xxx_iHeaders.created_by        := fnd_global.user_id;
      L_xxx_iHeaders.creation_date     := SYSDATE;
      L_xxx_iHeaders.last_updated_by   := fnd_global.user_id;
      L_xxx_iHeaders.last_update_date  := SYSDATE;
      L_xxx_iHeaders.last_update_login := fnd_global.login_id;
    
      insert into ap_invoices_interface VALUES L_xxx_iHeaders;
      Update xxx_STD_AP_IvoiiImport_Headers xxx
         set xxx.imported_flag = L_Imported_FlagY,
             xxx.invoice_xnum  = L_Invoii_Num
       Where Current Of iHeaders;
      ---- ---- ---- ----End Loop the Invoii Headers
    End Loop iiHeaders;
  
    For iiLines in iLines(L_Batch_ID, L_Org_ID, L_Com_Code, L_TPName) Loop
    
      L_AutoInvoii_PName := P_AutoInvoii_PName ||
                            iiLines.Invoii_Ifacelineid;
      L_Invoii_Amount    := iiLines.l_Invoiiline_Amount;
      L_xxi_Amount       := Round(L_Invoii_Amount, L_Curr_Prii);
    
      L_PMTs_Curr     := iiLines.Invoii_Curr;
      L_AWT_GroupName := iiLines.withhold_taxcode;
      L_AWT_GroupID   := iiLines.withhold_taxid;
      if L_PMTs_Curr <> L_SOB_Curr Then
        L_AWT_GroupName := P_Null;
        L_AWT_GroupID   := P_Null;
      End if;
    
      L_xxx_iLines.ORG_ID                := iiLines.Org_ID;
      L_xxx_iLines.invoice_id            := iiLines.Invoii_Ifaceid;
      L_xxx_iLines.invoice_line_id       := iiLines.Invoii_Ifacelineid;
      L_xxx_iLines.line_number           := iiLines.L_Invoiiline_Number;
      L_xxx_iLines.line_type_lookup_code := iiLines.Invoii_Linetii;
      L_xxx_iLines.amount                := L_xxi_Amount;
      L_xxx_iLines.accounting_date       := iiLines.Invoiiline_GL_Date;
    
      L_xxx_GLCCID     := iiLines.GL_CCID;
      L_xxx_GLCCIDCode := iiLines.GL_Coa_Code;
    
      L_xxx_iLines.awt_group_name := L_AWT_GroupName;
      L_xxx_iLines.awt_group_id   := L_AWT_GroupID;
    
      ---- Insert the Tax info.
      L_xxx_iLines.line_group_number       := iiLines.Line_GroupNum;
      L_xxx_iLines.tax_classification_code := iiLines.Taxvat_Code;
    
      L_Regime_Code       := P_Null;
      L_xxx_Tax           := P_Null;
      L_Jurisdiction_Code := P_Null;
      L_Status_Code       := P_Null;
      L_Rate_Code         := P_Null;
      L_Tax_Rate          := P_Null;
      L_Rate_ID           := P_Null;
      L_xxx_AcrossFlag    := P_Null;
      if iiLines.Invoii_Linetii = P_xxx_Tax Then
        SELECT zbb.tax_regime_code,
               zbb.tax,
               zbb.tax_jurisdiction_code,
               zbb.tax_status_code,
               zbb.tax_rate_code,
               zbb.percentage_rate,
               zbb.tax_rate_id
          into L_Regime_Code,
               L_xxx_Tax,
               L_Jurisdiction_Code,
               L_Status_Code,
               L_Rate_Code,
               L_Tax_Rate,
               L_Rate_ID
        
          FROM zx_rates_b zbb
         where zbb.tax_rate_code = iiLines.Taxvat_Code;
        L_xxx_GLCCID                           := P_Null;
        L_xxx_GLCCIDCode                       := P_Null;
        L_xxx_AcrossFlag                       := L_Imported_FlagY;
        L_xxx_iLines.incl_in_taxable_line_flag := L_Imported_FlagY;
      End if;
    
      L_xxx_iLines.prorate_across_flag      := L_xxx_AcrossFlag;
      L_xxx_iLines.dist_code_combination_id := L_xxx_GLCCID;
      L_xxx_iLines.default_dist_ccid        := L_xxx_GLCCID;
      L_xxx_iLines.dist_code_concatenated   := L_xxx_GLCCIDCode;
    
      L_xxx_iLines.tax_regime_code       := L_Regime_Code;
      L_xxx_iLines.tax                   := L_xxx_Tax;
      L_xxx_iLines.tax_jurisdiction_code := L_Jurisdiction_Code;
      L_xxx_iLines.tax_status_code       := L_Status_Code;
      L_xxx_iLines.tax_rate_code         := L_Rate_Code;
      L_xxx_iLines.tax_rate              := L_Tax_Rate;
      L_xxx_iLines.tax_rate_id           := L_Rate_ID;
    
      L_xxx_iLines.description := L_AutoInvoii_PName;
    
      L_xxx_iLines.created_by        := fnd_global.user_id;
      L_xxx_iLines.creation_date     := SYSDATE;
      L_xxx_iLines.last_updated_by   := fnd_global.user_id;
      L_xxx_iLines.last_update_date  := SYSDATE;
      L_xxx_iLines.last_update_login := fnd_global.login_id;
    
      insert into ap_invoice_lines_interface VALUES L_xxx_iLines;
      Update xxx_STD_AP_IvoiiImport_Lines xxx
         set xxx.imported_flag = L_Imported_FlagY
       Where Current Of iLines;
    End Loop iiLines;
  
    Commit;
  End iFaceAutoTaxINN;

  /*===========================================================
  ---- Procedure Name:    xxxMain()
  ---- The Main Procedure Of This pkg.
  =============================================================*/
  Procedure xxxMain(P_msg_Data  Out Varchar2,
                    P_msg_Count Out Number,
                    P_Com_Code  in varchar2,
                    P_TPName    in varchar2) is
    L_xxx_CCID Number;
  
    L_Org_ID       Number;
    L_Requesti_ID  Number;
    L_Requestii_ID Number;
    L_xxx_Waiting  BooLean;
    L_xxx_phase    Varchar2(2000);
    L_xxx_status   Varchar2(2000);
    L_Dev_phase    Varchar2(2000);
    L_Dev_status   Varchar2(2000);
    L_xxx_message  Varchar2(2000);
  
    L_Com_Code       varchar2(15);
    L_Batch_ID       Number;
    L_TPName         varchar2(15);
    L_Period_Opening Number;
    L_Start_Date     Date;
    L_End_Date       Date;
  
    L_Batch_Num varchar2(20);
  
  Begin
  
    L_Com_Code := P_Com_Code;
    L_TPName   := P_TPName;
  
    select Substr(to_Char(SYSTIMESTAMP, 'YYYYMMDDHH24MISSFF4'), 1, 11)
      into L_Batch_Num
      from dual;
    ---- ---- ---- ---- Get the Org_ID
    if L_Org_ID is Null Or L_Org_ID <> fnd_global.Org_ID Then
      L_Org_ID := fnd_global.Org_ID;
    End If;
    if L_Org_ID is Null Then
      Print_Output('PLS Set the OU Of the Profile!');
    End if;
  
    if L_Org_ID is not Null Then
      select faa.accts_pay_code_combination_id
        into L_xxx_CCID
        from financials_system_params_all faa
       where faa.set_of_books_id = fnd_profile.value('GL_SET_OF_BKS_ID')
         and faa.ORG_ID = L_Org_ID;
    End if;
    ---- ---- ---- ---- To Check the Period and gl Accounting Date.
    select Sum(1)
      into L_Period_Opening
      from gl_period_statuses gps
     where gps.set_of_books_id = fnd_profile.value('GL_SET_OF_BKS_ID')
       and gps.application_id = fnd_global.resp_appl_id
       and gps.period_name = L_TPName
       and gps.adjustment_period_flag = 'N'
       and gps.closing_status = 'O';
  
    ---- ---- ---- ---- To Build The Invoii Import Data Info.
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
    
      ---- ---- ---- ---- The Other Operations Defined Here Starting.
      Build_InvoiiHeader(L_Batch_ID, L_Org_ID, L_Com_Code, L_TPName);
      Build_InvoiiLine(L_Batch_ID, L_Org_ID, L_Com_Code, L_TPName);
      --iFaceAutoTaxYY(L_Batch_ID, L_Org_ID, L_Com_Code, L_TPName);
      --iFaceAutoTaxYN(L_Batch_ID, L_Org_ID, L_Com_Code, L_TPName);
      --iFaceAutoTaxNY(L_Batch_ID, L_Org_ID, L_Com_Code, L_TPName);
      --iFaceAutoTaxNN(L_Batch_ID, L_Org_ID, L_Com_Code, L_TPName);
      iFaceAutoTaxINY(L_Batch_ID, L_Org_ID, L_Com_Code, L_TPName);
      --iFaceAutoTaxINN(L_Batch_ID, L_Org_ID, L_Com_Code, L_TPName);
    
      ---- ---- ---- ---- To Open Interface Import
      L_Requesti_ID := fnd_request.submit_request(application => 'SQLAP',
                                                  program     => 'APXIIMPT',
                                                  description => P_Imported_Source,
                                                  start_time  => to_char(SYSDATE,
                                                                         'YYYY/MM/DD HH24:MI:SS'),
                                                  Sub_request => FALSE,
                                                  argument1   => L_Org_ID,
                                                  argument2   => P_Imported_Source,
                                                  argument3   => P_Null,
                                                  argument4   => L_Batch_Num);
    
      dbms_output.put_line('L_Requesti_ID:' || L_Requesti_ID);
      Print_Logs('L_Requesti_ID:' || L_Requesti_ID);
      Print_Output('L_Requesti_ID:' || L_Requesti_ID);
    
      /*L_Requesti_ID := L_Requesti_ID + 1;      
      if L_Requesti_ID - 1 > 0 Then
        Update ap_batches_all abb
           set abb.ORG_ID                = L_Org_ID,
               abb.control_invoice_count = P_Null,
               abb.control_invoice_total = P_Null
         where abb.batch_name = L_Batch_Num;
        Commit;
      
        L_Requestii_ID := fnd_request.submit_request(application => 'SQLAP',
                                                     program     => 'APPRVL',
                                                     description => P_Imported_Source,
                                                     start_time  => to_char(SYSDATE,
                                                                            'YYYY/MM/DD HH24:MI:SS'),
                                                     Sub_request => FALSE,
                                                     argument1   => L_Org_ID,
                                                     argument2   => 'All');
      End if;*/
    
      if L_Requesti_ID > 0 Then
        ----Need Commit the Update Records Before.
        COMMIT;
      
        L_xxx_Waiting := fnd_concurrent.wait_for_request(Request_id => L_Requesti_ID,
                                                         interval   => 5,
                                                         max_wait   => 0,
                                                         phase      => L_xxx_phase,
                                                         status     => L_xxx_status,
                                                         dev_phase  => L_Dev_phase,
                                                         dev_status => L_Dev_status,
                                                         message    => L_xxx_message);
      
        ---- ---- ---- ---- Set the Org Of the ap_Batch_all.
        if L_xxx_Waiting Then
          Update ap_batches_all abb
             set abb.ORG_ID                    = L_Org_ID,
                 abb.batch_code_combination_id = L_xxx_CCID,
                 abb.control_invoice_count     = P_Null,
                 abb.control_invoice_total     = P_Null
           where abb.batch_name = L_Batch_Num;
          Commit;
          ---- ---- ---- ---- To Invoice Validation
          L_Requestii_ID := fnd_request.submit_request(application => 'SQLAP',
                                                       program     => 'APPRVL',
                                                       description => P_Imported_Source,
                                                       start_time  => to_char(SYSDATE,
                                                                              'YYYY/MM/DD HH24:MI:SS'),
                                                       Sub_request => FALSE,
                                                       argument1   => L_Org_ID,
                                                       argument2   => 'All');
        End if;
        ----Ending L_xxx_Waiting
      End if;
    
    End if;
    ---- ---- ---- ----
  
    /*Submit_Request(P_Comcode      => P_Comcode,
                   P_TPName       => L_TPName,
                   P_Rturn_Status => x_Rturn_Status,
                   P_msg_Data     => x_msg_Data,
                   P_Request_ID   => x_Request_ID);
    
    Print_Logs('P_Request_ID:' || x_Request_ID);
    Print_Logs('P_Rturn_Status:' || x_Rturn_Status);*/
  
  End xxxMain;

End xxx_STD_AP_IvoiiImport_pkg;
/
