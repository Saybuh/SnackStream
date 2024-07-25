import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import '../models/cart.dart';
import '../services/database_service.dart';
import '../services/auth_service.dart';
import 'order_confirmation_screen.dart';
import '../widgets/app_drawer.dart';

class CheckoutScreen extends StatefulWidget {
  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  final TextEditingController _addressController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void onCreditCardModelChange(CreditCardModel creditCardModel) {
    setState(() {
      cardNumber = creditCardModel.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    final databaseService = Provider.of<DatabaseService>(context);
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout'),
      ),
      drawer: AppDrawer(),
      body: Column(
        children: <Widget>[
          CreditCardWidget(
            cardNumber: cardNumber,
            expiryDate: expiryDate,
            cardHolderName: cardHolderName,
            cvvCode: cvvCode,
            showBackView: isCvvFocused,
            obscureCardNumber: true,
            obscureCardCvv: true,
            onCreditCardWidgetChange:
                (CreditCardBrand creditCardBrand) {}, // Required parameter
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  CreditCardForm(
                    formKey: formKey,
                    onCreditCardModelChange: onCreditCardModelChange,
                    cardNumber: cardNumber,
                    expiryDate: expiryDate,
                    cardHolderName: cardHolderName,
                    cvvCode: cvvCode,
                    obscureCvv: true,
                    obscureNumber: true,
                  ),
                  TextField(
                    controller: _addressController,
                    decoration: InputDecoration(labelText: 'Delivery Address'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        // Here you would handle card processing logic
                        await databaseService.addOrder({
                          'userId': authService.user!.uid,
                          'items':
                              cart.items.map((item) => item.toMap()).toList(),
                          'status': 'pending',
                          'customerAddress': _addressController.text,
                          'restaurantAddress':
                              'Restaurant Address Here', // Fetch the restaurant address
                        });
                        cart.clear();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => OrderConfirmationScreen()),
                        );
                      } else {
                        print('Invalid form');
                      }
                    },
                    child: Text('Confirm Order'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
