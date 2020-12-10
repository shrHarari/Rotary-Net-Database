import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rotary_database/database/init_database_service.dart';
import 'package:rotary_database/screens/data_setting_pages/data_setting_area.dart';
import 'package:rotary_database/screens/data_setting_pages/data_setting_club.dart';
import 'package:rotary_database/screens/data_setting_pages/data_setting_cluster.dart';
import 'package:rotary_database/screens/data_setting_pages/data_setting_role.dart';
import 'package:rotary_database/screens/main_screen_pages/application_setting_screen.dart';
import 'package:rotary_database/shared/constants.dart' as Constants;

class MainPageScreen extends StatefulWidget {
  static const routeName = '/MainPageScreen';

  @override
  _MainPageScreen createState() => _MainPageScreen();
}

class _MainPageScreen extends State<MainPageScreen> with SingleTickerProviderStateMixin {

  String appBarTitle = 'ניהול בסיס הנתונים';
  TabController _tabController;
  bool newApplicationType;
  bool newApplicationRunningMode;
  bool isFirst = true;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 4,
      vsync: this,
    );
  }

  //#region Open Application Settings
  Future<void> openApplicationSettings() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ApplicationSettingsScreen(),
      ),
    );
  }
  //#endregion

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],

      body: Column(
        children: [
          Container(
            height: 100.0,
            color: Colors.blue,
              child: SafeArea(
                child: Stack(
                  children: <Widget>[
                    Center(
                      child: Text(Constants.rotaryApplicationName,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    /// ----------- Header - Application Menu -----------------
                    Align(
                        alignment: Alignment.centerRight,
                        child: buildApplicationMenuRow()),
                ],
              ),
            ),
          ),
          Expanded(
              child: buildMainScaffoldBody()
          ),
        ],
      ),
    );
  }

  Widget buildMainScaffoldBody() {
    var radius = Radius.circular(5);
    return Container(
      child:
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 20.0, left: 0.0, right: 0.0, bottom: 10.0),
            child: buildDividerSection('INIT DATA BASE'),
          ),

          Padding(
            padding: const EdgeInsets.only(top: 0.0, left: 80.0, right: 80.0, bottom: 10.0),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: RaisedButton(
                      elevation: 0.0,
                      disabledElevation: 0.0,
                      color: Colors.blue,
                      child: Text(
                        'Init Rotary DB',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        initDatabaseService();
                      }
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 10.0,),
          buildDividerSection('DATA BASE TABLES'),

          Padding(
            padding: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0, bottom: 0.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TabBar(
                  controller: _tabController,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.grey,
                  // indicatorColor: Colors.white,
                  labelStyle: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),   //For Selected tab
                  unselectedLabelStyle: TextStyle(fontSize: 14.0),                      //For Un-selected Tabs
                  tabs: <Widget>[
                    Tab(text :"תפקיד"),
                    Tab(text :"אזור"),
                    Tab(text :"אשכול"),
                    Tab(text :"מועדון"),
                  ],
                  indicator: ShapeDecoration(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: radius, topLeft: radius)),
                      color: Colors.lightBlue[700]
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                /// --------------- TAB: Role ---------------------
                DataSettingRole(),
                /// --------------- TAB: Area ---------------------
                DataSettingArea(),
                /// --------------- TAB: Cluster ------------------
                DataSettingCluster(),
                /// --------------- TAB: Club ---------------------
                DataSettingClub(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //#region Build Application Menu Row
  Widget buildApplicationMenuRow() {
    /// ----------- Header - Application Menu -----------------
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        /// Back Icon --->>> Back to previous screen
        Padding(
          padding: const EdgeInsets.only(left: 0.0, top: 0.0, right: 20.0, bottom: 0.0),
          child: IconButton(
            icon: Icon(Icons.build, color: Colors.white),
            onPressed: () async {
              await openApplicationSettings();
            },
          ),
        ),
      ],
    );
  }
  //# endregion

  //#region Build Divider Section
  Widget buildDividerSection(String aSectionTitle) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 5,
          child: Divider(
            color: Colors.grey[600],
            thickness: 2.0,
          ),
        ),
        Expanded(
          flex: 9,
          child: Text(
            aSectionTitle,
            style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16.0,
                fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          flex: 5,
          child: Divider(
            color: Colors.grey[600],
            thickness: 2.0,
          ),
        ),
      ],
    );
  }
  //#endregion

  //# region Init Database Service
  Future initDatabaseService() async {
    print('Data Base Initializing ..........');
    InitDatabaseService _initDatabaseService = InitDatabaseService();
    // await _initDatabaseService.insertAllStartedRotaryRoleToDb();
    // await _initDatabaseService.insertAllStartedRotaryAreaToDb();
    // await _initDatabaseService.insertAllStartedRotaryClusterToDb();
    // await _initDatabaseService.insertAllStartedRotaryClubToDb();
    //
    // await _initDatabaseService.insertAllStartedUsersToDb();
    // await _initDatabaseService.insertAllStartedPersonCardsToDb();
    // await _initDatabaseService.insertAllStartedEventsToDb();
  }
//#endregion
}
