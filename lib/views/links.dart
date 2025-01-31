import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
  List<Link> _filteredLinks = [];
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchLinks();
    _searchController.addListener(_filterLinks);
  }

  Future<void> _fetchLinks() async {
    setState(() => _isLoading = true);
    _links = await LinkService.fetchLinks();
    _filteredLinks = _links;
    setState(() => _isLoading = false);
  }

  void _filterLinks() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredLinks = _links
          .where((link) => link.name.toLowerCase().contains(query))
          .toList();
    });
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
              TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name')),
              TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Description')),
              TextField(
                  controller: linkController,
                  decoration: const InputDecoration(labelText: 'Link')),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel')),
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
      appBar: AppBar(
        backgroundColor: Color(0xFFFBF5DD),
        centerTitle: true,
        title: const Text(
          "LinkHub",
          style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              letterSpacing: 1.5),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search Links',
                labelStyle: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                ),
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: _filteredLinks.length,
                    itemBuilder: (context, index) {
                      final link = _filteredLinks[index];
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
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addLink,
        backgroundColor: Colors.blue.shade800,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
