import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:vschool/commons/models/childs/children_model.dart';
import 'package:vschool/commons/routes/router.dart';
import 'package:vschool/commons/widgets/animations/fade_animation.dart';
import 'package:vschool/commons/widgets/buttons/list_button.dart';
import 'package:vschool/commons/widgets/container/gradient_header_container.dart';
import 'package:vschool/commons/widgets/container/rounded_top_container.dart';
import 'package:vschool/commons/widgets/pages/base_page.dart';
import 'package:vschool/commons/widgets/snackbar/snackbbar.dart';
import 'package:vschool/gen/assets.gen.dart';
import 'package:vschool/pages/home/bloc/home_bloc.dart';
import 'package:vschool/injections.dart';
import 'package:vschool/commons/repository/user_repository.dart';
import 'package:vschool/pages/bloc/app/app_bloc.dart';

@RoutePage()
class ListChildrenPage extends StatefulWidget {
  const ListChildrenPage({Key? key}) : super(key: key);

  @override
  State<ListChildrenPage> createState() => _ListChildrenPageState();
}

class _ListChildrenPageState extends State<ListChildrenPage> {
  late List<ChildrenInfoModel> lstChildren = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomePageBloc(
        userRepository: getIt<IUserRepository>(),
        appBloc: getIt<AppBloc>(),
      )..add(const GetAllChildren()),
      child: BasePage(
        backgroundColor: Colors.white,
        title: 'Danh sách học sinh',
        child: Stack(
          children: [
            FadeAnimation(
              delay: 0.5,
              child: GradientHeaderContainer(
                height: 140.h,
              ),
            ),
            SafeArea(
              child: FadeAnimation(
                delay: 1,
                direction: FadeDirection.up,
                child: RoundedTopContainer(
                  child: BlocConsumer<HomePageBloc, HomePageState>(
                    listener: (context, state) {
                      if (state is GetAllChildrenInitial) {
                        context.loaderOverlay.show();
                      } else if (state is GetAllChildrenFailure) {
                        context.loaderOverlay.hide();
                        showErrorSnackBBar(
                            context: context, message: state.mess ?? '');
                      } else if (state is GetAllChildrenSuccess) {
                        context.loaderOverlay.hide();
                        lstChildren = state.children;
                      }
                    },
                    builder: (context, state) {
                      return ListView.separated(
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            final child = lstChildren[index];
                            return Padding(
                              padding: EdgeInsets.fromLTRB(
                                16.w,
                                index == 0 ? 24.h : 0.h,
                                16.w,
                                index == lstChildren.length - 1 ? 80.h : 0.h,
                              ),
                              child: ListButton(
                                leading: child.gender != null
                                    ? (child.gender == true
                                        ? Assets.images.avatarMale
                                            .svg(height: 30.r)
                                        : Assets.images.avatarFemale
                                            .svg(height: 30.r))
                                    : Assets.images.avatarNinja.svg(height: 30.r),
                                trailing: Assets.icons.chevronRight.svg(),
                                title: child.name ?? '',
                                onTap: () {
                                  context.pushRoute(
                                      ChildrenDetailRoute(child: child));
                                },
                              ),
                            );
                          },
                          separatorBuilder: (context, index) =>
                              SizedBox(height: 24.h),
                          itemCount: lstChildren.length);
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
