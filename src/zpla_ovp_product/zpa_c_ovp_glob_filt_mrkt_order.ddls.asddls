@AbapCatalog.sqlViewName: 'ZPLA_CGLOBFORD'
@AbapCatalog.compiler.compareFilter: true
//@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption CDS for Market Order OVP'

define view zpa_c_ovp_glob_filt_mrkt_order
  as select from ZPA_I_OVP_MARKET_ORDER
{
      @UI.hidden: true
  key ProdUuid,
      @UI.hidden: true
  key MrktUuid,
      @UI.hidden: true
  key OrderUuid,
      
      @UI:{
            selectionField: [{ position: 10 }] 
          }
      @Consumption.valueHelpDefinition: [{ 
                                           entity: { name:    'zpa_i_pg',   
                                                     element: 'Pgname' } 
                                        }]
      ProductName,
      
      @UI:{
            selectionField: [{ position: 20 }] 
          }
      @Consumption.valueHelpDefinition: [{ 
                                           entity: { name:    'zpa_i_market',   
                                                     element: 'Marketname'} 
                                        }]
      CountryName,
      
      @Consumption.filter: { selectionType:      #INTERVAL , 
                             multipleSelections:  false      }
      @UI:{
            selectionField: [{ position: 30 }] 
          }
      DeliveryDate,
      
      @UI:{
            selectionField: [{ position: 40 }] 
          }      
      GrossIncom,
      Amountcurr
}
