import 'package:flutter/material.dart';
import '../data/database_helper.dart';
import 'detail_screen.dart';
import 'preferences_screen.dart';
import 'dart:async';

class WordlistScreen extends StatefulWidget {
  const WordlistScreen({Key? key}) : super(key: key);

  @override
  _WordlistScreenState createState() => _WordlistScreenState();
}

class _WordlistScreenState extends State<WordlistScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      final query = _searchController.text;
      if (query.isEmpty) {
        setState(() => _searchResults = []);
        return;
      }
      _performSearch(query);
    });
  }

  bool _isGeorgian(String text) {
    // Basic heuristic: check if first character is in the Georgian Unicode block
    if (text.isEmpty) return false;
    int codeUnit = text.codeUnitAt(0);
    return codeUnit >= 0x10A0 && codeUnit <= 0x10FF;
  }

  Future<void> _performSearch(String query) async {
    List<Map<String, dynamic>> results;
    if (_isGeorgian(query)) {
      results = await DatabaseHelper.instance.searchGeorgian(query);
    } else {
      results = await DatabaseHelper.instance.searchEnglish(query);
    }
    setState(() {
      _searchResults = results;
    });
  }

  void _navigateToDetail(Map<String, dynamic> wordData) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailScreen(wordData: wordData),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EnGeo Dictionary'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PreferencesScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Type your word',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () => _searchController.clear(),
                      )
                    : null,
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: ListView.separated(
                itemCount: _searchResults.length,
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final item = _searchResults[index];
                  return ListTile(
                    title: Text(
                      item['original'] ?? '',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      item['translate'] ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: () => _navigateToDetail(item),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
