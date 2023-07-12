/*
//AlcoolDay screen. It will show the list of alcoolic beverages.
class AlcoolDay extends StatelessWidget {
  AlcoolDay({Key? key}) : super(key: key);

  static const route = '/';
  static const routeDisplayName = 'AlcoolDay';

  @override
  Widget build(BuildContext context) {
    //Print the route display name for debugging
    print('${AlcoolDay.routeDisplayName} built');
    
    return Scaffold(
      appBar: AppBar(
        title: Text(AlcoolDay.routeDisplayName),
      ),
      body: Center(
        child: Consumer<DatabaseRepository>(
          builder: (context, dbr, child) {
            return FutureBuilder(
              initialData: null,
              future: dbr.findAllAlcool(),
              builder:(context, snapshot) {
                if(snapshot.hasData){
                  final data = snapshot.data as List<Alcool>;
                  //If the Meal table is empty, show a simple Text, otherwise show the list of meals using a ListView.
                  return data.length == 0 ? Text('The meal list is currently empty') : ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, alcoolIndex) {
                      //Here, we are using a Card to show a Meal
                      return Card(
                        elevation: 5,
                        child: ListTile(
                          leading: Icon(MdiIcons.beer),
                          trailing: Icon(MdiIcons.noteEdit),
                          title:
                              Text('Millimiters : ${data[alcoolIndex].volume},   % : ${data[alcoolIndex].percentage}'),
                          subtitle: Text('Hour: ${data[alcoolIndex].hour}'),
                          //${Formats.fullDateFormatNoSeconds.format(data[alcoolIndex].dateTime)}'),
                          //When a ListTile is tapped, the user is redirected to the MealPage, where it will be able to edit it.
                          onTap: () => _toMealPage(context, data[alcoolIndex]),
                        ),
                      );
                    });
                }//if
                else{
                  return CircularProgressIndicator();
                }//else
              },//FutureBuilder builder 
            );
          }//Consumer-builder
        ),
      ),
      //Here, I'm using a FAB to let the user add new meals.
      //Rationale: I'm using null as meal to let MealPage know that we want to add a new meal.
      floatingActionButton: FloatingActionButton(
        child: Icon(MdiIcons.plus),
        onPressed: () => _toMealPage(context, null),
      ),
    );
  } //build

  //Utility method to navigate to MealPage
  void _toMealPage(BuildContext context, Alcool? nalcool) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => addAlcool(new_alcool: nalcool,)));
  } //_toMealPage
} //HomePage
*/