@AbapCatalog.sqlViewName: 'ZPLA_CALPMRKTORD'
@AbapCatalog.compiler.compareFilter: true
//@AbapCatalog.preserveKey: true
//@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'ALP for Market Orders'

@UI.selectionPresentationVariant: [
-----KPI                                   
                                   {
                                     qualifier:                    'KPIGrossIncomeByCountryAvg',
                                     selectionVariantQualifier:    'KPIGrossIncomeByCountryAvg',
                                     presentationVariantQualifier: 'KPIGrossIncomeByCountryAvg'
                                   },
                                   {
                                     qualifier:                    'KPIGrossIncomeByCountryMax',
                                     selectionVariantQualifier:    'KPIGrossIncomeByCountryMax',
                                     presentationVariantQualifier: 'KPIGrossIncomeByCountryMax'
                                   },
                                   {
                                     qualifier:                    'KPIGrossIncomeByCountryMin',
                                     selectionVariantQualifier:    'KPIGrossIncomeByCountryMin',
                                     presentationVariantQualifier: 'KPIGrossIncomeByCountryMin'
                                   },
                                   {
                                     qualifier:                    'KPIGrossIncomeByCountry',
                                     selectionVariantQualifier:    'KPIGrossIncomeByCountry',
                                     presentationVariantQualifier: 'KPIGrossIncomeByCountry'
                                   },
                                   {
                                     qualifier:                    'KPIGrossAmountByCountry',
                                     selectionVariantQualifier:    'KPIGrossAmountByCountry',
                                     presentationVariantQualifier: 'KPIGrossAmountByCountry'
                                   },
-----Visual Filters 
                                   {
                                     qualifier:                    'FilterCntrByGrossIncom',
                                     selectionVariantQualifier:    'FilterCntrByGrossIncom',
                                     presentationVariantQualifier: 'FilterCntrByGrossIncom'
                                   },
                                   {
                                     qualifier:                    'FilterProdByOrdQuantity',
                                     selectionVariantQualifier:    'FilterProdByOrdQuantity',
                                     presentationVariantQualifier: 'FilterProdByOrdQuantity'
                                   },
-----Main Chart                    
                                   {
                                     qualifier:                    'MainChart',
                                     selectionVariantQualifier:    'MainChart',
                                     presentationVariantQualifier: 'MainChart'
                                   }
                                  ]
-----------------------------
@UI.selectionVariant: [
----KPI                       
                       {//KPI AVG Gross Income by Countries
                         qualifier: 'KPIGrossIncomeByCountryAvg',
                         text:      'Average Gross Income by Countries'
                       },
                       {//KPI MAX Gross Income by Countries
                         qualifier: 'KPIGrossIncomeByCountryMax',
                         text:      'Maximum Gross Income by Countries'
                       },
                       {//KPI MIN Gross Income by Countries
                         qualifier: 'KPIGrossIncomeByCountryMin',
                         text:      'Minimum Gross Income by Countries'
                       },
                       {//KPI Total Gross Income by Countries
                         qualifier: 'KPIGrossIncomeByCountry',
                         text:      'Total Gross Income by Countries'
                       },
                       {//KPI Gross Amount by Countries
                         qualifier: 'KPIGrossAmountByCountry',
                         text:      'Gross Amount By Countries'
                       },
----Visual Filters
                       {//Filter By Gross Income
                         qualifier: 'FilterCntrByGrossIncom',
                         text:      'Market by Gross Income'
                       },
                       {//Filter Orders Quantity By Products  
                         qualifier: 'FilterProdByOrdQuantity',
                         text:      'Product by Gross Income Percentage'
                       },
----Main Chart                      
                       {//Main Chart
                         qualifier: 'MainChart',
                         text:      'Main Chart'
                       }
                      ]
