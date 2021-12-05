import 'package:olayafinal_app/screen/poll_screen.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:olayafinal_app/models/token.dart';
import 'package:olayafinal_app/screen/login_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeScreen extends StatefulWidget {
  final Token token;

  HomeScreen({required this.token});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Encuenta Vehicles'),
      ),
      body: _getBody(),
      drawer: widget.token.user.userType == 0 
        ? _getMechanicMenu() 
        : _getCustomerMenu(),
    );
  }

  Widget _getBody() {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(150),
              child: CachedNetworkImage(
                imageUrl: widget.token.user.imageFullPath,
                errorWidget: (context, url, error) => Icon(Icons.error),
                fit: BoxFit.cover,
                height: 300,
                width: 300,
                placeholder: (context, url) => Image(
                  image: AssetImage('assets/noimage.png'),
                  fit: BoxFit.cover,
                  height: 300,
                  width: 300,
                ),
              )
            ),
            SizedBox(height: 30,),
            Center(
              child: Text(
                'Bienvenid@ ${widget.token.user.fullName}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
             SizedBox(height: 30,),

             _showEncuestaButton(),
             
          ],
        ),
      ),
    );
  }

  Widget _getMechanicMenu() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Image(
              image: AssetImage('assets/noimage.png'),
            )
          ),
         
          ListTile(
            leading: Icon(Icons.logout),
            title: const Text('Cerrar Sesión'),
            onTap: () => _logOut(),
          ),
        ],
      ),
    );
  }

  Widget _getCustomerMenu() {
     return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Image(
              image: AssetImage('assets/noimage.png'),
            )
          ),
         
          Divider(
            color: Colors.black, 
            height: 2,
          ),
        
          ListTile(
            leading: Icon(Icons.logout),
            title: const Text('Cerrar Sesión'),
            onTap: () => _logOut(),
          ),
        ],
      ),
    );
  }

  void _logOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isRemembered', false);
    await prefs.setString('userBody', '');

    Navigator.pushReplacement(
      context, 
      MaterialPageRoute(
        builder: (context) => LoginScreen()
      )
    ); 
  }

  void _sendMessage() async {
    final link = WhatsAppUnilink(
      phoneNumber: '+573223114620',
      text: 'Hola soy ${widget.token.user.fullName} cliente del taller',
    );
    await launch('$link');
  }

  Widget _showButtons() {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      child: Column(
        children: [  
_showEncuestaButton(),
        ],
      ),
    );
  }

  Widget _showEncuestaButton() {
    return Row(
      children: <Widget>[
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => _encuesta(),
            icon: FaIcon(
              FontAwesomeIcons.poll,
              color: Colors.white,
            ), 
            label: Text('Validar Encuesta'),
            style: ElevatedButton.styleFrom(
              primary: Color(0xFF3B5998),
              onPrimary: Colors.white
            )
          )
        )
      ],
    );
  }

  _nada() {}

 void _encuesta() async {



String? result = await  Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (context) => PollScreen(token: widget.token)
      )
    );
    if (result == 'yes') {
  
    }

 }
}