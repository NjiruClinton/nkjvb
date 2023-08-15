import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import 'chaptersview.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('NKJV Bible'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Old Testament', icon: Icon(Icons.book)
                ),
              Tab(text: 'New Testament', icon: Icon(Icons.menu_book)
                ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            OldTestament(),
            NewTestament(),
          ]
        )

      ),
    );
  }
}


class OldTestament extends StatefulWidget {
  const OldTestament({super.key});

  @override
  State<OldTestament> createState() => _OldTestamentState();
}

class _OldTestamentState extends State<OldTestament> {

  String _fileContents = '';

  @override
  void initState() {
    super.initState();
    loadAsset();
  }

Future<void> loadAsset() async {
  String filetext = await rootBundle.loadString('assets/oldt_books.txt');
  setState(() {
    _fileContents = filetext;
  });
}

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          // Text(_fileContents),
          Expanded(
            child: SizedBox(
              height: 500,
              child: ListView.separated(
                itemCount: _fileContents.split('\n').length,
                itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_fileContents.split('\n')[index]),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ChaptersView(
                        bookName: _fileContents.split('\n')[index],
                      )),
                    );
                  },
                  trailing: Icon(Icons.arrow_forward_ios),
                );
              }, separatorBuilder: (BuildContext context, int index) {
                return Divider();
              },
              )
            ),
          )
        ],
      )
    );
  }
}


class NewTestament extends StatefulWidget {
  NewTestament({super.key});

  @override
  State<NewTestament> createState() => _NewTestamentState();
}

class _NewTestamentState extends State<NewTestament> {

  String _fileContents = '';
  //load assets

  @override
  void initState() {
    super.initState();
    loadAsset();
  }

  Future<void> loadAsset() async {
    String filetext = await rootBundle.loadString('assets/newt_books.txt');
    setState(() {
      _fileContents = filetext;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
          children: [
            // Text(_fileContents),
            Expanded(
              child: SizedBox(
                  height: 500,
                  child: ListView.separated(
                    itemCount: _fileContents.split('\n').length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(_fileContents.split('\n')[index]),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ChaptersView(
                              bookName: _fileContents.split('\n')[index],
                            )),
                          );
                        },
                        trailing: Icon(Icons.arrow_forward_ios),
                      );
                    }, separatorBuilder: (BuildContext context, int index) {
                    return Divider();
                  },
                  )
              ),
            )
          ],
        )
    );
  }
}

