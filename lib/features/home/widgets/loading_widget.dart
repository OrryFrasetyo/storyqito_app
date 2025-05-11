import 'package:flutter/material.dart';

class LoadingViewWidget extends StatelessWidget {
  const LoadingViewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}
