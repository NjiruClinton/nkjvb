import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Bookmarks extends StatefulWidget {
  const Bookmarks({super.key});

  @override
  State<Bookmarks> createState() => _BookmarksState();
}

class _BookmarksState extends State<Bookmarks> {

  List<String> bookmarks = [];

  @override
  void initState() {
    super.initState();
    _loadBookmarks();
  }

  void _loadBookmarks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      bookmarks = prefs.getStringList('bookmarks') ?? [];
    });
  }

  void _deleteBookmark(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      bookmarks.removeAt(index);
      prefs.setStringList('bookmarks', bookmarks);
    });
  }

  // Future<void> getBookmark() async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   final List<String>? bookmarks = prefs.getStringList('bookmarks');
  //   setState(() {
  //     _bookmarks = bookmarks!;
  //   });
  // }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Bookmarks'),
        ),
        body: ListView.separated(
          itemCount: bookmarks.length,
          itemBuilder: (context, index) {
            List<String> bookmarkParts = bookmarks[index].split(' - ');
            return ListTile(
              title: Text(bookmarkParts[0]),
              subtitle: Padding(
                padding: EdgeInsets.only(top: 5.0),
                child: Text(bookmarkParts[1]),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  _deleteBookmark(index);
                },
              ),
            );
          }, separatorBuilder: (BuildContext context, int index) {
            return const Divider();
          }
        )
    );
  }
}

//FutureBuilder(
//           future: getBookmark(),
//           builder: (BuildContext context, AsyncSnapshot snapshot) {
//             if (snapshot.connectionState == ConnectionState.done) {
//               return ListView.builder(
//                 itemCount: _bookmarks.length,
//                 itemBuilder: (BuildContext context, int index) {
//                   return ListTile(
//                     title: Text(_bookmarks[index]),
//                   );
//                 },
//               );
//             } else {
//               return const Center(
//                 child: CircularProgressIndicator(),
//               );
//             }
//           },
//         )