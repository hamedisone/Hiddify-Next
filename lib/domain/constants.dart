abstract class Constants {
  static const geoipFileName = "geoip.db";
  static const geositeFileName = "geosite.db";
  static const configsFolderName = "configs";
  static const localHost = "127.0.0.1";
  static const githubUrl = "https://github.com/hamedisone/hiddify-next";
  static const githubReleasesApiUrl =
      "https://api.github.com/repos/hamedisone/hiddify-next/releases";
  static const githubLatestReleaseUrl =
      "https://github.com/hamedisone/hiddify-next/releases/latest";
  static const telegramChannelUrl = "https://t.me/hifree";
}

abstract class Defaults {
  static const clashApiPort = 9090;
  static const mixedPort = 2334;
  static const connectionTestUrl = "https://www.gstatic.com/generate_204";
  static const concurrentTestCount = 5;
}
