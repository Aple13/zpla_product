@EndUserText.label: 'Consumption CDS for Product'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Search.searchable: true
@Metadata.allowExtensions: true

define root view entity zpa_c_product
  as projection on zpa_i_product
{
  key ProdUuid,
      //      @Consumption.valueHelpDefinition: [{ entity : {name: 'zpa_i_product' , element: 'Prodid' } }]
      @Search.defaultSearchElement: true
      
      Prodid,
      @Consumption.valueHelpDefinition: [{ entity : {name: 'zpa_i_pg' , element: 'Pgid' } }]
      @EndUserText.label: 'Product Group'
      @ObjectModel.text.element: ['Pgname']
      @Search.defaultSearchElement: true
      @UI.textArrangement: #TEXT_ONLY
      Pgid,
      _Pg.Pgname   as Pgname,
      @Consumption.valueHelpDefinition: [{ entity : {name: 'zpa_i_phase' , element: 'Phaseid' } }]
      @EndUserText.label: 'Phase'
      @ObjectModel.text.element: ['Phase']
      @Search.defaultSearchElement: true
      @UI.textArrangement: #TEXT_ONLY
      Phaseid,
      _Phase.Phase as Phase,
      PhaseCriticality,
      Height,
      Depth,
      Width,
      @EndUserText.label: 'Size Dimensions'
      Measure,
      @Consumption.valueHelpDefinition: [{ entity : {name: 'zpa_i_uom' , element: 'Msehi' } }]
      SizeUom,
      //      @Consumption.valueHelpDefinition: [{ entity : {name: 'zpa_i_product' , element: 'Price' } }]
      @EndUserText.label: 'Net Price'
      @Search.defaultSearchElement: true
      Price,
      @Consumption.valueHelpDefinition: [{ entity : {name: 'zpa_i_currency' , element: 'Currency' } }]
      PriceCurrency,
      @EndUserText.label: 'Tax Rate'
      Taxrate,
      @Semantics.imageUrl: true
      @UI.identification: [{iconUrl: 'Imageurl'}]
      _Pg.Imageurl as Imageurl,
      @EndUserText.label: 'Virtual'
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZPA_CL_VIRTUAL'
      virtual VirtualElement : abap_boolean,
      CreatedBy,
      CreationTime,
      ChangedBy,
      ChangeTime,
      LocalChangedTime,

      _Pg,
      _Phase,
      _Currency,
      _Uom,
      _Prodmrkt : redirected to composition child zpa_c_prod_mrkt
}
