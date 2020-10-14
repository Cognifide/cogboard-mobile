import 'package:cogboardmobileapp/models/widget_model.dart';

class Widgets {
  Map<String, DashboardWidget> widgetsById;
  List<String> allWidgets;

  Widgets({this.widgetsById, this.allWidgets});

  factory Widgets.fromJson(Map<String, dynamic> json) => Widgets(
        widgetsById: ((json['widgetsById']) as Map<String, dynamic>)
            .map((key, value) => MapEntry(key.toString(), DashboardWidget.fromJson(value))),
        allWidgets: ((json['allWidgets']) as List<dynamic>).cast<String>(),
      );
}
