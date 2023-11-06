import 'package:add_to_cart/cart_model.dart';
import 'package:add_to_cart/cart_provider.dart';
import 'package:add_to_cart/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  DBHelper? dbHelper = DBHelper();

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Carts'),
        centerTitle: true,
        actions: [
          Center(
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
          const SizedBox(
            width: 20.0,
          )
        ],
      ),
      body: Column(
        children: [
          FutureBuilder(
              future: cart.getData(),
              builder: (context, AsyncSnapshot<List<Cart>> snapshot) {
                if (snapshot.hasData) {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              leading: Image.asset(
                                snapshot.data![index].image.toString(),
                              ),
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    snapshot.data![index].productName
                                        .toString(),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500),
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        dbHelper!
                                            .delete(snapshot.data![index].id!);
                                        cart.removeCounter();
                                        cart.removeTotalPrice(double.parse(
                                            snapshot.data![index].productPrice
                                                .toString()));
                                      },
                                      icon: const Icon(
                                        Icons.delete_forever_rounded,
                                        color: Colors.red,
                                      ))
                                ],
                              ),
                              subtitle: Row(
                                children: [
                                  Text(
                                    ' ${snapshot.data![index].unitTag.toString()} ',
                                  ),
                                  Text(
                                    '\$${snapshot.data![index].productPrice.toString()} ',
                                  ),
                                  const Spacer(),
                                  Row(
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          int quantity =
                                              snapshot.data![index].quantity!;

                                          int price = snapshot
                                              .data![index].initialPrice!;
                                          quantity++;
                                          int? newPrice = price * quantity;

                                          dbHelper!
                                              .updateQuantity(Cart(
                                                  id: snapshot.data![index].id!,
                                                  productId: snapshot
                                                      .data![index].id!
                                                      .toString(),
                                                  productName: snapshot
                                                      .data![index]
                                                      .productName!,
                                                  initialPrice: snapshot
                                                      .data![index]
                                                      .initialPrice!,
                                                  productPrice: newPrice,
                                                  quantity: quantity,
                                                  unitTag: snapshot
                                                      .data![index].unitTag
                                                      .toString(),
                                                  image: snapshot
                                                      .data![index].image
                                                      .toString()))
                                              .then((value) {
                                            newPrice = 0;
                                            quantity = 0;
                                            cart.addTotalPrice(double.parse(
                                                snapshot
                                                    .data![index].initialPrice!
                                                    .toString()));
                                          }).onError((error, stackTrace) {
                                            print(error.toString());
                                          });
                                        },
                                        icon: const Icon(Icons.add_circle),
                                      ),
                                      Text(
                                        snapshot.data![index].quantity
                                            .toString(),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          int quantity =
                                              snapshot.data![index].quantity!;

                                          int price = snapshot
                                              .data![index].initialPrice!;
                                          quantity--;
                                          int? newPrice = price * quantity;

                                          if (quantity > 0) {
                                            dbHelper!
                                                .updateQuantity(Cart(
                                                    id: snapshot
                                                        .data![index].id!,
                                                    productId: snapshot
                                                        .data![index].id!
                                                        .toString(),
                                                    productName: snapshot
                                                        .data![index]
                                                        .productName!,
                                                    initialPrice: snapshot
                                                        .data![index]
                                                        .initialPrice!,
                                                    productPrice: newPrice,
                                                    quantity: quantity,
                                                    unitTag: snapshot
                                                        .data![index].unitTag
                                                        .toString(),
                                                    image: snapshot
                                                        .data![index].image
                                                        .toString()))
                                                .then((value) {
                                              newPrice = 0;
                                              quantity = 0;
                                              cart.removeTotalPrice(
                                                  double.parse(snapshot
                                                      .data![index]
                                                      .initialPrice!
                                                      .toString()));
                                            }).onError((error, stackTrace) {
                                              print(error.toString());
                                            });
                                          }
                                        },
                                        icon: const Icon(Icons.remove_circle),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
                return const Text('data');
              }),
          Container(
            padding: EdgeInsets.all(10),
            width: double.infinity,
            height: 150,
            color: const Color(0xfff7f8fa),
            child: Consumer<CartProvider>(builder: (context, value, child) {
              return Visibility(
                visible: value.getTotalPrice().toStringAsFixed(2) == "0.00"
                    ? false
                    : true,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ResuableWidget(
                        title: 'Sub Total',
                        value: '\$ ${value.getTotalPrice()} '),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Delivery',
                          style: TextStyle(color: Colors.black),
                        ),
                        Text(
                          '\$ 2.00',
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                    ResuableWidget(
                        title: 'Total',
                        value: '\$ ${value.getTotalPrice() + 2} ')
                  ],
                ),
              );
            }),
          )
        ],
      ),
    );
  }
}

class ResuableWidget extends StatelessWidget {
  final String title, value;
  const ResuableWidget({required this.title, required this.value, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(color: Colors.black),
          ),
          Text(
            value,
            style: TextStyle(color: Colors.black),
          )
        ],
      ),
    );
  }
}


// Wrap(children: [
//                           SizedBox(
//                             width: 200,
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceAround,
//                               children: [
//                                 Container(
//                                   margin: EdgeInsets.only(top: 1),
//                                   width: 100,
//                                   height: 90,
                                 
//                                 ),
//                                 Padding(
//                                   padding: const EdgeInsets.only(top: 8.0),
//                                   child: Column(
//                                     children: [
//                                       Row(
//                                         children: [
//                                           Text(
//                                             snapshot.data![index].productName
//                                                 .toString(),
//                                             style: const TextStyle(
//                                                 fontWeight: FontWeight.w500),
//                                           ),
//                                           Icon(Icons.delete)
//                                         ],
//                                       ),
//                                       
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ]);