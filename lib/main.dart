import 'package:flutter/material.dart';
import 'package:provaProvider/settings.dart';
import 'package:provider/provider.dart';
import 'analogic_input.dart';
import 'image.dart';
import 'login_page.dart';
import 'photocells.dart';
import 'ws_manage.dart';
import 'continous_motor.dart';
import 'solenoid.dart';
import 'stepper_motor.dart';
import 'digital_output.dart';

void main() => runApp(
    ChangeNotifierProvider(create: (_) => WebSocketClass(), child: MyApp()));
  TextEditingController controller = TextEditingController();

List<Color> color = [Colors.lightBlue[200]];

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: HomePage(),
      routes: {
        '/Photocells': (_) => Photocells(),
        '/PhotocellPage': (_) => PhotocellPage(),
        '/inputA': (_) => AnalogicInputs(),
        '/inputAnalogicPage': (_) => AnalogicInputPage(),
        '/StepperMotor': (_) => MotorST(),
        '/StepperMotorPage': (_) => MotorStPage(),
        '/DCMotor': (_) => DCMotor(),
        '/DCMotorPage': (_) => DCMotorPage(),
        '/Solenoids': (_) => Solenoid(),
        '/SolenoidPage': (_) => SolenoidPage(),
        '/DigitalOutputs': (_) => Output(),
        '/Image': (_) => ImagePickerPage(),
        '/Settings': (_) => Setting(),
        '/Network': (_) => NwOptions(),
        '/Restart': (_) => RestartOptions(),
        '/ParameterOption': (_) => HwcOptions(),
        '/IpConfig': (_) => IpConfig(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (__, WebSocketClass user, _) {
      switch (user.status) {
        case Status.Unauthenticated:
          return LoginPage();
        case Status.Authenticated:
          return UserInfoPage();
        default:
          return LoginPage();
      }
    });
  }
}

class UserInfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<WebSocketClass>(context);
    user.generateButtonsList(context);
    List<FlatButton> funct = [
      FlatButton(
        onPressed: () {
          Navigator.pushNamed(context, '/Photocells');
        },
        color: Colors.indigo[50],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Photocells',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))
          ],
        ),
      ),
      FlatButton(
        color: Colors.indigo[50],
        onPressed: () {
          Navigator.pushNamed(context, '/inputA');
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Analog Input',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))
          ],
        ),
      ),
      FlatButton(
        color: Colors.indigo[50],
        onPressed: () {
          Navigator.pushNamed(context, '/StepperMotor');
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Stepper Motors',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))
          ],
        ),
      ),
      FlatButton(
        color: Colors.indigo[50],
        onPressed: () {
          Navigator.pushNamed(context, '/DCMotor');
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('DC Motors',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))
          ],
        ),
      ),
      FlatButton(
        color: Colors.indigo[50],
        onPressed: () {
          Navigator.pushNamed(context, '/Solenoids');
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Solenoids',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))
          ],
        ),
      ),
      FlatButton(
        color: Colors.indigo[50],
        onPressed: () {
          Navigator.pushNamed(context, '/DigitalOutputs');
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Digital output',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))
          ],
        ),
      ),
      FlatButton(
        color: Colors.indigo[50],
        onPressed: () {
          Navigator.pushNamed(context, '/Image');
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Imagine Processing',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))
          ],
        ),
      ),
    ];
    return Scaffold(
        appBar: AppBar(
          title: Text('@Main'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.arrow_back),
              tooltip: 'go Back',
              onPressed: () {
                user.disconnect();
              },
            )
          ],
        ),
        body: Center(
            child: ListView(
              padding: EdgeInsets.fromLTRB(80, 100, 80, 50),
              children: funct
            )
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            Navigator.pushNamed(context, '/Settings');
          },
          child: Icon(Icons.settings),
        ),
    );
  }
}
