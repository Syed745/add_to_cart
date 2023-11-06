import 'package:add_to_cart/model/cart.dart';
// import 'package:add_to_cart/screen/car_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductListPage extends StatelessWidget {
  final List<Product> products;

  const ProductListPage(this.products, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Product List"),
      ),
      body: GridView.builder(
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              color: const Color(0xffe5e5e5),
              child: Column(
                children: [
                  SizedBox(
                    width: 100,
                    height: 100,
                    child: Image.asset(product.img),
                  ),
                  Text(product.name),
                  Text("\$${product.price.toStringAsFixed(2)}"),
                  Consumer<Cart>(
                    builder: (context, cart, child) {
                      return IconButton(
                        icon: const Icon(Icons.add_shopping_cart),
                        onPressed: () {
                          cart.addToCart(product);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("${product.name} added to cart."),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                      );
                    },
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

      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //         builder: (context) => const CartPage(),
      //       ),
      //     );
      //   },
      //   child: const Icon(Icons.shopping_cart),
      // ),