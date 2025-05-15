import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storyqito_app/core/data/network/static/address_load_state.dart';
import 'package:storyqito_app/core/localization/l10n/app_localizations.dart';
import 'package:storyqito_app/core/provider/map/address_provider.dart';

class AddressWidget extends StatefulWidget {
  final double latitude;
  final double longitude;
  final String storyId;

  const AddressWidget({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.storyId,
  });

  @override
  State<AddressWidget> createState() => _AddressWidgetState();
}

class _AddressWidgetState extends State<AddressWidget> {
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.location_on, color: Colors.red),
            const SizedBox(width: 8.0),
            Text(
              localizations.location,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8.0),

        Consumer<AddressProvider>(
          builder: (context, addressProvider, child) {
            final latText =
                "${localizations.latitude}: ${widget.latitude.toStringAsFixed(6)}";
            final lonText =
                "${localizations.longitude}: ${widget.longitude.toStringAsFixed(6)}";

            switch (addressProvider.state) {
              case AddressLoadStateInitial():
                return Text(
                  '$latText, $lonText',
                  style: const TextStyle(fontSize: 14.0),
                );

              case AddressLoadStateLoading():
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 16.0,
                        height: 16.0,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      const SizedBox(width: 8.0),
                      Text("${localizations.loading_address}..."),
                    ],
                  ),
                );

              case AddressLoadStateError():
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      localizations.address_not_available,
                      style: TextStyle(color: Colors.red[400], fontSize: 14.0),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      "$latText, $lonText",
                      style: const TextStyle(fontSize: 14.0),
                    ),
                  ],
                );

              case AddressLoadStateLoaded(formattedAddress: final address):
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        address,
                        style: const TextStyle(fontSize: 16.0),
                      ),
                    ),
                    Text(
                      "$latText, $lonText",
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                );

              default:
                return Text(
                  "Unknown Address load state : ${addressProvider.state}",
                );
            }
          },
        ),
      ],
    );
  }
}
