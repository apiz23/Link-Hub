import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:linkhub/components/link_card.dart';
import 'package:linkhub/components/link_details_bottom_sheet.dart';
import 'package:linkhub/models/link_model.dart';
import '../services/link_service.dart';

class PrivateLink extends StatefulWidget {
  const PrivateLink({super.key});

  @override
  State<PrivateLink> createState() => _PrivateLinkState();
}

class _PrivateLinkState extends State<PrivateLink> {
  List<Link> _privateLinks = [];
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchPrivateLinks();
    _searchController.addListener(_filterLinks);
  }

  Future<void> _fetchPrivateLinks() async {
    setState(() => _isLoading = true);
    List<Link> allLinks = await LinkService.fetchLinks();
    _privateLinks = allLinks.where((link) => link.category == "Private").toList();
    setState(() => _isLoading = false);
  }

  void _filterLinks() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _privateLinks = _privateLinks
          .where((link) => link.name.toLowerCase().contains(query))
          .toList();
    });
  }

  Future<void> _deleteLink(int id) async {
    await LinkService.deleteLink(id);
    _fetchPrivateLinks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFBF5DD),
        centerTitle: true,
        title: const Text(
          "Private Links",
          style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              letterSpacing: 1.5),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextField(
                controller: _searchController,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  labelText: 'Search Private Links',
                  labelStyle: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.black, width: 2.0),
                  ),
                ),
              ),
            ),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                padding: const EdgeInsets.only(bottom: 60),
                itemCount: _privateLinks.length,
                itemBuilder: (context, index) {
                  final link = _privateLinks[index];
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
          ],
        ),
      ),
    );
  }
}
