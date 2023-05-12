@AbapCatalog.sqlViewName: 'ZPLA_ALPPRODGRP'
@AbapCatalog.compiler.compareFilter: true
//@AbapCatalog.preserveKey: true
//@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Product groups'
@Analytics.dataCategory: #DIMENSION


define view zpa_i_alp_prod_group
  as select from zpa_d_prod_group
{
  key pgid     as Pgid,
      pgname   as Pgname,
      imageurl as Imageurl
}
