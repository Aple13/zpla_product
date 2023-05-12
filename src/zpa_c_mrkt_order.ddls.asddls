@EndUserText.label: 'Consumption CDS for Order Entity'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@Search.searchable: true

define view entity zpa_c_mrkt_order
  as projection on zpa_i_mrkt_order
{
  key     ProdUuid,
  key     MrktUuid,
  key     OrderUuid,
          @Search.defaultSearchElement: true
          Orderid,
          Quantity,
          CalendarYear,
          DeliveryDate,
          Netamount,
          Grossamount,
          AmountCurrency,
          BussPartner,
          BussPartnerName,
          BussPartnerGroup,
          CreatedBy,
          CreationTime,
          ChangedBy,
          ChangeTime,
          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZPA_CL_IMAGEURL'
  virtual imageUrl : abap.string(400),
          /* Associations */
          _ProdMrkt : redirected to parent zpa_c_prod_mrkt,
          _Product  : redirected to zpa_c_product
}
