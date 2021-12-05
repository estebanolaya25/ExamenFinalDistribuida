import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:olayafinal_app/components/loader_component.dart';
import 'package:olayafinal_app/helpers/api_helper.dart';
import 'package:olayafinal_app/models/response.dart';
import 'package:olayafinal_app/models/token.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:date_format/date_format.dart';

class PollEditScreen extends StatefulWidget {
  final Token token;


  PollEditScreen({required this.token});

  @override
  _PollEditScreenState createState() => _PollEditScreenState();

}

class _PollEditScreenState extends State<PollEditScreen> {
late final _ratingController;
  bool _showLoader = false;
  DateTime selectedDate = DateTime.now();
double _userRating = 3.0;
late double _rating;
double _initialRating = 2.0;

String _penalityDescription = '';
  String _penalityDescriptionError = '';
  bool _penalityDescriptionShowError = false;
  TextEditingController _penalityDescriptionController = TextEditingController();


  String _emailDescription = '';
  String _emailDescriptionError = '';
  bool _emailDescriptionShowError = false;
  TextEditingController _emailDescriptionController = TextEditingController();

  String _theBestDescription = '';
  String _theBestDescriptionError = '';
  bool _theBestDescriptionShowError = false;
  TextEditingController _theBestDescriptionController = TextEditingController();

  String _theWorstDescription = '';
  String _theWorstDescriptionError = '';
  bool _theWorstDescriptionShowError = false;
  TextEditingController _theWorstDescriptionController = TextEditingController();


   String _remarksDescription = '';
  String _remarksDescriptionError = '';
  bool _remarksDescriptionShowError = false;
  TextEditingController _remarksDescriptionController = TextEditingController();


 @override
  void initState() {
    super.initState();

    _ratingController = TextEditingController(text: '3.0');
    _rating = _initialRating;

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
         'Nuevo Transacion'
        ),
        backgroundColor: Colors.green,
      ),
      // ignore: unnecessary_new
      body: new SingleChildScrollView(
            child:  ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: 120.0,
              ),
              // ignore: unnecessary_new
              child:  Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  SizedBox(height: 8,),
              _showTransactionDate(),
              SizedBox(height: 8,),
              _show_Email(),
              SizedBox(height: 8,),
              _heading("Calificacion"),
              _showstartbar(),
              _inrattin(),

              SizedBox(height: 8,),

               
               _show_thebest(),
               SizedBox(height: 8,),
               _show_theworst(),
               SizedBox(height: 8,),
               
               _show_remarks(),
               SizedBox(height: 8,),

               _showButtons()
             
                ],
              ),

    )));
  }

  Widget _showTransactionDate()
  {
    return Container(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton.icon(
          icon: Icon(
            Icons.date_range_rounded,
            color: Colors.white,
            size: 24.0,
          ),
          style: ElevatedButton.styleFrom(
    minimumSize: const Size(200, 50),
    maximumSize: const Size(200, 50),
    primary: Colors.green,               
     textStyle: TextStyle(
      fontSize: 16,
     fontWeight: FontWeight.bold)),
          label: Text('Seleccione Fecha'),          
          onPressed: () {
             _selectDate(context);
          },),
          SizedBox(height: 8,),
            Text("${selectedDate.day}/${selectedDate.month}/${selectedDate.year}", 
             style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold
          ),
            )
          ],
        ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2010),
      lastDate: DateTime(2025), 
    );
    if (selected != null && selected != selectedDate)
      setState(() {
        selectedDate = selected;
      });
  }


 Widget _showstartbar()
  {
    return RatingBarIndicator(
                    rating: _userRating,
                    itemBuilder: (context, index) => Icon(
                       Icons.star,
                      color: Colors.amber,
                    ),
                    itemCount: 5,
                    itemSize: 50.0,
                    unratedColor: Colors.amber.withAlpha(50),
                    direction:  Axis.horizontal,
                    
                  );


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


      Widget _inrattin()
      {
        return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextFormField(
                      controller: _ratingController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Entre Calificacion',
                        labelText: 'Calificacion',
                        suffixIcon: MaterialButton(
                          onPressed: () {
                            _userRating =
                                double.parse(_ratingController.text ?? '0.0');
                            setState(() {

                            });
                          },
                          child: Text('Rate'),
                        ),
                      ),
                    ),
                  );
      }

