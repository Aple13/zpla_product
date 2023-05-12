@EndUserText.label: 'Custom entity Business Partner'
@ObjectModel.query.implementedBy: 'ABAP:ZPA_CL_BP_QUERY_PROVIDER'
define custom entity zpa_i_business_partner_c

{
  key BusinessPartner                : abap.char( 10 );

      @OData.property.valueControl   : 'BusinessPartnerGrouping_vc'
      BusinessPartnerGrouping        : abap.char( 4 );
      BusinessPartnerGrouping_vc     : rap_cp_odata_value_control;

      @OData.property.valueControl   : 'BusinessPartnerName_vc'
      BusinessPartnerName            : abap.char( 81 );
      BusinessPartnerName_vc         : rap_cp_odata_value_control;

}
