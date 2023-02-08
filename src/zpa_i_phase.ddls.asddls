@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface CDS for Phase'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

@ObjectModel.resultSet.sizeCategory: #XS

define view entity zpa_i_phase
  as select from zpa_d_phase
{
      @ObjectModel.text.element: ['Phase']
  key phaseid as Phaseid,
      phase   as Phase
}
