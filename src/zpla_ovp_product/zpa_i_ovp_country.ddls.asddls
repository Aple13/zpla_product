@AbapCatalog.sqlViewName: 'ZPLA_IOVPCOUNTRY'
@AbapCatalog.compiler.compareFilter: true
//@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Country'


define view ZPA_I_OVP_COUNTRY
  as select from zpa_d_market
{
  key mrktid   as Mrktid,
      mrktname as Country,
      code     as Code,
      imageurl as Imageurl
}
