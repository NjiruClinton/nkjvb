import 'dart:convert';

import 'package:bible/screens/versesview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;


class ChaptersView extends StatefulWidget {
  final String bookName;
  const ChaptersView({required String this.bookName, super.key,});

  @override
  State<ChaptersView> createState() => _ChaptersViewState();
}

class _ChaptersViewState extends State<ChaptersView> {
  late final String selectedBook;
  late Future<int> selectedBookChaptersLength;

  @override
  void initState() {
    super.initState();
    selectedBook = widget.bookName.trim();
    print(selectedBook);
    selectedBookChaptersLength = loadSelectedBookChaptersLength();

  }
  Future<int> loadSelectedBookChaptersLength() async {
    String jsonData = await loadJsonData();
    Map<String, dynamic> data = json.decode(jsonData);

    Map<String, dynamic>? selectedBookData = data['books'].firstWhere(
          (book) => book['name'] == selectedBook,
      orElse: () => null,
    );

    if (selectedBookData != null) {
      return selectedBookData['chapters'].length;
    } else {
      return 0;
    }
  }

  Future<String> loadJsonData() async {
    return await rootBundle.loadString('assets/nkjvbible.json');
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(selectedBook),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: FutureBuilder<int>(
          future: selectedBookChaptersLength,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error loading data'));
            } else {
              return GridView.count(
                crossAxisCount: 4,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                children: List.generate(snapshot.data ?? 0, (index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => VersesView(
                          chapterNumber: index + 1,
                          bookName: selectedBook,
                        )),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.blueGrey,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(color: Colors.white, fontSize: 25.0),
                        ),
                      ),
                    ),
                  );
                }),
              );
            }
          },
        ),
      ),
    );
  }
}
