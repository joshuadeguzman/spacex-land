import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:spacex_land/screens/home/home.screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final HttpLink link = HttpLink(
    uri: 'https://api.spacex.land/graphql/',
  );

  ValueNotifier<GraphQLClient> client = ValueNotifier(
    GraphQLClient(
      cache: InMemoryCache(),
      link: link,
    ),
  );

  runApp(MyApp(client: client));
}

class MyApp extends StatelessWidget {
  final ValueNotifier<GraphQLClient> client;

  const MyApp({Key key, this.client}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return GraphQLProvider(
      client: client,
      child: CacheProvider(
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blueGrey,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            textTheme: GoogleFonts.latoTextTheme(textTheme),
            appBarTheme: AppBarTheme(
              iconTheme: IconThemeData(
                color: Colors.black87,
              ),
              textTheme: GoogleFonts.orbitronTextTheme(textTheme),
            ),
          ),
          home: HomeScreen(),
        ),
      ),
    );
  }
}
