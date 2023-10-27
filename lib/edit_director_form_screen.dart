import 'package:flutter/material.dart';
import 'package:task_db_project/director_details_model.dart';
import 'package:task_db_project/director_list_screen.dart';


import 'database_helper.dart';
import 'main.dart';


class EditDirectorFormScreen extends StatefulWidget {
  const EditDirectorFormScreen({super.key});

  @override
  State<EditDirectorFormScreen> createState() => _EditDirectorFormScreenState();
}

class _EditDirectorFormScreenState extends State<EditDirectorFormScreen> {
  var _companyNameController = TextEditingController();
  var _panNoController = TextEditingController();
  var _gstinController = TextEditingController();
  var _offaddController = TextEditingController();
  var _diraddController = TextEditingController();


  bool firstTimeFlag = false;
  int _selectedId = 0;

  @override
  Widget build(BuildContext context) {
    if (firstTimeFlag == false) {
      print('-------->once Execute');
      firstTimeFlag = true;

      final directorDetail =
      ModalRoute.of(context)!.settings.arguments as DirectorDetailsModel;

      print('-------------->Received Data');
      print(directorDetail.id);
      print(directorDetail.companyName);
      print(directorDetail.panNo);
      print(directorDetail.gstin);
      print(directorDetail.offadd);
      print(directorDetail.diradd);

      _selectedId = directorDetail.id!;

      _companyNameController.text = directorDetail.companyName;
      _panNoController.text = directorDetail.panNo;
      _gstinController.text = directorDetail.gstin;
      _offaddController.text = directorDetail.offadd;
      _diraddController.text = directorDetail.diradd;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Director Details Form'),
        backgroundColor: Colors.blue,
        actions: [
          PopupMenuButton<int>(
            itemBuilder: (context) => [
              PopupMenuItem(value: 1, child: Text("Delete")),
            ],
            elevation: 2,
            onSelected: (value) {
              if (value == 1) {
                print('Delete option clicked');
                _deleteFormDialog(context);
              }
            },
          ),
        ],
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
                    print('--------------> update Button Clicked');
                    _update();
                  },
                  child: Text('Update'),
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
                  print('--------------> Cancel Button Clicked');
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  print('--------------> Delete Button Clicked');
                  _delete();
                },
                child: const Text('Delete'),
              )
            ],
            title: const Text('Are you sure you want to delete this?'),
          );
        });
  }

  void _update() async {
    print('--------------> _update');
    print('--------------> Selected ID : $_selectedId');
    print('--------------> Company Name: ${_companyNameController.text}');
    print('--------------> Pan No: ${_panNoController.text}');
    print('--------------> GSTIN Code: ${_gstinController.text}');
    print('--------------> Office Address: ${_offaddController.text}');
    print('--------------> Director Address: ${_diraddController.text}');

    Map<String, dynamic> row = {
      DatabaseHelper.colId: _selectedId,
      DatabaseHelper.colCompanyName: _companyNameController.text,
      DatabaseHelper.colPanNo: _panNoController.text,
      DatabaseHelper.colgstin: _gstinController.text,
      DatabaseHelper.coloffaddress: _offaddController.text,
      DatabaseHelper.coldiraddress: _diraddController.text,
    };

    final result = await dbHelper.updateDirectorDetails(
        row, DatabaseHelper.directorTable);

    debugPrint('--------> Updated Row Id: $result');

    if (result > 0) {
      Navigator.pop(context);
      _showSuccessSnackBar(context, 'Updated');
    }
    setState(() {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => DirectorListScreen()));
    });
  }

  void _showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(new SnackBar(content: new Text(message)));
  }
  void _delete() async{
    print('--------------> _delete');

    final result = await dbHelper.deleteDirectorDetails(_selectedId, DatabaseHelper.directorTable);

    debugPrint('-----------------> Deleted Row Id: $result');

    if (result > 0) {
      _showSuccessSnackBar(context, 'Deleted.');
      Navigator.pop(context);
    }

    setState(() {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => DirectorListScreen()));
    });
  }
}
