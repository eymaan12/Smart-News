import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/news_provider.dart';
import 'screens/news_list_screen.dart';

void main() {
  runApp(const SmartNewsApp());
}

class SmartNewsApp extends StatelessWidget {
  const SmartNewsApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NewsProvider()),
      ],
      child: MaterialApp(
        title: 'Smart News',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: const NewsListScreen(),
      ),
    );
  }
}
