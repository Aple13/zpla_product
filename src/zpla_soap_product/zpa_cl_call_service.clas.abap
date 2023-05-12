CLASS zpa_cl_call_service DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zpa_cl_call_service IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
  try.
    data(destination) = cl_soap_destination_provider=>create_by_url( i_url = 'http://webservices.oorsprong.org/websamples.countryinfo/CountryInfoService.wso' ).
    data(proxy) = new zpa_co_country_info_service_so(
                    destination = destination
                  ).
    data(request) = value zpa_country_isocode_soap_reque( s_country_name = 'Japan').
    proxy->country_isocode(
      exporting
        input = request
      importing
        output = data(response)
    ).

    "handle response
  catch cx_soap_destination_error.
    "handle error
  catch cx_ai_system_fault.
    "handle error
endtry.


  ENDMETHOD.
ENDCLASS.
