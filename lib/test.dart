import 'package:flutter/material.dart';
import 'package:flutter_paystack_client/flutter_paystack_client.dart';

class TestHomePage extends StatefulWidget {
  const TestHomePage({Key? key}) : super(key: key);

  @override
  _TestHomePageState createState() => _TestHomePageState();
}

class _TestHomePageState extends State<TestHomePage> {
  final String _email = 'usermail@mail.com';
  final int _amount = 500;
  String _message = 'Order premium for premium features!!!';
  late DateTime paymentDate;
  late DateTime paymentExpiryDate;
  bool paymentStatus = false;
  late Duration difference;

  makePayment() async {
    Charge charge = Charge()
      ..reference = 'ref${DateTime.now().microsecondsSinceEpoch}'
      ..amount = _amount * 100
      ..email = _email;
    final response = await PaystackClient.checkout(context, charge: charge);
    if (response.status) {
      setState(() {
        _message = 'Transaction Successful';
        paymentStatus = true;
      });
    } else {
      setState(() {
        _message = 'Transaction failed';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PayStack test'),
        leading: ElevatedButton(
          onPressed: () {
            if (difference.inSeconds > 1) {
              setState(() {
                paymentStatus = false;
              });
            }
            print(paymentStatus);
            print(difference);
          },
          child: const Icon(Icons.refresh),
        ),
      ),
      body: SizedBox(
        child: Column(
          children: [
            Text(_message),
            Text('A premium: $paymentStatus'),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  makePayment();
                  paymentDate = DateTime.now();

                  paymentExpiryDate =
                      paymentDate.add(const Duration(seconds: 2));
                  difference = paymentExpiryDate.difference(paymentDate);
                },
                child: Center(
                  child: Row(
                    children: const [Text('Make payment'), Icon(Icons.payment)],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
