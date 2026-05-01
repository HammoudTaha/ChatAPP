class AppStrings {
  AppStrings._();
  //server routers
  static const String baseUrl = 'http://10.0.2.2:8000/api/';
  static const String auth = '${baseUrl}broadcasting/auth';
  static const String user = 'user/';
  static const String login = 'login';
  static const String register = 'register';
  static const String forgetPassword = 'forget-password';
  static const String resetPassword = 'reset-password';
  static const String logout = 'logout';
  static const String checkPhoneAvailability = 'check-phone-availability';
  static const String checkPhoneExistence = 'check-phone-existence';
  static const String verifyPhone = 'verify-phone';
  static const String sendVerificationCode = 'send-verification-code';
  static const String token = 'token';
  static const String sendMessage = 'send-message';
  static const String updateMessageStatus = 'update-message-status';

  //app strings
  static const String cachedUser = 'CACHED_USER';
  static const String cachedAccessToken = 'CACHED_ACCESS_TOKEN';
  static const String cachedRefreshToken = 'CACHED_REFRESH_TOKEN';
  static const String cachedIsLoggedInUser = 'CACHED_IS_LOGGED_IN_USER';
  static const String cacheAccessTokenLifeTime = 'CACHE_ACCESS_TOKEN_LIFE_TIME';
  static const String cacheRefreshTokenLifeTime =
      'CACHE_REFRESH_TOKEN_LIFE_TIME';
  static const String cachedHomeContacts = 'CACHED_HOME_CONTACTS';

  static const String messages = 'messages';
  static const String chats = 'chats';
  static const String userChats = 'userChats';
}
