library google_places_flutter;

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:google_places_flutter/model/place_details.dart';
import 'package:google_places_flutter/model/prediction.dart';

import 'package:rxdart/subjects.dart';
import 'package:dio/dio.dart';
import 'package:rxdart/rxdart.dart';

class GooglePlaceAutoCompleteTextField extends StatefulWidget {
  InputDecoration inputDecoration;
  ItemClick? itmClick;
  GetPlaceDetailswWithLatLng? getPlaceDetailWithLatLng;
  bool isLatLngRequired = true;

  TextStyle textStyle;
  String googleAPIKey;
  int debounceTime = 600;
  List<String>? countries = [];
  TextEditingController textEditingController = TextEditingController();

  GooglePlaceAutoCompleteTextField(
      {required this.textEditingController,
      required this.googleAPIKey,
      this.debounceTime: 600,
      this.inputDecoration: const InputDecoration(),
      this.itmClick,
      this.isLatLngRequired=true,
      this.textStyle: const TextStyle(),
      this.countries,
      this.getPlaceDetailWithLatLng,
      });

  @override
  _GooglePlaceAutoCompleteTextFieldState createState() =>
      _GooglePlaceAutoCompleteTextFieldState();
}

class _GooglePlaceAutoCompleteTextFieldState
    extends State<GooglePlaceAutoCompleteTextField> {
  final subject = new PublishSubject<String>();
  OverlayEntry? _overlayEntry;
  List<Prediction> alPredictions = [];

  TextEditingController controller = TextEditingController();
  final LayerLink _layerLink = LayerLink();
  bool isSearched = false;

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: TextFormField(
        decoration: widget.inputDecoration,
        style: widget.textStyle,
        controller: widget.textEditingController,
        onChanged: (string) => (subject.add(string)),
      ),
    );
  }

  getLocation(String text) async {
    Dio dio = new Dio();

    /// Construct the URL for making a Google Places API autocomplete request
	String apiURL =
        "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$text&key=${widget.googleAPIKey}";
	String proxyURL = "https://cors-anywhere.herokuapp.com/";
	String url = kIsWeb ? proxyURL + apiURL : apiURL;
	/// Add the custom header to the options
	final options = kIsWeb ? Options(
      headers: { "x-requested-with": "XMLHttpRequest" }
    ) : null;

    if (widget.countries != null) {
      // in

      for (int i = 0; i < widget.countries!.length; i++) {
        String country = widget.countries![i];

        if (i == 0) {
          url = url + "&components=country:$country";
        } else {
          url = url + "|" + "country:" + country;
        }
      }
    }

	/// Send an HTTP GET request to the specified URL
    Response response = await dio.get(url, options: options);
    PlacesAutocompleteResponse subscriptionResponse =
        PlacesAutocompleteResponse.fromJson(response.data);

    if (text.length == 0) {
      alPredictions.clear();
      this._overlayEntry!.remove();
      return;
    }

    isSearched = false;
    if (subscriptionResponse.predictions!.length > 0) {
      alPredictions.clear();
      alPredictions.addAll(subscriptionResponse.predictions!);
    }

    //if (this._overlayEntry == null)

    this._overlayEntry = null;
    this._overlayEntry = this._createOverlayEntry();
    Overlay.of(context)!.insert(this._overlayEntry!);
    //   this._overlayEntry.markNeedsBuild();
  }

  @override
  void initState() {
    subject.stream
        .distinct()
        .debounceTime(Duration(milliseconds: widget.debounceTime))
        .listen(textChanged);
  }

  textChanged(String text) async {
    getLocation(text);
  }

  OverlayEntry? _createOverlayEntry() {
    if (context != null && context.findRenderObject() != null) {
      RenderBox renderBox = context.findRenderObject() as RenderBox;
      var size = renderBox.size;
      var offset = renderBox.localToGlobal(Offset.zero);
      return OverlayEntry(
          builder: (context) => Positioned(
                left: offset.dx,
                top: size.height + offset.dy,
                width: size.width,
                child: CompositedTransformFollower(
                  showWhenUnlinked: false,
                  link: this._layerLink,
                  offset: Offset(0.0, size.height + 5.0),
                  child: Material(
                      elevation: 1.0,
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemCount: alPredictions.length,
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            onTap: () {
                              if (index < alPredictions.length) {
                                widget.itmClick!(alPredictions[index]);
                                if (!widget.isLatLngRequired) return;

                                getPlaceDetailsFromPlaceId(
                                    alPredictions[index]);

                                removeOverlay();
                              }
                            },
                            child: Container(
                                padding: EdgeInsets.all(10),
                                child: Text(alPredictions[index].description!)),
                          );
                        },
                      )),
                ),
              ));
    }
  }

  removeOverlay() {
    alPredictions.clear();
    this._overlayEntry = this._createOverlayEntry();
    if (context != null) {
      Overlay.of(context)!.insert(this._overlayEntry!);
      this._overlayEntry!.markNeedsBuild();
    }
  }

  Future<Response?> getPlaceDetailsFromPlaceId(Prediction prediction) async {
    //String key = GlobalConfiguration().getString('google_maps_key');

	/// Construct the URL for making a Google Places API autocomplete request
	String apiURL =
        "https://maps.googleapis.com/maps/api/place/details/json?placeid=${prediction.placeId}&key=${widget.googleAPIKey}";
	String proxyURL = "https://cors-anywhere.herokuapp.com/";
	String url = kIsWeb ? proxyURL + apiURL : apiURL;
	/// Add the custom header to the options
	final options = kIsWeb ? Options(
      headers: { "x-requested-with": "XMLHttpRequest" }
    ) : null;
	/// Send an HTTP GET request to the specified URL
    Response response = await Dio().get(url, options: options);

    PlaceDetails placeDetails = PlaceDetails.fromJson(response.data);

    prediction.lat = placeDetails.result!.geometry!.location!.lat.toString();
    prediction.lng = placeDetails.result!.geometry!.location!.lng.toString();

    widget.getPlaceDetailWithLatLng!(prediction);

//    prediction.latLng = new LatLng(
//        placeDetails.result.geometry.location.lat,
//        placeDetails.result.geometry.location.lng);
  }
}

PlacesAutocompleteResponse parseResponse(Map responseBody) {
  return PlacesAutocompleteResponse.fromJson(responseBody as Map<String, dynamic>);
}

PlaceDetails parsePlaceDetailMap(Map responseBody) {
  return PlaceDetails.fromJson(responseBody as Map<String, dynamic>);
}

typedef ItemClick = void Function(Prediction postalCodeResponse);
typedef GetPlaceDetailswWithLatLng = void Function(
    Prediction postalCodeResponse);
