import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'modifier.dart';

class Page2 extends StatelessWidget {
  const Page2({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) { 
    return ChangeNotifierProvider(
      create: (_) => Modifier(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Pagina 2')
        ),
        body: Consumer(
          builder: (context, Modifier modifier, __){
            modifier.connect();
            return Column(
              children: <Widget>[
                RaisedButton(
                  child: Text('Premere per Cambiare'),
                    onPressed: (){
                    modifier.send('cambia 2');
                   }
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: modifier.x2.length,
                  itemBuilder: (BuildContext ctxt, int index) {
                    return new Text(modifier.x2[index]);
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
