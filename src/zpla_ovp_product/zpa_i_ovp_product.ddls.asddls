@AbapCatalog.sqlViewName: 'ZPLA_IOVPPRODUCT'
@AbapCatalog.compiler.compareFilter: true
//@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Product'

define view ZPA_I_OVP_PRODUCT
  as select from zpa_d_product

  association [1] to ZPA_I_OVP_PROD_GROUP as _ProdGrp on $projection.Pgid = _ProdGrp.Pgid
  association [1] to ZPA_I_OVP_PHASE      as _Phase   on $projection.Phaseid = _Phase.Phaseid

{
  key prod_uuid       as ProdUuid,
      prodid          as Prodid,
      @ObjectModel.text.element: ['ProdGrpName']
      pgid            as Pgid,
      _ProdGrp.Pgname as ProdGrpName,
      @ObjectModel.text.element: ['PhaseName']
      phaseid         as Phaseid,
      _Phase.Phase    as PhaseName,
      price           as Price,
      price_currency  as PriceCurrency,
      taxrate         as Taxrate,

      /*Associations*/
      _ProdGrp,
      _Phase
}
