import 'package:json_annotation/json_annotation.dart';

part 'patch_basket_body.g.dart';

@JsonSerializable()
class PatchBasketBody {
  final List<PatchBasketBodyBasket> basket;

  PatchBasketBody({required this.basket});

  factory PatchBasketBody.fromJson(Map<String, dynamic> json) =>
      _$PatchBasketBodyFromJson(json);
  Map<String, dynamic> toJson() => _$PatchBasketBodyToJson(this);
}

@JsonSerializable()
class PatchBasketBodyBasket {
  final String productId;
  final int count;

  PatchBasketBodyBasket({
    required this.productId,
    required this.count,
  });

  factory PatchBasketBodyBasket.fromJson(Map<String, dynamic> json) =>
      _$PatchBasketBodyBasketFromJson(json);
  Map<String, dynamic> toJson() => _$PatchBasketBodyBasketToJson(this);
}
