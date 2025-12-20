mixin LoginFormValidators {
  final nameMaxLength = 100;
  final passwordMaxLength = 100;

  String? usernameValidator(String? name) {
    if (name == null || name.isEmpty || name == '') {
      return 'Vui lòng nhập Tên đăng nhập';
    } else if (name.length > nameMaxLength) {
      return 'Tối đa $nameMaxLength ký tự';
    }
    return null;
  }

  String? passwordValidator(String? password) {
    if (password == null || password.isEmpty || password == '') {
      return 'Vui lòng nhập Mật khẩu';
    } else if (password.length > passwordMaxLength) {
      return 'Tối đa $passwordMaxLength ký tự';
    }
    return null;
  }
}
