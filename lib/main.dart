import 'package:flutter/material.dart';
import 'package:rotosocket/theme_changer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'firmware_update.dart';
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
  final version = (await PackageInfo.fromPlatform()).version;
  final imageAssets = await preloadAssets();

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => WebSocketClass(prefs, imageAssets)),
    ChangeNotifierProvider(create: (_) => ThemeChangerClass(prefs, version)),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (BuildContext context) {
      final themeChanger = Provider.of<ThemeChangerClass>(context);
      final webSocket = Provider.of<WebSocketClass>(context);
      return MaterialApp(
        scaffoldMessengerKey: webSocket.scaffoldMessengerKey,
        themeMode: themeChanger.themeMode,
        theme: ThemeData(
            brightness: Brightness.light,
            primarySwatch: Colors.red,
            colorScheme: ColorScheme.fromSwatch(
              primarySwatch: Colors.blue,
            ).copyWith()),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
        ),
        home: const HomePage(),
        routes: {
          '/Photocells': (_) => const Photocells(),
          '/PhotocellPage': (_) => const PhotocellPage(),
          '/inputA': (_) => const AnalogicInputs(),
          '/inputAnalogPage': (_) => const AnalogInputPage(),
          '/StepperMotor': (_) => const MotorST(),
          '/StepperMotorPage': (_) => const MotorStPage(),
          '/DCMotor': (_) => const DCMotor(),
          '/DCMotorPage': (_) => const DCMotorPage(),
          '/Solenoids': (_) => const Solenoid(),
          '/SolenoidPage': (_) => const SolenoidPage(),
          '/DigitalOutputs': (_) => const Output(),
          '/OutputPage': (_) => const OutputPage(),
          '/Image': (_) => const ImagePickerPage(),
          '/Settings': (_) => const Setting(),
          '/Network': (_) => const NwOptions(),
          '/Firmware': (_) => FirmwareUpdate(),
          '/ParameterOption': (_) => HwcOptions(),
          '/IpConfig': (_) => IpConfig(),
        },
      );
    });
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (__, WebSocketClass user, _) {
      switch (user.status) {
        case Status.socketNotConnected:
          return const ReconnectPage();
        case Status.socketConnected:
          return const MainMenuPage();
        case Status.socketCrash:
        default:
          user.statusRemoveCrash();
          // return to the first page from any page.
          // wait until the widget drawn was complete before invoking navigator
          // (this avoids avoid multiple simultaneous calls, and the relative exception)
          WidgetsBinding.instance.addPostFrameCallback(
              (_) => Navigator.of(context).popUntil((route) => route.isFirst));
          return const ReconnectPage();
      }
    });
  }
}

class MainMenuPage extends StatelessWidget {
  const MainMenuPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<WebSocketClass>(context);
    final List<Widget> func = [
      ElevatedButton(
        onPressed: () {
          Navigator.pushNamed(context, '/Photocells');
        },
        child: const Text('Photocells'),
      ),
      const SizedBox(height: 10),
      ElevatedButton(
        onPressed: () {
          Navigator.pushNamed(context, '/inputA');
        },
        child: const Text('Analog Input'),
      ),
      const SizedBox(height: 10),
      ElevatedButton(
        onPressed: () {
          Navigator.pushNamed(context, '/StepperMotor');
        },
        child: const Text('Stepper Motors'),
      ),
      const SizedBox(height: 10),
      ElevatedButton(
        onPressed: () {
          Navigator.pushNamed(context, '/DCMotor');
        },
        child: const Text('DC Motors'),
      ),
      const SizedBox(height: 10),
      ElevatedButton(
        onPressed: () {
          Navigator.pushNamed(context, '/Solenoids');
        },
        child: const Text('Solenoids'),
      ),
      const SizedBox(height: 10),
      ElevatedButton(
        onPressed: () {
          Navigator.pushNamed(context, '/DigitalOutputs');
        },
        child: const Text('Digital output'),
      ),
      const SizedBox(height: 10),
      ElevatedButton(
        onPressed: () {
          Navigator.pushNamed(context, '/Image');
        },
        child: const Text('Imagine Processing'),
      ),
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main menu'),
        actions: <Widget>[
          ElevatedButton.icon(
            label: const Text('Disconnect'),
            icon: const Icon(Icons.close),
            onPressed: () => user.disconnect(''),
          ),
          const SizedBox(width: 10), // icon + text is touching the border
        ],
      ),
      body: ListView(padding: const EdgeInsets.all(50), children: func),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Board Options',
        onPressed: () {
          Navigator.pushNamed(context, '/Settings');
        },
        child: const Icon(Icons.build),
      ),
    );
  }
}
