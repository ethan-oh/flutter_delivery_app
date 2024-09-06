class ValidateUtils {
  // 이메일 유효성 검사 함수
  static String? emailValidator(String? val) {
    if (val == null || val.isEmpty) {
      return '이메일 주소를 입력해 주세요.';
    }

    // 이메일 정규식
    final emailRegExp = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegExp.hasMatch(val)) {
      return '유효한 이메일 주소를 입력해 주세요.';
    }

    return null; // 유효성 검사 통과
  }

  // 비밀번호 유효성 검사 함수
  static String? passwordValidator(String? val) {
    if (val == null || val.isEmpty) {
      return '비밀번호를 입력해 주세요.';
    }

    if (val.length < 8) {
      return '비밀번호는 8자리 이상이어야 합니다.';
    }

    return null; // 유효성 검사 통과
  }
}
