import 'dart:convert';

import 'package:example/services/github_service.dart';
import 'package:example/widgets/github_form.dart';
import 'package:flutter/material.dart';
import 'package:simple_icons/simple_icons.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title, required this.apiURL});

  final String apiURL;
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _usernameGithub = "";
  String _imageGithub = "";
  String _repositoriesGithubURL = "";

  Map<String, dynamic>? resBody;
  List<dynamic>? resRepositoriesBody;

  bool _isSuccess = false;

  Future<void> getUserGithub(String username) async {
    final response =
        await GithubService.fetchGithubUser(widget.apiURL, username);
    setState(() {
      if (response['error'] != null) {
        _usernameGithub = response['error'];
        resBody = null;
        _isSuccess = false;
      } else {
        _usernameGithub = response['login'] ?? 'User not found';
        _imageGithub = response['avatar_url'] ?? '';
        _repositoriesGithubURL = response['repos_url'] ?? '';
        getRepositoriesGithub(_repositoriesGithubURL);
        resBody = response;
        _isSuccess = true;
      }
    });
  }

  Future<void> getRepositoriesGithub(String url) async {
    final response = await GithubService.fetchGithubRepositories(url);
    setState(() {
      if(response.isNotEmpty){
        resRepositoriesBody = response;
      }
    });
  }

  void _resetSearch() {
    setState(() {
      _isSuccess = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getUserGithub('backsoul');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        color: Colors.grey.shade300,
        child: Column(
          children: [
            if (_isSuccess == true) ...[
              Center(
                  child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: 100,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(_imageGithub),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Stack(
                      children: [
                        Container(
                          color: Colors.black
                              .withOpacity(0.5), // Adjust opacity here
                        ),
                        Center(
                          child: Text(
                            _usernameGithub,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 40.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      if (resBody != null)
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Wrap(
                                  direction: Axis.vertical,
                                  spacing: 10,
                                  children: [
                                    const Text(
                                      'Current Status',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w800),
                                      textAlign: TextAlign.center,
                                    ),
                                    Text(
                                      '${resBody?['bio'] ?? 'No bio available'}',
                                      style: const TextStyle(fontSize: 16),
                                      textAlign: TextAlign.center,
                                    ),
                                    const Text(
                                      'Name',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w800),
                                      textAlign: TextAlign.center,
                                    ),
                                    Text(
                                      '${resBody?['name'] ?? 'Name not available'}',
                                      style: const TextStyle(fontSize: 16),
                                      textAlign: TextAlign.center,
                                    ),
                                    const Text(
                                      'Repositories',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w800),
                                      textAlign: TextAlign.center,
                                    ),
                                  ])
                            ],
                          ),
                        ),
                      Container(
                        height: 200.0,
                        child: ListView.builder(
                          physics: ClampingScrollPhysics(),
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: resRepositoriesBody?.length ??
                              0, // Manejo de lista nula
                          itemBuilder: (context, index) {
                            final repo = resRepositoriesBody?[index];
                            return SizedBox(
                              width: 300,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            const Icon(
                                              SimpleIcons.github, // Icono
                                              color: SimpleIconColors
                                                  .github, // Color
                                              size: 24.0, // Tamaño del icono
                                            ),
                                            const SizedBox(width: 20),
                                            Expanded(
                                              child: Text(
                                                repo["full_name"] ??
                                                    "No Name", // Manejo de valores nulos
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 20,
                                                  color: Colors.black
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 20),
                                        Row(
                                          children: [
                                            const Text(
                                              "Languages",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 20,
                                              ),
                                            ),
                                            SizedBox(width: 20),
                                            Expanded(
                                              child: Text(
                                                repo["language"] ??
                                                    "Unknown", // Mostrar lenguaje o valor por defecto
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 20,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  )
                ],
              ))
            ],
            GithubForm(
              onSearch: getUserGithub,
              onReset: _resetSearch,
              show: _isSuccess,
            ),
          ],
        ),
      ),
    );
  }
}
