CREATE OR REPLACE Package xxx_ar_STDCreateDepoInv_pkg Is
  /*===============================================================
  *   
  * ===============================================================
  *    Program Name:   xxx_ar_STDCreate_pkg
  *    Author      :   Doris ZOU
  *    Date        :   2013-03-20
  *    Purpose     :   Pl/Sql Html Report PKG
  *                    To Create the AR Invs Auto.
  *
  *    Update History
  *    Version    Date                             Name                           Description
  *    --------  ----------  ----------------------------------  --------------------
  *     V1.5     2013-03-20     Doris ZOU         Creation/Updated
    ===============================================================*/
  ----  ----
  PO_Trx_BatchSoc    ar_invoice_api_pub.batch_source_rec_type;
  PO_Trx_Header      ar_invoice_api_pub.trx_header_tbl_type;
  PO_Trx_Line        ar_invoice_api_pub.trx_line_tbl_type;
  PO_Trx_Dist        ar_invoice_api_pub.trx_dist_tbl_type;
  PO_Trx_SalesCredit ar_invoice_api_pub.trx_salescredits_tbl_type;

  PO_CreatedInv_SumS  Number := 0;
  PO_CreatedInv_SumE  Number := 0;
  PO_CreatedDepo_SumS Number := 0;
  PO_CreatedDepo_SumE Number := 0;
  ----  ----
  /*===========================================================
  ---- Procedure Name:    Print_Logs()
  ---- To Create the AR Print_Logs Finished Program.
  =============================================================*/
  Procedure Print_Logs(P_Logs In Varchar2);

  /*===========================================================
  ---- Procedure Name:    Print_Output()
  ---- To Create the AR Print_Logs Finished Program.
  =============================================================*/
  Procedure Print_Output(P_Output In Varchar2);

  /*===========================================================
  ---- Func Name:    Get_SourceID()
  ---- To Check the and Get the AR Source ID.
  =============================================================*/
  Function Get_SourceID(P_Org_ID      in Number,
                        P_Source_Name in varchar2,
                        P_Start_Date  in varchar2) Return Number;

  /*===========================================================
  ---- Func Name:    Get_TrxCate_ID()
  ---- To Check the and Get the AR TrxAction Type ID.
  =============================================================*/
  Function Get_TrxCate_ID(P_Org_ID       in Number,
                          P_TrxCate_Name in varchar2,
                          P_Start_Date   in varchar2) Return Number;

  /*===========================================================
  ---- Func Name:    Get_PMTID()
  ---- To Check the and Get the AR PMT Terms ID.
  =============================================================*/
  Function Get_PMTID(P_PMT_Name in varchar2, P_Start_Date in varchar2)
    Return Number;

  /*===========================================================
  ---- Func Name:    Get_LocaCode()
  ---- To Get The SiteUseID For the Customer.
  =============================================================*/
  Function Get_LocaCode(P_Org_ID      in Number,
                        P_Customer_ID in Number,
                        P_SiteUse_ID  in Number) Return varchar2;

  /*===========================================================
  ---- Func Name:    Get_ACCTSiteID()
  ---- To Get The SiteUseID For the Customer.
  =============================================================*/
  Function Get_ACCTSiteID(P_Org_ID      in Number,
                          P_Customer_ID in Number,
                          P_SiteUse_ID  in Number) Return Number;

  /*===========================================================
  ---- Func Name:    Get_SiteUseID()
  ---- To Get The SiteUseID For the Customer.
  =============================================================*/
  Function Get_SiteUseID(P_Org_ID       in Number,
                         P_Customer_ID  in Number,
                         P_Acct_Site_ID in Number) Return Number;

  /*===========================================================
  ---- Func Name:    Get_LocationID()
  ---- To Get The LocationID For the Customer.
  =============================================================*/
  Function Get_LocationID(P_Org_ID       in Number,
                          P_Customer_ID  in Number,
                          P_Acct_Site_ID in Number) Return Number;

  /*===========================================================
  ---- Func Name:    Get_MemoLine_ID()
  ---- To Check the and Get the AR MemoLine ID.
  =============================================================*/
  Function Get_MemoLine_ID(P_Org_ID        in Number,
                           P_MemoLine_Name in varchar2,
                           P_MemoLine_Type in varchar2,
                           P_Start_Date    in varchar2) Return Number;

  /*===========================================================
  ---- Procedure Name:    Build_HTML()
  ---- To Build the HTML Reports.
  =============================================================*/
  Procedure Build_HTML(P_msg_Data  Out Varchar2,
                       P_msg_Count Out Number,
                       P_Org_ID    In Number,
                       P_TPName    in varchar2,
                       P_Group_ID  In Number);

  /*===========================================================
  ---- Procedure Name:    Build_Data()
  ---- To Build the Data Before RCPTs Created and Inv APPLY.
  =============================================================*/
  Procedure Build_Data(P_Org_ID   In Number,
                       P_Group_ID OUT NOCOPY Number,
                       P_TPName   in varchar2,
                       P_trx_Type in varchar2);

  /*===========================================================
  ---- Procedure Name:    Depo_CrtdLog_Upde()
  ---- To Create the AR Invoice Created Log.
  =============================================================*/
  Procedure Depo_CrtdLog_Updated(P_Org_ID                  in Number,
                                 P_HHHeaderID              In Number,
                                 P_DepoInv_ID              In Number,
                                 P_trx_Type                In Varchar2,
                                 P_xxx_Date                In Varchar2,
                                 P_xxx_gl_date             In Varchar2,
                                 P_Cur_Code                In Varchar2,
                                 P_SumDepoInv_Amount       In Number,
                                 P_SumDepoInv_ACCTD_Amount In Number,
                                 P_Com_Flag                In Varchar2,
                                 P_Customer_ID             In Number,
                                 P_Site_Use_ID             In Number);

  /*===========================================================
  ---- Procedure Name:    Create_Invoice_STD()
  ---- To Create the AR Invoice STD Program.
  =============================================================*/
  Procedure Create_Invoice_STD(P_msg_Data        Out Varchar2,
                               P_msg_Count       Out Number,
                               x_Cuxm_Trx_ID     OUT NOCOPY Number,
                               P_Org_ID          in Number,
                               P_Trx_BatchSoc    In ar_invoice_api_pub.batch_source_rec_type,
                               P_Trx_Header      In ar_invoice_api_pub.trx_header_tbl_type,
                               P_Trx_Line        In ar_invoice_api_pub.trx_line_tbl_type,
                               P_Trx_Dist        In ar_invoice_api_pub.trx_dist_tbl_type,
                               P_Trx_SalesCredit in ar_invoice_api_pub.trx_salescredits_tbl_type);
  /*===========================================================
  ---- Procedure Name:    Auto_CreateDepo_STD()
  ---- To Print The AutoCreateDepo.
  =============================================================*/
  Procedure Auto_CreateDepo_STD(P_msg_Data  Out Varchar2,
                                P_msg_Count Out Number,
                                P_Org_ID    In Number,
                                P_TPName    in varchar2,
                                P_Group_ID  In Number);

  /*===========================================================
  ---- Procedure Name:    Auto_CreateInv_STD()
  ---- To Create the AR Invoice Program.
  =============================================================*/
  Procedure Auto_CreateInv_STD(P_msg_Data  Out Varchar2,
                               P_msg_Count Out Number,
                               P_Org_ID    In Number,
                               P_TPName    in varchar2,
                               P_Group_ID  In Number);

  /*===========================================================
  ---- Procedure Name:    Auto_Created_STD()
  ---- To  AutoCreate Depo&Inv.
  =============================================================*/
  Procedure Auto_Created_STD(P_msg_Data  Out Varchar2,
                             P_msg_Count Out Number,
                             P_TPName    in varchar2);

