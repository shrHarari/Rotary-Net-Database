import 'dart:io';
import 'package:flutter/material.dart';
import 'package:rotary_database/objects/person_card_role_and_hierarchy_object.dart';
import 'package:rotary_database/objects/rotary_role_object.dart';
import 'package:rotary_database/services/rotary_role_service.dart';
import 'package:rotary_database/shared/action_button_decoration.dart';
import 'package:rotary_database/shared/data_setting_divider.dart';
import 'package:rotary_database/shared/decoration_style.dart';
import 'package:rotary_database/shared/error_message_screen.dart';
import 'package:rotary_database/shared/loading.dart';

class DataSettingRole extends StatefulWidget {

  @override
  _DataSettingRoleState createState() => _DataSettingRoleState();
}

class _DataSettingRoleState extends State<DataSettingRole> {

  final RotaryRoleService rotaryRoleService = RotaryRoleService();
  final formKey = GlobalKey<FormState>();

  //#region Declare Variables
  Future<PersonCardRoleAndHierarchyListObject> personCardRoleAndHierarchyListObjectForBuild;
  PersonCardRoleAndHierarchyListObject displayPersonCardRoleAndHierarchyListObject;

  TextEditingController roleNameController;
  TextEditingController roleEnumController;

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
    roleNameController = TextEditingController(text: '');
    roleEnumController = TextEditingController(text: '');
  }
  //#endregion

  //#region Get PersonCard Role And Hierarchy List For Build
  Future<PersonCardRoleAndHierarchyListObject> getPersonCardRoleAndHierarchyListForBuild() async {

    //////////////////////////////// Rotary Role
    RotaryRoleService _rotaryRoleService = RotaryRoleService();
    List<RotaryRoleObject> _rotaryRoleObjList = await _rotaryRoleService.getAllRotaryRolesList();
    setRotaryRoleDropdownMenuItems(_rotaryRoleObjList);

    return PersonCardRoleAndHierarchyListObject(
      rotaryRoleObjectList: _rotaryRoleObjList,
    );
  }
  //#endregion

  //#region All DropDown UI Objects

  //#region RotaryRole DropDown
  List<DropdownMenuItem<RotaryRoleObject>> dropdownRotaryRoleItems;
  RotaryRoleObject selectedRotaryRoleObj;

  void setRotaryRoleDropdownMenuItems(List<RotaryRoleObject> aRotaryRoleObjectsList) {
    List<DropdownMenuItem<RotaryRoleObject>> _rotaryRoleDropDownItems = List();
    for (RotaryRoleObject _rotaryRoleObj in aRotaryRoleObjectsList) {
      _rotaryRoleDropDownItems.add(
        DropdownMenuItem(
          child: SizedBox(
            width: 100.0,
            child: Text(
              _rotaryRoleObj.roleName,
              // '${_rotaryRoleObj.roleEnum.toString()} ${_rotaryRoleObj.roleName}',
              textAlign: TextAlign.right,
            ),
          ),
          value: _rotaryRoleObj,
        ),
      );
    }
    dropdownRotaryRoleItems = _rotaryRoleDropDownItems;
  }

  onChangeDropdownRotaryRoleItem(RotaryRoleObject aSelectedRotaryRoleObject) {
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() {
      selectedRotaryRoleObj = aSelectedRotaryRoleObject;
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

  //#region Add Data Table Role
  Future addDataTableRole() async {

    setState(() {loading = true;});

    bool validationVal = await checkValidation();

    if (validationVal){

      String _roleEnum = (roleEnumController.text != null) ? (roleEnumController.text) : '';
      String _roleName = (roleNameController.text != null) ? (roleNameController.text) : '';

      RotaryRoleObject newRotaryRoleObject =
      rotaryRoleService.createRotaryRoleAsObject(
          '', int.parse(_roleEnum), _roleName);

      bool returnVal = await rotaryRoleService.insertRotaryRole(newRotaryRoleObject);

      if ((returnVal) ){
        setState(() {
          displayMessage = 'תפקיד חדש הוגדר בהצלחה';
        });
      } else {
        setState(() {
          displayMessage = 'עדכון נתוני התפקיד נכשל, נסה שנית';
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
                    child: DataSettingDivider(argSectionTitle: 'פרטי תפקיד חדש להוספה'),
                  ),

                  Padding(
                    padding: EdgeInsets.only(left: 40, top: 10.0, right: 20.0, bottom: 0.0),
                    child: buildEnabledTextInputWithImageIcon(roleEnumController, 'קוד תפקיד', Icons.vpn_key, aValidation: true),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 40, top: 10.0, right: 20.0, bottom: 0.0),
                    child: buildEnabledTextInputWithImageIcon(roleNameController, 'תאור התפקיד', Icons.vpn_key_outlined, aValidation: true),
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

        buildActionButton('הוספה', Icons.save, addDataTableRole),
      ],
    );
  }

  //#region INPUT FIELDS

  //#region buildEnabledTextInputWithImageIcon
  Widget buildEnabledTextInputWithImageIcon(
      TextEditingController aController,
      String textInputName, IconData aIcon,
      {bool aMultiLine = false, bool aEnabled = true, bool aValidation = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
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
      ),
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
          Padding(
            padding: EdgeInsets.only(left: 20, top: 30.0, right: 20.0, bottom: 0.0),
            child: buildRotaryRoleDropDownButton(),
          ),
        ],
      ),
    );
  }
  //#endregion

  //#region Build Rotary Role DropDown Button
  Widget buildRotaryRoleDropDownButton() {
    return  Container(
      height: 45.0,
      alignment: Alignment.center,
      padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.0)
      ),
      child: DropdownButtonFormField(
        value: selectedRotaryRoleObj,
        items: dropdownRotaryRoleItems,
        onChanged: onChangeDropdownRotaryRoleItem,
        decoration: InputDecoration.collapsed(hintText: ''),
        hint: Text('בחר תפקיד'),
        // validator: (value) => value == null ? 'בחר תפקיד' : null,
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
