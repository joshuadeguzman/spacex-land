import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:spacex_land/screens/update_user/update_user.screen.dart';

class UsersPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _UsersPageState();
  }
}

class _UsersPageState extends State<UsersPage> {
  final String _query = """
  query users {
    users {
      id
      name
      rocket
      twitter
    }
  }
""";

  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(documentNode: gql(_query)),
      builder: (
        QueryResult result, {
        VoidCallback refetch,
        FetchMore fetchMore,
      }) {
        if (result.loading) {
          return Container(
            child: Center(
              child: Text("Loading"),
            ),
          );
        }

        final List users = result.data["users"];

        if (users == null || users.isEmpty) {
          return Container(
            child: Center(
              child: Text("No items found"),
            ),
          );
        } else {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                  left: 24,
                  top: 24,
                ),
                child: Text(
                  "Astronauts",
                  style: GoogleFonts.orbitron().copyWith(
                    color: Color(0xFF005288),
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: users.length,
                padding: const EdgeInsets.all(24),
                itemBuilder: (context, index) {
                  final user = users[index];

                  return Stack(
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.only(bottom: 24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(0, 10),
                              color: Colors.grey.shade300,
                              blurRadius: 30,
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Container(
                                        margin:
                                            const EdgeInsets.only(right: 120),
                                        child: Text(
                                          user['name'],
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Color(0xFF005288),
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () async {
                                          final route = MaterialPageRoute(
                                            builder: (_) => UpdateUserScreen(
                                              id: user['id'],
                                              name: user['name'],
                                              rocket: user['rocket'],
                                              twitter: user['twitter'],
                                            ),
                                          );

                                          final result = await Navigator.push(
                                            context,
                                            route,
                                          );

                                          if (result != null && result) {
                                            // TODO: Have a better way of notifying this dashboard screen to fetch new data
                                            setState(() {});
                                          }
                                        },
                                        child: Container(
                                          child: Icon(
                                            Icons.edit,
                                            color: Color(0xFF005288),
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 12),
                                  Text(
                                    "ID",
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey.shade400,
                                    ),
                                  ),
                                  Text(
                                    "${user['id']}",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 12),
                                  Text(
                                    "Rocket name",
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey.shade400,
                                    ),
                                  ),
                                  Text(
                                    "${user['rocket']}",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 12),
                                  Text(
                                    "Twitter",
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey.shade400,
                                    ),
                                  ),
                                  Text(
                                    "${user['twitter']}",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          );
        }
      },
    );
  }
}