End xxx_ar_STDCreateDepoInv_pkg;
/
CREATE OR REPLACE Package Body xxx_ar_STDCreateDepoInv_pkg Is
  /*===============================================================
  *  
  * ===============================================================
  *    Program Name:   xxx_ar_STDCreateDepoInv_pkg
  *    Author      :   Doris ZOU
  *    Date        :   2013-03-20
  *    Purpose     :   Pl/Sql Html Report PKG
  *                    To Create the AR Invs Auto.
  *
  *    Update History
  *    Version    Date                             Name                           Description
  *    --------  ----------  ----------------------------------  --------------------
  *     V1.5     2013-03-20     Doris ZOU         Creation/Updated
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
  ---- To Create the AR Print_Logs Finished Program.
  =============================================================*/
  Procedure Print_Output(P_Output In Varchar2) Is
    L_HTM_BR varchar2(7) := '<BR>';
  Begin
    fnd_file.put_line(fnd_file.Output, L_HTM_BR || P_Output);
  End;

  /*===========================================================
  ---- Func Name:    Period_Checking()
  ---- To Check the Period Open Or Closed.
  ---- 'O' Or 'C' Status Of the Period.
  =============================================================*/
  Function Period_Checking(P_TPName in varchar2) Return varchar2 IS
  
    L_TPClosing_Status varchar2(2) := 'C';
    L_OPClosing_Status varchar2(2);
    L_TPOpen_Status    varchar2(2) := 'N';
    L_TPName           varchar2(7) := P_TPName;
  
  Begin
    ---- ---- ---- ---- To Get the Exception
    L_OPClosing_Status := 'C';
    Begin
      select gps.closing_status
        into L_TPClosing_Status
        from gl_period_statuses gps
       where gps.set_of_books_id = fnd_profile.value('GL_SET_OF_BKS_ID')
         and gps.application_id = fnd_global.resp_appl_id
         and gps.adjustment_period_flag = 'N'
         and gps.period_name = L_TPName;
    
    Exception
      When Others Then
        L_TPClosing_Status := L_OPClosing_Status;
    End;
  
    if nvl(L_TPClosing_Status, 'C') = 'O' Then
      L_TPOpen_Status := 'Y';
    End If;
    Return(L_TPOpen_Status);
  End Period_Checking;

  /*===========================================================
  ---- Func Name:    Get_Open_Num()
  ---- To Check the Period Open Or Closed.
  ---- 'O' Or 'C' Status Of the Period.
  =============================================================*/
  Function Get_Open_Num Return Number IS
  
    L_TPOpen_Sum Number := 0;
  Begin
    select Count(*)
      into L_TPOpen_Sum
      from gl_period_statuses gps
     where gps.set_of_books_id = fnd_profile.value('GL_SET_OF_BKS_ID')
       and gps.application_id = fnd_global.resp_appl_id
       and gps.adjustment_period_flag = 'N'
       and gps.Closing_Status = 'O';
  
    Return(L_TPOpen_Sum);
  End Get_Open_Num;

  /*===========================================================
  ---- Func Name:    Get_Openning()
  ---- To Check the Period Open Or Closed.
  ---- 'O' Or 'C' Status Of the Period.
  =============================================================*/
  Procedure Get_Openning IS
  
    L_Openning_PDName varchar2(7);
    L_Closing_Status  varchar2(2) := 'C';
  
    Cursor PD_Openning is
      select gps.period_year PD_Years, gps.period_name, gps.Closing_Status
        from gl_period_statuses gps
       where gps.set_of_books_id = fnd_profile.value('GL_SET_OF_BKS_ID')
         and gps.application_id = fnd_global.resp_appl_id
         and gps.adjustment_period_flag = 'N'
         and gps.closing_status = 'O';
  
  Begin
    For ap in PD_Openning Loop
      L_Openning_PDName := ap.period_name;
      L_Closing_Status  := ap.Closing_Status;
      Print_Output('L_Openning_PDName^^^^^^^^Status:' || L_Openning_PDName ||
                   '^^^^^^^^' || L_Closing_Status);
    End Loop;
  End Get_Openning;
  /*===========================================================
  ---- Func Name:    Get_GL_Date()
  ---- To Check the Period Open Or Closed And Get the GL Date.
  ---- 'O' Or 'C' Status Of the Period.
  ---- Have Only One Opened Period and Then the Result Expected
  ---- will Be Return, Or not will get Error Data.
  =============================================================*/
  Function Get_GL_Date(P_TPName in varchar2, P_RCPTs_gl_Date in varchar2)
    Return Date IS
  
    L_RCPTs_GL_StartDate Date;
    L_RCPTs_GL_EndDate   Date;
    L_RCPTs_GL_Date      Date := TRUNC(SYSDATE);
    L_TRCPTs_GL_Date     Date := nvl(to_Date(P_RCPTs_gl_Date, 'YYYY-MM-DD'),
                                     TRUNC(SYSDATE));
    L_TPName             varchar2(7) := P_TPName;
  
  Begin
    select gps.start_date, gps.end_date
      into L_RCPTs_GL_StartDate, L_RCPTs_GL_EndDate
      from gl_period_statuses gps
     where gps.set_of_books_id = fnd_profile.value('GL_SET_OF_BKS_ID')
       and gps.application_id = fnd_global.resp_appl_id
       and gps.period_name = L_TPName
       and gps.adjustment_period_flag = 'N'
       and gps.closing_status = 'O';
  
    If (L_TPName is Not Null Or Get_Open_Num = 1) and
       (L_TRCPTs_GL_Date Between L_RCPTs_GL_StartDate and
       L_RCPTs_GL_EndDate) Then
      L_RCPTs_GL_Date := L_TRCPTs_GL_Date;
    End If;
    If (P_TPName is Not Null Or Get_Open_Num = 1) and
       L_TRCPTs_GL_Date < L_RCPTs_GL_StartDate Then
      L_RCPTs_GL_Date := L_RCPTs_GL_StartDate;
    End If;
    If (P_TPName is Not Null Or Get_Open_Num = 1) and
       L_TRCPTs_GL_Date > L_RCPTs_GL_EndDate Then
      L_RCPTs_GL_Date := L_RCPTs_GL_EndDate;
    End If;
    If P_TPName is Null and Get_Open_Num <> 1 Then
      L_RCPTs_GL_Date := L_TRCPTs_GL_Date;
    End If;
  
    Return(L_RCPTs_GL_Date);
  End Get_GL_Date;

  /*===========================================================
  ---- Func Name:    Get_SourceID()
  ---- To Check the and Get the AR Source ID.
  =============================================================*/
  Function Get_SourceID(P_Org_ID      in Number,
                        P_Source_Name in varchar2,
                        P_Start_Date  in varchar2) Return Number IS
  
    L_xxx_SourceID Number := -9999;
    L_Start_Date   Date := to_Date(P_Start_Date, 'YYYY-MM-DD');
  Begin
    select rsa.batch_source_id
      into L_xxx_SourceID
      from ra_batch_sources_all rsa
     where rsa.org_id = P_Org_ID
       and rsa.name = P_Source_Name
       and nvl(rsa.start_date, SYSDATE) <= L_Start_Date
       and rsa.status = 'A';
  
    Return(L_xxx_SourceID);
  End Get_SourceID;

  /*===========================================================
  ---- Func Name:    Get_TrxCate_ID()
  ---- To Check the and Get the AR TrxAction Type ID.
  =============================================================*/
  Function Get_TrxCate_ID(P_Org_ID       in Number,
                          P_TrxCate_Name in varchar2,
                          P_Start_Date   in varchar2) Return Number IS
  
    L_xxx_TrxCate_ID Number;
    L_Start_Date     Date := to_Date(P_Start_Date, 'YYYY-MM-DD');
  
  Begin
    select rct.cust_trx_type_id TrxCate_ID
      into L_xxx_TrxCate_ID
      from ra_cust_trx_types_all rct
     where rct.org_id = P_Org_ID
       and rct.set_of_books_id = fnd_profile.value('GL_SET_OF_BKS_ID')
       and rct.name = P_TrxCate_Name
       and rct.default_status = 'OP'
       and rct.start_date <= L_Start_Date
       and nvl(rct.end_date, SYSDATE) >= SYSDATE;
  
    Return(L_xxx_TrxCate_ID);
  End Get_TrxCate_ID;

  /*===========================================================
  ---- Func Name:    Get_PMTID()
  ---- To Check the and Get the AR PMT Terms ID.
  =============================================================*/
  Function Get_PMTID(P_PMT_Name in varchar2, P_Start_Date in varchar2)
    Return Number IS
  
    L_xxx_PMTID  Number := -9999;
    L_Start_Date Date := to_Date(P_Start_Date, 'YYYY-MM-DD');
  
  Begin
    select rtt.term_id
      Into L_xxx_PMTID
      from ra_terms_tl rtt, ra_terms_b rtb
     where rtt.term_id = rtb.term_id
       and rtt.name = P_PMT_Name
       and rtb.start_date_active <= L_Start_Date
       and nvl(rtb.end_date_active, SYSDATE) >= SYSDATE
       and rtt.language = 'US';
  
    Return(L_xxx_PMTID);
  End Get_PMTID;

  /*===========================================================
  ---- Func Name:    Get_LocaID()
  ---- To Get The Get_LocaID For the Customer.
  =============================================================*/
  Function Get_LocaID(P_Org_ID      in Number,
                      P_Customer_ID in Number,
                      P_SiteUse_ID  in Number) Return varchar2 IS
  
    L_xxx_LocaCode varchar2(15);
  Begin
    select xCi.Location_ID LocaCode
      Into L_xxx_LocaCode
      From xxx_Customer_Info xCi
     where xCi.org_id = P_Org_ID
       and xCi.Bill_To_Customer_ID = P_Customer_ID
       and xCi.Bill_To_SiteUse_ID = P_SiteUse_ID;
  
    Return(L_xxx_LocaCode);
  End Get_LocaID;

  /*===========================================================
  ---- Func Name:    Get_LocaCode()
  ---- To Get The SiteUseID For the Customer.
  =============================================================*/
  Function Get_LocaCode(P_Org_ID      in Number,
                        P_Customer_ID in Number,
                        P_SiteUse_ID  in Number) Return varchar2 IS
  
    L_xxx_LocaCode varchar2(15);
  Begin
    select xCi.Customer_Site LocaCode
      Into L_xxx_LocaCode
      From xxx_Customer_Info xCi
     where xCi.org_id = P_Org_ID
       and xCi.Bill_To_Customer_ID = P_Customer_ID
       and xCi.Bill_To_SiteUse_ID = P_SiteUse_ID;
  
    Return(L_xxx_LocaCode);
  End Get_LocaCode;

  /*===========================================================
  ---- Func Name:    Get_ACCTSiteID()
  ---- To Get The SiteUseID For the Customer.
  =============================================================*/
  Function Get_ACCTSiteID(P_Org_ID      in Number,
                          P_Customer_ID in Number,
                          P_SiteUse_ID  in Number) Return Number IS
  
    L_xxx_ACCTSiteID Number;
  Begin
    select xCi.cust_acct_site_ID ACCTSiteID
      Into L_xxx_ACCTSiteID
      From xxx_Customer_Info xCi
     where xCi.org_id = P_Org_ID
       and xCi.Bill_To_Customer_ID = P_Customer_ID
       and xCi.Bill_To_SiteUse_ID = P_SiteUse_ID;
  
    Return(L_xxx_ACCTSiteID);
  End Get_ACCTSiteID;

  /*===========================================================
  ---- Func Name:    Get_SiteUseID()
  ---- To Get The SiteUseID For the Customer.
  =============================================================*/
  Function Get_SiteUseID(P_Org_ID       in Number,
                         P_Customer_ID  in Number,
                         P_Acct_Site_ID in Number) Return Number IS
  
    L_xxx_SiteUseID Number;
  
  Begin
    select xCi.Bill_To_SiteUse_ID SiteUseID
      Into L_xxx_SiteUseID
      From xxx_Customer_Info xCi
     where xCi.org_id = P_Org_ID
       and xCi.Bill_To_Customer_ID = P_Customer_ID
       and xCi.cust_acct_site_id = P_Acct_Site_ID;
  
    Return(L_xxx_SiteUseID);
  End Get_SiteUseID;

  /*===========================================================
  ---- Func Name:    Get_LocationID()
  ---- To Get The Get_LocationID For the Customer.
  =============================================================*/
  Function Get_LocationID(P_Org_ID       in Number,
                          P_Customer_ID  in Number,
                          P_Acct_Site_ID in Number) Return Number IS
  
    L_xxx_LocationID Number;
  
  Begin
    select xCi.Location_ID SiteUseID
      Into L_xxx_LocationID
      From xxx_Customer_Info xCi
     where xCi.org_id = P_Org_ID
       and xCi.Bill_To_Customer_ID = P_Customer_ID
       and xCi.cust_acct_site_id = P_Acct_Site_ID;
  
    Return(L_xxx_LocationID);
  End Get_LocationID;

  /*===========================================================
  ---- Func Name:    Get_MemoLine_ID()
  ---- To Check the and Get the AR MemoLine ID.
  =============================================================*/
  Function Get_MemoLine_ID(P_Org_ID        in Number,
                           P_MemoLine_Name in varchar2,
                           P_MemoLine_Type in varchar2,
                           P_Start_Date    in varchar2) Return Number IS
  
    L_xxx_MemiLine_ID Number := -9999;
    L_Start_Date      Date := to_Date(P_Start_Date, 'YYYY-MM-DD');
  Begin
    select Sum(mlat.memo_line_id)
      Into L_xxx_MemiLine_ID
      from ar_memo_lines_all_b mla, ar_memo_lines_all_tl mlat
     where mlat.org_id = P_Org_ID
       and mlat.org_id = mla.org_id
       and mlat.memo_line_id = mla.memo_line_id
       and mlat.description = P_MemoLine_Name
       and mlat.language = 'US'
       and mla.line_type = P_MemoLine_Type
       and mla.start_date <= L_Start_Date
       and nvl(mla.end_date, SYSDATE) >= SYSDATE;
  
    Return(L_xxx_MemiLine_ID);
  End Get_MemoLine_ID;

  /*===========================================================
  ---- Procedure Name:    Build_HTML()
  ---- To Build the HTML Reports.
  =============================================================*/
  Procedure Build_HTML(P_msg_Data  Out Varchar2,
                       P_msg_Count Out Number,
                       P_Org_ID    In Number,
                       P_TPName    in varchar2,
                       P_Group_ID  In Number) IS
  
    L_Org_ID      Number := P_Org_ID;
    L_TPName      varchar2(7) := P_TPName;
    L_Group_ID    Number := P_Group_ID;
    L_xxx_Count   Number := 0;
    L_Conver_Rate varchar2(15);
  
    L_Program_Title varchar2(500) := 'HTML Report xxxxxxxx xxxxxxxx xxxxxxxx xxxxxxxx';
    L_Report_Title  varchar2(500) := L_Program_Title;
    L_Line_Title    varchar2(1000);
    L_YesNo         varchar2(2) := 'Y';
    L_Line_Sep      varchar2(2) := '$';
  
    Cursor RCPTs_Log(P_Org_ID   In Number,
                     P_TPName   In varchar2,
                     P_Group_ID in Number) IS
      select xDH.Period_Name, xDH.Conver_Rate, xDc.*
        from xxx_DepoInv_Created_Logs xDc, xxx_ar_DepoSelected_Header xDH
       where xDH.Group_ID = nvl(P_Group_ID, xDH.Group_ID)
         and xDH.Org_ID = nvl(P_Org_ID, xDH.Org_ID)
         and xDH.Period_Name = P_TPName
         and xDH.Org_ID = xDc.Org_ID
         and xDH.HHHeaderID = xDc.HHHeaderID
         and xDH.Depo_ID = xDc.DepoInv_ID;
  
  Begin
    if L_Org_ID is Null Or L_Org_ID <> fnd_global.Org_ID Then
      L_Org_ID := fnd_global.Org_ID;
    End If;
  
    ------Output the Table and the Tag of the Header of the HTML.
    xxx_CommonChecking_pkg.PO_Report_Output_Mode := 'F';
    xxx_CommonChecking_pkg.Html_Title(P_Program_Title => L_Program_Title,
                                      P_Report_Title  => L_Report_Title);
  
    xxx_CommonChecking_pkg.Output_Line('<table width=128% style="border-collapse:collapse;
    border:none; font-family:Courier; font-size: 10pt" border=1
    bordercolor=#000000 cellspacing="0" id="execl" name="execl">');
    L_Line_Title := 'No.***bgcolor=#E6F2FF,Org_ID***bgcolor=#E6F2FF,Period_Name***bgcolor=#E6F2FF,
    HHHeaderID***bgcolor=#E6F2FF,DepoInv_ID***bgcolor=#E6F2FF,Depo_Num*** bgcolor=#E6F2FF,Cur_Code***bgcolor=#E6F2FF,
    Convert_Rate*** bgcolor=#E6F2FF,xxx_Date*** bgcolor=#E6F2FF,xxx_GL_Date*** bgcolor=#E6F2FF,SUM_Depo*** bgcolor=#E6F2FF,
    SUM_DepoACCTD*** bgcolor=#E6F2FF,Customer_ID*** bgcolor=#E6F2FF,SiteUse_ID*** bgcolor=#E6F2FF,';
  
    xxx_CommonChecking_pkg.Line_Title(P_Title_String       => L_Line_Title,
                                      P_With_Other_Attr    => L_YesNo,
                                      P_With_TrCenter_Flag => L_YesNo,
                                      P_Attr_Delimiter     => '***');
  
    ---- ---- ---- ----- Output the Details U want...Loop...
    For ap in RCPTs_Log(L_Org_ID, L_TPName, L_Group_ID) Loop
      L_xxx_Count   := L_xxx_Count + 1;
      L_Conver_Rate := to_Char(ap.Conver_Rate, 'FM9999999990.00');
      xxx_CommonChecking_pkg.Line_Title(P_Title_String    => L_xxx_Count ||
                                                             L_Line_Sep ||
                                                             ap.Org_ID ||
                                                             L_Line_Sep ||
                                                             ap.Period_Name ||
                                                             L_Line_Sep ||
                                                             ap.HHHeaderID ||
                                                             L_Line_Sep ||
                                                             ap.DepoInv_ID ||
                                                             L_Line_Sep ||
                                                             ap.DepoNum ||
                                                             L_Line_Sep ||
                                                             ap.Cur_Code ||
                                                             L_Line_Sep ||
                                                             L_Conver_Rate ||
                                                             L_Line_Sep ||
                                                             ap.xxx_Date ||
                                                             L_Line_Sep ||
                                                             ap.xxx_GL_Date ||
                                                             L_Line_Sep ||
                                                             ap.SUMDepo_Amount ||
                                                             L_Line_Sep ||
                                                             ap.SUMDepo_ACCTD_Amount ||
                                                             L_Line_Sep ||
                                                             ap.Customer_ID ||
                                                             L_Line_Sep ||
                                                             ap.site_use_id ||
                                                             L_Line_Sep,
                                        P_With_Other_Attr => L_YesNo,
                                        P_Attr_Delimiter  => '***',
                                        P_Delimiter       => L_Line_Sep);
    End Loop;
    ------Output the Table and the Tag of the End of the HTML.
    xxx_CommonChecking_pkg.Output_Line('</table>');
    xxx_CommonChecking_pkg.Output_Line('<input type="submit" onclick=method1("execl")  value="Export"/>');
    xxx_CommonChecking_pkg.Output_Line('</html>');
  
  Exception
    When Others Then
      P_msg_Data := SQLERRM;
      Print_Logs(P_msg_Data);
      P_msg_Data := SQLCODE;
      Print_Logs(P_msg_Data);
    
  End Build_HTML;

  /*===========================================================
  ---- Procedure Name:    Build_Data()
  ---- To Build the Data Before Created DepoInv.
  =============================================================*/
  Procedure Build_Data(P_Org_ID   In Number,
                       P_Group_ID OUT NOCOPY Number,
                       P_TPName   in varchar2,
                       P_trx_Type in varchar2) IS
  
    x_group_ID             Number;
    L_HHHeaderID           Number;
    L_HLineID              Number;
    L_Org_ID               Number := P_Org_ID;
    L_TPName               varchar2(7) := P_TPName;
    L_trx_Type             varchar2(7) := P_trx_Type;
    L_Apps_ID              Number;
    L_SelectedHeader_Count Number := 0;
    L_SelectedLine_Count   Number := 0;
    L_LineCount_Num        Number := 0;
    L_User_ID              Number := Fnd_global.user_id;
    L_Start_Date           varchar2(10);
    L_xxx_gl_Date          varchar2(10);
    L_Create_Date          Date := SYSDATE;
  
    L_SOB_CurCode varchar2(5);
    L_xxx_ExRate  Number := 0;
  
    L_xxx_SourceID    Number := -9999;
    L_xxx_TrxCate_ID  Number := -9999;
    L_xxx_SiteUseID   Number := -9999;
    L_xxx_LocationID  Number := -9999;
    L_xxx_iiiiiiID    Number := -9999;
    L_xxx_MemiLine_ID Number := -9999;
    L_xxx_PMTID       Number := -9999;
    L_xxx_DepoID      Number := -9999;
  
    L_SUMDepo_Amount Number := 0;
  
    L_Header_Context xxx_ar_Depoinv_Interface.Line_Context %TYPE;
    L_Header_Num     xxx_ar_Depoinv_Interface.Line_Attria %TYPE;
  
    Cursor DepoInv_Header(P_Org_ID   In Number,
                          P_TPName   in varchar2,
                          P_trx_Type in varchar2) IS
      select xDi.Org_Id,
             xDi.Period_Name,
             xDi.Trx_Type,
             xDi.Line_Context,
             xDi.Line_Attria,
             xDi.Batch_Source_Name,
             xDi.Cur_Code,
             xDi.Conver_Type,
             xDi.Conver_Date,
             xDi.Conver_Rate,
             xDi.Cust_Trx_Type_Name,
             xDi.Bill_Customer_Name,
             xDi.Bill_Customer_Site,
             xDi.Bill_Customer_ID,
             xDi.Bill_Siteuse_ID,
             xDi.Term_Name,
             xDi.Depo_Date,
             xDi.Depo_Gl_Date
      
        from xxx_ar_DepoInv_Header xDi
       where xDi.Org_Id = P_Org_ID
         and xDi.Period_Name = P_TPName
         and xDi.Trx_Type = P_trx_Type
         and xDi.group_id = -9999;
  
    Cursor DepoInv_Lines(P_Org_ID         In Number,
                         P_TPName         in varchar2,
                         P_trx_Type       in varchar2,
                         P_Header_Context in varchar2,
                         P_Header_Num     In varchar2,
                         P_Customer_ID    Number,
                         P_SiteUse_ID     Number,
                         P_Cur_Code       In varchar2) IS
      select xDi.Line_ID,
             xDi.Line_Type,
             xDi.Line_Num,
             xDi.Quantity_Invoiced,
             xDi.Unit_Selling_Price,
             xDi.Depo_Amount,
             xDi.Item_ID,
             xDi.Memo_Line_Name,
             xDi.Line_Context,
             xDi.Line_Attria,
             xDi.Line_Attrib,
             xDi.Line_Attric
      
        from xxx_ar_Depoinv_Interface xDi
       where xDi.Org_Id = P_Org_ID
         and xDi.Period_Name = P_TPName
         and xDi.Trx_Type = P_trx_Type
         and xDi.Line_Context = P_Header_Context
         and xDi.Line_Attria = P_Header_Num
         and xDi.Cur_Code = P_Cur_Code
         and xDi.Bill_Customer_Id = P_Customer_ID
         and xDi.Bill_Siteuse_Id = P_SiteUse_ID
         and xDi.group_id = -9999;
  
  Begin
  
    if L_Org_ID is Null Or L_Org_ID <> fnd_global.Org_ID Then
      L_Org_ID := fnd_global.Org_ID;
    End If;
  
    x_group_ID := xxx_RCPTs_s.Nextval;
    P_Group_ID := x_group_ID;
    L_Apps_ID  := fnd_global.Resp_Appl_ID;
  
    L_SOB_CurCode := xxx_CommonChecking_pkg.Get_SOB_CurCode(P_Org_ID  => L_Org_ID,
                                                            P_Apps_ID => L_Apps_ID);
  
    Print_Logs('++++++------------------To Build The Selected Data------------------++++++');
    Print_Output('++++++------------------To Build The Selected Data------------------++++++');
  
    For apH in DepoInv_Header(L_Org_ID, L_TPName, L_trx_Type) Loop
      ---- ---- ---- ---- Header Loop.
      L_HHHeaderID     := xxx_DepoInv_HHH_s.nextval;
      L_Header_Context := apH.Line_Context;
      L_Header_Num     := apH.Line_Attria;
      L_Start_Date     := to_Char(apH.Depo_Date, 'YYYY-MM-DD');
      L_xxx_gl_Date    := to_Char(apH.Depo_Gl_Date, 'YYYY-MM-DD');
    
      L_xxx_SourceID := Get_SourceID(P_Org_ID      => L_Org_ID,
                                     P_Source_Name => apH.Batch_Source_Name,
                                     P_Start_Date  => L_Start_Date);
    
      L_xxx_TrxCate_ID := Get_TrxCate_ID(P_Org_ID       => L_Org_ID,
                                         P_TrxCate_Name => apH.Cust_Trx_Type_Name,
                                         P_Start_Date   => L_Start_Date);

      ---- ---- ---- ---- In Fact,apH.Bill_Siteuse_ID is CUST_ACCT_SITE_ID Imported.
      L_xxx_SiteUseID := Get_SiteUseID(P_Org_ID       => L_Org_ID,
                                       P_Customer_ID  => apH.Bill_Customer_Id,
                                       P_Acct_Site_ID => apH.Bill_Siteuse_Id);
      L_xxx_PMTID := Get_PMTID(P_PMT_Name   => apH.Term_Name,
                               P_Start_Date => L_Start_Date);

      if apH.Cur_Code <> L_SOB_CurCode Then
        L_xxx_ExRate := xxx_CommonChecking_pkg.Get_xxx_ExRate(Input_CurCode => apH.Cur_Code,
                                                              SOB_CurCode   => L_SOB_CurCode,
                                                              P_xxx_Convert => apH.Conver_Type,
                                                              P_xxx_gl_Date => L_xxx_gl_Date);

      End If;

      if apH.Cur_Code = L_SOB_CurCode and
         nvl(apH.Conver_Type, 'User') = 'User' Then
        L_xxx_ExRate := 1;
      End If;
    
      ---- ---- ---- ---- Line Loop.
      For apL In DepoInv_Lines(L_Org_ID,
                               L_TPName,
                               L_trx_Type,
                               L_Header_Context,
                               L_Header_Num,
                               apH.Bill_Customer_ID,
                               apH.Bill_Siteuse_ID,
                               apH.Cur_Code) Loop
      
        L_HLineID := xxx_DepoInv_HLine_s.nextval;
      
        L_xxx_MemiLine_ID := Get_MemoLine_ID(P_Org_ID        => L_Org_ID,
                                             P_MemoLine_Name => apL.Memo_Line_Name,
                                             P_MemoLine_Type => apL.Line_Type,
                                             P_Start_Date    => L_Start_Date);
      
        L_LineCount_Num := L_LineCount_Num + 1;
      
        Insert Into xxx_ar_DepoInv_Selected
          select L_Org_ID,
                 x_group_ID,
                 apL.Line_ID,
                 L_HHHeaderID,
                 L_HLineID,
                 apH.Period_Name,
                 apH.Trx_Type,
                 L_Header_Context,
                 L_Header_Num,
                 apL.Line_Attrib,
                 apL.Line_Attric,
                 L_xxx_SourceID,
                 apH.Batch_Source_Name,
                 apH.Cur_Code,
                 nvl(apH.Conver_Type, 'User'),
                 apH.Depo_Gl_Date,
                 L_xxx_ExRate,
                 0,
                 0,
                 apL.Line_Type,
                 L_LineCount_Num,
                 apL.Quantity_Invoiced,
                 apL.Unit_Selling_Price,
                 apL.Depo_Amount,
                 apH.Cust_Trx_Type_Name,
                 L_xxx_TrxCate_ID,
                 apH.Bill_Customer_ID,
                 L_xxx_SiteUseID,
                 apH.Bill_Customer_Name,
                 apH.Bill_Customer_Site,
                 apL.Item_ID,
                 L_xxx_MemiLine_ID,
                 apL.Memo_Line_Name,
                 L_xxx_PMTID,
                 apH.Term_Name,
                 apH.Depo_Date,
                 apH.Depo_Gl_Date,
                 apH.Depo_Date,
                 L_User_ID,
                 L_Create_Date,
                 L_User_ID,
                 L_Create_Date,
                 L_xxx_DepoID
            From Dual;
        Commit;
        L_SUMDepo_Amount     := L_SUMDepo_Amount + apL.Depo_Amount;
        L_SelectedLine_Count := L_SelectedLine_Count + 1;
      
      End Loop; ---- ---- ---- ---- Line Loop.
    
      Update xxx_ar_DepoInv_Selected xDi
         set xDi.SumDepo_Amount       = L_SUMDepo_Amount,
             xDi.SumDepo_Acctd_Amount = L_SUMDepo_Amount * L_xxx_ExRate
       where xDi.Org_ID = L_Org_ID
         and xDi.Group_ID = x_group_ID
         and xDi.HHHeaderID = L_HHHeaderID;
      Commit;
      L_LineCount_Num        := 0;
      L_SelectedHeader_Count := L_SelectedHeader_Count + 1;
    
    End Loop; ---- ---- ---- ---- Header Loop.
  
    Print_Output('Data Selected L_SelectedHeader Count(*):' ||
                 L_SelectedHeader_Count);
    Print_Output('Data Selected L_SelectedLine Count(*):' ||
                 L_SelectedLine_Count);
  End Build_Data;

  /*===========================================================
  ---- Procedure Name:    Depo_CrtdLog_Updated()
  ---- To Create the AR Invoice Created Log.
  =============================================================*/
  Procedure Depo_CrtdLog_Updated(P_Org_ID                  in Number,
                                 P_HHHeaderID              In Number,
                                 P_DepoInv_ID              In Number,
                                 P_trx_Type                In Varchar2,
                                 P_xxx_Date                In Varchar2,
                                 P_xxx_gl_date             In Varchar2,
                                 P_Cur_Code                In Varchar2,
                                 P_SumDepoInv_Amount       In Number,
                                 P_SumDepoInv_ACCTD_Amount In Number,
                                 P_Com_Flag                In Varchar2,
                                 P_Customer_ID             In Number,
                                 P_Site_Use_ID             In Number) IS
  
    L_User_ID     Number := fnd_global.user_id;
    L_xxx_DepoNum ra_customer_trx_all.trx_number%TYPE;
  
    ----L_Creation_Date Varchar2(10) := to_Char(SYSDATE, 'YYYY-MM-DD');
  Begin
    L_xxx_DepoNum := xxx_CommonChecking_pkg.Get_xxx_DepoNum(P_Org_ID,
                                                            P_DepoInv_ID);
  
    Insert into xxx_DepoInv_Created_Logs
      select P_Org_ID,
             P_HHHeaderID,
             xxx_DepoInv_Line_s.Nextval,
             P_DepoInv_ID,
             L_xxx_DepoNum,
             P_trx_Type,
             P_xxx_Date,
             P_xxx_gl_date,
             P_Cur_Code,
             P_SumDepoInv_Amount,
             P_SumDepoInv_ACCTD_Amount,
             P_Com_Flag,
             P_Customer_ID,
             P_Site_Use_ID,
             L_User_ID,
             SYSDATE
        From Dual;
  
  End Depo_CrtdLog_Updated;

  /*===========================================================
  ---- Procedure Name:    Create_Invoice_STD()
  ---- To Create the AR Invoice STD Program.
  =============================================================*/
  Procedure Create_Invoice_STD(P_msg_Data        Out Varchar2,
                               P_msg_Count       Out Number,
                               x_Cuxm_Trx_ID     OUT NOCOPY Number,
                               P_Org_ID          in Number,
                               P_Trx_BatchSoc    In ar_invoice_api_pub.batch_source_rec_type,
                               P_Trx_Header      In ar_invoice_api_pub.trx_header_tbl_type,
                               P_Trx_Line        In ar_invoice_api_pub.trx_line_tbl_type,
                               P_Trx_Dist        In ar_invoice_api_pub.trx_dist_tbl_type,
                               P_Trx_SalesCredit in ar_invoice_api_pub.trx_salescredits_tbl_type) IS
  
    L_Return_Status varchar2(2);
    L_msg_Count     Number;
    L_msg_Data      varchar2(1000);
  
    L_Cuxm_Trx_ID Number;
    L_Count_Num   Number := 0;
  
    L_Org_ID          Number := P_Org_ID;
    L_User_ID         Number;
    L_Resp_ID         Number;
    L_Resp_Appl_ID    Number;
    L_Sicuit_group_id Number;
  
    L_Trx_BatchSoc    ar_invoice_api_pub.batch_source_rec_type;
    L_Trx_Header      ar_invoice_api_pub.trx_header_tbl_type;
    L_Trx_Line        ar_invoice_api_pub.trx_line_tbl_type;
    L_Trx_Dist        ar_invoice_api_pub.trx_dist_tbl_type;
    L_Trx_SalesCredit ar_invoice_api_pub.trx_salescredits_tbl_type;
  
  Begin
  
    if L_Org_ID is Null Or L_Org_ID <> fnd_global.Org_ID Then
      L_Org_ID := fnd_global.Org_ID;
    End If;
    /*===========================================================
     ---- ---- ---- To Set the Apps Contexts.
     ---- ---- ---- MULTI_ORG_CATEGORY = 'S' = Single organization.
    ---- ---- ---- MULTI_ORG_CATEGORY = 'M' = Multi Organization.
    =============================================================*/
  
    L_User_ID         := fnd_global.user_id;
    L_Resp_ID         := fnd_global.Resp_id;
    L_Resp_Appl_ID    := fnd_global.Resp_Appl_ID;
    L_Sicuit_group_id := fnd_global.Security_group_id;
  
    mo_global.init('AR');
    mo_global.set_policy_context('S', L_Org_ID);
    fnd_global.apps_initialize(L_User_ID,
                               L_Resp_ID,
                               L_Resp_Appl_ID,
                               L_Sicuit_group_id);
  
    L_Trx_BatchSoc    := P_Trx_BatchSoc;
    L_Trx_Header      := P_Trx_Header;
    L_Trx_Line        := P_Trx_Line;
    L_Trx_Dist        := P_Trx_Dist;
    L_Trx_SalesCredit := P_Trx_SalesCredit;
  
    Print_Logs('++++++------------------Before Calling API To Create Invs------------------++++++');
    /*===========================================================
    ---- ---- ----Calling the STD API to Create the Invs.    
    ---- ---- ---- If the Org is DiFF and then the Error msg will be Created Here.
    ---- ---- ----To Call the invoice api ar_invoice_api_pub To Create it..
    =============================================================*/
    ar_invoice_api_pub.create_single_invoice(p_api_version          => 1.0,
                                             p_init_msg_list        => FND_API.G_TRUE,
                                             p_commit               => FND_API.G_TRUE,
                                             p_batch_source_rec     => L_Trx_BatchSoc,
                                             p_trx_header_tbl       => L_Trx_Header,
                                             p_trx_lines_tbl        => L_Trx_Line,
                                             p_trx_dist_tbl         => L_Trx_Dist,
                                             p_trx_salescredits_tbl => L_Trx_SalesCredit,
                                             x_customer_trx_id      => L_Cuxm_Trx_ID,
                                             x_return_status        => L_return_status,
                                             x_msg_count            => L_msg_count,
                                             x_msg_data             => L_msg_data);
  
    Print_Logs('++++++------------------Exit Calling API To Create Invs------------------++++++');
    P_msg_Count := L_msg_Count;
    P_msg_Data  := L_msg_Data;
  
    If L_Cuxm_Trx_ID IS Null Then
      L_Cuxm_Trx_ID := -9999;
    End If;
  
    x_Cuxm_Trx_ID := L_Cuxm_Trx_ID;
    Print_Logs('x_Cuxm_Trx_ID:' || x_Cuxm_Trx_ID);
    Print_Logs('L_Cuxm_Trx_ID:' || L_Cuxm_Trx_ID);
  
    if L_Return_Status = 'S' Then
      PO_CreatedInv_SumS := PO_CreatedInv_SumS + 1;
    End If;
  
    if L_Return_Status = 'E' Then
      PO_CreatedInv_SumE := PO_CreatedInv_SumE + 1;
    End If;
  
    Print_Logs('Return Status:' || L_Return_Status);
    Print_Logs('Message Count:' || P_msg_Count);
  
    IF L_msg_Count = 1 Then
      Print_Logs('L_msg_data:' || P_msg_Data);
    ELSIF L_msg_Count > 1 Then
      For i in 0 .. L_msg_Count Loop
        L_Count_Num := L_Count_Num + 1;
        L_msg_data  := FND_MSG_PUB.Get(FND_MSG_PUB.G_NEXT, FND_API.G_FALSE);
      
        ---- ---- ---- Exit the Loop.
        IF L_msg_data is NULL Then
          EXIT;
        END IF;
        Print_Logs('Message:' || L_Count_Num || '---- ---- ---- ---->' ||
                   L_msg_data);
      END LOOP;
    End If;
  
    If L_return_status = fnd_api.g_ret_sts_error OR
       L_return_status = fnd_api.g_ret_sts_unexp_error then
      Print_Logs('L_Return_Status:' || L_Return_Status);
    else
      select Count(*) Into L_msg_Count From ar_trx_errors_gt;
      If L_msg_Count = 0 Then
        Print_Logs('L_Cuxm_Trx_ID ' || L_Cuxm_Trx_ID);
        COMMIT;
      else
        Print_Logs('Doris ZOU ---- TransAction Not Created.');
      End If;
    End If;
  
  Exception
    When Others Then
      P_msg_Data := SQLERRM;
      Print_Logs(P_msg_Data);
      P_msg_Data := SQLCODE;
      Print_Logs(P_msg_Data);
      Print_Logs('++++++------------------End Calling API To Create Invs Loop------------------++++++');
    
  End Create_Invoice_STD;

  /*===========================================================
  ---- Procedure Name:    Auto_CreateDepo_STD()
  ---- To Print The AutoCreateDepo.
  =============================================================*/
  Procedure Auto_CreateDepo_STD(P_msg_Data  Out Varchar2,
                                P_msg_Count Out Number,
                                P_Org_ID    Number,
                                P_TPName    in varchar2,
                                P_Group_ID  In Number) IS
  
    L_Return_Status varchar2(2);
    L_msg_Count     Number;
    L_msg_Data      varchar2(1000);
  
    L_Depo_Num     ra_customer_trx.trx_number%type;
    L_Depo_ID      ra_customer_trx.customer_trx_id%type;
    x_Cuxm_Trx_ID  ra_customer_trx.customer_trx_id%type;
    L_Depo_Line_ID ra_customer_trx_lines.customer_trx_line_id%type;
    L_new_rowid    VARCHAR2(240);
    L_trx_Type     varchar2(7);
  
    L_Org_ID   Number := P_Org_ID;
    x_group_ID Number := P_Group_ID;
  
    L_User_ID         Number;
    L_Resp_ID         Number;
    L_Resp_Appl_ID    Number;
    L_Sicuit_group_id Number;
  
    L_Count_DNum Number := 0;
    L_Count_MNum Number := 0;
  
    L_Customer_ID       Number := -9999;
    L_HHHeaderID        Number := -9999;
    L_Site_Use_ID       Number;
    L_xxx_ACCTSiteID    Number;
    L_xxx_LocaCode      varchar2(15) := 'Andy P.';
    L_xxx_LocaID        Number;
    L_RemitToAddress_ID Number := -9999;
  
    L_Cur_Code    varchar2(5);
    L_Conver_Type varchar2(10);
    L_Conver_Date Date;
    L_Conver_Rate Number;
  
    L_Depo_Amount         Number;
    L_Batch_Source_ID     Number;
    L_Cust_trx_type_ID    Number;
    L_Item_ID             Number;
    L_Depo_Memo_Line_id   Number;
    L_Depo_Memo_line_name varchar2(30);
    L_Depo_Description    varchar2(30) := 'Generic Commitment';
    L_term_ID             Number;
    L_TPName              varchar2(7) := P_TPName;
    L_xxx_Depo_Date       Date;
    L_xxx_gl_Date         Date;
    LU_xxx_Depo_Date      varchar2(10);
    LU_xxx_gl_Date        varchar2(10);
    L_Start_Date_Depo     Date;
    L_Depo_HeaderID       Number;
    L_Depo_LineID         Number;
  
    Cursor DepoIFC(P_Org_ID   In Number,
                   P_TPName   in varchar2,
                   P_Group_ID In Number) IS
      select *
        from xxx_ar_DepoInv_Selected xDi
       where xDi.Org_Id = P_Org_ID
         and xDi.Period_Name = P_TPName
         and xDi.Group_Id = P_Group_ID
         and xDi.Trx_Type = 'DEP'
         and xDi.Depo_Id = -9999;
  
  Begin
    /*===========================================================
     ---- ---- ---- To Set the Apps Contexts.
     ---- ---- ---- MULTI_ORG_CATEGORY = 'S' = Single organization.
    ---- ---- ---- MULTI_ORG_CATEGORY = 'M' = Multi Organization.
     =============================================================*/
    L_Org_ID          := fnd_global.Org_ID;
    L_User_ID         := fnd_global.user_id;
    L_Resp_ID         := fnd_global.Resp_id;
    L_Resp_Appl_ID    := fnd_global.Resp_Appl_ID;
    L_Sicuit_group_id := fnd_global.Security_group_id;
  
    mo_global.init('AR');
    mo_global.set_policy_context('S', L_Org_ID);
    fnd_global.apps_initialize(L_User_ID,
                               L_Resp_ID,
                               L_Resp_Appl_ID,
                               L_Sicuit_group_id);
  
    select iii.address_id
      into L_RemitToAddress_ID
      from ra_remit_tos_all iii
     where iii.ORG_ID = L_Org_ID
       and iii.country = 'DEFAULT';
  
    For ap in DepoIFC(L_Org_ID, L_TPName, x_group_ID) Loop
    
      L_Cur_Code   := ap.cur_code;
      L_HHHeaderID := ap.HHHeaderID;
    
      if ap.conver_type = 'User' Then
        L_Conver_Type := NULL;
        L_Conver_Date := NULL;
        L_Conver_Rate := NULL;
      End If;
    
      if ap.conver_type <> 'User' Then
        L_Conver_Type := ap.conver_type;
      End If;
    
      if ap.conver_type <> 'User' Then
        L_Conver_Date := ap.conver_date;
      End if;
    
      L_Depo_Amount         := ap.depo_amount;
      L_Batch_Source_ID     := ap.batch_source_id;
      L_Cust_trx_type_ID    := ap.cust_trx_type_id;
      L_Item_ID             := ap.item_id;
      L_Depo_Memo_Line_id   := ap.memo_line_id;
      L_Depo_Memo_line_name := ap.memo_line_name;
    
      L_Customer_ID := ap.Bill_Customer_ID;
      L_Site_Use_ID := ap.Bill_SiteUse_ID;
    
      L_xxx_ACCTSiteID := Get_ACCTSiteID(P_Org_ID      => L_Org_ID,
                                         P_Customer_ID => L_Customer_ID,
                                         P_SiteUse_ID  => L_Site_Use_ID);
      L_xxx_LocaCode   := Get_LocaCode(P_Org_ID      => L_Org_ID,
                                       P_Customer_ID => L_Customer_ID,
                                       P_SiteUse_ID  => L_Site_Use_ID);
      L_xxx_LocaID     := Get_LocaID(P_Org_ID      => L_Org_ID,
                                     P_Customer_ID => L_Customer_ID,
                                     P_SiteUse_ID  => L_Site_Use_ID);
    
      L_xxx_Depo_Date   := ap.depo_date;
      LU_xxx_Depo_Date  := to_Char(ap.depo_date, 'YYYY-MM-DD');
      LU_xxx_gl_Date    := to_Char(ap.depo_gl_date, 'YYYY-MM-DD');
      L_xxx_gl_Date     := get_gl_date(L_TPName, LU_xxx_gl_Date);
      L_Start_Date_Depo := ap.start_date_depo;
      L_term_ID         := ap.term_id;
      L_Depo_HeaderID   := ap.HHHeaderID;
      L_Depo_LineID     := ap.HLineID;
      L_trx_Type        := ap.trx_type;
    
      /*===========================================================
      ---- ---- ----Calling the STD API to Create the Depo.    
      ---- ---- ---- If the Org is DiFF and then the Error msg will be Created Here.
      ---- ---- ---- Got the DiFF Org and Need User Switch the Responsibility.
      =============================================================*/
      Print_Logs('++++++------------------Before Calling API To Create Depo------------------++++++');
      ar_deposit_api_pub.Create_Deposit(p_api_version              => 1.0,
                                        p_init_msg_list            => FND_API.G_TRUE,
                                        p_commit                   => FND_API.G_TRUE,
                                        p_validation_level         => FND_API.G_VALID_LEVEL_FULL,
                                        x_return_status            => L_return_Status,
                                        x_msg_count                => L_msg_Count,
                                        x_msg_data                 => L_msg_Data,
                                        p_org_id                   => L_Org_ID,
                                        p_currency_code            => L_Cur_Code,
                                        p_exchange_rate_type       => L_Conver_Type,
                                        p_exchange_rate_date       => L_Conver_Date,
                                        p_exchange_rate            => L_Conver_Rate,
                                        p_amount                   => L_Depo_Amount,
                                        p_batch_source_id          => L_Batch_Source_ID,
                                        p_cust_trx_type_id         => L_Cust_trx_type_ID,
                                        p_inventory_id             => L_Item_ID,
                                        p_memo_line_id             => L_Depo_Memo_Line_id,
                                        p_description              => L_Depo_Description,
                                        p_deposit_date             => L_xxx_Depo_Date,
                                        p_start_date_commitment    => L_Start_Date_Depo,
                                        p_gl_date                  => L_xxx_gl_Date,
                                        p_bill_to_customer_id      => L_Customer_ID,
                                        p_bill_to_location         => L_xxx_LocaCode,
                                        p_remit_to_address_id      => L_RemitToAddress_ID,
                                        p_sold_to_customer_id      => L_Customer_ID,
                                        p_ship_to_location         => L_xxx_LocaID,
                                        p_term_id                  => L_term_ID,
                                        p_class                    => L_trx_Type,
                                        X_new_trx_number           => L_Depo_Num,
                                        X_new_customer_trx_id      => L_Depo_ID,
                                        X_new_customer_trx_line_id => L_Depo_Line_ID,
                                        X_new_rowid                => L_New_Rowid);
    
      Print_Logs('++++++------------------End Calling API To Create Depo------------------++++++');
    
      If L_Depo_ID IS Null Then
        L_Depo_ID := -9999;
      End If;
    
      x_Cuxm_Trx_ID := L_Depo_ID;
      Print_Logs('x_Cuxm_Trx_ID:' || x_Cuxm_Trx_ID);
      Print_Logs('L_Cuxm_Trx_ID:' || L_Depo_ID);
    
      if L_Return_Status = 'S' Then
        PO_CreatedDepo_SumS := PO_CreatedDepo_SumS + 1;
      End If;
    
      if L_Return_Status = 'E' Then
        PO_CreatedDepo_SumE := PO_CreatedDepo_SumE + 1;
      End If;
    
      Update xxx_ar_DepoInv_Selected xDi
         Set xDi.Depo_ID = L_Depo_ID
       where xDi.Org_ID = L_Org_ID
         and xDi.HHHeaderid = L_Depo_HeaderID
         and xDi.HLineid = L_Depo_LineID
         and xDi.Period_Name = L_TPName
         and xDi.Group_Id = x_group_ID;
      Commit;
    
      Depo_CrtdLog_Updated(P_Org_ID                  => L_Org_ID,
                           P_HHHeaderID              => L_HHHeaderID,
                           P_DepoInv_ID              => L_Depo_ID,
                           P_trx_Type                => L_trx_Type,
                           P_xxx_Date                => LU_xxx_Depo_Date,
                           P_xxx_gl_date             => LU_xxx_gl_Date,
                           P_Cur_Code                => ap.cur_code,
                           P_SumDepoInv_Amount       => ap.sumdepo_amount,
                           P_SumDepoInv_ACCTD_Amount => ap.sumdepo_acctd_amount,
                           P_Com_Flag                => 'Y',
                           P_Customer_ID             => ap.bill_customer_id,
                           P_Site_Use_ID             => ap.bill_siteuse_id);
    
      P_msg_Count := L_msg_Count;
      P_msg_Data  := L_msg_Data;
    
      L_Count_DNum := L_Count_DNum + 1;
      Print_Logs('L_Count_DNum:' || L_Count_DNum);
      Print_Logs('L_TPName:' || L_TPName);
      Print_Logs('L_Depo_ID:' || L_Depo_ID);
      Print_Logs('L_Depo_Num:' || L_Depo_Num);
      Print_Logs('L_Customer_ID:' || L_Customer_ID);
      Print_Logs('L_Site_Use_ID:' || L_Site_Use_ID);
      Print_Logs('L_xxx_ACCTSiteID:' || L_xxx_ACCTSiteID);
      Print_Logs('L_xxx_LocaCode:' || L_xxx_LocaCode);
      Print_Logs('L_Cur_Code:' || L_Cur_Code);
      Print_Logs('L_Depo_Amount:' || L_Depo_Amount);
      Print_Logs('Return Status:' || L_Return_Status);
      Print_Logs('Message Count:' || L_msg_Count);
    
      IF L_msg_Count = 1 Then
        Print_Logs('L_msg_data:' || L_msg_data);
      ELSIF L_msg_Count > 1 Then
        For i in 0 .. L_msg_Count Loop
          L_Count_MNum := L_Count_MNum + 1;
          L_msg_data   := FND_MSG_PUB.Get(FND_MSG_PUB.G_NEXT,
                                          FND_API.G_FALSE);
        
          ---- ---- ---- Exit the Loop.                               
          IF L_msg_data is NULL Then
            EXIT;
          END IF;
          Print_Logs('Message:' || L_Count_MNum || '---- ---- ---- ---->' ||
                     L_msg_data);
        END Loop;
        L_Count_MNum := 0;
      End If;
    
    End Loop;
  
  End Auto_CreateDepo_STD;

  /*===========================================================
  ---- Procedure Name:    Auto_CreateInv_STD()
  ---- To Create the AR Invoice Program.
  =============================================================*/
  Procedure Auto_CreateInv_STD(P_msg_Data  Out Varchar2,
                               P_msg_Count Out Number,
                               P_Org_ID    In Number,
                               P_TPName    in varchar2,
                               P_Group_ID  In Number) IS
  
    L_Count_Num Number := 1;
    L_msg_Count Number;
    L_msg_Data  varchar2(1000);
  
    L_Cuxm_Trx_ID   Number;
    L_HLine_ID      Number;
    L_Attri_Context varchar2(25);
    L_Attri_headers varchar2(25);
    L_trx_Type      varchar2(7);
    L_RCPTs_Num     varchar2(30);
  
    L_Org_ID   Number := P_Org_ID;
    x_group_ID Number := P_Group_ID;
  
    L_Cur_Code    varchar2(5);
    L_Conver_Type varchar2(10);
    L_Conver_Date Date;
    L_Conver_Rate Number;
  
    L_HHHeaderID        Number := -9999;
    L_xxx_SourceID      Number := -9999;
    L_xxx_TrxCate_ID    Number := -9999;
    L_xxx_MemiLine_ID   Number := -9999;
    L_xxx_PMTID         Number := -9999;
    L_Customer_ID       Number := -9999;
    L_Site_Use_ID       Number := -9999;
    L_xxx_ACCTSiteID    Number := -9999;
    L_TemitToAddress_ID Number := -9999;
  
    L_TPName       varchar2(7) := P_TPName;
    LU_xxx_gl_Date varchar2(10);
    L_Start_Date   varchar2(10);
    L_xxx_gl_Date  Date;
  
    Cursor DepoInv_Header(P_Org_ID   In Number,
                          P_TPName   in varchar2,
                          P_group_ID In Number) IS
      select Distinct xDi.Org_Id,
                      xDi.HHHeaderID,
                      xDi.Period_Name,
                      xDi.Trx_Type,
                      xDi.Line_Context,
                      xDi.Line_Attria,
                      xDi.Batch_Source_ID,
                      xDi.Batch_Source_Name,
                      xDi.Cur_Code,
                      xDi.Conver_Type,
                      xDi.Conver_Date,
                      xDi.Conver_Rate,
                      xDi.SumDepo_Amount,
                      xDi.SumDepo_ACCTD_Amount,
                      xDi.Cust_Trx_Type_ID,
                      xDi.Cust_Trx_Type_Name,
                      xDi.Bill_Customer_Name,
                      xDi.Bill_Customer_Site,
                      xDi.Bill_Customer_ID,
                      xDi.Bill_Siteuse_ID,
                      xDi.Term_ID,
                      xDi.Term_Name,
                      xDi.Depo_Date,
                      xDi.Depo_Gl_Date
      
        from xxx_ar_DepoInv_Selected xDi
       where xDi.Org_Id = P_Org_ID
         and xDi.Period_Name = P_TPName
         and xDi.group_id = P_group_ID
         and xDi.Trx_Type = 'INV'
         and xDi.Depo_Id = -9999;
  
    Cursor DepoInv_Lines(P_Org_ID     In Number,
                         P_TPName     in varchar2,
                         P_group_ID   In Number,
                         P_HHHeaderID in Number) IS
      select xDi.HLineID,
             xDi.Line_Type,
             xDi.Line_Num,
             xDi.Quantity_Invoiced,
             xDi.Unit_Selling_Price,
             xDi.Depo_Amount,
             xDi.Item_ID,
             xDi.Memo_Line_ID,
             xDi.Memo_Line_Name,
             xDi.Line_Context,
             xDi.Line_Attria,
             xDi.Line_Attrib,
             xDi.Line_Attric
      
        from xxx_ar_DepoInv_Selected xDi
       where xDi.Org_Id = P_Org_ID
         and xDi.HHHeaderID = P_HHHeaderID
         and xDi.group_id = P_group_ID
         and xDi.Trx_Type = 'INV'
         and xDi.Depo_Id = -9999;
  
  Begin
  
    select iii.address_id
      into L_TemitToAddress_ID
      from ra_remit_tos_all iii
     where iii.ORG_ID = L_Org_ID
       and iii.country = 'DEFAULT';
  
    For apH in DepoInv_Header(L_Org_ID, L_TPName, x_group_ID) Loop
    
      L_xxx_SourceID                  := apH.Batch_Source_ID;
      PO_Trx_BatchSoc.batch_source_id := L_xxx_SourceID;
      L_xxx_TrxCate_ID                := apH.Cust_Trx_Type_ID;
    
      L_Customer_ID := apH.Bill_Customer_ID;
      L_Site_Use_ID := apH.Bill_Siteuse_ID;
    
      L_xxx_ACCTSiteID := Get_ACCTSiteID(P_Org_ID      => L_Org_ID,
                                         P_Customer_ID => L_Customer_ID,
                                         P_SiteUse_ID  => L_Site_Use_ID);
    
      L_xxx_PMTID := apH.Term_ID;
    
      L_Start_Date   := to_Char(apH.Depo_Date, 'YYYY-MM-DD');
      LU_xxx_gl_Date := to_Char(apH.Depo_Gl_Date, 'YYYY-MM-DD');
      L_xxx_gl_Date  := Get_GL_Date(L_TPName, LU_xxx_gl_Date);
      LU_xxx_gl_Date := to_Char(L_xxx_gl_Date, 'YYYY-MM-DD');
      L_trx_Type     := apH.Trx_Type;
    
      -------------------------------------------------------------
      ---- Define details for the Header
      ---- this information goes into RA_CUSTOMER_TRX_ALL
      -------------------------------------------------------------
      L_HHHeaderID    := apH.HHHeaderID;
      L_Attri_Context := apH.Line_Context;
      L_Attri_headers := apH.Line_Attria;
    
      L_Cur_Code := apH.Cur_Code;
    
      if apH.conver_type = 'User' Then
        L_Conver_Type := NULL;
        L_Conver_Date := NULL;
        L_Conver_Rate := NULL;
      End If;
    
      if apH.conver_type <> 'User' Then
        L_Conver_Type := apH.conver_type;
      End If;
    
      if apH.conver_type <> 'User' Then
        L_Conver_Date := apH.conver_date;
      End if;
    
      PO_Trx_Header(L_Count_Num).interface_header_attribute1 := L_Attri_headers;
      PO_Trx_Header(L_Count_Num).org_id := L_Org_ID;
      PO_Trx_Header(L_Count_Num).trx_header_id := L_HHHeaderID;
      PO_Trx_Header(L_Count_Num).trx_currency := L_Cur_Code;
      ---- the following are required if you use a trx_currency <> functional currency
      PO_Trx_Header(L_Count_Num).exchange_rate_type := L_Conver_Type;
      PO_Trx_Header(L_Count_Num).exchange_date := L_Conver_Date;
      PO_Trx_Header(L_Count_Num).exchange_rate := L_Conver_Rate;
    
      ---- provide a valid trx_type_id, for type = Inv Defined in the AR Module.
      PO_Trx_Header(L_Count_Num).cust_trx_type_id := L_xxx_TrxCate_ID;
    
      ---- provide a valid bill_to_customer_id    
      ---- provide a valid bill_to_site_use_id, this value should exist in HZ_CUST_SITE_USES_ALL
      PO_Trx_Header(L_Count_Num).bill_to_customer_id := L_Customer_ID;
      PO_Trx_Header(L_Count_Num).bill_to_site_use_id := L_Site_Use_ID;
      ----PO_Trx_Header(L_Count_Num).bill_to_site_use_id := L_xxx_ACCTSiteID;
      PO_Trx_Header(L_Count_Num).remit_to_address_id := L_TemitToAddress_ID;
      ---- provide a valid term_id 
      PO_Trx_Header(L_Count_Num).term_id := L_xxx_PMTID;
    
      PO_Trx_Header(L_Count_Num).org_id := L_Org_ID;
      PO_Trx_Header(L_Count_Num).trx_date := apH.Depo_Date;
      PO_Trx_Header(L_Count_Num).gl_date := L_xxx_gl_Date;
    
      For apL in DepoInv_Lines(L_Org_ID, L_TPName, x_group_ID, L_HHHeaderID) Loop
        ---------------------------------------------------------------------
        ---- Define details for the LINES
        ---- this information goes into RA_CUSTOMER_TRX_LINES_ALL
        ---------------------------------------------------------------------
        L_HLine_ID        := apL.HLineID;
        L_xxx_MemiLine_ID := apL.Memo_Line_ID;
        L_RCPTs_Num       := to_Char(SYSTIMESTAMP, 'YYYYMMDDHH24MISSFF3');
      
        PO_Trx_Line(L_Count_Num).interface_line_context := L_Attri_Context;
        PO_Trx_Line(L_Count_Num).interface_line_attribute1 := L_Attri_headers;
        PO_Trx_Line(L_Count_Num).interface_line_attribute2 := apL.Line_Attrib;
        PO_Trx_Line(L_Count_Num).interface_line_attribute3 := L_RCPTs_Num;
        PO_Trx_Line(L_Count_Num).interface_line_attribute4 := apL.Line_Attric;
      
        ----this value needs to be unique per header_id value  
        ---- this value needs to match the trx_header_id value provided in trx_header_tbl(1).trx_header_id
        PO_Trx_Line(L_Count_Num).trx_header_id := L_HHHeaderID;
        PO_Trx_Line(L_Count_Num).trx_line_id := L_HLine_ID;
      
        ---- Unique Line Number
        PO_Trx_Line(L_Count_Num).line_type := apL.Line_Type;
        PO_Trx_Line(L_Count_Num).line_number := apL.Line_Num;
        PO_Trx_Line(L_Count_Num).memo_line_id := L_xxx_MemiLine_ID;
        PO_Trx_Line(L_Count_Num).description := apL.Memo_Line_Name;
        PO_Trx_Line(L_Count_Num).quantity_invoiced := apL.quantity_invoiced;
        PO_Trx_Line(L_Count_Num).unit_selling_price := apL.unit_selling_price;
        PO_Trx_Line(L_Count_Num).amount := apL.depo_amount;
        L_Count_Num := L_Count_Num + 1;
      End Loop;
      Print_Logs('++++++------------------START Create Invoice-Create_Invoice_STD------------------++++++');
      Create_Invoice_STD(P_msg_Data        => L_msg_Data,
                         P_msg_Count       => L_msg_Count,
                         x_Cuxm_Trx_ID     => L_Cuxm_Trx_ID,
                         P_Org_ID          => L_Org_ID,
                         P_Trx_BatchSoc    => PO_Trx_BatchSoc,
                         P_Trx_Header      => PO_Trx_Header,
                         P_Trx_Line        => PO_Trx_Line,
                         P_Trx_Dist        => PO_Trx_Dist,
                         P_Trx_SalesCredit => PO_Trx_SalesCredit);
    
      Print_Logs('++++++------------------End Create Invoice-Create_Invoice_STD------------------++++++');
      Print_Logs('L_Customer_ID:' || L_Customer_ID);
      Print_Logs('L_Site_Use_ID:' || L_Site_Use_ID);
      Print_Logs('L_xxx_ACCTSiteID:' || L_xxx_ACCTSiteID);
      Print_Logs('L_Start_Date:' || L_Start_Date);
      Print_Logs('LU_xxx_gl_Date:' || LU_xxx_gl_Date);
    
      Update xxx_ar_DepoInv_Selected xDi
         Set xDi.Depo_ID = L_Cuxm_Trx_ID
       where xDi.Org_ID = L_Org_ID
         and xDi.HHHeaderid = L_HHHeaderID
         and xDi.Period_Name = L_TPName
         and xDi.Group_Id = x_group_ID;
      Commit;
    
      Print_Logs('++++++------------------Start Update The Log-Depo_CrtdLog_Updated------------------++++++');
      Depo_CrtdLog_Updated(P_Org_ID                  => L_Org_ID,
                           P_HHHeaderID              => L_HHHeaderID,
                           P_DepoInv_ID              => L_Cuxm_Trx_ID,
                           P_trx_Type                => L_trx_Type,
                           P_xxx_Date                => L_Start_Date,
                           P_xxx_gl_date             => LU_xxx_gl_Date,
                           P_Cur_Code                => apH.cur_code,
                           P_SumDepoInv_Amount       => apH.Sumdepo_Amount,
                           P_SumDepoInv_ACCTD_Amount => apH.SumDepo_ACCTD_Amount,
                           P_Com_Flag                => 'Y',
                           P_Customer_ID             => aph.bill_customer_id,
                           P_Site_Use_ID             => aph.bill_siteuse_id);
      Print_Logs('++++++------------------End Update The Log-Depo_CrtdLog_Updated------------------++++++');
    
      L_Count_Num := 1;
      P_msg_Data  := L_msg_Data;
      P_msg_Count := L_msg_Count;
    End Loop;
  
  End Auto_CreateInv_STD;

  /*===========================================================
  ---- Procedure Name:    Auto_Created_STD()
  ---- To  AutoCreate Depo&Inv.
  =============================================================*/
  Procedure Auto_Created_STD(P_msg_Data  Out Varchar2,
                             P_msg_Count Out Number,
                             P_TPName    in varchar2) IS
  
    L_Org_ID       Number;
    x_group_ID     Number;
    L_trxDep_Count Number := 0;
    L_trxInv_Count Number := 0;
    L_TPName       varchar2(7) := P_TPName;
    L_trxDep_Type  varchar2(7) := 'DEP';
    L_trxInv_Type  varchar2(7) := 'INV';
  
    L_msg_Count     Number;
    L_msg_Data      varchar2(1000);
    L_xxx_RequestID Number;
  
  Begin
  
    /*===========================================================
    ---- ---- ---- To Set the Apps Contexts.
    =============================================================*/
    L_Org_ID := fnd_global.Org_ID;
  
    If L_TPName is Null Or Period_Checking(L_TPName) = 'N' Then
      Print_Output('L_TPName:' || L_TPName);
      Print_Output('L_Closing_Status:' || Period_Checking(L_TPName));
      Print_Output('The Period U Selected is Closed Already and Please Select the Openning Periods For Your Transactions... ...!!!');
      Print_Output('L_TPOpen_Sum:' || Get_Open_Num);
      Get_Openning;
    
      ---- ---- ---- ---- If the Period Input is Opening.
    else
    
      ---- ---- ---- ---- To Build the Depo&Invoice Data.
      select Count(*)
        into L_trxDep_Count
        from xxx_ar_depoinv_header xDs
       where xDs.Trx_Type = 'DEP'
         and xDs.Period_Name = L_TPName
         and xDs.Group_Id = -9999;
    
      select Count(*)
        into L_trxInv_Count
        from xxx_ar_depoinv_header xDs
       where xDs.Trx_Type = 'INV'
         and xDs.Period_Name = L_TPName
         and xDs.Group_Id = -9999;
    
      If L_trxDep_Count <> 0 Then
        Build_Data(P_Org_ID   => L_Org_ID,
                   P_Group_ID => x_group_ID,
                   P_TPName   => L_TPName,
                   P_trx_Type => L_trxDep_Type);
      
        Auto_CreateDepo_STD(P_msg_Data  => L_msg_Data,
                            P_msg_Count => L_msg_Count,
                            P_Org_ID    => L_Org_ID,
                            P_TPName    => L_TPName,
                            P_Group_ID  => x_group_ID);
      
        fnd_request.set_org_id(L_Org_ID);
        L_xxx_RequestID := fnd_request.submit_request(application => 'AR',
                                                      program     => 'BUILD_HTML',
                                                      description => NULL,
                                                      start_time  => to_char(SYSDATE,
                                                                             'YYYY/MM/DD HH24:MI:SS'),
                                                      sub_request => FALSE,
                                                      argument1   => L_Org_ID,
                                                      argument2   => L_TPName,
                                                      argument3   => x_group_ID);
      
        if L_xxx_RequestID <= 0 OR L_xxx_RequestID IS NULL THEN
          P_msg_Data := 'Failed The CreateDepo_Log Triggered';
        else
          P_msg_Data := 'CreateDepo_Log Triggered SuccessFully.';
        End If;
      
      End If;
    
      If L_trxInv_Count <> 0 Then
        Build_Data(P_Org_ID   => L_Org_ID,
                   P_Group_ID => x_group_ID,
                   P_TPName   => L_TPName,
                   P_trx_Type => L_trxInv_Type);
      
        Auto_CreateInv_STD(P_msg_Data  => L_msg_Data,
                           P_msg_Count => L_msg_Count,
                           P_Org_ID    => L_Org_ID,
                           P_TPName    => L_TPName,
                           P_Group_ID  => x_group_ID);
      
        fnd_request.set_org_id(L_Org_ID);
        L_xxx_RequestID := fnd_request.submit_request(application => 'AR',
                                                      program     => 'BUILD_HTML',
                                                      description => NULL,
                                                      start_time  => to_char(SYSDATE,
                                                                             'YYYY/MM/DD HH24:MI:SS'),
                                                      sub_request => FALSE,
                                                      argument1   => L_Org_ID,
                                                      argument2   => L_TPName,
                                                      argument3   => x_group_ID);
      
        if L_xxx_RequestID <= 0 OR L_xxx_RequestID IS NULL THEN
          P_msg_Data := 'Failed The CreateInv_Log Triggered';
        else
          P_msg_Data := 'CreateInv_Log Triggered SuccessFully.';
        End If;
      
      End If;
    
    End If;
  
    Print_Output('The STDInv Created SumS:' || PO_CreatedInv_SumS);
    Print_Output('The STDInv Created SumE:' || PO_CreatedInv_SumE);
    Print_Output('The STDDepo Created SumS:' || PO_CreatedDepo_SumS);
    Print_Output('The STDDepo Created SumE:' || PO_CreatedDepo_SumE);
  
  Exception
    When Others Then
      P_msg_Data := SQLERRM;
      Print_Logs(P_msg_Data);
      P_msg_Data := SQLCODE;
      Print_Logs(P_msg_Data);
    
  End Auto_Created_STD;

End xxx_ar_STDCreateDepoInv_pkg;
/
