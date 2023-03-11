@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface CDS for Market Entity'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zpa_i_prod_mrkt
  as select from zpa_d_prod_mrkt
  
  composition [1..*] of zpa_i_mrkt_order as _MrktOrder

  association     to parent zpa_i_product as _Product on $projection.ProdUuid = _Product.ProdUuid

  association [1] to zpa_i_market         as _Market  on $projection.Mrktid = _Market.Mrktid

{
  key prod_uuid          as ProdUuid,
  key mrkt_uuid          as MrktUuid,
      mrktid             as Mrktid,
      status             as Status,

      case status
        when 'X'  then 3  -- 'No'  | 0: unknown  
            else 1        -- 'Yes' | 1: red colour
      end                as StatusCriticality,

      startdate          as Startdate,
      enddate            as Enddate,
      @Semantics.user.createdBy: true
      created_by         as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      @Semantics.dateTime: true
      creation_time      as CreationTime,
      @Semantics.user.lastChangedBy: true
      changed_by         as ChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      @Semantics.dateTime: true
      change_time        as ChangeTime,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      @Semantics.dateTime: true
      local_changed_time as LocalChangedTime,

      _Market,
      _Product,
      _MrktOrder
}
