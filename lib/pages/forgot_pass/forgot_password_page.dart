import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:vschool/commons/routes/router.dart';
import 'package:vschool/commons/widgets/buttons/loading_primary_button.dart';
import 'package:vschool/commons/widgets/modal/success_dialog.dart';
import 'package:vschool/commons/widgets/text_field/phone_number_text_field.dart';
import 'package:vschool/gen/assets.gen.dart';
import 'package:vschool/gen/colors.gen.dart';
import 'package:vschool/pages/forgot_pass/bloc/forgot_password_bloc.dart';

@RoutePage()
class ForgotPassPage extends StatefulWidget {
  const ForgotPassPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ForgotPassPageState();
}

class _ForgotPassPageState extends State<ForgotPassPage> {
  TextEditingController _usernameController = TextEditingController();

  @override
  void initState() {
    _usernameController = TextEditingController(text: '');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ForgotPasswordBloc, ForgotPasswordState>(
      listener: (context, state) {
        if (state is ForgotPassInitial) {
          context.loaderOverlay.show();
        } else if (state is ForgotPasswordFailure) {
          context.loaderOverlay.hide();
          showDialog(
            context: context,
            builder: (contextDialog) {
              return SuccessDialog(
                title: 'Thất bại',
                content: 'Reset mật khẩu thất bại! \n Vui lòng thử lại sau!',
                imageType: 1,
                contentTextAlign: TextAlign.center,
                buttonTitle: 'Thử lại',
                onButtonTap: () async {
                  Navigator.of(contextDialog).pop();
                },
              );
            },
          );
        } else if (state is ForgotPasswordSuccess) {
          context.loaderOverlay.hide();
          showDialog(
            context: context,
            builder: (contextDialog) {
              return SuccessDialog(
                content: 'Reset mật khẩu thành công',
                contentTextAlign: TextAlign.center,
                buttonTitle: 'Đăng nhập ngay',
                onButtonTap: () async {
                  Navigator.of(contextDialog).pop();
                  context.pushRoute(const LoginRoute());
                },
              );
            },
          );
        }
      },
      child: SafeArea(
        child: Scaffold(
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    SizedBox(height: 80.h),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Assets.images.logoHome.image(),
                      ],
                    ),
                    SizedBox(height: 50.h),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextButton.icon(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(
                            Icons.arrow_back,
                            color: ColorName.linkBlue,
                            size: 16,
                          ),
                          label: const Text(
                            'Đăng nhập',
                            style: TextStyle(
                              color: ColorName.linkBlue,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 2.h),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Quên mật khẩu",
                          style: TextStyle(
                              fontSize: 24.0,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Sarabun'),
                        ),
                      ],
                    ),
                    /*--form login--*/
                    Form(
                        child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          PhoneNumberTextField(
                            controller: _usernameController,
                            labelText: 'Số điện thoại',
                          ),
                          SizedBox(height: 26.h),
                          SizedBox(
                            width: double.infinity,
                            child: LoadingPrimaryButton(
                              title: 'Xác nhận',
                              height: 56.h,
                              onTap: () {
                                context.read<ForgotPasswordBloc>().add(
                                    ForgetPasswordSubmitted(
                                        parentPhoneNum:
                                            _usernameController.text));
                              },
                            ),
                          ),
                        ],
                      ),
                    ))

                    /*--end form login--*/
                  ],
                ),
              ),
            )),
      ),
    );
  }
}
