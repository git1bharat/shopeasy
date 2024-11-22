import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:luxe_loft/bloc/product/bloc/product_bloc.dart';
import 'package:luxe_loft/bloc/product/bloc/product_state.dart';
import 'package:luxe_loft/data/flash_card_data.dart';
import 'package:luxe_loft/models/product.dart';
import 'package:luxe_loft/utill/luxe_color.dart';
import 'package:luxe_loft/utill/luxe_typography.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

final CarouselSliderController _carouselController = CarouselSliderController();

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

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
          child:
              Image.asset('assets/images/logo.png', width: 60.w, height: 60.h),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 1.w),
          ),
          Padding(
            padding: EdgeInsets.only(right: 15.w),
            child: Row(
              children: [
                Icon(Icons.search),
                SizedBox(width: 10),
                Image.asset('assets/icons/Scan.png'),
              ],
            ),
          ),
        ],
      ),
      body: BlocBuilder<ProductBloc, ProductState>(
        //Bloc used for statemanagment
        builder: (context, state) {
          if (state is ProductLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProductLoadedState) {
            return _buildLoadedUI(
                state.productsByCategory, state.userData, context);
          } else if (state is ProductErrorState) {
            return Center(
              child: Text(
                state.errorMessage,
                style: LuxeTypo.titleSmall.copyWith(color: Colors.red),
              ),
            );
          }
          return const Center(child: Text("No Data Available"));
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: LuxeColors.brandSecondry,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Category',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Message',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Private',
          ),
        ],
      ),
    );
  }

  Widget _buildLoadedUI(Map<String, List<Product>> productsByCategory,
      Map<String, dynamic>? userData, BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hi, ${userData!['name'] ?? 'User'}',
                style:
                    LuxeTypo.titleSmall.copyWith(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5.h),
              const Text(
                'What are you looking for today?',
                style: LuxeTypo.displayLarge,
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
        _buildFlashCover(),
        SizedBox(
          height: 20.h,
        ),
        Expanded(
            child: DefaultTabController(
          length: productsByCategory.length,
          child: Column(
            children: [
              // TabBar
              TabBar(
                isScrollable: true,
                tabs: productsByCategory.entries
                    .map((entry) => Tab(text: entry.key))
                    .toList(),
              ),
              Expanded(
                child: TabBarView(
                  children: productsByCategory.keys.map((category) {
                    // Check if the category exists in productsByCategory
                    if (productsByCategory.containsKey(category)) {
                      return _buildProductGrid(productsByCategory[category]!);
                    } else {
                      return const Center(
                        child: Text(
                          'No products available',
                          style: LuxeTypo.titleSmall,
                        ),
                      );
                    }
                  }).toList(),
                ),
              ),
            ],
          ),
        )),
      ],
    );
  }
}

int _current = 0;
Widget _buildFlashCover() {
  return Column(
    children: [
      CarouselSlider.builder(
        carouselController: _carouselController,
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
            _current = index;
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

Widget _buildFlashcardItem(Map<String, String> flashcard) {
  return Container(
    decoration: BoxDecoration(
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

Widget _buildProductGrid(List<Product> products) {
  return GridView.builder(
    padding: EdgeInsets.all(10.w),
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 4,
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

Widget _buildProductCard(Product product) {
  return Column(
    children: [
      Container(
        decoration: BoxDecoration(
          color: LuxeColors.brandWhite,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: LuxeColors.brandSecondry,
            width: 1.0,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 4.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Product Image
              ClipRRect(
                borderRadius: BorderRadius.circular(
                    10.r), // Match the container's border radius
                child: Center(
                  child: Image.network(
                    product.imageURL,
                    width: 60.w, // Smaller image width
                    height: 60.h, // Smaller image height
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[200],
                        child: Icon(
                          Icons.image_not_supported,
                          size: 18.r, // Smaller fallback icon size
                        ),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(height: 6.h),
              // Product Name
            ],
          ),
        ),
      ),
      Text(
        product.name,
        textAlign: TextAlign.center,
        style: LuxeTypo.titleSmall.copyWith(
          fontWeight: FontWeight.bold,
          fontSize: 10.sp, // Smaller font size
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    ],
  );
}
