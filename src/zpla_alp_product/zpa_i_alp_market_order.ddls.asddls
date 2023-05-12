@AbapCatalog.sqlViewName: 'ZPLA_ALPMRKTORD'
@AbapCatalog.compiler.compareFilter: true
//@AbapCatalog.preserveKey: true
//@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Orders'
@Analytics.dataCategory: #CUBE


define view zpa_i_alp_market_order
  as select from zpa_d_mrkt_order
  
  association[1..1] to zpa_i_alp_product as _Product on $projection.ProdUuid = _Product.ProdUuid
  association[1..1] to zpa_i_alp_market  as _Market  on $projection.MrktUuid = _Market.MrktUuid
  
{
  key prod_uuid                                               as ProdUuid,
  key mrkt_uuid                                               as MrktUuid,
  key order_uuid                                              as OrderUuid,
      orderid                                                 as Orderid,
      _Product.Prodid                                         as Prodid,
      _Product._ProdGrp.Pgname                                as ProductName,
      1                                                       as ProductCount,
      _Market._Country.Country                                as CountryName,
      _Market._Country.Country                                as CountryName2,
      1                                                       as CountryCount,
      _Product._Phase.Phase                                   as PhaseName,
      calendar_year                                           as CalendarYear,
      delivery_date                                           as DeliveryDate,
      quantity                                                as Quantity,
      
      @Semantics.amount.currencyCode: 'Amountcurr'
      netamount                                               as Netamount,
      
      @Semantics.amount.currencyCode: 'Amountcurr'
      grossamount                                             as Grossamount,
      
      @Semantics.currencyCode: true
      amountcurr                                              as Amountcurr,

      @Semantics.amount.currencyCode: 'Amountcurr'
      @EndUserText.label: 'Gross Incom'
      grossamount - netamount                                 as GrossIncom,
      
      @Semantics.amount.currencyCode: 'Amountcurr'
      @EndUserText.label: 'Average Gross Incom'
      grossamount - netamount                                 as GrossIncomAvg,
      
      @Semantics.amount.currencyCode: 'Amountcurr'
      @EndUserText.label: 'Maximum Gross Incom'
      grossamount - netamount                                 as GrossIncomMax,
      
      @Semantics.amount.currencyCode: 'Amountcurr'
      @EndUserText.label: 'Manimum Gross Incom'
      grossamount - netamount                                 as GrossIncomMin,
      

------Target Value for KPIs      
//      @Semantics.amount.currencyCode: 'Amountcurr'
      15000000                                                as KPITargGrossAmount,
      
//      @Semantics.amount.currencyCode: 'Amountcurr'
      8000000                                                 as KPITargGrossIncome,
      
      /*Associations*/
      _Product,
      _Market
      
}
