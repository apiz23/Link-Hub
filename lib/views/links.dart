import 'package:flutter/material.dart';
import 'package:linkhub/components/link_card.dart';
import 'package:linkhub/components/link_details_bottom_sheet.dart';
import 'package:linkhub/models/link_model.dart';
import '../services/link_service.dart';

class LinkListScreen extends StatefulWidget {
  const LinkListScreen({super.key});

  @override
  State<LinkListScreen> createState() => _LinkListScreenState();
}

class _LinkListScreenState extends State<LinkListScreen> {
  List<Link> _links = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchLinks();
  }

  Future<void> _fetchLinks() async {
    setState(() => _isLoading = true);
    _links = await LinkService.fetchLinks();
    setState(() => _isLoading = false);
  }

  Future<void> _addLink() async {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    final linkController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Link'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Name')),
              TextField(controller: descriptionController, decoration: const InputDecoration(labelText: 'Description')),
              TextField(controller: linkController, decoration: const InputDecoration(labelText: 'Link')),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            TextButton(
              onPressed: () async {
                final newLink = Link(
                  id: 0,
                  name: nameController.text,
                  description: descriptionController.text,
                  link: linkController.text,
                  createdAt: DateTime.now(),
                );
                await LinkService.addLink(newLink);
                _fetchLinks();
                Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteLink(int id) async {
    await LinkService.deleteLink(id);
    _fetchLinks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _links.length,
        itemBuilder: (context, index) {
          final link = _links[index];
          return LinkCard(
            link: link,
            onTap: () => showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (context) {
                return FractionallySizedBox(
                  heightFactor: 0.75,
                  child: LinkDetailsBottomSheet(
                    link: link,
                    onDelete: () => _deleteLink(link.id),
                  ),
                );
              },

            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addLink,
        backgroundColor: Colors.blue.shade800,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
