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
  String value;

  Data({this.type, required this.value});

  Data.fromJson(Map<String, dynamic> json) :
    type = json['type'],
    value =json['value'].toString();

}