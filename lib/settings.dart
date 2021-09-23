import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'ws_manage.dart';
import 'package:provider/provider.dart';

class Setting extends StatelessWidget {
  const Setting({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<WebSocketClass>(builder: (_, user, __) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Options'),
        ),
        body: ListView(
          padding: const EdgeInsets.all(50),
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/Network');
              },
              child: const Text('Network Options'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/Restart');
              },
              child: const Text('Restart Options'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/ParameterOption');
              },
              child: const Text('Parameter Options'),
            ),
          ],
        ),
      );
    });
  }
}

class NwOptions extends StatefulWidget {
  const NwOptions({Key key}) : super(key: key);

  @override
  _NwOptionsState createState() => _NwOptionsState();
}

class _NwOptionsState extends State<NwOptions> {
  int counter = 0;

  int counter2 = 0;

  TextEditingController controller11 = TextEditingController();

  TextEditingController controller12 = TextEditingController();

  TextEditingController controller13 = TextEditingController();

  TextEditingController controller14 = TextEditingController();

  TextEditingController controller21 = TextEditingController();

  TextEditingController controller22 = TextEditingController();

  TextEditingController controller23 = TextEditingController();

  TextEditingController controller24 = TextEditingController();

  TextEditingController controller31 = TextEditingController();

  TextEditingController controller32 = TextEditingController();

  TextEditingController controller33 = TextEditingController();

  TextEditingController controller34 = TextEditingController();

  bool value = false;

  FocusNode textSecondFocusNode = FocusNode();

  FocusNode textThirdFocusNode = FocusNode();

  FocusNode textFourthFocusNode = FocusNode();

  FocusNode textFirstFocusNode2 = FocusNode();

  FocusNode textSecondFocusNode2 = FocusNode();

  FocusNode textThirdFocusNode2 = FocusNode();

  FocusNode textFourthFocusNode2 = FocusNode();

  FocusNode textFirstFocusNode3 = FocusNode();

  FocusNode textSecondFocusNode3 = FocusNode();

  FocusNode textThirdFocusNode3 = FocusNode();

