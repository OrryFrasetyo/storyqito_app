import 'package:url_launcher/url_launcher.dart';

Future<void> openUrl(String urlString) async {
  final Uri uri = Uri.parse(urlString);
  if (!await launchUrl(uri)) {
    throw Exception('Could not launch $urlString');
  }
}