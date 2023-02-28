CLASS zpa_cl_virtual DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_sadl_exit_calc_element_read .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zpa_cl_virtual IMPLEMENTATION.


  METHOD if_sadl_exit_calc_element_read~calculate.

* Check the field for your condition and return either abap_true or abap_false
*    for the virtual field.

    DATA lt_original_data TYPE STANDARD TABLE OF zpa_c_product WITH DEFAULT KEY.
    lt_original_data = CORRESPONDING #( it_original_data ).

    LOOP AT lt_original_data ASSIGNING FIELD-SYMBOL(<fs_original_data>).
      <fs_original_data>-VirtualElement = COND abap_boolean( WHEN <fs_original_data>-Price > 100
                                                             THEN abap_true
                                                             ELSE abap_false ).
    ENDLOOP.

    ct_calculated_data = CORRESPONDING #( lt_original_data ).

  ENDMETHOD.


  METHOD if_sadl_exit_calc_element_read~get_calculation_info.
  ENDMETHOD.
ENDCLASS.
