import 'package:flutter/material.dart';
import 'package:task_db_project/director_details_model.dart';

import 'database_helper.dart';
import 'main.dart';
import 'optimized_director_form_screen.dart';

class DirectorListScreen extends StatefulWidget {
  const DirectorListScreen({super.key});

  @override
  State<DirectorListScreen> createState() => _DirectorListScreenState();
}

class _DirectorListScreenState extends State<DirectorListScreen> {
  late List<DirectorDetailsModel> _directorDetailsList;

  @override
  void initState() {
    super.initState();
    getAllDirectorDetails();
  }

  getAllDirectorDetails() async {
    _directorDetailsList = <DirectorDetailsModel>[];
    var studentDetailRecords =
        await dbHelper.queryAllRows(DatabaseHelper.directorTable);

    studentDetailRecords.forEach((directorDetail) {
      setState(() {
        print(directorDetail['_id']);
        print(directorDetail['_companyName']);
        print(directorDetail['_panNo']);
        print(directorDetail['_gstin']);
        print(directorDetail['_offaddress']);
        print(directorDetail['_diraddress']);

        var directorDetailsModel = DirectorDetailsModel(
          directorDetail['_id'],
          directorDetail['_companyName'],
          directorDetail['_panNo'],
          directorDetail['_gstin'],
          directorDetail['_offaddress'],
          directorDetail['_diraddress'],
        );
        _directorDetailsList.add(directorDetailsModel);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Director Details'),
      ),
      body: Container(
        child: ListView.builder(
            itemCount: _directorDetailsList.length,
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                onTap: () {
                  print('---------->Edit or Deleted Invoked : Send Data');
                  print(_directorDetailsList[index].id);
                  print(_directorDetailsList[index].companyName);
                  print(_directorDetailsList[index].panNo);
                  print(_directorDetailsList[index].gstin);
                  print(_directorDetailsList[index].offadd);
                  print(_directorDetailsList[index].diradd);

                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => OptimizedDirectorFormScreen(),
                    settings: RouteSettings(
                      arguments: _directorDetailsList[index],
                    ),
                  ));
                },
                child: ListTile(
                  title: Text(_directorDetailsList[index].companyName),
                ),
              );
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('--------------> Launch Director Details Form Screen');
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => OptimizedDirectorFormScreen()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
