import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class PictureCarousel extends StatefulWidget {
  final List<String> imagePaths;
  final CarouselSliderController carouselController;
  final Function onAddNewImage;

  const PictureCarousel({
    required this.imagePaths,
    required this.carouselController,
    required this.onAddNewImage,
    Key? key,
  }) : super(key: key);

  @override
  _PictureCarouselState createState() => _PictureCarouselState();
}

class _PictureCarouselState extends State<PictureCarousel> {
  int _currentImageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final containerSize = screenWidth * 0.9;

    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: widget.imagePaths.length + 1,
          itemBuilder: (context, index, realIndex) {
            if (index < widget.imagePaths.length) {
              // Normal image items
              return ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: containerSize,
                  height: containerSize,
                  color: Colors.grey[200],
                  child: Image.asset(
                    widget.imagePaths[index],
                    fit: BoxFit.cover,
                  ),
                ),
              );
            } else {
              // Plus sign as the last item
              return GestureDetector(
                onTap: () => widget.onAddNewImage(),
                child: Container(
                  width: containerSize,
                  height: containerSize,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.add,
                      size: 50,
                      color: Colors.black,
                    ),
                  ),
                ),
              );
            }
          },
          carouselController: widget.carouselController,
          options: CarouselOptions(
            height: containerSize,
            aspectRatio: 1.0,
            enlargeCenterPage: true,
            enableInfiniteScroll: false,
            onPageChanged: (index, reason) {
              setState(() {
                _currentImageIndex = index;
              });
            },
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            widget.imagePaths.length + 1,
            (index) {
              return GestureDetector(
                onTap: () => widget.carouselController.animateToPage(index),
                child: Container(
                  width: 8.0,
                  height: 8.0,
                  margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentImageIndex == index ? Colors.black : Colors.grey,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}