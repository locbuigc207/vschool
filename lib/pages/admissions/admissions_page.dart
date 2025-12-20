import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:vschool/commons/models/childs/children_model.dart';
import 'package:vschool/commons/repository/admissions_repository.dart';
import 'package:vschool/commons/widgets/animations/fade_animation.dart';
import 'package:vschool/commons/widgets/buttons/primary_button.dart';
import 'package:vschool/commons/widgets/container/gradient_header_container.dart';
import 'package:vschool/commons/widgets/container/rounded_top_container.dart';
import 'package:vschool/commons/widgets/modal/success_dialog.dart';
import 'package:vschool/commons/widgets/pages/base_page.dart';
import 'package:vschool/commons/widgets/snackbar/snackbbar.dart';
import 'package:vschool/commons/widgets/text_field/phone_number_text_field.dart';
import 'package:vschool/commons/widgets/text_field/primary_text_field.dart';
import 'package:vschool/injections.dart';
import 'package:vschool/pages/admissions/bloc/admissions_bloc.dart';

@RoutePage()
class AdmissionsPage extends StatefulWidget {
  final ChildrenInfoModel? child;

  const AdmissionsPage({Key? key, this.child}) : super(key: key);

  @override
  State<AdmissionsPage> createState() => _AdmissionsPageState();
}

class _AdmissionsPageState extends State<AdmissionsPage> {
  late TextEditingController _studentCodeController;
  late TextEditingController _studentNameController;
  late TextEditingController _studentDoBController;
  late TextEditingController _addressController;
  late TextEditingController _householderNameController;
  late TextEditingController _dadNameController;
  late TextEditingController _dadJobController;
  late TextEditingController _dadPhoneNumController;
  late TextEditingController _momNameController;
  late TextEditingController _momJobController;
  late TextEditingController _momPhoneNumController;
  late TextEditingController _patronsNameController;
  late TextEditingController _patronsJobController;
  late TextEditingController _patronsPhoneNumController;
  late TextEditingController _contractAddressController;
  late TextEditingController _noteController;
  late TextEditingController _graduateLevelController;
  late TextEditingController _graduateSchoolController;
  late TextEditingController _graduateGradesController;
  late TextEditingController _desiredSchoolController;

