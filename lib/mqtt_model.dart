class MqttModel {
  String? timestamp;
  List<Data>? data;

  MqttModel({this.timestamp, this.data});

  MqttModel.fromJson(Map<String, dynamic> json) {
    timestamp = json['timestamp'];
    if (json['data'] != null) {
      data = [];

      json['data'].forEach((v) {
        data?.add(Data.fromJson(v));
      });
    }
  }
}

class Data {
  String? type;
  int? value;

  Data({this.type, this.value});

  Data.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    value = json['value'];
  }
}
