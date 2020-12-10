import 'package:flutter/material.dart';
import 'package:rotary_database/services/globals_service.dart';
import 'package:rotary_database/services/route_generator_service.dart';
import 'package:rotary_database/shared/constants.dart' as Constants;

void main() => runApp(RotaryDataBaseApp());

class RotaryDataBaseApp extends StatelessWidget {

  //#region Get All Required Data For Build
  Future<DataRequiredForBuild> getAllRequiredDataForBuild() async {

    /// Call Global first ===>>> Initiate Logger
    await initializeGlobalValues();
    return DataRequiredForBuild(
      rotaryRolesEnum: null,
      personCardAvatarImageUrl: null,
    );
  }
  //#endregion

  //#region Initialize Global Values [ApplicationType, ApplicationRunningMode]
  Future initializeGlobalValues() async {
    bool _applicationType = await GlobalsService.readApplicationTypeFromSP();
    await GlobalsService.setApplicationType(_applicationType);

    bool _applicationRunningMode = await GlobalsService.readApplicationRunningModeFromSP();
    await GlobalsService.setApplicationRunningMode(_applicationRunningMode);
  }
  //#endregion

  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
        future: getAllRequiredDataForBuild(),
        builder: ((context, snapshot){
          if (snapshot.hasData) {
            return MaterialApp(
              title: 'Rotary DataBase',
              initialRoute: '/',
              onGenerateRoute: RouteGenerator.generateRoute,
            );
          } else {
            // return CircularProgressIndicator(strokeWidth: 10,);
            // return Loading();
            return Container(
              color: Colors.lightBlue[50],
            );
          }
        })
    );
  }
}

class DataRequiredForBuild {
  Constants.RotaryRolesEnum rotaryRolesEnum;
  String personCardAvatarImageUrl;

  DataRequiredForBuild({
    this.rotaryRolesEnum,
    this.personCardAvatarImageUrl
  });
}