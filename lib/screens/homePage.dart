import 'dart:convert';
import 'dart:io';

import 'package:flow1_prova/Repository/databaseRepository.dart';
import 'package:flow1_prova/database/entities/Datahealth.dart';
import 'package:flow1_prova/database/entities/P_access.dart';
import 'package:flow1_prova/database/entities/Steps.dart';
import 'package:flutter/material.dart';
import 'package:flow1_prova/screens/loginPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flow1_prova/utils/description.dart';
import 'package:flow1_prova/screens/datasetting.dart';
import 'package:flow1_prova/database/entities/Resthealth.dart';
//import 'package:flow1_prova/screens/datasetting_modify.dart';
import 'package:flow1_prova/screens/alcoolPage.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flow1_prova/utils/impact.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:provider/provider.dart';
import 'package:flow1_prova/screens/dailyMonitoring.dart';
import 'package:intl/intl.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);
  static const routename = 'HomePage';

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    //get the credentials from the loginpage
    return Scaffold(
      backgroundColor: const Color.fromRGBO(213, 181, 229, 0.929),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(135, 47, 183, .9),
        title: const Text(
          'THE FIRST STEP',
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.w600,
            fontFamily: 'MarcellusSC',
          ),
        ),
      ),
      drawer: Drawer(
          backgroundColor: const Color.fromRGBO(135, 47, 183, 1),
          child: ListView(
            padding: const EdgeInsets.all(8),
            children: [
              DrawerHeader(
                decoration:
                    const BoxDecoration(color: Color.fromRGBO(135, 47, 183, .9)),
                child: Image.asset(
                  'assets/images/logo.jpeg',
                  fit: BoxFit.fill,
                ),
              ),
              ListTile(
                leading: const Icon(
                  MdiIcons.humanGreeting,
                  color: Colors.white,
                ),
                title: const Text(
                  'Settings',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                trailing: const Icon(
                  Icons.arrow_right,
                  color: Colors.white,
                ),
                onTap: () => _toSettingPage(context),
              ),
              ListTile(
                leading: const Icon(
                  MdiIcons.glassCocktail,
                  color: Colors.white,
                ),
                title: const Text(
                  'Alcohol Intake',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                trailing: const Icon(
                  Icons.arrow_right,
                  color: Colors.white,
                ),
                onTap: () {
                  _toAlcoolPage(context);
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.monitor_heart,
                  color: Colors.white,
                ),
                title: const Text(
                  'Daily Monitoring',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                trailing: const Icon(
                  Icons.arrow_right,
                  color: Colors.white,
                ),
                onTap: () {
                  _getAllData(context);
                  _toDailyMonitoring(context);
                },
              )
            ],
          )),
      body: Center(
        child: SingleChildScrollView(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              Description.text_title,
              style: const TextStyle(
                color: Color.fromARGB(255, 50, 3, 59),
                fontSize: 25,
                fontWeight: FontWeight.bold,
                fontFamily: 'MarcellusSC',
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(30, 30, 50, 50),
              child: Text(
                Description.text,
                style: const TextStyle(
                  color: Color.fromARGB(255, 55, 8, 81),
                  fontSize: 17,
                  fontWeight: FontWeight.normal,
                  fontFamily: 'PlayfairDisplay',
                ),
              ),
            ),
            Text(
              Description.text_last,
              style: const TextStyle(
                color: Color.fromARGB(255, 50, 3, 59),
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'PlayfairDisplay',
              ),
            ),
          ],
        )),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _toLoginPage(context);
        },
        backgroundColor: const Color.fromRGBO(135, 47, 183, .9),
        child: const Icon(Icons.logout_outlined),
      ),
    );
  }

  void _toLoginPage(BuildContext context) async {
    //Unset the 'username' filed in SharedPreferences
    final sp = await SharedPreferences.getInstance();
    sp.setString('access', 'null');
    //sp.remove("username");
    //Pop the page from the naviagator
    //Navigator.pop(context);
    //Then pop the HomePage
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => const LoginPage()));
  }

  void _toAlcoolPage(BuildContext context) {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => const AlcoolPage()));
  }

  void _toSettingPage(BuildContext context) async {
    List<P_access> accessList =
        await Provider.of<DatabaseRepository>(context, listen: false)
            .findAllP_access();
    int lastId = accessList.length;
    if (lastId == 0) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const SettingPage()));
    } else {
      _openDialog(context);
      /*
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => SettingPage_modify()));
      */
    }
  }

  void _openDialog(BuildContext context) async {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
            title: const Text('Modify Personal Informations?',
                style: TextStyle(
                    fontFamily: 'MarcellusSC',
                    color: Color.fromARGB(255, 50, 3, 59))),
            content: SizedBox(
              height: 130,
              child: Center(
                child: Column(children: [
                  const Text(
                      'You have already inserted your personal information. Do you wanna modify them?'),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromRGBO(213, 181, 229, 0.929)),
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('No')),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromRGBO(213, 181, 229, 0.929)),
                            onPressed: () => _updateSetting(context),
                            child: const Text('Yes')),
                      ])
                ]),
              ),
            ))); //showDialog
  }

  void _updateSetting(BuildContext context) async {
    List<P_access> accessList =
        await Provider.of<DatabaseRepository>(context, listen: false)
            .findAllP_access();
    int lastId = accessList.length;
    Provider.of<DatabaseRepository>(context, listen: false)
        .removeP_access(accessList[lastId - 1]);
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const SettingPage()));
  }

  /*
  void _controllo(BuildContext context) async {
    List<P_access> access_list = await Provider.of<DatabaseRepository>(context,listen:false).findAllP_access();
    int last_id = access_list.length;
    print('Primo access: ${access_list[1].name}');
    print('Ultimo accesso: ${access_list[last_id-1].name}');
  }
  */

  void _toDailyMonitoring(BuildContext context) {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const DailyMonitoring()));
  }

  Future<int> _refreshTokens() async {
    final url = Impact.baseUrl + Impact.refreshEndpoint;
    final sp = await SharedPreferences.getInstance();
    final refresh = sp.getString('refresh');
    final body = {'refresh': refresh};

    print('Calling: $url ');
    final response = await http.post(Uri.parse(url), body: body);

    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(response.body);
      final sp = await SharedPreferences.getInstance();
      await sp.setString('access', decodedResponse['access']);
      await sp.setString('refresh', decodedResponse['refresh']);
    }
    return response.statusCode;
  }

  Future<bool> _getRestHearth(BuildContext context) async {
    final sp = await SharedPreferences.getInstance();
    var access = sp.getString('access');
    if (access == null) {
      return false;
    } else {
      if (JwtDecoder.isExpired(access)) {
        await _refreshTokens();
        access = sp.getString("access");
      }
    }

    DateTime now = DateTime.now().subtract(const Duration(days: 1));
    final date =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

    final url = '${Impact.baseUrl}${Impact.restHeartEndPoint}/patients/${Impact.patientUsername}/day/$date';

    final header = {HttpHeaders.authorizationHeader: 'Bearer $access'};

    print('Calling $url');
    final response = await http.get(Uri.parse(url), headers: header);
    print(response.statusCode);

    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(response.body);
      //print(decodedResponse);

      double value = decodedResponse['data']['data']['value'];
      String date = decodedResponse['data']['date'];

      //Solo se non c'è già un valore associato a quella data
      // ignore: use_build_context_synchronously
      List<Resthealth> restHeartlist =
          await Provider.of<DatabaseRepository>(context, listen: false)
              .findAllResthealth();
      int lastId = restHeartlist.length;
      print('Corretto fino a qui');

      if (lastId > 0 && restHeartlist[lastId - 1].date != date) {
        Resthealth newRest = Resthealth(1, date, value);
        // ignore: use_build_context_synchronously
        await Provider.of<DatabaseRepository>(context, listen: false)
            .insertResthealth(newRest);
        print('Nuovo Rest Heart Rate salvato');
      }
    }

    return (response.statusCode == 200);
  }

  Future<bool> _getHearth(BuildContext context) async {
    final sp = await SharedPreferences.getInstance();
    var access = sp.getString('access');
    if (access == null) {
      return false;
    } else {
      if (JwtDecoder.isExpired(access)) {
        await _refreshTokens();
        access = sp.getString("access");
      }
    }

    DateTime now = DateTime.now().subtract(const Duration(days: 1));
    final date =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

    final url = '${Impact.baseUrl}${Impact.hearthRateEndPoint}/patients/${Impact.patientUsername}/day/$date';

    final header = {HttpHeaders.authorizationHeader: 'Bearer $access'};

    print('Calling $url');
    final response = await http.get(Uri.parse(url), headers: header);
    print(response.statusCode);

    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(response.body);
      //print(decodedResponse);
      String date = decodedResponse['data']['date'];
      int totCampioni = decodedResponse['data']['data'].length;

      for (int h = 0; h < 24; h++) {
        double sumHour = 0;
        int nHour = 0;
        DateTime hourStart = DateFormat("hh:mm:ss").parse("$h:00:00");
        DateTime hourEnd = DateFormat("hh:mm:ss").parse("$h:59:59");
        for (int campione = 0; campione < totCampioni; campione++) {
          DateTime decodedData = DateFormat("hh:mm:ss")
              .parse(decodedResponse['data']['data'][campione]['time']);
          if (decodedData.isAfter(hourStart) &&
              decodedData.isBefore(hourEnd)) {
            sumHour =
                sumHour + decodedResponse['data']['data'][campione]['value'];
            nHour = nHour + 1;
          }
        }
        sumHour = sumHour / nHour;

        //creo l'oggetto
        List<Datahealth> heartlist =
            await Provider.of<DatabaseRepository>(context, listen: false)
                .findAllDatahealth();
        int lastId = heartlist.length;
        print('Corretto fino a qua');

        /*
        if (last_id > 0 && heartlist[last_id - 1].day != date) {
          Datahealth newDataHealth = Datahealth(1, date, h, sum_hour);
          // ignore: use_build_context_synchronously
          await Provider.of<DatabaseRepository>(context, listen: false).insertDatahealth(newDataHealth);
          print('Nuovo Heart Data salvato');
        }
        */
      }
    }

    return (response.statusCode == 200);
  }

  Future<bool> _getSteps(BuildContext context) async {
    final sp = await SharedPreferences.getInstance();
    var access = sp.getString('access');
    if (access == null) {
      return false;
    } else {
      if (JwtDecoder.isExpired(access)) {
        await _refreshTokens();
        access = sp.getString("access");
      }
    }

    DateTime now = DateTime.now().subtract(const Duration(days: 1));
    final date =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

    final url = '${Impact.baseUrl}${Impact.stepsEndPoint}/patients/${Impact.patientUsername}/day/$date';

    final header = {HttpHeaders.authorizationHeader: 'Bearer $access'};

    print('Calling $url');
    final response = await http.get(Uri.parse(url), headers: header);
    print(response.statusCode);

    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(response.body);
      //print(decodedResponse);
      String date = decodedResponse['data']['date'];
      int totCampioni = decodedResponse['data']['data'].length;

      int sumDay = 0;

      for (int l = 0; l < totCampioni; l++) {
        int numPassi = int.parse(decodedResponse['data']['data'][l]['value']);
        sumDay = sumDay + numPassi;
      }

      //creo l'oggetto
      // ignore: use_build_context_synchronously
      List<Steps> stepslist =
          await Provider.of<DatabaseRepository>(context, listen: false)
              .findAllSteps();
      int lastId = stepslist.length;
      print('Corretto fino a qui');

      if (lastId > 0 && stepslist[lastId - 1].day != date) {
        Steps newSteps = Steps(1, date, sumDay);
        // ignore: use_build_context_synchronously
        await Provider.of<DatabaseRepository>(context, listen: false)
            .insertSteps(newSteps);
        print('Nuovo Step Day salvato');
      }
    }

    return (response.statusCode == 200);
  }

  Future<void> _getAllData(BuildContext context) async {
    await _getRestHearth(context);
    await _getHearth(context);
    await _getSteps(context);
    //aggiungere le altre funzioni
  }
}
