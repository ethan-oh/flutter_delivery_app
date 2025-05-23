import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ImagesScreen extends StatefulWidget {
  final List<Image> images;
  final int initialIndex;

  const ImagesScreen({
    required this.images,
    required this.initialIndex,
    super.key,
  });

  @override
  State<ImagesScreen> createState() => _ImagesScreenState();
}

class _ImagesScreenState extends State<ImagesScreen> {
  late PageController _pageController;
  late int currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${currentIndex + 1}/${widget.images.length}'),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: SafeArea(
        child: PhotoViewGallery.builder(
          itemCount: widget.images.length,
          pageController: _pageController,
          onPageChanged: (index) {
            setState(() {
              currentIndex = index;
            });
          },
          builder: (context, index) {
            return PhotoViewGalleryPageOptions(
              imageProvider: widget.images[index].image,
              minScale: PhotoViewComputedScale.contained,
              maxScale: PhotoViewComputedScale.covered * 2,
            );
          },
          scrollPhysics: const BouncingScrollPhysics(),
        ),
      ),
    );
  }
}
