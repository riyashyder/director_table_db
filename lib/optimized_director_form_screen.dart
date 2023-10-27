import 'package:flutter/material.dart';
import 'package:task_db_project/director_details_model.dart';
import 'package:task_db_project/director_list_screen.dart';


import 'database_helper.dart';
import 'main.dart';

class OptimizedDirectorFormScreen extends StatefulWidget {
  const OptimizedDirectorFormScreen({super.key});

  @override
  State<OptimizedDirectorFormScreen> createState() =>
      _OptimizedDirectorFormScreenState();
}

class _OptimizedDirectorFormScreenState
    extends State<OptimizedDirectorFormScreen> {
  var _companyNameController = TextEditingController();
  var _panNoController = TextEditingController();
  var _gstinController = TextEditingController();
  var _offaddController = TextEditingController();
  var _diraddController = TextEditingController();

  //Edit option
  bool firstTimeFlag = false;
  int _selectedId = 0;

  //optimized

  String buttonText = 'Save';

  @override
  Widget build(BuildContext context) {
    //Edit Data
    if (firstTimeFlag == false) {
      print('-------->once Execute');

      firstTimeFlag = true;

      final directorDetail = ModalRoute.of(context)!.settings.arguments;

      if (directorDetail == null) {
        print('-------->FAB: Insert/Save:');
      } else {
        print('------->ListView: Received Data: Edit/Delete');

        directorDetail as DirectorDetailsModel;

        print('------->Received Data');

        print(directorDetail.id);
        print(directorDetail.companyName);
        print(directorDetail.panNo);
        print(directorDetail.gstin);
        print(directorDetail.offadd);
        print(directorDetail.diradd);

        _selectedId = directorDetail.id!;
        buttonText = 'Update';

        _companyNameController.text = directorDetail.companyName;
        _panNoController.text = directorDetail.panNo;
        _gstinController.text = directorDetail.gstin;
        _offaddController.text = directorDetail.offadd;
        _diraddController.text = directorDetail.diradd;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Director Details Form'),
        actions: _selectedId == 0 ? null : [
          PopupMenuButton<int>(
            itemBuilder: (context) => [
              PopupMenuItem(value: 1, child: Text('Delete')),
            ],
            elevation: 2,
            onSelected: (value) {
              if (value == 1) {
                _deleteFormDialog(context);
              }
            },
          )
        ],
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              children: [
                TextFormField(
                  controller: _companyNameController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(),
                      ),
                      labelText: 'Company Name',
                      hintText: 'Enter Company Name'),
                ),
                SizedBox(
                  height: 30,
                ),
                TextFormField(
                  controller: _panNoController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(),
                      ),
                      labelText: 'Director Pan No',
                      hintText: 'Enter Director Pan No'),
                ),
                SizedBox(
                  height: 30,
                ),
                TextFormField(
                  controller: _gstinController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(),
                      ),
                      labelText: 'GSTIN',
                      hintText: 'Enter GSTIN Code'),
                ),
                SizedBox(
                  height: 30,
                ),
                TextFormField(
                  controller: _offaddController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(),
                      ),
                      labelText: 'Office Address',
                      hintText: 'Enter Office Address'),
                ),
                SizedBox(
                  height: 30,
                ),
                TextFormField(
                  controller: _diraddController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(),
                      ),
                      labelText: 'Director Address',
                      hintText: 'Enter Director Address'),
                ),
                SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                  onPressed: () {
                    print('-------------->Button Clicked');
                    if(_selectedId ==0){
                      print('---------->Save');
                      _save();
                    }else{
                      print('---------->Update');
                      _update();
                    }

                  },
                  child: Text(buttonText),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
  _deleteFormDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (param) {
          return AlertDialog(
            actions: <Widget>[
              ElevatedButton(
                onPressed: () {
                  print('--------->Cancel Button Clicked');
                  Navigator.pop(context);
                },
                child: Text('Cancel'),),
              ElevatedButton(onPressed: (){
                print('----------->Delete Button Clicked');
                _delete();
              }, child: Text('Delete'))
            ],
            title: Text('Are You Sure You Want To Delete this?'),
          );
        });
  }


  void _save() async {
    print('--------------> _save');
    print('--------------> Company Name: ${_companyNameController.text}');
    print('--------------> Pan No: ${_panNoController.text}');
    print('--------------> GSTIN ID: ${_gstinController.text}');
    print('--------------> Office Address: ${_offaddController.text}');
    print('--------------> Director Address: ${_diraddController.text}');

    Map<String, dynamic> row = {
      DatabaseHelper.colCompanyName: _companyNameController.text,
      DatabaseHelper.colPanNo: _panNoController.text,
      DatabaseHelper.colgstin: _gstinController.text,
      DatabaseHelper.coloffaddress: _offaddController.text,
      DatabaseHelper.coldiraddress: _diraddController.text,
    };

    final result = await dbHelper.insertDirectorDetails(
        row, DatabaseHelper.directorTable);

    debugPrint('--------> Inserted Row Id: $result');
    if (result > 0) {
      Navigator.pop(context);
      _showSuccessSnackBar(context, 'Saved');
    }
    setState(() {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => DirectorListScreen()));
    });
  }
  void _update() async{
    print('------------>Update');
    print('------------>Selected ID:$_selectedId');
    print('--------------> Company Name: ${_companyNameController.text}');
    print('--------------> Pan No: ${_panNoController.text}');
    print('--------------> GSTIN Code: ${_gstinController.text}');
    print('--------------> Office Address: ${_offaddController.text}');
    print('--------------> Director Address: ${_diraddController.text}');

    Map<String, dynamic> row = {
      // edit
      DatabaseHelper.colId: _selectedId,

      DatabaseHelper.colCompanyName: _companyNameController.text,
      DatabaseHelper.colPanNo: _panNoController.text,
      DatabaseHelper.colgstin: _gstinController.text,
      DatabaseHelper.coloffaddress: _offaddController.text,
      DatabaseHelper.coldiraddress: _diraddController.text,
    };
    final result = await dbHelper.updateDirectorDetails(row, DatabaseHelper.directorTable);

    debugPrint('------------>Updated Row Id : $result');

    if(result>0){
      Navigator.pop(context);
      _showSuccessSnackBar(context, 'Updated');
    }
    setState(() {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>DirectorListScreen()));
    });
  }

  void _showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(new SnackBar(content: new Text(message)));
  }

  void _delete() async{
    print('------------>_delete');

    final result = await dbHelper.deleteDirectorDetails(_selectedId,DatabaseHelper.directorTable);

    debugPrint('-------------->Deleted Row Id: $result');

    if(result>0){
      _showSuccessSnackBar(context, 'Deleted');
      Navigator.pop(context);
    }
    setState(() {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>DirectorListScreen()));
    });

  }


}


