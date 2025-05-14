enum BuildVariant { free, paid }

class BuildConfig {
  static const BuildVariant _buildVariant =
      bool.fromEnvironment("IS_PAID_VERSION")
          ? BuildVariant.paid
          : BuildVariant.free;

  static bool get isPaidVersion => _buildVariant == BuildVariant.paid;
  static bool get isFreeVersion => _buildVariant == BuildVariant.free;

  static String get appName =>
      isPaidVersion ? "Storyqito Premium" : "Storyqito Free";

  static bool get canAddLocation => isPaidVersion;
}
