import 'package:flutter/material.dart';

class StoryMapScreen extends StatefulWidget {
  const StoryMapScreen({super.key});

  @override
  State<StoryMapScreen> createState() => _StoryMapScreenState();
}

class _StoryMapScreenState extends State<StoryMapScreen> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Map Screen"),
    );
  }
}