CREATE OR REPLACE Package xxx_STD_HR_Emploii_Import_pkg Is
  /*===============================================================
  *   Copyright (C)
  * ===============================================================
  *    Program Name:   xxx_STD_HRMS_Emploii_Imported_pkg
  *    Author      :   Doris ZOU
  *    Date        :   2013-02-28
  *    Purpose     :   Pl/Sql Html Report PKG
  *                    To Import the Emploii Info.
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
  Procedure xxxMain(P_msg_Data Out Varchar2, P_msg_Count Out Varchar2);

End xxx_STD_HR_Emploii_Import_pkg;
/
CREATE OR REPLACE Package Body xxx_STD_HR_Emploii_Import_pkg Is
  /*===============================================================
  *   Copyright (C) Doris ZOU. Consulting Co., Ltd All rights reserved
  * ===============================================================
  *    Program Name:   xxx_STD_HRMS_Emploii_Imported_pkg
  *    Author      :   Doris ZOU
  *    Date        :   2013-02-28
  *    Purpose     :   Pl/Sql Html Report PKG
  *                    To Import the Emploii Info.
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
  ---- Procedure Name:    xxxMain()
  ---- The Main Procedure Of This pkg.
  =============================================================*/
  Procedure xxxMain(P_msg_Data Out Varchar2, P_msg_Count Out Varchar2) is
  
    Cursor xxEmploii is
      select *
        from HR_UserInfo_Imported_iFace iii
       where iii.imported_flag = 'I'
         For Update Of iii.imported_flag;
  
    L_Import_Flag     Varchar2(2);
    ----L_Date_Format     Varchar2(10) := 'YYYY-MM-DD';
    L_BizGrgoup_ID    Number;
    L_people_group_id number;
    L_grade_id        number;
    L_Job_ID          Number;
    L_position_id     number;
    L_Location_ID     number;
    L_marital_status  Varchar2(5);
  
    L_Null          Varchar2(100);
    L_Person_ID     number;
    L_assignment_id number;
    L_Conn_vChar    Varchar2(5) := '-';
    L_SOB_ID        Number := fnd_profile.value('GL_SET_OF_BKS_ID');
  
    L_All_Num   Number := 0;
    L_ImportedS Number := 0;
    L_ImportedE Number := 0;
  
    L_object_version_number        number;
    L_per_object_version_number    number;
    L_asg_object_version_number    number;
    L_per_effective_start_date     date;
    L_per_effective_end_date       date;
    L_full_name                    varchar2(50);
    L_group_name                   varchar2(50);
    L_per_comment_id               number;
    L_assignment_sequence          number;
    L_special_ceiling_step_id      number;
    L_assignment_number            varchar2(50);
    L_entries_changed_warning      VARCHAR2(30);
    L_gsp_post_process_warning     VARCHAR2(30);
    L_tax_district_changed_warning boolean;
    L_name_combination_warning     boolean;
    L_org_now_no_manager_warning   boolean;
    L_assign_payroll_warning       boolean;
    L_other_manager_warning        boolean;
    L_spp_delete_warning           boolean;
  
    L_employee_number        varchar2(30);
    L_concatenated_segments  varchar2(1500);
    l_effective_start_date   date;
    l_effective_end_date     date;
    L_person_type_id         Number;
    b_soft_coding_keyflex_id number;
  
  Begin
  
    ---- ---- ---- ---- To Build the Data Of Details and Total.  
  
    For x in xxEmploii Loop
    
      L_Person_ID                 := null;
      L_assignment_id             := null;
      L_object_version_number     := null;
      L_per_object_version_number := null;
      L_asg_object_version_number := null;
      L_per_effective_start_date  := null;
      L_per_effective_end_date    := null;
      L_full_name                 := null;
      L_per_comment_id            := null;
      L_assignment_sequence       := null;
      L_assignment_number         := null;
      L_name_combination_warning  := null;
      L_assign_payroll_warning    := null;
      L_special_ceiling_step_id   := null;
      L_people_group_id           := null;
      L_assignment_id             := null;
      L_employee_number           := null;
      L_concatenated_segments     := null;
      L_effective_start_date      := null;
      L_effective_end_date        := null;
    
      L_Import_Flag := 'Y';
    
      select xx.lookup_code
        into L_marital_status
        from HR_LOOKUPS xx
       where xx.lookup_type = 'MAR_STATUS'
         and xx.meaning = x.marital_status;
    
      select ppt.person_type_id
        into L_person_type_id
        from per_person_types ppt
       where ppt.user_person_type = x.emp_tii;
    
      select poo.organization_id
        into L_BizGrgoup_ID
        from per_all_organization_units poo
       where poo.name = x.hr_org;
    
      select ppg.people_group_id
        into L_people_group_id
        from pay_people_groups ppg
       where ppg.group_name = x.hr_group;
    
      select pp.JOB_ID
        into L_Job_ID
        from per_jobs pp
       where pp.name = x.job_name;
    
      select pp.position_id
        into L_position_id
        from per_positions pp
       where pp.name = x.postion_name;
    
      select gg.grade_id
        into L_grade_id
        from per_grades gg
       where gg.name = x.salary_grade;
    
      select hll.location_id
        into L_Location_ID
        from hr_locations_no_join hll
       where hll.location_code = x.location_code;
    
      Savepoint xxxRollBackiii;
      Begin
        hr_employee_api.create_employee(p_validate            => false,
                                        p_hire_date           => x.emp_start_date,
                                        p_business_group_id   => L_BizGrgoup_ID,
                                        p_last_name           => x.Emp_LastName,
                                        p_sex                 => x.Sex_Code,
                                        p_person_type_id      => L_person_type_id,
                                        p_date_of_birth       => x.Birth_Date,
                                        p_email_address       => x.email_address,
                                        p_employee_number     => L_employee_number,
                                        p_marital_status      => L_marital_status,
                                        p_national_identifier => x.idcard_code,
                                        
                                        p_person_id                 => L_person_id,
                                        p_assignment_id             => L_assignment_id,
                                        p_per_object_version_number => L_per_object_version_number,
                                        p_asg_object_version_number => L_asg_object_version_number,
                                        p_per_effective_start_date  => L_per_effective_start_date,
                                        p_per_effective_end_date    => L_per_effective_end_date,
                                        p_full_name                 => L_full_Name,
                                        p_per_comment_id            => L_per_comment_id,
                                        p_assignment_sequence       => L_assignment_sequence,
                                        p_assignment_number         => L_assignment_number,
                                        p_name_combination_warning  => L_name_combination_warning,
                                        p_assign_payroll_warning    => L_assign_payroll_warning);
      
      Exception
        when others then
          dbms_output.put_line('L_Import_Flag-Emploii :' || SQLCODE);
          dbms_output.put_linE('L_Import_Flag-Emploii :' || SQLERRM);
          Print_Logs('L_Import_Flag-Emploii :' || SQLCODE);
          Print_Logs('L_Import_Flag-Emploii :' || SQLERRM);
          L_Import_Flag := 'N';
      End;
    
      if L_Import_Flag = 'Y' then
      
        BEGIN
          hr_assignment_api.UPDATE_EMP_ASG_CRITERIA(p_validate              => false,
                                                    p_effective_date        => x.emp_start_date,
                                                    p_datetrack_update_mode => 'CORRECTION',
                                                    --p_datetrack_update_mode   => 'UPDATE',
                                                    p_assignment_id          => L_assignment_id,
                                                    p_organization_id        => L_BizGrgoup_ID,
                                                    p_job_id                 => L_Job_ID,
                                                    p_position_id            => L_position_id,
                                                    p_people_group_id         => L_people_group_id,
                                                    p_grade_id                => L_grade_id,
                                                    p_location_id             => L_Location_ID,
                                                    
                                                    ----p_set_of_books_id =>L_SOB_ID,
                                                    ----p_default_code_comb_id=>gl_CCID,
                                                    p_soft_coding_keyflex_id => b_soft_coding_keyflex_id,
                                                    p_object_version_number   => L_asg_object_version_number,
                                                    p_special_ceiling_step_id => L_special_ceiling_step_id,                                                    
                                                    ---- ---- ---- ---- OUT
                                                    p_group_name                   => L_group_name,
                                                    p_effective_start_date         => L_effective_start_date,
                                                    p_effective_end_date           => L_effective_end_date,
                                                    p_org_now_no_manager_warning   => L_org_now_no_manager_warning,
                                                    p_other_manager_warning        => L_other_manager_warning,
                                                    p_spp_delete_warning           => L_spp_delete_warning,
                                                    p_entries_changed_warning      => L_entries_changed_warning,
                                                    p_tax_district_changed_warning => L_tax_district_changed_warning,
                                                    p_concatenated_segments        => L_concatenated_segments,
                                                    p_gsp_post_process_warning     => L_gsp_post_process_warning);
        
        Exception
          when others then
            dbms_output.put_line('L_Import_Flag-Emploii :' || SQLCODE);
            dbms_output.put_linE('L_Import_Flag-Emploii :' || SQLERRM);
            dbms_output.put_linE('fnd_message.get is :' || fnd_message.get);
            Print_Logs('L_Import_Flag-Emploii :' || SQLCODE);
            Print_Logs('L_Import_Flag-Emploii :' || SQLERRM);
            Print_Logs('L_Import_Flag-Emploii :' || fnd_message.get);
            L_Import_Flag := 'N';
            RollBack to xxxRollBackiii;
        End;
      End if;
    
      if L_Import_Flag = 'Y' Then
        L_ImportedS := L_ImportedS + 1;
        Update HR_UserInfo_Imported_iFace iiii
           Set iiii.imported_flag = 'Y'
         Where Current Of xxEmploii;
      
      End if;
      if L_Import_Flag = 'N' Then
        L_ImportedE := L_ImportedE + 1;
      End if;
    
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
  
  End xxxMain;

End xxx_STD_HR_Emploii_Import_pkg;
/
