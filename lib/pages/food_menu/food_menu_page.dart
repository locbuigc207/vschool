import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:vschool/commons/models/childs/children_model.dart';
import 'package:vschool/commons/models/food_menu/food_menu_model.dart';
import 'package:vschool/commons/repository/food_repository.dart';
import 'package:vschool/commons/widgets/animations/fade_animation.dart';
import 'package:vschool/commons/widgets/container/gradient_header_container.dart';
import 'package:vschool/commons/widgets/container/rounded_top_container.dart';
import 'package:vschool/commons/widgets/pages/base_page.dart';
import 'package:vschool/commons/widgets/snackbar/snackbbar.dart';
import 'package:vschool/injections.dart';
import 'package:vschool/pages/food_menu/bloc/food_menu_bloc.dart';

@RoutePage()
class FoodMenuPage extends StatefulWidget {
  final ChildrenInfoModel child;

  const FoodMenuPage({Key? key, required this.child}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _FoodMenuPageState();
}

class _FoodMenuPageState extends State<FoodMenuPage> {
  final DateTime _currentDate = DateTime.now();

  var date = '';

  List<FoodMenuModel> lst = [];

  @override
  void initState() {
    date = DateFormat('yyyy-MM-dd').format(_currentDate);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      backgroundColor: Colors.white,
      title: 'Thực đơn ngày ${DateFormat('dd/MM').format(_currentDate)}',
      child: Stack(
        children: [
          FadeAnimation(
            delay: 0.5,
            child: GradientHeaderContainer(height: 140.h),
          ),
          SafeArea(
            child: FadeAnimation(
              delay: 1,
              direction: FadeDirection.up,
              child: RoundedTopContainer(
                margin: EdgeInsets.only(top: 16.h, bottom: 30.h),
                padding: EdgeInsets.fromLTRB(10.w, 16.h, 10.w, 2.h),
                child: MultiBlocProvider(
                  providers: [
                    BlocProvider(
                        create: (_) => FoodMenuBloc(
                            foodRepository: getIt<IFoodRepository>())
                          ..add(FoodMenuFetching(
                              classId: widget.child.classId!, date: date))),
                  ],
                  child: BlocConsumer<FoodMenuBloc, FoodMenuState>(
                    listener: (context, state) {
                      if (state is FoodMenuFetchingInitial) {
                        context.loaderOverlay.show();
                      } else if (state is FoodMenuFetchFailure) {
                        context.loaderOverlay.hide();
                        showErrorSnackBBar(
                            context: context, message: state.mess);
                      } else if (state is FoodMenuFetchSuccess) {
                        context.loaderOverlay.hide();
                        lst = state.data ?? [];
                      }
                    },
                    builder: (context, state) {
                      return lst.isNotEmpty
                          ? ListView.separated(
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                final food = lst[index];
                                return Padding(
                                  padding: EdgeInsets.fromLTRB(
                                    16.w,
                                    index == 0 ? 24.h : 0.h,
                                    16.w,
                                    index == lst.length - 1 ? 80.h : 0.h,
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        '${food.dishFoodMenuFkId}.',
                                        style: const TextStyle(fontSize: 18),
                                      ),
                                      SizedBox(width: 10.w),
                                      Text(
                                        food.dishName,
                                        style: const TextStyle(fontSize: 18),
                                      ),
                                      const Spacer(),
                                      Text(
                                        food.isUsing == 0
                                            ? 'Khả dụng'
                                            : 'Đã hết',
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: food.isUsing == 0
                                                ? Colors.green
                                                : Colors.red),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) =>
                                  SizedBox(height: 24.h),
                              itemCount: lst.length)
                          : Center(
                              child: Text('Không có dữ liệu'),
                            );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
