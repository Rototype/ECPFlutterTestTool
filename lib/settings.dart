import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
        body: Center(
          child: 
            ListView(
              padding: EdgeInsets.all(150),
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
                    Navigator.pushNamed(context, '/ParameterOption');
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
        ),
      );
    });
  }
}


class NwOptions extends StatefulWidget {

  @override
  _NwOptionsState createState() => _NwOptionsState();
}

class _NwOptionsState extends State<NwOptions> {
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

  FocusNode textFirstFocusNode2 = new FocusNode();

  FocusNode textSecondFocusNode2 = new FocusNode();

  FocusNode textThirdFocusNode2 = new FocusNode();

  FocusNode textFourthFocusNode2 = new FocusNode();

  FocusNode textFirstFocusNode3 = new FocusNode();

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
                  padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                  child: Container(
                    width: 150,
                    child: Text(
                      'IP Address: ',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 0, 20),
                  child: Container(
                    width: 300,
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: 60,
                          child: TextFormField(     
                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                            inputFormatters: <TextInputFormatter>[
                                WhitelistingTextInputFormatter.digitsOnly
                            ], // Only numbers can be entered                            
                            textAlign: TextAlign.center, 
                             onChanged: (String value) {
                              if(value.length==3){
                                if(int.parse(value)>255)
                                {
                                  controller11.text = "255";
                                }
                                FocusScope.of(context).requestFocus(textSecondFocusNode);
                              }
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
                          width: 60,
                          child: TextFormField(
                            inputFormatters: <TextInputFormatter>[
                                WhitelistingTextInputFormatter.digitsOnly
                            ],      
                            keyboardType: TextInputType.number,     
                            textAlign: TextAlign.center, 
                            
                            focusNode: textSecondFocusNode,
                             onChanged: (String value) {
                               if(value.length==3){
                                if(int.parse(value)>255)
                                {
                                  controller12.text = "255";
                                }
                              FocusScope.of(context).requestFocus(textThirdFocusNode);}
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
                          width: 60,
                          child: TextFormField(     
                            keyboardType: TextInputType.number,     
                            textAlign: TextAlign.center, 
                            focusNode: textThirdFocusNode,
                             onChanged: (String value) {
                               if(value.length==3){
                                if(int.parse(value)>255)
                                {
                                  controller13.text = "255";
                                }
                              FocusScope.of(context).requestFocus(textFourthFocusNode);}
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
                          width: 60,
                          child: TextFormField(   
                            inputFormatters: <TextInputFormatter>[
                                WhitelistingTextInputFormatter.digitsOnly
                            ],   
                            keyboardType: TextInputType.number,     
                            textAlign: TextAlign.center, 
                            onChanged: (String value) {
                               if(value.length==3){
                                if(int.parse(value)>255)
                                {
                                  controller14.text = "255";
                                }
                              FocusScope.of(context).requestFocus(textFirstFocusNode2);}
                            },
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
                  child: Container(
                    width: 150,
                    child: Text(
                      'Subnet Mask: ',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold
                      ),
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
                          width: 60,
                          child: TextFormField(  
                            inputFormatters: <TextInputFormatter>[
                                WhitelistingTextInputFormatter.digitsOnly
                            ],   
                            keyboardType: TextInputType.number,     
                            textAlign: TextAlign.center, 
                             onChanged: (String value) {
                              if(value.length==3){
                                if(int.parse(value)>255)
                                {
                                  controller31.text = "255";
                                }
                                FocusScope.of(context).requestFocus(textSecondFocusNode3);
                              }
                            },
                            focusNode: textFirstFocusNode2,
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
                          width: 60,
                          child: TextFormField(  
                            inputFormatters: <TextInputFormatter>[
                                WhitelistingTextInputFormatter.digitsOnly
                            ],   
                            keyboardType: TextInputType.number,     
                            textAlign: TextAlign.center, 
                            
                            focusNode: textSecondFocusNode3,
                             onChanged: (String value) {
                               if(value.length==3){
                                if(int.parse(value)>255)
                                {
                                  controller32.text = "255";
                                }
                              FocusScope.of(context).requestFocus(textThirdFocusNode3);}
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
                          width: 60,
                          child: TextFormField(       
                            inputFormatters: <TextInputFormatter>[
                                WhitelistingTextInputFormatter.digitsOnly
                            ],   
                            keyboardType: TextInputType.number,     
                            textAlign: TextAlign.center, 
                            focusNode: textThirdFocusNode3,
                             onChanged: (String value) {
                               if(value.length==3){
                                if(int.parse(value)>255)
                                {
                                  controller33.text = "255";
                                }
                              FocusScope.of(context).requestFocus(textFourthFocusNode3);}
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
                          width: 60,
                          child: TextField(  
                            inputFormatters: <TextInputFormatter>[
                                WhitelistingTextInputFormatter.digitsOnly
                            ],   
                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                            textAlign: TextAlign.center, 
                            onChanged: (String value) {
                               if(value.length==3){
                                if(int.parse(value)>255)
                                {
                                  controller34.text = "255";
                                }
                              FocusScope.of(context).requestFocus(textFirstFocusNode3);}
                            },
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
                  child: Container(
                    width: 150,
                    child: Text(
                      'Default Gateway: ',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold
                      ),
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
                          width: 60,
                          child: TextFormField(       
                            inputFormatters: <TextInputFormatter>[
                                WhitelistingTextInputFormatter.digitsOnly
                            ],   
                            textAlign: TextAlign.center, 
                             onChanged: (String value) {
                               if(value.length==3){
                                if(int.parse(value)>255)
                                {
                                  controller21.text = "255";
                                }
                              FocusScope.of(context).requestFocus(textSecondFocusNode2);}
                            },
                            focusNode: textFirstFocusNode3,
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
                          width: 60,
                          
                          child: TextFormField(      
                            inputFormatters: <TextInputFormatter>[
                                WhitelistingTextInputFormatter.digitsOnly
                            ],    
                            textAlign: TextAlign.center,                        
                            focusNode: textSecondFocusNode2,
                             onChanged: (String value) {
                               if(value.length==3){
                                if(int.parse(value)>255)
                                {
                                  controller22.text = "255";
                                }
                              FocusScope.of(context).requestFocus(textThirdFocusNode2);}
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
                          width: 60,
                          child: TextFormField(      
                            inputFormatters: <TextInputFormatter>[
                                WhitelistingTextInputFormatter.digitsOnly
                            ],    
                            textAlign: TextAlign.center, 
                            focusNode: textThirdFocusNode2,
                             onChanged: (String value) {
                               if(value.length==3){
                                if(int.parse(value)>255)
                                {
                                  controller23.text = "255";
                                }
                              FocusScope.of(context).requestFocus(textFourthFocusNode2);}
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
                          width: 60,
                          child: TextFormField(       
                            inputFormatters: <TextInputFormatter>[
                                WhitelistingTextInputFormatter.digitsOnly
                            ],   
                            textAlign: TextAlign.center, 
                            focusNode: textFourthFocusNode2,
                            maxLength: 3,
                            controller: controller24,
                            onChanged: (String value) {
                              if(value.length==3){
                                if(int.parse(value)>255)
                                {
                                  controller24.text = "255";
                                }
                              }
                            },
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
                    setState(() {
                            value = newValue;
                    });
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
        title: Text('Restart Options',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold
                      ),
                    )
      ),
      body: Center(
        child: ListView(
          padding: EdgeInsets.all(100),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(0,20,0,0),
              child: RaisedButton(
                color: Colors.indigo[50],
                child: Text('Restart MC',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold
                        ),),
                onPressed: (){
                  user.send('CMD_Restart@HWController#');
                },
              ),
            ),           
            Padding(
              padding: const EdgeInsets.fromLTRB(0,20,0,0),
              child: RaisedButton(
                color: Colors.indigo[50],
                child: Text('Restart HWController',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold
                        ),),
                onPressed: (){
                  user.send('CMD_Restart@HWController#');
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0,20,0,0),
              child: RaisedButton(
                color: Colors.indigo[50],
                child: Text('Restart FPGA',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold
                        ),),
                onPressed: (){
                  user.send('CMD_Restart@FPGA#');
                },
              ),
            ),
          ],
        ),
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
        title: Text('Parameter Option'),
      ),
    );
  }
}