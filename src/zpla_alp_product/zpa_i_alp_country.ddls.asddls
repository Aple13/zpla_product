@AbapCatalog.sqlViewName: 'ZPLA_ALPCOUNTRY'
@AbapCatalog.compiler.compareFilter: true
//@AbapCatalog.preserveKey: true
//@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Country'
@Analytics.dataCategory: #DIMENSION


define view zpa_i_alp_country
  as select from zpa_d_market
{
  key mrktid   as Mrktid,
      mrktname as Country,
      code     as Code,
      imageurl as Imageurl
}