Widget _show_Email() {
    return Container(
      padding: EdgeInsets.all(10),
      child: TextField(
        keyboardType: TextInputType.text,
        controller: _emailDescriptionController,
        decoration: InputDecoration(
          hintText: 'Ingresa Correo',
          labelText: 'Correo',
          errorText: _emailDescriptionShowError ? _emailDescriptionError : null,
          suffixIcon: Icon(Icons.mail),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10)
          ),
        ),
        onChanged: (value) {
          _emailDescription = value;
        },
      ),
    );
  }

  

  Widget _show_thebest() {
    return Container(
      padding: EdgeInsets.all(10),
      child: TextField(
        keyboardType: TextInputType.text,
        controller: _theBestDescriptionController,
        decoration: InputDecoration(
          hintText: 'Ingresa lo mejor',
          labelText: 'lo mejor',
          errorText: _theBestDescriptionShowError ? _theBestDescriptionError : null,
          suffixIcon: Icon(Icons.sentiment_satisfied_sharp),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10)
          ),
        ),
        onChanged: (value) {
          _theBestDescription = value;
        },
      ),
    );
  }

  Widget _show_theworst() {
    return Container(
      padding: EdgeInsets.all(10),
      child: TextField(
        keyboardType: TextInputType.text,
        controller: _theWorstDescriptionController,
        decoration: InputDecoration(
          hintText: 'Ingresa lo Peor',
          labelText: 'lo peor',
          errorText: _theWorstDescriptionShowError ? _theWorstDescriptionError : null,
          suffixIcon: Icon(Icons.sentiment_dissatisfied_rounded),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10)
          ),
        ),
        onChanged: (value) {
          _theWorstDescription = value;
        },
      ),
    );
  }

  Widget _show_remarks() {
    return Container(
      padding: EdgeInsets.all(10),
      child: TextField(
        keyboardType: TextInputType.text,
        controller: _remarksDescriptionController,
        decoration: InputDecoration(
          hintText: 'Mejoras',
          labelText: 'Mejoras',
          errorText: _remarksDescriptionShowError ? _remarksDescriptionError : null,
          suffixIcon: Icon(Icons.flaky),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10)
          ),
        ),
        onChanged: (value) {
          _remarksDescription = value;
        },
      ),
    );
  }


  Widget _showButtons() {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Expanded(
            child: ElevatedButton(
              child: Text('Guardar'),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                    return Color(0xFF120E43);
                  }
                ),
              ),
              onPressed: () => _save(), 
            ),
          )]));
          
          }

  _save()  async {
    if (!_validateFields()) {
      return;
    }

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
    
    String juan=formatDate(selectedDate, [yyyy, '-', mm, '-', dd,]);

    Map<String, dynamic> request = {
      'id': 0,
      'date': juan,
      'email': _emailDescription,      
      'qualification': _userRating.toInt(),
      'theBest': _theBestDescription,
      'theWorst': _theWorstDescription,
      'remarks': _remarksDescription
    };

    print(jsonEncode(request));

    Response response = await ApiHelper.post(
      '/api/Finals/', 
      request, 
      widget.token
    );

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

    Navigator.pop(context, 'yes');

  }


   bool _validateFields() {
    bool isValid = true;

    if (_emailDescription.isEmpty) {
      isValid = false;
      _emailDescriptionShowError=true;
      _emailDescriptionError = 'Debes ingresar un email Valido';
    } else {
      _emailDescriptionShowError = false;
    }

   if (_theBestDescription.isEmpty) {
      isValid = false;
      _theBestDescriptionShowError = true;
      _theBestDescription = 'Debes que fue lo mejor';
    } else {
      _theBestDescriptionShowError = false;
    } 

     if (_theWorstDescription.isEmpty) {
      isValid = false;
      _theWorstDescriptionShowError = true;
     _theWorstDescriptionError = 'Debes ingresar lo peor';
    } else {
      _theWorstDescriptionShowError = false;
    }


    if (_remarksDescription.isEmpty) {
      isValid = false;
      _remarksDescriptionShowError = true;
      _remarksDescriptionError = 'Debes ingresar el valor total';
    } else {
      _remarksDescriptionShowError = false;
    }

    setState(() { });
    return isValid;
  }


}

  



