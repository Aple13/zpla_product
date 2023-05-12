@AbapCatalog.sqlViewName: 'ZPLA_ALPPHASE'
@AbapCatalog.compiler.compareFilter: true
//@AbapCatalog.preserveKey: true
//@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Phase'
@Analytics.dataCategory: #DIMENSION

define view zpa_i_alp_phase

  as select from zpa_d_phase

{
      @ObjectModel.text.element: ['Phase']
  key phaseid as Phaseid,
      @Semantics.text: true
      @EndUserText.label: 'Product Life Cycle Phase'
      phase   as Phase

}
