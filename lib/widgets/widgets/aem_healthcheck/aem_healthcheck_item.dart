import 'package:cogboardmobileapp/constants/constants.dart';
import 'package:cogboardmobileapp/utils/url_launcher.dart';
import 'package:flutter/material.dart';

class AemHealthcheckItem extends StatelessWidget with UrlLauncher {
  final String healthcheckName;
  final String healthcheckValue;
  final String url;

  AemHealthcheckItem({
    @required this.healthcheckName,
    @required this.healthcheckValue,
    @required this.url,
  });

  void openUrl(BuildContext context) {
    launchUrl(url, context);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        child: Row(
          children: [
            Container(
              child: Text(
                "${AEM_HEALTH_CHECKS[healthcheckName]}: $healthcheckValue",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              margin: const EdgeInsets.fromLTRB(26.0, 10.0, 0, 15.0),
            ),
          ],
        ),
        margin: const EdgeInsets.fromLTRB(5.0, 0, 0, 0),
      ),
      onTap: () => openUrl(context),
    );
  }
}
