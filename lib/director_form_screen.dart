import 'package:flutter/material.dart';
import 'package:task_db_project/director_list_screen.dart';


import 'database_helper.dart';
import 'main.dart';

class DirectorFormScreen extends StatefulWidget {
  const DirectorFormScreen({super.key});

  @override
  State<DirectorFormScreen> createState() => _DirectorFormScreenState();
}

class _DirectorFormScreenState extends State<DirectorFormScreen> {
  var _companyNameController = TextEditingController();
  var _panNoController = TextEditingController();
  var _gstinController = TextEditingController();
  var _offaddController = TextEditingController();
  var _diraddController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Details Form'),
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
                    print('--------------> Save Button Clicked');
                    _save();
                  },
                  child: Text('Save'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _save() async {
    print('--------------> _save');
    print('--------------> Company Name: ${_companyNameController.text}');
    print('--------------> Pan No: ${_panNoController.text}');
    print('--------------> GSTIN code: ${_gstinController.text}');
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

  void _showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(new SnackBar(content: new Text(message)));
  }
}
