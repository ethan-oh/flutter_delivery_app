class ValidateUtils {
  // 이메일 유효성 검사 함수
  static String? emailValidator(dynamic val) {
    // 이메일 정규식
    final emailRegExp = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegExp.hasMatch(val)) {
      return '유효한 이메일 주소를 입력해 주세요.';
    }

    return null; // 유효성 검사 통과
  }

  // 비밀번호 유효성 검사 함수
  static String? passwordValidator(dynamic val) {
    if (val.length < 4) {
      return '비밀번호는 4자리 이상이어야 합니다.';
    }

    return null; // 유효성 검사 통과
  }
}
