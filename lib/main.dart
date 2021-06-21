import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'settings.dart';
import 'package:provider/provider.dart';

import 'analog_input.dart';
import 'continuous_motor.dart';
import 'digital_output.dart';
import 'image.dart';
import 'reconnect.dart';
import 'photocells.dart';
import 'solenoid.dart';
import 'stepper_motor.dart';
import 'ws_manage.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // this line is needed to use async/await in main()

  final prefs = await SharedPreferences.getInstance();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(  create: (_) => WebSocketClass(prefs)), 
        ChangeNotifierProvider(  create: (_) => ThemeChangerClass(prefs)),
      ],
      child: MyApp()
    )
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
      return Builder(builder: (BuildContext context) {
        final themeChanger = Provider.of<ThemeChangerClass>(context);
        final WebSocket = Provider.of<WebSocketClass>(context);
        return MaterialApp(
          scaffoldMessengerKey: WebSocket.scaffoldMessengerKey,
          themeMode: themeChanger.themeMode,
          theme: ThemeData(
            brightness: Brightness.light,
            primarySwatch: Colors.red,
            colorScheme: ColorScheme.fromSwatch(
              primarySwatch: Colors.blue,
            ).copyWith()      
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
          ),
          home: HomePage(),
          routes: {
            '/Photocells': (_) => Photocells(),
            '/PhotocellPage': (_) => PhotocellPage(),
            '/inputA': (_) => AnalogicInputs(),
            '/inputAnalogPage': (_) => AnalogInputPage(),
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
      });
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (__, WebSocketClass user, _) {
      switch (user.status) {
        case Status.SocketNotConnected:
          return ReconnectPage();
        case Status.SocketConnected:
          return MainMenuPage();
        case Status.SocketCrash:
        default:
          user.statusRemoveCrash();
          // return to the first page from any page. 
          // wait until the widget drawn was complete before invoking navigator 
          // (this avoids avoid multiple simultaneous calls, and the relative exception)
          WidgetsBinding.instance.addPostFrameCallback((_) =>  Navigator.of(context).popUntil((route) => route.isFirst)); 
          return ReconnectPage();
      }
    });
  }
}

class MainMenuPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<WebSocketClass>(context);
    user.generateButtonsList(context);
    List<TextButton> func = [
      TextButton(
        onPressed: () {
          Navigator.pushNamed(context, '/Photocells');
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Photocells',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))
          ],
        ),
      ),
      TextButton(
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
      TextButton(
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
      TextButton(
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
      TextButton(
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
      TextButton(
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
      TextButton(
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
        title: Text('Main menu'),
        actions: <Widget>[
          TextButton.icon(
            label: Text('Disconnect'),
            icon: Icon(Icons.close),
            onPressed: () => user.disconnect(''),
          ),
            SizedBox(width: 10),    // icon + text is touching the border

        ],
      ),
      body: Center(
          child: ListView(
              padding: EdgeInsets.fromLTRB(80, 100, 80, 50), children: func)),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Board Options',
        onPressed: () {
          Navigator.pushNamed(context, '/Settings');
        },
        child: Icon(Icons.build),
      ),
    );
  }
}
