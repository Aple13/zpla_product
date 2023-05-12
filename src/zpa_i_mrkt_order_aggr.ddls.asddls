@AbapCatalog.sqlViewName: 'ZORDERAGGREGATE'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface CDS for Order Aggregate'
define view zpa_i_mrkt_order_aggr
  as select from zpa_i_mrkt_order
{
  key MrktUuid,

      sum(Quantity) as TotalQuantity,

      @Semantics.amount.currencyCode: 'AmountCurrency'
      sum(Netamount) as TotalNetamount,
      
      @Semantics.amount.currencyCode: 'AmountCurrency'
      sum(Grossamount) as TotalGrossamount,
      
      AmountCurrency
      
} group by MrktUuid, AmountCurrency
