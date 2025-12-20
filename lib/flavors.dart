enum Flavor {
  dev,
  stg,
  prod,
}

extension FlavorName on Flavor {
  String get name => toString().split('.').last;
}

class F {
  static Flavor? appFlavor;

  static String get name => appFlavor?.name ?? '';

  static String get title {
    switch (appFlavor) {
      case Flavor.dev:
        return 'VSchool (development)';
      case Flavor.stg:
        return 'VSchool (stg)';
      case Flavor.prod:
        return 'VSchool';
      default:
        return 'title';
    }
  }

  static String get apiUrl {
    switch (appFlavor) {
      case Flavor.dev:
      case Flavor.stg:
      case Flavor.prod:
      // return 'https://vschoolapi.adevz.com';
        return 'https://api.v-school.vn';
      // return 'http://10.10.11.240:8080';
      default:
        return '';
    }
  }
}
