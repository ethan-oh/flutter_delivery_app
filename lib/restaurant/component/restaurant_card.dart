import 'package:delivery_flutter_app/common/const/colors.dart';
import 'package:flutter/material.dart';

class RestaurantCard extends StatelessWidget {
  final Widget image; // 이미지
  final String name; // 레스토랑 이름
  final List<String> tags; // 레스토랑 태그
  final int ratingCount; // 평점 개수
  final int deliveryTime; // 배송 소요시간
  final int deliveryFee; // 배송 비용
  final double rating; // 평균 평점

  const RestaurantCard({
    super.key,
    required this.image,
    required this.name,
    required this.tags,
    required this.ratingCount,
    required this.deliveryTime,
    required this.deliveryFee,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12.0),
          child: image,
        ),
        const SizedBox(
          height: 16,
        ),
        Text(
          name,
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
        ),
        const SizedBox(
          height: 8.0,
        ),
        Text(
          tags.join(' · '),
          style: TextStyle(color: BODY_TEXT_COLOR, fontSize: 14),
        ),
        const SizedBox(
          height: 8.0,
        ),
        Row(
          children: [
            _IconText(
              icon: Icons.star,
              label: rating.toString(),
            ),
            buildDot(),
            _IconText(
              icon: Icons.receipt,
              label: ratingCount.toString(),
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
          color: PRIMARY_COLOR,
          size: 14.0,
        ),
        const SizedBox(
          width: 6.0,
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12.0,
            fontWeight: FontWeight.w500,
          ),
        )
      ],
    );
  }
}

Widget buildDot() {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 6),
    child: Text(
      '·',
      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
    ),
  );
}
