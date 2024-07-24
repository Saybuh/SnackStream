import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DeliveryPickupSwitch extends StatefulWidget {
  const DeliveryPickupSwitch({super.key});

  @override
  State<DeliveryPickupSwitch> createState() => _DeliveryPickupSwitchState();
}

class _DeliveryPickupSwitchState extends State<DeliveryPickupSwitch> {
  bool isDelivery = true; // Initial state set to 'Delivery'

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            'Pickup',
            textAlign: TextAlign.end,
            style: TextStyle(
              color: isDelivery
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.inversePrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: CupertinoSwitch(
            value: isDelivery,
            onChanged: (bool value) {
              setState(() {
                isDelivery = value;
              });
            },
          ),
        ),
        Expanded(
          child: Text(
            'Delivery',
            style: TextStyle(
              color: isDelivery
                  ? Theme.of(context).colorScheme.inversePrimary
                  : Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
