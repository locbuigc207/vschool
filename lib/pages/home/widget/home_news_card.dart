import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vschool/commons/models/banner/banner_model.dart';
import 'package:vschool/gen/assets.gen.dart';
import 'package:vschool/gen/colors.gen.dart';

class HomeNewsCard extends StatefulWidget {
  final List<BannerModel> lstContent;

  const HomeNewsCard({super.key, required this.lstContent});

  @override
  State<StatefulWidget> createState() => _HomeNewsCardState();
}

class _HomeNewsCardState extends State<HomeNewsCard> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.horizontal,
      children: [
        Flexible(
          child: Padding(
            padding: EdgeInsets.zero,
            child: ClipRect(
              child: Align(
                child: SizedBox(
                  height: 280.h,
                  width: double.infinity,
                  child: widget.lstContent.isEmpty
                      ? Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Assets.images.vschoolBanner.image(),
                        )
                      : Column(
                          children: [
                            Expanded(
                              child: PageView.builder(
                                controller: _pageController,
                                onPageChanged: (index) {
                                  setState(() {
                                    _currentPage = index;
                                  });
                                },
                                itemCount: widget.lstContent.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10.w, vertical: 10.h),
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                      child: NewsCard(
                                          queue: index,
                                          data: widget.lstContent[index]),
                                    ),
                                  );
                                },
                              ),
                            ),
                            if (widget.lstContent.length > 1)
                              Padding(
                                padding: EdgeInsets.only(bottom: 10.h),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(
                                    widget.lstContent.length,
                                    (index) => Container(
                                      width: 8.w,
                                      height: 8.h,
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 4.w),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: _currentPage == index
                                            ? ColorName.backgroundCardTopStart
                                            : Colors.grey
                                                .withValues(alpha: 0.3),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class NewsCard extends StatelessWidget {
  final int queue;
  final BannerModel data;

  const NewsCard({super.key, required this.queue, required this.data});

  @override
  Widget build(BuildContext context) {
    if (queue == 0) {
      return Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[
                  ColorName.backgroundCardTopStart,
                  ColorName.backgroundCardTopEnd,
                ]),
            borderRadius: BorderRadius.all(Radius.circular(12.0))),
        child: Container(
          padding: EdgeInsets.only(left: 16.w, bottom: 16.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      data.subContent ?? '',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Sarabun',
                      ),
                      overflow: TextOverflow.clip,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              Row(
                children: [
                  Flexible(
                    child: Text(
                      data.mainContent ?? '',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Sarabun',
                      ),
                      overflow: TextOverflow.clip,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    } else if (queue == 1) {
      return Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[
                  ColorName.backgroundCardMiddleStart,
                  ColorName.backgroundCardMiddleEnd
                ]),
            borderRadius: BorderRadius.all(Radius.circular(12.0))),
        child: Container(
          padding: EdgeInsets.only(left: 16.w, bottom: 16.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      data.subContent ?? '',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Sarabun',
                      ),
                      overflow: TextOverflow.clip,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              Row(
                children: [
                  Flexible(
                    child: Text(
                      data.mainContent ?? '',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Sarabun',
                      ),
                      overflow: TextOverflow.clip,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    } else {
      return Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[
                  ColorName.backgroundCardUnderStart,
                  ColorName.backgroundCardUnderEnd
                ]),
            borderRadius: BorderRadius.all(Radius.circular(12.0))),
        child: Container(
          padding: EdgeInsets.only(left: 16.w, bottom: 16.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      data.subContent ?? '',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Sarabun',
                      ),
                      overflow: TextOverflow.clip,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              Row(
                children: [
                  Flexible(
                    child: Text(
                      data.mainContent ?? '',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Sarabun',
                      ),
                      overflow: TextOverflow.clip,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }
  }
}
