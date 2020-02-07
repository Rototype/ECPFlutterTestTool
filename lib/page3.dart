import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'modifier.dart';

class Page3 extends StatelessWidget {
  const Page3({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) { 
    return ChangeNotifierProvider(
      create: (_) => Modifier(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Pagina 3')
        ),
        body: Consumer(
          builder: (context, Modifier modifier, __){
            modifier.connect();
            return Column(
              children: <Widget>[
                RaisedButton(
                  child: Text('Premere per Cambiare'),
                    onPressed: (){
                    modifier.send('cambia 3');
                   }
                 ),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: modifier.x3.length,
                    itemBuilder: (BuildContext ctxt, int index) {
                      return new Text(modifier.x3[index]);
                   }
                  )
               ],
            );
          }
        ),            
      )
    );
  }
}
