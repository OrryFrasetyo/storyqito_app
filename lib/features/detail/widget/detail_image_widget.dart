import 'package:flutter/material.dart';

class DetailImageWidget extends StatelessWidget {
  final String photoUrl;

  const DetailImageWidget({super.key, required this.photoUrl});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16.0),
      child: Image.network(
        photoUrl,
        width: double.infinity,
        fit: BoxFit.contain,
        loadingBuilder: (context, child, loadingStatus) {
          if (loadingStatus == null) return child;
          return Container(
            height: 350.0,
            color: Colors.grey[200],
            child: Center(
              child: CircularProgressIndicator(
                value:
                    loadingStatus.expectedTotalBytes != null
                        ? loadingStatus.cumulativeBytesLoaded /
                            loadingStatus.expectedTotalBytes!
                        : null,
              ),
            ),
          );
        },
        errorBuilder:
            (context, error, stackTrace) => Container(
              height: 350.0,
              color: Colors.grey[300],
              child: Center(
                child: Icon(
                  Icons.broken_image,
                  size: 64.0,
                  color: Colors.grey[400],
                ),
              ),
            ),
      ),
    );
  }
}
