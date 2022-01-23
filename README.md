# google_places_flutter

# Add dependency into pubspec.yml

```
dependencies:
  flutter:
    sdk: flutter
  google_places_flutter: <last-version>
  
```  

# Google AutoComplete TextField Widget code


```
    GooglePlaceAutoCompleteTextField(
        textEditingController: controller,
        validator: (val){} // optional by default. Use it just as you would use the validator of any regular TextFormField
        googleAPIKey: "YOUR_GOOGLE_API_KEY",
        inputDecoration: InputDecoration()
        debounceTime: 800 // default 600 ms,
        countries: ["in","fr"],// optional by default null is set
        isLatLngRequired:true,// if you required coordinates from place detail
        getPlaceDetailWithLatLng: (Prediction prediction) {
         // this method will return latlng with place detail
        print("placeDetails" + prediction.lng.toString());
        }, // this callback is called when isLatLngRequired is true
        itmClick: (Prediction prediction) {
         controller.text=prediction.description;
          controller.selection = TextSelection.fromPosition(TextPosition(offset: prediction.description.length));
        }
    )
    
```
# Customization Option
 You can customize a text field input decoration and debounce time 

# Screenshorts
<img src="sample.jpg" height="400">

