import 'package:flutter/foundation.dart';

class FlutterLicense extends LicenseEntry {
  final packages;
  final paragraphs;

  FlutterLicense(this.packages, this.paragraphs);
}

Stream<LicenseEntry> licenses() async* {
  yield FlutterLicense(
    [
      'Icons8',
    ],
    [
      LicenseParagraph(
        'Instagram and Twitter icons provided by icons8.com',
        0,
      ),
    ],
  );
}

void addLicenses() {
  LicenseRegistry.addLicense(licenses);
}