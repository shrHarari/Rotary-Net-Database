import 'dart:io';
import 'package:flutter/material.dart';
import 'package:rotary_database/objects/person_card_role_and_hierarchy_object.dart';
import 'package:rotary_database/objects/rotary_area_object.dart';
import 'package:rotary_database/objects/rotary_club_object.dart';
import 'package:rotary_database/objects/rotary_cluster_object.dart';
import 'package:rotary_database/services/rotary_area_service.dart';
import 'package:rotary_database/services/rotary_club_service.dart';
import 'package:rotary_database/services/rotary_cluster_service.dart';
import 'package:rotary_database/shared/action_button_decoration.dart';
import 'package:rotary_database/shared/data_setting_divider.dart';
import 'package:rotary_database/shared/decoration_style.dart';
import 'package:rotary_database/shared/error_message_screen.dart';
import 'package:rotary_database/shared/loading.dart';

class DataSettingClub extends StatefulWidget {

  @override
  _DataSettingClubState createState() => _DataSettingClubState();
}

class _DataSettingClubState extends State<DataSettingClub> {

  final RotaryClubService rotaryClubService = RotaryClubService();
  final formKey = GlobalKey<FormState>();

  //#region Declare Variables
  Future<PersonCardRoleAndHierarchyListObject> personCardRoleAndHierarchyListObjectForBuild;
  PersonCardRoleAndHierarchyListObject displayPersonCardRoleAndHierarchyListObject;

  TextEditingController clubNameController;
  TextEditingController clubAddressController;
  TextEditingController clubMailController;
  TextEditingController clubManagerIdController;

  String displayMessage = '';
  bool loading = false;
  //#endregion

  @override
  void initState() {
    setVariables();
    personCardRoleAndHierarchyListObjectForBuild = getPersonCardRoleAndHierarchyListForBuild();

    super.initState();
  }

  //#region Set Variables
  Future<void> setVariables() async {
    clubNameController = TextEditingController(text: '');
    clubAddressController = TextEditingController(text: '');
    clubMailController = TextEditingController(text: '');
    clubManagerIdController = TextEditingController(text: '');
  }
  //#endregion

  //#region Get PersonCard Role And Hierarchy List For Build
  Future<PersonCardRoleAndHierarchyListObject> getPersonCardRoleAndHierarchyListForBuild() async {

    //////////////////////////////// Rotary Area
    RotaryAreaService _rotaryAreaService = RotaryAreaService();
    List<RotaryAreaObject> _rotaryAreaObjList = await _rotaryAreaService.getAllRotaryAreaList();
    setRotaryAreaDropdownMenuItems(_rotaryAreaObjList);

    // //////////////////////////////// Rotary Cluster
    RotaryClusterService _rotaryClusterService = RotaryClusterService();
    List<RotaryClusterObject> _rotaryClusterObjList = await _rotaryClusterService.getAllRotaryClusterList();
    setRotaryClusterDropdownMenuItems(null, _rotaryClusterObjList);

    // //////////////////////////////// Rotary Club
    RotaryClubService _rotaryClubService = RotaryClubService();
    List<RotaryClubObject> _rotaryClubObjList = await _rotaryClubService.getAllRotaryClubList();
    setRotaryClubDropdownMenuItems(null, _rotaryClubObjList);

    return PersonCardRoleAndHierarchyListObject(
      rotaryAreaObjectList: _rotaryAreaObjList,
      rotaryClusterObjectList: _rotaryClusterObjList,
      rotaryClubObjectList: _rotaryClubObjList,
    );
  }
  //#endregion

  //#region All DropDown UI Objects

  //#region RotaryArea DropDown
  List<DropdownMenuItem<RotaryAreaObject>> dropdownRotaryAreaItems;
  RotaryAreaObject selectedRotaryAreaObj;

  void setRotaryAreaDropdownMenuItems(List<RotaryAreaObject> aRotaryAreaObjectsList) {
    List<DropdownMenuItem<RotaryAreaObject>> _rotaryAreaDropDownItems = List();
    for (RotaryAreaObject _rotaryAreaObj in aRotaryAreaObjectsList) {
      _rotaryAreaDropDownItems.add(
        DropdownMenuItem(
          child: SizedBox(
            width: 100.0,
            child: Text(
              _rotaryAreaObj.areaName,
              textAlign: TextAlign.right,
            ),
          ),
          value: _rotaryAreaObj,
        ),
      );
    }
    dropdownRotaryAreaItems = _rotaryAreaDropDownItems;
  }

