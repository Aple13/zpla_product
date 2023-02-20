CLASS lhc_Product DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

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

ENDCLASS.

CLASS lhc_Product IMPLEMENTATION.

  METHOD get_instance_features.
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
**    markets_cba  TYPE TABLE FOR CREATE zpa_i_product\\product\_market,
**    orders_cba TYPE TABLE FOR CREATE zpa_i_product\\market\_order.
**
    READ ENTITIES OF zpa_i_product IN LOCAL MODE
      ENTITY Product
       ALL FIELDS WITH CORRESPONDING #( keys )
                  RESULT DATA(product_read_result)
     FAILED    failed
     REPORTED  reported.

** to add read eml for another entities - market, order
***********************************************************************
**READ ENTITIES OF /DMO/I_Travel_M IN LOCAL MODE
**      ENTITY travel BY \_booking
**        ALL FIELDS WITH CORRESPONDING #( travel_read_result )
**                   RESULT DATA(book_read_result).
**
**    READ ENTITIES OF /DMO/I_Travel_M IN LOCAL MODE
**      ENTITY booking BY \_booksupplement
**       ALL FIELDS WITH CORRESPONDING #( book_read_result )
**                  RESULT DATA(booksuppl_read_result).
***********************************************************************
*
*
    DATA(lv_date) = cl_abap_context_info=>get_system_time( ).
    DATA(lv_user)  = cl_abap_context_info=>get_user_alias( ).
    TRY.
        DATA(lv_uuid)  = cl_system_uuid=>create_uuid_x16_static( ).
      CATCH cx_uuid_error .
    ENDTRY.
*
    LOOP AT keys INTO DATA(key).
      DATA(lv_prodid) = key-%param.
    ENDLOOP.
*
    LOOP AT product_read_result ASSIGNING FIELD-SYMBOL(<product>).
      APPEND VALUE #(
                      %data = CORRESPONDING #( <product> EXCEPT Produuid Prodid )
                      Produuid     = lv_uuid
                      Prodid = lv_prodid
                      Phaseid = '1' )
                        TO products ASSIGNING FIELD-SYMBOL(<new_product>).
*      APPEND VALUE #( %cid_ref = <product>-travel_id )
*                        TO market_cba ASSIGNING FIELD-SYMBOL(<markets_cba>).

*
** Implement LOOP statement after creating new entities - market, ordder
***********************************************************************
**      LOOP AT book_read_result ASSIGNING FIELD-SYMBOL(<booking>) USING KEY entity WHERE travel_id EQ <travel>-travel_id.
**        APPEND VALUE #( %cid     = <travel>-travel_id && <booking>-booking_id
**                        %data    = CORRESPONDING #( <booking> EXCEPT travel_id ) ) TO <bookings_cba>-%target ASSIGNING FIELD-SYMBOL(<new_booking>).
**        APPEND VALUE #( %cid_ref = <travel>-travel_id && <booking>-booking_id ) TO booksuppl_cba ASSIGNING FIELD-SYMBOL(<booksuppl_cba>).
**
**        <new_booking>-booking_status = 'N'.
**
**        LOOP AT booksuppl_read_result ASSIGNING FIELD-SYMBOL(<booksuppl>) USING KEY entity WHERE travel_id  EQ <travel>-travel_id
**                                                                                           AND   booking_id EQ <booking>-booking_id.
**          APPEND VALUE #( %cid  = <travel>-travel_id && <booking>-booking_id && <booksuppl>-booking_supplement_id
**                          %data = CORRESPONDING #( <booksuppl> EXCEPT travel_id booking_id ) ) TO <booksuppl_cba>-%target.
**        ENDLOOP.
**      ENDLOOP.
***********************************************************************
    ENDLOOP.
*
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
*        CREATE BY \_Booking FIELDS ( booking_id booking_date customer_id carrier_id connection_id flight_date flight_price currency_code booking_status )
*          WITH bookings_cba
*      ENTITY booking
*        CREATE BY \_BookSupplement FIELDS ( booking_supplement_id supplement_id price currency_code )
*          WITH booksuppl_cba
      MAPPED mapped
      FAILED DATA(failed_create)
      REPORTED DATA(reported_create).
*
*
      result = VALUE #( FOR product IN products INDEX INTO idx
                        (
                          %tky   = keys[ idx ]-%tky
                          %param = CORRESPONDING #( product )
                        )
                    ) .
*
*
*
**      READ ENTITIES OF zpa_i_product IN LOCAL MODE
**       ENTITY Product
**         ALL FIELDS WITH CORRESPONDING #( mapped-product )
**         RESULT DATA(read_created_result).
*
*
*
**    result = VALUE #( FOR new IN read_created_result ( %param = new  %tky = new-%tky ) ).
**    result = CORRESPONDING #( result FROM mapped-product USING KEY entity  ProdUuid = ProdUuid MAPPING ProdUuid = %cid     ).
**    result = CORRESPONDING #( result FROM keys          USING KEY entity  ProdUuid = ProdUuid MAPPING %cid_ref  = %cid_ref ).


  ENDMETHOD.


ENDCLASS.
