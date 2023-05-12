CLASS zpa_cl_suppl_query_provider DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES: if_rap_query_provider.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zpa_cl_suppl_query_provider IMPLEMENTATION.


  METHOD if_rap_query_provider~select.

    DATA:
      lt_business_data TYPE TABLE OF zzplaa_supplier,
      lo_http_client   TYPE REF TO if_web_http_client,
      lo_client_proxy  TYPE REF TO /iwbep/if_cp_client_proxy,
      lo_request       TYPE REF TO /iwbep/if_cp_request_read_list,
      lo_response      TYPE REF TO /iwbep/if_cp_response_read_lst.


    TRY.
        " Create http client
        DATA(lo_destination) = cl_http_destination_provider=>create_by_url( i_url = 'https://services.odata.org' ).
        lo_http_client = cl_web_http_client_manager=>create_by_http_destination( i_destination = lo_destination ).
*DATA(lo_destination) = cl_http_destination_provider=>create_by_comm_arrangement(
*                                             comm_scenario  = '<Comm Scenario>'
*                                             comm_system_id = '<Comm System Id>'
*                                             service_id     = '<Service Id>' ).
*lo_http_client = cl_web_http_client_manager=>create_by_http_destination( lo_destination ).

        lo_client_proxy = cl_web_odata_client_factory=>create_v2_remote_proxy(
          EXPORTING
            iv_service_definition_name = 'ZPLA_SC_SUPPLIERS'
            io_http_client             = lo_http_client
            iv_relative_service_root   = 'V4/Northwind/Northwind.svc' ).

*lo_client_proxy = /iwbep/cl_cp_factory_alv5=>create_v2_remote_proxy(
*  EXPORTING
*    is_proxy_model_key       = value #( repository_id       = /iwbep/if_cp_registry_types=>gcs_repository_id-srvd
*                                        proxy_model_id      = 'ZPLA_SC_SUPPLIERS'
*                                        proxy_model_version = '0001' )
*    io_http_client             = lo_http_client
*    iv_relative_service_root   = '<service_root>' ).

**********************************************************************

        " Navigate to the resource and create a request for the read operation
        lo_request = lo_client_proxy->create_resource_for_entity_set( 'A_SUPPLIER' )->create_request_for_read( ).

        """Request Count
        IF io_request->is_total_numb_of_rec_requested( ).
          lo_request->request_count( ).
        ENDIF.

        """Request Data
        IF io_request->is_data_requested( ).
          """Request Paging
          DATA(ls_paging) = io_request->get_paging( ).
          IF ls_paging->get_offset( ) >= 0.
            lo_request->set_skip( ls_paging->get_offset( ) ).
          ENDIF.
          IF ls_paging->get_page_size( ) <>
         if_rap_query_paging=>page_size_unlimited.
            lo_request->set_top( ls_paging->get_page_size( ) ).
          ENDIF.
        ENDIF.

**********************************************************************

        DATA:
          lo_filter_factory          TYPE REF TO /iwbep/if_cp_filter_factory,
          lo_filter_node_1           TYPE REF TO /iwbep/if_cp_filter_node,
          lo_filter_node_2           TYPE REF TO /iwbep/if_cp_filter_node,
          lo_filter_node_root        TYPE REF TO /iwbep/if_cp_filter_node,
          lt_range_SUPPLIER          TYPE RANGE OF zzplaa_supplier,
          lt_range_ALTERNATIVENUMBER TYPE RANGE OF zzplaa_supplier.

        DATA ranges_table TYPE if_rap_query_filter=>tt_range_option .
        ranges_table = VALUE #( (  sign = 'I' option = 'GE' low = '000000' ) ).

        " Create the filter tree
        lo_filter_factory = lo_request->create_filter_factory( ).

        lo_filter_node_1  = lo_filter_factory->create_by_range( iv_property_path     = 'SUPPLIER'
                                                                it_range             = ranges_table ).
*lo_filter_node_2  = lo_filter_factory->create_by_range( iv_property_path     = 'ALTERNATIVEPAYEEACCOUNTNUMBER'
*                                                        it_range             = lt_range_ALTERNATIVENUMBER ).
*
        IF lo_filter_node_root IS INITIAL.
          lo_filter_node_root = lo_filter_node_1.
        ELSE.
          lo_filter_node_root = lo_filter_node_root->and( lo_filter_node_1 ).
        ENDIF.

*lo_filter_node_root = lo_filter_node_1->and( lo_filter_node_2 ).

        lo_request->set_filter( lo_filter_node_root ).


**********************************************************************
*
**********************************************************************
        " Execute the request and retrieve the business data
        lo_response = lo_request->execute( ).

        """Set Count
        IF io_request->is_total_numb_of_rec_requested( ).
          io_response->set_total_number_of_records( lo_response->get_count( ) ).
        ENDIF.

        lo_response->get_business_data( IMPORTING et_business_data = lt_business_data ).

**********************************************************************

      CATCH /iwbep/cx_cp_remote INTO DATA(lx_remote).
        " Handle remote Exception
        " It contains details about the problems of your http(s) connection

      CATCH /iwbep/cx_gateway INTO DATA(lx_gateway).
        " Handle Exception

    ENDTRY.
  ENDMETHOD.

ENDCLASS.
