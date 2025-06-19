import 'package:flutter/material.dart';

void main() {
  runApp(TemperatureConverterApp());
}

class TemperatureConverterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Temperature Converter',
      home: TemperatureConverter(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class TemperatureConverter extends StatefulWidget {
  @override
  _TemperatureConverterState createState() => _TemperatureConverterState();
}

class _TemperatureConverterState extends State<TemperatureConverter> {
  final TextEditingController _controller = TextEditingController();
  bool _isFtoC = true; // Default conversion
  String _result = '';
  List<String> _history = [];

  void _convertTemperature() {
    double? input = double.tryParse(_controller.text);
    if (input == null) {
      setState(() {
        _result = 'Invalid input';
      });
      return;
    }

    double output;
    String entry;
    if (_isFtoC) {
      output = (input - 32) * 5 / 9;
      _result = '${output.toStringAsFixed(2)} °C';
      entry = 'F to C: ${input.toStringAsFixed(1)} => ${output.toStringAsFixed(1)}';
    } else {
      output = input * 9 / 5 + 32;
      _result = '${output.toStringAsFixed(2)} °F';
      entry = 'C to F: ${input.toStringAsFixed(1)} => ${output.toStringAsFixed(1)}';
    }

    setState(() {
      _history.insert(0, entry);
    });
  }

  Widget _buildOrientationLayout(BuildContext context, BoxConstraints constraints) {
    bool isPortrait = constraints.maxHeight > constraints.maxWidth;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: isPortrait
          ? Column(
        children: _buildContent(),
      )
          : Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _buildContent(),
            ),
          ),
          Expanded(
            child: _buildHistoryList(),
          )
        ],
      ),
    );
  }

  List<Widget> _buildContent() {
    return [
      ToggleButtons(
        isSelected: [_isFtoC, !_isFtoC],
        onPressed: (index) {
          setState(() {
            _isFtoC = index == 0;
          });
        },
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text('F to C'),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text('C to F'),
          ),
        ],
      ),
      SizedBox(height: 20),
      TextField(
        controller: _controller,
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
          labelText: 'Enter Temperature',
          border: OutlineInputBorder(),
        ),
      ),
      SizedBox(height: 20),
      ElevatedButton(
        onPressed: _convertTemperature,
        child: Text('Convert'),
      ),
      SizedBox(height: 20),
      Text(
        _result,
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
      SizedBox(height: 20),
      Expanded(child: _buildHistoryList()),
    ];
  }

  Widget _buildHistoryList() {
    return ListView.builder(
      itemCount: _history.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(_history[index]),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Temperature Converter'),
      ),
      body: LayoutBuilder(
        builder: _buildOrientationLayout,
      ),
    );
  }
}
