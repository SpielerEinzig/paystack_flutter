import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paystack_client/flutter_paystack_client.dart';
import 'package:integrating_flutterwave/test.dart';

const String appName = 'Paystack Example';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PaystackClient.initialize(
      "pk_test_8cc3cb26890264ab857ff4bf11a5c41fd53010be");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: appName,
      home: TestHomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _email = '';
  int _amount = 0;
  String _message = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Paystack Client Test'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width / 8,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _message,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
              keyboardType: TextInputType.emailAddress,
              onChanged: (val) {
                _email = val;
              },
            ),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Amount',
              ),
              keyboardType: TextInputType.number,
              onChanged: (val) {
                try {
                  _amount = (double.parse(val) * 100).toInt();
                } catch (e) {
                  print(e);
                }
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                setState(() {
                  _message = '';
                });

                final charge = Charge()
                  ..email = _email
                  ..amount = _amount
                  ..reference = 'ref_${DateTime.now().millisecondsSinceEpoch}';
                final res =
                    await PaystackClient.checkout(context, charge: charge);

                if (res.status) {
                  _message = 'Charge was successful. Ref: ${res.reference}';
                } else {
                  _message = 'Failed: ${res.message}';
                }
                setState(() {});
              },
              child: const Text('Checkout'),
            ),
          ],
        ),
      ),
    );
  }
}
