import 'package:delivery_flutter_app/common/extension/string_extension.dart';
import 'package:delivery_flutter_app/rating/model/rating_model.dart';
import 'package:delivery_flutter_app/rating/screen/images_screen.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';
import 'dart:math' as math;

class RatingCard extends StatelessWidget {
  final String id;
  final ImageProvider avartarImage;
  final List<Image> images;
  final int rating;
  final String email;
  final String content;

  const RatingCard(
      {super.key,
      required this.id,
      required this.avartarImage,
      required this.images,
      required this.rating,
      required this.email,
      required this.content});

  factory RatingCard.fromModel({required RatingModel model}) {
    return RatingCard(
        id: model.id,
        avartarImage: NetworkImage(model.user.imageUrl),
        images: model.imgUrls.map((e) => Image.network(e)).toList(),
        rating: model.rating,
        email: model.user.username.split('@')[0],
        content: model.content);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      borderOnForeground: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      // 카드 배경색
      color: Theme.of(context).colorScheme.surfaceContainerHigh,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _Header(
                avartarImage: avartarImage,
                rating: rating,
                email: email,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _Body(content: content),
            ),
            const SizedBox(height: 8),
            _Images(id: id, images: images),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatefulWidget {
  final ImageProvider avartarImage;
  final int rating;
  final String email;

  const _Header({
    required this.avartarImage,
    required this.rating,
    required this.email,
  });

  @override
  _HeaderState createState() => _HeaderState();
}

class _HeaderState extends State<_Header> {
  late Color randomColor;

  @override
  void initState() {
    super.initState();
    randomColor = _getRandomColor();
  }

  Color _getRandomColor() {
    return Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
        .withOpacity(0.5);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ColorFiltered(
          colorFilter: ColorFilter.mode(
            randomColor,
            BlendMode.srcATop,
          ),
          child: CircleAvatar(
            radius: 12,
            backgroundImage: widget.avartarImage,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            widget.email,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        ...List.generate(
          5,
          (index) {
            return Icon(
              index < widget.rating ? Icons.star : Icons.star_border_outlined,
              color: Theme.of(context).colorScheme.primary,
            );
          },
        ),
      ],
    );
  }
}

class _Body extends StatelessWidget {
  final String content;
  const _Body({required this.content});

  @override
  Widget build(BuildContext context) {
    return content.toReadMoreText();
  }
}

class _Images extends StatelessWidget {
  final String id;
  final List<Image> images;

  const _Images({required this.id, required this.images});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: images.isNotEmpty ? 100 : 0,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: images
            .mapIndexed(
              (index, element) => Padding(
                padding: EdgeInsets.only(left: index == 0 ? 16 : 0, right: 16),
                child: GestureDetector(
                    onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            fullscreenDialog: true,
                            builder: (context) => ImagesScreen(
                                images: images, initialIndex: index),
                          ),
                        ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.onSurface,
                          width: 0.2,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: element,
                      ),
                    )),
              ),
            )
            .toList(),
      ),
    );
  }
}
