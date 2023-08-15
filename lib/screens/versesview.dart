import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VersesView extends StatefulWidget {
  final int chapterNumber;
  final String bookName;
  const VersesView({required int this.chapterNumber, required String this.bookName, super.key });

  @override
  State<VersesView> createState() => _VersesViewState();
}

class _VersesViewState extends State<VersesView> {
  late final int selectedChapter;
  late final String selectedBook;

  @override
  void initState() {
    super.initState();
    selectedChapter = widget.chapterNumber;
    selectedBook = widget.bookName;
  }

  Future<List<Map<String, dynamic>>> loadVersesData() async {
    String jsonData = await loadJsonData();
    Map<String, dynamic> data = json.decode(jsonData);

    Map<String, dynamic>? selectedBookData = data['books'].firstWhere(
          (book) => book['name'] == selectedBook,
      orElse: () => null,
    );

    if (selectedBookData != null) {
      Map<String, dynamic>? selectedChapterData = selectedBookData['chapters'][selectedChapter - 1];
      if (selectedChapterData != null) {
        return List<Map<String, dynamic>>.from(selectedChapterData['verses']);
      }
    }

    return [];
  }

  Future<String> loadJsonData() async {
    return await rootBundle.loadString('assets/nkjvbible.json');
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text('$selectedBook $selectedChapter'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: loadVersesData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading data'));
          } else {
            return ListView.separated(
              itemCount: snapshot.data?.length ?? 0,
              itemBuilder: (context, index) {
                final verse = snapshot.data![index];
                final verseNumber = verse['num'];
                final verseText = verse['text'];
                return TextButton(
                  onPressed: () {  },
                  onLongPress: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return Container(
                            height: 120,
                            child: Column(
                              children: [
                                ListTile(
                                  leading: Icon(Icons.bookmark),
                                  title: Text("Bookmark"),
                                  onTap: () async{
                                    SharedPreferences prefs = await SharedPreferences.getInstance();
                                    String verse =  verseText;
                                    String bookmark = '${selectedBook.trim()} $selectedChapter:${index + 1}';
                                    String bookmarkedVerse = verse + ' - ' + bookmark;
                                    // print(bookmarkedVerse);
                                    List<String>? existingBookmarks = prefs.getStringList("bookmarks") ?? [];
                                    if (!existingBookmarks.contains(bookmarkedVerse)) {
                                      existingBookmarks.add(bookmarkedVerse);
                                      prefs.setStringList("bookmarks", existingBookmarks);
                                      // print(existingBookmarks);
                                    }

                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text("Bookmarked"),
                                          duration: Duration(seconds: 1),
                                        )
                                    );
                                    Navigator.pop(context);
                                  },
                                ),
                                ListTile(
                                  leading: Icon(Icons.copy),
                                  title: Text("Copy"),
                                  onTap: () {
                                    Clipboard.setData(ClipboardData(text: verseText));
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text("Copied to Clipboard"),
                                          duration: Duration(seconds: 1),
                                        )
                                    );
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            ),
                          );
                        }
                    );
                  },
                  child: ListTile(
                    title: Text(
                      "$verseNumber. $verseText",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                );
              }, separatorBuilder: (BuildContext context, int index) { return Divider(); },
            );
          }
        },
      ),
    );
  }
}