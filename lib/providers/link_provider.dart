import 'package:flutter/material.dart';
import 'package:linkhub/models/link_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LinkProvider extends ChangeNotifier {
  List<Link> _links = [];

  List<Link> get links => _links;

  // Fetch links from Supabase
  Future<void> fetchLinks() async {
    final response = await Supabase.instance.client
        .from('links')
        .select()
        .order('created_at', ascending: false);

    _links = response.map((link) => Link.fromMap(link)).toList();
    notifyListeners();
  }

  // Add a new link to Supabase
  Future<void> addLink(Link link) async {
    await Supabase.instance.client.from('links').insert({
      'name': link.name,
      'description': link.description,
      'link': link.link,
      'created_at': link.createdAt.toIso8601String(),
    });
    await fetchLinks(); // Refresh the list
  }

  // Update a link in Supabase
  Future<void> updateLink(Link updatedLink) async {
    await Supabase.instance.client.from('links').update({
      'name': updatedLink.name,
      'description': updatedLink.description,
      'link': updatedLink.link,
    }).eq('id', updatedLink.id);
    await fetchLinks(); // Refresh the list
  }

  // Delete a link from Supabase
  Future<void> removeLink(int id) async {
    await Supabase.instance.client.from('links').delete().eq('id', id);
    await fetchLinks(); // Refresh the list
  }
}
