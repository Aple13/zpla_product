@AbapCatalog.sqlViewName: 'ZPLA_ALPPRODUCT'
@AbapCatalog.compiler.compareFilter: true
//@AbapCatalog.preserveKey: true
//@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Product'
@Analytics.dataCategory: #FACT


define view zpa_i_alp_product
  as select from zpa_d_product
  
  association[1] to zpa_i_alp_prod_group  as _ProdGrp on $projection.Pgid    = _ProdGrp.Pgid
  association[1] to zpa_i_alp_phase     as _Phase   on $projection.Phaseid = _Phase.Phaseid
  
{
  key prod_uuid                   as ProdUuid,
      prodid                      as Prodid,
      
      @ObjectModel.text.element: ['ProdGrpName']
      pgid                        as Pgid,
      _ProdGrp.Pgname             as ProdGrpName,
      
      @ObjectModel.text.element: ['PhaseName']
      phaseid                     as Phaseid,
      _Phase.Phase                as PhaseName,
      
      @Semantics.amount.currencyCode: 'PriceCurrency'
      @Aggregation.default: #NONE
      price                       as Price,
      price_currency              as PriceCurrency,
      
      @Semantics.quantity.unitOfMeasure: 'Percentage'
      taxrate                     as Taxrate,
      
      @Semantics.unitOfMeasure: true
      cast('%' as abap.unit( 3 )) as Percentage,
      
      /*Associations*/
      _ProdGrp,
      _Phase 
}
