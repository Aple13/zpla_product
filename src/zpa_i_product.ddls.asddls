@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface CDS for Product'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity zpa_i_product
  as select from zpa_d_product

  composition [1..*] of zpa_i_prod_mrkt as _Prodmrkt

  association [1]    to zpa_i_pg           as _Pg       on $projection.Pgid = _Pg.Pgid
  association [1]    to zpa_i_phase        as _Phase    on $projection.Phaseid = _Phase.Phaseid
  association [1]    to zpa_i_currency     as _Currency on $projection.PriceCurrency = _Currency.Currency
  association [1]    to zpa_i_uom          as _Uom      on $projection.SizeUom = _Uom.Msehi
  association [1..*] to zpa_i_market    as _Market      on $projection.TransCode = _Market.Code

{
  key prod_uuid             as ProdUuid,
      prodid                as Prodid,
      pgid                  as Pgid,
      _Pg.Pgname            as Pgname,
      phaseid               as Phaseid,

      case phaseid
        when 1  then 1    -- 'plan' | 1: red colour
        when 2  then 2    -- 'dev'  | 2: yellow colour
        when 3  then 3    -- 'prod' | 3: green colour
            else 0        -- 'out'  | 0: unknown
      end                   as PhaseCriticality,

      @Semantics.quantity.unitOfMeasure: 'SizeUom'
      height                as Height,
      @Semantics.quantity.unitOfMeasure: 'SizeUom'
      depth                 as Depth,
      @Semantics.quantity.unitOfMeasure: 'SizeUom'
      width                 as Width,

      concat_with_space( concat_with_space( concat_with_space(cast(height as abap.char(20)),
                                                              'x',
                                                              1),
                                            concat_with_space(cast(depth as abap.char(20)),
                                                              'x',
                                                              1),
                                            1),
                         cast(width as abap.char(20)),
                         1) as Measure,

      size_uom              as SizeUom,
      @Semantics.amount.currencyCode: 'PriceCurrency'
      price                 as Price,
      price_currency        as PriceCurrency,
      taxrate               as Taxrate,
      pgname_trans          as PgnameTrans,
      trans_code            as TransCode,
      @Semantics.user.createdBy: true
      created_by            as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      @Semantics.dateTime: true
      creation_time         as CreationTime,
      @Semantics.user.lastChangedBy: true
      changed_by            as ChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      @Semantics.dateTime: true
      change_time           as ChangeTime,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      @Semantics.dateTime: true
      local_changed_time    as LocalChangedTime,

      _Pg,
      _Phase,
      _Currency,
      _Uom,
      _Prodmrkt,
      _Market
}
