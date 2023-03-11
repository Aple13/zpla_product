CLASS lhc_mrktorder DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS validateDeliveryDate FOR VALIDATE ON SAVE
      IMPORTING keys FOR MrktOrder~validateDeliveryDate.
    METHODS calculateOrderId FOR DETERMINE ON SAVE
      IMPORTING keys FOR MrktOrder~calculateOrderId.
    METHODS setCalendarYear FOR DETERMINE ON MODIFY
      IMPORTING keys FOR MrktOrder~setCalendarYear.
    METHODS recalculateAmount FOR MODIFY
      IMPORTING keys FOR ACTION MrktOrder~recalculateAmount.

    METHODS calculateAmount FOR DETERMINE ON MODIFY
      IMPORTING keys FOR MrktOrder~calculateAmount.

ENDCLASS.

CLASS lhc_mrktorder IMPLEMENTATION.

  METHOD validateDeliveryDate.
    READ ENTITIES OF zpa_i_product IN LOCAL MODE
        ENTITY ProdMrkt
        FIELDS ( Startdate Enddate )
            WITH CORRESPONDING #( keys )
    RESULT DATA(marketdates).

    READ ENTITIES OF zpa_i_product IN LOCAL MODE
        ENTITY MrktOrder
        FIELDS ( DeliveryDate )
            WITH CORRESPONDING #( keys )
    RESULT DATA(deliverydates).

    LOOP AT marketdates INTO DATA(marketdate).
      LOOP AT deliverydates INTO DATA(deliverydate).

        APPEND VALUE #(
            %tky        = deliverydate-%tky
            %state_area = 'VALIDATE_DELIVERY_DATE' )
              TO reported-mrktorder.

        IF deliverydate-DeliveryDate <= marketdate-Startdate.

          APPEND VALUE #( %tky        = deliverydate-%tky ) TO failed-MrktOrder.

          APPEND VALUE #(  %tky        = deliverydate-%tky
                           %state_area = 'VALIDATE_DELIVERY_DATE'
                           %path       = VALUE #( Product-%is_draft = deliverydate-%is_draft
                                                  Product-ProdUuid = deliverydate-ProdUuid
*                                                ProdMrkt-MrktUuid = deliverydate-MrktUuid
                                                   )
                           %msg        = NEW zcm_pa_product(
                                             severity   = if_abap_behv_message=>severity-error
                                             textid     = zcm_pa_product=>delivery_date_error_start
                                              )
                           %element-DeliveryDate = if_abap_behv=>mk-on
                        ) TO reported-mrktorder.

        ELSEIF deliverydate-DeliveryDate > marketdate-Enddate.

          APPEND VALUE #( %tky        = deliverydate-%tky ) TO failed-MrktOrder.

          APPEND VALUE #(  %tky        = deliverydate-%tky
                           %state_area = 'VALIDATE_DELIVERY_DATE'
                           %path       = VALUE #( Product-%is_draft = deliverydate-%is_draft
                                                  Product-ProdUuid = deliverydate-ProdUuid
