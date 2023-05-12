CLASS lhc_Product DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    CONSTANTS:
      BEGIN OF out_phase,
        out TYPE c LENGTH 1  VALUE '4',
      END OF out_phase.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR Product RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Product RESULT result.
    METHODS setphaseid FOR DETERMINE ON SAVE
      IMPORTING keys FOR product~setphaseid.
    METHODS validateproductgroup FOR VALIDATE ON SAVE
      IMPORTING keys FOR product~validateproductgroup.
    METHODS validateproductid FOR VALIDATE ON SAVE
      IMPORTING keys FOR product~validateproductid.
    METHODS copyproduct FOR MODIFY
      IMPORTING keys FOR ACTION product~copyproduct RESULT result.
    METHODS movetonextphase FOR MODIFY
      IMPORTING keys FOR ACTION product~movetonextphase RESULT result.
    METHODS setpgnametranslation FOR DETERMINE ON SAVE
      IMPORTING keys FOR product~setpgnametranslation.
*    METHODS calculateamount FOR DETERMINE ON MODIFY
*      IMPORTING keys FOR product~calculateamount.

ENDCLASS.

CLASS lhc_Product IMPLEMENTATION.

  METHOD get_instance_features.
    READ ENTITIES OF zpa_i_product IN LOCAL MODE
        ENTITY Product
            FIELDS ( PhaseId ) WITH CORRESPONDING #( keys )
    RESULT DATA(products)
    FAILED failed.

    result =
      VALUE #(
        FOR product IN products
          LET is_out   =   COND #( WHEN product-Phaseid = out_phase-out
                                         THEN if_abap_behv=>fc-o-disabled
                                         ELSE if_abap_behv=>fc-o-enabled )
          IN
            ( %tky             = product-%tky
              %action-moveToNextPhase  = is_out
             ) ).
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD setPhaseid.
    READ ENTITIES OF zpa_i_product IN LOCAL MODE
        ENTITY Product
          FIELDS ( Phaseid ) WITH CORRESPONDING #( keys )
        RESULT DATA(products).

    DELETE products WHERE Phaseid IS NOT INITIAL.

    CHECK products IS NOT INITIAL.

    MODIFY ENTITIES OF zpa_i_product IN LOCAL MODE
    ENTITY Product
      UPDATE
        FROM VALUE #( FOR product IN products INDEX INTO i (
          %tky             = product-%tky
          Phaseid         = '1'
          %control-Phaseid = if_abap_behv=>mk-on ) )
    REPORTED DATA(update_reported).

    reported = CORRESPONDING #( DEEP update_reported ).
  ENDMETHOD.

  METHOD validateProductGroup.
    READ ENTITIES OF zpa_i_product IN LOCAL MODE
        ENTITY Product
          FIELDS ( Pgid ) WITH CORRESPONDING #( keys )
        RESULT DATA(products).

    DATA pgroups TYPE SORTED TABLE OF zpa_d_prod_group WITH UNIQUE KEY pgid.

    pgroups = CORRESPONDING #( products DISCARDING DUPLICATES MAPPING pgid = Pgid EXCEPT * ).
    DELETE pgroups WHERE pgid IS INITIAL.

    IF pgroups IS NOT INITIAL.
      SELECT FROM zpa_d_prod_group FIELDS pgid
        FOR ALL ENTRIES IN @pgroups
        WHERE pgid = @pgroups-pgid
        INTO TABLE @DATA(pgroups_db).
    ENDIF.

    LOOP AT products INTO DATA(product).

      APPEND VALUE #(
          %tky = product-%tky
          %state_area        = 'VALIDATE_PGROUPS' )
            TO reported-product.

      IF product-Pgid IS INITIAL OR NOT line_exists( pgroups_db[ pgid = product-Pgid ] ).
        APPEND VALUE #(  %tky = product-%tky ) TO failed-product.

        APPEND VALUE #(  %tky        = product-%tky
                         %state_area = 'VALIDATE_PGROUPS'
                         %msg        = NEW zcm_pa_product(
                                           severity   = if_abap_behv_message=>severity-error
                                           textid     = zcm_pa_product=>pgroup_unknown
                                           pgid = product-Pgid )
                         %element-Pgid = if_abap_behv=>mk-on )
          TO reported-product.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD validateProductId.
    READ ENTITIES OF zpa_i_product IN LOCAL MODE
        ENTITY Product
          FIELDS ( Prodid ) WITH CORRESPONDING #( keys )
        RESULT DATA(products).

    DATA productid TYPE SORTED TABLE OF zpa_d_product WITH UNIQUE KEY prodid.

    productid = CORRESPONDING #( products DISCARDING DUPLICATES MAPPING prodid = Prodid EXCEPT * ).
    DELETE productid WHERE prodid IS INITIAL.

    IF productid IS NOT INITIAL.
      SELECT FROM zpa_d_product FIELDS prodid
        FOR ALL ENTRIES IN @productid
        WHERE prodid = @productid-prodid
        INTO TABLE @DATA(productid_db).
    ENDIF.

    LOOP AT products INTO DATA(product).

      APPEND VALUE #(
        %tky = product-%tky
        %state_area        = 'VALIDATE_PRODUCTID' )
          TO reported-product.

      IF line_exists( productid_db[ prodid = product-Prodid ] ).
        APPEND VALUE #(  %tky = product-%tky ) TO failed-product.

        APPEND VALUE #(  %tky        = product-%tky
                         %state_area = 'VALIDATE_PRODUCTID'
                         %msg        = NEW zcm_pa_product(
                                           severity   = if_abap_behv_message=>severity-error
                                           textid     = zcm_pa_product=>productid_exist
                                           prodid = product-Prodid )
                         %element-Prodid = if_abap_behv=>mk-on )
          TO reported-product.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD copyProduct.
    DATA:
      products       TYPE TABLE FOR CREATE zpa_i_product\\product.

    READ ENTITIES OF zpa_i_product IN LOCAL MODE
      ENTITY Product
       ALL FIELDS WITH CORRESPONDING #( keys )
                  RESULT DATA(product_read_result)
     FAILED    failed
     REPORTED  reported.

    DATA(lv_date) = cl_abap_context_info=>get_system_time( ).
    DATA(lv_user)  = cl_abap_context_info=>get_user_alias( ).
    TRY.
        DATA(lv_uuid)  = cl_system_uuid=>create_uuid_x16_static( ).
      CATCH cx_uuid_error .
    ENDTRY.

    LOOP AT keys INTO DATA(key).
      DATA(lv_prodid) = key-%param.
    ENDLOOP.

    LOOP AT product_read_result ASSIGNING FIELD-SYMBOL(<product>).
      APPEND VALUE #(
                      %data = CORRESPONDING #( <product> EXCEPT Produuid Prodid )
                      Produuid     = lv_uuid
                      Prodid = lv_prodid
                      Phaseid = '1' )
                        TO products ASSIGNING FIELD-SYMBOL(<new_product>).
    ENDLOOP.

    MODIFY ENTITIES OF zpa_i_product IN LOCAL MODE
      ENTITY Product
        CREATE FIELDS ( ProdUuid
                        Prodid
                        Pgid
                        Phaseid
                        Height
                        Width
                        Depth
                        Price
                        PriceCurrency
                        Taxrate
                        SizeUom )
          WITH products

      MAPPED mapped
      FAILED DATA(failed_create)
      REPORTED DATA(reported_create).

    result = VALUE #( FOR product IN products INDEX INTO idx
                      (
                        %tky   = keys[ idx ]-%tky
                        %param = CORRESPONDING #( product )
                      )
                  ) .
  ENDMETHOD.


  METHOD moveToNextPhase.

    DATA: tt_phase TYPE TABLE FOR UPDATE zpa_i_product\\Product.

    READ ENTITIES OF zpa_i_product IN LOCAL MODE
        ENTITY Product
         FIELDS ( PhaseId ) WITH CORRESPONDING #( keys )
                    RESULT DATA(product_read_result)
       FAILED    failed
       REPORTED  reported.

    LOOP AT product_read_result ASSIGNING FIELD-SYMBOL(<ls_phase>).

      CASE <ls_phase>-PhaseId.

        WHEN 1.
          READ ENTITIES OF zpa_i_product IN LOCAL MODE
            ENTITY Product BY \_ProdMrkt
                FIELDS ( Mrktid ProdUuid ) WITH CORRESPONDING #( keys )
            RESULT DATA(mrktids).

          IF mrktids IS NOT INITIAL.
            <ls_phase>-PhaseId = <ls_phase>-PhaseId + 1.
          ELSE.
            APPEND VALUE #(  %tky = <ls_phase>-%tky ) TO failed-product.

            APPEND VALUE #(  %tky        = <ls_phase>-%tky
                             %state_area = 'ACTION_PHASE_1'
                             %msg        = NEW zcm_pa_product(
                                               severity   = if_abap_behv_message=>severity-error
                                               textid     = zcm_pa_product=>phase_1
                                               phaseid = <ls_phase>-Phaseid )
                             %element-PhaseId = if_abap_behv=>mk-on
                              )
              TO reported-product.
          ENDIF.

        WHEN 2.
          READ ENTITIES OF zpa_i_product IN LOCAL MODE
            ENTITY Product BY \_ProdMrkt
                FIELDS ( Status ) WITH CORRESPONDING #( keys )
            RESULT DATA(status).

          LOOP AT status ASSIGNING FIELD-SYMBOL(<ls_status>).
            IF <ls_status>-Status = 'X'.
              DATA(lv_status) = 'X'.
              EXIT.
            ENDIF.
          ENDLOOP.

          IF lv_status = 'X'.
            <ls_phase>-PhaseId = <ls_phase>-PhaseId + 1.
          ELSE.
            APPEND VALUE #(  %tky = <ls_phase>-%tky ) TO failed-product.

            APPEND VALUE #(  %tky        = <ls_phase>-%tky
                             %state_area = 'ACTION_PHASE_2'
                             %msg        = NEW zcm_pa_product(
                                               severity   = if_abap_behv_message=>severity-error
                                               textid     = zcm_pa_product=>phase_2
                                               phaseid = <ls_phase>-Phaseid )
                             %element-PhaseId = if_abap_behv=>mk-on
                              )
              TO reported-product.
          ENDIF.

        WHEN 3.
          READ ENTITIES OF zpa_i_product IN LOCAL MODE
              ENTITY Product BY \_ProdMrkt
                  FIELDS ( Enddate ) WITH CORRESPONDING #( keys )
              RESULT DATA(dates).

          DATA(lv_today) = cl_abap_context_info=>get_system_date( ).

          LOOP AT dates ASSIGNING FIELD-SYMBOL(<ls_date>).
            IF <ls_date>-Enddate > lv_today.
              DATA(lv_date) = 'X'.
              EXIT.
            ENDIF.
          ENDLOOP.

          IF lv_date <> 'X'.
            <ls_phase>-PhaseId = <ls_phase>-PhaseId + 1.
          ELSE.
            APPEND VALUE #(  %tky = <ls_phase>-%tky ) TO failed-product.

            APPEND VALUE #(  %tky        = <ls_phase>-%tky
                             %state_area = 'ACTION_PHASE_3'
                             %msg        = NEW zcm_pa_product(
                                               severity   = if_abap_behv_message=>severity-error
                                               textid     = zcm_pa_product=>phase_3
                                               phaseid = <ls_phase>-Phaseid )
                             %element-PhaseId = if_abap_behv=>mk-on
                              )
              TO reported-product.
          ENDIF.

      ENDCASE.

      APPEND VALUE #(
                %tky             = <ls_phase>-%tky
                PhaseID          = <ls_phase>-PhaseId
                %control-PhaseID = if_abap_behv=>mk-on
                       ) TO tt_phase.
    ENDLOOP.

    MODIFY ENTITIES OF zpa_i_product IN LOCAL MODE
    ENTITY Product
       UPDATE
         FIELDS ( PhaseId ) WITH tt_phase.


    READ ENTITIES OF zpa_i_product IN LOCAL MODE
        ENTITY Product
    ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(products).

    result = VALUE #( FOR product IN products
                        ( %tky   = product-%tky
                          %param = product ) ).

  ENDMETHOD.

