import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rotosocket/textformfieldnum.dart';

import 'ws_manage.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

Widget getStepperMotorButtons(int i, bool active) {
  return TextButton(
    child: SizedBox(
      width: 80,
      child: Row(
        children: <Widget>[
          Hero(
              tag: 'hero $i',
              child: active
                  ? const Icon(Icons.autorenew, color: Colors.red)
                  : const Icon(Icons.autorenew, color: Colors.green)),
          Text('M ${i + 1}'),
        ],
      ),
    ),
    onPressed: () {
      Navigator.pushNamed(_scaffoldKey.currentContext, '/StepperMotorPage',
          arguments: i);
    },
  );
}

dynamic stepperMotorButtons;

class MotorST extends StatelessWidget {
  const MotorST({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    stepperMotorButtons = List.generate(WebSocketClass.stepperMotorStateSize,
        (i) => getStepperMotorButtons(i, false));

    return Consumer<WebSocketClass>(builder: (_, user, __) {
      return Scaffold(
          key: _scaffoldKey,
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            title: const Text('Stepper Motors'),
          ),
          body: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              padding: const EdgeInsets.only(top: 20),
              child: Wrap(
                children: stepperMotorButtons,
              )));
    });
  }
}

class SettingState {
  int stepResolution = 1;
  bool isFullLoad = false;
  String get load => isFullLoad ? '100' : '50';
  int startStopSpeed = 1000;
  int startStopAcc = 400;

  int constSpeedSpeed = 1000;
  int constSpeedSteps = 800;

  int constAccLimitSpeed = 1000;
  int constAccSteps = 800;
  int constAccAcc = 400;
}

void setMotorStateActive(WebSocketClass user, int index, bool active) {
  stepperMotorButtons[index] = getStepperMotorButtons(index, active);
  user.setStepperMotorState(index, active);
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////
class StartStopForm extends StatefulWidget {
  final int index;
  final WebSocketClass user;
  final SettingState st;
  const StartStopForm({
    Key exekey,
    @required this.index,
    @required this.user,
    @required this.st,
  }) : super(key: exekey);

  @override
  StartStopFormState createState() {
    return StartStopFormState();
  }
}

class StartStopFormState extends State<StartStopForm> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextFormFieldNum(
            labelTextNum: 'Speed [steps/s]:',
            min: 80,
            max: 8000,
            initialNum: widget.st.startStopSpeed,
            onSavedCallback: (int value) => widget.st.startStopSpeed = value,
          ),
          TextFormFieldNum(
            labelTextNum: 'Acceleration [steps/s²]:',
            min: 0,
            max: 2097151,
            initialNum: widget.st.startStopAcc,
            onSavedCallback: (int value) => widget.st.startStopAcc = value,
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            child: const Text('Run Clockwise'),
            onPressed: () {
              // Validate returns true if the form is valid, or false otherwise.
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
                setMotorStateActive(widget.user, widget.index, true);
                // CMD_SetStepperMotorSpeed@Main(id,mode,speed,maxacceleration,load)
                widget.user.send(
                    'CMD_SetStepperMotorSpeed@Main(${widget.index},${widget.st.stepResolution},${widget.st.startStopSpeed},${widget.st.startStopAcc},${widget.st.load})');
              }
            },
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            child: const Text('Run Counterclockwise'),
            onPressed: () {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
                setMotorStateActive(widget.user, widget.index, true);
                // CMD_SetStepperMotorSpeed@Main(id,mode,speed,maxacceleration,load)
                widget.user.send(
                    'CMD_SetStepperMotorSpeed@Main(${widget.index},${widget.st.stepResolution},-${widget.st.startStopSpeed},${widget.st.startStopAcc},${widget.st.load})');
              }
            },
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            child: const Text('Stop'),
            onPressed: () {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
                // CMD_SetStepperMotorSpeed@Main(id,mode,speed,maxacceleration,load)
                widget.user.send(
                    'CMD_SetStepperMotorSpeed@Main(${widget.index},${widget.st.stepResolution},0,${widget.st.startStopAcc},${widget.st.load})');
              }
            },
          ),
        ],
      ),
    );
  }
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////
class ConstantSpeedForm extends StatefulWidget {
  final int index;
  final WebSocketClass user;
  final SettingState st;
  const ConstantSpeedForm({
    Key exekey,
    @required this.index,
    @required this.user,
    @required this.st,
  }) : super(key: exekey);

