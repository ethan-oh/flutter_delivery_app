import 'package:delivery_flutter_app/product/product_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'basket_model.g.dart';

@JsonSerializable()
class BasketModel {
  final ProductModel product;
  final int count;

  BasketModel({required this.product, required this.count});

  factory BasketModel.fromJson(Map<String, dynamic> json) =>
      _$BasketModelFromJson(json);
  Map<String, dynamic> toJson() => _$BasketModelToJson(this);
}
