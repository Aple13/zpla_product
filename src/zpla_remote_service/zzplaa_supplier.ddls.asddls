/********** GENERATED on 04/24/2023 at 11:18:57 by CB9980003307**************/
 @OData.entitySet.name: 'A_Supplier' 
 @OData.entityType.name: 'A_SupplierType' 
 define root abstract entity ZZPLAA_SUPPLIER { 
 key Supplier : abap.char( 10 ) ; 
 @OData.property.valueControl: 'AlternativePayeeAccountNumb_vc' 
 AlternativePayeeAccountNumber : abap.char( 10 ) ; 
 AlternativePayeeAccountNumb_vc : rap_cp_odata_value_control ; 
 @OData.property.valueControl: 'AuthorizationGroup_vc' 
 AuthorizationGroup : abap.char( 4 ) ; 
 AuthorizationGroup_vc : rap_cp_odata_value_control ; 
 @OData.property.valueControl: 'CreatedByUser_vc' 
 CreatedByUser : abap.char( 12 ) ; 
 CreatedByUser_vc : rap_cp_odata_value_control ; 
 @OData.property.valueControl: 'CreationDate_vc' 
 CreationDate : rap_cp_odata_v2_edm_datetime ; 
 CreationDate_vc : rap_cp_odata_value_control ; 
 @OData.property.valueControl: 'Customer_vc' 
 Customer : abap.char( 10 ) ; 
 Customer_vc : rap_cp_odata_value_control ; 
 @OData.property.valueControl: 'PaymentIsBlockedForSupplier_vc' 
 PaymentIsBlockedForSupplier : abap_boolean ; 
 PaymentIsBlockedForSupplier_vc : rap_cp_odata_value_control ; 
 @OData.property.valueControl: 'PostingIsBlocked_vc' 
 PostingIsBlocked : abap_boolean ; 
 PostingIsBlocked_vc : rap_cp_odata_value_control ; 
 @OData.property.valueControl: 'PurchasingIsBlocked_vc' 
 PurchasingIsBlocked : abap_boolean ; 
 PurchasingIsBlocked_vc : rap_cp_odata_value_control ; 
 @OData.property.valueControl: 'SupplierAccountGroup_vc' 
 SupplierAccountGroup : abap.char( 4 ) ; 
 SupplierAccountGroup_vc : rap_cp_odata_value_control ; 
 @OData.property.valueControl: 'SupplierFullName_vc' 
 SupplierFullName : abap.char( 220 ) ; 
 SupplierFullName_vc : rap_cp_odata_value_control ; 
 @OData.property.valueControl: 'SupplierName_vc' 
 SupplierName : abap.char( 80 ) ; 
 SupplierName_vc : rap_cp_odata_value_control ; 
 @OData.property.valueControl: 'VATRegistration_vc' 
 VATRegistration : abap.char( 20 ) ; 
 VATRegistration_vc : rap_cp_odata_value_control ; 
 @OData.property.valueControl: 'BirthDate_vc' 
 BirthDate : rap_cp_odata_v2_edm_datetime ; 
 BirthDate_vc : rap_cp_odata_value_control ; 
 @OData.property.valueControl: 'ConcatenatedInternationalLo_vc' 
 ConcatenatedInternationalLocNo : abap.char( 20 ) ; 
 ConcatenatedInternationalLo_vc : rap_cp_odata_value_control ; 
 @OData.property.valueControl: 'DeletionIndicator_vc' 
 DeletionIndicator : abap_boolean ; 
 DeletionIndicator_vc : rap_cp_odata_value_control ; 
 @OData.property.valueControl: 'FiscalAddress_vc' 
 FiscalAddress : abap.char( 10 ) ; 
 FiscalAddress_vc : rap_cp_odata_value_control ; 
 @OData.property.valueControl: 'Industry_vc' 
 Industry : abap.char( 4 ) ; 
 Industry_vc : rap_cp_odata_value_control ; 
 @OData.property.valueControl: 'InternationalLocationNumber_vc' 
 InternationalLocationNumber1 : abap.numc( 7 ) ; 
 InternationalLocationNumber_vc : rap_cp_odata_value_control ; 
 @OData.property.valueControl: 'InternationalLocationNumber_v1' 
 InternationalLocationNumber2 : abap.numc( 5 ) ; 
 InternationalLocationNumber_v1 : rap_cp_odata_value_control ; 
 @OData.property.valueControl: 'InternationalLocationNumber_v2' 
 InternationalLocationNumber3 : abap.numc( 1 ) ; 
 InternationalLocationNumber_v2 : rap_cp_odata_value_control ; 
 @OData.property.valueControl: 'IsNaturalPerson_vc' 
 IsNaturalPerson : abap.char( 1 ) ; 
 IsNaturalPerson_vc : rap_cp_odata_value_control ; 
 @OData.property.valueControl: 'ResponsibleType_vc' 
 ResponsibleType : abap.char( 2 ) ; 
 ResponsibleType_vc : rap_cp_odata_value_control ; 
 @OData.property.valueControl: 'SuplrQltyInProcmtCertfnVali_vc' 
 SuplrQltyInProcmtCertfnValidTo : rap_cp_odata_v2_edm_datetime ; 
 SuplrQltyInProcmtCertfnVali_vc : rap_cp_odata_value_control ; 
 @OData.property.valueControl: 'SuplrQualityManagementSyste_vc' 
 SuplrQualityManagementSystem : abap.char( 4 ) ; 
 SuplrQualityManagementSyste_vc : rap_cp_odata_value_control ; 
 @OData.property.valueControl: 'SupplierCorporateGroup_vc' 
 SupplierCorporateGroup : abap.char( 10 ) ; 
 SupplierCorporateGroup_vc : rap_cp_odata_value_control ; 
 @OData.property.valueControl: 'SupplierProcurementBlock_vc' 
 SupplierProcurementBlock : abap.char( 2 ) ; 
 SupplierProcurementBlock_vc : rap_cp_odata_value_control ; 
 @OData.property.valueControl: 'TaxNumber1_vc' 
 TaxNumber1 : abap.char( 16 ) ; 
 TaxNumber1_vc : rap_cp_odata_value_control ; 
 @OData.property.valueControl: 'TaxNumber2_vc' 
 TaxNumber2 : abap.char( 11 ) ; 
 TaxNumber2_vc : rap_cp_odata_value_control ; 
 @OData.property.valueControl: 'TaxNumber3_vc' 
 TaxNumber3 : abap.char( 18 ) ; 
 TaxNumber3_vc : rap_cp_odata_value_control ; 
 @OData.property.valueControl: 'TaxNumber4_vc' 
 TaxNumber4 : abap.char( 18 ) ; 
 TaxNumber4_vc : rap_cp_odata_value_control ; 
 @OData.property.valueControl: 'TaxNumber5_vc' 
 TaxNumber5 : abap.char( 60 ) ; 
 TaxNumber5_vc : rap_cp_odata_value_control ; 
 @OData.property.valueControl: 'TaxNumberResponsible_vc' 
 TaxNumberResponsible : abap.char( 18 ) ; 
 TaxNumberResponsible_vc : rap_cp_odata_value_control ; 
 @OData.property.valueControl: 'TaxNumberType_vc' 
 TaxNumberType : abap.char( 2 ) ; 
 TaxNumberType_vc : rap_cp_odata_value_control ; 
 @OData.property.valueControl: 'SuplrProofOfDelivRlvtCode_vc' 
 SuplrProofOfDelivRlvtCode : abap.char( 1 ) ; 
 SuplrProofOfDelivRlvtCode_vc : rap_cp_odata_value_control ; 
 @OData.property.valueControl: 'BR_TaxIsSplit_vc' 
 BR_TaxIsSplit : abap_boolean ; 
 BR_TaxIsSplit_vc : rap_cp_odata_value_control ; 
 
 } 
