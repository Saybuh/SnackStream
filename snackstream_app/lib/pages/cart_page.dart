import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/my_button.dart';
import '../components/my_cart_tile.dart';
import '../models/restaurant.dart';
import 'payment_page.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<Restaurant>(
      builder: (context, restaurant, child) {
        // cart
        final userCart = restaurant.cart;

        // scaffold UI
        return Scaffold(
          appBar: AppBar(
            title: const Text("Cart"),
            backgroundColor: Colors.transparent,
            foregroundColor: Theme.of(context).colorScheme.inversePrimary,
            actions: [
              // clear cart button
              userCart.isEmpty
                  ?
                  // button unavailable
                  IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.delete_forever,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    )
                  :
                  // button available
                  IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text(
                                "Are you sure you want to clear the cart?"),
                            actions: [
                              // no button
                              MaterialButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text("No"),
                              ),

                              // yes button
                              MaterialButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  Provider.of<Restaurant>(context,
                                          listen: false)
                                      .clearCart();
                                },
                                child: const Text("Yes"),
                              )
                            ],
                          ),
                        );
                      },
                      icon: const Icon(Icons.delete_forever),
                    )
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: userCart.isEmpty
                    ? Center(
                        child: Text(
                          "Cart is empty..",
                          style: TextStyle(
                              color:
                                  Theme.of(context).colorScheme.inversePrimary),
                        ),
                      )
                    : ListView.builder(
                        itemCount: userCart.length,
                        itemBuilder: (context, index) {
                          // each item in cart
                          final cartItem = userCart[index];

                          // tile UI
                          return MyCartTile(
                            cartItem: cartItem,
                          );
                        },
                      ),
              ),

              const SizedBox(height: 25),

              // checkout button only show when there is checkout items
              if (userCart.isNotEmpty)

                // checkout button: available
                MyButton(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PaymentPage(),
                      )),
                  text: "Go to checkout " +
                      '\$' +
                      restaurant.getTotalPrice().toStringAsFixed(2),
                ),

              const SizedBox(height: 25),
            ],
          ),
        );
      },
    );
  }
}
