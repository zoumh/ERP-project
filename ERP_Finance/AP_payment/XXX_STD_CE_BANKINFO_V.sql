CREATE OR REPLACE VIEW XXX_STD_CE_BANKINFO_V AS
SELECT cbau.org_id,
       cba.account_owner_party_id L_Party_ID,
       cba.account_owner_org_id   Legal_Entity,
       hou.name                   org_name,
       cbv.bank_name,
       cbb.bank_branch_name,
       cba.bank_account_name,
       cba.bank_account_num,
       cba.currency_code,

       cbv.bank_party_id     Bank_ID,
       cba.bank_account_id,
       cbau.bank_acct_use_id,

       nvl(cba.multi_currency_allowed_flag, 'N') Mutii_Flag,
       nvl(cba.payment_multi_currency_flag, 'N') MutiiAP_Flag,
       nvl(cba.receipt_multi_currency_flag, 'N') MutiiAR_Flag,

       gcc.concatenated_segments   Bank_Account,
       gccap.concatenated_segments BankAP_Account,
       gccar.concatenated_segments BankAR_Account,
       gcc.code_combination_id     gl_CCID,
       gccap.code_combination_id   AP_CCID,
       gccar.code_combination_id   AR_CCID,

       cbau.end_date bank_use_end_date,
       cba.end_date  bank_end_date,

       gccap_Clearing.concatenated_segments     BankAPClearing_Account,
       gccap_Clearing.code_combination_id       APClearing_CCID,
       gccap_Charges.concatenated_segments      BankAPCharges_Account,
       gccap_Charges.code_combination_id        APCharges_CCID,
       gccap_BankErrors.concatenated_segments   BankAPBankErrors_Account,
       gccap_BankErrors.code_combination_id     APBankErrors_CCID,
       gccap_RealizedGain.concatenated_segments BankAPRealizedGain_Account,
       gccap_RealizedGain.code_combination_id   APRealizedGain_CCID,
       gccap_RealizedLoss.concatenated_segments BankAPRealizedLoss_Account,
       gccap_RealizedLoss.code_combination_id   APRealizedLoss_CCID,
       gccap_Future.concatenated_segments       BankAPRealizedFuture_Account,
       gccap_Future.code_combination_id         APRealizedFuture_CCID

  FROM ce_banks_v               cbv,
       ce_bank_accounts         cba,
       ce_bank_branches_v       cbb,
       ce_bank_acct_uses_all    cbau,
       ce_gl_accounts_ccid      cga,
       gl_code_combinations_kfv gcc,
       gl_code_combinations_kfv gccap,
       gl_code_combinations_kfv gccar,

       gl_code_combinations_kfv gccap_Clearing,
       gl_code_combinations_kfv gccap_Charges,
       gl_code_combinations_kfv gccap_BankErrors,
       gl_code_combinations_kfv gccap_RealizedGain,
       gl_code_combinations_kfv gccap_RealizedLoss,
       gl_code_combinations_kfv gccap_Future,

       hr_operating_units hou

 Where cbv.bank_party_id = cba.bank_id
   and cbb.bank_party_id = cba.bank_id
   and cbb.branch_party_id = cba.bank_branch_id
   and cbau.bank_account_id = cba.bank_account_id
   and cbau.bank_acct_use_id = cga.bank_acct_use_id
   and cbau.org_id = hou.organization_id
   and gcc.code_combination_id(+) = cba.asset_code_combination_id
   and nvl(cga.ap_asset_ccid, cga.ar_asset_ccid) = gccap.code_combination_id(+)

   and cga.cash_clearing_ccid = gccap_Clearing.code_combination_id(+)
   and cga.bank_charges_ccid = gccap_Charges.code_combination_id(+)
   and cga.bank_errors_ccid = gccap_BankErrors.code_combination_id(+)
   and cga.gain_code_combination_id = gccap_RealizedGain.code_combination_id(+)
   and cga.loss_code_combination_id = gccap_RealizedLoss.code_combination_id(+)
   and cga.future_dated_payment_ccid = gccap_Future.code_combination_id(+)

   and nvl(cga.ar_asset_ccid, cga.ap_asset_ccid) = gccar.code_combination_id(+);