-----------------------------
@UI.presentationVariant: [
---KPI                           
                          {//KPI AVG Gross Income by Countries
                            qualifier:     'KPIGrossIncomeByCountryAvg',
                            text:          'Average Gross Income by Countries',
                            visualizations:[
                                            { type:#AS_CHART,     qualifier: 'ChartGrossIncomeByCountry'},
                                            { type:#AS_DATAPOINT, qualifier: 'GrossIncomAvg'}
                                           ]
                          },
                          {//KPI MAX Gross Income by Countries
                            qualifier:     'KPIGrossIncomeByCountryMax',
                            text:          'Maximum Gross Income by Countries',
                            visualizations:[
                                            { type:#AS_CHART,     qualifier: 'ChartGrossIncomeByCountry'},
                                            { type:#AS_DATAPOINT, qualifier: 'GrossIncomMax'}
                                           ]
                          },
                          {//KPI MIN Gross Income by Countries
                            qualifier:     'KPIGrossIncomeByCountryMin',
                            text:          'Minimum Gross Income by Countries',
                            visualizations:[
                                            { type:#AS_CHART,     qualifier: 'ChartGrossIncomeByCountry'},
                                            { type:#AS_DATAPOINT, qualifier: 'GrossIncomMin'}
                                           ]
                          },
                          {//KPI Total Gross Income by Countries
                            qualifier:     'KPIGrossIncomeByCountry',
                            text:          'Total Gross Income by Countries',
                            visualizations:[
                                            { type:#AS_CHART,     qualifier: 'ChartGrossIncomeByCountry'},
                                            { type:#AS_DATAPOINT, qualifier: 'dpGrossIncom'}
                                           ]
                          },
                          {//KPI Gross Amount by Countries
                            qualifier:     'KPIGrossAmountByCountry',
                            text:          'Gross Amount By Countries',
                            visualizations:[
                                            { type:#AS_CHART,     qualifier: 'ChartGrossAmountByCountry'},
                                            { type:#AS_DATAPOINT, qualifier: 'Grossamount'}
                                           ]
                          },
---Visual Filters
                          {//Filter Country By Gross Income
                            qualifier:     'FilterCntrByGrossIncom',
                            text:          'Market by Gross Income',
                            visualizations:[
                                            { type:#AS_CHART,     qualifier: 'ChartFilterCntrByGrossIncom' },
                                            { type:#AS_DATAPOINT, qualifier: 'dpGrossIncom'}
                                           ]
                          },
                          {//Filter Orders Quantity By Products  
                            qualifier:     'FilterProdByOrdQuantity',
                            text:          'Product by Gross Income Percentage',
                            visualizations:[
                                            { type:#AS_CHART,     qualifier: 'ChartFilterProdByOrdQuantity' },
                                            { type:#AS_DATAPOINT, qualifier: 'dpProductCount'}
                                           ]
                          },
---Main Chart                         
                          {
                            qualifier:     'MainChart',
                            sortOrder:     [{ by: 'Orderid', direction: #ASC }],
                            groupBy:       [ 'ProductName', 'CountryName' ],
                            visualizations:[
                                             { type:#AS_CHART,    qualifier: 'ChartMainChart' },
                                             { type:#AS_LINEITEM, qualifier: 'LineMainChart'}
                                           ]
                          }
                         ]
-----------------------------
@UI.chart: [
--KPI            
            {//KPI Chart Gross Income by Country
              qualifier:           'ChartGrossIncomeByCountry',
              chartType:           #DONUT,
              dimensions:          ['CountryName'],
              measures:            ['GrossIncom'],
              dimensionAttributes: [{ dimension: 'CountryName', role:#CATEGORY }],
              measureAttributes:   [{ measure:   'GrossIncom',  role: #AXIS_1 }]
            },
            {//KPI Gross Amount By Country
              qualifier:           'ChartGrossAmountByCountry',
              chartType:           #BAR,
              dimensions:          ['CountryName'],
              measures:            ['Grossamount'],
              dimensionAttributes: [{ dimension: 'CountryName', role:#CATEGORY }],
              measureAttributes:   [{ measure:   'Grossamount', role: #AXIS_1 }]
            },
--Visual Filters
            {//Filter Country By Gross Income
              qualifier:           'ChartFilterCntrByGrossIncom',
              chartType:           #LINE,
              dimensions:          ['CountryName'],
              measures:            ['GrossIncom'],
              dimensionAttributes: [{ dimension: 'CountryName', role:#CATEGORY }],
              measureAttributes:   [{ measure:   'GrossIncom',  role: #AXIS_1, asDataPoint: true }]
            },
            {//Filter Orders Quantity By Products  
              qualifier:           'ChartFilterProdByOrdQuantity',
              chartType:           #DONUT,
              dimensions:          ['ProductName'],
              measures:            ['ProductCount'],
              dimensionAttributes: [{ dimension: 'ProductName',  role:#CATEGORY }],
              measureAttributes:   [{ measure:   'ProductCount', role: #AXIS_1, asDataPoint: true } ]
            },
--Main Chart
            {//Main Chart
              qualifier:          'ChartMainChart',
              chartType:           #BAR_STACKED,
              dimensions:          [ 'ProductName', 'CountryName'],
              measures:            [ 'Netamount',   'GrossIncom' ],
              dimensionAttributes: [
                                    { dimension: 'CountryName', role:#CATEGORY },
                                    { dimension: 'ProductName', role:#CATEGORY }                                    
                                   ],
              measureAttributes:   [
                                    { measure: 'Netamount',  role: #AXIS_1 },
                                    { measure: 'GrossIncom', role: #AXIS_1 }
                                   ]
            }
           ]

define view zpa_c_alp_market_order
  as select from zpa_i_alp_market_order
{
   @UI.facet:[
---------------------------------------------------------------------
//                       Header Facet Annotations                        
              {
                 id:              'HeaderOrderid',
                 purpose:          #HEADER,
                 type:             #DATAPOINT_REFERENCE,
                 targetQualifier: 'Orderid',
                 position: 10
              },
              {
                 id:              'HeaderProduct',
                 purpose:          #HEADER,
                 type:             #DATAPOINT_REFERENCE,
                 targetQualifier: 'Product',
                 position: 20
              },
---------------------------------------------------------------------            
//                       Object Page Tabs                                               
              {
                 id:                'GeneralInformation',
                 type:               #COLLECTION,
                 label:             'General Information',
                 position:           10
              },
              {
                 id:                'FinanceInformation',
                 type:               #COLLECTION,
                 label:             'Finance Information',
                 position:           20
              },
 --------------------------------------------------------------------             
//                      Field Groups              
              {
                 id:                'BasicData',
                 purpose:           #STANDARD ,
                 parentId:          'GeneralInformation',
                 type:              #FIELDGROUP_REFERENCE,
                 label:             'General Information',
                 position:          10,
                 targetQualifier:   'BasicData'
              },
              {
                 id:                'FinInfo',
                 purpose:           #STANDARD ,
                 parentId:          'FinanceInformation',
                 type:              #FIELDGROUP_REFERENCE,
                 label:             'Finance Information',
                 position:          20,
                 targetQualifier:   'FinInfo'
              }
             ]     
 --------------------------------------------------------------------  
  @UI.hidden: true
  key ProdUuid,
  @UI.hidden: true
  key MrktUuid,
  @UI.hidden: true
  key OrderUuid,
      
      @UI: {
             lineItem:       [{qualifier: 'LineMainChart', position: 30}],
             identification: [{ position: 10 }],
             fieldGroup:     [{ position: 10,     qualifier: 'BasicData'}],
             dataPoint:      {  title:'Order ID', qualifier: 'Orderid' }
           }      
      Orderid,
      @UI: {
             lineItem:       [{ qualifier: 'LineMainChart', position: 31 }],
             identification: [{ position: 11 }],
             fieldGroup:     [{ position: 11,     qualifier: 'BasicData'}],
             dataPoint:      {  title:'Product ID', qualifier: 'Orderid' }
           }      
      @Consumption: {
                     semanticObject: 'zpa_c_product_analyze',
                     semanticObjectMapping: { element: 'Prodid' }
                    } 
      Prodid,
      @UI: {
             lineItem:       [{qualifier: 'LineMainChart', position: 15}],
             selectionField: [{ position: 10 }],
             identification: [{ position: 20 }],
             fieldGroup:     [{ position: 20,    qualifier: 'BasicData'}],
             dataPoint:      {  title:'Product', qualifier: 'Product' }
             
           }
      @Consumption.valueHelpDefinition: [{ 
                                           entity: { name:    'zpa_i_pg',   
                                                     element: 'Pgname' } 
                                        }]
      @EndUserText.label: 'Product'
      ProductName,

      
      @UI.dataPoint: {//Visual Filter Criticality
                       qualifier: 'dpProductCount',
                       valueFormat.numberOfFractionalDigits: 2 ,
                       criticalityCalculation: { improvementDirection:   #MAXIMIZE,
                                                 deviationRangeLowValue: 3, 
                                                 toleranceRangeLowValue: 5 }
                     }
      @Aggregation.default: #SUM
      @EndUserText.label: 'Orders Quantity'
      ProductCount,
      
      
      @Consumption: {
                     semanticObject: 'ovpsemanticobject',
                     semanticObjectMapping: { element: 'CountryName' }
                    }
      @UI: {
             lineItem:       [{qualifier: 'LineMainChart', position: 20 }],
             selectionField: [{ position: 20 }],
             identification: [{ 
                                position: 30 
                             }],
             fieldGroup:     [{ position: 30, qualifier: 'BasicData'}]
           }
      @Consumption.valueHelpDefinition: [{ 
                                           entity: { name:    'zpa_i_market',   
                                                     element: 'Marketname'} 
                                        }]      
      @EndUserText.label: 'Market (Country)'
      CountryName,
      @UI: {
             selectionField: [{ position: 21 }]
           }
      @Consumption.valueHelpDefinition: [{ 
                                           entity: { name:    'zpa_i_market',   
                                                     element: 'Marketname'} 
                                        }]     
      CountryName2,
      
      @UI: {
             identification: [{ position: 40 }],
             fieldGroup:     [{ position: 40, qualifier: 'BasicData'}]
           }      
      @Consumption.valueHelpDefinition: [{ 
                                           entity: { name:    'zpa_i_phase',   
                                                     element: 'Phase'} 
                                        }]
      PhaseName,
      
      @UI: {
             lineItem:       [{qualifier: 'LineMainChart', position: 50 }],
             selectionField: [{ position: 50 }],
             identification: [{ position: 50 }],
             fieldGroup:     [{ position: 50, qualifier: 'BasicData'}]
           }
      @Consumption.filter: { selectionType:      #INTERVAL , 
                             multipleSelections:  false      }           
      DeliveryDate,
      
      @UI: { selectionField: [{ position: 51 }] }
      CalendarYear,
     
      @UI: {
             lineItem:       [{qualifier: 'LineMainChart', position: 60 }],
             identification: [{ position: 60 }],
             fieldGroup:     [{ position: 10, qualifier: 'FinInfo'}]
           }      
      @Aggregation.default: #SUM
      Quantity,
     
      @UI: {
             lineItem:       [{qualifier: 'LineMainChart', position: 70 }],
             identification: [{ position: 70 }],
             fieldGroup:     [{ position: 20, qualifier: 'FinInfo'}]
           }     
      @Aggregation.default: #SUM
      Netamount,
     
      @UI: {
             lineItem:       [{qualifier: 'LineMainChart', position: 80 }],
             identification: [{ position: 80 }],
             fieldGroup:     [{ position: 30, qualifier: 'FinInfo'}],
             dataPoint:      {//KPI Gross Amount by Country
                               valueFormat.numberOfFractionalDigits: 2 ,
                               criticalityCalculation: { improvementDirection:   #MAXIMIZE,
                                                         deviationRangeLowValue: 14000000, 
                                                         toleranceRangeLowValue: 15000000 },
                               trendCalculation:       { referenceValue:'KPITargGrossAmount',
                                                         downDifference: 0,
                                                         upDifference:   0 }
                             }
           }
      @Aggregation.default: #SUM
      Grossamount,
      
      @UI: {
             lineItem:       [{qualifier: 'LineMainChart', position: 90 }], 
             identification: [{ position: 90 }],
             fieldGroup:     [{ position: 40, qualifier: 'FinInfo'}],
             dataPoint:      {//KPI Total Gross Income by Countries
                               qualifier: 'dpGrossIncom',
                               valueFormat.numberOfFractionalDigits: 2 ,
                               criticalityCalculation: { improvementDirection:   #MAXIMIZE,
                                                         deviationRangeLowValue: 7500000, 
                                                         toleranceRangeLowValue: 8000000 },
                               trendCalculation:       { referenceValue:'KPITargGrossIncome',
                                                         downDifference: 0,
                                                         upDifference:   0 }
                             }
           }  
      @Aggregation.default: #SUM
      GrossIncom,
      
      @UI: {
             lineItem:  [{qualifier: 'LineMainChart', position: 110 }], 
             dataPoint: {//KPI Chart Gross Income by Country
                          title: 'Average Gross Income',
                          valueFormat.numberOfFractionalDigits: 2,
                          valueFormat.scaleFactor:              1000000,
                          criticalityCalculation: {
                                                    improvementDirection:   #MAXIMIZE,
                                                    toleranceRangeLowValue: 550000,
                                                    deviationRangeLowValue: 500000
                                                  }
                        }
                        
           }
      @Aggregation.default: #AVG
      @EndUserText.label:  'Average Gross Income'
      GrossIncomAvg,
      
      @UI: {
             lineItem:  [{qualifier: 'LineMainChart', position: 120 }], 
             dataPoint: {//KPI Chart Max Gross Income by Country
                          title: 'Maximum',
                          valueFormat.numberOfFractionalDigits: 2,
                          valueFormat.scaleFactor:              1000000,
                          criticalityCalculation: {
                                                    improvementDirection:   #MAXIMIZE,
                                                    toleranceRangeLowValue: 6000000,
                                                    deviationRangeLowValue: 5000000
                                                  }
                        }
                        
           }
      @Aggregation.default: #MAX
      @EndUserText.label:  'Maximum Gross Income'
      GrossIncomMax,  
      
      @UI: {
             lineItem:  [{qualifier: 'LineMainChart', position: 100 }], 
             dataPoint: {//KPI Chart Min Gross Income by Country
                          title: 'Minimum',
                          valueFormat.numberOfFractionalDigits: 2,
                          valueFormat.scaleFactor:              1000000,
                          criticalityCalculation: {
                                                    improvementDirection:   #MAXIMIZE,
                                                    toleranceRangeLowValue: 200000,
                                                    deviationRangeLowValue: 150000
                                                  }
                        }
           }
      @Aggregation.default: #MIN
      @EndUserText.label:  'Minimum Gross Income'
      GrossIncomMin,  
     
      Amountcurr,
      KPITargGrossIncome,
      KPITargGrossAmount,
      _Product
}
