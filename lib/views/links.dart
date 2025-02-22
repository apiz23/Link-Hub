import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:linkhub/components/link_card.dart';
import 'package:linkhub/components/link_details_bottom_sheet.dart';
import 'package:linkhub/models/link_model.dart';
import 'package:linkhub/views/private_link.dart';
import '../services/link_service.dart';
import 'package:flutter/cupertino.dart';

class LinkListScreen extends StatefulWidget {
  const LinkListScreen({super.key});

  @override
  State createState() => _LinkListScreenState();
}

class _LinkListScreenState extends State<LinkListScreen> {
  List _allLinks = [];
  List _links = [];
  final Map<String, List<Link>> _groupedLinks = {};
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = "All";

  @override
  void initState() {
    super.initState();
    _fetchLinks();
    _searchController.addListener(_filterLinks);
  }

  Future<void> _fetchLinks() async {
    setState(() => _isLoading = true);
    _allLinks = await LinkService.fetchLinks();
    _links = List.from(_allLinks);
    _groupLinksByCategory();
    setState(() => _isLoading = false);
  }

  // Group links by their category
  void _groupLinksByCategory() {
    _groupedLinks.clear();
    for (var link in _links) {
      if (link.category.isNotEmpty && link.category != "Private") {
        if (_groupedLinks.containsKey(link.category)) {
          _groupedLinks[link.category]?.add(link);
        } else {
          _groupedLinks[link.category] = [link];
        }
      }
    }
  }

  void _filterLinks() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _links = List.from(_allLinks);
      } else {
        _links = _allLinks.where((link) => link.name.toLowerCase().contains(query)).toList();
      }
    });
  }

  List _getFilteredLinks() {
    final query = _searchController.text.toLowerCase();
    List filtered = _links.where((link) => link.category != "Private").toList();
    if (_selectedFilter != "All") {
      filtered = filtered.where((link) => link.category == _selectedFilter).toList();
    }
    if (query.isNotEmpty) {
      filtered = filtered.where((link) => link.name.toLowerCase().contains(query)).toList();
    }
    return filtered;
  }

  Widget _buildFilterTabs() {
    final filters = ["All", ..._groupedLinks.keys, "Private"];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.map((filter) {
          final isSelected = _selectedFilter == filter;
          return GestureDetector(
            onTap: () async {
              if (filter == "Private") {
                bool isAuthenticated = await _showPasscodeDialog();
                if (isAuthenticated) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PrivateLink(),
                    ),
                  );
                }
              } else {
                setState(() {
                  _selectedFilter = filter;
                });
              }
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF16404D) : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                filter,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Future<bool> _showPasscodeDialog() async {
    print("Opening passcode dialog..."); // Debug print

    final passcodes = await LinkService.fetchPasscodes(); // Fetch all passcodes
    if (passcodes == null || passcodes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to fetch passcodes!")),
      );
      return false;
    }

    TextEditingController passcodeController = TextEditingController();
    return await showDialog(
      context: context,
      builder: (context) {
        print("Building dialog...");
        return AlertDialog(
          title: const Text("Enter Passcode"),
          content: TextField(
            controller: passcodeController,
            obscureText: true,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              hintText: "Passcode",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text("Cancel"),
            ),
            OutlinedButton(
              onPressed: () {
                if (passcodes.contains(passcodeController.text)) {
                  Navigator.of(context).pop(true);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Incorrect Passcode!")),
                  );
                }
              },
              child: const Text(
                "Enter",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    ) ??
        false;
  }

  Future<void> _showAddLinkDialog() async {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    final TextEditingController urlController = TextEditingController();
    final TextEditingController categoryController = TextEditingController();

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFFFBF5DD),
          title: const Text("Add New Link"),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      hintText: 'Link name',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextField(
                    controller: descriptionController,
                    decoration: InputDecoration(
                      hintText: 'Link description',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextField(
                    controller: urlController,
                    decoration: InputDecoration(
                      hintText: 'Link URL',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextField(
                    controller: categoryController,
                    decoration: InputDecoration(
                      hintText: 'Link category',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ],
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
                if (nameController.text.isEmpty ||
                    descriptionController.text.isEmpty ||
                    urlController.text.isEmpty ||
                    categoryController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please fill all fields!")),
                  );
                  return;
                }
                final newLink = Link(
                  name: nameController.text,
                  description: descriptionController.text,
                  link: urlController.text,
                  category: categoryController.text,
                  createdAt: DateTime.now(),
                  id: 0,
                );
                try {
                  await LinkService.addLink(newLink);
                  setState(() {});
                  Navigator.of(context).pop();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Failed to add link: $e")),
                  );
                }
              },
              child: const Text(
                "Add",
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

  Future<void> _deleteLink(int id) async {
    await LinkService.deleteLink(id);
    _fetchLinks();
  }

  Future<void> _showEditCategoryDialog(Link link) async {
    final TextEditingController categoryController = TextEditingController(text: link.category);

    return showDialog(
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
                  setState(() {
                    _fetchLinks();
                  });
                  Navigator.of(context).pop();
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

  @override
  Widget build(BuildContext context) {
    final filteredLinks = _getFilteredLinks();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFBF5DD),
        title: const Text(
          "LinkHub",
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            letterSpacing: 1.5,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  TextField(
                    controller: _searchController,
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      labelText: 'Search Links',
                      labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w500, color: Colors.black),
                      prefixIcon: Icon(Icons.search, color: Colors.black),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.black, width: 2.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildFilterTabs(),
                ],
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  await _fetchLinks();
                },
                child: _isLoading
                    ? const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Colors.black),
                  ),
                )
                    : ListView.builder(
                  padding: const EdgeInsets.only(bottom: 60),
                  itemCount: filteredLinks.length,
                  itemBuilder: (context, index) {
                    final link = filteredLinks[index];
                    return LinkCard(
                      link: link,
                      onTap: () => showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (context) {
                          return FractionallySizedBox(
                            heightFactor: 0.80,
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
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddLinkDialog,
        backgroundColor: Colors.blue.shade800,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}