@EndUserText.label: 'Consumption CDS for Market Entity'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@Search.searchable: true

define view entity zpa_c_prod_mrkt
  as projection on zpa_i_prod_mrkt
{
  key ProdUuid,
  key MrktUuid,
      @Search.defaultSearchElement: true
      @Consumption.valueHelpDefinition: [{ entity : {name: 'zpa_i_market' , element: 'Mrktid' } }]
      @ObjectModel.text.element: ['MarketName']
      @EndUserText.label: 'Market'
      @UI.textArrangement: #TEXT_ONLY
      Mrktid,
      _Market.Marketname as MarketName,
      @EndUserText.label: 'Confirmed?'
      Status,
      StatusCriticality,
      Startdate,
      Enddate,
      _Market.Imageurl as Imageurl,
      CreatedBy,
      CreationTime,
      ChangedBy,
      ChangeTime,
      LocalChangedTime,
      /* Associations */
      _Market,
      _Product : redirected to parent zpa_c_product,
      _MrktOrder : redirected to composition child zpa_c_mrkt_order
}
