import 'package:flutter/material.dart';
import 'common/appcolor.dart';
import 'services/currency_rate_service.dart';
import 'splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

class CurrencyConverter extends StatefulWidget {
  const CurrencyConverter({super.key});

  @override
  State<CurrencyConverter> createState() => _CurrencyConverterState();
}

class _CurrencyConverterState extends State<CurrencyConverter> {
  TextEditingController amountController = TextEditingController();

  String fromCurrency = 'USD';
  String toCurrency = 'BDT';

  double result = 0;
  double rate = 0;
  bool isLoading = false;

  List<String> currencies = [
    'USD', 'BDT', 'EUR', 'INR', 'GBP', 'AUD', 'CAD', 'JPY'
  ];

  Future<void> fetchRate() async {
    setState(() => isLoading = true);

    try {
      final fetchedRate =
          await CurrencyRateService.getExchangeRate(fromCurrency, toCurrency);

      if (mounted) {
        setState(() {
          if (fetchedRate != null) {
            rate = fetchedRate;
          }
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  void convertCurrency() async {
    double input = double.tryParse(amountController.text) ?? 0;
    await fetchRate();

    setState(() {
      result = input * rate;
    });
  }

  void swapCurrency() {
    setState(() {
      String temp = fromCurrency;
      fromCurrency = toCurrency;
      toCurrency = temp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        decoration: const BoxDecoration(
          gradient: gradientColors.primaryGradient,
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              // Title
              Text(
                "Currency Converter",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              SizedBox(height: 30),

              // Card UI
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    )
                  ],
                ),
                child: Column(
                  children: [

                    // Input
                    TextField(
                      controller: amountController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Enter Amount",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),

                    SizedBox(height: 20),

                    // Dropdown Row
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: fromCurrency,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            items: currencies.map((value) {
                              return DropdownMenuItem(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() => fromCurrency = value!);
                            },
                          ),
                        ),

                        SizedBox(width: 10),

                        // Swap Button
                        GestureDetector(
                          onTap: swapCurrency,
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.deepPurple,
                            ),
                            child: Icon(
                              Icons.swap_horiz,
                              color: Colors.white,
                            ),
                          ),
                        ),

                        SizedBox(width: 10),

                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: toCurrency,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            items: currencies.map((value) {
                              return DropdownMenuItem(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() => toCurrency = value!);
                            },
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 20),

                    // Convert Button
                    ElevatedButton(
                      onPressed: convertCurrency,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                        minimumSize: Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text("Convert"),
                    ),

                    SizedBox(height: 20),

                    // Result
                    isLoading
                        ? CircularProgressIndicator()
                        : Column(
                            children: [
                              Text(
                                "Result",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                result == 0
                                    ? "0"
                                    : result.toStringAsFixed(2),
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                              Text(
                                toCurrency,
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}