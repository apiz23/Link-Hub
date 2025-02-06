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
      height: MediaQuery.of(context).size.height * 0.9,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Link Details',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(bottom: 40.0),
              children: [
                _buildDetailItem('Title', link.name),
                _buildDetailItem('Description', link.description),
                _buildDetailItem('Link', link.link),
                _buildDetailItem('Created', link.createdAt.toString()),
                const SizedBox(height: 16),
                Center(
                  child: QrImageView(
                    data: link.link,
                    version: QrVersions.auto,
                    size: 300.0,
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
          const SizedBox(height: 16),
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

  Widget _buildDetailItem(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade300,
            width: 1.0,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                fontSize: 16.0,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              value,
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 16.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
