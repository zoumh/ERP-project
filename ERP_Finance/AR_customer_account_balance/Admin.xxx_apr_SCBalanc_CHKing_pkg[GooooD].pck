CREATE OR REPLACE Package xxx_apr_SCBalanc_CHKing_pkg Is
  /*===============================================================
  *   Copyright (C) 
  * ===============================================================
  *    Program Name:   xxx_apr_SCBalanc_CHKing_pkg
  *    Author      :   Doris ZOU
  *    Date        :   2013-02-28
  *    Purpose     :   Pl/Sql Html Report PKG
  *                    Extract the AP/AR Supplier/Customer Balances Info Details.
  *
  *    Update History
  *    Version    Date                             Name                           Description
  *    --------  ----------  ----------------------------------  --------------------
  *     V1.0     2013-02-28     Doris ZOU.         Creation
  *
    ===============================================================*/
  ----  ----
  /*===========================================================
  ---- Procedure Name:    Build_BalncH()
  ---- To Build the Balance Of This Month.
  ---- If the Period is Open Or the Accounting SUM still are D Status.
  =============================================================*/
  Procedure Build_BalncH(P_LPName in varchar2,
                         P_TPName in varchar2,
                         P_Flag   in varchar2,
                         P_SCode  in varchar2,
                         P_SCMark in varchar2);

  /*===========================================================
  ---- Procedure Name:    Build_BalncNR()
  ---- To Build the Balance Of This Month For the AR with Non-Part_ID.
  ---- If the Period is Open Or the Accounting SUM still are D Status.
  =============================================================*/
  Procedure Build_BalncNR(P_LPName  in varchar2,
                          P_TPName  in varchar2,
                          P_Flag    in varchar2,
                          P_SCode   in varchar2,
                          P_SCnMark in varchar2);

  /*===========================================================
  ---- Procedure Name:    Build_BalncNP()
  ---- To Build the Balance Of This Month For the AP with Non-Part_ID.
  ---- If the Period is Open Or the Accounting SUM still are D Status.
  =============================================================*/
  Procedure Build_BalncNP(P_LPName  in varchar2,
                          P_TPName  in varchar2,
                          P_Flag    in varchar2,
                          P_SCode   in varchar2,
                          P_SCnMark in varchar2);

  /*===========================================================
  ---- Func Name:    CountSumSCN()
  ---- To Count the 'P_TPStatus' Records.
  ---- 'O' Or 'C' Status Of the Period.
  =============================================================*/
  Function CountSumSCN(P_TPName   in varchar2,
                       P_TPStatus in varchar2,
                       P_SCMark   in varchar2) Return Number;

  /*===========================================================
  ---- Procedure Name:    Balanc_CHKing()
  ---- The Main Procedure Of This pkg.
  =============================================================*/
  Procedure Balanc_CHKing(errbuf   Out Varchar2,
                                      retcode  Out Number,
                                      P_TPName in varchar2);

