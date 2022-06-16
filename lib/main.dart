import "package:flutter/material.dart";

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  // Immutable data
  static const String _title = "Measures Converters";
  static const double _DEFAULT_SATE = 0;

  final List<String> _measures = [
    "meters",
    "kilometres",
    "grams",
    "kilograms",
    "feet",
    "miles",
    "pounds (lbs)",
    "ounces",
  ];

  final Map<String, int> _measuresMap = {
    "meters": 0,
    "kilometres": 1,
    "grams": 2,
    "kilograms": 3,
    "feet": 4,
    "miles": 5,
    "pounds (lbs)": 6,
    "ounces": 7,
  };

  final Map<String, List<double>> _formulas = {
    "0": [1, 0.001, 0, 0, 3.28084, 0.000621371, 0, 0],
    "1": [1000.0, 1, 0, 0, 3280.84, 0.621371, 0, 0],
    "2": [0, 0, 1, 0.0001, 0, 0, 0.00220462, 0.035274],
    "3": [0, 0, 1000, 1, 0, 0, 2.20462, 35.274],
    "4": [0.3048, 0.0003048, 0, 0, 1, 0.000189394, 0, 0],
    "5": [1609.34, 1.60934, 0, 0, 5280, 1, 0, 0],
    "6": [0, 0, 453.592, 0.453592, 0, 0, 1, 16],
    "7": [0, 0, 28.3495, 0.0283495, 3.28084, 0, 0.0625, 1],
  };

  // app state
  double _numberForm = 0;
  String _fromMeasure = "", _toMeasure = "";
  String _resultMessage = "";

  @override
  void initState() {
    _numberForm = _DEFAULT_SATE;
    _fromMeasure = _measures[0]; // We set the default value directly
    _toMeasure = _measures[1]; // We set the default value directly
    super.initState();
  }

  // styling
  final TextStyle inputStyle = TextStyle(
    fontSize: 20,
    color: Colors.blue[900],
  );

  final TextStyle labelStyle = TextStyle(
    fontSize: 24,
    color: Colors.grey[700],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text(_title),
          ),
        ),
        body: Container(
          // Padding class and container
          padding: EdgeInsets.symmetric(horizontal: 20),
          // child: SingleChildScrollView(
          // The SingleChildScrollView is causing a rendering error
          child: Column(
            children: [
              Spacer(),
              Text(
                "Value",
                style: labelStyle,
              ),
              Spacer(),
              TextField(
                onChanged: (text) {
                  var parsedValued = double.tryParse(text);

                  if (parsedValued == null) {
                    parsedValued = _DEFAULT_SATE;
                  }

                  setState(() {
                    _numberForm = parsedValued!;
                  });
                },
                style: inputStyle,
                decoration: InputDecoration(
                  hintText: "Enter the measure to convert",
                ),
              ),
              Spacer(),
              Text(
                "From",
                style: labelStyle,
              ),
              Spacer(),
              DropdownButton(
                isExpanded: true,
                items: _measures.map((String measure) {
                  // print(measure);
                  /* for debugging - There should be exactly one item with 
                  [DropdownButton]'s value: .
                  Either zero or 2 or more [DropdownMenuItem]s were detected 
                  with the same value */
                  return DropdownMenuItem<String>(
                    value: measure,
                    child: Text(measure),
                  );
                }).toList(),
                hint: Text("Choose measure"),
                onChanged: (measure) {
                  setState(() {
                    _fromMeasure = measure.toString();
                  });
                },
                value: /* meters */ _fromMeasure,
              ),
              Spacer(),
              Text(
                "To",
                style: labelStyle,
              ),
              Spacer(),
              DropdownButton(
                isExpanded: true,
                items: _measures.map((String measure) {
                  return DropdownMenuItem<String>(
                    value: measure,
                    child: Text(
                      measure,
                      style: inputStyle,
                    ),
                  );
                }).toList(),
                hint: Text("Choose measure"),
                onChanged: (measure) {
                  setState(() {
                    _toMeasure = measure.toString();
                  });
                },
                value: /* "kilometres" */ _toMeasure,
              ),
              Spacer(flex: 2),
              ElevatedButton(
                onPressed: () {
                  // print("Convert button clicked");
                  // if (_resultMessage == "" ||
                  //     _toMeasure == "" ||
                  //     _numberForm == 0) {
                  //   print("Nothing occurs after button click");
                  //   return;
                  // } else {
                  convert(_numberForm, _fromMeasure, _toMeasure);
                  // }
                },
                child: Text(
                  "Convert",
                  style: inputStyle,
                ),
              ),
              Spacer(flex: 2),
              Text(
                /* (_numberForm == 0) ? "" : */ _resultMessage,
                style: inputStyle,
              ),
              Spacer(flex: 8)
            ],
          ),
          // ),
        ),
      ),
    );
  }

  void convert(double measure, String fromMeasure, String toMeasure) {
    int fromMeasurePos = _measuresMap[fromMeasure]!;
    int toMeasurePos = _measuresMap[toMeasure]!;

    double scale = _formulas[fromMeasurePos.toString()]![toMeasurePos];

    double result = measure * scale;

    if (result == 0) {
      _resultMessage = "This conversion cannot be performed";
    } else {
      _resultMessage =
          "${_numberForm.toString()} $_fromMeasure are ${result.toString()} $_toMeasure";
    }

    setState(() {
      _resultMessage = _resultMessage;
    });
  }
}

// Always separate business logic from UI
// Use ScopeModel and Business Logic Components (BLoCs)
