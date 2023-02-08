@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface CDS for Product group'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

@ObjectModel.resultSet.sizeCategory: #XS

define view entity zpa_i_pg
  as select from zpa_d_prod_group
{
@ObjectModel.text.element: ['Pgname']
  key pgid     as Pgid,
      pgname   as Pgname,
      imageurl as Imageurl
}
