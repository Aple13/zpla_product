@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface CDS for Market'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

@ObjectModel.resultSet.sizeCategory: #XS

define view entity zpa_i_market
  as select from zpa_d_market
{
//      @ObjectModel.text.element: ['Code']
  key mrktid   as Mrktid,
      mrktname as Marketname,
      code     as Code,
      imageurl as Imageurl
}
