class AppRoutePath {
  final bool isLoginScreen;
  final bool isRegisterScreen;
  final bool isMainScreen;
  final bool isDetailScreen;
  final bool isUnknown;
  final bool isLanguageDialogOpen;
  final int? tabIndex;
  final String? storyId;

  AppRoutePath.login()
    : isLoginScreen = true,
      isRegisterScreen = false,
      isMainScreen = false,
      isDetailScreen = false,
      isLanguageDialogOpen = false,
      isUnknown = false,
      tabIndex = null,
      storyId = null;

  AppRoutePath.register()
    : isLoginScreen = false,
      isRegisterScreen = true,
      isMainScreen = false,
      isDetailScreen = false,
      isLanguageDialogOpen = false,
      isUnknown = false,
      tabIndex = null,
      storyId = null;

  AppRoutePath.home({this.tabIndex = 0})
    : isLoginScreen = false,
      isRegisterScreen = false,
      isMainScreen = true,
      isDetailScreen = false,
      isLanguageDialogOpen = false,
      isUnknown = false,
      storyId = null;

  AppRoutePath.unknown()
    : isLoginScreen = false,
      isRegisterScreen = false,
      isMainScreen = false,
      isDetailScreen = false,
      isLanguageDialogOpen = false,
      isUnknown = true,
      tabIndex = null,
      storyId = null;

  AppRoutePath.detailScreen(this.storyId)
    : isLoginScreen = false,
      isRegisterScreen = false,
      isMainScreen = true,
      isUnknown = false,
      isDetailScreen = true,
      isLanguageDialogOpen = false,
      tabIndex = null;

  AppRoutePath.languageDialog(AppRoutePath basePath)
    : isLoginScreen = basePath.isLoginScreen,
      isRegisterScreen = basePath.isRegisterScreen,
      isMainScreen = basePath.isMainScreen,
      isDetailScreen = basePath.isDetailScreen,
      isUnknown = basePath.isUnknown,
      tabIndex = basePath.tabIndex,
      storyId = basePath.storyId,
      isLanguageDialogOpen = true;
}