  @override
  void initState() {
    _studentCodeController =
        TextEditingController(text: widget.child?.studentCode ?? '');
    _studentNameController =
        TextEditingController(text: widget.child?.name ?? '');
    _studentDoBController =
        TextEditingController(text: widget.child?.dob ?? '');
    _addressController = TextEditingController(text: '');
    _householderNameController = TextEditingController(text: '');
    _dadNameController = TextEditingController(text: '');
    _dadJobController = TextEditingController(text: '');
    _dadPhoneNumController = TextEditingController(text: '');
    _momNameController = TextEditingController(text: '');
    _momJobController = TextEditingController(text: '');
    _momPhoneNumController = TextEditingController(text: '');
    _patronsNameController = TextEditingController(text: '');
    _patronsJobController = TextEditingController(text: '');
    _patronsPhoneNumController = TextEditingController(text: '');
    _contractAddressController = TextEditingController(text: '');
    _noteController = TextEditingController(text: '');
    _graduateLevelController = TextEditingController(text: '');
    _graduateSchoolController = TextEditingController(text: '');
    _graduateGradesController = TextEditingController(text: '');
    _desiredSchoolController = TextEditingController(text: '');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          AdmissionsBloc(admissionsRepository: getIt<IAdmissionsRepository>()),
      child: BlocListener<AdmissionsBloc, AdmissionsState>(
        listener: (context, state) {
          if (state is AdmissionsSubmitInit) {
            context.loaderOverlay.show();
          } else if (state is AdmissionsSubmitFailed) {
            context.loaderOverlay.hide();
            showErrorSnackBBar(context: context, message: state.mess);
          } else if (state is AdmissionsSubmitSuccess) {
            context.loaderOverlay.hide();
            showDialog(
              context: context,
              builder: (contextDialog) {
                return SuccessDialog(
                  content: 'Đăng ký tuyển sinh thành công',
                  contentTextAlign: TextAlign.center,
                  onButtonTap: () {
                    Navigator.of(contextDialog).pop();
                  },
                );
              },
            );
          }
        },
        child: BasePage(
          backgroundColor: Colors.white,
          title: 'Tuyển sinh',
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
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const Center(
                            child: Text(
                              'Hồ sơ chi tiết của học sinh',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(height: 20.h),
                          PrimaryTextField(
                            controller: _studentCodeController,
                            labelText: 'Mã học sinh',
                            hintText: 'Nhập mã học sinh',
                          ),
                          SizedBox(height: 20.h),
                          PrimaryTextField(
                            controller: _studentNameController,
                            labelText: 'Họ tên học sinh',
                            hintText: 'Nhập họ tên học sinh',
                          ),
                          SizedBox(height: 20.h),
                          PrimaryTextField(
                            controller: _studentDoBController,
                            labelText: 'Ngày tháng năm sinh',
                            hintText: 'Nhập ngày tháng năm sinh học sinh',
                          ),
                          // SizedBox(height: 20.h),
                          // PrimaryDropdown<DropdownItem>(
                          //   label: 'Giới tính',
                          //   selectedItem: widget.child?.gender == true
                          //       ? DropdownItem(title: 'Nam', value: '0')
                          //       : DropdownItem(title: 'Nữ', value: '1'),
                          //   dropdownHeight: 150.h,
                          //   onChanged: (item) {},
                          //   hasClearButton: true,
                          //   items: [
                          //     DropdownItem(title: 'Nam', value: '0'),
                          //     DropdownItem(title: 'Nữ', value: '1'),
                          //   ],
                          // ),
                          SizedBox(height: 20.h),
                          PrimaryTextField(
                            controller: _addressController,
                            labelText: 'Hộ khẩu thường trú',
                            hintText: 'Nhập hộ khẩu thường trú',
                          ),
                          SizedBox(height: 20.h),
                          PrimaryTextField(
                            controller: _householderNameController,
                            labelText: 'Họ tên chủ hộ',
                            hintText: 'Nhập họ tên chủ hộ',
                          ),
                          SizedBox(height: 20.h),
                          PrimaryTextField(
                            controller: _dadNameController,
                            labelText: 'Họ tên cha',
                            hintText: 'Nhập họ tên cha',
                          ),
                          SizedBox(height: 20.h),
                          PrimaryTextField(
                            controller: _dadJobController,
                            labelText: 'Nghề nghiệp của cha',
                            hintText: 'Nhập nghề nghiệp của cha',
                          ),
                          SizedBox(height: 20.h),
                          PhoneNumberTextField(
                            controller: _dadPhoneNumController,
                            labelText: 'Điện thoại của cha',
                          ),
                          SizedBox(height: 20.h),
                          PrimaryTextField(
                            controller: _momNameController,
                            labelText: 'Họ tên mẹ',
                            hintText: 'Nhập họ tên mẹ',
                          ),
                          SizedBox(height: 20.h),
                          PrimaryTextField(
                            controller: _momJobController,
                            labelText: 'Nghề nghiệp của mẹ',
                            hintText: 'Nhập nghề nghiệp của mẹ',
                          ),
                          SizedBox(height: 20.h),
                          PhoneNumberTextField(
                            controller: _momPhoneNumController,
                            labelText: 'Điện thoại của mẹ',
                          ),
                          SizedBox(height: 20.h),
                          PrimaryTextField(
                            controller: _patronsNameController,
                            labelText: 'Họ tên người đỡ đầu',
                            hintText: 'Nhập họ tên người đỡ đầu',
                          ),
                          SizedBox(height: 20.h),
                          PrimaryTextField(
                            controller: _patronsJobController,
                            labelText: 'Nghề của người đỡ đầu',
                            hintText: 'Nhập nghề của người đỡ đầu',
                          ),
                          SizedBox(height: 20.h),
                          PhoneNumberTextField(
                            controller: _patronsPhoneNumController,
                            labelText: 'Điện thoại của người đỡ đầu',
                          ),
                          SizedBox(height: 20.h),
                          PrimaryTextField(
                            controller: _contractAddressController,
                            labelText: 'Địa chỉ liên hệ',
                            hintText: 'Nhập địa chỉ liên hệ',
                          ),
                          SizedBox(height: 20.h),
                          PrimaryTextField(
                            controller: _noteController,
                            labelText: 'Ghi chú',
                            hintText: 'Nhập ghi chú',
                          ),
                          SizedBox(height: 20.h),
                          PrimaryTextField(
                            controller: _graduateLevelController,
                            labelText: 'Cấp tốt nghiệp',
                            hintText: 'Nhập cấp tốt nghiệp',
                          ),
                          SizedBox(height: 20.h),
                          PrimaryTextField(
                            controller: _graduateSchoolController,
                            labelText: 'Trường tốt nghiệp',
                            hintText: 'Nhập trường tốt nghiệp',
                          ),
                          SizedBox(height: 20.h),
                          PrimaryTextField(
                            controller: _graduateGradesController,
                            labelText: 'Lớp tốt nghiệp',
                            hintText: 'Nhập lớp tốt nghiệp',
                          ),
                          SizedBox(height: 20.h),
                          PrimaryTextField(
                            controller: _desiredSchoolController,
                            labelText: 'Trường đăng ký nguyện vọng',
                            hintText: 'Nhập nguyện vọng đăng ký',
                          ),
                          SizedBox(height: 20.h),
                          SizedBox(
                            width: double.infinity,
                            child: PrimaryButton(
                              title: 'Xác nhận',
                              enabled: _studentCodeController.text.isNotEmpty &&
                                  _studentNameController.text.isNotEmpty &&
                                  _studentDoBController.text.isNotEmpty &&
                                  _addressController.text.isNotEmpty &&
                                  _householderNameController.text.isNotEmpty &&
                                  _contractAddressController.text.isNotEmpty &&
                                  _desiredSchoolController.text.isNotEmpty,
                              onTap: () {
                                context.read<AdmissionsBloc>().add(
                                      AdmissionsSubmitting(
                                          studentCode:
                                              _studentCodeController.text,
                                          studentName:
                                              _studentNameController.text,
                                          studentDob:
                                              _studentDoBController.text,
                                          gender: widget.child?.gender == true
                                              ? 'Nam'
                                              : 'Nữ',
                                          address: _addressController.text,
                                          householderName:
                                              _householderNameController.text,
                                          dadName: _dadNameController.text,
                                          dadJob: _dadJobController.text,
                                          dadPhoneNum:
                                              _dadPhoneNumController.text,
                                          momName: _momNameController.text,
                                          momJob: _momJobController.text,
                                          momPhoneNum:
                                              _momPhoneNumController.text,
                                          patronsName:
                                              _patronsNameController.text,
                                          patronsJob:
                                              _patronsJobController.text,
                                          patronsPhoneNum:
                                              _patronsPhoneNumController.text,
                                          contactAddress:
                                              _contractAddressController.text,
                                          note: _noteController.text,
                                          graduateLevel:
                                              _graduateLevelController.text,
                                          graduateSchool:
                                              _graduateSchoolController.text,
                                          graduateGrades:
                                              _graduateGradesController.text,
                                          desiredSchool:
                                              _desiredSchoolController.text),
                                    );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
