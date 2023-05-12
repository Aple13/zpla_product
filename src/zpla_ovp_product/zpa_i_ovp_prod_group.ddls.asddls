@AbapCatalog.sqlViewName: 'ZPLA_IOVPPRODGRP'
@AbapCatalog.compiler.compareFilter: true
//@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Product groups'


define view ZPA_I_OVP_PROD_GROUP
  as select from zpa_d_prod_group
{
  key pgid     as Pgid,
      pgname   as Pgname,
      imageurl as Imageurl
}