  onChangeDropdownRotaryAreaItem(RotaryAreaObject aSelectedRotaryAreaObject) {
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() {
      selectedRotaryAreaObj = aSelectedRotaryAreaObject;
      filterRotaryClusterDropdownMenuItems(aSelectedRotaryAreaObject.clusters, null);
      filterRotaryClubDropdownMenuItems(null, null);
    });
  }
  //#endregion

  //#region RotaryCluster DropDown
  List<DropdownMenuItem<RotaryClusterObject>> dropdownRotaryClusterItems;
  List<DropdownMenuItem<RotaryClusterObject>> dropdownRotaryClusterFilteredItems;
  RotaryClusterObject selectedRotaryClusterObj;

  void setRotaryClusterDropdownMenuItems(List<String> aClustersOfArea, List<RotaryClusterObject> aRotaryClusterObjectsList) {
    List<DropdownMenuItem<RotaryClusterObject>> _rotaryClusterDropDownItems = List();
    for (RotaryClusterObject _rotaryClusterObj in aRotaryClusterObjectsList) {
      _rotaryClusterDropDownItems.add(
        DropdownMenuItem(
          child: SizedBox(
            width: 100.0,
            child: Text(
              _rotaryClusterObj.clusterName,
              textAlign: TextAlign.right,
            ),
          ),
          value: _rotaryClusterObj,
        ),
      );
    }
    dropdownRotaryClusterItems = _rotaryClusterDropDownItems;
    filterRotaryClusterDropdownMenuItems(aClustersOfArea, null);
  }

  void filterRotaryClusterDropdownMenuItems(List<String> aClustersOfArea, String aClusterId) {
    // Filter list & Find the ClusterObject Element in a ClusterList By clusterId ===>>> Set DropDown Initial Value
    int _initialListIndex;

    if (aClustersOfArea != null)
      dropdownRotaryClusterFilteredItems = dropdownRotaryClusterItems.where((item) =>
          aClustersOfArea.contains(item.value.clusterId)).toList();

    if (aClusterId != null) {
      _initialListIndex = dropdownRotaryClusterFilteredItems.indexWhere((listElement) =>
      (listElement.value.clusterId == aClusterId));
      selectedRotaryClusterObj = dropdownRotaryClusterFilteredItems[_initialListIndex].value;
    } else {
      _initialListIndex = null;
      selectedRotaryClusterObj = null;
    }
  }

  onChangeDropdownRotaryClusterItem(RotaryClusterObject aSelectedRotaryClusterObject) {
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() {
      selectedRotaryClusterObj = aSelectedRotaryClusterObject;
      filterRotaryClubDropdownMenuItems(aSelectedRotaryClusterObject.clubs, null);
    });
  }
  //#endregion

  //#region RotaryClub DropDown
  List<DropdownMenuItem<RotaryClubObject>> dropdownRotaryClubItems;
  List<DropdownMenuItem<RotaryClubObject>> dropdownRotaryClubFilteredItems;
  RotaryClubObject selectedRotaryClubObj;

  void setRotaryClubDropdownMenuItems(List<String> aClubsOfCluster, List<RotaryClubObject> aRotaryClubObjectsList) {
    List<DropdownMenuItem<RotaryClubObject>> _rotaryClubDropDownItems = List();
    for (RotaryClubObject _rotaryClubObj in aRotaryClubObjectsList) {
      _rotaryClubDropDownItems.add(
        DropdownMenuItem(
          child: SizedBox(
            width: 100.0,
            child: Text(
              _rotaryClubObj.clubName,
              textAlign: TextAlign.right,
            ),
          ),
          value: _rotaryClubObj,
        ),
      );
    }
    dropdownRotaryClubItems = _rotaryClubDropDownItems;
    filterRotaryClubDropdownMenuItems(aClubsOfCluster, null);
  }

  void filterRotaryClubDropdownMenuItems(List<String> aClubsOfCluster, String aClubId) {
    // Filter list & Find the ClubObject Element in a ClubList By clubId ===>>> Set DropDown Initial Value
    int _initialListIndex;

    if (aClubsOfCluster != null) {
      dropdownRotaryClubFilteredItems = dropdownRotaryClubItems.where((item) =>
          aClubsOfCluster.contains(item.value.clubId)).toList();

      if (aClubId != null) {
        _initialListIndex = dropdownRotaryClubFilteredItems.indexWhere((listElement) =>
        (listElement.value.clubId == aClubId));
        selectedRotaryClubObj = dropdownRotaryClubFilteredItems[_initialListIndex].value;
      } else {
        _initialListIndex = null;
        selectedRotaryClubObj = null;
      }
    } else {
      _initialListIndex = null;
      dropdownRotaryClubFilteredItems = [];
      selectedRotaryClubObj = null;
    }
  }

  onChangeDropdownRotaryClubItem(RotaryClubObject aSelectedRotaryClubObject) {
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() {
      selectedRotaryClubObj = aSelectedRotaryClubObject;
    });
  }
  //#endregion

  //#endregion

  //#region Check Validation
  Future<bool> checkValidation() async {
    bool validationVal = false;

    if (formKey.currentState.validate()){
      validationVal = true;
    }
    return validationVal;
  }
  //#endregion

  //#region Add Data Table Club
  Future addDataTableClub() async {

    setState(() {loading = true;});

    bool validationVal = await checkValidation();

    if (validationVal){

      String _clubName = (clubNameController.text != null) ? (clubNameController.text) : '';
      String _clubAddress = (clubAddressController.text != null) ? (clubAddressController.text) : '';
      String _clubMail = (clubMailController.text != null) ? (clubMailController.text) : '';
      String _clubManagerId = (clubManagerIdController.text != null) ? (clubManagerIdController.text) : '';

      RotaryClubObject newRotaryClubObject =
      rotaryClubService.createRotaryClubAsObject(
          '', _clubName, _clubAddress, _clubMail, _clubManagerId);

      bool returnVal = await rotaryClubService.insertRotaryClubWithCluster(selectedRotaryClusterObj.clusterId, newRotaryClubObject);

      if ((returnVal) ){
        setState(() {
          displayMessage = 'מועדון חדש הוגדר בהצלחה';
        });
      } else {
        setState(() {
          displayMessage = 'עדכון נתוני המועדון נכשל, נסה שנית';
        });
      }
    }
    setState(() {loading = false;});
  }
  //#endregion

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() :
    FutureBuilder<PersonCardRoleAndHierarchyListObject>(
        future: personCardRoleAndHierarchyListObjectForBuild,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Loading();
          else
          if (snapshot.hasError) {
            return RotaryErrorMessageScreen(
              errTitle: 'שגיאה בשליפת נתונים',
              errMsg: 'אנא פנה למנהל המערכת',
            );
          } else {
            if (snapshot.hasData)
            {
              displayPersonCardRoleAndHierarchyListObject = snapshot.data;
              return buildMainBody();
            }
            else
              return Center(child: Text('כרטיס ביקור חסר'));
          }
        }
    );
  }

  Widget buildMainBody() {
    return Column(
      children: <Widget>[
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Form(
              key: formKey,
              child: Column(
                children: <Widget>[
                  /// ------------------- Input Text Fields ----------------------
                  buildDropDownRoleAndHierarchy(),

                  Padding(
                    padding: EdgeInsets.only(left: 10, top: 20.0, right: 10.0, bottom: 0.0),
                    child: DataSettingDivider(argSectionTitle: 'פרטי מועדון חדש להוספה'),
                  ),

                  Padding(
                    padding: EdgeInsets.only(left: 40, top: 10.0, right: 20.0, bottom: 0.0),
                    child: buildEnabledTextInputWithImageIcon(clubNameController, 'שם המועדון', Icons.house, aValidation: true),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 40, top: 10.0, right: 20.0, bottom: 0.0),
                    child: buildEnabledTextInputWithImageIcon(clubAddressController, 'כתובת', Icons.location_on, aValidation: true),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 40, top: 10.0, right: 20.0, bottom: 0.0),
                    child: buildEnabledTextInputWithImageIcon(clubMailController, 'דוא"ל', Icons.mail, aValidation: true),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 40, top: 10.0, right: 20.0, bottom: 0.0),
                    child: buildEnabledTextInputWithImageIcon(clubManagerIdController, 'מנהל המועדון', Icons.person, aValidation: true),
                  ),

                  /// ---------------------- Display Error -----------------------
                  Text(
                    displayMessage,
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 14.0
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        buildActionButton('הוספה', Icons.save, addDataTableClub),
      ],
    );
  }

  //#region INPUT FIELDS

  //#region buildEnabledTextInputWithImageIcon
  Widget buildEnabledTextInputWithImageIcon(
      TextEditingController aController,
      String textInputName, IconData aIcon,
      {bool aMultiLine = false, bool aEnabled = true, bool aValidation = false}) {
    return Row(
        textDirection: TextDirection.rtl,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 3,
            child: Container(
                child: buildImageIconForTextField(aIcon)
            ),
          ),

          Expanded(
            flex: 12,
            child:
            Container(
              child: buildTextFormField(aController, textInputName,
                  aMultiLine: aMultiLine,aEnabled: aEnabled, aValidation: aValidation),
            ),
          ),
        ]
    );
  }
  //#endregion

  //#region buildImageIconForTextField
  MaterialButton buildImageIconForTextField(IconData aIcon) {
    return MaterialButton(
      onPressed: () {},
      shape: CircleBorder(
          side: BorderSide(color: Colors.blue)
      ),
      child:
      IconTheme(
        data: IconThemeData(
            color: Colors.blue[500]
        ),
        child: Icon(
          aIcon,
          size: 20,
        ),
      ),
    );
  }
  //#endregion

  //region buildTextFormField
  TextFormField buildTextFormField(
      TextEditingController aController,
      String textInputName,
      {bool aMultiLine = false, bool aEnabled = true, bool aValidation = false}) {
    return TextFormField(
      keyboardType: aMultiLine
          ? TextInputType.multiline
          : null,
      maxLines: aMultiLine ? null : 1,
      textAlign: TextAlign.right,
      controller: aController,
      style: TextStyle(fontSize: 16.0),
      decoration: aEnabled
          ? TextInputDecoration.copyWith(
          hintText: textInputName,
          hintStyle: TextStyle(fontSize: 14.0)
      )
          : DisabledTextInputDecoration.copyWith(
          hintText: textInputName,
          hintStyle: TextStyle(fontSize: 14.0)
      ), // Disabled Field
      validator: aValidation
          ? (val) => val.isEmpty ? 'הקלד $textInputName' : null
          : null,
    );
  }
  //#endregion

  //#endregion

  //#region DROP DOWN Section

  //#region buildDropDownRoleAndHierarchy
  Widget buildDropDownRoleAndHierarchy() {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 5,
                child: Padding(
                  padding: EdgeInsets.only(left: 5.0, top: 30.0, right: 20.0, bottom: 0.0),
                  child: buildRotaryAreaDropDownButton(),
                ),
              ),
              Expanded(
                flex: 5,
                child: Padding(
                  padding: EdgeInsets.only(left: 20.0, top: 30.0, right: 5.0, bottom: 0.0),
                  child: buildRotaryClusterDropDownButton(),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                flex: 5,
                child: Padding(
                  padding: EdgeInsets.only(left: 20.0, top: 10.0, right: 20.0, bottom: 0.0),
                  child: buildRotaryClubDropDownButton(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  //#endregion

  //#region Build Rotary Area DropDown Button
  Widget buildRotaryAreaDropDownButton() {
    return  Container(
      height: 45.0,
      alignment: Alignment.center,
      padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.0)
      ),
      child: DropdownButtonFormField(
        value: selectedRotaryAreaObj,
        items: dropdownRotaryAreaItems,
        onChanged: onChangeDropdownRotaryAreaItem,
        decoration: InputDecoration.collapsed(hintText: ''),
        hint: Text('בחר אזור'),
        validator: (value) => value == null ? 'בחר אזור' : null,
        // underline: SizedBox(),
        // iconSize: 30,
      ),
    );
  }
  //#endregion

  //#region Build Rotary Cluster DropDown Button
  Widget buildRotaryClusterDropDownButton() {
    return Container(
      height: 45.0,
      alignment: Alignment.center,
      padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.0)
      ),
      child: DropdownButtonFormField(
        value: selectedRotaryClusterObj,
        items: dropdownRotaryClusterFilteredItems,
        onChanged: onChangeDropdownRotaryClusterItem,
        decoration: InputDecoration.collapsed(hintText: ''),
        hint: Text('בחר אשכול'),
        validator: (value) => value == null ? 'בחר אשכול' : null,
        // underline: SizedBox(),
      ),
    );
  }
  //#endregion

  //#region Build Rotary Club DropDown Button
  Widget buildRotaryClubDropDownButton() {
    return Container(
      height: 45.0,
      alignment: Alignment.center,
      padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.0)
      ),
      child: DropdownButtonFormField(
        value: selectedRotaryClubObj,
        items: dropdownRotaryClubFilteredItems,
        onChanged: onChangeDropdownRotaryClubItem,
        decoration: InputDecoration.collapsed(hintText: ''),
        hint: Text('בחר מועדון'),
        // validator: (value) => value == null ? 'בחר מועדון' : null,
        // underline: SizedBox(),
      ),
    );
  }
  //#endregion

  //#endregion

  //#region Build Action Button
  Widget buildActionButton(String aButtonText, IconData aIcon, Function aFunc) {

    return Padding(
      padding: const EdgeInsets.only(top: 10.0, right: 120.0, left: 120.0, bottom: 10.0),
      child: ActionButtonDecoration(
          argButtonType: ButtonType.Decorated,
          argHeight: 35.0,
          argButtonText: aButtonText,
          argIcon: aIcon,
          onPressed: () {
            aFunc();
          }),
    );
  }
//#endregion
}
