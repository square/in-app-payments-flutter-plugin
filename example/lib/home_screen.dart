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

import 'buy_screen.dart';
import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
   title: 'Super Cookie',
   home: HomeScreen(),
 ));

class HomeScreen extends StatefulWidget {
  _HomeScreen createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {

  @override
  void initState() {
    super.initState();
    
  }

  Widget build(BuildContext context) => 
    MaterialApp(
      theme: ThemeData(
        canvasColor: Color(0xFF78CCC5)
      ),
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                child: Image(image: AssetImage("assets/iconCookie.png")),
              ),
              Container(
                height: 50,
                child:
                  Text(
                    'Super Cookie',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                    ),
                  ),
              ),
              Container(
                height: 70,
                child:
                  Text(
                    "Instantly gain special powers \nwhen ordering a super cookie",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                ),
              ),
              Container(
                height: 64,
                width: 170,
                child:
                  RaisedButton(
                    child: 
                      Text(
                        "Buy",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18
                        )
                      ),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                      color: Color(0xFF24988D),
                      onPressed: (){
                        Navigator.of(context).push(PageRouteBuilder(
                            opaque: false,
                            pageBuilder: (context, _, __) {
                                return BuyScreen();
                            }
                        ));
                      },
                  ),
              ),
            ],
          ),
        ),
      ),
    );
}