  @override
  ConstantSpeedFormState createState() {
    return ConstantSpeedFormState();
  }
}

class ConstantSpeedFormState extends State<ConstantSpeedForm> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextFormFieldNum(
            labelTextNum: 'Steps to travel:',
            min: 0,
            max: 4294967295,
            initialNum: widget.st.constSpeedSteps,
            onSavedCallback: (int value) => widget.st.constSpeedSteps = value,
          ),
          TextFormFieldNum(
            labelTextNum: 'Speed [steps/s]:',
            min: 80,
            max: 8000,
            initialNum: widget.st.constSpeedSpeed,
            onSavedCallback: (int value) => widget.st.constSpeedSpeed = value,
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            child: const Text('Run Clockwise'),
            onPressed: () {
              // Validate returns true if the form is valid, or false otherwise.
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
                setMotorStateActive(widget.user, widget.index, true);
                // CMD_SetStepperMotorCountSteps@Main(id,mode,speed,maxacceleration,load,steps)
                widget.user.send(
                    'CMD_SetStepperMotorCountSteps@Main(${widget.index},${widget.st.stepResolution},${widget.st.constSpeedSpeed},0,${widget.st.load},${widget.st.constSpeedSteps})');
              }
            },
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            child: const Text('Run Counterclockwise'),
            onPressed: () {
              if (_formKey.currentState.validate()) {
                setMotorStateActive(widget.user, widget.index, true);
                _formKey.currentState.save();
                // CMD_SetStepperMotorCountSteps@Main(id,mode,speed,maxacceleration,load,steps)
                widget.user.send(
                    'CMD_SetStepperMotorCountSteps@Main(${widget.index},${widget.st.stepResolution},-${widget.st.constSpeedSpeed},0,${widget.st.load},${widget.st.constSpeedSteps})');
              }
            },
          ),
        ],
      ),
    );
  }
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////
class ConstantAccForm extends StatefulWidget {
  final int index;
  final WebSocketClass user;
  final SettingState st;
  const ConstantAccForm({
    Key exekey,
    @required this.index,
    @required this.user,
    @required this.st,
  }) : super(key: exekey);

  @override
  ConstantAccFormState createState() {
    return ConstantAccFormState();
  }
}

class ConstantAccFormState extends State<ConstantAccForm> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextFormFieldNum(
            labelTextNum: 'Steps to travel:',
            min: 0,
            max: 4294967295,
            initialNum: widget.st.constAccSteps,
            onSavedCallback: (int value) => widget.st.constAccSteps = value,
          ),
          TextFormFieldNum(
            labelTextNum: 'Max Acceleration [steps/s²]:',
            min: 0,
            max: 2097151,
            initialNum: widget.st.constAccAcc,
            onSavedCallback: (int value) => widget.st.constAccAcc = value,
          ),
          TextFormFieldNum(
            labelTextNum: 'Limit speed to [steps/s]:',
            min: 80,
            max: 8000,
            initialNum: widget.st.constAccLimitSpeed,
            onSavedCallback: (int value) =>
                widget.st.constAccLimitSpeed = value,
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            child: const Text('Run Clockwise'),
            onPressed: () {
              // Validate returns true if the form is valid, or false otherwise.
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
                setMotorStateActive(widget.user, widget.index, true);
                // CMD_SetStepperMotorCountSteps@Main(id,mode,speed,maxacceleration,load,steps)
                widget.user.send(
                    'CMD_SetStepperMotorCountSteps@Main(${widget.index},${widget.st.stepResolution},${widget.st.constAccLimitSpeed},${widget.st.constAccAcc},${widget.st.load},${widget.st.constAccSteps})');
              }
            },
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            child: const Text('Run Counterclockwise'),
            onPressed: () {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
                setMotorStateActive(widget.user, widget.index, true);
                // CMD_SetStepperMotorCountSteps@Main(id,mode,speed,maxacceleration,load,steps)
                widget.user.send(
                    'CMD_SetStepperMotorCountSteps@Main(${widget.index},${widget.st.stepResolution},-${widget.st.constAccLimitSpeed},${widget.st.constAccAcc},${widget.st.load},${widget.st.constAccSteps})');
              }
            },
          ),
        ],
      ),
    );
  }
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

