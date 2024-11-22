// lib/screens/home_screen.dart

import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:luxe_loft/bloc/auth/auth_bloc.dart';
import 'package:luxe_loft/bloc/auth/auth_event.dart';
import 'package:luxe_loft/utill/luxe_color.dart';
import 'package:luxe_loft/utill/luxe_typography.dart';
import '../models/product.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Corrected CarouselController
  final CarouselSliderController _carouselController =
      CarouselSliderController();

  // Current user
  User? user;

  Map<String, List<Product>>? productsByCategory;

  // Current page index for the indicator
  int _currentPage = 0;

  // List of categories
  final List<String> categories = [
    'Recommended',
    'Car Products',
    'Department Stores',
    'Trending',
  ];

  List<Map<String, String>> flashcards = [
    {
      'imageUrl':
          'https://images.unsplash.com/photo-1522204503104-3bcb1e2df9f6?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
      'title': 'Flash Sale!',
    },
    {
      'imageUrl':
          'https://images.unsplash.com/photo-1608061844179-fc795c21adcc?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
      'title': 'New Arrivals!',
    },
    {
      'imageUrl':
          'https://images.unsplash.com/photo-1490367532201-b9bc1dc483f6?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
      'title': 'Exclusive Offers!',
    },
  ];

  // Initialize a Future variable
  late Future<Map<String, dynamic>?> _userDataFuture;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    _loadProducts(); // Load products on initialization
    _userDataFuture = _fetchUserData(); // Initialize the Future
  }

  @override
  void dispose() {
    super.dispose();
  }

  // Load products from JSON
  Future<void> _loadProducts() async {
    String jsonString = await rootBundle.loadString('assets/product.json');
    final jsonResponse = json.decode(jsonString);

    setState(() {
      productsByCategory = {
        'Recommended': (jsonResponse['recommended_products'] as List)
            .map((p) => Product.fromJson(p))
            .toList(),
        'Car Products': (jsonResponse['car_products'] as List)
            .map((p) => Product.fromJson(p))
            .toList(),
        'Department Stores': (jsonResponse['department_products'] as List)
            .map((p) => Product.fromJson(p))
            .toList(),
        'Trending': (jsonResponse['trending_product'] as List)
            .map((p) => Product.fromJson(p))
            .toList(),
      };
    });
  }

  // Fetch user data from Firestore
  Future<Map<String, dynamic>?> _fetchUserData() async {
    if (user == null) return null;
    try {
      DocumentSnapshot<Map<String, dynamic>> doc =
          await _firestore.collection('users').doc(user!.uid).get();
      if (doc.exists) {
        return doc.data();
      } else {
        return null;
      }
    } catch (e) {
      // Handle errors as needed
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: EdgeInsets.all(8.0.w),
          child: Image.asset('assets/icons/menu_icon.png'),
        ),
        title: Padding(
          padding: EdgeInsets.only(left: 80.w),
          child: Image.asset(
            'assets/images/logo.png',
            width: 60.w,
            height: 60.h,
          ),
        ),
        actions: [
          // Logout Button
          Padding(
            padding: EdgeInsets.only(right: 1.w),
            child: IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                context.read<AuthBloc>().add(SignOutRequested());
              },
            ),
          ),
          // Search and Scan Icons
          Padding(
            padding: EdgeInsets.only(right: 15.w),
            child: Row(
              children: [
                const Icon(Icons.search),
                SizedBox(width: 10.w),
                Image.asset('assets/icons/Scan.png'),
              ],
            ),
          ),
        ],
        // Removed the 'bottom' property
      ),
      body: productsByCategory == null
          ? const Center(child: CircularProgressIndicator())
          : FutureBuilder<Map<String, dynamic>?>(
              future: _userDataFuture, // Use the initialized Future
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // Loading State
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  // Error State
                  return Center(
                    child: Text(
                      'Error fetching user data',
                      style: LuxeTypo.titleSmall.copyWith(color: Colors.red),
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data == null) {
                  // No Data State
                  return Center(
                    child: Text(
                      'User data not found',
                      style: LuxeTypo.titleSmall.copyWith(color: Colors.grey),
                    ),
                  );
                } else {
                  // Data Retrieved Successfully
                  Map<String, dynamic> userData = snapshot.data!;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Greeting Section
                      Padding(
                        padding: EdgeInsets.only(left: 20.w, top: 20.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hi, ${userData['name'] ?? 'User'}',
                              style: LuxeTypo.titleSmall
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 5.h),
                            Text(
                              'What are you looking for today?',
                              style: LuxeTypo.displayLarge,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20.h),

                      // Flash Cover Section
                      _buildFlashCover(),

                      SizedBox(
                        height: 20.h,
                      ),

                      // Place DefaultTabController here
                      Expanded(
                        child: DefaultTabController(
                          length: categories.length,
                          child: Column(
                            children: [
                              // TabBar
                              TabBar(
                                isScrollable: true,
                                tabs: categories
                                    .map((category) => Tab(text: category))
                                    .toList(),
                              ),

                              // Expanded TabBarView
                              Expanded(
                                child: TabBarView(
                                  children: categories.map((category) {
                                    return _buildProductGrid(
                                        productsByCategory![category]!);
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
    );
  }

  int _current = 0;

  Widget _buildFlashCover() {
    return Column(
      children: [
        CarouselSlider.builder(
          carouselController: _carouselController, // Attach the controller
          itemCount: flashcards.length,
          itemBuilder: (context, index, realIndex) {
            return _buildFlashcardItem(flashcards[index]);
          },
          options: CarouselOptions(
            height: 230.h,
            viewportFraction: 1.0,
            enlargeCenterPage: false,
            autoPlay: true,
            autoPlayInterval: Duration(seconds: 5),
            onPageChanged: (index, reason) {
              setState(() {
                _current = index;
              });
            },
          ),
        ),
        SizedBox(height: 10.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: flashcards.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () => _carouselController.animateToPage(entry.key),
              child: Container(
                width: _current == entry.key ? 12.w : 8.w,
                height: _current == entry.key ? 12.h : 8.h,
                margin: EdgeInsets.symmetric(horizontal: 4.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.r),
                  color: _current == entry.key
                      ? LuxeColors.brandSecondry
                      : Colors.grey,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // Build individual flashcard item
  Widget _buildFlashcardItem(Map<String, String> flashcard) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        image: DecorationImage(
          image: NetworkImage(flashcard['imageUrl']!),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          // Overlay Gradient
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
              gradient: LinearGradient(
                colors: [Colors.black.withOpacity(0.3), Colors.transparent],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ),
          // Flashcard Title
          Positioned(
            bottom: 10.h,
            left: 10.w,
            child: Text(
              flashcard['title']!,
              style: LuxeTypo.displayLarge
                  .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  // Build product grid
  Widget _buildProductGrid(List<Product> products) {
    return GridView.builder(
      padding: EdgeInsets.all(10.w),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Number of columns
        mainAxisSpacing: 10.h,
        crossAxisSpacing: 10.w,
        childAspectRatio: 0.7, // Adjust as needed
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        return _buildProductCard(products[index]);
      },
    );
  }

  // Build individual product card
  Widget _buildProductCard(Product product) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(10.r)),
              child: Image.network(
                product.imageURL,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[200],
                    child: Center(
                      child: Icon(Icons.image_not_supported),
                    ),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Name
                Text(
                  product.name,
                  style: LuxeTypo.titleSmall.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                // Product Price
                Text(
                  '\$${product.price.toStringAsFixed(2)}',
                  style: LuxeTypo.displayLarge.copyWith(
                    color: LuxeColors.brandPrimary,
                  ),
                ),
                SizedBox(height: 4.h),
                // Product Rating
                Row(
                  children: [
                    Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: 16.w,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      product.rating.toString(),
                      style: LuxeTypo.displayMedium,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      '(${product.reviewCount})',
                      style: LuxeTypo.displaySmall.copyWith(color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
