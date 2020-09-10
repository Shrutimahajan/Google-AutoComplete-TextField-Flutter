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
        googleAPIKey: "YOUR_GOOGLE_API_KEY",
        inputDecoration: InputDecoration()
        debounceTime: 800 // default 600 ms,
         country_code: "in",// optional by default null is set
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