*                                                ProdMrkt-MrktUuid = deliverydate-MrktUuid
                                                   )
                           %msg        = NEW zcm_pa_product(
                                             severity   = if_abap_behv_message=>severity-error
                                             textid     = zcm_pa_product=>delivery_date_error_end
                                              )
                           %element-DeliveryDate = if_abap_behv=>mk-on
                        ) TO reported-mrktorder.
        ENDIF.

      ENDLOOP.
    ENDLOOP.
  ENDMETHOD.

  METHOD calculateOrderId.
    READ ENTITIES OF zpa_i_product IN LOCAL MODE
    ENTITY MrktOrder
      FIELDS ( OrderId ) WITH CORRESPONDING #( keys )
    RESULT DATA(orders).

    DELETE orders WHERE OrderId IS NOT INITIAL.
    CHECK orders IS NOT INITIAL.

    SELECT SINGLE
        FROM  zpa_d_mrkt_order
        FIELDS MAX( orderid ) AS OrderId
        INTO @DATA(max_orderid).

    MODIFY ENTITIES OF zpa_i_product IN LOCAL MODE
    ENTITY MrktOrder
      UPDATE
        FROM VALUE #( FOR order IN orders INDEX INTO i (
          %tky             = order-%tky
          OrderId          = max_orderid + i
          %control-OrderId = if_abap_behv=>mk-on ) )
    REPORTED DATA(update_reported).

    reported = CORRESPONDING #( DEEP update_reported ).
  ENDMETHOD.

  METHOD setCalendarYear.
    READ ENTITIES OF zpa_i_product IN LOCAL MODE
        ENTITY MrktOrder
        FIELDS ( DeliveryDate )
            WITH CORRESPONDING #( keys )
    RESULT DATA(deliverydates).

    DATA lv_year TYPE zpla_year.

    LOOP AT deliverydates ASSIGNING FIELD-SYMBOL(<ls_year>).
      lv_year = <ls_year>-DeliveryDate+0(4).


      MODIFY ENTITIES OF zpa_i_product IN LOCAL MODE
      ENTITY MrktOrder
        UPDATE
          FROM VALUE #( FOR year IN deliverydates INDEX INTO i (
            %tky                  = year-%tky
            CalendarYear          = lv_year
            %control-CalendarYear = if_abap_behv=>mk-on ) )
      REPORTED DATA(update_reported).

      reported = CORRESPONDING #( DEEP update_reported ).
    ENDLOOP.

  ENDMETHOD.

  METHOD recalculateAmount.
*    TYPES: BEGIN OF ty_amount_per_currencycode,
*             netamount     TYPE zpla_netamount,
*             grossamount   TYPE zpla_grossamount,
*             currency_code TYPE zpla_currency,
*           END OF ty_amount_per_currencycode.

*    DATA: amount_per_currencycode TYPE STANDARD TABLE OF ty_amount_per_currencycode.
    DATA: tt_amount TYPE TABLE FOR UPDATE zpa_i_product\\MrktOrder.

    READ ENTITIES OF zpa_i_product IN LOCAL MODE
         ENTITY Product
            FIELDS ( Price Taxrate PriceCurrency )
            WITH CORRESPONDING #( keys )
         RESULT DATA(prices).

    LOOP AT prices INTO DATA(prodprice).
        READ ENTITIES OF zpa_i_product IN LOCAL MODE
         ENTITY MrktOrder
            FIELDS ( Quantity )
            WITH CORRESPONDING #( keys )
         RESULT DATA(orders).

         CHECK orders IS NOT INITIAL.

         LOOP AT orders INTO DATA(order).

            order-Netamount = order-Quantity * prodprice-Price.
            order-Grossamount = order-Netamount + ( order-Netamount * prodprice-Taxrate / 100 ).

         APPEND VALUE #(
                %tky         = order-%tky
                netamount = order-Netamount
                grossamount = order-Grossamount
                amountcurrency = prodprice-PriceCurrency
                %control-netamount = if_abap_behv=>mk-on
                %control-grossamount = if_abap_behv=>mk-on
                %control-amountcurrency = if_abap_behv=>mk-on
                       ) TO tt_amount.
         ENDLOOP.

    MODIFY ENTITIES OF zpa_i_product IN LOCAL MODE
                ENTITY MrktOrder
                  UPDATE FIELDS ( Netamount Grossamount AmountCurrency ) WITH tt_amount.

    ENDLOOP.
  ENDMETHOD.

  METHOD calculateAmount.
    MODIFY ENTITIES OF zpa_i_product IN LOCAL MODE
    ENTITY mrktorder
      EXECUTE recalculateAmount
      FROM CORRESPONDING #( keys )
    REPORTED DATA(execute_reported).

    reported = CORRESPONDING #( DEEP execute_reported ).
  ENDMETHOD.

ENDCLASS.
