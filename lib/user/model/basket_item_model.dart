import 'package:delivery_flutter_app/product/product_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'basket_item_model.g.dart';

@JsonSerializable()
class BasketItemModel {
  final ProductModel product;
  final int count;

  BasketItemModel({required this.product, required this.count});

  factory BasketItemModel.fromJson(Map<String, dynamic> json) =>
      _$BasketItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$BasketItemModelToJson(this);

  BasketItemModel copyWith({ProductModel? product, int? count}) {
    return BasketItemModel(
        product: product ?? this.product, count: count ?? this.count);
  }
}
