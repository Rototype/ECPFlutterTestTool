import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'ws_manage.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

Widget getSolenoidButtons(int i, bool active) {
  return TextButton(
    child: SizedBox(
      width: 80,
      child: Row(
        children: <Widget>[
          Hero(
            tag: 'hero $i',
            child: active
                ? const Icon(Icons.sync_alt, color: Colors.red)
                : const Icon(Icons.sync_alt, color: Colors.green),
          ),
          Text('S ${i + 1}'),
        ],
      ),
    ),
    onPressed: () {
      Navigator.pushNamed(_scaffoldKey.currentContext, '/SolenoidPage',
          arguments: i);
    },
  );
}

dynamic solenoidButtons;

class Solenoid extends StatelessWidget {
  const Solenoid({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var wsc = Provider.of<WebSocketClass>(context, listen: false);
    solenoidButtons = List.generate(WebSocketClass.solenoidStateSize,
        (i) => getSolenoidButtons(i, wsc.getSolenoidState(i)));

    return Consumer<WebSocketClass>(builder: (_, user, __) {
      return Scaffold(
          key: _scaffoldKey,
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            title: const Text('Solenoids'),
          ),
          body: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              padding: const EdgeInsets.only(top: 20),
              child: Wrap(
                children: solenoidButtons,
              )));
    });
  }
}

class SolenoidPage extends StatefulWidget {
  const SolenoidPage({Key key}) : super(key: key);

  @override
  _SolenoidPageState createState() => _SolenoidPageState();
}

class _SolenoidPageState extends State<SolenoidPage> {
  double pwm = 33;
  double initTime = 80;
  bool isPwmChecked = false;

  @override
  Widget build(BuildContext context) {
    final index = ModalRoute.of(context).settings.arguments as int;

    return Consumer<WebSocketClass>(builder: (_, user, __) {
      return Scaffold(
          appBar: AppBar(
            title: Text(' Solenoid ${index + 1}'),
          ),
          body: SingleChildScrollView(
              padding: const EdgeInsets.all(10.0),
              scrollDirection: Axis.vertical,
              child: SizedBox(
                  width: 350.0,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Hero(
                          tag: 'hero $index',
                          child: user.getSolenoidState(index)
                              ? const Icon(Icons.sync_alt,
                                  color: Colors.red, size: 100)
                              : const Icon(Icons.sync_alt,
                                  color: Colors.green, size: 100),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            if (isPwmChecked) {
                              user.send(
                                  'CMD_SetDCSolenoidPWM@Main($index,1,${pwm.toInt()},${initTime.toInt()})');
                            } else {
                              user.send('CMD_SetDCSolenoid@Main($index,1)');
                            }
                            user.setSolenoidState(index, true);
                            solenoidButtons[index] =
                                getSolenoidButtons(index, true);
                          },
                          child: const Text('Set Solenoid ON'),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            user.send('CMD_SetDCSolenoid@Main($index,0)');
                            user.setSolenoidState(index, false);
                            solenoidButtons[index] =
                                getSolenoidButtons(index, false);
                          },
                          child: const Text('Set Solenoid OFF'),
                        ),
                        const SizedBox(height: 10),
                        CheckboxListTile(
                            title: const Text('Enable PWM:'),
                            value: isPwmChecked,
                            onChanged: (bool newValue) {
                              setState(() => isPwmChecked = newValue);
                            }),
                        Text('Duty cycle: ${pwm.round()}%'),
                        Slider(
                          label: '${pwm.round()}%',
                          value: pwm,
                          onChanged: !isPwmChecked
                              ? null
                              : (newValue) {
                                  setState(() {
                                    pwm = newValue;
                                  });
                                },
                          min: 0,
                          max: 100,
                          divisions: 100,
                        ),
                        Text('Init Time: ${initTime.round()} ms'),
                        Slider(
                          label: '${initTime.round()} ms',
                          value: initTime,
                          onChanged: !isPwmChecked
                              ? null
                              : (newValue) {
                                  setState(() {
                                    initTime = newValue;
                                  });
                                },
                          min: 0,
                          max: 2000,
                          divisions: 100,
                        ),
                      ]))));
    });
  }
}
