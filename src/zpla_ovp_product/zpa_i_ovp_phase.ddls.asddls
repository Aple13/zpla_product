@AbapCatalog.sqlViewName: 'ZPLA_IOVPPHASE'
@AbapCatalog.compiler.compareFilter: true
//@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Phase'

define view ZPA_I_OVP_PHASE

  as select from zpa_d_phase

{
  key phaseid as Phaseid,
      phase   as Phase

}
