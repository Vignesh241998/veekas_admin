class Validators {
  Validators._();

  static String? required(String? value, String field) {
    if (value == null || value.trim().isEmpty) {
      return "$field is required";
    }
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Email is required";
    }

    const pattern =
        r'^[\w\-\.]+@([\w\-]+\.)+[\w]{2,4}$';

    if (!RegExp(pattern).hasMatch(value)) {
      return "Enter valid email";
    }

    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return "Password is required";
    }

    if (value.length < 6) {
      return "Minimum 6 characters";
    }

    return null;
  }

  static String? mobile(String? value) {
    if (value == null || value.isEmpty) {
      return "Mobile number is required";
    }

    if (value.length != 10) {
      return "Enter valid mobile number";
    }

    return null;
  }

  static String? confirmPassword(
      String? password,
      String? confirmPassword,
      ) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return "Confirm password is required";
    }

    if (password != confirmPassword) {
      return "Passwords do not match";
    }

    return null;
  }
}