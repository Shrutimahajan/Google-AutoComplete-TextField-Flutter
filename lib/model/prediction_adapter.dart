import 'new_prediction.dart';
import 'prediction.dart';

class PredictionAdapter {
  static Prediction fromSuggestion(Suggestion suggestion) {
    final placePrediction = suggestion.placePrediction;
    if (placePrediction == null) {
      return Prediction();
    }

    return Prediction(
      description: placePrediction.text?.text,
      id: null, 
      placeId: placePrediction.placeId,
      reference: null,
      structuredFormatting:null,
      terms: null,
      types: placePrediction.types,
      matchedSubstrings:null,
      lat: null,
      lng: null,
    );
  }
}
