import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:vschool/commons/routes/router.dart';
import 'package:vschool/commons/widgets/buttons/loading_primary_button.dart';

import 'package:vschool/gen/assets.gen.dart';
import 'package:vschool/gen/colors.gen.dart';

@RoutePage()
class ForgotPasswordOtpPage extends StatefulWidget {
  const ForgotPasswordOtpPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ForgotPasswordOtpPageState();
}

class _ForgotPasswordOtpPageState extends State<ForgotPasswordOtpPage> {
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
                  SizedBox(height: 12.h),
                  Row(children: const [
                    Text(
                      'Nhập mã OTP',
                    )
                  ]),
                  /*--form login--*/
                  Form(
                      child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PinCodeTextField(
                          appContext: context,
                          animationType: AnimationType.fade,
                          length: 6,
                          obscureText: false,
                          pinTheme: PinTheme(
                            shape: PinCodeFieldShape.box,
                            fieldHeight: 46.r,
                            fieldWidth: 46.r,
                            borderRadius: BorderRadius.circular(8.0),
                            errorBorderColor: ColorName.error,
                            borderWidth: 1.0,
                            activeColor: ColorName.disabledBorderColor,
                            activeFillColor: Colors.white,
                            inactiveColor: ColorName.disabledBorderColor,
                            inactiveFillColor: Colors.white,
                            selectedColor: ColorName.disabledBorderColor,
                            selectedFillColor: Colors.white,
                          ),
                          backgroundColor: Colors.transparent,
                          autoDismissKeyboard: true,
                          autoFocus: true,
                          keyboardType: TextInputType.number,
                          textStyle:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    fontSize: 22.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                          onChanged: (value) {},
                          beforeTextPaste: (text) {
                            return false;
                          },
                        ),
                        SizedBox(height: 26.h),
                        SizedBox(
                          width: double.infinity,
                          child: LoadingPrimaryButton(
                            title: 'Xác thực',
                            height: 56.h,
                            onTap: () => context
                                .pushRoute(const ForgotPassNewPassRoute()),
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              onPressed: () {},
                              child: const Text(
                                'Gửi lại mã?',
                                style: TextStyle(
                                  color: ColorName.linkBlue,
                                ),
                              ),
                            ),
                          ],
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
