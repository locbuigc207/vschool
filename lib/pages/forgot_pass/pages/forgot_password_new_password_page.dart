import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vschool/commons/routes/router.dart';
import 'package:vschool/commons/widgets/buttons/loading_primary_button.dart';
import 'package:vschool/commons/widgets/modal/success_dialog.dart';
import 'package:vschool/commons/widgets/text_field/primary_text_field.dart';
import 'package:vschool/gen/assets.gen.dart';

@RoutePage()
class ForgotPassNewPassPage extends StatefulWidget {
  const ForgotPassNewPassPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ForgotPassNewPassPageState();
}

class _ForgotPassNewPassPageState extends State<ForgotPassNewPassPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
                        const PrimaryTextField(
                          labelText: 'Mật khẩu mới',
                          hintText: 'Nhập mật khẩu mới',
                        ),
                        SizedBox(height: 26.h),
                        SizedBox(
                          width: double.infinity,
                          child: LoadingPrimaryButton(
                            title: 'Xác nhận',
                            height: 56.h,
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (dialogContext) {
                                  return SuccessDialog(
                                    content:
                                        'Đặt lại mật khẩu thành công, vui lòng đăng nhập lại bằng mật khẩu mới.',
                                    buttonTitle: 'Đăng nhập ngay',
                                    onButtonTap: () {
                                      Navigator.of(dialogContext).pop();
                                      context.router
                                          .replaceAll([const LoginRoute()]);
                                    },
                                  );
                                },
                              );
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
    );
  }
}
