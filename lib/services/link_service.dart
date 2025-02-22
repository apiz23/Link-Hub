import 'package:linkhub/models/link_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LinkService {
  static final _client = Supabase.instance.client;

  static Future<List<Link>> fetchLinks() async {
    final response = await _client.from('link-hub').select().order('created_at', ascending: false);
    return response.map<Link>((link) => Link.fromMap(link)).toList();
  }

  static Future<void> addLink(Link link) async {
    await _client.from('link-hub').insert({
      'name': link.name,
      'description': link.description,
      'link': link.link,
      'category': link.category,
      'created_at': link.createdAt.toIso8601String(),
    });
  }

  static Future<void> deleteLink(int id) async {
    await _client.from('link-hub').delete().eq('id', id);
  }

  static Future<List<String>?> fetchPasscodes() async {
    final response = await _client.from('tokens').select('token');

    if (response.isEmpty) {
      return null;
    }

    return response.map<String>((entry) => entry['token'].toString()).toList();
  }

  static Future<void> updateLink(Link link) async {
    await _client.from('link-hub').update({
      'name': link.name,
      'description': link.description,
      'link': link.link,
      'category': link.category,
    }).eq('id', link.id);
  }
}
