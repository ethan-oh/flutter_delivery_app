// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'basket_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BasketModel _$BasketModelFromJson(Map<String, dynamic> json) => BasketModel(
      product: ProductModel.fromJson(json['product'] as Map<String, dynamic>),
      count: (json['count'] as num).toInt(),
    );

Map<String, dynamic> _$BasketModelToJson(BasketModel instance) =>
    <String, dynamic>{
      'product': instance.product,
      'count': instance.count,
    };
