import 'package:flutter/material.dart';

class LocationErrorWidget extends StatelessWidget {
  final String errorMsg;

  const LocationErrorWidget({super.key, required this.errorMsg});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 10.0,
      left: 10.0,
      right: 10.0,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.errorContainer,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Text(
          errorMsg,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onErrorContainer,
            fontSize: 12.0,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