*  METHOD calculateAmount.
*    MODIFY ENTITIES OF zpa_i_product IN LOCAL MODE
*    ENTITY mrktorder
*      EXECUTE recalculateAmount
*      FROM CORRESPONDING #( keys )
*    REPORTED DATA(execute_reported).
*
*    reported = CORRESPONDING #( DEEP execute_reported ).
*  ENDMETHOD.

  METHOD setPgnameTranslation.
    READ ENTITIES OF zpa_i_product IN LOCAL MODE
          ENTITY Product
            FIELDS ( Pgname TransCode ) WITH CORRESPONDING #( keys )
          RESULT DATA(TransPGName).

    DELETE TransPGName WHERE Pgid IS INITIAL AND TransCode IS INITIAL.
    CHECK TransPGName IS NOT INITIAL.

    DATA lv_translate TYPE zpla_pg_name.

    LOOP AT TransPGName ASSIGNING FIELD-SYMBOL(<Transpgname>).
      TRANSLATE <Transpgname>-TransCode+0(2) TO LOWER CASE.
      CONCATENATE
                'https://dictionary.yandex.net/api/v1/dicservice/lookup?key='
                'dict.1.1.20230420T075824Z.40c97a04bf9203c9.4cfa58424f96683d29ada52aba4a2bea41d32a51'
                '&lang=en-'
                <Transpgname>-TransCode
                '&text='
                <Transpgname>-Pgname
      INTO DATA(url_result).

      REPLACE ALL OCCURRENCES OF ` ` IN url_result WITH '%20'.

    ENDLOOP.

    DATA(lo_destination) = cl_http_destination_provider=>create_by_url( i_url = url_result ).
    DATA(lo_http_client) = cl_web_http_client_manager=>create_by_http_destination( i_destination = lo_destination ).

    DATA(lo_request) = lo_http_client->get_http_request(  ).

    DATA(lo_response) = lo_http_client->execute( i_method = if_web_http_client=>get ).

    DATA(lo_text_xml) = lo_response->get_text(  ).

    TYPES:
      BEGIN OF ls_tr,
        text TYPE string,
        syn  TYPE string,
        mean TYPE string,
        ex   TYPE string,
      END OF ls_tr,
      lt_tr_table TYPE STANDARD TABLE OF ls_tr WITH EMPTY KEY,

      BEGIN OF ls_def,
        text TYPE string,
        tr   TYPE lt_tr_table,
      END OF ls_def,
      lt_def_table TYPE STANDARD TABLE OF ls_def WITH EMPTY KEY,

      BEGIN OF ls_result,
        head TYPE string,
        def  TYPE lt_def_table,
      END OF ls_result.

      DATA lt_result TYPE STANDARD TABLE OF ls_result WITH EMPTY KEY.


    TRY.

