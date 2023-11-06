import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:add_to_cart/cart_model.dart';
import 'package:add_to_cart/cart_provider.dart';
import 'package:add_to_cart/cart_screen.dart';
import 'package:add_to_cart/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:provider/provider.dart';

class ProductList extends StatefulWidget {
  const ProductList({super.key});

  @override
  State<ProductList> createState() => _ProductListState();
}

DBHelper? dbHelper = DBHelper();

List<String> productName = [
  'Apple',
  'Banana',
  'Orange',
  'Grapes',
  'Strawberries',
  'Pineapple'
];
List<String> productUnit = ['Kg', 'Dozen', 'Dozen', 'Kg', 'kg', 'kg'];
List<int> productPrice = [10, 20, 43, 50, 100, 50];
List<String> productImages = [
  'assets/images/apple.jpg',
  'assets/images/banana.jpg',
  'assets/images/orange.jpg',
  'assets/images/grapes.jpg',
  'assets/images/strawbarry.jpg',
  'assets/images/pineapple.jpg',
];

bool lightOrDark = false;

class _ProductListState extends State<ProductList> {
  @override
  Widget build(BuildContext context) {
    ///
    final cart = Provider.of<CartProvider>(context);

////

    ///
    // void lightDarkMode() {
    //   setState(() {
    //     lightOrDark != lightOrDark;
    //     lightOrDark
    //         // ignore: dead_code
    //         ? AdaptiveTheme.of(context).setTheme(
    //             light: ThemeData(
    //             useMaterial3: true,
    //             brightness: Brightness.light,
    //             colorSchemeSeed: Colors.purple,
    //           ))
    //         : AdaptiveTheme.of(context).setTheme(
    //             light: ThemeData(
    //               useMaterial3: true,
    //               brightness: Brightness.dark,
    //               colorSchemeSeed: Colors.purple,
    //             ),
    //           );
    //   });
    // }

    return Scaffold(
      appBar: AppBar(
        title: ElevatedButton.icon(
          // ignore: dead_code
          label: Text(lightOrDark ? 'Dark mode on' : 'Light mode on'),
          onPressed: () {
            setState(() {
              lightOrDark = !lightOrDark;
              lightOrDark
                  ? AdaptiveTheme.of(context).setTheme(
                      light: ThemeData(
                      useMaterial3: true,
                      brightness: Brightness.light,
                      colorSchemeSeed: Colors.black,
                    ))
                  : AdaptiveTheme.of(context).setTheme(
                      light: ThemeData(
                        useMaterial3: true,
                        brightness: Brightness.dark,
                        colorSchemeSeed: Colors.yellow,
                      ),
                    );
            });
          },
          // ignore: dead_code
          icon: Icon(lightOrDark ? Icons.dark_mode : Icons.light_mode),
        ),
        // title: const Text('Fruits'),
        centerTitle: true,
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CartScreen(),
                ),
              );
            },
            child: Center(
              child: badges.Badge(
                badgeContent: Consumer<CartProvider>(
                  builder: (context, value, child) {
                    return Text(
                      value.getCounter().toString(),
                      style: const TextStyle(color: Colors.white),
                    );
                  },
                ),
                child: const Icon(Icons.shopping_bag_outlined),
              ),
            ),
          ),
          const SizedBox(
            width: 20.0,
          )
        ],
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemCount: productName.length,
        itemBuilder: (context, index) {
          return SingleChildScrollView(
            child: Container(
              decoration: const BoxDecoration(color: Color(0xffeaf4f4)),
              margin: const EdgeInsets.all(10),
              width: 300,
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 1),
                    width: 100,
                    height: 90,
                    child: Image.asset(productImages[index]),
                  ),
                  Text(
                    productName[index].toString(),
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    '\$ ${productPrice[index].toString()} ',
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    productUnit[index].toString(),
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      dbHelper!
                          .insert(Cart(
                              id: index,
                              productId: index.toString(),
                              productName: productName[index].toString(),
                              initialPrice: productPrice[index],
                              productPrice: productPrice[index],
                              quantity: 1,
                              unitTag: productUnit[index].toString(),
                              image: productImages[index].toString()))
                          .then((value) {
                        print('Product Is added to cart');
                        cart.addTotalPrice(
                          double.parse(
                            productPrice[index].toString(),
                          ),
                        );
                        cart.addCounter();
                      }).onError((error, stackTrace) {
                        print(
                          error.toString(),
                        );
                      });
                    },
                    child: const Text(
                      'Add to cart\n',
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
