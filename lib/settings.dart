import 'package:flutter/material.dart';
import 'package:rotosocket/textformfieldnum.dart';
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
              child: const Text('Network Settings'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/ParameterOption');
              },
              child: const Text('Configuration'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/Firmware');
              },
              child: const Text('Firmware Update'),
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
  String ip = '192.168.1.11';
  String mask = '255.255.255.0';
  String gateway = '192.168.1.254';
  bool dhcpEnabled = false;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Consumer<WebSocketClass>(builder: (_, user, __) {
      return Scaffold(
          appBar: AppBar(title: const Text('Network Settings')),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(10.0),
            scrollDirection: Axis.vertical,
            child: SizedBox(
              width: 350,
              child: Form(
                  key: _formKey,
                  child: Column(children: <Widget>[
                    TextFormFieldIpv4(
                      initialIpv4: ip,
                      labelTextIpv4: 'Ip Address',
                      onSavedCallback: (value) => {ip = value},
                    ),
                    const SizedBox(height: 10),
                    TextFormFieldIpv4(
                      initialIpv4: mask,
                      labelTextIpv4: 'Subnet mask',
                      onSavedCallback: (value) => {mask = value},
                    ),
                    const SizedBox(height: 10),
                    TextFormFieldIpv4(
                      initialIpv4: gateway,
                      labelTextIpv4: 'Default gateway',
                      onSavedCallback: (value) => {gateway = value},
                    ),
                    const SizedBox(height: 10),
                    CheckboxListTile(
                        title: const Text("Enable DHCP client"),
                        value: dhcpEnabled,
                        onChanged: (bool value) {
                          // This is where we update the state when the checkbox is tapped
                          setState(() => dhcpEnabled = value);
                        }),
                    const SizedBox(height: 10),
                    ElevatedButton(
                        child: const Text('Update Network Settings'),
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            _formKey.currentState.save();
                            String dhcp = dhcpEnabled? 'enable' : 'disable'; // similar to shell script: if [ "$DHCP_MODE0" = "enable" ];then
                            user.send(
                                'CMD_UpdateNetworkConfiguration@Main{ "IpAddress" : "$ip", "SubnetMask" : "$mask", "DefaultGateway" : "$gateway", "DHCP" : "$dhcp" }');
                          }
                        }),
                  ])),
            ),
          ));
    });
  }
}


class HwcOptions extends StatelessWidget {
  HwcOptions({Key key}) : super(key: key);
  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<WebSocketClass>(builder: (_, user, __) {

      textController.text = user.configText;

      return Scaffold(
          appBar: AppBar(
            title: const Text('Configuration'),
          ),
          body: SingleChildScrollView(
              padding: const EdgeInsets.all(10.0),
              scrollDirection: Axis.vertical,
              child: Column(
                children: <Widget>[
                  Row(children: <Widget>[
                    ElevatedButton(
                      child: const Text('Read'),
                      onPressed: () {
                        user.send('CMD_ReadConfiguration@HWController#');
                      },
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      child: const Text('Write'),
                      onPressed: () {
                        user.send('CMD_UpdateConfiguration@HWController{${textController.text}}');
                      },
                    )
                  ]),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: textController,
                    maxLength: 1024,
                    maxLines: 16,
                    decoration: const InputDecoration(
                      hintText:
                          'Type the text that will be written as board configuration',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              )));
    });
  }
}
