import 'package:flutter/material.dart';
import 'process_payment.dart';

class BuyScreen extends StatefulWidget {
  BuyScreenState createState() => BuyScreenState();
}

class BuyScreenState extends State<BuyScreen> {
  ProcessPayment processPayment;
  @override
  void initState() {
    super.initState();
    processPayment = ProcessPayment(context);
  }


  @override
  Widget build(BuildContext context) =>
    MaterialApp(
      theme: ThemeData(
        canvasColor: Colors.black.withOpacity(0.5)
      ),
      home: Scaffold(
        body: Column(
          children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.35,
          width: MediaQuery.of(context).size.width,
          alignment: Alignment(0.0, 1.0),
          child: GestureDetector(onTap: () {Navigator.pop(context, false);})
          ),// child:
            Container(
              height: MediaQuery.of(context).size.height * 0.65,
                decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft:  const  Radius.circular(20.0),
                              topRight: const  Radius.circular(20.0))
                      ),
                child:
                Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 10, top: 10),
                      child:
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            height: 56,
                            width: 56,
                            child:
                            IconButton(onPressed: (){Navigator.pop(context, false);},
                              icon: Image(
                                image: AssetImage("assets/btnClose.png"),
                              )
                            )
                          ),
                          Padding(padding: EdgeInsets.only(right: 64)),
                          Expanded(
                            child: Text(
                              "Place your order",
                              style: TextStyle(fontSize: 18, fontFamily: 'SF_Pro_Text', fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                    child:
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(padding: EdgeInsets.only(left: 30)),
                              Text(
                                "Ship to",
                                style: TextStyle(fontSize: 16, fontFamily: 'SF_Pro_Text',color: Color(0xFF24988D)),
                              ),
                              Padding(padding: EdgeInsets.only(left: 30)),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Lauren Nobel",
                                    style: TextStyle(fontSize: 16, fontFamily: 'SF_Pro_Text', fontWeight: FontWeight.w500),
                                    textAlign: TextAlign.center,
                                  ),
                                  Padding(padding: EdgeInsets.only(bottom: 6),),
                                  Text(
                                    "1455 Market Street\nSan Francisco, CA, 94103",
                                    style: TextStyle(fontSize: 16, fontFamily: 'SF_Pro_Text', color: Color(0xFF7B7B7B)),
                                  ),
                                ]
                              ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                color: Color(0xFFD8D8D8),
                                height: 1, 
                                margin: const EdgeInsets.only(left: 30.0, right: 30.0),
                              ),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(padding: EdgeInsets.only(left: 30)),
                              Text(
                                "Total",
                                style: TextStyle(fontSize: 16, fontFamily: 'SF_Pro_Text',color: Color(0xFF24988D)),
                              ),
                              Padding(padding:EdgeInsets.only(right: 47)),
                              Text(
                                "\$1.00",
                                style: TextStyle(fontSize: 16, fontFamily: 'SF_Pro_Text', fontWeight: FontWeight.w500),
                                textAlign: TextAlign.center,
                              ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                color: Color(0xFFD8D8D8),
                                height: 1, 
                                margin: const EdgeInsets.only(left: 30.0, right: 30.0),
                              ),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              margin: const EdgeInsets.only(left: 30.0, right: 30.0),
                              width: MediaQuery.of(context).size.width - 60,
                              child:
                                Text(
                                  "You can refund this transaction through your Square dashboard, go to squareup.com/dashboard.",
                                  style: TextStyle(fontSize: 12, fontFamily: 'SF_Pro_Text',color: Color(0xFF7B7B7B)),
                                  maxLines: 2,
                                ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Padding(padding: EdgeInsets.only(left: 30)),
                            Expanded(
                              child:
                              RaisedButton(
                                onPressed: (){
                                  processPayment.paymentInitialized ? processPayment.onStartCardEntryFlow() : null;
                                },
                                child: SizedBox(
                                  height: 64,
                                  child:
                                    FittedBox(
                                      child:
                                        Text(
                                        'Pay with card',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18
                                        )
                                      ),
                                    ),
                                ),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                                color: Color(0xFF24988D),
                              ),
                            ),
                            Padding(padding: EdgeInsets.only(left: 14),),
                            Expanded(
                              child:
                              RaisedButton(
                                onPressed: (){
                                  processPayment.paymentInitialized && (processPayment.applePayEnabled || processPayment.googlePayEnabled) ? 
                                  (Theme.of(context).platform == TargetPlatform.iOS) ? processPayment.onStartApplePay() : processPayment.onStartGooglePay() : null;
                                },
                                child: SizedBox(
                                  height: 64,
                                    child:
                                      Image(
                                          image: (Theme.of(context).platform == TargetPlatform.iOS) ? AssetImage("assets/applePayLogo.png") : AssetImage("assets/googlePayLogo.png")
                                          // AssetImage("assets/applePay.png"),
                                        ),
                                ),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                                color: Colors.black,
                              ),
                            ),
                            Padding(padding: EdgeInsets.only(right: 30),)
                          ]),
                      ]),
                    ),
                  ]),
                ),
            // ),
          ]),
      ),
    );
}