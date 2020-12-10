import 'dart:io';
import 'package:flutter/material.dart';
import 'package:rotary_database/objects/person_card_role_and_hierarchy_object.dart';
import 'package:rotary_database/objects/rotary_area_object.dart';
import 'package:rotary_database/services/rotary_area_service.dart';
import 'package:rotary_database/shared/action_button_decoration.dart';
import 'package:rotary_database/shared/data_setting_divider.dart';
import 'package:rotary_database/shared/decoration_style.dart';
import 'package:rotary_database/shared/error_message_screen.dart';
import 'package:rotary_database/shared/loading.dart';

class DataSettingArea extends StatefulWidget {

  @override
  _DataSettingAreaState createState() => _DataSettingAreaState();
}

class _DataSettingAreaState extends State<DataSettingArea> {

  final RotaryAreaService rotaryAreaService = RotaryAreaService();
  final formKey = GlobalKey<FormState>();

  //#region Declare Variables
  Future<PersonCardRoleAndHierarchyListObject> personCardRoleAndHierarchyListObjectForBuild;
  PersonCardRoleAndHierarchyListObject displayPersonCardRoleAndHierarchyListObject;

  TextEditingController areaNameController;

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
    areaNameController = TextEditingController(text: '');
  }
  //#endregion

  //#region Get PersonCard Role And Hierarchy List For Build
  Future<PersonCardRoleAndHierarchyListObject> getPersonCardRoleAndHierarchyListForBuild() async {

    ////////////////////////////// Rotary Area
    RotaryAreaService _rotaryAreaService = RotaryAreaService();
    List<RotaryAreaObject> _rotaryAreaObjList = await _rotaryAreaService.getAllRotaryAreaList();
    setRotaryAreaDropdownMenuItems(_rotaryAreaObjList);

    return PersonCardRoleAndHierarchyListObject(
      rotaryAreaObjectList: _rotaryAreaObjList,
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

  //#region Add Data Table Area
  Future addDataTableArea() async {

    setState(() {loading = true;});

    bool validationVal = await checkValidation();

    if (validationVal){

      String _areaName = (areaNameController.text != null) ? (areaNameController.text) : '';

      RotaryAreaObject newRotaryAreaObject =
      rotaryAreaService.createRotaryAreaAsObject(
          '', _areaName, []);

      bool returnVal = await rotaryAreaService.insertRotaryArea(newRotaryAreaObject);

      if ((returnVal) ){
        setState(() {
          displayMessage = 'אזור חדש הוגדר בהצלחה';
        });
      } else {
        setState(() {
          displayMessage = 'עדכון נתוני האזור נכשל, נסה שנית';
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
                    child: DataSettingDivider(argSectionTitle: 'פרטי אזור חדש להוספה'),
                  ),

                  Padding(
                    padding: EdgeInsets.only(left: 40, top: 10.0, right: 20.0, bottom: 0.0),
                    child: buildEnabledTextInputWithImageIcon(areaNameController, 'שם אזור', Icons.location_on, aValidation: true),
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

        buildActionButton('הוספה', Icons.save, addDataTableArea),
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
      child: IconTheme(
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
          Padding(
            padding: EdgeInsets.only(left: 20, top: 30.0, right: 20.0, bottom: 0.0),
            child: buildRotaryAreaDropDownButton(),
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
        // validator: (value) => value == null ? 'בחר אזור' : null,
        // underline: SizedBox(),
        // iconSize: 30,
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
