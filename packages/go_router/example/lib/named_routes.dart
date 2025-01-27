// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:go_router/go_router.dart';

// This scenario demonstrates how to navigate using named locations instead of
// URLs.
//
// Instead of hardcoding the URI locations , you can also use the named
// locations. To use this API, give a unique name to each GoRoute. The name can
// then be used in context.namedLocation to be translate back to the actual URL
// location.

void main() {
  setUrlStrategy(PathUrlStrategy());
  runApp(App());
}

const Map<String, Family> _families = <String, Family>{
  'f1': Family(
    name: 'Doe',
    people: <String, Person>{
      'p1': Person(name: 'Jane', age: 23),
      'p2': Person(name: 'John', age: 6),
    },
  ),
  'f2': Family(
    name: 'Wong',
    people: <String, Person>{
      'p1': Person(name: 'June', age: 51),
      'p2': Person(name: 'Xin', age: 44),
    },
  ),
};

/// The main app.
class App extends StatelessWidget {
  /// The title of the app.
  static const String title = 'GoRouter Example: Named Routes';

  late final GoRouter _router = GoRouter(
    debugLogDiagnostics: true,
    routes: <GoRoute>[
      GoRoute(
        name: 'home',
        path: '/',
        builder: (BuildContext context, GoRouterState state) =>
            const HomeScreen(),
        routes: <GoRoute>[
          GoRoute(
              path: 'family/:fid',
              redirect: (context, state) {
                window.location.href =
                    'https://feat-multi-html-page-ex.dwutfyggvgzri.amplifyapp.com/test.html';
              })
        ],
      ),
    ],
  );

  /// Creates an [App].
  App({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp.router(
        routerConfig: _router,
        title: title,
        debugShowCheckedModeBanner: false,
      );
}

/// Family data class.
class Family {
  /// The last name of the family.
  final String name;

  /// The people in the family.
  final Map<String, Person> people;

  /// Create a family.
  const Family({required this.name, required this.people});
}

/// The screen that shows a list of persons in a family.
class FamilyScreen extends StatelessWidget {
  /// The id family to display.
  final String fid;

  /// Creates a [FamilyScreen].
  const FamilyScreen({required this.fid, super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, Person> people = _families[fid]!.people;
    return Scaffold(
      appBar: AppBar(title: Text(_families[fid]!.name)),
      body: ListView(
        children: <Widget>[
          for (final MapEntry<String, Person> entry in people.entries)
            ListTile(
              title: Text(entry.value.name),
              onTap: () => context.go(context.namedLocation(
                'person',
                pathParameters: <String, String>{'fid': fid, 'pid': entry.key},
                queryParameters: <String, String>{'qid': 'quid'},
              )),
            ),
        ],
      ),
    );
  }
}

/// The home screen that shows a list of families.
class HomeScreen extends StatelessWidget {
  /// Creates a [HomeScreen].
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(App.title),
      ),
      body: ListView(
        children: <Widget>[
          for (final MapEntry<String, Family> entry in _families.entries)
            ListTile(
              title: Text(entry.value.name),
              onTap: () => context.go(context.namedLocation('family',
                  pathParameters: <String, String>{'fid': entry.key})),
            )
        ],
      ),
    );
  }
}

/// Person data class.
class Person {
  /// The first name of the person.
  final String name;

  /// The age of the person.
  final int age;

  /// Creates a person.
  const Person({required this.name, required this.age});
}

/// The person screen.
class PersonScreen extends StatelessWidget {
  /// The id of family this person belong to.
  final String fid;

  /// The id of the person to be displayed.
  final String pid;

  /// Creates a [PersonScreen].
  const PersonScreen({required this.fid, required this.pid, super.key});

  @override
  Widget build(BuildContext context) {
    final Family family = _families[fid]!;
    final Person person = family.people[pid]!;
    return Scaffold(
      appBar: AppBar(title: Text(person.name)),
      body: Text('${person.name} ${family.name} is ${person.age} years old'),
    );
  }
}
