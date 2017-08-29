CREATE OR REPLACE Package xxx_CommonChecking_pkg Is
  /*===============================================================
  *   Copyright (C) Doris ZOU
  * ===============================================================
  *    Program Name:   xxx_CommonChecking_pkg
  *    Author      :   Doris ZOU
  *    Date        :   2013-01-28
  *    Purpose     :   Pl/Sql Html Report PKG
  *                    To Get Some Common Func Or Procedures.
  *
  *
  *    Update History
  *    Version    Date                             Name                           Description
  *    --------  ----------  ----------------------------------  --------------------
  *     V1.0     2013-01-28     Doris ZOU.         Creation
  *
    ===============================================================*/
  ----  ---- ----  ----
  type DCNAmount is table Of Number index by binary_integer;
  type DCvAmount is table Of varchar2(30000) index by binary_integer;

  LO_Bank_Status_Checking varchar2(188) := 'Has No the Mthod For This Bank&Account!!!';
  PO_Report_Output_Mode   Varchar2(2);
  P_NTName                varchar2(8) := '2199-12';
  P_xxx_Null              varchar2(50) := NULL;
  ----  ---- ----  ----
  ----  ---- ----  ----
  Procedure Output_Line(P_Output_Str  In Varchar2,
                        P_Output_Mode In Varchar2 Default PO_Report_Output_Mode);
  ----  ---- ----  ----
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
  ---- Procedure Name:    xxxx()
  =============================================================*/
  Function xxxx(xxxx IN Varchar2, Value IN Varchar2) Return Varchar2;

  /*===========================================================
  ---- Procedure Name:    get_pwd()
  ---- To Print the pswd Info
  =============================================================*/
  Function get_pwd(P_UName In Varchar2) Return Varchar2;

  /*===========================================================
  ---- Function Name:    isUserExtUE()
  ---- To Check the User Exisit Or Not with UnExpired.
  =============================================================*/
  Function isUserExtUE(P_User_Name In Varchar2) Return Varchar2;

  /*===========================================================
  ---- Function Name:    isEnCoded()
  ---- To Check the pkg EnCode Or Not.
  =============================================================*/
  Function isEnCoded(P_Package_Code In Varchar2) Return Varchar2;

  /*===========================================================
  ---- Function Name:    toCacuNN()
  ---- To Caculate the N+(N-1)+(N-2)+...+2+1=SUM
  =============================================================*/
  Function toCacuNN(P_xxx_Number In Varchar2) Return Number;

  /*===========================================================
  ---- Function Name:    DoEnCoded()
  ---- To Do the pkg EnCode.
  =============================================================*/
  Procedure DoEnCoded(P_Package_Code In Varchar2);

  /*===========================================================
  ---- Procedure Name:    CHGPSWD()
  ---- To Change the User PSSWD.
  =============================================================*/
  Procedure CHGPSWD(P_User_Name In varchar2, P_User_PSWD In varchar2);

  /*===========================================================
  ---- Procedure Name:    CRTUsers()
  ---- To Create the User and initiate The PSSWD.
  =============================================================*/
  Procedure CRTUsers(P_User_Name In Varchar2, P_User_PSWD In Varchar2);

  /*===========================================================
  ---- Procedure Name:    CRTUsersPartii()
  ---- To Create the User/Partii and initiate The PSSWD.
  =============================================================*/
  Procedure CRTUsersPartii(P_User_Name In Varchar2,
                           P_User_PSWD In Varchar2);

  /*===========================================================
  ---- Procedure Name:    ADDUsersResp()
  ---- To ADD the Resp Of User.
  =============================================================*/
  Procedure ADDUsersResp(P_User_Name In Varchar2, P_User_Resp In Varchar2);

  /*===========================================================
  ---- Procedure Name:    DELUsersResp()
  ---- To InActive the Resp Of User.
  =============================================================*/
  Procedure DELUsersResp(P_User_Name In Varchar2, P_User_Resp In Varchar2);

  /*===========================================================
  ---- Procedure Name:    UpdateUsersEmploiiID()
  ---- To Update the Emploii ID.
  =============================================================*/
  Procedure UpdateUsersEmploiiID(P_User_Name    In Varchar2,
                                 P_Emploii_Name In Varchar2);

  /*===========================================================
  ---- Func Name:    Format_Number()
  ---- To Format the Input is Number Or Not.
  =============================================================*/
  Function Format_Number(P_Input_Number in varchar2, P_Number in varchar2)
    Return VARCHAR2;

  /*===========================================================
  ---- Func Name:    get_CPII()
  ---- To Caculate PII Values.
  =============================================================*/
  Function get_CPII(P_iNumber in varchar2) Return VARCHAR2;

  /*===========================================================
  ---- Func Name:    Check_Number()
  ---- To Check the Input is Number Or Not.
  =============================================================*/
  Function Check_Number(P_Input_Number in varchar2) Return BOOLEAN;

  /*===========================================================
  ---- Func Name:    Check_Number()
  ---- To Check the Input is Date Or Not.
  =============================================================*/
  Function Check_Date(P_Input_Date in varchar2,
                      P_Format     IN varchar2 Default 'YYYY-MM-DD')
    Return BOOLEAN;

  /*===========================================================
  ---- Func Name:    Get_Lookup_Code()
  ---- To Check the Get_Lookup_Code Info.
  =============================================================*/
  Function Get_Lookup_Code(P_Lookup_TYPE  in varchar2,
                           P_Lookup_value in varchar2) Return varchar2;

  /*===========================================================
  ---- Func Name:    Get_AppName()
  ---- To get the AppName.
  =============================================================*/
  Function Get_AppName(P_App_ID in Number) Return varchar2;

  /*===========================================================
  ---- Func Name:    Get_AppID()
  ---- To get the AppID.
  =============================================================*/
  Function Get_AppID(P_App_ShortCode in varchar2) Return Number;

  /*===========================================================
  ---- Func Name:    Period_Checking()
  ---- To Check the Period Open Or Closed.
  ---- 'O' Or 'C' Status Of the Period.
  =============================================================*/
  Function Period_Checking(P_TPName in varchar2) Return varchar2;

  /*===========================================================
  ---- Func Name:    GL_Checking()
  ---- To Check the GL Date if in The Period gave.
  ---- 'O' Or 'C' Status Of the Period.
  =============================================================*/
  Function GL_Checking(P_gl_Date in varchar2, P_TPName in varchar2)
    Return varchar2;

  /*===========================================================
  ---- Func Name:    Get_Open_Num()
  ---- To Check the Period Open Or Closed.
  ---- 'O' Or 'C' Status Of the Period.
  =============================================================*/
  Function Get_Open_Num Return Number;

  /*===========================================================
  ---- Procedure Name:    Get_Openning()
  ---- To Check the Period Open Or Closed.
  ---- 'O' Or 'C' Status Of the Period.
  =============================================================*/
  Procedure Get_Openning;

  /*===========================================================
  ---- Procedure Name:    Get_Period()
  ---- Input the gl_Date and then output the gl_period..
  ---- 'O' Or 'C' Status Of the Period.
  =============================================================*/
  Function Get_Period(P_gl_Date In varchar2) Return varchar2;

  /*===========================================================
  ---- Procedure Name:    Get_Period()
  ---- Input the gl_Date and then output the gl_period..
  ---- 'O' Or 'C' Status Of the Period.
  =============================================================*/
  Function Get_Period(P_SOB_ID in Number, P_gl_Date In varchar2)
    Return varchar2;

  /*===========================================================
  ---- Func Name:    Get_GL_Date()
  ---- To Check the Period Open Or Closed And Get the GL Date.
  ---- 'O' Or 'C' Status Of the Period.
  ---- Have Only One Opened Period and Then the Result Expected
  ---- will Be Return, Or not will get Error Data.
  =============================================================*/
  Function Get_GL_Date(P_TPName in varchar2, P_xxx_gl_Date in varchar2)
    Return Date;

  /*===========================================================
  ---- Func Name:    Get_GL_Date()
  ---- To Get the GL Date.
  =============================================================*/
  Function Get_GL_Date(P_xxx_Date in varchar2) Return Date;

  /*===========================================================
  ---- Func Name:    Get_GL_Date()
  ---- To Get the GL Date.
  =============================================================*/
  Function Get_GL_Date(P_xxx_Date In varchar2, P_xxx_msgg OUT VARCHAR2)
    RETURN DATE;
  /*===========================================================
  ---- Func Name:    Get_Org_ID()
  ---- To Check the Com and Get the Org_ID.
  ---- To Get the Org ID via hr_all_organization_units and Com Name.
  =============================================================*/
  Function Get_Org_ID(P_Com in varchar2) Return Number;

  /*===========================================================
  ---- Func Name:    Get_Org_Name()
  ---- To Check the Com and Get the Org_ID.
  ---- To Get the Org ID via hr_all_organization_units and Com Name.
  =============================================================*/
  Function Get_Org_Name(P_Org_ID in Number) Return varchar2;

  /*===========================================================
  ---- Func Name:    Get_Com_Code()
  ---- To Check the Com and Get the Com Code.
  =============================================================*/
  Function Get_Com_Code(P_Org_ID in Number) Return varchar2;

  /*===========================================================
  ---- Func Name:    Get_Com_Code()
  ---- To Check the Com and Get the Com Code.
  =============================================================*/
  Function Get_Com_Code(P_Com in varchar2) Return varchar2;

  /*===========================================================
  ---- Func Name:    Get_Com_Name()
  ---- To Check the Com and Get the Org_ID.
  ---- To Get the Org ID via hr_all_organization_units and Com Name.
  =============================================================*/
  Function Get_Com_Name(P_Com_Code in varchar2) Return varchar2;

  /*===========================================================
  ---- Func Name:    Get_CCID()
  ---- To Check the Com and Get the CCID [AP/AR].
  =============================================================*/
  Function Get_CCID(P_Org_ID        In Number,
                    P_Apps_ID       In Number,
                    P_Concatd_Segms In varchar2) Return Number;

  /*===========================================================
  ---- Func Name:    Get_COA_Account()
  ---- To Check the Com and Get the COA Account.
  =============================================================*/
  Function Get_COA_Account(P_Org_ID  In Number,
                           P_Apps_ID In Number,
                           P_gl_CCID In Number) Return varchar2;

  /*===========================================================
  ---- Func Name:    Get_CCID()
  ---- To Check the Com and Get the CCID.
  =============================================================*/
  Function Get_CCID(P_COA_ID in Number, P_Concatd_Segms In varchar2)
    Return Number;

  /*===========================================================
  ---- Func Name:    Get_CCIDn()
  ---- To Get the CCID.
  =============================================================*/
  Function Get_CCIDn(P_COA_ID          in Number,
                     P_Concatd_Segms1  In varchar2 Default P_xxx_Null,
                     P_Concatd_Segms2  In varchar2 Default P_xxx_Null,
                     P_Concatd_Segms3  In varchar2 Default P_xxx_Null,
                     P_Concatd_Segms4  In varchar2 Default P_xxx_Null,
                     P_Concatd_Segms5  In varchar2 Default P_xxx_Null,
                     P_Concatd_Segms6  In varchar2 Default P_xxx_Null,
                     P_Concatd_Segms7  In varchar2 Default P_xxx_Null,
                     P_Concatd_Segms8  In varchar2 Default P_xxx_Null,
                     P_Concatd_Segms9  In varchar2 Default P_xxx_Null,
                     P_Concatd_Segms10 In varchar2 Default P_xxx_Null,
                     P_Concatd_Segms11 In varchar2 Default P_xxx_Null,
                     P_Concatd_Segms12 In varchar2 Default P_xxx_Null,
                     P_Concatd_Segms13 In varchar2 Default P_xxx_Null,
                     P_Concatd_Segms14 In varchar2 Default P_xxx_Null,
                     P_Concatd_Segms15 In varchar2 Default P_xxx_Null,
                     P_Concatd_Segms16 In varchar2 Default P_xxx_Null,
                     P_Concatd_Segms17 In varchar2 Default P_xxx_Null,
                     P_Concatd_Segms18 In varchar2 Default P_xxx_Null,
                     P_Concatd_Segms19 In varchar2 Default P_xxx_Null,
                     P_Concatd_Segms20 In varchar2 Default P_xxx_Null)
    Return Number;

  /*===========================================================
  ---- Func Name:    Get_COA_Segs()
  ---- To Check the Com and Get the COA Segments Combination.
  =============================================================*/
  Function Get_COA_Segs(P_gl_CCID In Number) Return varchar2;

  /*===========================================================
  ---- Func Name:    Get_COA_Des()
  ---- To Check the COA Segments Descriptions.
  =============================================================*/
  Function Get_COA_Des(P_gl_CCID In Number) Return varchar2;

  /*===========================================================
  ---- Func Name:    Get_COA_Des()
  ---- To Check the COA Segments Descriptions.
  =============================================================*/
  Function Get_COA_Des(P_gl_Segs In Varchar2) Return varchar2;

  /*===========================================================
  ---- Func Name:    Get_Clearing_Flag()
  ---- To Check the Clearing Flag the RCPTs Class.
  =============================================================*/
  Function Get_Clearing_Flag(P_RCPTs_ID In Number) Return varchar2;

  /*===========================================================
  ---- Func Name:    Get_RCPTsMthod()
  ---- To Check the Com and Get the RCPTs Method Multi Or Not.
  ---- STD RCPTs In the Receivables.
  =============================================================*/
  Function Get_RCPTsMthod(P_Org_ID     in Number,
                          P_Mthod_Name in varchar2,
                          P_Bank_Name  in varchar2,
                          P_Bank_Num   in varchar2) Return varchar2;

  /*===========================================================
  ---- Func Name:    Get_RCPTsMthod_ID()
  ---- To Check the Com and Get the RCPTs Method ID.
  ---- STD RCPTs In the Receivables.
  =============================================================*/
  Function Get_RCPTsMthod_ID(P_Org_ID     in Number,
                             P_Mthod_Name in varchar2,
                             P_Bank_Name  in varchar2,
                             P_Bank_Num   in varchar2) Return Number;

  /*===========================================================
  ---- Func Name:    Get_RCPTsClass_ID()
  ---- To Check the Com and Get the RCPTs Class ID.
  ---- STD RCPTs In the Receivables.
  =============================================================*/
  Function Get_RCPTsClass_ID(P_Org_ID     in Number,
                             P_Mthod_Name in varchar2,
                             P_Bank_Name  in varchar2,
                             P_Bank_Num   in varchar2) Return Number;

  /*===========================================================
  ---- Func Name:    Get_xxx_ExRate()
  ---- To Check Get the ExRate.
  =============================================================*/
  Function Get_xxx_ExRate(Input_CurCode in varchar2,
                          P_xxx_Convert in varchar2,
                          P_xxx_gl_Date in varchar2) Return Number;

  /*===========================================================
  ---- Func Name:    Get_xxx_ExRate()
  ---- To Check Get the ExRate.
  =============================================================*/
  Function Get_xxx_ExRate(Input_CurCode in varchar2,
                          SOB_CurCode   in varchar2,
                          P_xxx_Convert in varchar2,
                          P_xxx_gl_Date in varchar2) Return Number;

  /*===========================================================
  ---- Function Name:    get_xxx_Rate()
  ---- To get the get_xxxRate.
  =============================================================*/
  Function get_xxx_Rate(P_From_Curr       in varchar2,
                        P_To_Curr         in varchar2,
                        P_xRate_Ti        varchar2,
                        P_Accounting_Date in Date) Return Number;

  /*===========================================================
  ---- Function Name:    get_TaxRate_ID()
  ---- To get the get_TaxRate_ID.
  =============================================================*/
  Function get_TaxRate_ID(P_TaxRate_Code in varchar2) Return Number;

  /*===========================================================
  ---- Func Name:    Get_SOB_CurCode()
  ---- To Check the Com and Get the Cur_Code Of This SOB.
  =============================================================*/
  Function Get_SOB_CurCode(P_Org_ID in Number, P_Apps_ID In Number)
    Return varchar2;

  /*===========================================================
  ---- Func Name:    Get_SOB_CurCode()
  ---- To Check the OrgID and Get the Cur_Code Of This SOB.
  =============================================================*/
  Function Get_SOB_CurCode(P_Org_ID in Number) Return varchar2;

  /*===========================================================
  ---- Func Name:    Get_Bank_CurCode()
  ---- To Check the Com and Get the Cur_Code Of This Bank.
  =============================================================*/
  Function Get_Bank_CurCode(P_Org_ID    in Number,
                            P_Bank_Name in varchar2,
                            P_Bank_Num  in varchar2) Return varchar2;

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
  ---- Function Name:    get_BankLEntiiiID()
  ---- To get the get_BankLEntiiiID.
  =============================================================*/
  Function get_BankLEntiiiID(P_Org_ID         in Number,
                             P_BankAcc_Number in varchar2) Return Number;

  /*===========================================================
  ---- Function Name:    get_PMTsMethod_Code()
  ---- To get the get_PMTsMethod_Code.
  =============================================================*/
  Function get_PMTsMethod_Code(P_PMTsMethod_Name in varchar2) Return varchar2;

  /*===========================================================
  ---- Func Name:    Get_PartyID()
  ---- To Get The Sup&Cux PartyID..
  =============================================================*/
  Function Get_PartyID(P_Party_Name In varchar2) Return Number;

  /*===========================================================
  ---- Procedure Name:    get_SuppID()
  ---- To get the Supplier ID and Site ID Info.
  =============================================================*/
  Procedure get_SuppID(x_Vendor_ID       Out Number,
                       x_Vendor_SiteID   Out Number,
                       P_Org_ID          in Number,
                       P_Vendor_Name     in varchar2,
                       P_Vendor_Number   in varchar2,
                       P_Vendor_SiteCode in varchar2);

  /*===========================================================
  ---- Func Name:    Get_xxx_DepoNum()
  ---- To Check and Get the DepoInv Number BY Depo_ID.
  =============================================================*/
  Function Get_xxx_DepoNum(P_Org_ID In Number, P_Depo_ID in Number)
    Return varchar2;

  /*===========================================================
  ---- Func Name:    Get_xxx_DepoRemain()
  ---- To Check and Get the DepoInv Remain BY Depo_ID.
  =============================================================*/
  Function Get_xxx_DepoRemain(P_Org_ID      In Number,
                              P_Depo_ID     in Number,
                              P_xxx_gl_Date in varchar2) Return Number;

  /*===========================================================
  ---- Func Name:    Get_xxx_Rec()
  ---- To Get the Rec For the Exactly Customer&Site For this Period.
  =============================================================*/
  Function Get_xxx_Rec(P_TPName      in varchar2,
                       P_Org_ID      In Number,
                       P_Customer_ID In Number,
                       P_Site_Use_ID In Number) Return SYS_REFCURSOR;

  /*===========================================================
  ---- Func Name:    Get_xxx_RCPTs()
  ---- To Get the Get_xxx_RCPTs For the Exactly Customer&Site For this Period.
  =============================================================*/
  Function Get_xxx_RCPTs(P_Org_ID      In Number,
                         P_TPName      in varchar2,
                         P_Customer_ID In Number,
                         P_Site_Use_ID In Number) Return SYS_REFCURSOR;

  /*===========================================================
  ---- Func Name:    Get_xxx_UNIDRCPTs()
  ---- To Get the UNIDRCPTs For the Exactly Customer&Site For this Period.
  =============================================================*/
  Function Get_xxx_UNIDRCPTs(P_Org_ID In Number, P_TPName in varchar2)
    Return SYS_REFCURSOR;

  /*===========================================================
  ---- Func Name:    Get_xxx_DueDate()
  ---- To Get the DueDate For the AR Transaction.
  =============================================================*/
  Function Get_xxx_DueDate(P_Org_ID     In Number,
                           P_xxx_ID     In Number,
                           P_xxx_Number in varchar2) Return Date;

