import 'package:add_to_cart/model/cart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Cart"),
      ),
      body: ListView.builder(
        itemCount: cart.items.length,
        itemBuilder: (context, index) {
          final product = cart.items[index];
          return ListTile(
            title: Text(product.name),
            subtitle: Text("\$${product.price.toStringAsFixed(2)}"),
            trailing: IconButton(
              icon: const Icon(Icons.remove_shopping_cart),
              onPressed: () {
                cart.removeFromCart(product);
              },
            ),
          );
        },
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          "Total: \$${cart.totalPrice.toStringAsFixed(2)}",
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
