@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface CDS for Market'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zpa_i_market
  as select from zpa_d_market
{
  key mrktid   as Marketid,
      mrktname as Marketname,
      code     as Code,
      imageurl as Imageurl
}
