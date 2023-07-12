import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flow1_prova/database/entities/P_access.dart';
import 'package:flow1_prova/screens/homePage.dart';
import 'package:flow1_prova/Repository/databaseRepository.dart';

class SettingPage extends StatefulWidget {
  SettingPage({Key? key}) : super(key: key);
  static const routename = 'SettingPage';

  @override
  _SettingPageState createState() => _SettingPageState();
}

enum OpzioniEnum { male, female, other }

const List<String> list = <String>[
  'Occasionally(0-1)',
  'Normal(1-3)',
  'Frequent(3-5)',
  'Strong(5-8)',
  'Semi-professional(8-12)',
  'Professional(12+)'
];

class _SettingPageState extends State<SettingPage> {
  late UserData userData;

  IconData secondButtonIcon = Icons.home_filled;

  OpzioniEnum genere = OpzioniEnum.male;
  String trainingLevel = list.first;

  void onRadioTap(newValue) {
    setState(() => genere = newValue);
  }

  @override
  void initState() {
    super.initState();
    userData = UserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(135, 47, 183, .9),
        title: Text(
          'Profile Settings',
          style: TextStyle(fontFamily: 'MarcellusSC', fontSize: 30),
        ),
      ),
      body: Column(
        children: [
          Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  decoration: const InputDecoration(
                    icon: const Icon(
                      MdiIcons.accountSettingsOutline,
                      color: Color.fromARGB(255, 50, 3, 59),
                    ),
                    hintText: 'Enter your name',
                    labelText: 'Name',
                  ),
                  onChanged: (newValue) => userData.updateName(newValue),
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    icon: const Icon(
                      MdiIcons.accountSettingsOutline,
                      color: Color.fromARGB(255, 50, 3, 59),
                    ),
                    hintText: 'Enter your surname',
                    labelText: 'Surname',
                  ),
                  onChanged: (newValue) => userData.updateSurname(newValue),
                ),
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Row(
                          children: [
                            Icon(
                              MdiIcons.genderMaleFemaleVariant,
                              color: Color.fromARGB(255, 50, 3, 59),
                            ),
                            Text('Gender'),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Radio(
                              value: OpzioniEnum.male,
                              groupValue: genere,
                              onChanged: onRadioTap),
                          Text('Male'),
                          Radio(
                              value: OpzioniEnum.female,
                              groupValue: genere,
                              onChanged: onRadioTap),
                          Text('Female'),
                          Radio(
                              value: OpzioniEnum.other,
                              groupValue: genere,
                              onChanged: onRadioTap),
                          Text('Other'),
                        ],
                      ),
                    ],
                  ),
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    icon: const Icon(Icons.height,
                        color: Color.fromARGB(255, 50, 3, 59)),
                    hintText: 'Enter your height',
                    labelText: 'Height',
                  ),
                  onChanged: (newValue) => userData.updateHeight(newValue),
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    icon: const Icon(
                      MdiIcons.scaleBalance,
                      color: Color.fromARGB(255, 50, 3, 59),
                    ),
                    hintText: 'Enter your weight',
                    labelText: 'Weight',
                  ),
                  onChanged: (newValue) => userData.updateWeight(newValue),
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    icon: const Icon(
                      Icons.calendar_today,
                      color: Color.fromARGB(255, 50, 3, 59),
                    ),
                    hintText: 'Enter your date of birth',
                    labelText: 'Date of birth',
                  ),
                  onChanged: (newValue) => userData.updateDateOfBirth(newValue),
                ),
                Center(
                  child: Row(
                    children: [
                      Icon(
                        MdiIcons.run,
                        color: Color.fromARGB(255, 50, 3, 59),
                      ),
                      Text('Training level (hours/week)'),
                    ],
                  ),
                ),
                DropdownButton<String>(
                  value: trainingLevel,
                  icon: const Icon(Icons.arrow_downward),
                  iconSize: 20,
                  elevation: 16,
                  style: const TextStyle(color: Colors.black54),
                  underline: Container(
                    height: 2,
                    color: Colors.black54,
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      trainingLevel = value!;
                    });
                  },
                  items: list.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            backgroundColor: Color.fromRGBO(135, 47, 183, .9),
            child: Icon(Icons.save),
            onPressed: () => _validateAndSaveDataSetting(userData),
          ),
          SizedBox(height: 16),
          FloatingActionButton(
            backgroundColor: Color.fromRGBO(135, 47, 183, .9),
            child: Icon(secondButtonIcon),
            onPressed: () => _backHome(context),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  void _backHome(BuildContext context) {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
  }

  void _validateAndSaveDataSetting(UserData userData) async {
    List<P_access> accessList =
        await Provider.of<DatabaseRepository>(context, listen: false)
            .findAllP_access();
    int lastId = accessList.length;

    print(
        'name: ${userData.name}, surname: ${userData.surname}, height: ${userData.height}, weight: ${userData.weight}, dateOfBirth: ${userData.dateOfBirth}, gender: ${userData.gender.name}, trainingLevel: ${userData.trainingLevel}');

    if (userData.name != null &&
        userData.surname != null &&
        userData.gender != null &&
        userData.dateOfBirth != null) {
      P_access newAccess = P_access(
        lastId + 1,
        userData.name!,
        userData.surname!,
        userData.gender.name,
        userData.dateOfBirth!,
      );
      await Provider.of<DatabaseRepository>(context, listen: false)
          .insertP_access(newAccess);
      print('Nuovo P_access salvato');
    } else {
      print('Control: not save new P_access');
    }
  }
}

class UserData extends ChangeNotifier {
  String? name;
  String? surname;
  String? height;
  String? weight;
  String? dateOfBirth;
  OpzioniEnum gender = OpzioniEnum.male;
  String trainingLevel = 'Occasionally(0-1)';

  void updateName(String newValue) {
    name = newValue;
    notifyListeners();
  }

  void updateSurname(String newValue) {
    surname = newValue;
    notifyListeners();
  }

  void updateHeight(String newValue) {
    height = newValue;
    notifyListeners();
  }

  void updateWeight(String newValue) {
    weight = newValue;
    notifyListeners();
  }

  void updateDateOfBirth(String newValue) {
    dateOfBirth = newValue;
    notifyListeners();
  }

  void updateGender(OpzioniEnum newValue) {
    gender = newValue;
    notifyListeners();
  }

  void updateTrainingLevel(String newValue) {
    trainingLevel = newValue;
    notifyListeners();
  }

  // Metodo per reimpostare i dati
  void resetData() {
    name = 'Default';
    surname = 'Default';
    height = 'Default';
    weight = 'Default';
    dateOfBirth = 'Default';
    gender = OpzioniEnum.male;
    trainingLevel = 'Occasionally(0-1)';
    notifyListeners();
  }
}
