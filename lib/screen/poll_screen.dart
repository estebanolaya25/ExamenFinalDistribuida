import 'package:flutter/material.dart';
import 'package:olayafinal_app/components/loader_component.dart';
import 'package:olayafinal_app/helpers/api_helper.dart';
import 'package:olayafinal_app/models/poll.dart';
import 'package:olayafinal_app/models/response.dart';
import 'package:olayafinal_app/models/token.dart';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:date_format/date_format.dart';
import 'package:olayafinal_app/screen/polledit_screen.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class PollScreen extends StatefulWidget {
  final Token token;


  PollScreen({required this.token});

  @override
  _PollScreenState createState() => _PollScreenState();
}

class _PollScreenState extends State<PollScreen> {
  late Poll _poll;
  bool _showLoader = false;
  bool _isFiltered = false;
  String _search = '';

  @override
  void initState() {
    super.initState();
    _getPenalities();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('Encuenta'),
     
      ),
      body: Center(
        child: _showLoader ? LoaderComponent(text: 'Por favor espere...') : _getContent(),
      )
     
    );
  }

  Future<Null> _getPenalities() async {
    setState(() {
      _showLoader = true;
    });

    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        _showLoader = false;
      });
      await showAlertDialog(
        context: context,
        title: 'Error', 
        message: 'Verifica que estes conectado a internet.',
        actions: <AlertDialogAction>[
            AlertDialogAction(key: null, label: 'Aceptar'),
        ]
      );    
      return;
    }

    Response response = await ApiHelper.getPoll(widget.token);

    setState(() {
      _showLoader = false;
    });

    if (!response.isSuccess) {
      await showAlertDialog(
        context: context,
        title: 'Error', 
        message: response.message,
        actions: <AlertDialogAction>[
            AlertDialogAction(key: null, label: 'Aceptar'),
        ]
      );    
      return;
    }

    setState(() {
      _poll = response.result;
    });
  }

  Widget _getContent() {
    return _poll==null
      ? _noContent()
      : _Content();
  }

  Widget _Content()
  {
      setState(() {
      _showLoader = false;
    });
        return Column(
      children: <Widget>[
       _pollview(),

       _showButtonspoll()
        
      ],
    );



  }

  Widget _noContent() {
    return Center(
      child: Container(
        margin: EdgeInsets.all(20),
        child: Text(
          _isFiltered
          ? 'No hay tipos de Transaccion con ese criterio de búsqueda.'
          : 'No hay tipos de documento registrados.',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold
          ),
        ),
      ),
    );
  }

  Widget _pollview() {  
   return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(5),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
               width: double.infinity,
                decoration: BoxDecoration(
                    gradient: LinearGradient(                      
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft, 
                      colors: [
                        Color(0xffB2BABD),
                        Color(0xffDEFAE8),
                      ],
                    ),
                    border: Border.all(
                        style: BorderStyle.solid, color: Colors.grey),
                        borderRadius: BorderRadius.circular(15),                         
                        ),
                        
               margin: EdgeInsets.symmetric(horizontal: 10),
               padding: EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded( 
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(
                              'id encuenta: ', 
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              )
                            ),
                            Text(
                              _poll.id.toString(), 
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8,),
                        Row(
                          children: <Widget>[
                            Text(
                              'Fecha: ', 
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                 fontSize: 18,
                              )
                            ),
                            Text(
                              formatDate(DateTime.parse(_poll.date), [dd, '/', mm, '/', yyyy, ' ', HH, ':', nn]),
                             
                              style: TextStyle(
                                 fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                         SizedBox(height: 8,),
                        Row(
                          children: <Widget>[
                            Text(
                              'Email: ', 
                              
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                 fontSize: 18
                              )
                            ),
                            Flexible(child: 
                            Text(
                               _poll.email.toString(),
                            )
                            )
                           
                          ],
                        ),
                       
                        SizedBox(height: 8,),
                        _heading("Calificacion"),
                        RatingBarIndicator(
                    rating: _poll.qualification.toDouble(),
                    itemBuilder: (context, index) => Icon(
                       Icons.star,
                      color: Colors.amber,
                    ),
                    itemCount: 5,
                    itemSize: 50.0,
                    unratedColor: Colors.amber.withAlpha(50),
                    direction:  Axis.horizontal,
                    
                  ),
                        SizedBox(height: 8,),
                        Row(
                          children: <Widget>[
                            Text(
                              'Lo mejor:', 
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                 fontSize: 18
                              )
                            ),
                            Text(
                            _poll.theBest.toString(),
                             textAlign: TextAlign.right,
                             overflow: TextOverflow.fade,
                              style: TextStyle(
                                 fontSize: 18,                               
                                
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 8,),
                        Row(
                          children: <Widget>[
                            Text(
                              'Lo Peor: ', 
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                 fontSize: 18
                              )
                            ),
                            Text(
                            _poll.theWorst.toString(),
                            overflow: TextOverflow.fade,
                             textAlign: TextAlign.right,                             
                              style: TextStyle(
                                 fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8,),
                        Row(
                          children: <Widget>[
                            Text(
                              'Recomendacion:', 
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                 fontSize: 18
                              )
                            ),
                            Text(
                            _poll.remarks.toString(),
                            overflow: TextOverflow.fade,
                             textAlign: TextAlign.right,                             
                              style: TextStyle(
                                 fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ])
                  )
                ]
              )
            ),
          )
         ]
      )
   );
  }

  _goAddPenality() {}   

 

 Widget _showButtonspoll() {
    return Column(
      children: [
        Container(
          
          margin: EdgeInsets.only(left: 10, right: 10),
          child: Row(
            
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[              
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ButtonBar(
              buttonPadding:EdgeInsets.symmetric(horizontal: 30,vertical: 10),
              buttonMinWidth: 100,
              children: [
                    FloatingActionButton.extended(
                      onPressed: () => _gopolledit(),
    label: Text('Editar'),
    icon: Icon(Icons.swap_vert_circle_rounded),
    backgroundColor: Colors.pink,
                    )
              ],
            ),
                  ],
                ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  void _gopolledit() async{
String? result = await  Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (context) => PollEditScreen(token: widget.token     
          
        ) 
      )
    );

    _getPenalities();

    
}

 

 Widget _heading(String text) => Column(
        children: [
          Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 24.0,
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
        ],
      );
  

   
 }

  
  

  
