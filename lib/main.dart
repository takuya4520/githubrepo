import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'github_repo.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: GitHubPage(),
    );
  }
}

class GitHubPage extends StatefulWidget {
  const GitHubPage({super.key});

  @override
  State<GitHubPage> createState() => _GitHubPageState();
}

class _GitHubPageState extends State<GitHubPage> {
  List _repositories = [];
  Future<List<GitHubRepository>> searchRepositories(String searchWord) async {
    final response = await http.get(Uri.parse(
        'https://api.github.com/search/repositories?q=$searchWord&sort=stars&order=desc'));
    if (response.statusCode == 200) {
      List<GitHubRepository> list = [];
      Map<String, dynamic> decoded = json.decode(response.body);
      for (var item in decoded['items']) {
        list.add(GitHubRepository.fromMap(item));
      }
      return list;
    } else {
      throw Exception('Fail to search repository');
    }
  }

  @override
  void initState() {
    super.initState();
    searchRepositories('flutter');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.search), onPressed: () {}),
        actions: [
          IconButton(icon: Icon(Icons.more_vert), onPressed: () {}),
        ],
        elevation: 0,
        title: TextFormField(
          decoration: const InputDecoration(
            fillColor: Colors.white54,
            filled: true,
          ),
          onFieldSubmitted: (inputString) {
            if (inputString.length >= 5) {
              searchRepositories(inputString).then((repositories) {
                setState(() {
                  _repositories = repositories;
                });
              });
            }
          },
        ),
      ),
      extendBodyBehindAppBar: true,
      body: ListView.builder(
        itemCount: _repositories.length,
        itemBuilder: (BuildContext context, int index) {
          final repository = _repositories[index];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(12.0),
                child: Text(
                  repository.fullName,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                ),
              ),
              repository.language != null
                  ? Padding(
                      padding: EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 12.0),
                      child: Text(
                        repository.language,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 12.0),
                      ),
                    )
                  : Container(),
              repository.description != null
                  ? Padding(
                      padding: EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 12.0),
                      child: Text(repository.description,
                          style: TextStyle(
                              fontWeight: FontWeight.w200, color: Colors.grey)),
                    )
                  : Container(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Icon(Icons.star),
                  SizedBox(
                    width: 50.0,
                    child: Text(repository.stargazersCount.toString()),
                  ),
                  Icon(Icons.remove_red_eye),
                  SizedBox(
                    width: 50.0,
                    child: Text(repository.watchersCount.toString()),
                  ),
                ],
              ),
              SizedBox(
                height: 16.0,
              )
            ],
          );
        },
      ),
    );
  }
}