End xxx_apr_SCBalanc_CHKing_pkg;
/
CREATE OR REPLACE Package Body xxx_apr_SCBalanc_CHKing_pkg Is
  /*===============================================================
  *   Copyright (C) Doris ZOU. Consulting Co., Ltd All rights reserved
  * ===============================================================
  *    Program Name:   xxx_apr_SCBalanc_CHKing_pkg
  *    Author      :   Doris ZOU
  *    Date        :   2013-02-28
  *    Purpose     :   Pl/Sql Html Report PKG
  *                    Extract the AP/AR Supplier/Customer Balances Info Details.
  *
  *    Update History
  *    Version    Date                             Name                           Description
  *    --------  ----------  ----------------------------------  --------------------
  *     V1.0     2013-02-28     Doris ZOU.         Creation
  *
    ===============================================================*/
  ----  ----
  /*===========================================================
  ---- Procedure Name:    Build_BalncH()
  ---- To Build the Balance Of This Month.
  ---- If the Period is Open Or the Accounting SUM still are D Status.
  =============================================================*/
  PROCEDURE Build_BalncH(P_LPName in varchar2,
                         P_TPName in varchar2,
                         P_Flag   in varchar2,
                         P_SCode  in varchar2,
                         P_SCMark in varchar2) IS
  begin
    delete xxx_xla_Sum_Log xla_SumT
     where xla_SumT.PD_Name = P_TPName
       and xla_SumT.party_code = P_SCode
       and xla_SumT.Org_ID = fnd_global.Org_id
       and xla_SumT.SC_Mark = P_SCMark
       and xla_SumT.Application_ID = fnd_global.resp_appl_ID;
  
    --delete apps.xxx_ar_RCPTs_Log xarL where xarL.pd_name = '&PN';
    --delete from apps.xxx_ar_RCPTs_Log xarL where xarL.pd_name = '&PN';
  
    commit;
  
    insert into apps.xxx_xla_Sum_Log
      select Org_ID,
             PD_Name,
             application_id,
             Cur_Code,
             gcc_CCID,
             Party_Code,
             Party_ID,
             Site_Use_ID,
             P_Flag Status,
             P_SCMark SC_Mark,
             SUM(Balnc_Start) Balnc_Start,
             SUM(Balnc_Start) + SUM(Entered_Dr) - SUM(Entered_Cr) Balnc_End,
             SUM(Balnc_ACCTD_Start) Balnc_ACCTD_Start,
             SUM(Balnc_ACCTD_Start) + SUM(Accounted_Dr) - SUM(Accounted_Cr) Balnc_ACCTD_End,
             SUM(Entered_Dr) Entered_Dr,
             SUM(Entered_Cr) Entered_Cr,
             SUM(Accounted_Dr) Accounted_Dr,
             SUM(Accounted_Cr) Accounted_Cr
      
        From (select Org_ID,
                     P_TPName        PD_Name,
                     application_id,
                     Cur_Code,
                     gcc_CCID,
                     Party_Code,
                     Party_ID,
                     Site_Use_ID,
                     P_Flag          Status,
                     Balnc_End       Balnc_Start,
                     0               Balnc_End,
                     Balnc_ACCTD_End Balnc_ACCTD_Start,
                     0               Balnc_ACCTD_End,
                     0               Entered_Dr,
                     0               Entered_Cr,
                     0               Accounted_Dr,
                     0               Accounted_Cr
              
                From xxx_xla_Sum_Log xla_SumE
               where PD_Name = P_LPName
                 and party_code = P_SCode
                 and SC_Mark = P_SCMark
                 and Org_ID = fnd_global.Org_ID
                 and xla_SumE.Application_Id = fnd_global.resp_Appl_ID
              
              Union All
              select fnd_global.Org_ID       Org_ID,
                     gps.period_name         PD_Name,
                     xah.application_id,
                     xal.currency_code       Cur_Code,
                     xal.code_combination_id gcc_CCID,
                     xal.party_type_code     Party_Code,
                     xal.party_id            Party_ID,
                     xal.party_site_id       Site_Use_ID,
                     
                     P_Flag Status,
                     
                     0 Balnc_Start,
                     0 Balnc_End,
                     0 Balnc_ACCTD_Start,
                     0 Balnc_ACCTD_End,
                     
                     nvl(xal.entered_Dr, 0) entered_Dr,
                     nvl(xal.entered_Cr, 0) entered_Cr,
                     nvl(xal.accounted_Dr, 0) accounted_Dr,
                     nvl(xal.accounted_Cr, 0) accounted_Cr
              
                from xla_ae_headers               xah,
                     xla_ae_lines                 xal,
                     xla.xla_transaction_entities xte,
                     gl_period_statuses           gps
              
               where xal.party_type_code = P_SCode
                 and xal.ledger_id = gps.set_of_books_id
                 and gps.application_id = fnd_global.resp_appl_id
                 and gps.adjustment_period_flag = 'N'
                 and gps.period_name = P_TPName
                 and (xal.accounting_date >= gps.start_date and
                     xal.accounting_date <= gps.end_date)
                 and xah.period_name = P_TPName
                 and xah.application_id = fnd_global.resp_appl_id
                 and xah.ae_header_id = xal.ae_header_id
                 and xah.balance_type_code = 'A'
                 and xah.entity_id = xte.entity_id
                    ---- ---- To Get The Transactions with Party_ID have.
                 and xal.party_id IS Not NULL
                 and fnd_global.Org_ID = xte.security_ID_int_1)
      
       group by Org_ID,
                PD_Name,
                application_id,
                Cur_Code,
                gcc_CCID,
                Party_Code,
                Party_ID,
                Site_Use_ID,
                Status;
    Commit;
  end Build_BalncH;

  /*===========================================================
  ---- Procedure Name:    Build_BalncNR()
  ---- To Build the Balance Of This Month For the AR with Non-Part_ID.
  ---- If the Period is Open Or the Accounting SUM still are D Status.
  =============================================================*/
  PROCEDURE Build_BalncNR(P_LPName  in varchar2,
                          P_TPName  in varchar2,
                          P_Flag    in varchar2,
                          P_SCode   in varchar2,
                          P_SCnMark in varchar2) IS
  begin
    delete xxx_xla_Sum_Log xla_SumT
     where xla_SumT.PD_Name = P_TPName
       and xla_SumT.party_code = P_SCode
       and xla_SumT.Org_ID = fnd_global.Org_id
       and xla_SumT.SC_Mark = P_SCnMark
       and xla_SumT.Application_Id = fnd_global.resp_appl_id;
  
    commit;
  
    insert into apps.xxx_xla_Sum_Log
      select Org_ID,
             PD_Name,
             application_id,
             Cur_Code,
             gcc_CCID,
             Party_Code,
             Party_ID,
             Site_Use_ID,
             P_Flag Status,
             P_SCnMark SC_Mark,
             SUM(Balnc_Start) Balnc_Start,
             SUM(Balnc_Start) + SUM(Entered_Dr) - SUM(Entered_Cr) Balnc_End,
             SUM(Balnc_ACCTD_Start) Balnc_ACCTD_Start,
             SUM(Balnc_ACCTD_Start) + SUM(Accounted_Dr) - SUM(Accounted_Cr) Balnc_ACCTD_End,
             SUM(Entered_Dr) Entered_Dr,
             SUM(Entered_Cr) Entered_Cr,
             SUM(Accounted_Dr) Accounted_Dr,
             SUM(Accounted_Cr) Accounted_Cr
      
        From (select Org_ID,
                     P_TPName        PD_Name,
                     application_id,
                     Cur_Code,
                     gcc_CCID,
                     Party_Code,
                     Party_ID,
                     Site_Use_ID,
                     P_Flag          Status,
                     Balnc_End       Balnc_Start,
                     0               Balnc_End,
                     Balnc_ACCTD_End Balnc_ACCTD_Start,
                     0               Balnc_ACCTD_End,
                     0               Entered_Dr,
                     0               Entered_Cr,
                     0               Accounted_Dr,
                     0               Accounted_Cr
              
                From xxx_xla_Sum_Log xla_SumE
               where PD_Name = P_LPName
                 and party_code = P_SCode
                 and SC_Mark = P_SCnMark
                 and Org_ID = fnd_global.Org_ID
                 and xla_SumE.Application_Id = fnd_global.resp_Appl_ID
              
              Union All
              select fnd_global.Org_ID Org_ID,
                     gps.period_name PD_Name,
                     xah.application_id,
                     xal.currency_code Cur_Code,
                     xal.code_combination_id gcc_CCID,
                     xal.party_type_code Party_Code,
                     nvl(aca.pay_from_customer, 99959266) Party_ID,
                     nvl(aca.customer_site_use_id, 99959266) Site_Use_ID,
                     
                     P_Flag Status,
                     
                     0 Balnc_Start,
                     0 Balnc_End,
                     0 Balnc_ACCTD_Start,
                     0 Balnc_ACCTD_End,
                     
                     nvl(xal.entered_Dr, 0) entered_Dr,
                     nvl(xal.entered_Cr, 0) entered_Cr,
                     nvl(xal.accounted_Dr, 0) accounted_Dr,
                     nvl(xal.accounted_Cr, 0) accounted_Cr
              
                from xla_ae_headers               xah,
                     xla_ae_lines                 xal,
                     xla.xla_transaction_entities xte,
                     ar_cash_receipts_all         aca,
                     gl_period_statuses           gps
              
               where xal.party_type_code = P_SCode
                 and xal.ledger_id = gps.set_of_books_id
                 and gps.application_id = fnd_global.resp_appl_id
                 and gps.adjustment_period_flag = 'N'
                 and gps.period_name = P_TPName
                 and (xal.accounting_date >= gps.start_date and
                     xal.accounting_date <= gps.end_date)
                 and xah.period_name = P_TPName
                 and xah.application_id = fnd_global.resp_appl_id
                 and xah.ae_header_id = xal.ae_header_id
                 and xah.balance_type_code = 'A'
                 and xah.entity_id = xte.entity_id
                 and (xal.party_type_code = 'C' and xal.party_id IS NULL)
                 and aca.org_id = fnd_global.Org_ID
                 and aca.cash_receipt_id = nvl(xte.source_id_int_1, -9999)
                 and fnd_global.Org_ID = xte.security_ID_int_1)
      
       group by Org_ID,
                PD_Name,
                application_id,
                Cur_Code,
                gcc_CCID,
                Party_Code,
                Party_ID,
                Site_Use_ID,
                Status;
    Commit;
  end Build_BalncNR;

  /*===========================================================
  ---- Procedure Name:    Build_BalncNP()
  ---- To Build the Balance Of This Month For the AP with Non-Part_ID.
  ---- If the Period is Open Or the Accounting SUM still are D Status.
  =============================================================*/
  PROCEDURE Build_BalncNP(P_LPName  in varchar2,
                          P_TPName  in varchar2,
                          P_Flag    in varchar2,
                          P_SCode   in varchar2,
                          P_SCnMark in varchar2) IS
  begin
    delete xxx_xla_Sum_Log xla_SumT
     where xla_SumT.PD_Name = P_TPName
       and xla_SumT.party_code = P_SCode
       and xla_SumT.Org_ID = fnd_global.Org_id
       and xla_SumT.SC_Mark = P_SCnMark
       and xla_SumT.Application_Id = fnd_global.resp_appl_id;
  
    commit;
  
    insert into apps.xxx_xla_Sum_Log
      select Org_ID,
             PD_Name,
             application_id,
             Cur_Code,
             gcc_CCID,
             Party_Code,
             Party_ID,
             Site_Use_ID,
             P_Flag Status,
             P_SCnMark SC_Mark,
             SUM(Balnc_Start) Balnc_Start,
             SUM(Balnc_Start) + SUM(Entered_Dr) - SUM(Entered_Cr) Balnc_End,
             SUM(Balnc_ACCTD_Start) Balnc_ACCTD_Start,
             SUM(Balnc_ACCTD_Start) + SUM(Accounted_Dr) - SUM(Accounted_Cr) Balnc_ACCTD_End,
             SUM(Entered_Dr) Entered_Dr,
             SUM(Entered_Cr) Entered_Cr,
             SUM(Accounted_Dr) Accounted_Dr,
             SUM(Accounted_Cr) Accounted_Cr
      
        From (select Org_ID,
                     P_TPName        PD_Name,
                     application_id,
                     Cur_Code,
                     gcc_CCID,
                     Party_Code,
                     Party_ID,
                     Site_Use_ID,
                     P_Flag          Status,
                     Balnc_End       Balnc_Start,
                     0               Balnc_End,
                     Balnc_ACCTD_End Balnc_ACCTD_Start,
                     0               Balnc_ACCTD_End,
                     0               Entered_Dr,
                     0               Entered_Cr,
                     0               Accounted_Dr,
                     0               Accounted_Cr
              
                From xxx_xla_Sum_Log xla_SumE
               where PD_Name = P_LPName
                 and party_code = P_SCode
                 and SC_Mark = P_SCnMark
                 and Org_ID = fnd_global.Org_ID
                 and xla_SumE.Application_Id = fnd_global.resp_Appl_ID
              
              Union All
              select fnd_global.Org_ID Org_ID,
                     gps.period_name PD_Name,
                     xah.application_id,
                     xal.currency_code Cur_Code,
                     xal.code_combination_id gcc_CCID,
                     P_SCode Party_Code,
                     nvl(aia.party_id, 99959266) Party_ID,
                     nvl(aia.party_site_id, 99959266) Site_Use_ID,
                     
                     P_Flag Status,
                     
                     0 Balnc_Start,
                     0 Balnc_End,
                     0 Balnc_ACCTD_Start,
                     0 Balnc_ACCTD_End,
                     
                     nvl(xal.entered_Dr, 0) entered_Dr,
                     nvl(xal.entered_Cr, 0) entered_Cr,
                     nvl(xal.accounted_Dr, 0) accounted_Dr,
                     nvl(xal.accounted_Cr, 0) accounted_Cr
              
                from xla_ae_headers               xah,
                     xla_ae_lines                 xal,
                     xla.xla_transaction_entities xte,
                     ap_invoices_all              aia,
                     gl_period_statuses           gps
              
               where nvl(xal.party_type_code, 'S') = P_SCode
                 and xal.ledger_id = gps.set_of_books_id
                 and gps.application_id = fnd_global.resp_appl_id
                 and gps.adjustment_period_flag = 'N'
                 and gps.period_name = P_TPName
                 and (xal.accounting_date >= gps.start_date and
                      xal.accounting_date <= gps.end_date)
                 and xah.period_name = P_TPName
                 and xah.application_id = fnd_global.resp_appl_id
                 and xah.ae_header_id = xal.ae_header_id
                 and xah.balance_type_code = 'A'
                 and xah.entity_id = xte.entity_id
                 and (xal.party_type_code IS NULL and xal.party_id IS NULL)
                 and aia.org_id = fnd_global.Org_ID
                 and aia.invoice_id = nvl(xte.source_id_int_1, -9999)
                 and fnd_global.Org_ID = xte.security_ID_int_1
              
              Union All
              select fnd_global.Org_ID Org_ID,
                     gps.period_name PD_Name,
                     xah.application_id,
                     xal.currency_code Cur_Code,
                     xal.code_combination_id gcc_CCID,
                     P_SCode Party_Code,
                     nvl(aca.party_site_id, 99959266) Party_ID,
                     nvl(aca.party_site_id, 99959266) Site_Use_ID,
                     
                     P_Flag Status,
                     
                     0 Balnc_Start,
                     0 Balnc_End,
                     0 Balnc_ACCTD_Start,
                     0 Balnc_ACCTD_End,
                     
                     nvl(xal.entered_Dr, 0) entered_Dr,
                     nvl(xal.entered_Cr, 0) entered_Cr,
                     nvl(xal.accounted_Dr, 0) accounted_Dr,
                     nvl(xal.accounted_Cr, 0) accounted_Cr
              
                from xla_ae_headers               xah,
                     xla_ae_lines                 xal,
                     xla.xla_transaction_entities xte,
                     ap_checks_all                aca,
                     gl_period_statuses           gps
              
               where nvl(xal.party_type_code, 'S') = P_SCode
                 and xal.ledger_id = gps.set_of_books_id
                 and gps.application_id = fnd_global.resp_appl_id
                 and gps.adjustment_period_flag = 'N'
                 and gps.period_name = P_TPName
                 and (xal.accounting_date >= gps.start_date and
                      xal.accounting_date <= gps.end_date)
                 and xah.period_name = P_TPName
                 and xah.application_id = fnd_global.resp_appl_id
                 and xah.ae_header_id = xal.ae_header_id
                 and xah.balance_type_code = 'A'
                 and xah.entity_id = xte.entity_id
                 and (xal.party_type_code IS NULL and xal.party_id IS NULL)
                 and aca.org_id = fnd_global.Org_ID
                 and aca.check_id = nvl(xte.source_id_int_1, -9999)
                 and fnd_global.Org_ID = xte.security_ID_int_1)
      
       group by Org_ID,
                PD_Name,
                application_id,
                Cur_Code,
                gcc_CCID,
                Party_Code,
                Party_ID,
                Site_Use_ID,
                Status;
    Commit;
  end Build_BalncNP;
  /*===========================================================
  ---- Func Name:    CountSumSCN()
  ---- To Count the 'P_TPStatus' Records.
  ---- 'O' Or 'C' Status Of the Period.
  =============================================================*/
  Function CountSumSCN(P_TPName   in varchar2,
                       P_TPStatus in varchar2,
                       P_SCMark   in varchar2) Return Number IS
    L_TPStatus_Sum Number := 0;
  
  Begin
    select Count(*)
      into L_TPStatus_Sum
      from xxx_xla_Sum_Log xla_SumT
     where xla_SumT.status = P_TPStatus
       and xla_SumT.Pd_Name = P_TPName
       and xla_SumT.SC_Mark = P_SCMark
       and xla_SumT.Application_Id = fnd_global.resp_Appl_ID;
    Return(L_TPStatus_Sum);
  
  End CountSumSCN;

  /*===========================================================
  ---- Procedure Name:    Balanc_CHKing()
  ---- The Main Procedure Of This pkg.
  =============================================================*/
  Procedure Balanc_CHKing(errbuf   Out Varchar2,
                                      retcode  Out Number,
                                      P_TPName IN VARCHAR2) IS
  
    L_LPName     varchar2(7);
    L_PDStaus    varchar2(2);
    L_P_SCode    varchar2(2);
    L_P_SCMark   varchar2(2) := 'H';
    L_P_SCnMark  varchar2(2) := 'N';
    L_HOpen_Num  number := 0;
    L_HClose_Num number := 0;
    L_NOpen_Num  number := 0;
    L_NClose_Num number := 0;
  
    ---- ---- ---- ---- Define the variables here...
    L_num       number := 0;
    L_rows      Varchar2(60);
    L_rowscolor Varchar2(60);
    L_rowm      Varchar2(60);
    L_rowmcolor Varchar2(60);
    L_rowe      Varchar2(15);
    L_lines     Varchar2(15);
    L_linem     Varchar2(15);
    L_linee     Varchar2(15);
  
    L_headers Varchar2(150);
    L_headerm Varchar2(500);
    L_headere Varchar2(100);
  
    L_style Varchar2(1200);
    L_body  Varchar2(100);
  
    L_tablesexcel Varchar2(600);
    L_tables      Varchar2(150);
    L_tablem      Varchar2(100);
    L_tablee      Varchar2(100);
    L_Export      Varchar2(100);
  
    L_BkClor  Varchar2(30) Default 'bgcolor=#FFC000';
    L_BkClorA Varchar2(30) Default 'bgcolor=#E6F2FF';
    L_BkClorB Varchar2(30) Default 'bgcolor=#92D050';
    L_BkClorC Varchar2(30) Default 'bgcolor=#E26B0A';
    L_BkClorD Varchar2(30) Default 'bgcolor=#A6A6A6';
    L_BkClorE Varchar2(30) Default 'bgcolor=#FABF8F';
    L_BkClorF Varchar2(30) Default 'bgcolor=#948A54';
    L_BkClorF Varchar2(30) Default 'bgcolor=#CCCC00';
  
    L_Rtittle Varchar2(1500);
  
    LP_style             Varchar2(100) Default '<!-- .amount {mso-number-format:Standard;text-align:right;}-->';
    LP_program_title     Varchar2(100) Default '...AP&AR Supplier&Customer Acount SumAmount Info Checking...';
    LP_report_title_attr Varchar2(100) Default 'align=center style="font-family: Calibri; font-size: 20pt"';
  
    ---- ---- ---- ---- the Name Defined Of this Report...
    LP_report_title Varchar2(100) Default '... ...AP&AR Supplier&Customer Acount SumAmount Info Checking...  ----  By Doris ZOU... ...';
  
    LP_title_string Varchar2(2000);
  
    Cursor anpeng Is
    ----  ----  ----  ---- the Beginning of select[Cursor or Main Cursor]...
      select xla_SumT.*, gcck.concatenated_segments gcc_Account
        from xxx_xla_Sum_Log xla_SumT, gl_code_combinations_kfv gcck
       where xla_SumT.Pd_Name = P_TPName
         and xla_SumT.Application_Id = fnd_global.resp_appl_id
         and xla_SumT.Gcc_Ccid = gcck.code_combination_id
       Order by xla_SumT.Party_ID, xla_SumT.gcc_CCID;
  
  begin
  
    ---- ---- ---- ---- gvie values to the variables here...
    L_rows      := '<td>';
    L_rowscolor := '<td ' || L_BkClor || '>';
    L_rowm      := '</td><td>';
    L_rowmcolor := '</td><td ' || L_BkClor || '>';
    L_rowe      := '</td>';
  
    L_lines := '<tr>';
    L_linem := '</tr><tr>';
    L_linee := '</tr>';
  
    L_tableSExcel := '<table width=100% style="border-collapse:collapse; 
    border:none; font-family:Courier; font-size: 10pt"
    border=1 bordercolor=#000000 cellspacing="0" id="execl" name="execl">';
  
    L_tablem := '</table><table>';
    L_tablee := '</table>';
  
    ---- ---- ---- ---- Output the html_title...
    L_headers := '<html><head><meta content="text/html; charset=utf-8" http-equiv="Content-Type" />';
  
    L_headerm := '<style>' || LP_style || '</style>' || '<title>' ||
                 LP_program_title || '</title>' || '<H1 ' ||
                 LP_report_title_attr || '>' || LP_report_title || '</H1>';
  
    L_style := '<style>
                        table{border:1px solid #000;margin:2px 0;border-collapse:collapse;}
                        td{border:1px solid #000;margin:2px 0;}
                        .th1{font:600 12px;background:#E6F2FF;}
                        .t1{border:0px;font:12}
                        </style>
                        <SCRIPT LANGUAGE="javascript">
                         function method1(tableid) {
                            var curTbl = document.getElementById(tableid);
                            var oXL = new ActiveXObject("Excel.Application");
                            var oWB = oXL.Workbooks.Add();
                            var oSheet = oWB.ActiveSheet;
                            var sel = document.body.createTextRange();
                            sel.moveToElementText(curTbl);
                            sel.select();
                            sel.execCommand("Copy");
                            oSheet.Paste();
                            oXL.Visible = true;
                        }
                        </script>';
  
    L_body    := '</head><body>';
    L_Export  := '<input type="submit" onclick=method1("execl")  value="Export"/>';
    L_headere := '</body></html>';
  
    ---- ---- ---- ---- The Other Operations Defined Here Starting.
    select Substr(to_Char(gps.start_date - 1, 'YYYY-MM-DD'), 1, 7),
           gps.closing_status,
           decode(gps.application_id, 222, 'C', 200, 'S')
      into L_LPName, L_PDStaus, L_P_SCode
      from gl_period_statuses gps
     where gps.set_of_books_id = fnd_profile.value('GL_SET_OF_BKS_ID')
       and gps.application_id = fnd_global.resp_appl_id
       and gps.adjustment_period_flag = 'N'
       and gps.period_name = P_TPName;
  
    L_HOpen_Num  := CountSumSCN(P_TPName, 'O', L_P_SCMark);
    L_HClose_Num := CountSumSCN(P_TPName, 'C', L_P_SCMark);
    L_NOpen_Num  := CountSumSCN(P_TPName, 'O', L_P_SCnMark);
    L_NClose_Num := CountSumSCN(P_TPName, 'C', L_P_SCnMark);
  
    if (L_HOpen_Num > 0 and L_PDStaus = 'C' Or L_PDStaus = 'O') then
      Build_BalncH(L_LPName, P_TPName, L_PDStaus, L_P_SCode, L_P_SCMark);
    End if;
    if (L_NOpen_Num > 0 and L_PDStaus = 'C' Or L_PDStaus = 'O') and
       (L_P_SCode = 'C') then
      Build_BalncNR(L_LPName, P_TPName, L_PDStaus, L_P_SCode, L_P_SCnMark);
    End if;
    if (L_NOpen_Num > 0 and L_PDStaus = 'C' Or L_PDStaus = 'O') and
       (L_P_SCode = 'S') then
      Build_BalncNP(L_LPName, P_TPName, L_PDStaus, L_P_SCode, L_P_SCnMark);
    End if;
    if (L_HClose_Num = 0 and L_PDStaus = 'C') then
      Build_BalncH(L_LPName, P_TPName, L_PDStaus, L_P_SCode, L_P_SCMark);
    End if;
    if (L_NClose_Num = 0 and L_PDStaus = 'C') and (L_P_SCode = 'C') then
      Build_BalncNR(L_LPName, P_TPName, L_PDStaus, L_P_SCode, L_P_SCnMark);
    End if;
    if (L_NClose_Num = 0 and L_PDStaus = 'C') and (L_P_SCode = 'S') then
      Build_BalncNP(L_LPName, P_TPName, L_PDStaus, L_P_SCode, L_P_SCnMark);
    End if;
    ---- ---- ---- ---- The Other Operations Defined Here Ending.
  
    ---- ---- ---- ---- Define the Report Tittle in this Table...
    L_Rtittle := L_lines || L_rowscolor || 'No.' || L_rowscolor || 'Org_ID' ||
                 L_rowmcolor || 'Appl_ID' || L_rowmcolor || 'PD_Name' ||
                 L_rowmcolor || 'PD_Status' || L_rowmcolor || 'Cur_Code' ||
                 L_rowmcolor || 'gcc_CCID' || L_rowmcolor || 'gcc_Account' ||
                 L_rowmcolor || 'ScCode' || L_rowmcolor || 'SCMark' ||
                 L_rowmcolor || 'Party_ID' || L_rowmcolor || 'Site_Use_ID' ||
                 L_rowmcolor || 'Balnc_Start' || L_rowmcolor ||
                 'Balnc_ACCTD_Start' || L_rowmcolor || 'Balnc_End' ||
                 L_rowmcolor || 'Balnc_ACCTD_End' || L_rowmcolor ||
                 'Entered_Dr' || L_rowmcolor || 'Entered_Cr' || L_rowmcolor ||
                 'Accounted_Dr' || L_rowmcolor || 'Accounted_Cr' || L_rowe ||
                 L_linee;
  
    ---- ---- ---- ---- Start Output the Header parts...
    fnd_file.put_line(fnd_file.output, L_headers);
    fnd_file.put_line(fnd_file.output, L_headerm);
    fnd_file.put_line(fnd_file.output, L_style);
    fnd_file.put_line(fnd_file.output, L_body);
  
    fnd_file.put_line(fnd_file.output, L_tableSExcel);
    fnd_file.put_line(fnd_file.output, L_Rtittle);
  
    ---- ---- ---- ----- Output the Details U want...Loop...
    For ap In anpeng Loop
      L_num := L_num + 1;
      fnd_file.put_line(fnd_file.output, L_lines);
    
      fnd_file.put_line(fnd_file.output,
                        L_rows || L_num || L_rowmcolor || ap.org_id ||
                        L_rowm || ap.application_id || L_rowm || ap.PD_Name ||
                        L_rowm || ap.Status || L_rowm || ap.Cur_Code ||
                        L_rowm || ap.gcc_CCID || L_rowm || ap.gcc_Account ||
                        L_rowm || ap.Party_Code || L_rowm || ap.SC_Mark ||
                        L_rowm || ap.Party_ID || L_rowm || ap.Site_Use_ID ||
                        L_rowm || to_char(ap.Balnc_Start, 'FM999,999,999,990.00') ||
                        L_rowm || to_char(ap.Balnc_ACCTD_Start,'FM999,999,999,990.00') || 
                        L_rowm || to_char(ap.Balnc_End, 'FM999,999,999,990.00') ||
                        L_rowm || to_char(ap.Balnc_ACCTD_End, 'FM999,999,999,990.00') ||
                        L_rowm || to_char(ap.Entered_Dr, 'FM999,999,999,990.00') ||
                        L_rowm || to_char(ap.Entered_Cr, 'FM999,999,999,990.00') ||
                        L_rowm || to_char(ap.Accounted_Dr, 'FM999,999,999,990.00') ||
                        L_rowm || to_char(ap.Accounted_Cr, 'FM999,999,999,990.00') ||
                        L_rowe);
    
      fnd_file.put_line(fnd_file.output, L_linee);
    End Loop;
  
    ---- ---- ---- ---- Output the table and the tag of the end of the HTML.
    fnd_file.put_line(fnd_file.output, L_tablee);
    fnd_file.put_line(fnd_file.output, L_Export);
    fnd_file.put_line(fnd_file.output, L_headere);
  
  End Balanc_CHKing;

End xxx_apr_SCBalanc_CHKing_pkg;
/
