import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:vschool/commons/models/childs/children_model.dart';
import 'package:vschool/commons/repository/user_repository.dart';
import 'package:vschool/commons/widgets/animations/fade_animation.dart';

import 'package:vschool/commons/widgets/container/gradient_header_container.dart';
import 'package:vschool/commons/widgets/container/rounded_top_container.dart';
import 'package:vschool/commons/widgets/modal/success_dialog.dart';
import 'package:vschool/commons/widgets/pages/base_page.dart';
import 'package:vschool/commons/widgets/snackbar/snackbbar.dart';
import 'package:vschool/commons/widgets/text_field/primary_text_field.dart';
import 'package:vschool/injections.dart';
import 'package:vschool/pages/account/pages/list_children/bloc/list_children_bloc.dart';
import 'package:vschool/pages/home/bloc/home_bloc.dart';

@RoutePage()
class ChildrenDetailPage extends StatefulWidget {
  final ChildrenInfoModel child;

  const ChildrenDetailPage({Key? key, required this.child}) : super(key: key);

  @override
  State<ChildrenDetailPage> createState() => _ChildrenDetailPageState();
}

class _ChildrenDetailPageState extends State<ChildrenDetailPage> {
  late TextEditingController _studentCodeController;
  late TextEditingController _studentNameController;
  late TextEditingController _studentDoBController;
  // ignore: unused_field
  late TextEditingController _addressController;
  // ignore: unused_field
  late TextEditingController _bhytController;
  late TextEditingController _cmndController;
  // ignore: unused_field
  late TextEditingController _mailController;

  @override
  void initState() {
    _studentCodeController =
        TextEditingController(text: widget.child.studentCode ?? '');
    _studentNameController =
        TextEditingController(text: widget.child.name ?? '');
    _studentDoBController = TextEditingController(text: widget.child.dob ?? '');
    // _addressController =
    // TextEditingController(text: widget.child.address ?? '');
    // _bhytController = TextEditingController(text: widget.child.bhytNum.toString());
    _cmndController = TextEditingController(text: widget.child.className ?? '');
    _mailController = TextEditingController(text: widget.child.email ?? '');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      backgroundColor: Colors.white,
      title: 'Thông tin học sinh',
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
              delay: 0.5,
              direction: FadeDirection.up,
              child: RoundedTopContainer(
                padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
                child: SingleChildScrollView(
                  child: BlocProvider(
                    create: (_) => ListChildrenBloc(
                        userRepository: getIt<IUserRepository>()),
                    child: BlocConsumer<ListChildrenBloc, ListChildrenState>(
                      listener: (context, state) {
                        if (state is UpdateInfoChildrenInitial) {
                          context.loaderOverlay.show();
                        } else if (state is UpdateInfoChildrenFailure) {
                          context.loaderOverlay.hide();
                          showErrorSnackBBar(
                              context: context, message: state.mess);
                        } else if (state is UpdateInfoChildrenSuccess) {
                          context.loaderOverlay.hide();
                          showDialog(
                            context: context,
                            builder: (contextDialog) {
                              return SuccessDialog(
                                content: state.mess,
                                contentTextAlign: TextAlign.center,
                                onButtonTap: () {
                                  Navigator.of(contextDialog).pop();
                                  context
                                      .read<HomePageBloc>()
                                      .add(const GetAllChildren());
                                  Navigator.of(context).pop();
                                },
                              );
                            },
                          );
                        }
                      },
                      builder: (context, state) {
                        return Column(
                          children: [
                            SizedBox(height: 10.h),
                            PrimaryTextField(
                              controller: _studentCodeController,
                              labelText: 'Mã học sinh',
                              hintText: 'Nhập mã học sinh',
                              readonly: true,
                              hasClearButton: false,
                            ),
                            SizedBox(height: 25.h),
                            PrimaryTextField(
                              controller: _studentNameController,
                              labelText: 'Tên học sinh',
                              hintText: 'Nhập tên học sinh',
                              readonly: true,
                              hasClearButton: false,
                            ),
                            SizedBox(height: 25.h),
                            PrimaryTextField(
                              controller: _studentDoBController,
                              labelText: 'Ngày tháng năm sinh',
                              hintText: 'Ngày/Tháng/Năm (VD: 01/01/2011)',
                              readonly: true,
                              hasClearButton: false,
                            ),
                            SizedBox(height: 25.h),
                            // PrimaryTextField(
                            //   controller: _addressController,
                            //   labelText: 'Địa chỉ',
                            //   hintText: 'Nhập địa chỉ',
                            // ),
                            // SizedBox(height: 25.h),
                            // PrimaryTextField(
                            //   controller: _bhytController,
                            //   labelText: 'Mã bảo hiểm y tế',
                            //   hintText: 'Nhập mã bảo hiểm y tế',
                            // ),
                            // SizedBox(height: 25.h),
                            PrimaryTextField(
                              controller: _cmndController,
                              labelText: 'Lớp',
                              hintText: '',
                              readonly: true,
                              hasClearButton: false,
                            ),
                            // SizedBox(height: 25.h),
                            // PrimaryTextField(
                            //   initialValue: widget.child.gender != null
                            //       ? (widget.child.gender == true ? 'Nam' : 'Nữ')
                            //       : 'Khác',
                            //   labelText: 'Giới tính',
                            //   hintText: 'Nhập giới tính',
                            //   readonly: true,
                            // ),
                            // SizedBox(height: 25.h),
                            // PrimaryTextField(
                            //   controller: _mailController,
                            //   labelText: 'Email',
                            //   hintText: 'Nhập email',
                            // ),
                            SizedBox(height: 25.h),
                            // SizedBox(
                            //   width: double.infinity,
                            //   child: LoadingPrimaryButton(
                            //     title: 'Lưu',
                            //     height: 56.h,
                            //     onTap: () {
                            //       context
                            //           .read<ListChildrenBloc>()
                            //           .add(UpdatingInfoStudent(
                            //             studentId: widget.child.studentId,
                            //             // bhytNum: _bhytController,
                            //             cmnd: _cmndController.text,
                            //             status: widget.child.status,
                            //             gender: widget.child.gender,
                            //             name: _studentNameController.text,
                            //             studentCode:
                            //                 _studentCodeController.text,
                            //             dob: _studentDoBController.text,
                            //             email: _mailController.text,
                            //             address: _addressController.text,
                            //             classId: widget.child.classId,
                            //             parentPhonenum:
                            //                 widget.child.parentPhonenum,
                            //           ));
                            //     },
                            //   ),
                            // )
                          ],
                        );
                      },
                    ),
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
