import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'analogic_input.dart';
import 'login_page.dart';
import 'photocells.dart';
import 'ws_manage.dart';
import 'continous_motor.dart';
import 'solenoid.dart';
import 'stepper_motor.dart';

void main() => runApp(ChangeNotifierProvider(
      create: (_) => WebSocketClass(),
      child: MyApp()
    )
  );
TextEditingController controller = TextEditingController();

List<Color> color = [
  Colors.lightBlue[200]
];

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

      },
    );
  }
}

class HomePage extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Consumer(
        builder: (__, WebSocketClass user, _) {
          switch (user.status) {           
            case Status.Unauthenticated:
              return LoginPage();
            case Status.Authenticated:
              return UserInfoPage();   
            default:
              return LoginPage();
          }
        }
      );
  }
}

class UserInfoPage extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<WebSocketClass>(context);
    if(user.index==-1)
    {
      user.generateButtonsList(context);
    }
    
    List<FlatButton> funct = [
      FlatButton(
        onPressed: () {
          Navigator.pushNamed(context,'/Photocells' );
        },
        color: Colors.indigo[50],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[           
            Text('Photocells')
          ],
        ),
      ),

      FlatButton(
        color: Colors.indigo[50],
        onPressed: () {
          Navigator.pushNamed(context,'/inputA' );
          },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[                 
            Text('Ingressi Analogici')
          ],
        ),
      ),

      FlatButton(
        color: Colors.indigo[50],
        onPressed: () {
          Navigator.pushNamed(context,'/StepperMotor' );
          },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[       
                
            Text('Motori Stepper')
          ],
        ),
      ),

      FlatButton(
        color: Colors.indigo[50],
        onPressed: () {
          Navigator.pushNamed(context,'/DCMotor' );
          },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[       
                
            Text('Motori in continua')
          ],
        ),
      ),

      FlatButton(
        color: Colors.indigo[50],
        onPressed: () {
          Navigator.pushNamed(context,'/Solenoids' );
          },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[       
                
            Text('Solenoidi')
          ],
        ),
      ),
    ];
    return Scaffold(
      appBar: AppBar(     
        title: Text('Titolo'),  
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
      )    
    );   
  }
}
