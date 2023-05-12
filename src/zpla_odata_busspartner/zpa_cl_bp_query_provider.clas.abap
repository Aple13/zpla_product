CLASS zpa_cl_bp_query_provider DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .

    TYPES t_partner_range TYPE RANGE OF ZPAA_BUSINESSPARTNER8BFC5695AF-BusinessPartner.
    TYPES t_busspartner_data TYPE TABLE OF ZPAA_BUSINESSPARTNER8BFC5695AF.

    METHODS get_busspartners
      IMPORTING
        filter_cond        TYPE if_rap_query_filter=>tt_name_range_pairs   OPTIONAL
        top                TYPE i OPTIONAL
        skip               TYPE i OPTIONAL
        is_data_requested  TYPE abap_bool
        is_count_requested TYPE abap_bool
      EXPORTING
        business_data      TYPE t_busspartner_data
        count              TYPE int8
      RAISING
        /iwbep/cx_cp_remote
        /iwbep/cx_gateway
        cx_web_http_client_error
        cx_http_dest_provider_error
      .


    INTERFACES if_rap_query_provider .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zpa_cl_bp_query_provider IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
    DATA business_data TYPE t_busspartner_data.
    DATA count TYPE int8.
    DATA filter_conditions  TYPE if_rap_query_filter=>tt_name_range_pairs .
    DATA ranges_table TYPE if_rap_query_filter=>tt_range_option .
    ranges_table = VALUE #( (  sign = 'I' option = 'GE' low = '0' ) ).
    filter_conditions = VALUE #( ( name = 'BUSINESSPARTNER'  range = ranges_table ) ).

    TRY.
        get_busspartners(
          EXPORTING
*            filter_cond        = filter_conditions
*            top                = 3
*            skip               = 1
            is_count_requested = abap_true
            is_data_requested  = abap_true
          IMPORTING
            business_data  = business_data
            count          = count
          ) .
        out->write( |Total number of records = { count }| ) .
        out->write( business_data ).
      CATCH cx_root INTO DATA(exception).
        out->write( cl_message_helper=>get_latest_t100_exception( exception )->if_message~get_longtext( ) ).
    ENDTRY.
  ENDMETHOD.


  METHOD if_rap_query_provider~select.
  ENDMETHOD.

  METHOD get_busspartners.

DATA:
  lt_business_data TYPE TABLE OF ZPAA_BUSINESSPARTNER8BFC5695AF,
  lo_http_client   TYPE REF TO if_web_http_client,
  lo_client_proxy  TYPE REF TO /iwbep/if_cp_client_proxy,
  lo_request       TYPE REF TO /iwbep/if_cp_request_read_list,
  lo_response      TYPE REF TO /iwbep/if_cp_response_read_lst.

DATA:
 lo_filter_factory   TYPE REF TO /iwbep/if_cp_filter_factory,
 lo_filter_node_1    TYPE REF TO /iwbep/if_cp_filter_node,
 lo_filter_node_2    TYPE REF TO /iwbep/if_cp_filter_node,
 lo_filter_node_root TYPE REF TO /iwbep/if_cp_filter_node,
 lt_range_BUSINESSPARTNER TYPE RANGE OF ZPAA_BUSINESSPARTNER8BFC5695AF-BusinessPartner,
 lt_range_CUSTOMER TYPE RANGE OF ZPAA_BUSINESSPARTNER8BFC5695AF-BusinessPartner.

DATA service_consumption_name TYPE cl_web_odata_client_factory=>ty_service_definition_name.


     TRY.
     " Create http client
DATA(lo_destination) = cl_http_destination_provider=>create_by_url( i_url = 'https://my303843.s4hana.ondemand.com' ).
lo_http_client = cl_web_http_client_manager=>create_by_http_destination( i_destination = lo_destination ).

lo_http_client->get_http_request( )->set_authorization_basic( i_username = 'POSTMAN_USER'
                                                              i_password = 'bLaPPuUkMMmDJGzgklwHQQqfJLlAPSi[5ekDKgxL' ).