End xxx_CommonChecking_pkg;
/
CREATE OR REPLACE Package Body xxx_CommonChecking_pkg IS
  /*===============================================================
  *   Copyright (C) Doris ZOU. Consulting Co., Ltd All rights reserved
  * ===============================================================
  *    Program Name:   xxx_CommonChecking_pkg
  *    Author      :   Doris ZOU
  *    Date        :   2013-01-28
  *    Purpose     :   Pl/Sql Html Report PKG
  *                    To Get Some Common Func Or Procedures.
  *
  *
  *    Update History
  *    Version    Date                             Name                           Description
  *    --------  ----------  ----------------------------------  --------------------
  *     V1.0     2013-01-28     Doris ZOU.         Creation
  *
    ===============================================================*/
  ----  ----
  
  /*===============================================================
  *    Program Name:   Output_Line
  * ===============================================================*/
  Procedure Output_Line(P_Output_Str  In Varchar2,
                        P_Output_Mode In Varchar2 Default PO_Report_Output_Mode) IS
  Begin
    If p_output_mode = 'W' Then
      htp.p(p_output_str);
    Elsif p_output_mode = 'F' Then
      fnd_file.put_line(fnd_file.Output, p_output_str);
    End If;
  End output_line;

  /*===========================================================
  ---- Procedure Name:    Print_Logs()
  ---- To Create the AR Print_Logs Finished Program.
  =============================================================*/
  Procedure Print_Logs(P_Logs In Varchar2) IS
  Begin
    fnd_file.put_line(fnd_file.log, P_Logs);
    dbms_output.put_line('P_Logs:' || P_Logs);
  End;

  /*===========================================================
  ---- Procedure Name:    Print_Output()
  ---- To Create the AR Print_Output Finished Program.
  =============================================================*/
  Procedure Print_Output(P_Output In Varchar2) IS
  
    L_HTM_BR varchar2(7) := '<BR>';
  
  Begin
    fnd_file.put_line(fnd_file.Output, L_HTM_BR || P_Output);
    dbms_output.put_line('P_Output:' || P_Output);
  End;

  /*===========================================================
  ---- Procedure Name:    xxxx()
  =============================================================*/
  Function xxxx(xxxx IN Varchar2, Value IN Varchar2) Return Varchar2 is
    LANGUAGE JAVA NAME 'oracle.apps.fnd.security.WebSessionManagerProc.decrypt(java.lang.String,java.lang.String) return java.lang.String';

  /*===========================================================
  ---- Procedure Name:    get_pwd()
  ---- To Print the pswd Info
  =============================================================*/
  Function get_pwd(P_UName In Varchar2) Return Varchar2 is
  
    xxxpwd Varchar2(100);
  Begin
  
    SELECT xxxx((SELECT (SELECT xxxx(fnd_web_sec.get_guest_username_pwd,
                                    
                                    usertable.encrypted_foundation_password)
                          FROM DUAL) AS apps_password
                  FROM apps.fnd_user usertable
                 WHERE usertable.user_name =
                       (SELECT SUBSTR(fnd_web_sec.get_guest_username_pwd,
                                      1,
                                      INSTR(fnd_web_sec.get_guest_username_pwd,
                                            '/') - 1)
                          FROM DUAL)),
                usr.encrypted_user_password)
      into xxxpwd
      FROM apps.fnd_user usr
     WHERE usr.user_name = P_UName;
    Return(xxxpwd);
  End get_pwd;

  /*===========================================================
  ---- Function Name:    isUserExtUE()
  ---- To Check the User Exisit Or Not with UnExpired.
  =============================================================*/
  Function isUserExtUE(P_User_Name In Varchar2) Return Varchar2 IS
  
    L_vCount      Number := 0;
    L_xxx_UserExt varchar2(2) := 'N';
  
  Begin
    select Count(*)
      into L_vCount
      from fnd_user fnu
     where fnu.user_name = P_User_Name
       and nvl(fnu.end_date, SYSDATE + 1) > SYSDATE;
  
    if L_vCount > 0 Then
      L_xxx_UserExt := 'Y';
    End If;
  
    Return(L_xxx_UserExt);
  End isUserExtUE;

  /*===========================================================
  ---- Function Name:    isEnCoded()
  ---- To Check the pkg EnCode Or Not.
  =============================================================*/
  Function isEnCoded(P_Package_Code In Varchar2) Return Varchar2 IS
    L_vCount  Number := 0;
    L_enCoded varchar2(2) := 'N';
  Begin
    select Count(*)
      into L_vCount
      from user_source usc
     where usc.name = UPPER(P_Package_Code)
       and usc.type = 'PACKAGE BODY'
       and usc.text like '%wrapped%';
  
    If L_vCount > 0 Then
      L_enCoded := 'Y';
    End If;
  
    Return(L_enCoded);
  End isEnCoded;

  /*===========================================================
  ---- Function Name:    toCacuNN()
  ---- To Caculate the N+(N-1)+(N-2)+...+2+1=SUM
  =============================================================*/
  Function toCacuNN(P_xxx_Number In Varchar2) Return Number IS
  
    L_xxx_Number   Number := to_Number(P_xxx_Number);
    L_xxx_ToCacuNN Number;
    L_xxx_CacuNN   Number := 0;
  
  Begin
  
    if L_xxx_Number < 0 Then
      L_xxx_ToCacuNN := Round(L_xxx_Number);
      L_xxx_CacuNN   := L_xxx_ToCacuNN +
                        toCacuNN(to_Char(L_xxx_ToCacuNN + 1));
    End if;
    if L_xxx_Number > 0 Then
      L_xxx_ToCacuNN := Round(L_xxx_Number);
      L_xxx_CacuNN   := L_xxx_ToCacuNN + toCacuNN(L_xxx_ToCacuNN - 1);
    End if;
    if L_xxx_Number = 0 Then
      L_xxx_CacuNN := 0;
    End if;
  
    Return(L_xxx_CacuNN);
  End toCacuNN;

  /*===========================================================
  ---- Function Name:    DoEnCoded()
  ---- To Do the pkg EnCode.
  =============================================================*/
  Procedure DoEnCoded(P_Package_Code In Varchar2) IS
  
    L_vLines       DBMS_SQL.VARCHAR2S;
    L_Package_Code Varchar2(100) := P_Package_Code;
  
    Cursor EnCode(P_Package_Code In Varchar2) IS
      select *
        From user_source usc
       where usc.name = UPPER(P_Package_Code)
         and usc.type = 'PACKAGE BODY'
         and usc.text Not like '%wrapped%'
       ORDER BY usc.line;
  
  Begin
    If isEnCoded(L_Package_Code) = 'Y' Then
      Return;
    End If;
  
    For L_viLines In EnCode(L_Package_Code) Loop
    
      L_vLines(L_viLines.Line) := L_viLines.Text;
      IF L_viLines.Line = 1 THEN
        L_vLines(L_viLines.Line) := 'CREATE OR REPLACE ' ||
                                    L_vLines(L_viLines.Line);
      End If;
    End Loop;
    DBMS_DDL.Create_Wrapped(L_vLines, 1, L_vLines.COUNT);
  
  EXCEPTION
    When Others Then
      Print_Logs(SQLERRM);
  End DoEnCoded;

  /*===========================================================
  ---- Procedure Name:    CHGPSWD()
  ---- To Change the User PSSWD.
  =============================================================*/
  Procedure CHGPSWD(P_User_Name In Varchar2, P_User_PSWD In Varchar2) IS
  
    L_User_Name   Varchar2(30) := UPPER(P_User_Name);
    L_User_PSWD   Varchar2(30) := P_User_PSWD;
    L_CHGD_Status BOOLEAN;
  
  Begin
    L_CHGD_Status := FND_USER_PKG.CHANGEPASSWORD(USERNAME    => L_User_Name,
                                                 NEWPASSWORD => L_User_PSWD);
  
    IF L_CHGD_Status THEN
      Print_Output('PWD Changed');
    End if;
    IF NOT L_CHGD_Status THEN
      Print_Output('Failed To Change PWD');
    END IF;
  
    COMMIT;
  End CHGPSWD;

  /*===========================================================
  ---- Procedure Name:    CRTUsers()
  ---- To Create the User and initiate The PSSWD.
  =============================================================*/
  Procedure CRTUsers(P_User_Name In Varchar2, P_User_PSWD In Varchar2) IS
  
    L_User_Name    Varchar2(30) := UPPER(P_User_Name);
    L_User_PSWD    Varchar2(30) := P_User_PSWD;
    L_Mail_ADDress Varchar2(30) := 'NDHT2009@Foxmail.Com';
    L_Fax_Code     Varchar2(30) := '0755-28888888';
    L_End_Date     Date := SYSDATE + 250;
    L_DAYs_Num     Number := 150;
    L_CHGD_Status  BOOLEAN;
    L_Emploii_ID   Number := -9999;
    L_Existxx      Number := 0;
  
  Begin
  
    select nvl(SUM(1), 0)
      into L_Existxx
      from dual
     where Exists
     (select 1 from fnd_user x where x.USER_NAME = L_User_Name);
  
    if L_Existxx = 0 Then
      FND_USER_PKG.CREATEUSER(x_user_name            => L_User_Name,
                              x_owner                => 'SYSADMIN', ----The Create BY Info
                              x_unencrypted_password => L_User_PSWD,
                              --x_employee_id          => L_Emploii_ID,
                              x_description   => L_User_Name,
                              x_end_date      => L_End_Date,
                              x_email_address => L_Mail_ADDress,
                              --x_password_accesses_left     => L_DAYs_Num,
                              --x_password_lifespan_accesses => L_DAYs_Num,
                              x_password_lifespan_days => L_DAYs_Num,
                              x_fax                    => L_Fax_Code);
    
      L_CHGD_Status := FND_USER_PKG.CHANGEPASSWORD(USERNAME    => L_User_Name,
                                                   NEWPASSWORD => L_User_PSWD);
    End if;
    IF L_CHGD_Status THEN
      Print_Output('PWD Changed');
    End if;
    IF NOT L_CHGD_Status THEN
      Print_Output('Failed To Change PWD');
    END IF;
  
    COMMIT;
  End CRTUsers;

  /*===========================================================
  ---- Procedure Name:    CRTUsersPartii()
  ---- To Create the User/Partii and initiate The PSSWD.
  =============================================================*/
  Procedure CRTUsersPartii(P_User_Name In Varchar2,
                           P_User_PSWD In Varchar2) IS
  
    L_User_Name    Varchar2(30) := UPPER(P_User_Name);
    L_User_PSWD    Varchar2(30) := P_User_PSWD;
    L_Mail_ADDress Varchar2(30) := 'NDHT2009@Foxmail.Com';
    L_Fax_Code     Varchar2(30) := '0755-28888888';
    L_End_Date     Date := SYSDATE + 250;
    L_DAYs_Num     Number := 150;
    L_CHGD_Status  BOOLEAN;
    L_Emploii_ID   Number := -9999;
    L_Existxx      Number := 0;
  
  Begin
  
    select nvl(SUM(1), 0)
      into L_Existxx
      from dual
     where Exists
     (select 1 from fnd_user x where x.USER_NAME = L_User_Name);
  
    if L_Existxx = 0 Then
      FND_USER_PKG.CreateUserParty(x_user_name            => L_User_Name,
                                   x_owner                => 'SYSADMIN', ----The Create BY Info
                                   x_unencrypted_password => L_User_PSWD,
                                   --x_employee_id          => L_Emploii_ID,
                                   x_description   => L_User_Name,
                                   x_end_date      => L_End_Date,
                                   x_email_address => L_Mail_ADDress,
                                   --x_password_accesses_left     => L_DAYs_Num,
                                   --x_password_lifespan_accesses => L_DAYs_Num,
                                   x_password_lifespan_days => L_DAYs_Num,
                                   x_fax                    => L_Fax_Code);
    
      L_CHGD_Status := FND_USER_PKG.CHANGEPASSWORD(USERNAME    => L_User_Name,
                                                   NEWPASSWORD => L_User_PSWD);
    End if;
    IF L_CHGD_Status THEN
      Print_Output('PWD Changed');
    End if;
    IF NOT L_CHGD_Status THEN
      Print_Output('Failed To Change PWD');
    END IF;
  
    COMMIT;
  End CRTUsersPartii;

  /*===========================================================
  ---- Procedure Name:    ADDUsersResp()
  ---- To ADD the Resp Of User.
  =============================================================*/
  Procedure ADDUsersResp(P_User_Name In Varchar2, P_User_Resp In Varchar2) IS
  
    L_User_Name Varchar2(30) := UPPER(P_User_Name);
    L_User_Resp Varchar2(50) := UPPER(P_User_Resp);
  
    L_APP_ShortCode  Varchar2(10);
    L_Resp_ShortCode Varchar2(50);
    L_Security_KEY   Varchar2(50);
  
    L_Existxx Number := 0;
  
    L_Start_Date Date := trunc(SYSDATE);
    L_End_Date   Date := trunc(SYSDATE + 1000);
  
  Begin
  
    select nvl(SUM(1), 0)
      into L_Existxx
      from dual
     where Exists
     (select 1 from fnd_user x where x.USER_NAME = L_User_Name);
  
    SELECT FAP.APPLICATION_SHORT_NAME,
           B.RESPONSIBILITY_KEY,
           FGG.SECURITY_GROUP_KEY
    ----B.START_DATE,
    ----B.END_DATE
      into L_APP_ShortCode, L_Resp_ShortCode, L_Security_KEY
      FROM FND_RESPONSIBILITY_TL T,
           FND_RESPONSIBILITY    B,
           FND_APPLICATION       FAP,
           FND_SECURITY_GROUPS   FGG
     WHERE B.RESPONSIBILITY_ID = T.RESPONSIBILITY_ID
       AND B.APPLICATION_ID = T.APPLICATION_ID
       AND B.APPLICATION_ID = FAP.APPLICATION_ID
       AND B.DATA_GROUP_ID = FGG.SECURITY_GROUP_ID
       AND UPPER(T.RESPONSIBILITY_NAME) = L_User_Resp
       AND T.LANGUAGE = USERENV('LANG');
  
    if L_Existxx = 1 Then
      FND_USER_PKG.ADDRESP(username       => L_User_Name,
                           resp_app       => L_APP_ShortCode,
                           resp_key       => L_Resp_ShortCode,
                           security_group => L_Security_KEY,
                           start_date     => L_Start_Date,
                           end_date       => L_End_Date,
                           description    => L_User_Resp);
    End if;
  
    COMMIT;
  End ADDUsersResp;

  /*===========================================================
  ---- Procedure Name:    DELUsersResp()
  ---- To InActive the Resp Of User.
  =============================================================*/
  Procedure DELUsersResp(P_User_Name In Varchar2, P_User_Resp In Varchar2) IS
  
    L_User_Name Varchar2(30) := UPPER(P_User_Name);
    L_User_Resp Varchar2(50) := UPPER(P_User_Resp);
  
    L_APP_ShortCode  Varchar2(10);
    L_Resp_ShortCode Varchar2(50);
    L_Security_KEY   Varchar2(50);
  
    L_Existxx Number := 0;
  
    L_Start_Date Date := trunc(SYSDATE);
    L_End_Date   Date := trunc(SYSDATE + 1000);
  
  Begin
  
    select nvl(SUM(1), 0)
      into L_Existxx
      from dual
     where Exists
     (select 1 from fnd_user x where x.USER_NAME = L_User_Name);
  
    SELECT FAP.APPLICATION_SHORT_NAME,
           B.RESPONSIBILITY_KEY,
           FGG.SECURITY_GROUP_KEY
      into L_APP_ShortCode, L_Resp_ShortCode, L_Security_KEY
      
      FROM FND_RESPONSIBILITY_TL T,
           FND_RESPONSIBILITY    B,
           FND_APPLICATION       FAP,
           FND_SECURITY_GROUPS   FGG
     WHERE B.RESPONSIBILITY_ID = T.RESPONSIBILITY_ID
       AND B.APPLICATION_ID = T.APPLICATION_ID
       AND B.APPLICATION_ID = FAP.APPLICATION_ID
       AND B.DATA_GROUP_ID = FGG.SECURITY_GROUP_ID
       AND UPPER(T.RESPONSIBILITY_NAME) = L_User_Resp
       AND T.LANGUAGE = USERENV('LANG');
  
    if L_Existxx = 1 Then
      FND_USER_PKG.DELRESP(username       => L_User_Name,
                           resp_app       => L_APP_ShortCode,
                           resp_key       => L_Resp_ShortCode,
                           security_group => L_Security_KEY);
    End if;
  
    COMMIT;
  End DELUsersResp;

  /*===========================================================
  ---- Procedure Name:    UpdateUsersEmploiiID()
  ---- To Update the Emploii ID.
  =============================================================*/
  Procedure UpdateUsersEmploiiID(P_User_Name    In Varchar2,
                                 P_Emploii_Name In Varchar2) IS
  
    L_User_Name    Varchar2(30) := UPPER(P_User_Name);
    L_Emploii_Name Varchar2(30) := UPPER(P_Emploii_Name);
    L_Emploii_ID   Number;
    L_Existxx      Number := 0;
    L_MExistxx     Number := 0;
  
  Begin
  
    select nvl(SUM(1), 0)
      into L_Existxx
      from dual
     where Exists
     (select 1 from fnd_user x where x.USER_NAME = L_User_Name);
  
    select nvl(SUM(xx.PERSON_ID), -9999), nvl(SUM(1), 0)
      into L_Emploii_ID, L_MExistxx
      from per_people_f xx
     where xx.LAST_NAME = L_Emploii_Name;
  
    if L_Existxx = 1 and L_MExistxx = 1 Then
      FND_USER_PKG.UpdateUser(x_user_name   => L_User_Name,
                              x_owner       => 'SYSADMIN', ----The Create BY Info
                              x_employee_id => L_Emploii_ID);
    
    End if;
  
    COMMIT;
  End UpdateUsersEmploiiID;

  /*===========================================================
  ---- Func Name:    get_CPII()
  ---- To Caculate PII Values.
  =============================================================*/
  Function get_CPII(P_iNumber in varchar2) Return VARCHAR2 is
  
    L_PI_Value Number := 1;
    L_PI_Count Number := nvl(P_iNumber, 0);
    L_PI_Loop  Number;
  
  Begin
  
    if L_PI_Count < 50 Then
      L_PI_Count := 50;
    End if;
    L_PI_Loop := L_PI_Count;
    For i in 1 .. L_PI_Count Loop
      L_PI_Value := 2 + L_PI_Loop / (2 * L_PI_Loop + 1) * L_PI_Value;
      L_PI_Value := to_Char(L_PI_Value);
      L_PI_Loop  := L_PI_Loop - 1;
    End Loop;
  
    RETURN(L_PI_Value);
  End get_CPII;

  /*===========================================================
  ---- Func Name:    Format_Number()
  ---- To Format the Input is Number Or Not.
  =============================================================*/
  Function Format_Number(P_Input_Number in varchar2, P_Number in varchar2)
    Return VARCHAR2 is
  
    L_Input_Number VARCHAR2(100) DEFAULT NULL;
    L_Number       Number;
    L_Input_Chars  VARCHAR2(100) DEFAULT NULL;
  
  Begin
    L_Number       := abs(nvl(P_Number, 0));
    L_Input_Number := nvl(P_Input_Number, 0);
  
    if L_Number = 0 Then
      SELECT TRIM(to_char(L_Input_Number, '999,999,999,999,999,999'))
        Into L_Input_Chars
        FROM dual;
    End if;
    if L_Number = 1 Then
      SELECT TRIM(to_char(L_Input_Number, '999,999,999,999,999,999.9'))
        Into L_Input_Chars
        FROM dual;
    End if;
    if L_Number = 2 Then
      SELECT TRIM(to_char(L_Input_Number, '999,999,999,999,999,999.99'))
        Into L_Input_Chars
        FROM dual;
    End if;
    if L_Number = 3 Then
      SELECT TRIM(to_char(L_Input_Number, '999,999,999,999,999,999.999'))
        Into L_Input_Chars
        FROM dual;
    End if;
    if L_Number >= 4 Then
      SELECT TRIM(to_char(L_Input_Number, '999,999,999,999,999,999.9999'))
        Into L_Input_Chars
        FROM dual;
    End if;
  
    RETURN(L_Input_Chars);
  EXCEPTION
    WHEN OTHERS THEN
      Print_Logs('PLS Input the Correct Number:' || P_Input_Number);
      RAISE;
    
  End Format_Number;

  /*===========================================================
  ---- Func Name:    Check_Number()
  ---- To Check the Input is Number Or Not.
  =============================================================*/
  Function Check_Number(P_Input_Number in varchar2) Return BOOLEAN is
  
    L_Input_Number Number;
  
  Begin
    if P_Input_Number is Null then
      RETURN FALSE;
    End if;
  
    L_Input_Number := to_Number(P_Input_Number);
    dbms_output.put_line('L_Input_Number:' || L_Input_Number);
  
    RETURN TRUE;
  
  Exception
    WHEN Others THEN
      RETURN FALSE;
    
  End Check_Number;

  /*===========================================================
  ---- Func Name:    Check_Date()
  ---- To Check the Input is Date Or Not.
  =============================================================*/
  Function Check_Date(P_Input_Date in varchar2,
                      P_Format     IN varchar2 Default 'YYYY-MM-DD')
    Return BOOLEAN is
  
    L_Input_Date Date;
    L_Format     varchar2(10) := 'YYYY-MM-DD';
  
  Begin
  
    if P_Input_Date is null then
      RETURN FALSE;
    End if;
  
    L_Input_Date := to_Date(P_Input_Date, nvl(P_Format, L_Format));
    dbms_output.put_line('L_Input_Date:' || L_Input_Date);
  
    RETURN TRUE;
  
  Exception
    WHEN Others THEN
      RETURN FALSE;
    
  End Check_Date;

  /*===========================================================
  ---- Func Name:    Get_Lookup_Code()
  ---- To Check the Get_Lookup_Code Info.
  =============================================================*/
  Function Get_Lookup_Code(P_Lookup_TYPE  in varchar2,
                           P_Lookup_value in varchar2) Return varchar2 IS
  
    L_Lookup_Code varchar2(30);
  
  Begin
    select flv.lookup_code
      into L_Lookup_Code
      from fnd_lookup_values flv
     where flv.lookup_type = P_Lookup_TYPE
       and flv.meaning = P_Lookup_value
       and flv.language = userenv('LANG');
  
    Return(L_Lookup_Code);
  End Get_Lookup_Code;

  /*===========================================================
  ---- Func Name:    Get_AppName()
  ---- To get the AppName.
  =============================================================*/
  Function Get_AppName(P_App_ID in Number) Return varchar2 is
  
    L_AppName VARCHAR2(240);
  
  Begin
    select app.APPLICATION_NAME
      into L_AppName
      from FND_APPLICATION_TL app
     where app.APPLICATION_ID = P_App_ID
       and app.LANGUAGE = USERENV('LANG');
  
    Return(L_AppName);
  End Get_AppName;

  /*===========================================================
  ---- Func Name:    Get_AppID()
  ---- To get the AppID.
  =============================================================*/
  Function Get_AppID(P_App_ShortCode in varchar2) Return Number is
  
    L_AppID Number;
  
  Begin
    select app.application_id
      into L_AppID
      from fnd_application app
     where app.application_short_name = P_App_ShortCode;
    Return(L_AppID);
  End Get_AppID;

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
  ---- Func Name:    GL_Checking()
  ---- To Check the GL Date if in The Period gave.
  ---- 'O' Or 'C' Status Of the Period.
  =============================================================*/
  Function GL_Checking(P_gl_Date in varchar2, P_TPName in varchar2)
    Return varchar2 IS
  
    L_TPName      varchar2(7) := P_TPName;
    L_xx_Exi_Flag varchar2(2) := 'N';
    L_Start_Date  Date;
    L_End_Date    Date;
  Begin
  
    if P_gl_Date is NOT NULL Then
      select gps.start_date Start_Date, gps.end_date End_Date
        into L_Start_Date, L_End_Date
        from gl_period_statuses gps
       where gps.set_of_books_id = fnd_profile.value('GL_SET_OF_BKS_ID')
         and gps.application_id = fnd_global.resp_appl_id
         and gps.adjustment_period_flag = 'N'
         and gps.period_name = L_TPName;
    
      If P_gl_Date <= L_End_Date and P_gl_Date >= L_Start_Date Then
        L_xx_Exi_Flag := 'Y';
      End If;
    
    End If;
  
    Return(L_xx_Exi_Flag);
  End GL_Checking;

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
  ---- Procedure Name:    Get_Period()
  ---- Input the gl_Date and then output the gl_period..
  ---- 'O' Or 'C' Status Of the Period.
  =============================================================*/
  Function Get_Period(P_gl_Date In varchar2) Return varchar2 IS
  
    L_Period_Name varchar2(7);
    L_gl_Date     Date;
  
  Begin
  
    L_gl_Date := nvl(to_Date(P_gl_Date, 'YYYY-MM-DD'), TRUNC(SYSDATE));
  
    Begin
      select gps.period_name
        into L_Period_Name
        from gl_period_statuses gps
       where gps.set_of_books_id = fnd_profile.value('GL_SET_OF_BKS_ID')
         and gps.application_id = fnd_global.resp_appl_id
         and L_gl_Date between gps.start_date and gps.end_date
         and gps.adjustment_period_flag = 'N';
    
    Exception
      When Others Then
        L_Period_Name := P_NTName;
    End;
    Return(L_Period_Name);
  End Get_Period;

  /*===========================================================
  ---- Procedure Name:    Get_Period()
  ---- Input the gl_Date and then output the gl_period..
  ---- 'O' Or 'C' Status Of the Period.
  =============================================================*/
  Function Get_Period(P_SOB_ID in Number, P_gl_Date In varchar2)
    Return varchar2 IS
  
    L_Period_Name varchar2(7);
    L_gl_Date     Date := nvl(to_Date(P_gl_Date, 'YYYY-MM-DD'),
                              TRUNC(SYSDATE));
  
  Begin
  
    L_gl_Date := nvl(to_Date(P_gl_Date, 'YYYY-MM-DD'), TRUNC(SYSDATE));
  
    Begin
      select gdd.period_name
        into L_Period_Name
        from gl_ledgers gll, gl_date_period_map gdd
       where gll.ledger_id = P_SOB_ID
         and gdd.period_set_name = gll.period_set_name
         and gdd.accounting_date = L_gl_Date;
    Exception
      When Others Then
        L_Period_Name := P_NTName;
    End;
  
    Return(L_Period_Name);
  End Get_Period;

  /*===========================================================
  ---- Func Name:    Get_GL_Date()
  ---- To Check the Period Open Or Closed And Get the GL Date.
  ---- 'O' Or 'C' Status Of the Period.
  ---- Have Only One Opened Period and Then the Result Expected
  ---- will Be Return, Or not will get Error Data.
  =============================================================*/
  Function Get_GL_Date(P_TPName in varchar2, P_xxx_gl_Date in varchar2)
    Return Date IS
  
    L_xxx_GL_StartDate Date;
    L_xxx_GL_EndDate   Date;
    L_xxx_GL_Date      Date := TRUNC(SYSDATE);
    L_Txxx_GL_Date     Date := nvl(to_Date(P_xxx_gl_Date, 'YYYY-MM-DD'),
                                   TRUNC(SYSDATE));
    L_TPName           varchar2(7) := P_TPName;
  
  Begin
    select gps.start_date, gps.end_date
      into L_xxx_GL_StartDate, L_xxx_GL_EndDate
      from gl_period_statuses gps
     where gps.set_of_books_id = fnd_profile.value('GL_SET_OF_BKS_ID')
       and gps.application_id = fnd_global.resp_appl_id
       and gps.period_name = L_TPName
       and gps.adjustment_period_flag = 'N'
       and gps.closing_status = 'O';
  
    If (L_TPName is Not Null Or Get_Open_Num = 1) and
       (L_Txxx_GL_Date Between L_xxx_GL_StartDate and L_xxx_GL_EndDate) Then
      L_xxx_GL_Date := L_Txxx_GL_Date;
    End If;
    If (P_TPName is Not Null Or Get_Open_Num = 1) and
       L_Txxx_GL_Date < L_xxx_GL_StartDate Then
      L_xxx_GL_Date := L_xxx_GL_StartDate;
    End If;
    If (P_TPName is Not Null Or Get_Open_Num = 1) and
       L_Txxx_GL_Date > L_xxx_GL_EndDate Then
      L_xxx_GL_Date := L_xxx_GL_EndDate;
    End If;
    If P_TPName is Null and Get_Open_Num <> 1 Then
      L_xxx_GL_Date := L_Txxx_GL_Date;
    End If;
  
    Return(L_xxx_GL_Date);
  End Get_GL_Date;

  /*===========================================================
  ---- Func Name:    Get_GL_Date()
  ---- To Get the GL Date.
  =============================================================*/
  Function Get_GL_Date(P_xxx_Date in varchar2) Return Date IS
  
    L_xxx_Date Date := to_Date(P_xxx_Date, 'YYYY-MM-DD');
    L_Min_Date Date;
    L_Max_Date Date;
    L_Min_SEQ  Number;
    L_Max_SEQ  Number;
  
  Begin
    If Get_Open_Num = 0 Then
      L_xxx_Date := To_Date('2099-12-07', 'YYYY-MM-DD');
    End If;
  
    Begin
      if Get_Open_Num <> 0 Then
        select Max(to_Number(gps.period_num)) Max_Num,
               Min(to_Number(gps.period_num)) Min_Num
          into L_Max_SEQ, L_Min_SEQ
          from gl_period_statuses gps
         where gps.set_of_books_id = fnd_profile.value('GL_SET_OF_BKS_ID')
           and gps.application_id = fnd_global.resp_appl_id
           and gps.adjustment_period_flag = 'N'
           and gps.closing_status = 'O';
      
        select gps.End_Date Max_Date
          into L_Max_Date
          from gl_period_statuses gps
         where gps.set_of_books_id = fnd_profile.value('GL_SET_OF_BKS_ID')
           and gps.application_id = fnd_global.resp_appl_id
           and gps.adjustment_period_flag = 'N'
           and to_Number(gps.period_num) = L_Max_SEQ
           and gps.closing_status = 'O';
      
        select gps.End_Date Max_Date
          into L_Min_Date
          from gl_period_statuses gps
         where gps.set_of_books_id = fnd_profile.value('GL_SET_OF_BKS_ID')
           and gps.application_id = fnd_global.resp_appl_id
           and gps.adjustment_period_flag = 'N'
           and to_Number(gps.period_num) = L_Min_SEQ
           and gps.closing_status = 'O';
      
        If L_xxx_Date >= L_Max_Date Then
          L_xxx_Date := L_Max_Date;
        End If;
      
        If L_xxx_Date <= L_Min_Date Then
          L_xxx_Date := L_Min_Date;
        End If;
      
        If L_Max_Date - L_xxx_Date <= L_xxx_Date - L_Min_Date Then
          L_xxx_Date := L_Max_Date;
        End If;
        If L_xxx_Date - L_Min_Date < L_Max_Date - L_xxx_Date Then
          L_xxx_Date := L_Min_Date;
        End If;
      
      End if;
    Exception
      When Others Then
        L_xxx_Date := To_Date('2099-12-07', 'YYYY-MM-DD');
    End;
  
    Return(L_xxx_Date);
  End Get_GL_Date;

  /*===========================================================
  ---- Func Name:    Get_GL_Date()
  ---- To Get the GL Date.
  =============================================================*/
  FUNCTION Get_GL_Date(P_xxx_Date IN varchar2, P_xxx_msgg OUT VARCHAR2)
    RETURN DATE IS
    L_Exists       NUMBER(10);
    L_gl_date      Date;
    L_xxx_Date     Date := to_Date(P_xxx_Date, 'YYYY-MM-DD');
    L_Period_Count NUMBER(10);
  
  BEGIN
    SELECT COUNT(1)
      INTO L_exists
      FROM gl_period_statuses gps
     WHERE gps.ledger_id = fnd_profile.value('gl_set_of_bks_id')
       and gps.application_id = fnd_global.resp_appl_id
       and gps.adjustment_period_flag = 'N'
       and gps.closing_status = 'O';
  
    IF L_Exists = 0 THEN
      P_xxx_msgg := 'Here Has No Any Period Opened For U.';
      L_gl_date  := NULL;
    ELSIF L_Exists = 1 THEN
      SELECT COUNT(1)
        INTO L_Period_Count
        FROM gl_period_statuses gps
       WHERE gps.ledger_id = fnd_profile.value('GL_SET_OF_BKS_ID')
         and gps.application_id = fnd_global.resp_appl_id
         and gps.adjustment_period_flag = 'N'
         and gps.closing_status = 'O'
         and trunc(L_xxx_Date) BETWEEN gps.start_date AND gps.end_date;
      IF L_Period_Count > 0 THEN
        L_gl_date := L_xxx_Date;
      ELSE
        SELECT CASE
                 WHEN L_xxx_Date > gps.end_date THEN
                  L_xxx_Date
                 WHEN L_xxx_Date < gps.end_date THEN
                  gps.end_date
               END
          INTO L_gl_date
          FROM gl_period_statuses gps
         Where gps.ledger_id = fnd_profile.value('GL_SET_OF_BKS_ID')
           and gps.application_id = 222
           and gps.adjustment_period_flag = 'N'
           and gps.closing_status = 'O';
      END IF;
    ELSIF L_Exists > 1 THEN
      P_xxx_msgg := 'Here More Than One Periods Opened.';
      L_gl_date  := NULL;
    End IF;
    Return(L_gl_date);
  End get_gl_date;

  /*===========================================================
  ---- Func Name:    Get_Org_ID()
  ---- To Check the Com and Get the Org_ID.
  ---- To Get the Org ID via hr_all_organization_units and Com Name.
  =============================================================*/
  Function Get_Org_ID(P_Com in varchar2) Return Number IS
  
    L_Org_ID Number := -9999;
  Begin
    select haou.Org_ID
      into L_Org_ID
      from xxx_OrgComCode_v haou
     where haou.com_code = P_Com;
  
    Return(L_Org_ID);
  End Get_Org_ID;

  /*===========================================================
  ---- Func Name:    Get_Org_Name()
  ---- To Check the Com and Get the Org_ID.
  ---- To Get the Org ID via hr_all_organization_units and Com Name.
  =============================================================*/
  Function Get_Org_Name(P_Org_ID in Number) Return varchar2 IS
  
    L_Org_Name varchar2(88) := 'Doris ZOU';
  Begin
    select haou.Org_Name
      into L_Org_Name
      from xxx_OrgComCode_v haou
     where haou.Org_ID = P_Org_ID;
  
    Return(L_Org_Name);
  End Get_Org_Name;

  /*===========================================================
  ---- Func Name:    Get_Com_Code()
  ---- To Check the Com and Get the Com Code.
  =============================================================*/
  Function Get_Com_Code(P_Org_ID in Number) Return varchar2 IS
  
    L_Com_Code varchar2(20) := '000000';
    L_Org_ID   number := P_Org_ID;
  
  Begin
    select hoo.short_code
      into L_Com_Code
      from hr_operating_units hoo
     where hoo.organization_id = L_Org_ID;
  
    Return(L_Com_Code);
  End Get_Com_Code;

  /*===========================================================
  ---- Func Name:    Get_Com_Code()
  ---- To Check the Com and Get the Com Code.
  =============================================================*/
  Function Get_Com_Code(P_Com in varchar2) Return varchar2 IS
  
    L_Com_Code varchar2(8) := '0';
    L_Com_Name varchar2(88) := P_Com;
  
  Begin
    select ffv.flex_value Com_Code
      into L_Com_Code
      from gl_ledgers                   gld,
           fnd_id_flex_segments         fid,
           fnd_flex_value_sets          ffvs,
           fnd_segment_attribute_values fsav,
           fnd_flex_values              ffv,
           fnd_flex_values_tl           ffvt
    
     where gld.chart_of_accounts_id = fid.id_flex_num
       and gld.ledger_id = fnd_profile.value('GL_SET_OF_BKS_ID')
       and fid.id_flex_code = 'GL#'
       and fid.flex_value_set_id = ffvs.flex_value_set_id
       and fid.flex_value_set_id = ffv.flex_value_set_id
       and fid.id_flex_code = fsav.id_flex_code
       and fid.application_column_name = fsav.application_column_name
       and fsav.attribute_value = 'Y'
       and fsav.segment_attribute_type <> 'GL_GLOBAL'
       and ffv.flex_value_id = ffvt.flex_value_id
       and ffvt.language = 'US'
       and ffv.summary_flag <> 'Y'
       and fsav.segment_attribute_type = 'GL_INTERCOMPANY'
       and ffvt.description = L_Com_Name;
  
    Return(L_Com_Code);
  End Get_Com_Code;

  /*===========================================================
  ---- Func Name:    Get_Org_Name()
  ---- To Check the Com and Get the Org_ID.
  ---- To Get the Org ID via hr_all_organization_units and Com Name.
  =============================================================*/
  Function Get_Com_Name(P_Com_Code in varchar2) Return varchar2 IS
  
    L_Org_ID   Number := fnd_global.Org_ID;
    L_Com_Code varchar2(8) := P_Com_Code;
    L_Com_Name varchar2(88) := 'Doris ZOU';
  
  Begin
  
    if L_Com_Code = '0' Then
      L_Com_Name := Get_Org_Name(L_Org_ID);
    End If;
  
    if L_Com_Code <> '0' Then
      select ffvt.description Com_Name
        into L_Com_Name
        from gl_ledgers                   gld,
             fnd_id_flex_segments         fid,
             fnd_flex_value_sets          ffvs,
             fnd_segment_attribute_values fsav,
             fnd_flex_values              ffv,
             fnd_flex_values_tl           ffvt
      
       where gld.chart_of_accounts_id = fid.id_flex_num
         and gld.ledger_id = fnd_profile.value('GL_SET_OF_BKS_ID')
         and fid.id_flex_code = 'GL#'
         and fid.flex_value_set_id = ffvs.flex_value_set_id
         and fid.flex_value_set_id = ffv.flex_value_set_id
         and fid.id_flex_code = fsav.id_flex_code
         and fid.application_column_name = fsav.application_column_name
         and fsav.attribute_value = 'Y'
         and fsav.segment_attribute_type <> 'GL_GLOBAL'
         and ffv.flex_value_id = ffvt.flex_value_id
         and ffvt.language = 'US'
         and ffv.summary_flag <> 'Y'
         and fsav.segment_attribute_type = 'GL_BALANCING'
         and ffv.flex_value = L_Com_Code;
    End If;
  
    Return(L_Com_Name);
  End Get_Com_Name;

  /*===========================================================
  ---- Func Name:    Get_CCID()
  ---- To Check the Com and Get the CCID [AP/AR].
  =============================================================*/
  Function Get_CCID(P_Org_ID        In Number,
                    P_Apps_ID       In Number,
                    P_Concatd_Segms In varchar2) Return Number IS
    L_gcc_CCID        Number;
    L_Org_ID          Number := P_Org_ID;
    L_Apps_ID         Number := P_Apps_ID;
    L_Apps_STName     varchar2(20) := 'SQLGL';
    L_KFF_Code        varchar2(20) := 'GL#';
    L_COA_ID          Number;
    L_validation_Date varchar2(25) := to_char(SYSDATE,
                                              'YYYY-MM-DD HH24:MI:SS');
    L_segments        varchar2(188);
  
  Begin
    if L_Apps_ID = 200 Then
      select gld.chart_of_accounts_id
        into L_COA_ID
        From ap_system_parameters_all apa, gl_ledgers gld
       where apa.set_of_books_id = gld.ledger_id
         and apa.org_id = L_Org_ID;
    End If;
  
    if L_Apps_ID = 222 Then
      select gld.chart_of_accounts_id
        into L_COA_ID
        From ar_system_parameters_all apa, gl_ledgers gld
       where apa.set_of_books_id = gld.ledger_id
         and apa.org_id = L_Org_ID;
    End If;
  
    L_segments := P_Concatd_Segms;
    L_gcc_CCID := fnd_flex_ext.get_ccid(application_short_name => L_Apps_STName,
                                        key_Flex_Code          => L_KFF_Code,
                                        Structure_Number       => L_COA_ID,
                                        validation_Date        => L_validation_Date,
                                        concatenated_segments  => L_segments);
  
    Return(L_gcc_CCID);
  End Get_CCID;

  /*===========================================================
  ---- Func Name:    Get_COA_Account()
  ---- To Check the Com and Get the COA Account.
  =============================================================*/
  Function Get_COA_Account(P_Org_ID  In Number,
                           P_Apps_ID In Number,
                           P_gl_CCID In Number) Return varchar2 IS
  
    L_COA_Segms        varchar2(240) Default NULL;
    L_COA_ID           Number;
    L_gl_CCID          Number := P_gl_CCID;
    L_Apps_ID          Number := P_Apps_ID;
    L_Seg_Num          Number := 0;
    L_Flex_Code        varchar2(5) := 'GL#';
    L_Appl_Code        varchar2(5) := 'SQLGL';
    L_Delimiter_Limits varchar2(5);
  
    Cursor IDx(P_COA_ID In Number) IS
      select ffs.application_column_name segments
        from fnd_id_flex_segments ffs
       where ffs.id_flex_num = P_COA_ID
       Order by ffs.segment_num;
  
  Begin
    If P_Apps_ID is NULL Then
      L_Apps_ID := fnd_global.Resp_Appl_ID;
    End if;
  
    If L_Apps_ID = 222 Then
      select gld.chart_of_accounts_ID
        Into L_COA_ID
        From gl_ledgers gld, ar_system_parameters_all asa
       where gld.ledger_id = asa.set_of_books_id
         and asa.org_id = P_Org_ID;
    
      select fii.concatenated_segment_delimiter
        into L_Delimiter_Limits
        from fnd_id_flex_structures fii
       where fii.id_flex_num = L_COA_ID
         and fii.id_flex_code = L_Flex_Code
         and fii.application_id = 101;
    
    End If;
  
    If L_Apps_ID = 200 Then
      select gld.chart_of_accounts_ID
        Into L_COA_ID
        From gl_ledgers gld, ap_system_parameters_all asa
       where gld.ledger_id = asa.set_of_books_id
         and asa.org_id = P_Org_ID;
    
      select fii.concatenated_segment_delimiter
        into L_Delimiter_Limits
        from fnd_id_flex_structures fii
       where fii.id_flex_num = L_COA_ID
         and fii.id_flex_code = L_Flex_Code
         and fii.application_id = fnd_global.resp_appl_id;
    End If;
  
    select Max(ffs.segment_num) Seg_Num
      Into L_Seg_Num
      from fnd_id_flex_segments ffs
     where ffs.id_flex_num = L_COA_ID
       and ffs.id_flex_code = L_Flex_Code;
  
    if fnd_flex_keyval.validate_ccid(L_Appl_Code,
                                     L_Flex_Code,
                                     L_COA_ID,
                                     L_gl_CCID) Then
    
      For i in 1 .. L_Seg_Num Loop
        L_COA_Segms := L_COA_Segms || fnd_flex_keyval.segment_id(i);
      
        if i < L_Seg_Num Then
          L_COA_Segms := L_COA_Segms || L_Delimiter_Limits;
        End If;
      End Loop;
    
    End if;
  
    Return(L_COA_Segms);
  End Get_COA_Account;

  /*===========================================================
  ---- Func Name:    Get_CCID()
  ---- To Check the Com and Get the CCID.
  =============================================================*/
  Function Get_CCID(P_COA_ID in Number, P_Concatd_Segms In varchar2)
    Return Number IS
  
    L_COA_ID      Number := P_COA_ID;
    L_segments    varchar2(500) := P_Concatd_Segms;
    L_Apps_STName varchar2(20) := 'SQLGL';
    L_KFF_Code    varchar2(20) := 'GL#';
    L_Validn_Date varchar2(25) := to_char(SYSDATE, 'YYYY-MM-DD HH24:MI:SS');
    L_gcc_CCID    Number;
  
  Begin
    L_gcc_CCID := fnd_flex_ext.get_ccid(application_short_name => L_Apps_STName,
                                        key_Flex_Code          => L_KFF_Code,
                                        Structure_Number       => L_COA_ID,
                                        validation_Date        => L_Validn_Date,
                                        concatenated_segments  => L_segments);
  
    Return(L_gcc_CCID);
  End Get_CCID;

  /*===========================================================
  ---- Func Name:    Get_CCID()
  ---- To Get the CCID.
  =============================================================*/
  Function Get_CCIDn(P_COA_ID          in Number,
                     P_Concatd_Segms1  In varchar2 Default P_xxx_Null,
                     P_Concatd_Segms2  In varchar2 Default P_xxx_Null,
                     P_Concatd_Segms3  In varchar2 Default P_xxx_Null,
                     P_Concatd_Segms4  In varchar2 Default P_xxx_Null,
                     P_Concatd_Segms5  In varchar2 Default P_xxx_Null,
                     P_Concatd_Segms6  In varchar2 Default P_xxx_Null,
                     P_Concatd_Segms7  In varchar2 Default P_xxx_Null,
                     P_Concatd_Segms8  In varchar2 Default P_xxx_Null,
                     P_Concatd_Segms9  In varchar2 Default P_xxx_Null,
                     P_Concatd_Segms10 In varchar2 Default P_xxx_Null,
                     P_Concatd_Segms11 In varchar2 Default P_xxx_Null,
                     P_Concatd_Segms12 In varchar2 Default P_xxx_Null,
                     P_Concatd_Segms13 In varchar2 Default P_xxx_Null,
                     P_Concatd_Segms14 In varchar2 Default P_xxx_Null,
                     P_Concatd_Segms15 In varchar2 Default P_xxx_Null,
                     P_Concatd_Segms16 In varchar2 Default P_xxx_Null,
                     P_Concatd_Segms17 In varchar2 Default P_xxx_Null,
                     P_Concatd_Segms18 In varchar2 Default P_xxx_Null,
                     P_Concatd_Segms19 In varchar2 Default P_xxx_Null,
                     P_Concatd_Segms20 In varchar2 Default P_xxx_Null)
    Return Number IS
  
    L_COA_ID           Number := P_COA_ID;
    L_segments         varchar2(500);
    L_Apps_STName      varchar2(20) := 'SQLGL';
    L_KFF_Code         varchar2(20) := 'GL#';
    L_Delimiter_Limits varchar2(5);
    L_Validn_Date      varchar2(25) := to_char(SYSDATE,
                                               'YYYY-MM-DD HH24:MI:SS');
    Lxxx_Num           Number;
    L_gcc_CCID         Number;
    L_DCAmount         DCvAmount;
  
  Begin
  
    L_DCAmount(1) := P_Concatd_Segms1;
    L_DCAmount(2) := P_Concatd_Segms2;
    L_DCAmount(3) := P_Concatd_Segms3;
    L_DCAmount(4) := P_Concatd_Segms4;
    L_DCAmount(5) := P_Concatd_Segms5;
    L_DCAmount(6) := P_Concatd_Segms6;
    L_DCAmount(7) := P_Concatd_Segms7;
    L_DCAmount(8) := P_Concatd_Segms8;
    L_DCAmount(9) := P_Concatd_Segms9;
    L_DCAmount(10) := P_Concatd_Segms10;
    L_DCAmount(11) := P_Concatd_Segms11;
    L_DCAmount(12) := P_Concatd_Segms12;
    L_DCAmount(13) := P_Concatd_Segms13;
    L_DCAmount(14) := P_Concatd_Segms14;
    L_DCAmount(15) := P_Concatd_Segms15;
    L_DCAmount(16) := P_Concatd_Segms16;
    L_DCAmount(17) := P_Concatd_Segms17;
    L_DCAmount(18) := P_Concatd_Segms18;
    L_DCAmount(19) := P_Concatd_Segms19;
    L_DCAmount(20) := P_Concatd_Segms20;
  
    select fii.concatenated_segment_delimiter
      into L_Delimiter_Limits
      from fnd_id_flex_structures fii
     where fii.id_flex_num = L_COA_ID
       and fii.id_flex_code = L_KFF_Code
       and fii.application_id = 101;
  
    select SUM(1)
      into Lxxx_Num
      from xxx_STD_GL_COAChart_v xxv
     where xxv.SOB_ID = fnd_profile.value('GL_SET_OF_BKS_ID');
    L_segments := L_DCAmount(1);
  
    For i in 2 .. Lxxx_Num Loop
      L_segments := L_segments || L_Delimiter_Limits || L_DCAmount(i);
    End Loop;
  
    L_gcc_CCID := fnd_flex_ext.get_ccid(application_short_name => L_Apps_STName,
                                        key_Flex_Code          => L_KFF_Code,
                                        Structure_Number       => L_COA_ID,
                                        validation_Date        => L_Validn_Date,
                                        concatenated_segments  => L_segments);
  
    Return(L_gcc_CCID);
  End Get_CCIDn;

  /*===========================================================
  ---- Func Name:    Get_COA_Segs()
  ---- To Check the Com and Get the COA Segments Combination.
  =============================================================*/
  Function Get_COA_Segs(P_gl_CCID In Number) Return varchar2 IS
  
    L_COA_ID   Number;
    L_gl_CCID  Number;
    L_COA_Segs varchar2(888);
  
  Begin
  
    select gll.chart_of_accounts_id
      into L_COA_ID
      from gl_ledgers gll
     where gll.ledger_id = fnd_profile.value('GL_SET_OF_BKS_ID');
  
    L_gl_CCID := P_gl_CCID;
    Begin
      select gcc.concatenated_segments
        into L_COA_Segs
        from gl_code_combinations_kfv gcc
       where gcc.code_combination_id = L_gl_CCID
         and gcc.chart_of_accounts_id = L_COA_ID;
    
    Exception
      When Others Then
        Print_Output('The CCID U give is Not Existed and Please Double Check.');
    End;
  
    Return(L_COA_Segs);
  End Get_COA_Segs;

  /*===========================================================
  ---- Func Name:    Get_COA_Des()
  ---- To Check the COA Segments Descriptions.
  =============================================================*/
  Function Get_COA_Des(P_gl_CCID In Number) Return varchar2 is
  
    L_gl_CCID      Number;
    L_SOB_ID       Number;
    L_COA_ID       Number;
    L_COA_Des      Varchar2(5000) := 'GL.xxxxxx';
    L_GL_ShortCode Varchar2(6) := 'SQLGL';
    L_GL_FlexCode  Varchar2(6) := 'GL#';
  
  Begin
  
    L_gl_CCID := P_gl_CCID;
    L_SOB_ID  := fnd_profile.value('GL_SET_OF_BKS_ID');
    select gll.chart_of_accounts_id
      into L_COA_ID
      from gl_ledgers gll
     where gll.ledger_id = L_SOB_ID;
  
    dbms_output.put_line('L_SOB_ID:' || L_SOB_ID);
    dbms_output.put_line('L_COA_ID:' || L_COA_ID);
    dbms_output.put_line('L_gl_CCID:' || L_gl_CCID);
    Begin
      IF fnd_flex_keyval.validate_ccid(appl_short_name  => L_GL_ShortCode,
                                       key_flex_code    => L_GL_FlexCode,
                                       structure_number => L_COA_ID, --- Pass U Chart Of Accounts ID
                                       combination_id   => L_gl_CCID) THEN
      
        L_COA_Des := fnd_flex_keyval.concatenated_descriptions();
      END IF;
    
    Exception
      When Others Then
        L_COA_Des := 'Exxxxxx';
    End;
    Return(L_COA_Des);
  End Get_COA_Des;

  /*===========================================================
  ---- Func Name:    Get_COA_Des()
  ---- To Check the COA Segments Descriptions.
  =============================================================*/
  Function Get_COA_Des(P_gl_Segs In Varchar2) Return varchar2 is
  
    L_gl_Segs      Varchar2(1000);
    L_gl_CCID      Number;
    L_SOB_ID       Number;
    L_COA_ID       Number;
    L_COA_Des      Varchar2(5000) := 'GL.xxxxxx';
    L_GL_ShortCode Varchar2(6) := 'SQLGL';
    L_GL_FlexCode  Varchar2(6) := 'GL#';
  
  Begin
  
    L_gl_Segs := P_gl_Segs;
    L_SOB_ID  := fnd_profile.value('GL_SET_OF_BKS_ID');
    select gll.chart_of_accounts_id
      into L_COA_ID
      from gl_ledgers gll
     where gll.ledger_id = L_SOB_ID;
  
    select gcc.code_combination_id
      into L_gl_CCID
      from gl_code_combinations_kfv gcc
     where gcc.concatenated_segments = L_gl_Segs
       and gcc.chart_of_accounts_id = L_COA_ID;
  
    dbms_output.put_line('L_SOB_ID:' || L_SOB_ID);
    dbms_output.put_line('L_COA_ID:' || L_COA_ID);
    dbms_output.put_line('L_gl_CCID:' || L_gl_CCID);
    Begin
      IF fnd_flex_keyval.validate_ccid(appl_short_name  => L_GL_ShortCode,
                                       key_flex_code    => L_GL_FlexCode,
                                       structure_number => L_COA_ID, --- Pass your chart of accounts id
                                       combination_id   => L_gl_CCID) THEN
      
        L_COA_Des := fnd_flex_keyval.concatenated_descriptions();
      End IF;
    Exception
      When Others Then
        L_COA_Des := 'Exxxxxx';
    End;
  
    Return(L_COA_Des);
  End Get_COA_Des;
  /*===========================================================
  ---- Func Name:    Get_Clearing_Flag()
  ---- To Check the Clearing Flag the RCPTs Class.
  =============================================================*/
  Function Get_Clearing_Flag(P_RCPTs_ID In Number) Return varchar2 is
  
    L_Clearing_Flag varchar2(2) := 'N';
  
  Begin
    select acc.clear_flag
      into L_Clearing_Flag
      from ar_receipt_classes acc
     where acc.receipt_class_id = P_RCPTs_ID;
    Return(L_Clearing_Flag);
  End Get_Clearing_Flag;

  /*===========================================================
  ---- Func Name:    Get_RCPTsMthod()
  ---- To Check the Com and Get the RCPTs Method Multi Or Not.
  ---- STD RCPTs In the Receivables.
  =============================================================*/
  Function Get_RCPTsMthod(P_Org_ID     in Number,
                          P_Mthod_Name in varchar2,
                          P_Bank_Name  in varchar2,
                          P_Bank_Num   in varchar2) Return varchar2 IS
  
    L_RCPTsMthod varchar2(2) := 'N';
    L_Org_ID     Number := P_Org_ID;
  
  Begin
    ---- ---- ---- ---- To Get the Exception
    Begin
      select nvl(cba.receipt_multi_currency_flag, 'N')
        into L_RCPTsMthod
        from ar_receipt_method_accounts_all rma,
             ar_receipt_methods             arm,
             ce_bank_acct_uses_all          cbau,
             ce_bank_accounts               cba,
             hz_parties                     hpb,
             hz_parties                     hpc
       where rma.remit_bank_acct_use_id = cbau.bank_acct_use_id
         and cba.bank_account_id = cbau.bank_account_id
         and cba.bank_branch_id = hpc.party_id
         and hpb.party_id = cba.bank_id
         and rma.org_id = cbau.org_id
         and rma.receipt_method_id = arm.receipt_method_id
         and rma.org_id = cbau.org_id
         and rma.org_id = L_Org_ID
         and arm.name = P_Mthod_Name
         and hpb.party_name = P_Bank_Name
         and cba.bank_account_num = P_Bank_Num;
    
    Exception
      When Others Then
        Print_Output(LO_Bank_Status_Checking || P_Bank_Name || P_Bank_Num);
    End;
  
    if nvl(L_RCPTsMthod, 'N') = 'N' Then
      L_RCPTsMthod := 'N';
    End If;
    Return(L_RCPTsMthod);
  End Get_RCPTsMthod;

  /*===========================================================
  ---- Func Name:    Get_RCPTsMthod_ID()
  ---- To Check the Com and Get the RCPTs Method ID.
  ---- STD RCPTs In the Receivables.
  =============================================================*/
  Function Get_RCPTsMthod_ID(P_Org_ID     in Number,
                             P_Mthod_Name in varchar2,
                             P_Bank_Name  in varchar2,
                             P_Bank_Num   in varchar2) Return Number IS
  
    L_RCPTsMthod_ID Number := -9999;
    L_Org_ID        Number := P_Org_ID;
  
  Begin
    select nvl(SUM(rma.receipt_method_id), 0)
      into L_RCPTsMthod_ID
      from ar_receipt_method_accounts_all rma,
           ar_receipt_methods             arm,
           ce_bank_acct_uses_all          cbau,
           ce_bank_accounts               cba,
           hz_parties                     hpb,
           hz_parties                     hpc
     where rma.remit_bank_acct_use_id = cbau.bank_acct_use_id
       and cba.bank_account_id = cbau.bank_account_id
       and cba.bank_branch_id = hpc.party_id
       and hpb.party_id = cba.bank_id
       and rma.org_id = cbau.org_id
       and rma.receipt_method_id = arm.receipt_method_id
       and rma.org_id = cbau.org_id
       and rma.org_id = L_Org_ID
       and arm.name = P_Mthod_Name
       and hpb.party_name = P_Bank_Name
       and cba.bank_account_num = P_Bank_Num;
  
    if L_RCPTsMthod_ID = 0 Then
      Print_Output(LO_Bank_Status_Checking || P_Bank_Name || P_Bank_Num);
      L_RCPTsMthod_ID := -9999;
    End if;
  
    Return(L_RCPTsMthod_ID);
  End Get_RCPTsMthod_ID;

  /*===========================================================
  ---- Func Name:    Get_RCPTsClass_ID()
  ---- To Check the Com and Get the RCPTs Class ID.
  ---- STD RCPTs In the Receivables.
  =============================================================*/
  Function Get_RCPTsClass_ID(P_Org_ID     in Number,
                             P_Mthod_Name in varchar2,
                             P_Bank_Name  in varchar2,
                             P_Bank_Num   in varchar2) Return Number IS
  
    L_RCPTsClass_ID Number := -9999;
    L_Org_ID        Number := P_Org_ID;
  
  Begin
    select nvl(SUM(arm.receipt_class_id), 0)
      into L_RCPTsClass_ID
      from ar_receipt_method_accounts_all rma,
           ar_receipt_methods             arm,
           ce_bank_acct_uses_all          cbau,
           ce_bank_accounts               cba,
           hz_parties                     hpb,
           hz_parties                     hpc
     where rma.remit_bank_acct_use_id = cbau.bank_acct_use_id
       and cba.bank_account_id = cbau.bank_account_id
       and cba.bank_branch_id = hpc.party_id
       and hpb.party_id = cba.bank_id
       and rma.org_id = cbau.org_id
       and rma.receipt_method_id = arm.receipt_method_id
       and rma.org_id = cbau.org_id
       and rma.org_id = L_Org_ID
       and arm.name = P_Mthod_Name
       and hpb.party_name = P_Bank_Name
       and cba.bank_account_num = P_Bank_Num;
  
    if L_RCPTsClass_ID = 0 Then
      Print_Output(LO_Bank_Status_Checking || P_Bank_Name || P_Bank_Num);
      L_RCPTsClass_ID := -9999;
    End if;
  
    Return(L_RCPTsClass_ID);
  End Get_RCPTsClass_ID;

  /*===========================================================
  ---- Func Name:    Get_xxx_ExRate()
  ---- To Check Get the ExRate.
  =============================================================*/
  Function Get_xxx_ExRate(Input_CurCode in varchar2,
                          P_xxx_Convert in varchar2,
                          P_xxx_gl_Date in varchar2) Return Number IS
  
    L_Input_CurCode varchar2(5) := Input_CurCode;
    L_SOB_CurCode   varchar2(5);
    L_xxx_ExRate    Number := 0;
    L_xxx_Convert   varchar2(10) := P_xxx_Convert;
    L_xxx_gl_Date   Date;
  
  Begin
  
    L_xxx_gl_Date := to_Date(P_xxx_gl_Date, 'YYYY-MM-DD');
    select gll.currency_code
      into L_SOB_CurCode
      from gl_ledgers gll
     where gll.ledger_id = fnd_profile.value('GL_SET_OF_BKS_ID');
  
    Begin
      If L_Input_CurCode <> L_SOB_CurCode Then
        select nvl(SUM(gdr.conversion_rate), 0)
          into L_xxx_ExRate
          from gl_daily_rates gdr
         where gdr.from_currency = L_Input_CurCode
           and gdr.to_currency = L_SOB_CurCode
           and gdr.conversion_date = L_xxx_gl_Date
           and gdr.conversion_type = nvl(L_xxx_Convert, 'Corporate');
        L_xxx_ExRate := Round(L_xxx_ExRate, 2);
      End If;
    
    Exception
      When Others Then
        Print_Output('Get_xxx_ExRate:' || 'Exception');
    End;
  
    Return(L_xxx_ExRate);
  End Get_xxx_ExRate;

  /*===========================================================
  ---- Func Name:    Get_xxx_ExRate()
  ---- To Check Get the ExRate.
  =============================================================*/
  Function Get_xxx_ExRate(Input_CurCode in varchar2,
                          SOB_CurCode   in varchar2,
                          P_xxx_Convert in varchar2,
                          P_xxx_gl_Date in varchar2) Return Number IS
  
    L_Input_CurCode varchar2(5) := Input_CurCode;
    L_SOB_CurCode   varchar2(5) := SOB_CurCode;
    L_xxx_ExRate    Number := 0;
    L_xxx_Convert   varchar2(10) := P_xxx_Convert;
    L_xxx_gl_Date   Date;
  
  Begin
    L_xxx_gl_Date := to_Date(P_xxx_gl_Date, 'YYYY-MM-DD');
  
    Begin
      If L_Input_CurCode <> L_SOB_CurCode Then
        select nvl(SUM(gdr.conversion_rate), 0)
          into L_xxx_ExRate
          from gl_daily_rates gdr
         where gdr.from_currency = L_Input_CurCode
           and gdr.to_currency = L_SOB_CurCode
           and gdr.conversion_date = L_xxx_gl_Date
           and gdr.conversion_type = nvl(L_xxx_Convert, 'Corporate');
        L_xxx_ExRate := Round(L_xxx_ExRate, 2);
      End If;
    
    Exception
      When Others Then
        Print_Output('Get_xxx_ExRate:' || 'Exception');
    End;
  
    Return(L_xxx_ExRate);
  End Get_xxx_ExRate;

  /*===========================================================
  ---- Function Name:    get_xxx_Rate()
  ---- To get the get_xxxRate.
  =============================================================*/
  Function get_xxx_Rate(P_From_Curr       in varchar2,
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
  
  End get_xxx_Rate;

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
  ---- Func Name:    Get_SOB_CurCode()
  ---- To Check the Com and Get the Cur_Code Of This SOB.
  =============================================================*/
  Function Get_SOB_CurCode(P_Org_ID in Number, P_Apps_ID In Number)
    Return varchar2 IS
  
    L_Org_ID      Number := P_Org_ID;
    L_Apps_ID     Number := P_Apps_ID;
    L_SOB_CurCode varchar2(5);
  
  Begin
  
    if L_Apps_ID = 200 Then
      select gld.currency_code
        into L_SOB_CurCode
        from gl_ledgers gld, ap_system_parameters_all apa
       where gld.ledger_id = apa.set_of_books_id
         and apa.org_id = L_Org_ID;
    End If;
  
    if L_Apps_ID = 222 Then
      select gld.currency_code
        into L_SOB_CurCode
        from gl_ledgers gld, ar_system_parameters_all apa
       where gld.ledger_id = apa.set_of_books_id
         and apa.org_id = L_Org_ID;
    End If;
  
    Return(L_SOB_CurCode);
  End Get_SOB_CurCode;

  /*===========================================================
  ---- Func Name:    Get_SOB_CurCode()
  ---- To Check the OrgID and Get the Cur_Code Of This SOB.
  =============================================================*/
  Function Get_SOB_CurCode(P_Org_ID in Number) Return varchar2 is
  
    L_SOB_CurCode varchar2(3);
    L_Org_ID      Number := fnd_global.Org_ID;
  
  Begin
  
    if P_Org_ID is null Then
      L_Org_ID := P_Org_ID;
    End if;
  
    SELECT gll.currency_code
      INTO L_SOB_CurCode
      FROM gl_ledgers gll, hr_operating_units hoo
     WHERE gll.ledger_id = hoo.set_of_books_id
       AND hoo.organization_id = L_Org_ID;
  
    Return(L_SOB_CurCode);
  EXCEPTION
    WHEN OTHERS THEN
      RETURN NULL;
    
  End Get_SOB_CurCode;

  /*===========================================================
  ---- Func Name:    Get_Bank_CurCode()
  ---- To Check the Com and Get the Cur_Code Of This Bank.
  =============================================================*/
  Function Get_Bank_CurCode(P_Org_ID    in Number,
                            P_Bank_Name in varchar2,
                            P_Bank_Num  in varchar2) Return varchar2 IS
  
    L_Bank_CurCode varchar2(5);
  
  Begin
  
    ---- ---- ---- ---- To Get the Exception
    Begin
      select cba.currency_code
        Into L_Bank_CurCode
        from ce_bank_acct_uses_all cbau,
             ce_bank_accounts      cba,
             hz_parties            hpb,
             hz_parties            hpc
       where cba.bank_account_id = cbau.bank_account_id
         and cba.bank_branch_id = hpc.party_id
         and hpb.party_id = cba.bank_id
         and nvl(cbau.end_date, trunc(SYSDATE)) >= trunc(SYSDATE)
         and cbau.org_id = P_Org_ID
         and hpb.party_name = P_Bank_Name
         and cba.bank_account_num = P_Bank_Num;
    
    Exception
      When Others Then
        Print_Output(LO_Bank_Status_Checking || P_Bank_Name || P_Bank_Num);
    End;
    If nvl(L_Bank_CurCode, 'HTD') = 'HTD' Then
      L_Bank_CurCode := 'HTD';
    End If;
  
    Return(L_Bank_CurCode);
  End Get_Bank_CurCode;

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
  ---- Func Name:    Get_PartyID()
  ---- To Get The Sup&Cux PartyID..
  =============================================================*/
  Function Get_PartyID(P_Party_Name In varchar2) Return Number IS
  
    L_SupCuxPartyID  Number;
    L_Apps_ID        Number := fnd_global.Resp_Appl_ID;
    L_CreatedModuleA varchar2(30) := 'CUST_INTERFACE';
    L_CreatedModuleB varchar2(30) := 'HZ_CPUI';
  
  Begin
  
    If L_Apps_ID = 222 Then
      Begin
        select hp.party_id
          into L_SupCuxPartyID
          From hz_parties hp
         where hp.party_name = P_Party_Name
           and (hp.created_by_module = L_CreatedModuleA Or
               hp.created_by_module = L_CreatedModuleB and
               hp.application_id = L_Apps_ID);
      
      Exception
        When Others Then
          L_SupCuxPartyID := -9999;
      End;
    End If;
  
    Return(L_SupCuxPartyID);
  End Get_PartyID;

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
  ---- Func Name:    Get_xxx_DepoNum()
  ---- To Check and Get the DepoInv Number BY Depo_ID.
  =============================================================*/
  Function Get_xxx_DepoNum(P_Org_ID In Number, P_Depo_ID in Number)
    Return varchar2 IS
  
    L_Org_ID      Number := P_Org_ID;
    L_Depo_ID     number := P_Depo_ID;
    L_xxx_DepoNum ra_customer_trx_all.trx_number%TYPE;
  
  Begin
  
    ---- ---- ---- ---- Get the Exception L_xxx_DepoNum.
    Begin
      select rct.trx_number
        Into L_xxx_DepoNum
        from ra_customer_trx_all rct
       where rct.org_id = L_Org_ID
         and rct.customer_trx_id = L_Depo_ID;
    
    Exception
      When Others Then
        L_xxx_DepoNum := 'HHHHHHHH';
    End;
    Return(L_xxx_DepoNum);
  End Get_xxx_DepoNum;

  /*===========================================================
  ---- Func Name:    Get_xxx_DepoRemain()
  ---- To Check and Get the DepoInv Remain BY Depo_ID.
  =============================================================*/
  Function Get_xxx_DepoRemain(P_Org_ID      In Number,
                              P_Depo_ID     in Number,
                              P_xxx_gl_Date in varchar2) Return Number IS
  
    L_Org_ID               Number := P_Org_ID;
    L_Depo_ID              Number := P_Depo_ID;
    L_Cur_Code             varchar2(5);
    L_Txxx_GL_Date         Date := nvl(to_Date(P_xxx_gl_Date, 'YYYY-MM-DD'),
                                       TRUNC(SYSDATE));
    L_xxx_DepoRemain       Number := 0;
    L_xxx_ACCTD_DepoRemain Number := 0;
  
  Begin
    select SUM(nvl(rcgd.amount, 0)),
           SUM(nvl(rcgd.acctd_amount, 0)),
           rct.invoice_currency_code Cur_Code
      into L_xxx_DepoRemain, L_xxx_ACCTD_DepoRemain, L_Cur_Code
      from ra_customer_trx_all rct, ra_cust_trx_line_gl_dist_all rcgd
     where rct.customer_trx_id = L_Depo_ID
       and rct.customer_trx_id = rcgd.customer_trx_id
       and rct.org_id = L_Org_ID
       and rct.org_id = rcgd.org_id
       and rcgd.account_class = 'REC'
       and rcgd.gl_date <= L_Txxx_GL_Date;
  
    Return(L_xxx_DepoRemain);
  End Get_xxx_DepoRemain;

  /*===========================================================
  ---- Func Name:    Get_xxx_Rec()
  ---- To Get the Rec For the Exactly Customer&Site For this Period.
  =============================================================*/
  Function Get_xxx_Rec(P_TPName      in varchar2,
                       P_Org_ID      In Number,
                       P_Customer_ID In Number,
                       P_Site_Use_ID In Number) Return SYS_REFCURSOR IS
  
    L_TPName      varchar2(7) := P_TPName;
    L_Org_ID      Number := P_Org_ID;
    L_Apps_ID     Number := fnd_global.Resp_Appl_ID;
    L_Customer_ID Number := P_Customer_ID;
    L_Site_Use_ID Number := P_Site_Use_ID;
    L_RecAmount   SYS_REFCURSOR;
  
  Begin
    Open L_RecAmount For
      select rct.invoice_currency_code Cur_Code,
             rct.bill_to_customer_id Customer_ID,
             rct.bill_to_site_use_id Site_Use_ID,
             SUM(nvl(rcgd.amount, 0)) Rec_Amount,
             SUM(nvl(rcgd.acctd_amount, 0)) RecACCTD_Amount
        from ra_customer_trx_all          rct,
             ra_cust_trx_line_gl_dist_all rcgd,
             gl_period_statuses           gps
       where rct.org_id = L_Org_ID
         and rct.org_id = rcgd.org_id
         and rct.complete_flag = 'Y'
         and rct.customer_trx_id = rcgd.customer_trx_id
         and rct.bill_to_customer_id = L_Customer_ID
         and rct.bill_to_site_use_id = L_Site_Use_ID
         and rct.set_of_books_id = gps.set_of_books_id
         and gps.application_id = L_Apps_ID
         and gps.adjustment_period_flag = 'N'
         and gps.period_name = L_TPName
         and rcgd.account_class = 'REC'
         and (rcgd.gl_date between gps.start_date and gps.end_date)
       Group by rct.invoice_currency_code,
                rct.bill_to_customer_id,
                rct.bill_to_site_use_id;
  
    Return(L_RecAmount);
  End Get_xxx_Rec;

  /*===========================================================
  ---- Func Name:    Get_xxx_RCPTs()
  ---- To Get the Get_xxx_RCPTs For the Exactly Customer&Site For this Period..
  =============================================================*/
  Function Get_xxx_RCPTs(P_Org_ID      In Number,
                         P_TPName      in varchar2,
                         P_Customer_ID In Number,
                         P_Site_Use_ID In Number) Return SYS_REFCURSOR IS
  
    L_TPName      varchar2(7) := P_TPName;
    L_Start_Date  Date;
    L_End_Date    Date;
    L_Org_ID      Number := P_Org_ID;
    L_Customer_ID Number := P_Customer_ID;
    L_Site_Use_ID Number := P_Site_Use_ID;
    L_RCPTsAmount SYS_REFCURSOR;
  
  Begin
  
    select min(gdd.accounting_date), max(gdd.accounting_date)
      into L_Start_Date, L_End_Date
      from gl_ledgers gll, gl_date_period_map gdd
     where gll.ledger_id = fnd_profile.value('GL_SET_OF_BKS_ID')
       and gdd.period_set_name = gll.period_set_name
       and gdd.period_name = L_TPName;
  
    Open L_RCPTsAmount For
      select aca.currency_code Cur_Code,
             aca.pay_from_customer Customer_ID,
             aca.customer_site_use_id Site_Use_ID,
             SUM(decode(acrh.status, 'REVERSED', -acrh.amount, acrh.amount)) RCPTs_Amount,
             SUM(decode(acrh.status,
                        'REVERSED',
                        -acrh.acctd_amount,
                        acrh.acctd_amount)) RCPTsACCTD_Amount,
             SUM(decode(acrh.status,
                        'REVERSED',
                        -nvl(acrh.factor_discount_amount, 0),
                        nvl(acrh.factor_discount_amount, 0))) RCPTs_Disknt_Amount,
             SUM(decode(acrh.status,
                        'REVERSED',
                        -nvl(acrh.acctd_factor_discount_amount, 0),
                        nvl(acrh.acctd_factor_discount_amount, 0))) RCPTsACCTD_Disknt_Amount
      
        from ar_cash_receipts_all aca, ar_cash_receipt_history_all acrh
      
       where aca.cash_receipt_id = acrh.cash_receipt_id
         and aca.org_id = L_Org_ID
         and aca.org_id = acrh.org_id
         and aca.pay_from_customer = L_Customer_ID
         and aca.customer_site_use_id = L_Site_Use_ID
         and aca.set_of_books_id = fnd_profile.value('GL_SET_OF_BKS_ID')
         and (acrh.gl_date >= L_Start_Date and acrh.gl_date <= L_End_Date)
       Group by aca.currency_code,
                aca.pay_from_customer,
                aca.customer_site_use_id;
    Return(L_RCPTsAmount);
  End Get_xxx_RCPTs;

  /*===========================================================
  ---- Func Name:    Get_xxx_UNIDRCPTs()
  ---- To Get the UNIDRCPTs For the Exactly Customer&Site For this Period..
  =============================================================*/
  Function Get_xxx_UNIDRCPTs(P_Org_ID In Number, P_TPName in varchar2)
    Return SYS_REFCURSOR IS
  
    L_TPName          varchar2(7) := P_TPName;
    L_Start_Date      Date;
    L_End_Date        Date;
    L_Org_ID          Number := P_Org_ID;
    L_UNIDRCPTsAmount SYS_REFCURSOR;
  
  Begin
  
    select min(gdd.accounting_date), max(gdd.accounting_date)
      into L_Start_Date, L_End_Date
      from gl_ledgers gll, gl_date_period_map gdd
     where gll.ledger_id = fnd_profile.value('GL_SET_OF_BKS_ID')
       and gdd.period_set_name = gll.period_set_name
       and gdd.period_name = L_TPName;
  
    Open L_UNIDRCPTsAmount For
      select aca.currency_code Cur_Code,
             -9999 Customer_ID,
             -9999 Site_Use_ID,
             SUM(decode(acrh.status, 'REVERSED', -acrh.amount, acrh.amount)) RCPTs_Amount,
             SUM(decode(acrh.status,
                        'REVERSED',
                        -acrh.acctd_amount,
                        acrh.acctd_amount)) RCPTsACCTD_Amount,
             SUM(decode(acrh.status,
                        'REVERSED',
                        -nvl(acrh.factor_discount_amount, 0),
                        nvl(acrh.factor_discount_amount, 0))) RCPTs_Disknt_Amount,
             SUM(decode(acrh.status,
                        'REVERSED',
                        -nvl(acrh.acctd_factor_discount_amount, 0),
                        nvl(acrh.acctd_factor_discount_amount, 0))) RCPTsACCTD_Disknt_Amount
      
        from ar_cash_receipts_all aca, ar_cash_receipt_history_all acrh
      
       where aca.cash_receipt_id = acrh.cash_receipt_id
         and aca.org_id = L_Org_ID
         and aca.org_id = acrh.org_id
         and nvl(aca.pay_from_customer, -9999) = -9999
         and nvl(aca.customer_site_use_id, -9999) = -9999
         and aca.set_of_books_id = fnd_profile.value('GL_SET_OF_BKS_ID')
         and (acrh.gl_date >= L_Start_Date and acrh.gl_date <= L_End_Date)
       Group by aca.currency_code;
  
    Return(L_UNIDRCPTsAmount);
  End Get_xxx_UNIDRCPTs;

  /*===========================================================
  ---- Func Name:    Get_xxx_DueDate()
  ---- To Get the DueDate For the AR Transaction.
  =============================================================*/
  Function Get_xxx_DueDate(P_Org_ID     In Number,
                           P_xxx_ID     In Number,
                           P_xxx_Number in varchar2) Return Date IS
  
    L_xxx_DueDate Date;
    L_Org_ID      Number := P_Org_ID;
    L_xxx_ID      Number := P_xxx_ID;
    L_xxx_Number  varchar2(30) := P_xxx_Number;
  
  Begin
  
    if (L_xxx_ID is NULL and L_xxx_Number is NULL) Then
      L_xxx_DueDate := TRUNC(SYSDATE);
    End If;
  
    Begin
      if NOT (L_xxx_ID is NULL and L_xxx_Number is NULL) Then
        select nvl(rct.term_due_date, rct.trx_date) Due_Date
          into L_xxx_DueDate
          from ra_customer_trx_all rct
         where rct.org_id = L_Org_ID
           and rct.customer_trx_id = nvl(L_xxx_ID, rct.customer_trx_id)
           and rct.trx_number = nvl(L_xxx_Number, rct.trx_number);
      End If;
    Exception
      When Others Then
        L_xxx_DueDate := TRUNC(SYSDATE);
    End;
  
    Return(L_xxx_DueDate);
  End Get_xxx_DueDate;

End xxx_CommonChecking_pkg;
/
