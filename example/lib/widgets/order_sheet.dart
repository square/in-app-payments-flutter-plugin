/*
 Copyright 2018 Square Inc.
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
*/
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import '../colors.dart';
import 'cookie_button.dart';

enum PaymentType {
  giftcardPayment,
  cardPayment,
  googlePay,
  applePay,
  buyerVerification,
  secureRemoteCommerce
}

final int cookieAmount = 100;

String getCookieAmount() => (cookieAmount / 100).toStringAsFixed(2);

class OrderSheet extends StatelessWidget {
  final bool googlePayEnabled;
  final bool applePayEnabled;
  OrderSheet({required this.googlePayEnabled, required this.applePayEnabled});

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(20.0),
                topRight: const Radius.circular(20.0))),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                child: _title(context),
              ),
              ConstrainedBox(
                constraints: BoxConstraints(
                    minWidth: MediaQuery.of(context).size.width,
                    minHeight: 350,
                    maxHeight: MediaQuery.of(context).size.height,
                    maxWidth: MediaQuery.of(context).size.width),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      _ShippingInformation(),
                      _LineDivider(),
                      _PaymentTotal(),
                      _LineDivider(),
                      _RefundInformation(),
                      _payButtons(context),
                      _buyerVerificationButton(context),
                      _masterCardButton(context)
                    ]),
              ),
            ]),
      );

  Widget _title(context) => Container(
        padding: EdgeInsets.all(5.0),
        color: mainButtonColor,
        child:
            Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
          Expanded(
            child: Text(
              "Place your order",
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
              child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.close),
                  color: closeButtonColor)),
        ]),
      );

  Widget _payButtons(context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          CookieButton(
            text: "Pay with gift card",
            onPressed: () {
              Navigator.pop(context, PaymentType.giftcardPayment);
            },
          ),
          CookieButton(
            text: "Pay with card",
            onPressed: () {
              Navigator.pop(context, PaymentType.cardPayment);
            },
          ),
        ],
      );

  Widget _buyerVerificationButton(context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Container(
            height: 50,
            width: MediaQuery.of(context).size.width * .44,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
              onPressed: googlePayEnabled || applePayEnabled
                  ? () {
                      if (Platform.isAndroid) {
                        Navigator.pop(context, PaymentType.googlePay);
                      } else if (Platform.isIOS) {
                        Navigator.pop(context, PaymentType.applePay);
                      }
                    }
                  : null,
              child: Image(
                  image: (Theme.of(context).platform == TargetPlatform.iOS)
                      ? AssetImage("assets/applePayLogo.png")
                      : AssetImage("assets/googlePayLogo.png")),
            ),
          ),
          CookieButton(
            text: "Buyer Verification",
            onPressed: () {

              Scaffold.of(context).showBottomSheet((context) =>Container());
              Navigator.pop(context, PaymentType.buyerVerification);
            },
          ),
        ],
      );

  Widget _masterCardButton(context) => Column(
        children: [
          Container(
            height: 50,
            width: MediaQuery.of(context).size.width * .44,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
              onPressed: () {
                Navigator.pop(context, PaymentType.secureRemoteCommerce);
              },
              child: Image(image: AssetImage("assets/masterCardLogo.png")),
            ),
          ),
        ],
      );

}

class _ShippingInformation extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(padding: EdgeInsets.only(left: 30)),
          Text(
            "Ship to",
            style: TextStyle(
                fontSize: 16,
                color: mainTextColor,
                fontWeight: FontWeight.bold),
          ),
          Padding(padding: EdgeInsets.only(left: 20)),
          Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Lauren Nobel",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 4),
                ),
                Text(
                  "1455 Market Street\nSan Francisco, CA, 94103",
                  style: TextStyle(fontSize: 15, color: subTextColor),
                ),
              ]),
        ],
      );
}

class _LineDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
      margin: EdgeInsets.only(left: 30, right: 30),
      child: Divider(
        height: 1,
        color: dividerColor,
      ));
}

class _PaymentTotal extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(padding: EdgeInsets.only(left: 30)),
          Text(
            "Total",
            style: TextStyle(
                fontSize: 16,
                color: mainTextColor,
                fontWeight: FontWeight.bold),
          ),
          Padding(padding: EdgeInsets.only(left: 30)),
          Text(
            "\$${getCookieAmount()}",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
        ],
      );
}

class _RefundInformation extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        width: MediaQuery.of(context).size.width - 50,
        child: Text(
          "You can refund this transaction through your Square dashboard, go to squareup.com/dashboard.",
          style: TextStyle(fontSize: 12, color: subTextColor),
          textAlign: TextAlign.center,
        ),
      );
}
