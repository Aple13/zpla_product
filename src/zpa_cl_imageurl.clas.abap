CLASS zpa_cl_imageurl DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_sadl_exit_calc_element_read .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zpa_cl_imageurl IMPLEMENTATION.


  METHOD if_sadl_exit_calc_element_read~calculate.
    DATA Orders TYPE STANDARD TABLE OF zpa_c_mrkt_order WITH DEFAULT KEY.
    Orders = CORRESPONDING #( it_original_data ).

    LOOP AT Orders ASSIGNING FIELD-SYMBOL(<order>).
      <order>-imageUrl = 'https://i7.pngguru.com/preview/423/632/57/computer-icons-purchase-order-order-fulfillment-purchasing-order-icon.jpg'.
    ENDLOOP.

    ct_calculated_data = CORRESPONDING #( Orders ).
  ENDMETHOD.


  METHOD if_sadl_exit_calc_element_read~get_calculation_info.
  ENDMETHOD.
ENDCLASS.