  FocusNode textFourthFocusNode3 = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Consumer<WebSocketClass>(builder: (_, user, __) {
      return Scaffold(
          appBar: AppBar(title: const Text('Network Options')),
          body: Container(
            padding: const EdgeInsets.all(15),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        const Padding(
                          padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                          child: SizedBox(
                            width: 150,
                            child: Text(
                              'IP Address: ',
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 20, 0, 20),
                          child: SizedBox(
                            width: 300,
                            child: Row(
                              children: <Widget>[
                                SizedBox(
                                  width: 60,
                                  child: TextFormField(
                                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9]'))],
                                    // Only numbers can be entered
                                    textAlign: TextAlign.center,
                                    onChanged: (String value) {
                                      if (value.length == 3) {
                                        if (int.parse(value) > 255) {
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
                                        enabledBorder: const OutlineInputBorder(borderSide: BorderSide(width: 1, color: Colors.red)),
                                        focusedBorder: const OutlineInputBorder(borderSide: BorderSide(width: 1, color: Colors.red))),
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('.'),
                                ),
                                SizedBox(
                                  width: 60,
                                  child: TextFormField(
                                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9]'))],
                                    keyboardType: TextInputType.number,
                                    textAlign: TextAlign.center,
                                    focusNode: textSecondFocusNode,
                                    onChanged: (String value) {
                                      if (value.length == 3) {
                                        if (int.parse(value) > 255) {
                                          controller12.text = "255";
                                        }
                                        FocusScope.of(context).requestFocus(textThirdFocusNode);
                                      }
                                    },
                                    maxLength: 3,
                                    controller: controller12,
                                    decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.red[100],
                                        counterText: "",
                                        enabledBorder: const OutlineInputBorder(borderSide: BorderSide(width: 1, color: Colors.red)),
                                        focusedBorder: const OutlineInputBorder(borderSide: BorderSide(width: 1, color: Colors.red))),
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('.'),
                                ),
                                SizedBox(
                                  width: 60,
                                  child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    textAlign: TextAlign.center,
                                    focusNode: textThirdFocusNode,
                                    onChanged: (String value) {
                                      if (value.length == 3) {
                                        if (int.parse(value) > 255) {
                                          controller13.text = "255";
                                        }
                                        FocusScope.of(context).requestFocus(textFourthFocusNode);
                                      }
                                    },
                                    maxLength: 3,
                                    controller: controller13,
                                    decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.red[100],
                                        counterText: "",
                                        enabledBorder: const OutlineInputBorder(borderSide: BorderSide(width: 1, color: Colors.red)),
                                        focusedBorder: const OutlineInputBorder(borderSide: BorderSide(width: 1, color: Colors.red))),
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('.'),
                                ),
                                SizedBox(
                                  width: 60,
                                  child: TextFormField(
                                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9]'))],
                                    keyboardType: TextInputType.number,
                                    textAlign: TextAlign.center,
                                    onChanged: (String value) {
                                      if (value.length == 3) {
                                        if (int.parse(value) > 255) {
                                          controller14.text = "255";
                                        }
                                        FocusScope.of(context).requestFocus(textFirstFocusNode2);
                                      }
                                    },
                                    focusNode: textFourthFocusNode,
                                    maxLength: 3,
                                    controller: controller14,
                                    decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.red[100],
                                        counterText: "",
                                        enabledBorder: const OutlineInputBorder(borderSide: BorderSide(width: 1, color: Colors.red)),
                                        focusedBorder: const OutlineInputBorder(borderSide: BorderSide(width: 1, color: Colors.red))),
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
                        const Padding(
                          padding: EdgeInsets.fromLTRB(15, 0, 0, 15),
                          child: SizedBox(
                            width: 150,
                            child: Text(
                              'Subnet Mask: ',
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 0, 20),
                          child: SizedBox(
                            width: 300,
                            child: Row(
                              children: <Widget>[
                                SizedBox(
                                  width: 60,
                                  child: TextFormField(
                                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9]'))],
                                    keyboardType: TextInputType.number,
                                    textAlign: TextAlign.center,
                                    onChanged: (String value) {
                                      if (value.length == 3) {
                                        if (int.parse(value) > 255) {
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
                                        enabledBorder: const OutlineInputBorder(borderSide: BorderSide(width: 1, color: Colors.red)),
                                        focusedBorder: const OutlineInputBorder(borderSide: BorderSide(width: 1, color: Colors.red))),
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('.'),
                                ),
                                SizedBox(
                                  width: 60,
                                  child: TextFormField(
                                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9]'))],
                                    keyboardType: TextInputType.number,
                                    textAlign: TextAlign.center,
                                    focusNode: textSecondFocusNode3,
                                    onChanged: (String value) {
                                      if (value.length == 3) {
                                        if (int.parse(value) > 255) {
                                          controller32.text = "255";
                                        }
                                        FocusScope.of(context).requestFocus(textThirdFocusNode3);
                                      }
                                    },
                                    maxLength: 3,
                                    controller: controller32,
                                    decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.red[100],
                                        counterText: "",
                                        enabledBorder: const OutlineInputBorder(borderSide: BorderSide(width: 1, color: Colors.red)),
                                        focusedBorder: const OutlineInputBorder(borderSide: BorderSide(width: 1, color: Colors.red))),
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('.'),
                                ),
                                SizedBox(
                                  width: 60,
                                  child: TextFormField(
                                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9]'))],
                                    keyboardType: TextInputType.number,
                                    textAlign: TextAlign.center,
                                    focusNode: textThirdFocusNode3,
                                    onChanged: (String value) {
                                      if (value.length == 3) {
                                        if (int.parse(value) > 255) {
                                          controller33.text = "255";
                                        }
                                        FocusScope.of(context).requestFocus(textFourthFocusNode3);
                                      }
                                    },
                                    maxLength: 3,
                                    controller: controller33,
                                    decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.red[100],
                                        counterText: "",
                                        enabledBorder: const OutlineInputBorder(borderSide: BorderSide(width: 1, color: Colors.red)),
                                        focusedBorder: const OutlineInputBorder(borderSide: BorderSide(width: 1, color: Colors.red))),
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('.'),
                                ),
                                SizedBox(
                                  width: 60,
                                  child: TextField(
                                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9]'))],
                                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                    textAlign: TextAlign.center,
                                    onChanged: (String value) {
                                      if (value.length == 3) {
                                        if (int.parse(value) > 255) {
                                          controller34.text = "255";
                                        }
                                        FocusScope.of(context).requestFocus(textFirstFocusNode3);
                                      }
                                    },
                                    focusNode: textFourthFocusNode3,
                                    maxLength: 3,
                                    controller: controller34,
                                    decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.red[100],
                                        counterText: "",
                                        enabledBorder: const OutlineInputBorder(borderSide: BorderSide(width: 1, color: Colors.red)),
                                        focusedBorder: const OutlineInputBorder(borderSide: BorderSide(width: 1, color: Colors.red))),
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
                        const Padding(
                          padding: EdgeInsets.fromLTRB(15, 0, 0, 15),
                          child: SizedBox(
                            width: 150,
                            child: Text(
                              'Default Gateway: ',
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 0, 20),
                          child: SizedBox(
                            width: 300,
                            child: Row(
                              children: <Widget>[
                                SizedBox(
                                  width: 60,
                                  child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9]'))],
                                    textAlign: TextAlign.center,
                                    onChanged: (String value) {
                                      if (value.length == 3) {
                                        if (int.parse(value) > 255) {
                                          controller21.text = "255";
                                        }
                                        FocusScope.of(context).requestFocus(textSecondFocusNode2);
                                      }
                                    },
                                    focusNode: textFirstFocusNode3,
                                    maxLength: 3,
                                    controller: controller21,
                                    decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.red[100],
                                        counterText: "",
                                        enabledBorder: const OutlineInputBorder(borderSide: BorderSide(width: 1, color: Colors.red)),
                                        focusedBorder: const OutlineInputBorder(borderSide: BorderSide(width: 1, color: Colors.red))),
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('.'),
                                ),
                                SizedBox(
                                  width: 60,
                                  child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9]'))],
                                    textAlign: TextAlign.center,
                                    focusNode: textSecondFocusNode2,
                                    onChanged: (String value) {
                                      if (value.length == 3) {
                                        if (int.parse(value) > 255) {
                                          controller22.text = "255";
                                        }
                                        FocusScope.of(context).requestFocus(textThirdFocusNode2);
                                      }
                                    },
                                    maxLength: 3,
                                    controller: controller22,
                                    decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.red[100],
                                        counterText: "",
                                        enabledBorder: const OutlineInputBorder(borderSide: BorderSide(width: 1, color: Colors.red)),
                                        focusedBorder: const OutlineInputBorder(borderSide: BorderSide(width: 1, color: Colors.red))),
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('.'),
                                ),
                                SizedBox(
                                  width: 60,
                                  child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9]'))],
                                    textAlign: TextAlign.center,
                                    focusNode: textThirdFocusNode2,
                                    onChanged: (String value) {
                                      if (value.length == 3) {
                                        if (int.parse(value) > 255) {
                                          controller23.text = "255";
                                        }
                                        FocusScope.of(context).requestFocus(textFourthFocusNode2);
                                      }
                                    },
                                    maxLength: 3,
                                    controller: controller23,
                                    decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.red[100],
                                        counterText: "",
                                        enabledBorder: const OutlineInputBorder(borderSide: BorderSide(width: 1, color: Colors.red)),
                                        focusedBorder: const OutlineInputBorder(borderSide: BorderSide(width: 1, color: Colors.red))),
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('.'),
                                ),
                                SizedBox(
                                  width: 60,
                                  child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9]'))],
                                    textAlign: TextAlign.center,
                                    focusNode: textFourthFocusNode2,
                                    maxLength: 3,
                                    controller: controller24,
                                    onChanged: (String value) {
                                      if (value.length == 3) {
                                        if (int.parse(value) > 255) {
                                          controller24.text = "255";
                                        }
                                      }
                                    },
                                    decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.red[100],
                                        counterText: "",
                                        enabledBorder: const OutlineInputBorder(borderSide: BorderSide(width: 1, color: Colors.red)),
                                        focusedBorder: const OutlineInputBorder(borderSide: BorderSide(width: 1, color: Colors.red))),
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
                        const Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Text(
                              'DHCP: ',
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                            )),
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
                      padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                      child: Row(
                        children: <Widget>[
                          ElevatedButton(
                              onPressed: () {
                                String ip = controller11.text + "." + controller12.text + "." + controller13.text + "." + controller14.text;
                                String dg = controller21.text + "." + controller22.text + "." + controller23.text + "." + controller24.text;
                                user.send('CMD_UpdateNetworkConfiguration@Main'
                                    '{ "IpAddress" : "$ip", "DefaultGateway" : "$dg", "DHCP" : "$value" }');
                                debugPrint('CMD_UpdateNetworkConfiguration@Main'
                                    '{ "IpAddress" : "$ip", "DefaultGateway" : "$dg", "DHCP" : "$value" }');
                              },
                              child: const Text(
                                'Update Network Settings',
                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                              ))
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ));
    });
  }
}

class RestartOptions extends StatelessWidget {
  final TextEditingController controller = TextEditingController();
  final TextEditingController controller2 = TextEditingController();

  final bool value = false;

  RestartOptions({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<WebSocketClass>(builder: (_, user, __) {
      return Scaffold(
          appBar: AppBar(
              title: const Text(
            'Restart Options',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          )),
          body: Center(
            child: ListView(
              padding: const EdgeInsets.all(100),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: ElevatedButton(
                    child: const Text(
                      'Restart MC',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      user.send('CMD_Restart@HWController#');
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: ElevatedButton(
                    child: const Text(
                      'Restart     HWController',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      user.send('CMD_Restart@HWController#');
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: ElevatedButton(
                    child: const Text(
                      'Restart FPGA',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      user.send('CMD_Restart@FPGA#');
                    },
                  ),
                ),
              ],
            ),
          ));
    });
  }
}

class HwcOptions extends StatelessWidget {
  const HwcOptions({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Parameter Option'),
      ),
    );
  }
}
