import 'package:flutter/material.dart';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:sportsstore_flutter/shared/widget/input-field.dart';
import 'package:sportsstore_flutter/service/cart-service.dart';
import 'package:sportsstore_flutter/model/order.dart';
import 'package:sportsstore_flutter/model/checkout-form.dart';
import 'package:sportsstore_flutter/validator/general.dart';
import 'package:sportsstore_flutter/helpers.dart';

class Checkout extends StatefulWidget {
  Checkout({Key key, this.title}) : super(key: key);

  static const String routeName = '/Checkout';

  final String title;

  @override
  _CheckoutState createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {

  bool giftwrap = false;
  String name;
  String addr1;
  String addr2;
  String addr3;
  String city;
  String state;
  String zip;
  String country;
  bool isValid = false;

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    setState(() {
     isValid = formKey.currentState?.validate() ?? false;
    });
  }

  void showRetry(DioError error) {
    handleError(context, error, () async {
      await submit();
    });
  }

  Future<void> submit() async {
    var valid = formKey.currentState.validate();
    if (!valid) {
      return;
    }

    var order = Order(
      name: name,
      line1: addr1,
      line2: addr2,
      line3: addr3,
      city: city,
      state: state,
      zip: zip,
      country: country,
      giftwrap: giftwrap
    );
    var lines = await getLines();
    var fm = CheckoutForm(
      order: order,
      lines: lines
    );
    try {
      await checkout(fm);
      Navigator.pop(context, true);
    }
    
    catch (error) {
      showRetry(error);
    }
  }

  Widget buildContent() {
    return Container(
      padding: const EdgeInsets.all(10.0),
      child: Form(
        key: formKey,
        child: ListView(
          children: <Widget>[
            Text(
              'Ship to',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            InputField(
              label: 'Name',
              onChanged: (String s) {
                setState(() {
                 name = s;
                 isValid = formKey.currentState.validate();
                });
              },
              validator: (s) {
                return vRequired(s, 'Name');
              },
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(0, 15.0, 0, 5.0),
              child: Text(
                'Address',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            InputField(
              label: 'Line 1',
              onChanged: (String s) {
                setState(() {
                 addr1 = s;
                 isValid = formKey.currentState.validate();
                });
              },
              validator: (s) {
                return vRequired(s, 'Line 1');
              },
            ),
            InputField(
              label: 'Line 2',
              onChanged: (String s) {
                setState(() {
                 addr2 = s;
                });
              },
            ),
            InputField(
              label: 'Line 3',
              onChanged: (String s) {
                setState(() {
                 addr3 = s;
                });
              },
            ),
            InputField(
              label: 'City',
              onChanged: (String s) {
                setState(() {
                 city = s;
                 isValid = formKey.currentState.validate();
                });
              },
              validator: (s) {
                return vRequired(s, 'City');
              },
            ),
            InputField(
              label: 'State',
              onChanged: (String s) {
                setState(() {
                 state = s;
                 isValid = formKey.currentState.validate();
                });
              },
              validator: (s) {
                return vRequired(s, 'State');
              },
            ),
            InputField(
              label: 'Zip',
              onChanged: (String s) {
                setState(() {
                 zip = s; 
                });
              },
            ),
            InputField(
              label: 'Country',
              onChanged: (String s) {
                setState(() {
                 country = s;
                 isValid = formKey.currentState.validate();
                });
              },
              validator: (s) {
                return vRequired(s, 'Country');
              },
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(0, 15.0, 0, 5.0),
              child: Text(
                'Options',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Row(
              children: <Widget>[
                Checkbox(
                  value: giftwrap,
                  onChanged: (bool b) {
                    setState(() {
                     giftwrap = b; 
                    });
                  },
                ),
                Text('Gift wrap these items'),
              ],
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: RaisedButton(
                color: Colors.red,
                elevation: 5,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                child: Text(
                  'Complete Order',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white
                  ),
                ),
                onPressed: !isValid ? null : () async {
                  await submit();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: buildContent(),
    );
  }
}