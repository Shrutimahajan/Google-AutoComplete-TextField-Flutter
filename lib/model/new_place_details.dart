class NewPlaceDetails {
  String? id;
  Location? location;
  DisplayName? displayName;

  NewPlaceDetails({this.id, this.location, this.displayName});

  NewPlaceDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    location = json['location'] != null 
        ? Location.fromJson(json['location']) 
        : null;
    displayName = json['displayName'] != null 
        ? DisplayName.fromJson(json['displayName']) 
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (location != null) {
      data['location'] = location!.toJson();
    }
    if (displayName != null) {
      data['displayName'] = displayName!.toJson();
    }
    return data;
  }
}

class Location {
  double? latitude;
  double? longitude;

  Location({this.latitude, this.longitude});

  Location.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude']?.toDouble();
    longitude = json['longitude']?.toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    return data;
  }
}

class DisplayName {
  String? text;
  String? languageCode;

  DisplayName({this.text, this.languageCode});

  DisplayName.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    languageCode = json['languageCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['text'] = text;
    data['languageCode'] = languageCode;
    return data;
  }
}