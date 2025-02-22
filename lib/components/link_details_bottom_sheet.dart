import 'package:flutter/material.dart';
import 'package:linkhub/models/link_model.dart';
import 'package:linkhub/services/link_service.dart';
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
                _buildDetailItem('Category', link.category),
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
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _showEditCategoryDialog(context, link);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Edit Category'),
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

  void _showEditCategoryDialog(BuildContext context, Link link) {
    final TextEditingController categoryController = TextEditingController(text: link.category);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Category"),
          content: TextField(
            controller: categoryController,
            decoration: InputDecoration(
              hintText: 'New category',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                "Cancel",
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                final newCategory = categoryController.text.trim();
                if (newCategory.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Category cannot be empty!")),
                  );
                  return;
                }

                // Update the link's category
                final updatedLink = Link(
                  id: link.id,
                  name: link.name,
                  description: link.description,
                  link: link.link,
                  category: newCategory,
                  createdAt: link.createdAt,
                );

                try {
                  await LinkService.updateLink(updatedLink);
                  Navigator.of(context).pop(); // Close the dialog
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Category updated successfully!")),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Failed to update category: $e")),
                  );
                }
              },
              child: const Text(
                "Save",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}