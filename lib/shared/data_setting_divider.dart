import 'package:flutter/material.dart';

class DataSettingDivider extends StatelessWidget {
  final String argSectionTitle;

  const DataSettingDivider({
    @required this.argSectionTitle,
  });
  @override
  Widget build(BuildContext context) {
      return Row(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: Divider(
              color: Colors.grey[400],
              thickness: 2.0,
            ),
          ),
          Expanded(
            flex: 15,
            child: Text(
              argSectionTitle,
              style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 1,
            child: Divider(
              color: Colors.grey[400],
              thickness: 2.0,
            ),
          ),
        ],
      );
  }
}
