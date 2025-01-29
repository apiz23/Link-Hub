import 'package:flutter/material.dart';
import 'package:linkhub/models/link_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:qr_flutter/qr_flutter.dart';

class LinkDetailsBottomSheet extends StatelessWidget {
  final Link link;
  final VoidCallback onDelete;

  const LinkDetailsBottomSheet({
    super.key,
    required this.link,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 1,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Link Details',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Text('Name: ${link.name}'),
          Text('Description: ${link.description}'),
          Text('Link: ${link.link}'),
          Text('Created: ${link.createdAt.toString()}'),
          const SizedBox(height: 16),

          Center(
            child: QrImageView(
              data: link.link,
              version: QrVersions.auto,
              size: 300.0,
            ),
          ),

          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  launchUrl(Uri.parse(link.link));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white70,
                  foregroundColor: Colors.black,
                ),
                child: const Text('Open Link'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  onDelete();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Delete Link'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
