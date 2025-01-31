import 'package:flutter/material.dart';
import 'package:linkhub/app_theme.dart';
import 'package:linkhub/views/home.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:linkhub/views/links.dart';
import 'package:linkhub/widgets/bottom_nav.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://ykzglhnkmwqyekcvutgx.supabase.co',
    anonKey:
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InlremdsaG5rbXdxeWVrY3Z1dGd4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTA1NjYzNTIsImV4cCI6MjAyNjE0MjM1Mn0.qO5klTaA07a2cb9QL0G6osMhBWG1n1t34CH2yhxXyLQ',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Link Hub',
      theme: AppTheme.lightTheme,
      themeMode: ThemeMode.system,
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomeView(),
    LinkListScreen(),
    Center(child: Text('Settings Page')),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
