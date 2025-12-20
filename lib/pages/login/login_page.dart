import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:vschool/commons/repository/user_repository.dart';
import 'package:vschool/commons/routes/router.dart';
import 'package:vschool/commons/widgets/buttons/loading_primary_button.dart';
import 'package:vschool/commons/widgets/snackbar/snackbbar.dart';
import 'package:vschool/commons/widgets/text_field/password_text_field.dart';
import 'package:vschool/commons/widgets/text_field/phone_number_text_field.dart';
import 'package:vschool/gen/assets.gen.dart';
import 'package:vschool/gen/colors.gen.dart';
import 'package:vschool/injections.dart';
import 'package:vschool/pages/bloc/app/app_bloc.dart';
import 'package:vschool/pages/home/bloc/home_bloc.dart';
import 'package:vschool/pages/login/bloc/login_page_bloc.dart';

@RoutePage()
class LoginPage extends StatefulWidget implements AutoRouteWrapper {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginPageState();

  @override
  Widget wrappedRoute(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AppBloc(),
        ),
        BlocProvider(
            create: (_) => LoginPageBloc(
                userRepository: getIt<IUserRepository>(),
                appBloc: getIt<AppBloc>())),
        BlocProvider(
            create: (_) => HomePageBloc(
                userRepository: getIt<IUserRepository>(),
                appBloc: getIt<AppBloc>())),
      ],
      child: this,
    );
  }
}

class _LoginPageState extends State<LoginPage> {
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    _usernameController = TextEditingController(text: '');
    _passwordController = TextEditingController(text: '');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginPageBloc, LoginPageState>(
      listener: (context, state) {
        if (state is LoginProcessing) {
          context.loaderOverlay.show();
        } else if (state is LoginFail) {
          context.loaderOverlay.hide();
          showErrorSnackBBar(context: context, message: state.mess);
        } else if (state is LoginSuccess) {
          context.read<HomePageBloc>().add(const GetAllChildren());
          context.pushRoute(const HomeRouteProviderRoute());
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
                    SizedBox(height: 60.h),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Assets.images.logoHome.image(),
                      ],
                    ),
                    SizedBox(height: 40.h),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Đăng nhập",
                          style: TextStyle(
                              fontSize: 32.0,
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
                          const SizedBox(
                            height: 20,
                          ),
                          PasswordTextField(
                            controller: _passwordController,
                            labelText: 'Mật khẩu',
                            hintText: 'Mời nhập mật khẩu',
                            validator:
                                context.read<LoginPageBloc>().passwordValidator,
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () => context.pushRoute(
                                  const ForgotPasswordProviderRoute()),
                              child: const Text(
                                'Quên mật khẩu?',
                                style: TextStyle(
                                  color: ColorName.linkBlue,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                              width: double.infinity,
                              child: LoadingPrimaryButton(
                                title: 'Đăng nhập',
                                height: 56.h,
                                onTap: () {
                                  if (_usernameController.text.isEmpty ||
                                      _passwordController.text.isEmpty) {
                                    showErrorSnackBBar(
                                        context: context,
                                        message:
                                            'Vui lòng nhập tài khoản/mật khẩu');
                                  } else {
                                    context.read<LoginPageBloc>().add(Login(
                                        username: _usernameController.text,
                                        password: _passwordController.text));
                                    context
                                        .read<HomePageBloc>()
                                        .add(GetBannerContent());
                                  }
                                },
                              )),
                          SizedBox(height: 20.h),
                          Row(
                            children: [
                              TextButton(
                                onPressed: () =>
                                    context.pushRoute(AdmissionsRoute()),
                                child: const Text(
                                  'Đăng ký tuyển sinh',
                                  style: TextStyle(
                                    color: ColorName.linkBlue,
                                  ),
                                ),
                              ),
                              const Spacer(),
                              TextButton(
                                onPressed: () => context
                                    .pushRoute(const SearchInvoiceRoute()),
                                child: const Text(
                                  'Tra cứu hóa đơn',
                                  style: TextStyle(
                                    color: ColorName.linkBlue,
                                  ),
                                ),
                              ),
                            ],
                          )
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
