CLASS zcm_pa_product DEFINITION
  PUBLIC
  INHERITING FROM cx_static_check
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_abap_behv_message .
    INTERFACES if_t100_message .
    INTERFACES if_t100_dyn_msg .

    CONSTANTS:
      BEGIN OF pgroup_unknown,
        msgid TYPE symsgid VALUE 'ZPA_MSG_PRODUCT',
        msgno TYPE symsgno VALUE '001',
        attr1 TYPE scx_attrname VALUE 'PGID',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF pgroup_unknown,

      BEGIN OF productid_exist,
        msgid TYPE symsgid VALUE 'ZPA_MSG_PRODUCT',
        msgno TYPE symsgno VALUE '002',
        attr1 TYPE scx_attrname VALUE 'PRODID',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF productid_exist,

      BEGIN OF market_unknown,
        msgid TYPE symsgid VALUE 'ZPA_MSG_PRODUCT',
        msgno TYPE symsgno VALUE '003',
        attr1 TYPE scx_attrname VALUE 'MRKTID',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF market_unknown,

      BEGIN OF start_date_error,
        msgid TYPE symsgid VALUE 'ZPA_MSG_PRODUCT',
        msgno TYPE symsgno VALUE '004',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF start_date_error,

      BEGIN OF end_date_error_start,
        msgid TYPE symsgid VALUE 'ZPA_MSG_PRODUCT',
        msgno TYPE symsgno VALUE '005',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF end_date_error_start,

      BEGIN OF end_date_error_today,
        msgid TYPE symsgid VALUE 'ZPA_MSG_PRODUCT',
        msgno TYPE symsgno VALUE '006',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF end_date_error_today,

      BEGIN OF market_duplicate,
        msgid TYPE symsgid VALUE 'ZPA_MSG_PRODUCT',
        msgno TYPE symsgno VALUE '007',
        attr1 TYPE scx_attrname VALUE 'MRKTID',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF market_duplicate,

      BEGIN OF phase_1,
        msgid TYPE symsgid VALUE 'ZPA_MSG_PRODUCT',
        msgno TYPE symsgno VALUE '008',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF phase_1,

      BEGIN OF phase_2,
        msgid TYPE symsgid VALUE 'ZPA_MSG_PRODUCT',
        msgno TYPE symsgno VALUE '009',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF phase_2,

      BEGIN OF phase_3,
        msgid TYPE symsgid VALUE 'ZPA_MSG_PRODUCT',
        msgno TYPE symsgno VALUE '010',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF phase_3,

      BEGIN OF delivery_date_error_start,
        msgid TYPE symsgid VALUE 'ZPA_MSG_PRODUCT',
        msgno TYPE symsgno VALUE '011',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF delivery_date_error_start,

      BEGIN OF delivery_date_error_end,
        msgid TYPE symsgid VALUE 'ZPA_MSG_PRODUCT',
        msgno TYPE symsgno VALUE '012',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF delivery_date_error_end.

    METHODS constructor
      IMPORTING
        severity  TYPE if_abap_behv_message=>t_severity DEFAULT if_abap_behv_message=>severity-error
        !textid   LIKE if_t100_message=>t100key OPTIONAL
        !previous LIKE previous OPTIONAL
        revious   TYPE REF TO cx_root   OPTIONAL
        pgid      TYPE zpla_pg_id OPTIONAL
        prodid    TYPE zpla_product_id OPTIONAL
        mrktid    TYPE zpla_market_id OPTIONAL
        phaseid   TYPE zpla_phase_id OPTIONAL.
*        startdate TYPE zpla_start_date OPTIONAL
*        enddate TYPE zpla_end_date OPTIONAL.

    DATA pgid   TYPE zpla_pg_id READ-ONLY.
    DATA prodid TYPE zpla_product_id READ-ONLY.
    DATA mrktid TYPE zpla_market_id READ-ONLY.
    DATA phaseid TYPE zpla_phase_id READ-ONLY.
*    DATA startdate TYPE zpla_start_date READ-ONLY.
*    DATA enddate TYPE zpla_end_date READ-ONLY.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcm_pa_product IMPLEMENTATION.


  METHOD constructor ##ADT_SUPPRESS_GENERATION.
    CALL METHOD super->constructor
      EXPORTING
        previous = previous.

    me->if_abap_behv_message~m_severity = severity.
    me->pgid = pgid.
    me->prodid = prodid.
    me->mrktid = mrktid.
    me->phaseid = phaseid.
*    me->startdate = startdate.
*    me->enddate = enddate.

    CLEAR me->textid.
    IF textid IS INITIAL.
      if_t100_message~t100key = if_t100_message=>default_textid.
    ELSE.
      if_t100_message~t100key = textid.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