*CALL TRANSFORMATION zpa_tr_translate
*SOURCE XML lo_text_xml
*RESULT result = lv_translate.
      CATCH cx_root.
    ENDTRY.

    lv_translate = lo_response->get_text(  ).

**********************************************************************
* url = https://dictionary.yandex.net/api/v1/dicservice/lookup?key=API-ключ&lang=en-ru&text=time
* key = API - dict.1.1.20230418T095939Z.7643dd81b22f3dec.475203ce19a5812a09b1e139063da925169311f0
* lang = en - TransCode
* text = Pgname
*
* CONCATENATE
*               'https://dictionary.yandex.net/api/v1/dicservice/lookup?key=API-'
*               'dict.1.1.20230418T095939Z.7643dd81b22f3dec.475203ce19a5812a09b1e139063da925169311f0'
*               '&lang=en-'
*               TransCode
*               '&text='
*               Pgname
*   INTO DATA(url-result).
**********************************************************************

    MODIFY ENTITIES OF zpa_i_product IN LOCAL MODE
    ENTITY Product
      UPDATE
      FIELDS ( PgnameTrans )
      WITH VALUE #( FOR translate IN TransPGName (
          %tky        = translate-%tky
          PgnameTrans = lv_translate ) )
    REPORTED DATA(update_reported).

    reported = CORRESPONDING #( DEEP update_reported ).
  ENDMETHOD.

ENDCLASS.
