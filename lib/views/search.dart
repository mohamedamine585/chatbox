import 'package:chat/Authservice.dart/chatuser.dart';
import 'package:chat/views/consts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Chatservice/chatservice.dart';
import '../imageservice/image.dart';

class searchdelegate extends SearchDelegate {
  @override
  String get searchFieldLabel => "Search for friends";
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.person),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    try {
      return StreamBuilder(
          stream: chatservice().get_searched(text: query),
          builder: ((context, snapshot) {
            final d = snapshot as AsyncSnapshot<Iterable<chatuser>?>?;
            if (d?.data?.isNotEmpty ?? false) {
              return ListView.builder(
                  itemCount: d?.data?.length,
                  itemBuilder: ((context, index) {
                    final user = d?.data!.elementAt(index);

                    return ListTile(
                      title: Text(user?.Username ?? ''),
                      leading: const Icon(Icons.person),
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed(Chatuserview, arguments: user);
                      },
                    );
                  }));
            }
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }));
    } catch (e) {
      return const ListTile();
    }
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return StreamBuilder(
        stream: chatservice().get_searched(text: query),
        builder: ((context, snapshot) {
          final d = snapshot as AsyncSnapshot<Iterable<chatuser>?>?;

          return ListView.builder(
              itemCount: d?.data?.length,
              itemBuilder: ((context, index) {
                final user = d?.data?.elementAt(index);
                return ListTile(
                  title: Text(user?.Username ?? ''),
                  leading: Imagetakeruploader()
                      .showingimage(email: user?.email, radius: 20),
                  onTap: () {
                    Navigator.of(context)
                        .pushNamed(Chatuserview, arguments: user);
                  },
                );
              }));
        }));
  }
}
