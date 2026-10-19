import 'package:flutter/material.dart';
import 'segments/keep_note_segment.dart';
import 'segments/expense_track_segment.dart';
import 'segments/currency_convert_segment.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<String> _segmentNames = [
    'keep note',
    'expense track',
    'currency convert',
  ];

  final List<Widget> _segments = const [
    KeepNoteSegment(),
    ExpenseTrackSegment(),
    CurrencyConvertSegment(),
  ];

  String get _appBarTitle {
    switch (_currentIndex) {
      case 0:
        return 'Keep Note';
      case 1:
        return 'Expense Track';
      case 2:
        return 'Currency Convert';
      default:
        return 'Home';
    }
  }

  String get _segmentSubtitle {
    switch (_currentIndex) {
      case 0:
        return 'Organize your financial reminders & notes';
      case 1:
        return 'Track cashflow, income and daily spending';
      case 2:
        return 'Live global foreign exchange calculator';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.deepPurple],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header Section
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _appBarTitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _segmentSubtitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white.withValues(alpha: 0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Container(
                    //   padding: const EdgeInsets.all(8),
                    //   decoration: BoxDecoration(
                    //     color: Colors.white.withValues(alpha: 0.2),
                    //     shape: BoxShape.circle,
                    //   ),
                    //   child: const Icon(
                    //     Icons.account_balance_wallet_outlined,
                    //     color: Colors.white,
                    //     size: 24,
                    //   ),
                    // ),
                  ],
                ),
              ),

              // Segmented Control Pill Bar
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: List.generate(_segmentNames.length, (index) {
                    final isSelected = _currentIndex == index;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _currentIndex = index;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeInOut,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.white
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.12,
                                      ),
                                      blurRadius: 8,
                                      offset: const Offset(0, 3),
                                    ),
                                  ]
                                : [],
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            _segmentNames[index],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.w500,
                              color: isSelected
                                  ? Colors.deepPurple
                                  : Colors.white.withValues(alpha: 0.85),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),

              const SizedBox(height: 4),

              // Main Active Segment (Preserves state of each segment)
              Expanded(
                child: IndexedStack(index: _currentIndex, children: _segments),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
