import 'package:flutter/material.dart';
import 'package:provaProvider/ws_manage.dart';
import 'package:provider/provider.dart';

class Setting extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<WebSocketClass>(builder: (_, user, __) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Settings'),
        ),
        body: Row(
          children: <Widget>[
            Column(
              children: <Widget>[
                FlatButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/Network');
                  },
                  color: Colors.indigo[50],
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('Network Options',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold))
                    ],
                  ),
                ),
                FlatButton(
                  color: Colors.indigo[50],
                  onPressed: () {
                    Navigator.pushNamed(context, '/Restart');
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('Restart Options',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold))
                    ],
                  ),
                ),
                FlatButton(
                  color: Colors.indigo[50],
                  onPressed: () {
                    Navigator.pushNamed(context, '/HWController');
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('Parameter Options',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold))
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      );
    });
  }
}


class NwOptions extends StatelessWidget {

  int counter = 0;
  int counter2 = 0;
  TextEditingController controller11 =  new TextEditingController(); 
  TextEditingController controller12 =  new TextEditingController(); 
  TextEditingController controller13 =  new TextEditingController(); 
  TextEditingController controller14 =  new TextEditingController(); 

  TextEditingController controller21 =  new TextEditingController(); 
  TextEditingController controller22 =  new TextEditingController(); 
  TextEditingController controller23 =  new TextEditingController(); 
  TextEditingController controller24 =  new TextEditingController(); 

  TextEditingController controller31 =  new TextEditingController(); 
  TextEditingController controller32 =  new TextEditingController(); 
  TextEditingController controller33 =  new TextEditingController(); 
  TextEditingController controller34 =  new TextEditingController(); 


  bool value = false;

  FocusNode textSecondFocusNode = new FocusNode();
  FocusNode textThirdFocusNode = new FocusNode();
  FocusNode textFourthFocusNode = new FocusNode();
  
  FocusNode textSecondFocusNode2 = new FocusNode();
  FocusNode textThirdFocusNode2 = new FocusNode();
  FocusNode textFourthFocusNode2 = new FocusNode();
  
  FocusNode textSecondFocusNode3 = new FocusNode();
  FocusNode textThirdFocusNode3 = new FocusNode();
  FocusNode textFourthFocusNode3 = new FocusNode();