service_consumption_name = to_upper( 'ZPA_SC_BUSINESS_PARTNER' ).

     lo_client_proxy = cl_web_odata_client_factory=>create_v2_remote_proxy(
       EXPORTING
         iv_service_definition_name = service_consumption_name
         io_http_client             = lo_http_client
         iv_relative_service_root   = '/sap/opu/odata/sap/API_BUSINESS_PARTNER' ).

*lo_client_proxy = /iwbep/cl_cp_factory_alv5=>create_v2_remote_proxy(
*  EXPORTING
*    is_proxy_model_key       = value #( repository_id       = /iwbep/if_cp_registry_types=>gcs_repository_id-srvd
*                                        proxy_model_id      = 'ZPA_SC_BUSINESS_PARTNER'
*                                        proxy_model_version = '0001' )
*    io_http_client             = lo_http_client
*    iv_relative_service_root   = '/sap/opu/odata/sap/API_BUSINESS_PARTNER/' ).



" Navigate to the resource and create a request for the read operation
lo_request = lo_client_proxy->create_resource_for_entity_set( 'A_BUSINESSPARTNER' )->create_request_for_read( ).


**********************************************************************
* From lesson
**********************************************************************
*    " Create the filter tree
*    filter_factory = lo_request->create_filter_factory( ).
*    LOOP AT  filter_cond  INTO DATA(filter_condition).
*      filter_node  = filter_factory->create_by_range( iv_property_path     = filter_condition-name
*                                                              it_range     = filter_condition-range ).
*      IF root_filter_node IS INITIAL.
*        root_filter_node = filter_node.
*      ELSE.
*        root_filter_node = root_filter_node->and( filter_node ).
*      ENDIF.
*    ENDLOOP.
*
*    IF root_filter_node IS NOT INITIAL.
*      lo_request->set_filter( root_filter_node ).
*    ENDIF.
*
*    IF is_data_requested = abap_true.
*      lo_request->set_skip( skip ).
*      IF top > 0 .
*        lo_request->set_top( top ).
*      ENDIF.
*    ENDIF.
*
*    IF is_count_requested = abap_true.
*      lo_request->request_count(  ).
*    ENDIF.
*
*    IF is_data_requested = abap_false.
*      lo_request->request_no_business_data(  ).
*    ENDIF.
*
    " Execute the request and retrieve the business data and count if requested
    lo_response = lo_request->execute( ).
    IF is_data_requested = abap_true.
      lo_response->get_business_data( IMPORTING et_business_data = business_data ).
    ENDIF.
    IF is_count_requested = abap_true.
      count = lo_response->get_count(  ).
    ENDIF.

**********************************************************************
* From Service Consumption
**********************************************************************
" Create the filter tree
lo_filter_factory = lo_request->create_filter_factory( ).

lo_filter_node_1  = lo_filter_factory->create_by_range( iv_property_path     = 'BUSINESSPARTNER'
                                                        it_range             = lt_range_BUSINESSPARTNER ).
lo_filter_node_2  = lo_filter_factory->create_by_range( iv_property_path     = 'CUSTOMER'
                                                        it_range             = lt_range_CUSTOMER ).

lo_filter_node_root = lo_filter_node_1->and( lo_filter_node_2 ).
lo_request->set_filter( lo_filter_node_root ).

lo_request->set_top( 50 )->set_skip( 0 ).

" Execute the request and retrieve the business data
lo_response = lo_request->execute( ).
lo_response->get_business_data( IMPORTING et_business_data = lt_business_data ).

  CATCH /iwbep/cx_cp_remote INTO DATA(lx_remote).
" Handle remote Exception
" It contains details about the problems of your http(s) connection

CATCH /iwbep/cx_gateway INTO DATA(lx_gateway).
" Handle Exception

ENDTRY.
  ENDMETHOD.

ENDCLASS.
