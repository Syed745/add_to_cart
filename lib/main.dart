import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:add_to_cart/cart_provider.dart';
import 'package:add_to_cart/product_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CartProvider(),
      child: Builder(builder: (BuildContext context) {
        return AdaptiveTheme(
          light: ThemeData.light(useMaterial3: true),
          dark: ThemeData.dark(useMaterial3: true),
          initial: AdaptiveThemeMode.light,
          builder: (theme, darkTheme) => MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Adaptive Theme Demo',
            theme: theme,
            darkTheme: darkTheme,
            home: ProductList(),
          ),
        );
      }),
    );
  }
}
