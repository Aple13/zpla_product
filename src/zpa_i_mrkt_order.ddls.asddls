@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface CDS for Order Entity'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zpa_i_mrkt_order
  as select from zpa_d_mrkt_order
  
  association to parent zpa_i_prod_mrkt as _ProdMrkt on $projection.ProdUuid = _ProdMrkt.ProdUuid
                                                    and $projection.MrktUuid = _ProdMrkt.MrktUuid
                                                  
  association [1] to zpa_i_product as _Product on $projection.ProdUuid = _Product.ProdUuid
  
{
  key prod_uuid     as ProdUuid,
  key mrkt_uuid     as MrktUuid,
  key order_uuid    as OrderUuid,
      orderid       as Orderid,
      quantity      as Quantity,
      calendar_year as CalendarYear,
      delivery_date as DeliveryDate,
      @Semantics.amount.currencyCode: 'AmountCurrency'
      netamount     as Netamount,
      @Semantics.amount.currencyCode: 'AmountCurrency'
      grossamount   as Grossamount,
      amountcurr    as AmountCurrency,
      @Semantics.user.createdBy: true
      created_by    as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      @Semantics.dateTime: true
      creation_time as CreationTime,
      @Semantics.user.lastChangedBy: true
      changed_by    as ChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      @Semantics.dateTime: true
      change_time   as ChangeTime,
      
      _ProdMrkt,
      _Product
}
