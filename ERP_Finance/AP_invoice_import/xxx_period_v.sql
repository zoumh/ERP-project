create or replace view xxx_period_v as
select gss.application_id,
       gss.set_of_books_id,
       gss.period_name,
       gss.closing_status,
       gss.period_year,
       gss.period_num,
       gss.adjustment_period_flag,
       to_char(gss.start_date, 'YYYY-MM-DD') start_date,
       to_char(gss.end_date, 'YYYY-MM-DD') end_date
  from gl_period_statuses gss

 Order by gss.Period_Name Desc;
