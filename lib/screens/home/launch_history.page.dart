import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';

class LaunchHistoryPage extends StatelessWidget {
  final DateFormat _dateFormat = DateFormat("MMMM dd, yyyy");

  final String _query = """
  query launchHistory {
      launchesPast(limit: 10) {
        mission_name 
        launch_date_utc
        rocket {
          rocket_name
          rocket_type
        }
        links {
          flickr_images
        }
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

        final List launches = result.data["launchesPast"];

        if (launches == null || launches.isEmpty) {
          return Container(
            child: Center(
              child: Text("No items found"),
            ),
          );
        } else {
          return Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                  right: 24,
                  top: 24,
                ),
                child: Text(
                  "Past launches",
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
                itemCount: launches.length,
                padding: const EdgeInsets.all(24),
                itemBuilder: (context, index) {
                  final launch = launches[index];
                  final List<dynamic> images = launch['links']['flickr_images'];

                  return Stack(
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.only(
                          bottom: 24,
                          right: 24,
                        ),
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
                                  Container(
                                    margin: const EdgeInsets.only(right: 120),
                                    child: Text(
                                      launch['mission_name'],
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Color(0xFF005288),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 12),
                                  Text(
                                    "Rocket",
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey.shade400,
                                    ),
                                  ),
                                  Text(
                                    "${launch['rocket']['rocket_name']} | ${launch['rocket']['rocket_type']}",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 12),
                                  Text(
                                    "Launch date",
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey.shade400,
                                    ),
                                  ),
                                  launch['launch_date_utc'] != null
                                      ? Text(
                                          "${_dateFormat.format(DateTime.parse(launch['launch_date_utc']))}",
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                      : Text(
                                          "TO BE DETERMINED",
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
                      images.length > 0
                          ? Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                margin: const EdgeInsets.only(top: 16),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: SizedBox(
                                    height: 100,
                                    width: 120,
                                    child: CachedNetworkImage(
                                      imageUrl: images.first,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : Container(),
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
