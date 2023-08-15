import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';



class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}


class _SearchState extends State<Search> {
  List<String> oldTestamentBooks = [];
  List<String> newTestamentBooks = [];
  List<Map<String, dynamic>> bibleData = [];
  TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'All';
  String _selectedBook = 'Genesis'; // Default selected book

  @override
  void initState() {
    super.initState();
    _selectedFilter = 'All';
    _selectedBook = 'All';
    loadBooks();
    loadBibleData();
  }

  void loadBooks() async {
    String oldTestamentContent = await rootBundle.loadString('assets/oldt_books.txt');
    String newTestamentContent = await rootBundle.loadString('assets/newt_books.txt');
    setState(() {
      oldTestamentBooks = oldTestamentContent.split('\n');
      newTestamentBooks = newTestamentContent.split('\n');
    });
  }

  void loadBibleData() async {
    String bibleContent = await rootBundle.loadString('assets/nkjvbible.json');
    Map<String, dynamic> bibleJson = json.decode(bibleContent);
    setState(() {
      bibleData = List<Map<String, dynamic>>.from(bibleJson['books']);
    });
  }

  List<Map<String, dynamic>> getFilteredVerses() {
    List<Map<String, dynamic>> filteredVerses = [];

    for (var book in bibleData) {
      if (_selectedFilter == 'All' || (_selectedFilter == 'Old Testament' && oldTestamentBooks.contains(book['name'])) ||
          (_selectedFilter == 'New Testament' && newTestamentBooks.contains(book['name']))) {
        List<dynamic> chapters = book['chapters'];

        for (var chapter in chapters) {
          for (var verse in chapter['verses']) {
            if (_selectedBook == 'All' || _selectedBook == book['name']) {
              String verseText = verse['text'];
              if (_searchController.text.isNotEmpty && !verseText.toLowerCase().contains(_searchController.text.toLowerCase())) {
                continue; // Skip if search keyword not found in verse text
              }
              filteredVerses.add({
                'verseText': verseText,
                'bookName': book['name'],
                'chapterNum': chapter['num'],
                'verseNum': verse['num'],
              });
            }
          }
        }
      }
    }

    return filteredVerses;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bible Search'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: 'Search Keyword',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 16.0),
                DropdownButton<String>(
                  value: _selectedFilter,
                  onChanged: (value) {
                    setState(() {
                      _selectedFilter = value!;
                    });
                  },
                  items: ['All', 'Old Testament', 'New Testament']
                      .map<DropdownMenuItem<String>>(
                        (value) => DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    ),
                  )
                      .toList(),
                ),
                SizedBox(width: 16.0),
                DropdownButton<String>(
                  value: _selectedBook,
                  onChanged: (value) {
                    setState(() {
                      _selectedBook = value!;
                    });
                  },
                  items: ['All', ...oldTestamentBooks, ...newTestamentBooks]
                      .map<DropdownMenuItem<String>>(
                        (value) => DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    ),
                  )
                      .toList(),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: getFilteredVerses().length,
              itemBuilder: (context, index) {
                String verseText = getFilteredVerses()[index]['verseText'];
                String bookName = getFilteredVerses()[index]['bookName'];
                int chapterNum = getFilteredVerses()[index]['chapterNum'];
                int verseNum = getFilteredVerses()[index]['verseNum'];

                return ListTile(
                  title: Text(verseText),
                  subtitle: Text('$bookName $chapterNum:$verseNum'),
                );
              }, separatorBuilder: (BuildContext context, int index) { return Divider(); },
            ),
          ),
        ],
      ),
    );
  }
}