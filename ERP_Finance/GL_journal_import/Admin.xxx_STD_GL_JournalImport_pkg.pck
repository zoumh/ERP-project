CREATE OR REPLACE Package xxx_STD_GL_JournalImport_pkg Is
  /*===============================================================
  *   Copyright (C) 
  * ===============================================================
  *    Program Name:   xxx_STD_GL_JournalImport_pkg
  *    Author      :   Doris ZOU
  *    Date        :   2013-02-28
  *    Purpose     :  To Import the Journals.
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
  ---- Procedure Name:    Build_Random()
  ---- To Create the Journals Randoms.
  =============================================================*/
  Procedure Build_Random(P_ComCode in varchar2, P_TPName in varchar2);

  /*===========================================================
  ---- Procedure Name:    Build_Imported()
  ---- To Create the Journal BY User Imported.
  =============================================================*/
  Procedure Build_Imported(P_ComCode in varchar2, P_TPName in varchar2);

  /*===========================================================
  ---- Procedure Name:    xxxMain()
  ---- The Main Procedure Of This pkg.
  =============================================================*/
  Procedure xxxMain(P_msg_Data  Out Varchar2,
                    P_msg_Count Out Number,
                    P_ComCode   in varchar2,
                    P_TPName    in varchar2);

End xxx_STD_GL_JournalImport_pkg;
/
CREATE OR REPLACE Package Body xxx_STD_GL_JournalImport_pkg Is
  /*===============================================================
  *   Copyright (C) Doris ZOU
  * ===============================================================
  *    Program Name:   xxx_STD_GL_JournalImport_pkg
  *    Author      :   Doris ZOU
  *    Date        :   2013-02-28
  *    Purpose     :  To Import the Journals.
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
  ---- Function Name:    get_OrgID()
  ---- To get the OrgID BY ComCode.
  =============================================================*/
  Function get_OrgID(P_ComCode in varchar2) Return Number IS
  
    L_OrgID number := 0;
  Begin
    select haou.organization_id Org_ID
      into L_OrgID
    
      from hr_all_organization_units    haou,
           hr_all_organization_units_tl haot,
           hr_organization_information  hoi,
           hr_organization_information  hoii,
           gl_ledgers                   gll
     where haou.organization_id = hoi.organization_id
       and haou.organization_id = hoii.organization_id
       and hoi.org_information_context || '' = 'CLASS'
       and hoii.org_information_context = 'Operating Unit Information'
       and hoi.org_information1 = 'OPERATING_UNIT'
       and hoi.org_information2 = 'Y'
       and haou.organization_id = haot.organization_id
       and haot.language = userenv('LANG')
       and hoii.org_information5 = P_ComCode
       and hoii.org_information3 = gll.ledger_id;
  
    Return(L_OrgID);
  End get_OrgID;

  /*===========================================================
  ---- Function Name:    get_CCID()
  ---- To get the CCID.
  =============================================================*/
  Function get_CCID(P_COAChart_ID in Number, P_COAChart_Segmns in varchar2)
    Return Number is
  
    L_COAChart_ID     Number := P_COAChart_ID;
    L_COAChart_Segmns varchar2(188) := P_COAChart_Segmns;
    L_Appl_Code       varchar2(5) := 'SQLGL';
    L_IDCode          varchar2(5) := 'GL#';
    --L_Delimiter_Limits varchar2(5);
    L_Validn_Date varchar2(25) := to_char(SYSDATE, 'YYYY-MM-DD HH24:MI:SS');
    L_xx_glCCID   Number;
  
  Begin
  
    L_xx_glCCID := fnd_flex_ext.get_ccid(application_short_name => L_Appl_Code,
                                         key_flex_code          => L_IDCode,
                                         structure_number       => L_COAChart_ID,
                                         validation_date        => L_Validn_Date,
                                         concatenated_segments  => L_COAChart_Segmns);
    Return(L_xx_glCCID);
  End get_CCID;

  /*===========================================================
  ---- Func Name:    CountSumSCN()
  ---- To Count the 'P_TPStatus' Records.
  ---- 'O' Or 'C' Status Of the Period.
  =============================================================*/
  Function CountSumSCN(P_TPName in varchar2, P_TPStatus in varchar2)
    Return Number IS
  
    L_TPStatus_Sum Number := 0;
  
  Begin
    select Count(*)
      into L_TPStatus_Sum
      from xxx_xla_Sum_Log xla_SumT
     where xla_SumT.status = P_TPStatus
       and xla_SumT.Pd_Name = P_TPName
       and xla_SumT.Application_Id = fnd_global.resp_Appl_ID;
    Return(L_TPStatus_Sum);
  
  End CountSumSCN;

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
  ---- Procedure Name:    Build_Random()
  ---- To Create the Journals Randoms.
  =============================================================*/
  Procedure Build_Random(P_ComCode in varchar2, P_TPName in varchar2) is
  
    L_iFace_Rec     gl_interface%ROWTYPE;
    L_Batch_Num     varchar2(30) := to_Char(SYSTIMESTAMP,
                                            'YYYYMMDDHH24MISSFF3');
    L_user_source   gl_je_sources_tl.user_je_source_name%TYPE := 'Manual';
    L_User_category gl_je_categories_tl.user_je_category_name%TYPE := 'Fwd';
    L_je_source     gl_je_sources_tl.je_source_name%TYPE;
  
    L_Gl_ContrlID Number;
    L_Request_ID  Number;
  
    type MAmount is table Of varchar2(12) index by binary_integer;
    L_Accounting_Date MAmount;
    type xMAmount is varray(5) Of varchar2(5) Not Null;
    L_Acct_Curr   xMAmount := xMAmount('CNY', 'USD', 'HKD');
    L_Curr_Number Number := 3;
    type cMAmount is table Of Number index by binary_integer;
    L_gl_CCID    cMAmount;
    L_COA_Count  Number := 0;
    L_COA_Random Number;
    L_CCID_Dr    Number := 0;
    L_CCID_Cr    Number := 0;
  
    L_Null         varchar2(1);
    L_iii          Number := 0;
    L_Journal_Line Number := 5;
    L_StartNumber  Number := 1;
    L_EndNumber    Number := 200;
    L_SOB_ID       Number;
    L_SOB_Curr     varchar2(5);
    L_Curr_Rate    Number;
    L_Curr_RTpe    varchar2(20);
    L_Curr_DRTpe   varchar2(20) := 'Corporate';
    L_Curr_Prce    Number;
    L_TPName       varchar2(7) := P_TPName;
    L_Date_Format  varchar2(10) := 'YYYY-MM-DD';
    L_TPName_Days  Number := 0;
    L_DRandom_Num  Number := 0;
    L_CRandom_Num  Number := 0;
    L_EnAmount     Number := 0;
    L_AcctdAmount  Number := 0;
    L_Actual_Flag  varchar2(1) := 'A';
    L_Conn_Char    varchar2(2) := '-';
  
    Cursor gl_Date(P_SOB_ID in Number, P_TPName in varchar2) is
      select gmm.period_name, gmm.accounting_date
        from gl_date_period_map gmm, gl_ledgers gll
       where gmm.period_set_name = gll.period_set_name
         and gmm.period_name = P_TPName
         and gll.ledger_id = P_SOB_ID;
  
    Cursor gl_COA(P_ComCode in varchar2) is
      select gcc.segment1 ComCode,
             gcc.code_combination_id,
             gcc.concatenated_segments
        from gl_code_combinations_kfv gcc
       where gcc.segment1 = P_ComCode
         and gcc.summary_flag = 'N'
         and gcc.enabled_flag = 'Y'
         and nvl(gcc.end_date_active, SYSDATE + 1) >= SYSDATE;
  
  Begin
  
    select fnd_profile.value('GL_SET_OF_BKS_ID'),
           gll.currency_code,
           fcc.precision,
           nvl(gll.daily_translation_rate_type, L_Curr_DRTpe)
      into L_SOB_ID, L_SOB_Curr, L_Curr_Prce, L_Curr_RTpe
      from gl_ledgers gll, fnd_currencies fcc
     where gll.ledger_id = fnd_profile.value('GL_SET_OF_BKS_ID')
       and gll.currency_code = fcc.currency_code;
  
    select Sum(1)
      into L_COA_Count
      from gl_code_combinations_kfv gcc
     where gcc.segment1 = P_ComCode
       and gcc.summary_flag = 'N'
       and gcc.enabled_flag = 'Y'
       and nvl(gcc.end_date_active, SYSDATE) >= SYSDATE;
  
    L_iii := 1;
    For xx in gl_COA(P_ComCode) Loop
      L_gl_CCID(L_iii) := xx.code_combination_id;
      L_iii := L_iii + 1;
    End Loop;
  
    select Sum(1)
      into L_TPName_Days
      from gl_date_period_map gmm, gl_ledgers gll
     where gmm.period_set_name = gll.period_set_name
       and gmm.period_name = L_TPName
       and gll.ledger_id = L_SOB_ID;
  
    L_iii := 1;
    For xx in gl_Date(L_SOB_ID, L_TPName) Loop
      L_Accounting_Date(L_iii) := to_Char(xx.accounting_date, L_Date_Format);
      dbms_output.put_line('L_Accounting_Date:' ||
                           L_Accounting_Date(L_iii));
      L_iii := L_iii + 1;
    End Loop;
  
    SELECT gl_interface_control_s.nextval
      INTO L_iFace_Rec.group_id
      FROM dual;
    SELECT gl_interface_control_s.nextval INTO L_Gl_ContrlID FROM dual;
  
    select gtt.je_source_name
      into L_je_source
      from gl_je_sources_tl gtt
     where gtt.language = userenv('LANG')
       and gtt.user_je_source_name = L_user_source;
  
    L_iii := 1;
    for L_iii in L_StartNumber .. L_EndNumber Loop
    
      select dbms_random.value(1, L_COA_Count) into L_COA_Random from dual;
      L_COA_Random := Floor(L_COA_Random);
      L_CCID_Dr    := L_gl_CCID(L_COA_Random);
      select dbms_random.value(1, L_COA_Count) into L_COA_Random from dual;
      L_COA_Random := Floor(L_COA_Random);
      L_CCID_Cr    := L_gl_CCID(L_COA_Random);
    
      select dbms_random.value(1, L_TPName_Days)
        into L_DRandom_Num
        from dual;
      L_DRandom_Num := Floor(L_DRandom_Num);
    
      select dbms_random.value(1, L_Curr_Number)
        into L_CRandom_Num
        from dual;
      L_CRandom_Num := Floor(L_CRandom_Num);
    
      select round(dbms_random.value(100, 10000), L_Curr_Prce)
        into L_EnAmount
        from dual;
      if L_Acct_Curr(L_CRandom_Num) = L_SOB_Curr Then
        L_AcctdAmount := L_EnAmount;
      End if;
    
      if L_Acct_Curr(L_CRandom_Num) <> L_SOB_Curr Then
        select Sum(gdd.conversion_rate)
          into L_Curr_Rate
          from gl_daily_rates gdd
         where gdd.from_currency = L_Acct_Curr(L_CRandom_Num)
           and gdd.to_currency = L_SOB_Curr
           and gdd.conversion_type = L_Curr_RTpe
           and gdd.conversion_date =
               to_Date(L_Accounting_Date(L_DRandom_Num), L_Date_Format);
        if L_Curr_Rate = 0 Then
          L_Curr_Rate := 1;
        End if;
        L_AcctdAmount := Round(L_EnAmount * L_Curr_Rate, L_Curr_Prce);
      End if;
      L_Journal_Line := L_Journal_Line + 1;
      ---- ---- ---- ---- Inster the Data Of Dr.
      L_iFace_Rec.status              := 'NEW';
      L_iFace_Rec.ledger_id           := L_SOB_ID;
      L_iFace_Rec.set_of_books_id     := L_SOB_ID;
      L_iFace_Rec.period_name         := L_TPName;
      L_iFace_Rec.accounting_date     := to_Date(L_Accounting_Date(L_DRandom_Num),
                                                 L_Date_Format);
      L_iFace_Rec.currency_code       := L_Acct_Curr(L_CRandom_Num);
      L_iFace_Rec.code_combination_id := L_CCID_Dr;
      L_iFace_Rec.actual_flag         := L_Actual_Flag;
    
      L_iFace_Rec.entered_dr   := L_EnAmount;
      L_iFace_Rec.accounted_dr := L_AcctdAmount;
      L_iFace_Rec.entered_cr   := L_Null;
      L_iFace_Rec.accounted_cr := L_Null;
    
      L_iFace_Rec.user_je_source_name   := L_user_source;
      L_iFace_Rec.user_je_category_name := L_User_category;
    
      L_iFace_Rec.created_by   := fnd_global.user_id;
      L_iFace_Rec.date_created := SYSDATE;
    
      L_iFace_Rec.reference1  := L_Batch_Num;
      L_iFace_Rec.reference2  := L_Batch_Num;
      L_iFace_Rec.reference4  := L_Batch_Num;
      L_iFace_Rec.reference5  := L_Batch_Num;
      L_iFace_Rec.reference10 := L_CCID_Dr || L_Conn_Char || L_CCID_Cr ||
                                 L_Conn_Char || L_EnAmount;
      --L_iFace_Rec.reference21 := l.header_id; --REFERENCE_1
      --L_iFace_Rec.reference22 := L_Journal_Line; --REFERENCE_2 line_id
      --L_iFace_Rec.reference23 := l.define_id; --REFERENCE_3
      --L_iFace_Rec.reference24 := l.request_id; --REFERENCE_4
      L_iFace_Rec.reference25 := P_ComCode; --REFERENCE_5
      L_iFace_Rec.reference26 := L_TPName; --REFERENCE_6
      L_iFace_Rec.reference28 := L_Journal_Line; --Journal Line Number
      INSERT INTO gl_interface VALUES L_iFace_Rec;
    
      L_Journal_Line := L_Journal_Line + 1;
      ---- ---- ---- ---- Inster the Data Of Cr.
      L_iFace_Rec.status          := 'NEW';
      L_iFace_Rec.ledger_id       := L_SOB_ID;
      L_iFace_Rec.set_of_books_id := L_SOB_ID;
      L_iFace_Rec.period_name     := L_TPName;
      L_iFace_Rec.accounting_date := to_Date(L_Accounting_Date(L_DRandom_Num),
                                             L_Date_Format);
    
      L_iFace_Rec.currency_code       := L_Acct_Curr(L_CRandom_Num);
      L_iFace_Rec.code_combination_id := L_CCID_Cr;
      L_iFace_Rec.actual_flag         := L_Actual_Flag;
    
      L_iFace_Rec.entered_dr   := L_Null;
      L_iFace_Rec.accounted_dr := L_Null;
      L_iFace_Rec.entered_cr   := L_EnAmount;
      L_iFace_Rec.accounted_cr := L_AcctdAmount;
    
      L_iFace_Rec.user_je_source_name   := L_user_source;
      L_iFace_Rec.user_je_category_name := L_User_category;
    
      L_iFace_Rec.created_by   := fnd_global.user_id;
      L_iFace_Rec.date_created := SYSDATE;
    
      L_iFace_Rec.reference1  := L_Batch_Num; ----Batch Name
      L_iFace_Rec.reference2  := L_Batch_Num; ----Batch Desc
      L_iFace_Rec.reference4  := L_Batch_Num; ----Journal Name
      L_iFace_Rec.reference5  := L_Batch_Num; ----Journal Desc
      L_iFace_Rec.reference10 := L_CCID_Dr || L_Conn_Char || L_CCID_Cr ||
                                 L_Conn_Char || L_EnAmount; ----Journal Line Desc
      --L_iFace_Rec.reference21 := l.header_id; --REFERENCE_1
      --L_iFace_Rec.reference22 := L_Journal_Line; --REFERENCE_2 line_id
      --L_iFace_Rec.reference23 := l.define_id; --REFERENCE_3
      --L_iFace_Rec.reference24 := l.request_id; --REFERENCE_4
      L_iFace_Rec.reference25 := P_ComCode; --REFERENCE_5
      L_iFace_Rec.reference26 := L_TPName; --REFERENCE_6
      L_iFace_Rec.reference28 := L_Journal_Line; --Journal Line Number
      INSERT INTO gl_interface VALUES L_iFace_Rec;
    End Loop;
  
    INSERT INTO gl_interface_control
      (je_source_name, group_id, interface_run_id, set_of_books_id, status)
    values
      (L_je_source,
       L_iFace_Rec.group_id,
       L_Gl_ContrlID,
       L_iFace_Rec.ledger_id,
       'S');
  
    Commit;
  
    L_Request_ID := fnd_request.submit_request('SQLGL',
                                               'GLLEZL',
                                               L_Null,
                                               to_char(SYSDATE,
                                                       'YYYY/MM/DD HH24:MI:SS'),
                                               FALSE,
                                               L_Gl_ContrlID,
                                               L_iFace_Rec.ledger_id,
                                               'N', ----Post Errors to Suspense
                                               L_Null,
                                               L_Null,
                                               'N', ----Create Summary Journals
                                               'W', ----Import Descriptive Flexfields
                                               chr(0));
  
  End Build_Random;

  /*===========================================================
  ---- Procedure Name:    Build_Imported()
  ---- To Create the Journal BY User Imported.
  =============================================================*/
  Procedure Build_Imported(P_ComCode in varchar2, P_TPName in varchar2) is
  
    L_iFace_Rec     gl_interface%ROWTYPE;
    L_Batch_Num     varchar2(30) := to_Char(SYSTIMESTAMP,
                                            'YYYYMMDDHH24MISSFF3');
    L_user_source   gl_je_sources_tl.user_je_source_name%TYPE := 'Manual';
    L_User_category gl_je_categories_tl.user_je_category_name%TYPE := 'Fwd';
    L_je_source     gl_je_sources_tl.je_source_name%TYPE;
  
    L_Null           varchar2(1);
    L_SOB_ID         Number;
    L_SOB_Curr       varchar2(5);
    L_Curr_Rate      Number;
    L_Curr_RTpe      varchar2(20);
    L_Curr_DRTpe     varchar2(20) := 'Corporate';
    L_Curr_Prce      Number;
    L_Actual_Flag    varchar2(1) := 'A';
    L_AcctdAmount_dr Number;
    L_AcctdAmount_cr Number;
  
    L_IFace_Number Number := 0;
    L_Gl_ContrlID  Number;
    L_Request_ID   Number;
    L_IFace_GoupID Number;
    L_CCID_Dr      Number := 0;
    L_CCID_Cr      Number := 0;
  
    L_Conn_Char varchar2(2) := '-';
  
    Cursor gl_Journal(P_ComCode in varchar2, P_TPName in varchar2) is
      select *
        from xxx_STD_GL_Jmport_IFace xx
       where xx.segment1 = P_ComCode
         and xx.period_name = P_TPName
         and xx.xx_Status = 'I'
         For Update Of xx.xx_status;
  
  Begin
  
    select fnd_profile.value('GL_SET_OF_BKS_ID'),
           gll.currency_code,
           fcc.precision,
           nvl(gll.daily_translation_rate_type, L_Curr_DRTpe)
      into L_SOB_ID, L_SOB_Curr, L_Curr_Prce, L_Curr_RTpe
      from gl_ledgers gll, fnd_currencies fcc
     where gll.ledger_id = fnd_profile.value('GL_SET_OF_BKS_ID')
       and gll.currency_code = fcc.currency_code;
  
    SELECT gl_interface_control_s.nextval INTO L_IFace_GoupID FROM dual;
    L_iFace_Rec.group_id := L_IFace_GoupID;
    SELECT gl_interface_control_s.nextval INTO L_Gl_ContrlID FROM dual;
  
    select gtt.je_source_name
      into L_je_source
      from gl_je_sources_tl gtt
     where gtt.language = userenv('LANG')
       and gtt.user_je_source_name = L_user_source;
  
    For xx in gl_Journal(P_ComCode, P_TPName) Loop
      L_IFace_Number := L_IFace_Number + 1;
      if xx.currency_code <> L_SOB_Curr Then
        select Sum(gdd.conversion_rate)
          into L_Curr_Rate
          from gl_daily_rates gdd
         where gdd.from_currency = xx.currency_code
           and gdd.to_currency = L_SOB_Curr
           and gdd.conversion_type = L_Curr_RTpe
           and gdd.conversion_date = xx.accounting_date;
        if L_Curr_Rate = 0 Then
          L_Curr_Rate := 1;
        End if;
        L_AcctdAmount_dr := xx.entered_dr;
        L_AcctdAmount_cr := xx.entered_cr;
        if xx.entered_dr is not null Then
          L_AcctdAmount_dr := Round(xx.entered_dr * L_Curr_Rate,
                                    L_Curr_Prce);
        End if;
        if xx.entered_cr is not null Then
          L_AcctdAmount_cr := Round(xx.entered_cr * L_Curr_Rate,
                                    L_Curr_Prce);
        End if;
      End if;
    
      ---- ---- ---- ---- Inster the Data Of Imported Details.
      L_iFace_Rec.status          := 'NEW';
      L_iFace_Rec.ledger_id       := L_SOB_ID;
      L_iFace_Rec.set_of_books_id := L_SOB_ID;
      L_iFace_Rec.period_name     := P_TPName;
      L_iFace_Rec.accounting_date := xx.accounting_date;
      L_iFace_Rec.currency_code   := xx.currency_code;
      --L_iFace_Rec.code_combination_id := L_CCID_DCr;
      L_iFace_Rec.Segment1  := xx.segment1;
      L_iFace_Rec.Segment2  := xx.Segment2;
      L_iFace_Rec.Segment3  := xx.Segment3;
      L_iFace_Rec.Segment4  := xx.Segment4;
      L_iFace_Rec.Segment5  := xx.Segment5;
      L_iFace_Rec.Segment6  := xx.Segment6;
      L_iFace_Rec.Segment7  := xx.Segment7;
      L_iFace_Rec.Segment8  := xx.Segment8;
      L_iFace_Rec.Segment9  := xx.Segment9;
      L_iFace_Rec.Segment10 := xx.Segment10;
    
      L_iFace_Rec.actual_flag := L_Actual_Flag;
    
      L_iFace_Rec.entered_dr   := xx.entered_dr;
      L_iFace_Rec.entered_cr   := xx.entered_cr;
      L_iFace_Rec.accounted_dr := L_AcctdAmount_dr;
      L_iFace_Rec.accounted_cr := L_AcctdAmount_cr;
    
      L_iFace_Rec.user_je_source_name   := L_user_source;
      L_iFace_Rec.user_je_category_name := L_User_category;
    
      L_iFace_Rec.created_by   := fnd_global.user_id;
      L_iFace_Rec.date_created := SYSDATE;
    
      L_iFace_Rec.reference1  := L_Batch_Num;
      L_iFace_Rec.reference2  := L_Batch_Num;
      L_iFace_Rec.reference4  := L_Batch_Num;
      L_iFace_Rec.reference5  := L_Batch_Num;
      L_iFace_Rec.reference10 := xx.concatenated_segments;
      --L_iFace_Rec.reference21 := l.header_id; --REFERENCE_1
      --L_iFace_Rec.reference22 := L_Journal_Line; --REFERENCE_2 line_id
      --L_iFace_Rec.reference23 := l.define_id; --REFERENCE_3
      --L_iFace_Rec.reference24 := l.request_id; --REFERENCE_4
      L_iFace_Rec.reference25 := P_ComCode; --REFERENCE_5
      L_iFace_Rec.reference26 := P_TPName; --REFERENCE_6
      L_iFace_Rec.reference28 := xx.journalline_number; --Journal Line Number
    
      INSERT INTO gl_interface VALUES L_iFace_Rec;
    End Loop;
  
    INSERT INTO gl_interface_control
      (je_source_name, group_id, interface_run_id, set_of_books_id, status)
    values
      (L_je_source,
       L_IFace_GoupID,
       L_Gl_ContrlID,
       L_iFace_Rec.ledger_id,
       'S');
  
    Commit;
  
    if L_IFace_Number >= 2 Then
      L_Request_ID := fnd_request.submit_request('SQLGL',
                                                 'GLLEZL',
                                                 L_Null,
                                                 to_char(SYSDATE,
                                                         'YYYY/MM/DD HH24:MI:SS'),
                                                 FALSE,
                                                 L_Gl_ContrlID,
                                                 L_iFace_Rec.ledger_id,
                                                 'N', ----Post Errors to Suspense
                                                 L_Null,
                                                 L_Null,
                                                 'N', ----Create Summary Journals
                                                 'W', ----Import Descriptive Flexfields
                                                 chr(0));
    End if;
  End Build_Imported;

  /*===========================================================
  ---- Procedure Name:    xxxMain()
  ---- The Main Procedure Of This pkg.
  =============================================================*/
  Procedure xxxMain(P_msg_Data  Out Varchar2,
                    P_msg_Count Out Number,
                    P_ComCode   in varchar2,
                    P_TPName    in varchar2) is
  
    L_TPName varchar2(10) := P_TPName;
  
  Begin
  
    ---- ---- ---- ---- To Build the Data Of Details and Total.  
    Build_Random(P_ComCode, L_TPName);
    Build_Imported(P_ComCode, L_TPName);
  
    /*Submit_Request(P_ComCode      => P_ComCode,
                   P_TPName       => L_TPName,
                   P_Rturn_Status => x_Rturn_Status,
                   P_msg_Data     => x_msg_Data,
                   P_Request_ID   => x_Request_ID);
    
    Print_Logs('P_Request_ID:' || x_Request_ID);
    Print_Logs('P_Rturn_Status:' || x_Rturn_Status);*/
  
  End xxxMain;

End xxx_STD_GL_JournalImport_pkg;
/
