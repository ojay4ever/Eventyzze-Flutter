import 'dart:math';

import 'package:eventyzze/cache/shared_preferences_helper.dart';
import 'package:eventyzze/config/app_theme.dart';
import 'package:eventyzze/config/app_utils.dart';
import 'package:eventyzze/config/get_it.dart';
import 'package:eventyzze/enums/enums.dart';
import 'package:eventyzze/helper/navigation_helper.dart';
import 'package:eventyzze/model/event_model.dart';
import 'package:eventyzze/model/stream_model.dart';
import 'package:eventyzze/utils/custom_snack_bar.dart';
import 'package:eventyzze/views/eventScreens/event_details_screen.dart';
import 'package:eventyzze/views/eventScreens/event_payment_form_screen.dart';
import 'package:eventyzze/views/homeScreens/commonWidget/common_title_text.dart';
import 'package:eventyzze/views/homeScreens/home_controller.dart';
import 'package:eventyzze/views/streamScreen/live_stream_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:eventyzze/config/app_font.dart';
import 'package:eventyzze/config/app_images.dart';
import 'package:get/get.dart';
import '../../customWidgets/mini_event_tile.dart';
import '../../customWidgets/custom_categories.dart';
import '../../customWidgets/custom_event_card.dart';
import '../eventScreens/event_payment_form_screen.dart';

class HomePageViewer extends StatefulWidget {
  const HomePageViewer({super.key});

  @override
  State<HomePageViewer> createState() => _HomePageViewerState();
}

