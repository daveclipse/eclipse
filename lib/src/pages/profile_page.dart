import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:eclipse_flutter/src/components/profile_popover.dart';
import 'package:eclipse_flutter/src/components/square_grid.dart';
import 'package:eclipse_flutter/src/components/picture_carousel.dart';
import 'package:eclipse_flutter/src/components/vitals_card.dart';

class Profile extends StatefulWidget {
  final String userId;

  const Profile({required this.userId, Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool isPopoverVisible = false;
  Map<String, dynamic>? profileInfo;

  final ImagePicker _picker = ImagePicker();
  final List<Map<String, Object>> draggableSquares = [
    {'icon': const Icon(Icons.star, size: 40), 'description': 'Star'},
    {'icon': const Icon(Icons.favorite, size: 40), 'description': 'Favorite'},
    {'icon': const Icon(Icons.home, size: 40), 'description': 'Home'},
    {'icon': const Icon(Icons.person, size: 40), 'description': 'Profile'},
    {'icon': const Icon(Icons.settings, size: 40), 'description': 'Settings'},
    {'icon': const Icon(Icons.map, size: 40), 'description': 'Map'},
  ];

  final List<String> imagePaths = [
    'assets/images/bird.jpg',
    'assets/images/bird.jpg',
    'assets/images/bird.jpg',
  ];

  late final CarouselSliderController _carouselController;

  @override
  void initState() {
    super.initState();
    _carouselController = CarouselSliderController();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      await Future.delayed(const Duration(seconds: 0));
      setState(() {
        profileInfo = {
          'name': 'John Doe',
          'email': 'johndoe@example.com',
          'age': 30,
        };
      });
    } catch (error) {
      print('Error fetching user data: $error');
    }
  }

  void onPopover() {
    setState(() {
      isPopoverVisible = true;
    });
  }

  void closePopover() {
    setState(() {
      isPopoverVisible = false;
    });
  }

  void addSquare(Map<String, Object> square) {
    setState(() {
      draggableSquares.add(square);
    });
  }

  Future<void> onAddNewImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          imagePaths.add(pickedFile.path);
        });
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final gridBoxWidth = (screenWidth - 48) / 3; // Total padding and spacing is 48 (16 * 2 + 8 * 2)
    final vitalsCardHeight = gridBoxWidth + 8; // Match grid row height including spacing

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.black),
            onPressed: onPopover,
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                PictureCarousel(
                  imagePaths: imagePaths,
                  carouselController: _carouselController,
                  onAddNewImage: onAddNewImage,
                ),
                if (profileInfo != null)
                  VitalsCard(
                    name: profileInfo!['name'],
                    email: profileInfo!['email'],
                    age: profileInfo!['age'],
                    width: screenWidth - 32,
                    height: vitalsCardHeight,
                  ),
                DraggableGrid(squares: draggableSquares),
              ],
            ),
          ),
          ProfilePopover(
            isVisible: isPopoverVisible,
            onClose: closePopover,
            onAddTile: addSquare,
          ),
        ],
      ),
    );
  }
}