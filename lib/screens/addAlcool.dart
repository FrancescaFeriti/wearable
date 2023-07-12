import 'package:flow1_prova/screens/alcoolPage.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flow1_prova/database/entities/Alcool.dart';
import 'package:flow1_prova/Repository/databaseRepository.dart';
import 'package:flow1_prova/widget/formTiles.dart';
import 'package:flow1_prova/widget/formSeparator.dart';
import 'package:provider/provider.dart';

class AddAlcool extends StatefulWidget {
  final Alcool? init_alcool;

  const AddAlcool({Key? key, required this.init_alcool}) : super(key: key);

  static const routeDisplayName = 'AddAlcool';

  @override
  State<AddAlcool> createState() => _AddAlcoolState();
} //AlcoolPage

class _AddAlcoolState extends State<AddAlcool> {
  //Form globalkey: this is required to validate the form fields.
  final formKey = GlobalKey<FormState>();

  //Variables that maintain the current form fields values in memory.
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  final TextEditingController _controller3 = TextEditingController();
  final TextEditingController _controller4 = TextEditingController();
  final TextEditingController _controller5 = TextEditingController();
  final TextEditingController _controller6 = TextEditingController();

  //Here, we are using initState() to initialize the form fields values.
  //Rationale: Meal content and time are not known is the meal is new (meal == null).
  // In this case, initilize them to empty and now(), respectively, otherwise set them to the respective values.
  @override
  void initState() {
    _controller1.text = widget.init_alcool == null ? '' : widget.init_alcool!.type.toString();
    _controller2.text = widget.init_alcool == null ? '' : widget.init_alcool!.volume.toString();
    _controller3.text = widget.init_alcool == null ? '' : widget.init_alcool!.quantity.toString();
    _controller4.text = widget.init_alcool == null ? '' : widget.init_alcool!.percentage.toString();
    _controller5.text = widget.init_alcool == null ? '' : widget.init_alcool!.hour.toString();
    _controller6.text = widget.init_alcool == null ? '' : widget.init_alcool!.day.toString();
    super.initState();
  } // initState

  //Remember that form controllers need to be manually disposed. So, here we need also to override the dispose() method.
  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    _controller4.dispose();
    _controller5.dispose();
    _controller6.dispose();
    super.dispose();
  } // dispose

  @override
  Widget build(BuildContext context) {
    //The page is composed of a form. An action in the AppBar is used to validate and save the information provided by the user.
    //A FAB is showed to provide the "delete" functinality. It is showed only if the meal already exists.
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(135, 47, 183, .9),
        title: const Text(AddAlcool.routeDisplayName),
        actions: [
          IconButton(
            onPressed: () => _validateAndSave(context),
            icon: const Icon(Icons.done),
          )
        ],
      ),
      body: Center(
        child: _buildForm(context),
      ),
      floatingActionButton: widget.init_alcool == null
          ? null
          : FloatingActionButton(
              backgroundColor: const Color.fromRGBO(135, 47, 183, .9),
              onPressed: () => _deleteAndPop(context, widget.init_alcool!),
              child: const Icon(Icons.delete),
            ),
    );
  } //build

  //Utility method used to build the form.
  Widget _buildForm(BuildContext context) {
    return Form(
      key: formKey,
      child: Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 8, left: 20, right: 20),
        child: ListView(
          children: <Widget>[
            const FormSeparator(label: 'Type'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 18, right: 30),
                  child: const Icon(
                    MdiIcons.glassCocktail,
                    color: Color.fromRGBO(50, 3, 59, 1),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: DropdownButton(
                      iconSize: 16,
                      value: _controller1.text.isEmpty ? null : _controller1.text,
                      hint: const Text('Select Type', style: TextStyle(fontSize: 16)),
                      style: const TextStyle(color: Colors.black),
                      items: const [
                        DropdownMenuItem(
                          value: 'Beer',
                          child: Text('Beer'),
                        ),
                        DropdownMenuItem(
                          value: "Wine",
                          child: Text('Wine'),
                        ),
                        DropdownMenuItem(
                          value: "Cocktail",
                          child: Text("Cocktail"),
                        ),
                        DropdownMenuItem(
                          value: "Other",
                          child: Text("Other"),
                        ),
                      ],
                      onChanged: (String? newvalue) {
                        _controller1.text = newvalue!;
                        setState(() {});
                      }),
                )
              ],
            ),
            /*
            FormNumberTile(
              labelText: 'Type',
              controller: _controller1,
              icon: MdiIcons.glassCocktail,
            ),
            */
            const FormSeparator(label: 'Volume'),
            FormNumberTile(
              labelText: 'Volume',
              controller: _controller2,
              icon: MdiIcons.flaskOutline,
            ),
            const FormSeparator(label: 'Quantity'),
            FormNumberTile(
              labelText: 'Quantity',
              controller: _controller3,
              icon: MdiIcons.bookmarkPlus,
            ),
            const FormSeparator(label: 'Percentage'),
            FormNumberTile(
              labelText: 'Percentage',
              controller: _controller4,
              icon: MdiIcons.percent,
            ),
            const FormSeparator(label: 'Hour'),
            FormNumberTile(
              labelText: 'Hour',
              controller: _controller5,
              icon: MdiIcons.timetable,
            ),
            const FormSeparator(label: 'Day'),
            TextFormField(
                controller: _controller6,
                decoration: const InputDecoration(icon: Icon(MdiIcons.clockTimeFourOutline), labelText: 'Day')),
          ],
        ),
      ),
    );
  } // _buildForm

  /*
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2010),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDate),
      );
      if (pickedTime != null) {
        setState(() {
          _selectedDate = DateTime(
            picked.year,
            picked.month,
            picked.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  } //_selectDate
  */

  //Utility method that validate the form and, if it is valid, save the new meal information.
  void _validateAndSave(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      if (widget.init_alcool == null) {
        Alcool newAlcool = Alcool(
          null,
          _controller6.text,
          _controller1.text,
          int.parse(_controller3.text),
          int.parse(_controller5.text),
          double.parse(_controller2.text),
          double.parse(_controller4.text),
        );
        await Provider.of<DatabaseRepository>(context, listen: false).insertAlcool(newAlcool);
      } else {
        Alcool updatedAlcool = Alcool(
          widget.init_alcool!.id,
          _controller6.text,
          _controller1.text,
          int.parse(_controller3.text),
          int.parse(_controller5.text),
          double.parse(_controller2.text),
          double.parse(_controller4.text),
        );

        await Provider.of<DatabaseRepository>(context, listen: false).updateAlcool(updatedAlcool);
        Navigator.pop(context);
      } //else
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const AlcoolPage()));
    } //if
  } //_validateAndSave

  void _deleteAndPop(BuildContext context, Alcool alcooltorem) async {
    await Provider.of<DatabaseRepository>(context, listen: false).removeAlcool(alcooltorem); //alcooltorem);
    // Navigator.pop(context);
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const AlcoolPage()));
  } //_deleteAndPop
} //alcoolPage
