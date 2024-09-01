import 'package:delivery_flutter_app/common/extension/string_extension.dart';
import 'package:delivery_flutter_app/restaurant/model/restaurant_detail_model.dart';
import 'package:delivery_flutter_app/restaurant/model/restaurant_model.dart';
import 'package:flutter/material.dart';

class RestaurantCard extends StatelessWidget {
  final Widget image; // 이미지
  final String name; // 레스토랑 이름
  final List<String> tags; // 레스토랑 태그
  final int ratingsCount; // 평점 개수
  final int deliveryTime; // 배송 소요시간
  final int deliveryFee; // 배송 비용
  final double ratings; // 평균 평점
  final bool isDetail; // 상세페이지 카드 여부
  final String? detail; // 상세 내용

  const RestaurantCard({
    super.key,
    required this.image,
    required this.name,
    required this.tags,
    required this.ratingsCount,
    required this.deliveryTime,
    required this.deliveryFee,
    required this.ratings,
    this.isDetail = false,
    this.detail,
  });

  factory RestaurantCard.fromModel(
      {required RestaurantModel model, bool isDetail = false, String? detail}) {
    return RestaurantCard(
      image: Hero(
        tag: ObjectKey(model.id),
        child: Image.network(
          model.thumbUrl,
          fit: BoxFit.cover,
        ),
      ),
      name: model.name,
      tags: model.tags,
      ratingsCount: model.ratingsCount,
      deliveryTime: model.deliveryTime,
      deliveryFee: model.deliveryFee,
      ratings: model.ratings,
      isDetail: isDetail,
      detail: model is RestaurantDetailModel ? model.detail : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 이미지 렌더링 여부
        isDetail
            ? const SizedBox.shrink()
            : ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: image,
              ),
        const SizedBox(height: 16),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: isDetail ? 16 : 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 레스토랑 이름
              Text(
                name,
                style: TextStyle(
                  fontSize: isDetail ? 24 : 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8.0),
              // 태그
              Text(
                tags.join(' · '),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.outline,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8.0),
              // 별점, 댓글, 배달시간, 배달비
              Row(
                children: [
                  _IconText(
                    icon: Icons.star,
                    label: ratings.toString(),
                  ),
                  buildDot(),
                  _IconText(
                    icon: Icons.receipt,
                    label: ratingsCount.toString(),
                  ),
                  buildDot(),
                  _IconText(
                    icon: Icons.timelapse_outlined,
                    label: '$deliveryTime 분',
                  ),
                  buildDot(),
                  _IconText(
                    icon: Icons.monetization_on,
                    label: deliveryFee == 0 ? '무료' : '$deliveryFee 원',
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              // 레스토랑 디테일 텍스트
              if (detail != null && isDetail)
                detail!.toReadMoreText(context, trimLines: 8),
            ],
          ),
        ),
      ],
    );
  }
}

class _IconText extends StatelessWidget {
  final IconData icon;
  final String label;
  const _IconText({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: Theme.of(context).colorScheme.primary,
          size: 14.0,
        ),
        const SizedBox(
          width: 6.0,
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12.0,
            fontWeight: FontWeight.w500,
          ),
        )
      ],
    );
  }
}

Widget buildDot() {
  return const Padding(
    padding: EdgeInsets.symmetric(horizontal: 6),
    child: Text(
      '·',
      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
    ),
  );
}
