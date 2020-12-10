import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rotary_database/objects/connected_user_object.dart';
import 'package:rotary_database/services/globals_service.dart';
import 'package:rotary_database/shared/loading.dart';
import 'package:rotary_database/shared/constants.dart' as Constants;

class ApplicationSettingsScreen extends StatefulWidget {
  static const routeName = '/ApplicationSettingsScreen';

  @override
  _ApplicationSettingsScreen createState() => _ApplicationSettingsScreen();
}

class _ApplicationSettingsScreen extends State<ApplicationSettingsScreen> {

  Future<DataRequiredForBuild> dataRequiredForBuild;
  DataRequiredForBuild currentDataRequired;

  String appBarTitle = 'הגדרות מערכת';
  bool newApplicationType;
  bool newApplicationRunningMode;
  bool isFirst = true;
  bool loading = true;

  @override
  void initState() {
    dataRequiredForBuild = getAllRequiredDataForBuild();
    super.initState();
  }

  //#region Get All Required Data For Build
  Future<DataRequiredForBuild> getAllRequiredDataForBuild() async {
    setState(() {
      loading = true;
    });

    setState(() {
      loading = false;
    });

    return DataRequiredForBuild(
      connectedUserObj: null,
    );
  }
  //#endregion

  //#region Update Application Type
  updateApplicationType(bool aApplicationType) async {
    GlobalsService.setApplicationType(aApplicationType);
    GlobalsService.writeApplicationTypeToSP(aApplicationType);
  }
  //#endregion

  //#region Update Application RunningMode
  void updateApplicationRunningMode(bool aApplicationRunningMode) {
    GlobalsService.setApplicationRunningMode(aApplicationRunningMode);
    GlobalsService.writeApplicationRunningModeToSP(aApplicationRunningMode);
  }
  //#endregion

  //#region Exit From App
  void exitFromApp() {
    exit(0);
  }
  //#endregion

  @override
  Widget build(BuildContext context) {

    // Initial Value
    if (isFirst){
      newApplicationType = GlobalsService.applicationType;
      newApplicationRunningMode = GlobalsService.applicationRunningMode;
      isFirst = false;
    }

    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        backgroundColor: Colors.blue[500],
        elevation: 5.0,
        title: Text(appBarTitle),
      ),

      body: FutureBuilder<DataRequiredForBuild>(
          future: dataRequiredForBuild,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return Loading();
            else {
              currentDataRequired = snapshot.data;
              return buildMainScaffoldBody();
            }
          }
      ),
    );
  }

  Widget buildMainScaffoldBody() {
    return Center(
      child: Container(
        child:
        Padding(
          padding: const EdgeInsets.only(top: 20.0, left: 50.0, right: 50.0, bottom: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(height: 40.0,),

              ///============ Application SETTINGS ============
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    child: Divider(
                      color: Colors.grey[600],
                      thickness: 2.0,
                    ),
                  ),
                  Expanded(
                    flex: 9,
                    child: Text (
                      'Application Settings',
                      style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Divider(
                      color: Colors.grey[600],
                      thickness: 2.0,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.0,),

              Row(
                children: <Widget>[
                  Expanded(
                    flex: 6,
                    child: Text(
                      'Application Type:',
                      style: TextStyle(
                          color: Colors.blue[800],
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    child: Text(
                      'Client',
                      style: TextStyle(
                          color: Colors.blue[800],
                          fontSize: 16.0),
                      textAlign: TextAlign.right,
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Switch(
                      value: newApplicationType,
                      onChanged: (bool newValue) async  {
                        updateApplicationType(newValue);
                        setState(() {
                          newApplicationType = newValue;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      'Network',
                      style: TextStyle(
                          color: Colors.blue[800],
                          fontSize: 16.0),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.0,),

              Row(
                children: <Widget>[
                  Expanded(
                    flex: 6,
                    child: Text(
                      'Application Running Mode:',
                      style: TextStyle(
                          color: Colors.blue[800],
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),

              Row(
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    child: Text(
                      'Debug',
                      style: TextStyle(
                          color: Colors.blue[800],
                          fontSize: 16.0),
                      textAlign: TextAlign.right,
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Switch(
                      value: newApplicationRunningMode,
                      onChanged: (bool newValue) {
                        updateApplicationRunningMode(newValue);
                        setState(() {
                          newApplicationRunningMode = newValue;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      'Production',
                      style: TextStyle(
                          color: Colors.blue[800],
                          fontSize: 16.0),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DataRequiredForBuild {
  ConnectedUserObject connectedUserObj;

  DataRequiredForBuild({
    this.connectedUserObj,
  });
}