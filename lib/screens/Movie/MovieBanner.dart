import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:my_app/api/banner_service.dart';
import 'package:my_app/models/banner.dart';

class MovieBanner extends StatelessWidget {
  Future<List<Banners>> fetchBanner() async {
    try {
      return await BannerService.fetchBanners();
    } catch (e) {
      throw Exception("Không thể tải banner. Vui lòng kiểm tra kết nối mạng.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Banners>>(
      future: fetchBanner(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text("Lỗi tải banner: ${snapshot.error}"));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text("Không có banner nào"));
        }

        List<Banners> banners = snapshot.data!;

        return CarouselSlider(
          options: CarouselOptions(
            height: 180,
            autoPlay: true,
            autoPlayInterval: Duration(seconds: 3),
            enlargeCenterPage: true,
            viewportFraction: 0.9,
          ),
          items:
              banners.map((banner) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedNetworkImage(
                    imageUrl: banner.image,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    placeholder:
                        (context, url) =>
                            Center(child: CircularProgressIndicator()),
                    errorWidget:
                        (context, url, error) =>
                            Image.asset("assets/images/placeholder.png"),
                  ),
                );
              }).toList(),
        );
      },
    );
  }
}
