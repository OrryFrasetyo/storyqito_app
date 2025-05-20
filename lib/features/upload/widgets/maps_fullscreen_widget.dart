import 'package:flutter/material.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:provider/provider.dart';
import 'package:storyqito_app/core/provider/app/app_provider.dart';
import 'package:storyqito_app/core/provider/upload/add_new_story_provider.dart';
import 'package:storyqito_app/features/upload/widgets/build_google_map_widget.dart';

class MapsFullscreenWidget extends StatelessWidget {
  const MapsFullscreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<AddNewStoryProvider>();
    if (provider.attachedLocation == null) return const SizedBox.shrink();

    return SafeArea(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: BuildGoogleMapWidget(),
          ),

          Positioned(
            top: 16,
            left: 16,
            child: PointerInterceptor(
              child: FloatingActionButton.small(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                onPressed: () {
                  context.read<AppProvider>().closeUploadFullScreenMap();
                },
                child: const Icon(Icons.close),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