class _HomePageViewerState extends State<HomePageViewer> {
  late final HomeController _homeController;
  late final SharedPrefsHelper _sharedPrefsHelper;
  String _selectedCategory = 'Trending';
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _homeController = Get.isRegistered<HomeController>()
        ? Get.find<HomeController>()
        : Get.put(HomeController());
    _sharedPrefsHelper = getIt<SharedPrefsHelper>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_homeController.trendingEvents.isEmpty) {
        _homeController.fetchTrendingEvents();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    CustomScreenUtil.init(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => _homeController.fetchTrendingEvents(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 2.6.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 1.6.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CommonTitleText(
                      title: 'Explore New Hosts',
                      color: Color(0xFF000000).withValues(alpha: 0.6),
                    ),
                    SvgPicture.asset(
                      AppImages.search,
                      width: 2.2.w,
                      height: 2.2.h,
                    ),
                  ],
                ),
                SizedBox(height: 1.6.h),
                _profileImage(),
                SizedBox(height: 2.h),
                _liveShow(),
                SizedBox(height: 1.6.h),
                Obx(() {
                  final events = _homeController.trendingEvents;
                  if (_homeController.isLoadingTrending.value) {
                    return SizedBox(
                      height: 36.h,
                      child: const Center(child: CircularProgressIndicator()),
                    );
                  }
                  
                  if (events.isEmpty) {
                    return SizedBox(
                      height: 36.h,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          _liveShowCard(AppImages.man, price: 50, onTap: () {

                          }),
                          SizedBox(width: 1.6.h),
                          _liveShowCard(AppImages.singGirl, price: 100),
                        ],
                      ),
                    );
                  }
                  
                  return SizedBox(
                    height: 36.h,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: events.length,
                      separatorBuilder: (_, __) => SizedBox(width: 1.6.h),
                      itemBuilder: (context, index) {
                        final event = events[index];
                        String? imageUrl;
                        if (event.advertisementUrl != null && event.advertisementUrl!.trim().isNotEmpty) {
                          imageUrl = event.advertisementUrl!.trim();
                        } else if (event.organizerProfilePicture != null && event.organizerProfilePicture!.trim().isNotEmpty) {
                          imageUrl = event.organizerProfilePicture!.trim();
                        }
                        
                        return _liveShowCardFromUrl(
                          imageUrl: imageUrl,
                          price: event.price,
                          onTap: () => _handleEventTap(event),
                        );
                      },
                    ),
                  );
                }),
                SizedBox(height: 2.h),
                _eventDayCard(),
                SizedBox(height: 2.h),
                CommonTitleText(title: 'Recommended Shows',
                  color: Color(0xFF000000).withValues(alpha: 0.6),
                ),
                SizedBox(height: 2.h),
                CustomCategories(
                  categories: const [
                    "Trending",
                    "New",
                    "Discover",
                    "Music",
                    "Comedy",
                  ],
                  onSelected: (selected) {
                    setState(() {
                      _selectedCategory = selected;
                    });

                    if (selected == 'Trending' &&
                        !_homeController.isLoadingTrending.value &&
                        _homeController.trendingEvents.isEmpty) {
                      _homeController.fetchTrendingEvents();
                    }
                  },
                ),
                SizedBox(height: 2.h),
                _miniEventCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget _liveShowCard(String imagePath, {int price = 0, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(imagePath, width: 220, height: 323, fit: BoxFit.cover),
          ),
          if (price > 0)
            Positioned(
              top: 12,
              right: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.monetization_on,
                      color: AppTheme.kPrimaryColor,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '$price',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _liveShowCardFromUrl({String? imageUrl, int price = 0, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: imageUrl != null && imageUrl.isNotEmpty
                ? Image.network(
                    imageUrl,
                    width: 220,
                    height: 323,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        width: 220,
                        height: 323,
                        color: Colors.grey[200],
                        child: const Center(child: CircularProgressIndicator()),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        AppImages.man,
                        width: 220,
                        height: 323,
                        fit: BoxFit.cover,
                      );
                    },
                  )
                : Image.asset(
                    AppImages.man,
                    width: 220,
                    height: 323,
                    fit: BoxFit.cover,
                  ),
          ),
          if (price > 0)
            Positioned(
              top: 12,
              right: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.monetization_on,
                      color: AppTheme.kPrimaryColor,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '$price',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _profileImage() {
    return Column(
      children: [
        SizedBox(
          height: 64,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _homeController.trendingEvents.length > 0 
                ? _homeController.trendingEvents.length 
                : 6,
            separatorBuilder: (context, _) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              return Obx(() {
                final events = _homeController.trendingEvents;
                if (events.length > index) {
                  final event = events[index];
                  String? imageUrl;
                  
                  if (event.advertisementUrl != null && event.advertisementUrl!.trim().isNotEmpty) {
                    imageUrl = event.advertisementUrl!.trim();
                  } else if (event.organizerProfilePicture != null && event.organizerProfilePicture!.trim().isNotEmpty) {
                    imageUrl = event.organizerProfilePicture!.trim();
                  }
                  
                  if (imageUrl != null && imageUrl.isNotEmpty) {
                    return Container(
                      width: 60,
                      height: 60,
                      decoration: const BoxDecoration(shape: BoxShape.circle),
                      clipBehavior: Clip.hardEdge,
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          if (index < 6) {
                            return Image.asset(
                              _getStaticImage(index),
                              fit: BoxFit.cover,
                            );
                          }
                          return Container(
                            color: Colors.grey[300],
                            child: Icon(Icons.event, color: Colors.grey[600]),
                          );
                        },
                      ),
                    );
                  }
                }
                if (index < 6) {
                  return Container(
                    width: 60,
                    height: 60,
                    decoration: const BoxDecoration(shape: BoxShape.circle),
                    clipBehavior: Clip.hardEdge,
                    child: Image.asset(_getStaticImage(index), fit: BoxFit.cover),
                  );
                }
                return Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[300],
                  ),
                  child: Icon(Icons.event, color: Colors.grey[600], size: 24),
                );
              });
            },
          ),
        ),
      ],
    );
  }

  String _getStaticImage(int index) {
    final imageList = [
      AppImages.firstP,
      AppImages.second,
      AppImages.third,
      AppImages.fourth,
      AppImages.fifth,
      AppImages.sixth,
    ];
    return imageList[index];
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
    return Obx(() {
      final events = _homeController.trendingEvents;
      if (events.isEmpty) {
        return CustomEventCard(
          title: "The Show Of\nThe Century!",
          artist: "-JohnSings",
          date: "June 14th, 2025",
          time: "4PM",
          backgroundImage: AppImages.lightBg,
          artistImage: AppImages.singingMen,
          price: 50,
          onTap: () {},
        );
      }
      final event = events.first;
      String? imageUrl;
      if (event.advertisementUrl != null && event.advertisementUrl!.trim().isNotEmpty) {
        imageUrl = event.advertisementUrl!.trim();
      } else if (event.organizerProfilePicture != null && event.organizerProfilePicture!.trim().isNotEmpty) {
        imageUrl = event.organizerProfilePicture!.trim();
      }
      
      return CustomEventCardWithNetwork(
        title: event.title,
        artist: event.description.isNotEmpty ? event.description : "Event Details",
        date: event.date,
        time: event.time,
        backgroundImage: AppImages.lightBg,
        artistImageUrl: imageUrl,
        price: event.price,
        onTap: () => _handleEventTap(event),
      );
    });
  }

  Widget _miniEventCard() {
    if (_selectedCategory != 'Trending') {
      return _comingSoonPlaceholder();
    }

    return Obx(() {
      if (_homeController.isLoadingTrending.value) {
        return SizedBox(
          height: 12.h,
          child: const Center(child: CircularProgressIndicator()),
        );
      }

      if (_homeController.trendingError.value.isNotEmpty) {
        return _errorState(_homeController.trendingError.value);
      }

      final events = _homeController.trendingEvents;

      if (events.isEmpty) {
        return _emptyTrendingState();
      }

      return Column(
        children: events.map((event) {
          final hasAdImage = (event.advertisementUrl ?? '').trim().isNotEmpty;
          final imagePath = hasAdImage
              ? event.advertisementUrl!.trim()
              : AppImages.pic;

          return Padding(
            padding: EdgeInsets.only(bottom: 2.h),
            child: MiniEventTile(
              imagePath: imagePath,
              isAsset: !hasAdImage,
              title: event.title,
              subtitle: event.description,
              price: event.price,
              onTap: () => _handleEventTap(event),
            ),
          );
        }).toList(),
      );
    });
  }

  Widget _comingSoonPlaceholder() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Column(
        children: [
          Text(
            '$_selectedCategory shows coming soon',
            style: TextStyle(
              fontFamily: AppFonts.lato,
              fontWeight: FontWeight.w600,
              fontSize: 1.6.h,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Stay tuned while we curate the best experiences for you.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: AppFonts.lato,
              fontWeight: FontWeight.w400,
              fontSize: 1.4.h,
              color: Colors.black.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _errorState(String message) {
    return Column(
      children: [
        Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: AppFonts.lato,
            fontWeight: FontWeight.w600,
            fontSize: 1.4.h,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 1.2.h),
        TextButton(
          onPressed: _homeController.fetchTrendingEvents,
          child: const Text('Retry'),
        ),
      ],
    );
  }

  Widget _emptyTrendingState() {
    return Column(
      children: [
        Text(
          'No events yet',
          style: TextStyle(
            fontFamily: AppFonts.lato,
            fontWeight: FontWeight.w700,
            fontSize: 1.6.h,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 0.8.h),
        Text(
          'Create an event to see it appear here.',
          style: TextStyle(
            fontFamily: AppFonts.lato,
            fontWeight: FontWeight.w400,
            fontSize: 1.4.h,
            color: Colors.black.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }

  Future<void> _handleEventTap(EventModel event) async {
    final currentUserId = await _sharedPrefsHelper.getDatabaseId();
    final isOwner = currentUserId.isNotEmpty && currentUserId == event.organizerId;
    final hasPurchased = event.participantIds.contains(currentUserId);

    if (isOwner || hasPurchased) {
      _joinEventStream(event);
      return;
    }

    NavigationHelper.goToNavigatorScreen(
      context,
      EventPaymentFormScreen(
        event: event,
        onPaymentSuccess: () {
          _joinEventStream(event);
        },
      ),
    );
  }

  Future<void> _joinEventStream(EventModel event) async {
    final uid = _generateAgoraUid();
    final currentUserId = await _sharedPrefsHelper.getDatabaseId();
    final isHost =
        currentUserId.isNotEmpty && currentUserId == event.organizerId;
    _showLoadingDialog();
    final EventStreamJoinData? streamData = await _homeController
        .joinEventStream(eventId: event.id, uid: uid);

    if (mounted) {
      Navigator.of(context, rootNavigator: true).pop();
    }

    if (streamData == null) {
      final message = _homeController.joinError.value.isNotEmpty
          ? _homeController.joinError.value
          : 'Unable to join this stream right now.';
      CustomSnackBar.error(title: 'Join failed', message: message);
      return;
    }

    if (!mounted) return;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => LiveStreamScreen(
          event: event,
          streamData: streamData,
          isHost: isHost,
        ),
      ),
    );
  }

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );
  }

  int _generateAgoraUid() {
    return 100000 + _random.nextInt(900000);
  }
}
