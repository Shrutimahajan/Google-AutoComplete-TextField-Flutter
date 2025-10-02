class NewPlacesAutocompleteResponse {
  List<Suggestion>? suggestions;

  NewPlacesAutocompleteResponse({this.suggestions});

  NewPlacesAutocompleteResponse.fromJson(Map<String, dynamic> json) {
    if (json['suggestions'] != null) {
      suggestions = [];
      json['suggestions'].forEach((v) {
        suggestions!.add(Suggestion.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (suggestions != null) {
      data['suggestions'] = suggestions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Suggestion {
  PlacePrediction? placePrediction;

  Suggestion({this.placePrediction});

  Suggestion.fromJson(Map<String, dynamic> json) {
    placePrediction = json['placePrediction'] != null
        ? PlacePrediction.fromJson(json['placePrediction'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (placePrediction != null) {
      data['placePrediction'] = placePrediction!.toJson();
    }
    return data;
  }
}

class PlacePrediction {
  String? place;
  String? placeId;
  TextWithMatches? text;
  StructuredFormatV2? structuredFormat;
  List<String>? types;

  PlacePrediction({
    this.place,
    this.placeId,
    this.text,
    this.structuredFormat,
    this.types,
  });

  PlacePrediction.fromJson(Map<String, dynamic> json) {
    place = json['place'];
    placeId = json['placeId'];
    text = json['text'] != null ? TextWithMatches.fromJson(json['text']) : null;
    structuredFormat = json['structuredFormat'] != null
        ? StructuredFormatV2.fromJson(json['structuredFormat'])
        : null;
    types = json['types']?.cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['place'] = place;
    data['placeId'] = placeId;
    if (text != null) {
      data['text'] = text!.toJson();
    }
    if (structuredFormat != null) {
      data['structuredFormat'] = structuredFormat!.toJson();
    }
    data['types'] = types;
    return data;
  }
}

class TextWithMatches {
  String? text;
  List<TextMatch>? matches;

  TextWithMatches({this.text, this.matches});

  TextWithMatches.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    if (json['matches'] != null) {
      matches = [];
      json['matches'].forEach((v) {
        matches!.add(TextMatch.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['text'] = text;
    if (matches != null) {
      data['matches'] = matches!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TextMatch {
  int? endOffset;

  TextMatch({this.endOffset});

  TextMatch.fromJson(Map<String, dynamic> json) {
    endOffset = json['endOffset'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['endOffset'] = endOffset;
    return data;
  }
}

class StructuredFormatV2 {
  TextWithMatches? mainText;
  TextWithMatches? secondaryText;

  StructuredFormatV2({this.mainText, this.secondaryText});

  StructuredFormatV2.fromJson(Map<String, dynamic> json) {
    mainText = json['mainText'] != null
        ? TextWithMatches.fromJson(json['mainText'])
        : null;
    secondaryText = json['secondaryText'] != null
        ? TextWithMatches.fromJson(json['secondaryText'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (mainText != null) {
      data['mainText'] = mainText!.toJson();
    }
    if (secondaryText != null) {
      data['secondaryText'] = secondaryText!.toJson();
    }
    return data;
  }
}