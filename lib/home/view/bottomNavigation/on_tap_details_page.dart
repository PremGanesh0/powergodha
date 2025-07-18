import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:powergodha/shared/api/api_models.dart';

class OnTapDetailsPage extends StatefulWidget {
  const OnTapDetailsPage({required this.item, super.key});

  final BottomNavigationData item;

  static Route<void> route(BottomNavigationData item) {
    return MaterialPageRoute(builder: (_) => OnTapDetailsPage(item: item));
  }

  @override
  State<OnTapDetailsPage> createState() => _OnTapDetailsPageState();
}

class _OnTapDetailsPageState extends State<OnTapDetailsPage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final items = widget.item.images;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
              pinned: true,
              title: Text('Information'),
          ),
          //This widget displays scrollable images
          SliverAppBar(
            automaticallyImplyLeading: false,
            toolbarHeight: 160,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  CarouselSlider(
                    items: items.map(_buildCarouselItem).toList(),
                    options: CarouselOptions(
                      height: 250,
                      viewportFraction: 0.999,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _currentIndex = index;
                        });
                      },
                    ),
                  ),
                  Positioned(
                      bottom: 23,
                      left: 10,
                      child: Text(
                        items[_currentIndex].name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                        ),
                      )
                  ),
                  Positioned(
                    bottom: 4,
                    child: _buildScrollingDots(items)
                  ),
                ],
              ),
            ),
            pinned: true,
          ),

          //this widget displays the content
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Html(
                    data: widget.item.content, // <-- your HTML string
                    style: {
                      'body': Style(
                        fontSize: FontSize(16),
                        lineHeight: LineHeight.number(1),
                        margin: Margins.zero,
                        padding: HtmlPaddings.zero,
                      ),
                      'h1': Style(
                        fontSize: FontSize(22),
                        fontWeight: FontWeight.bold,
                      ),
                      'h2': Style(
                        fontSize: FontSize(20),
                        fontWeight: FontWeight.bold,
                      ),
                      'h3': Style(
                        fontSize: FontSize(20),
                        fontWeight: FontWeight.bold,
                      ),
                      'h4': Style(
                        fontSize: FontSize(20),
                        fontWeight: FontWeight.bold,
                      ),
                      'p': Style(margin: Margins.only(bottom: 10)),

                      'span': Style(fontSize: FontSize(16)),
                      // add more tag styles if you like
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //used to build one image the carousel
  Widget _buildCarouselItem(ImagesList item) {
    return CachedNetworkImage(
      imageUrl: item.img,
      fit: BoxFit.cover,
      width: double.infinity,
      placeholder: (context, url) => Container(
        color: Colors.grey[200],
        child: const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  //used to build dots in carousel
  Widget _buildScrollingDots(List<ImagesList> items){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(items.length, (index) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: _currentIndex == index ? 10.0 : 8.0,
          height: _currentIndex == index ? 10.0 : 8.0,
          margin: const EdgeInsets.symmetric(horizontal: 4.99),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _currentIndex == index
                ? Theme.of(context).colorScheme.primary
                : Colors.white.withOpacity(0.6),
          ),
        );
      }),
    );
  }
}
