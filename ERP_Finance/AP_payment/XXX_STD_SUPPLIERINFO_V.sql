CREATE OR REPLACE VIEW XXX_STD_SUPPLIERINFO_V AS
SELECT avs.org_id org_id,
       haou.name ou_name,
       aps.vendor_name sup_name,
       aps.segment1 sup_num,
       avs.vendor_site_code VendorSite_Code,
       aps.vendor_id Vendor_id,
       aps.party_id VParty_ID,
       avs.vendor_site_id vendor_SiteID,
       avs.party_site_id VParty_SiteID,
       nvl(aps.vendor_type_lookup_code, 'StanDard') VendarLookUp_Code,
       iee.default_payment_method_code DPMTs_Method_Code,
       ipp.payment_method_code PMTs_Method_Code,
       nvl(aps.employee_id, -9999) Emploii_ID,
       aps.enabled_flag Enable_Flag,
       aps.allow_awt_flag AWT_Header_Flag,
       nvl(aps.awt_group_id,-9999) AWT_Header_groupID,
       avs.allow_awt_flag AWT_Site_Flag,
       nvl(avs.awt_group_id,-9999) awt_Site_groupID,
       atms.name tms_name,
       gccl.concatenated_segments gccl_account,
       gccp.concatenated_segments gccp_account,
       avs.invoice_currency_code inv_Code,
       avs.payment_currency_code PMT_Code
  FROM ap_suppliers                aps,
       ap_supplier_sites_all       avs,
       hr_all_organization_units   haou,
       hr_organization_information hoi,
       ap_terms_tl                 atms,
       gl_code_combinations_kfv    gccl,
       gl_code_combinations_kfv    gccp,
       hz_parties                  hp,
       iby_external_payees_all iee,
       iby_ext_party_pmt_mthds ipp

 WHERE aps.vendor_id = avs.vendor_id
   AND haou.organization_id = avs.org_id
   AND haou.organization_id = avs.org_id
   AND haou.organization_id = hoi.organization_id
   and haou.organization_id=iee.ORG_ID
   and iee.ORG_TYPE='OPERATING_UNIT'
   and iee.payee_party_id=aps.party_id
   and iee.supplier_site_id=avs.vendor_site_id
   and iee.ext_payee_id=ipp.ext_pmt_party_id
   AND hoi.org_information1 = 'OPERATING_UNIT'
   AND hp.party_id = aps.party_id
   AND avs.terms_id = atms.term_id(+)
   AND atms.language(+) = USERENV('LANG')
   AND gccl.code_combination_id = avs.accts_pay_code_combination_id
   AND gccp.code_combination_id = avs.prepay_code_combination_id
   ----AND nvl(aps.vendor_type_lookup_code, 9999) <> 'EMPLOYEE'
   AND nvl(aps.end_date_active, trunc(SYSDATE)) >= trunc(SYSDATE)
   AND nvl(avs.inactive_date, trunc(SYSDATE)) >= trunc(SYSDATE)
 ORDER BY haou.name;