  @override

  
  Widget build(BuildContext context) {
  return Consumer<WebSocketClass>(builder: (_, user, __) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Network Options')
      ),
      body: Container(
        padding: const EdgeInsets.fromLTRB(15, 0, 0, 15),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                  child: Text(
                    'IP Address: ',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Container(
                    width: 300,
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: 50,
                          child: TextFormField(
                             onChanged: (String value) {
                               if(value.length==3){
                              FocusScope.of(context).requestFocus(textSecondFocusNode);}
                            },
                            onFieldSubmitted: (String value) {
                              FocusScope.of(context).requestFocus(textSecondFocusNode);
                            },
                            maxLength: 3,
                            controller: controller11,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.red[100],
                              counterText: "",
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  width: 1,
                                  color: Colors.red
                                )
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  width: 1,
                                  color: Colors.red
                                )
                              )
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('.'),
                        ),
                        Container(
                          width: 50,
                          child: TextFormField(
                            
                            focusNode: textSecondFocusNode,
                             onChanged: (String value) {
                               if(value.length==3){
                              FocusScope.of(context).requestFocus(textThirdFocusNode);}
                            },
                            onFieldSubmitted: (String value) {
                              FocusScope.of(context).requestFocus(textThirdFocusNode);
                            },
                            maxLength: 3,
                            controller: controller12,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.red[100],
                              counterText: "",
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  width: 1,
                                  color: Colors.red
                                )
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  width: 1,
                                  color: Colors.red
                                )
                              )
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('.'),
                        ),
                        Container(
                          width: 50,
                          child: TextFormField(
                            focusNode: textThirdFocusNode,
                             onChanged: (String value) {
                               if(value.length==3){
                              FocusScope.of(context).requestFocus(textFourthFocusNode);}
                            },
                            onFieldSubmitted: (String value) {
                              FocusScope.of(context).requestFocus(textFourthFocusNode);
                            },
                            maxLength: 3,
                            controller: controller13,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.red[100],
                              counterText: "",
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  width: 1,
                                  color: Colors.red
                                )
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  width: 1,
                                  color: Colors.red
                                )
                              )
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('.'),
                        ),
                        Container(
                          width: 50,
                          child: TextFormField(
                            focusNode: textFourthFocusNode,
                            maxLength: 3,
                            controller: controller14,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.red[100],
                              counterText: "",
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  width: 1,
                                  color: Colors.red
                                )
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  width: 1,
                                  color: Colors.red
                                )
                              )
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),             
              ],
            ),
                  
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 0, 0, 15),
                  child: Text(
                    'Subnet Mask: ',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 0, 20),
                  child: Container(
                    width: 300,
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: 50,
                          child: TextFormField(
                             onChanged: (String value) {
                               if(value.length==3){
                              FocusScope.of(context).requestFocus(textSecondFocusNode3);}
                            },
                            onFieldSubmitted: (String value) {
                              FocusScope.of(context).requestFocus(textSecondFocusNode3);
                            },
                            maxLength: 3,
                            controller: controller31,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.red[100],
                              counterText: "",
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  width: 1,
                                  color: Colors.red
                                )
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  width: 1,
                                  color: Colors.red
                                )
                              )
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('.'),
                        ),
                        Container(
                          width: 50,
                          child: TextFormField(
                            
                            focusNode: textSecondFocusNode3,
                             onChanged: (String value) {
                               if(value.length==3){
                              FocusScope.of(context).requestFocus(textThirdFocusNode3);}
                            },
                            onFieldSubmitted: (String value) {
                              FocusScope.of(context).requestFocus(textThirdFocusNode3);
                            },
                            maxLength: 3,
                            controller: controller32,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.red[100],
                              counterText: "",
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  width: 1,
                                  color: Colors.red
                                )
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  width: 1,
                                  color: Colors.red
                                )
                              )
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('.'),
                        ),
                        Container(
                          width: 50,
                          child: TextFormField(
                            focusNode: textThirdFocusNode3,
                             onChanged: (String value) {
                               if(value.length==3){
                              FocusScope.of(context).requestFocus(textFourthFocusNode3);}
                            },
                            onFieldSubmitted: (String value) {
                              FocusScope.of(context).requestFocus(textFourthFocusNode3);
                            },
                            maxLength: 3,
                            controller: controller33,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.red[100],
                              counterText: "",
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  width: 1,
                                  color: Colors.red
                                )
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  width: 1,
                                  color: Colors.red
                                )
                              )
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('.'),
                        ),
                        Container(
                          width: 50,
                          child: TextFormField(
                            focusNode: textFourthFocusNode3,
                            maxLength: 3,
                            controller: controller34,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.red[100],
                              counterText: "",
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  width: 1,
                                  color: Colors.red
                                )
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  width: 1,
                                  color: Colors.red
                                )
                              )
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),   
              ],
            ),
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 0, 0, 15),
                  child: Text(
                    'Def Gateway: ',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 0, 20),
                  child: Container(
                    width: 300,
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: 50,
                          child: TextFormField(
                             onChanged: (String value) {
                               if(value.length==3){
                              FocusScope.of(context).requestFocus(textSecondFocusNode2);}
                            },
                            onFieldSubmitted: (String value) {
                              FocusScope.of(context).requestFocus(textSecondFocusNode2);
                            },
                            maxLength: 3,
                            controller: controller21,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.red[100],
                              counterText: "",
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  width: 1,
                                  color: Colors.red
                                )
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  width: 1,
                                  color: Colors.red
                                )
                              )
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('.'),
                        ),
                        Container(
                          width: 50,
                          child: TextFormField(
                            
                            focusNode: textSecondFocusNode2,
                             onChanged: (String value) {
                               if(value.length==3){
                              FocusScope.of(context).requestFocus(textThirdFocusNode2);}
                            },
                            onFieldSubmitted: (String value) {
                              FocusScope.of(context).requestFocus(textThirdFocusNode2);
                            },
                            maxLength: 3,
                            controller: controller22,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.red[100],
                              counterText: "",
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  width: 1,
                                  color: Colors.red
                                )
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  width: 1,
                                  color: Colors.red
                                )
                              )
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('.'),
                        ),
                        Container(
                          width: 50,
                          child: TextFormField(
                            focusNode: textThirdFocusNode2,
                             onChanged: (String value) {
                               if(value.length==3){
                              FocusScope.of(context).requestFocus(textFourthFocusNode2);}
                            },
                            onFieldSubmitted: (String value) {
                              FocusScope.of(context).requestFocus(textFourthFocusNode2);
                            },
                            maxLength: 3,
                            controller: controller23,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.red[100],
                              counterText: "",
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  width: 1,
                                  color: Colors.red
                                )
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  width: 1,
                                  color: Colors.red
                                )
                              )
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('.'),
                        ),
                        Container(
                          width: 50,
                          child: TextFormField(
                            focusNode: textFourthFocusNode2,
                            maxLength: 3,
                            controller: controller24,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.red[100],
                              counterText: "",
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  width: 1,
                                  color: Colors.red
                                )
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  width: 1,
                                  color: Colors.red
                                )
                              )
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),   
              ],
            ),
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text('DHCP: ',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold
                      ),
                  )
                ),
                Checkbox(
                  value: value,
                  onChanged: (newValue) {
                    value = newValue;
                  },
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20,0,0,0),
              child: Row(
                children: <Widget>[
                  RaisedButton(
                    onPressed: (){
                      String ip = controller11.text+"."+controller12.text+"."+controller13.text+"."+controller14.text;
                      String dg = controller21.text+"."+controller22.text+"."+controller23.text+"."+controller24.text;
                      user.send('CMD_UpdateNetworkConfiguration@Main'
                      +'{ "IpAddress" : "$ip", "DefaultGateway" : "$dg", "DHCP" : "$value" }');
                      print('CMD_UpdateNetworkConfiguration@Main'
                      +'{ "IpAddress" : "$ip", "DefaultGateway" : "$dg", "DHCP" : "$value" }');
                    },
                    child: Text('Update Network Settings',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                    )
                  )
                ],
              ),
            ),
          ],
        ),
      )
    );
  });
  }
}

class RestartOptions extends StatelessWidget {
  
  TextEditingController controller =  new TextEditingController(); 
  TextEditingController controller2 = new TextEditingController(); 

  bool value = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<WebSocketClass>(builder: (_, user, __) {
      return Scaffold(
      appBar: AppBar(
        title: Text('Restart Options')
      ),
      body: Column(
        children: <Widget>[
          RaisedButton(
            child: Text('Restart MC'),
            onPressed: (){
              user.send('CMD_Restart@HWController#');
            },
          ),
          RaisedButton(
            child: Text('Restart FPGA'),
            onPressed: (){
              user.send('CMD_Restart@FPGA#');
            },
          ),
          RaisedButton(
            child: Text('Restart HWController'),
            onPressed: (){
              user.send('CMD_Restart@HWController#');
            },
          ),
        ],
      )
    );
    });
  }
}

class HwcOptions extends StatelessWidget {
  const HwcOptions({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hardware Controller'),
      ),
    );
  }
}