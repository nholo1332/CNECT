import 'package:flutter/foundation.dart';

// This class allows us to add additional licenses to the Flutter license view

class FlutterLicense extends LicenseEntry {
  final packages;
  final paragraphs;

  FlutterLicense(this.packages, this.paragraphs);
}

// Create a list of our custom licenses we wish to add. In this case, we used
// Icons8.com for some app icons
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

// Add the licenses to the Flutter license registry
void addLicenses() {
  LicenseRegistry.addLicense(licenses);
}