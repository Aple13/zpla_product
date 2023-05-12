@AbapCatalog.sqlViewName: 'ZPLA_IOVPMARKET'
@AbapCatalog.compiler.compareFilter: true
//@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Market'

define view ZPA_I_OVP_MARKET
  as select from zpa_d_prod_mrkt

  association [1] to ZPA_I_OVP_COUNTRY as _Country on $projection.Mrktid = _Country.Mrktid

{
  key prod_uuid        as ProdUuid,
  key mrkt_uuid        as MrktUuid,
      @ObjectModel.text.element: ['CountryName']
      mrktid           as Mrktid,
      _Country.Country as CountryName,
      status           as Status,
      startdate        as Startdate,
      enddate          as Enddate,

      /*Associations*/
      _Country
}
