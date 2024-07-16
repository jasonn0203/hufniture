class Validators {
  static String? validateNull(String? value) {
    if (value == null || value.isEmpty) {
      return 'Không được để trống!';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    validateNull;
    // Kiểm tra định dạng email sử dụng RegExp
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value!)) {
      return 'Email không hợp lệ!';
    }
    return null;
  }

  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Không được để trống!';
    }
    // Kiểm tra độ dài từ 10 đến 11 ký tự và chỉ chấp nhận ký tự là số
    final phoneRegex = RegExp(r'^[0-9]{10,11}$');
    if (!phoneRegex.hasMatch(value)) {
      return 'Số điện thoại không hợp lệ!';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Không được để trống!';
    }
    if (value.length < 8) {
      return 'Mật khẩu phải có ít nhất 8 ký tự!';
    }

    // Kiểm tra có ít nhất một ký tự không phải chữ số hoặc chữ cái
    if (!value.contains(RegExp(r'[^\w\d]'))) {
      return 'Mật khẩu phải có ít nhất một ký tự đặc biệt';
    }

    // Kiểm tra có ít nhất một chữ số ('0'-'9')
    if (!value.contains(RegExp(r'\d'))) {
      return 'Mật khẩu phải có ít nhất một chữ số!';
    }

    // Kiểm tra có ít nhất một chữ in hoa ('A'-'Z')
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Mật khẩu phải có ít nhất một chữ in hoa!';
    }

    return null;
  }

  static String? validatePasswordMatch(
      String? password, String? confirmPassword) {
    if (password != confirmPassword) {
      return 'Mật khẩu không khớp!';
    }
    return null;
  }
}
