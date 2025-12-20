import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:vschool/commons/models/childs/children_model.dart';
import 'package:vschool/commons/models/heath/heath_model.dart';
import 'package:vschool/commons/repository/heath_repository.dart';
import 'package:vschool/commons/widgets/animations/fade_animation.dart';
import 'package:vschool/commons/widgets/container/gradient_header_container.dart';
import 'package:vschool/commons/widgets/container/rounded_top_container.dart';
import 'package:vschool/commons/widgets/pages/base_page.dart';
import 'package:vschool/commons/widgets/pages/no_data_page.dart';
import 'package:vschool/commons/widgets/snackbar/snackbbar.dart';
import 'package:vschool/injections.dart';
import 'package:vschool/pages/heath/bloc/heath_bloc.dart';

@RoutePage()
class HeathPage extends StatefulWidget {
  final ChildrenInfoModel child;

  const HeathPage({Key? key, required this.child}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HeathPageState();
}

class _HeathPageState extends State<HeathPage> {
  List<HeathModel> lst = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      backgroundColor: Colors.white,
      title: 'Sức khỏe',
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
                        create: (_) => HeathBloc(
                            heathRepository: getIt<IHeathRepository>())
                          ..add(GetHeathInfo(
                              studentId: widget.child.studentId!))),
                  ],
                  child: BlocConsumer<HeathBloc, HeathState>(
                    listener: (context, state) {
                      if (state is HeathFetching) {
                        context.loaderOverlay.show();
                      } else if (state is HeathFetchFailure) {
                        context.loaderOverlay.hide();
                        showErrorSnackBBar(
                            context: context, message: state.mess);
                      } else if (state is HeathFetchSuccess) {
                        context.loaderOverlay.hide();
                        lst = state.heathInfo ?? [];
                      }
                    },
                    builder: (context, state) {
                      return lst.isEmpty
                          ? NoDataPage(
                              onTap: () => context.read<HeathBloc>().add(
                                  GetHeathInfo(
                                      studentId: widget.child.studentId!)))
                          : ListView.separated(
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                final heath = lst[index];
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
                                        'Tình trạng sức khỏe: ${heath.heathInfo}',
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) =>
                                  SizedBox(height: 24.h),
                              itemCount: lst.length);
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
