@AbapCatalog.sqlViewName: 'ZPLA_C_CARDORDER'
@AbapCatalog.compiler.compareFilter: true
//@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption CDS for Cards Order OVP'

@UI.headerInfo: { //StackCard  Orders List
                  typeName:       'Order',
                  typeNamePlural: 'Orders',
                  imageUrl:       'IconUrl',
                  title:         { label: 'Order ID', value: 'Orderid' },
                  description:   { type:   #STANDARD, value: 'PhaseName' }
                }

@UI.chart: [
            { //Chart  Total Quantity of Orders:
                //Tab1   by Country
              qualifier:             'OrdQuanByCountry',
              title:                 'By Countrys',
              chartType:              #LINE,
              dimensions:          [ 'CountryName'],
              measures:            [ 'CountByCountry'],
              dimensionAttributes: [{ dimension: 'CountryName',  role: #CATEGORY }],
              measureAttributes:   [{ measure:   'CountByCountry', role: #AXIS_1 }]
            },
            {   //Tab2   by Product Groups
              qualifier:             'OrdQuanByProdGr',
              title:                 'By Product Groups',
              chartType:              #COLUMN,
              dimensions:          [ 'ProductName'],
              measures:            [ 'CountByProdGrp'],
              dimensionAttributes: [{ dimension: 'ProductName',  role: #CATEGORY }],
              measureAttributes:   [{ measure:   'CountByProdGrp', role: #AXIS_1 }]
            },
           ------------------
            { //Chart AVG Income by Countries
              qualifier:            'AVGIncomeCountry',
              title:                'by Countries',
              chartType:             #DONUT,
              dimensions:          ['CountryName'],
              measures:            ['GrossIncomPercentage'],
              dimensionAttributes: [{ dimension: 'CountryName' } ],
              measureAttributes:   [{ measure:   'GrossIncomPercentage', role: #AXIS_1 }],
              actions: [{
                          semanticObjectAction: 'alpreportaction',
                          type:                 #FOR_INTENT_BASED_NAVIGATION
                       }]
            }
           ]
-----------------------------
@UI.presentationVariant: [
                          { //Chart  Total Quantity of Orders:
                              //Tab1   by Country
                            qualifier:      'pvOrdQuanByCountry',
                            visualizations: [{
                                               type:      #AS_CHART,
                                               qualifier: 'OrdQuanByCountry'
                                            }],
                            sortOrder:      [{ by: 'CountryName', direction: #ASC }]
                          },
                          {   //Tab2   by Product Groups
                            qualifier:      'pvOrdQuanByProdGr',
                            visualizations: [{
                                               type:      #AS_CHART,
                                               qualifier: 'OrdQuanByProdGr'
                                            }],
                            sortOrder:      [{ by: 'ProductName', direction: #ASC }]
                          }
                          ,
                         --------------
                          { //Chart AVG Income by Countries
                            qualifier:      'pvAVGIncomeCountry',
                            visualizations: [{
                                               type:      #AS_CHART,
                                               qualifier: 'AVGIncomeCountry'
                                            }],
                            sortOrder:      [{ by: 'CountryName',          direction: #ASC },
                                             { by: 'GrossIncomPercentage', direction: #DESC}]
                          },
                         --------------
                          { //ListCard  Orders List
                            qualifier:      'pvOrdersList',
                            visualizations: [{
                                               type:      #AS_LINEITEM,
                                               qualifier: 'OrdersList'
                                            }],
                            sortOrder: [
                                        {by: 'GrossIncomPercentage', direction: #DESC},
                                        {by: 'Orderid',              direction: #ASC }
                                       ]
                          }
                         ]

define view ZPA_C_OVP_CARDS_MARKET_ORDER
  as select from ZPA_I_OVP_MARKET_ORDER
{

      @UI.facet: [//StackCard  Orders List
                  {
                    isSummary:        true,
                    qualifier:       'StackOrdersList',
                    label:           'StackOrdersListGenInf',
                    type:             #FIELDGROUP_REFERENCE,
                    targetQualifier: 'StackOrdersListGenInf'
                  } ,
                  {
                    isSummary:        true,
                    qualifier:       'StackOrdersList',
                    label:           'StackOrdersListFD',
                    type:             #FIELDGROUP_REFERENCE,
                    targetQualifier: 'StackOrdersListFD'
                  }
                 ]

  key ProdUuid,
  key MrktUuid,
  key OrderUuid,

      @UI: {
             lineItem:        [{ //ListCard  Orders List
                                 qualifier: 'OrdersList',
                                 type:       #AS_DATAPOINT,
                                 position:   20,
                                 importance: #HIGH
                              }],
             dataPoint.title:   'Order ID',
             identification: [{ //StackCard  Orders List
                                qualifier:            'FaceSide',
                                position:              10,
                                label:                'Product ID'//,
                             }]
           }
      Orderid,

      Pgid,

      @UI: {
             lineItem:   [{ //ListCard  Orders List
                            qualifier: 'OrdersList',
                            position:   10,
                            importance: #HIGH
                         }],

             fieldGroup: [{ //StackCard  Orders List
                            qualifier: 'StackOrdersListGenInf',
                            position:   10,
                            label:     'Product Name'
                         }]
           }
      @UI.identification: [{ //StackCard  Orders List
                             qualifier:            'FlipSide',
                             position:              10
                          }]
      ProductName,

      @UI: {
             lineItem:   [{ //ListCard  Orders List
                            qualifier: 'OrdersList',
                            position:   20,
                            importance: #HIGH
                         }],

             fieldGroup: [{ //StackCard  Orders List
                            qualifier: 'StackOrdersListGenInf',
                            label:     'Market',
                            position:   20
                         }]
           }
      CountryName,

      //Chart Tab1 Total Quantity of Orders
      @UI.dataPoint: {
                       qualifier:               'dpOrdQuanByCountry',
                       criticalityCalculation: { improvementDirection: #MAXIMIZE,
                                                 toleranceRangeLowValue: 16,
                                                 deviationRangeLowValue: 10 }
                     }
      @Aggregation.default: #SUM
      @EndUserText.label: 'Quantity by Countrys'
      CountByCountry,

      //Chart Tab2 Total Quantity of Orders
      @UI.dataPoint: {
                       qualifier:               'dpOrdQuanByProdGr',
                       criticalityCalculation: { improvementDirection: #MAXIMIZE,
                                                 toleranceRangeLowValue: 25,
                                                 deviationRangeLowValue: 18 }
                     }
      @Aggregation.default: #SUM
      @EndUserText.label: 'Quantity by Product Groups'
      CountByProdGrp,

      PhaseName,


      @UI.fieldGroup: [{ //StackCard  Orders List
                         qualifier: 'StackOrdersListGenInf',
                         position:   30,
                         label:     'Year of Issue'
                      }]
      CalendarYear,

      @UI.fieldGroup: [{ //StackCard  Orders List
                         qualifier: 'StackOrdersListGenInf',
                         position:   40,
                         label: 'Delivery'
                      }]
      DeliveryDate,

      @UI.fieldGroup: [{ //StackCard  Orders List
                         qualifier: 'StackOrdersListFD',
                         position:   10,
                         label: 'Quantity, pieces'
                      }]
      Quantity,

      @UI.fieldGroup: [{ //StackCard  Orders List
                         qualifier: 'StackOrdersListFD',
                         position:   20,
                         label: 'Net Amount'
                      }]
      Netamount,

      @UI.fieldGroup: [{ //StackCard  Orders List
                         qualifier: 'StackOrdersListFD',
                         position:   30,
                         label: 'Gross Amount'
                      }]
      Grossamount,

      @UI:  {
              lineItem: [{ //ListCard  Orders List
                           qualifier: 'OrdersList',
                           position: 10,
                           type: #AS_DATAPOINT,
                           importance: #HIGH
                        }],
              dataPoint: {
                           valueFormat.numberOfFractionalDigits: 2,
                           valueFormat.scaleFactor: 1000000
                         },

              fieldGroup: [{ //StackCard  Orders List
                             qualifier: 'StackOrdersListFD',
                             position:   40,
                             label: 'Gross Income'
                          }]
            }
      GrossIncom,

      Amountcurr,


      @Consumption: {
                     semanticObject: 'alpsemantic',
                     semanticObjectMapping.additionalBinding: [
                                                               {
                                                                 localElement: 'CountryName',
                                                                 element: 'CountryName'
                                                               }
                                                              ]
                    }
      @UI:{
            dataPoint: { //Chart AVG Income by Countries (KPI)
                         qualifier: 'dpAVGIncomeCountry',
                         valueFormat.numberOfFractionalDigits: 1 ,
                         criticalityCalculation: { improvementDirection: #MAXIMIZE,
                                                   deviationRangeLowValue: 15,
                                                   toleranceRangeLowValue: 20 },
                         trendCalculation:       { referenceValue:'TargetGrossIncomPercentage',
                                                   downDifference: 0,
                                                   upDifference: 0 }
                       },

            fieldGroup: [{ //StackCard  Orders List
                           qualifier: 'StackOrdersListFD',
                           position:   50,
                           label: 'Gross Income Percentage'
                        }]
          }
      @EndUserText.label:   'Average Gross Income Percentage'
      @Aggregation.default: #AVG
      GrossIncomPercentage,

      Percentage,

      TargetGrossIncomPercentage,

      @UI: {
             lineItem:  [{ //ListCard  Orders List
                           qualifier: 'OrdersList',
                           position:   10,
                           importance: #HIGH,
                           type:       #AS_DATAPOINT
                        }],
             dataPoint: {
                          criticalityCalculation: { improvementDirection: #MAXIMIZE,
                                                    toleranceRangeLowValue: 20,
                                                    deviationRangeLowValue: 15 }
                        }
           }
      GrossIncomPercentageList,

      @UI.dataPoint: { //ListCard  Orders List (KPI)
                       qualifier: 'dpAVGIncomeCountryList',
                       valueFormat.numberOfFractionalDigits: 1 ,
                       criticalityCalculation: { improvementDirection: #MAXIMIZE,
                                                 deviationRangeLowValue: 15,
                                                 toleranceRangeLowValue: 20 },
                       trendCalculation:       { referenceValue:'TargetGrossIncomPercentageKPI' ,
                                                 downDifference: 0,
                                                 upDifference:   0 }
                     }
      @Aggregation.default: #MAX
      GrossIncomPercentageKPI,

      TargetGrossIncomPercentageKPI,

      @UI.identification: [{ //StackCard  Orders List
                             type:       #WITH_URL,
                             qualifier: 'FlipSide',
                             label:     'EPAM Global',
                             url:       'WebAddress',
                             position:   20
                          }]
      'https://www.epam.com/'         as WebAddress,

      @UI.identification: [{ //StackCard  Orders List
                             type:       #WITH_URL,
                             qualifier: 'FlipSide',
                             label:     'SAP',
                             url:       'WebAddress2',
                             position:   30
                          }]
      'https://store.sap.com/dcp/en/' as WebAddress2,

      //StackCard  Orders List
      'sap-icon://order-status'       as IconUrl
}
