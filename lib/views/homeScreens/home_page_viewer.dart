import 'package:eventyzze/config/app_theme.dart';
import 'package:eventyzze/config/app_utils.dart';
import 'package:eventyzze/enums/enums.dart';
import 'package:eventyzze/views/homeScreens/commonWidget/common_title_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:eventyzze/config/app_font.dart';
import 'package:eventyzze/config/app_images.dart';

import '../../customWidget/mini_event_tile.dart';
import '../../customWidget/custom_categories.dart';
import '../../customWidget/custom_event_card.dart';

class HomePageViewer extends StatefulWidget {
  const HomePageViewer({super.key});

  @override
  State<HomePageViewer> createState() => _HomePageViewerState();
}

class _HomePageViewerState extends State<HomePageViewer> {
  @override
  Widget build(BuildContext context) {
    CustomScreenUtil.init(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 2.6.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 1.6.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CommonTitleText(title: 'Explore New Hosts'),
                  SvgPicture.asset(
                      AppImages.search, width: 2.2.w, height: 2.2.h),
                ],
              ),
              SizedBox(height: 1.6.h),
              _profileImage(),
              SizedBox(height: 2.h),
              _liveShow(),
              SizedBox(height: 1.6.h),
              SizedBox(
                height: 36.h,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _liveShowCard(AppImages.men),
                    SizedBox(width: 1.6.h),
                    _liveShowCard(AppImages.singGirl),
                  ],
                ),
              ),
              SizedBox(height: 2.h),
              _eventDayCard(),
              SizedBox(height: 2.h),
              CommonTitleText(title: 'Recommended Shows'),
              SizedBox(height: 2.h,),
              CustomCategories(
                categories: ["Trending", "New", "Discover", "Music", "Comedy"],
                onSelected: (selected) {
                },
              ),
              SizedBox(height: 2.h,),
              _miniEventCard(),

            ],
          ),
        ),
      ),
    );
  }

  Widget _liveShowCard(String imagePath) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.asset(imagePath, width: 220, height: 323, fit: BoxFit.cover),
    );
  }

  Widget _profileImage() {
    return Column(
      children: [
        SizedBox(
          height: 64,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: 6,
            separatorBuilder: (context, _) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final imageList = [
                AppImages.firstP,
                AppImages.second,
                AppImages.third,
                AppImages.fourth,
                AppImages.fifth,
                AppImages.sixth,
              ];
              return Container(
                width: 60,
                height: 60,
                decoration: const BoxDecoration(shape: BoxShape.circle),
                clipBehavior: Clip.hardEdge,
                child: Image.asset(imageList[index], fit: BoxFit.cover),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _liveShow() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Live shows",
              style: TextStyle(
                fontFamily: AppFonts.inter,
                fontWeight: FontWeight.w700,
                fontSize: 20,
                color: AppTheme.kPrimaryColor,
                letterSpacing: -0.17,
              ),
            ),
            Text(
              "See all",
              style: TextStyle(
                fontFamily: AppFonts.inter,
                fontWeight: FontWeight.w500,
                fontSize: 12,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _eventDayCard() {
    return CustomEventCard(
      title: "The Show Of\nThe Century!",
      artist: "-JohnSings",
      date: "June 14th, 2025",
      time: "4PM",
      backgroundImage: AppImages.lightBg,
      artistImage: AppImages.singingMen,
      onTap: () {
      },
    );
  }

  Widget _miniEventCard() {
    return Column(
      children: [
        MiniEventTile(
          imagePath: AppImages.pic,
          title: 'Peace , Love and Light ( music fest)',
          subtitle: 'Pitcher',
          onTap: () {},
        ),
        SizedBox(height: 2.h,), MiniEventTile(
          imagePath: AppImages.goldenMen,
          title: 'Peace , Love and Light ( music fest)',
          subtitle: 'Pitcher',
          onTap: () {},
        ),
        SizedBox(height: 2.h,), MiniEventTile(
          imagePath: AppImages.mic,
          title: 'Livally concerto',
          subtitle: 'Livally concerto',
          onTap: () {},
        ),
        SizedBox(height: 2.h,), MiniEventTile(
          imagePath: AppImages.airPhone,
          title: 'Sing Off',
          subtitle: 'Musiccc',
          onTap: () {},
        ),
        SizedBox(height: 2.h,), MiniEventTile(
          imagePath: AppImages.men,
          title: 'Shine on Music',
          subtitle: 'Dan the creator',
          onTap: () {},
        ),
        SizedBox(height: 2.h,),

      ],
    );
  }
}
