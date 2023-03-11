CLASS lhc_prodmrkt DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    CONSTANTS:
      BEGIN OF market_status,
        new       TYPE c LENGTH 1  VALUE ' ',
        confirmed TYPE c LENGTH 1  VALUE 'X',
      END OF market_status.

    METHODS validateMarket FOR VALIDATE ON SAVE
      IMPORTING keys FOR ProdMrkt~validateMarket.
    METHODS validateStartDate FOR VALIDATE ON SAVE
      IMPORTING keys FOR ProdMrkt~validateStartDate.
    METHODS validateEndDate FOR VALIDATE ON SAVE
      IMPORTING keys FOR ProdMrkt~validateEndDate.
    METHODS validateDuplicates FOR VALIDATE ON SAVE
      IMPORTING keys FOR ProdMrkt~validateDuplicates.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR ProdMrkt RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR ProdMrkt RESULT result.

    METHODS confirm FOR MODIFY
      IMPORTING keys FOR ACTION ProdMrkt~confirm RESULT result.

ENDCLASS.

CLASS lhc_prodmrkt IMPLEMENTATION.

  METHOD validateMarket.
    READ ENTITIES OF zpa_i_product IN LOCAL MODE
     ENTITY ProdMrkt
       FIELDS ( Mrktid ) WITH CORRESPONDING #( keys )
     RESULT DATA(mrktids).

    DATA markets TYPE SORTED TABLE OF zpa_d_prod_mrkt WITH UNIQUE KEY Mrktid.

    markets = CORRESPONDING #( mrktids DISCARDING DUPLICATES MAPPING Mrktid = Mrktid EXCEPT * ).
    DELETE markets WHERE mrktid IS INITIAL.

    IF markets IS NOT INITIAL.
      SELECT FROM zpa_d_market FIELDS mrktid
         FOR ALL ENTRIES IN @markets
         WHERE mrktid = @markets-Mrktid
         INTO TABLE @DATA(markets_db).
    ENDIF.

    LOOP AT mrktids INTO DATA(market).

    APPEND VALUE #(
        %tky = market-%tky
        %state_area        = 'VALIDATE_MARKET' )
          TO reported-prodmrkt.

      IF market-Mrktid IS INITIAL OR NOT line_exists( markets_db[ mrktid = market-Mrktid ] ).
        APPEND VALUE #(  %tky = market-%tky ) TO failed-prodmrkt.

        APPEND VALUE #(  %tky        = market-%tky
                         %state_area = 'VALIDATE_MARKET'
                         %path       = VALUE #( Product-%is_draft = market-%is_draft
                                                Product-ProdUuid = market-ProdUuid )
                         %msg        = NEW zcm_pa_product(
                                           severity   = if_abap_behv_message=>severity-error
                                           textid     = zcm_pa_product=>market_unknown
                                           mrktid     = market-Mrktid )
                         %element-Mrktid = if_abap_behv=>mk-on )
          TO reported-prodmrkt.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD validateStartDate.
    READ ENTITIES OF zpa_i_product IN LOCAL MODE
    ENTITY ProdMrkt
      FIELDS ( Startdate )
      WITH CORRESPONDING #( keys )
    RESULT DATA(markets).

    CLEAR failed-ProdMrkt.
    CLEAR reported-ProdMrkt.

    LOOP AT markets INTO DATA(market).

    APPEND VALUE #(
        %tky = market-%tky
        %state_area        = 'VALIDATE_START_DATE' )
          TO reported-prodmrkt.

      IF market-Startdate < cl_abap_context_info=>get_system_date( ).  "begin_date must be in the future

        APPEND VALUE #( %tky        = market-%tky ) TO failed-ProdMrkt.

        APPEND VALUE #(  %tky        = market-%tky
                         %state_area = 'VALIDATE_START_DATE'
                         %path       = VALUE #( Product-%is_draft = market-%is_draft
                                                Product-ProdUuid = market-ProdUuid )
                         %msg        = NEW zcm_pa_product(
                                           severity   = if_abap_behv_message=>severity-error
                                           textid     = zcm_pa_product=>start_date_error
                                            )
                         %element-Startdate = if_abap_behv=>mk-on
                      ) TO reported-ProdMrkt.
      ENDIF.

    ENDLOOP.
  ENDMETHOD.

  METHOD validateEndDate.
    READ ENTITIES OF zpa_i_product IN LOCAL MODE
      ENTITY ProdMrkt
    FIELDS ( Startdate Enddate )
    WITH CORRESPONDING #( keys )
    RESULT DATA(markets).

    LOOP AT markets INTO DATA(market).

    APPEND VALUE #(
        %tky = market-%tky
        %state_area        = 'VALIDATE_END_DATE' )
          TO reported-prodmrkt.

      IF market-Enddate < cl_abap_context_info=>get_system_date( ).

        APPEND VALUE #( %tky        = market-%tky ) TO failed-ProdMrkt.

        APPEND VALUE #(  %tky        = market-%tky
                         %state_area = 'VALIDATE_END_DATE'
                         %path       = VALUE #( Product-%is_draft = market-%is_draft
                                                Product-ProdUuid = market-ProdUuid )
                         %msg        = NEW zcm_pa_product(
                                           severity   = if_abap_behv_message=>severity-error
                                           textid     = zcm_pa_product=>end_date_error_today
                                            )
                         %element-Enddate = if_abap_behv=>mk-on
                      ) TO reported-ProdMrkt.

      ELSEIF market-Enddate < market-Startdate.

        APPEND VALUE #( %tky        = market-%tky ) TO failed-ProdMrkt.

        APPEND VALUE #(  %tky        = market-%tky
                         %state_area = 'VALIDATE_END_DATE'
                         %path       = VALUE #( Product-%is_draft = market-%is_draft
                                                Product-ProdUuid = market-ProdUuid )
                         %msg        = NEW zcm_pa_product(
                                           severity   = if_abap_behv_message=>severity-error
                                           textid     = zcm_pa_product=>end_date_error_start
                                            )
                         %element-Enddate = if_abap_behv=>mk-on
                      ) TO reported-ProdMrkt.
      ENDIF.

    ENDLOOP.
  ENDMETHOD.

  METHOD validateDuplicates.
    READ ENTITIES OF zpa_i_product IN LOCAL MODE
    ENTITY ProdMrkt
      FIELDS ( Mrktid ProdUuid ) WITH CORRESPONDING #( keys )
    RESULT DATA(mrktids).

    DATA markets TYPE SORTED TABLE OF zpa_d_prod_mrkt WITH UNIQUE KEY Mrktid.

    markets = CORRESPONDING #( mrktids DISCARDING DUPLICATES MAPPING Mrktid = Mrktid prod_uuid = ProdUuid EXCEPT * ).
    DELETE markets WHERE mrktid IS INITIAL.

    IF markets IS NOT INITIAL.

      SELECT FROM zpa_d_prod_mrkt
        FIELDS mrktid,
               prod_uuid
         FOR ALL ENTRIES IN @markets
         WHERE mrktid = @markets-mrktid
           AND prod_uuid = @markets-prod_uuid
         INTO TABLE @DATA(markets_db).
    ENDIF.

    LOOP AT mrktids INTO DATA(market).

    APPEND VALUE #(
        %tky = market-%tky
        %state_area        = 'VALIDATE_MARKET' )
          TO reported-prodmrkt.

      IF line_exists( markets_db[ mrktid = market-Mrktid
                                  prod_uuid = market-ProdUuid ] ).
        APPEND VALUE #(  %tky = market-%tky ) TO failed-prodmrkt.

        APPEND VALUE #(  %tky        = market-%tky
                         %state_area = 'VALIDATE_MARKET'
                         %path       = VALUE #( Product-%is_draft = market-%is_draft
                                                Product-ProdUuid = market-ProdUuid )
                         %msg        = NEW zcm_pa_product(
                                           severity   = if_abap_behv_message=>severity-error
                                           textid     = zcm_pa_product=>market_duplicate
                                           mrktid     = market-Mrktid )
                         %element-Mrktid = if_abap_behv=>mk-on )
          TO reported-prodmrkt.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD get_instance_features.
    READ ENTITIES OF zpa_i_product IN LOCAL MODE
    ENTITY ProdMrkt
      FIELDS ( Status ) WITH CORRESPONDING #( keys )
    RESULT DATA(markets)
    FAILED failed.

    result =
      VALUE #(
        FOR market IN markets
          LET is_confirmed   =   COND #( WHEN market-Status = market_status-confirmed
                                         THEN if_abap_behv=>fc-o-disabled
                                         ELSE if_abap_behv=>fc-o-enabled )
          IN
            ( %tky             = market-%tky
              %action-confirm  = is_confirmed
             ) ).

  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD confirm.
    MODIFY ENTITIES OF zpa_i_product IN LOCAL MODE
    ENTITY ProdMrkt
       UPDATE
         FIELDS ( Status )
         WITH VALUE #( FOR key IN keys
                         ( %tky         = key-%tky
                           Status = market_status-confirmed
                            ) )
    FAILED failed
    REPORTED reported.

    READ ENTITIES OF zpa_i_product IN LOCAL MODE
      ENTITY ProdMrkt
        ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(markets).

    result = VALUE #( FOR market IN markets
                        ( %tky   = market-%tky
                          %param = market ) ).
  ENDMETHOD.

ENDCLASS.
