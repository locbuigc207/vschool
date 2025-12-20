import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:vschool/commons/repository/user_repository.dart';
import 'package:vschool/commons/widgets/animations/fade_animation.dart';
import 'package:vschool/commons/widgets/buttons/loading_primary_button.dart';
import 'package:vschool/commons/widgets/container/gradient_header_container.dart';
import 'package:vschool/commons/widgets/container/rounded_top_container.dart';
import 'package:vschool/commons/widgets/modal/success_dialog.dart';
import 'package:vschool/commons/widgets/pages/base_page.dart';
import 'package:vschool/commons/widgets/snackbar/snackbbar.dart';
import 'package:vschool/commons/widgets/text_field/password_text_field.dart';
import 'package:vschool/commons/widgets/text_field/phone_number_text_field.dart';
import 'package:vschool/injections.dart';
import 'package:vschool/pages/account/pages/change_password/bloc/change_password_bloc.dart';

@RoutePage()
class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ChangePasswordPageState();
}

class ChangePasswordPageState extends State<ChangePasswordPage> {
  late TextEditingController _usernameController;
  late TextEditingController _passwordOldController;
  late TextEditingController _passwordNewController;

  @override
  void initState() {
    _usernameController = TextEditingController(text: '');
    _passwordOldController = TextEditingController(text: '');
    _passwordNewController = TextEditingController(text: '');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (_) =>
                ChangePasswordBloc(userRepository: getIt<IUserRepository>())),
      ],
      child: BlocConsumer<ChangePasswordBloc, ChangePasswordState>(
        listener: (context, state) {
          if (state is ChangePasswordInitial) {
            context.loaderOverlay.show();
          } else if (state is ChangePasswordFailure) {
            context.loaderOverlay.hide();
            showErrorSnackBBar(context: context, message: state.mess);
          } else if (state is ChangePasswordSuccess) {
            context.loaderOverlay.hide();
            showDialog(
              context: context,
              builder: (contextDialog) {
                return SuccessDialog(
                  content: 'Đổi mật khẩu thành công',
                  contentTextAlign: TextAlign.center,
                  onButtonTap: () {
                    Navigator.of(contextDialog).pop();
                    Navigator.of(context).pop();
                  },
                );
              },
            );
          }
        },
        builder: (context, state) {
          return BasePage(
            backgroundColor: Colors.white,
            title: 'Đổi mật khẩu',
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
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Form(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 16.h, horizontal: 12.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  PhoneNumberTextField(
                                    controller: _usernameController,
                                    labelText: 'Số điện thoại',
                                  ),
                                  const SizedBox(height: 20),
                                  PasswordTextField(
                                    controller: _passwordOldController,
                                    labelText: 'Mật khẩu cũ',
                                    hintText: 'Mời nhập mật khẩu cũ',
                                  ),
                                  const SizedBox(height: 20),
                                  PasswordTextField(
                                    controller: _passwordNewController,
                                    labelText: 'Mật khẩu mới',
                                    hintText: 'Mời nhập mật khẩu mới',
                                  ),
                                  const SizedBox(height: 20),
                                  SizedBox(
                                    width: double.infinity,
                                    child: LoadingPrimaryButton(
                                      title: 'Xác nhận',
                                      height: 56.h,
                                      onTap: () {
                                        context.read<ChangePasswordBloc>().add(
                                            ChangePasswordSubmitted(
                                                username:
                                                    _usernameController.text,
                                                oldPassword:
                                                    _passwordOldController.text,
                                                newPassword:
                                                    _passwordNewController
                                                        .text));
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ))
              ],
            ),
          );
        },
      ),
    );
  }
}