class MotorStPage extends StatefulWidget {
  const MotorStPage({Key key}) : super(key: key);

  @override
  _MotorStPageState createState() => _MotorStPageState();
}

class _MotorStPageState extends State<MotorStPage> {
  var st = SettingState();
  String title = "Start-Stop";
  int currentIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      currentIndex = index;
      switch (index) {
        case 0:
          title = "Start-Stop";
          break;
        case 1:
          title = "Speed";
          break;
        case 2:
          title = "Acceleration";
          break;
        default:
          title = "Configuration";
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final index = ModalRoute.of(context).settings.arguments as int;

    return Consumer<WebSocketClass>(builder: (_, user, __) {
      return Scaffold(
        appBar: AppBar(
          title: Text(' Stepper Motor ${index + 1}:  $title'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(10.0),
          scrollDirection: Axis.vertical,
          child: Column(children: <Widget>[
            Hero(
                tag: 'hero $index',
                child: user.getStepperMotorState(index)
                    ? const Icon(Icons.autorenew, color: Colors.red, size: 100)
                    : const Icon(Icons.autorenew,
                        color: Colors.green, size: 100)),
            SizedBox(
                width: 350.0,
                child:
/////////////////////////////////////////////////////////////////////////////////////////////////////////////
                    currentIndex == 0
                        ? StartStopForm(
                            index: index,
                            user: user,
                            st: st,
                          )
                        : currentIndex == 1
                            ? ConstantSpeedForm(
                                index: index,
                                user: user,
                                st: st,
                              )
                            : currentIndex == 2
                                ? ConstantAccForm(
                                    index: index,
                                    user: user,
                                    st: st,
                                  )
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                        const Text('Driver microstepping:'),
                                        ListTile(
                                            title: const Text('Full step'),
                                            leading: Radio<int>(
                                                value: st.stepResolution,
                                                groupValue: 1,
                                                onChanged: (int value) {
                                                  setState(() =>
                                                      st.stepResolution = 1);
                                                })),
                                        ListTile(
                                            title: const Text('Half step'),
                                            leading: Radio<int>(
                                                value: st.stepResolution,
                                                groupValue: 2,
                                                onChanged: (int value) {
                                                  setState(() =>
                                                      st.stepResolution = 2);
                                                })),
                                        ListTile(
                                            title: const Text('1/8 step'),
                                            leading: Radio<int>(
                                                value: st.stepResolution,
                                                groupValue: 8,
                                                onChanged: (int value) {
                                                  setState(() =>
                                                      st.stepResolution = 8);
                                                })),
                                        ListTile(
                                            title: const Text('1/16 step'),
                                            leading: Radio<int>(
                                                value: st.stepResolution,
                                                groupValue: 16,
                                                onChanged: (int value) {
                                                  setState(() =>
                                                      st.stepResolution = 16);
                                                })),
                                        const Text('Driver current:'),
                                        CheckboxListTile(
                                            title: const Text("Full power"),
                                            value: st.isFullLoad,
                                            onChanged: (bool value) {
                                              // This is where we update the state when the checkbox is tapped
                                              setState(
                                                  () => st.isFullLoad = value);
                                            }),
                                      ]))
          ]),
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.repeat_outlined),
              label: ('Start-Stop'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.trending_flat),
              label: ('Constant Speed'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.trending_up),
              label: ('Constant Acc'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.tune),
              label: ('Configuration'),
            )
          ],
          currentIndex: currentIndex,
          onTap: _onItemTapped,
        ),
      );
    });
  }
}
