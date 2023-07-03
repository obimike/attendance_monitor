import 'package:Attendance_Monitor/common/welcome/welcome_page.dart';
import 'package:flutter/material.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({super.key});

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  final List<Map<String, String>> _pages = [
    {
      'image': 'images/intro1.png',
      'title': 'Easy setup and Usage',
      'description':
          'Get up and running in no time with our simple installation process.',
      'upperText': 'Skip',
    },
    {
      'image': 'images/intro2.png',
      'title': 'Real-time tracking',
      'description':
          'Instantly record attendance and monitor updates as they happen.',
      'upperText': 'Skip',
    },
    {
      'image': 'images/intro3.png',
      'title':
          ' Instantly record attendance and monitor updates as they happen.',
      'description':
          'Generate detailed reports effortlessly, providing valuable insights for analysis and decision-making.',
      'upperText': 'Continue',
    },
  ];

  @override
  Widget build(BuildContext context) {
    var dynamicWidth = MediaQuery.of(context).size.width;
    var dynamicHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                  controller: _pageController,
                  itemCount: _pages.length,
                  onPageChanged: (int page) {
                    setState(() {
                      _currentPage = page;
                    });
                  },
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(builder: (context) => const Welcome()),
                                );
                              },
                              child: Text(
                                _pages[index]['upperText']!,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300,
                                  fontStyle: FontStyle.normal,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Image.asset(
                          _pages[index]['image']!,
                          width: 320,
                          height: 320,
                        ),
                        const SizedBox(height: 32),
                        Text(
                          _pages[index]['title']!,
                          style: const TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                            fontWeight: FontWeight.w300,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _pages[index]['description']!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w300,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                       const SizedBox(height: 36),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: _buildPageIndicator(),
                        ),
                       const SizedBox(height: 36),
                        ElevatedButton(
                          child: Text(
                            _currentPage == _pages.length - 1
                                ? 'Get Started'
                                : 'Next',
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          onPressed: () {
                            if (_currentPage == _pages.length - 1) {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(builder: (context) => const Welcome()),
                              );
                            } else {
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 600),
                                curve: Curves.ease,
                              );
                            }
                          },
                        ),
                      ],
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildPageIndicator() {
    List<Widget> indicators = [];
    for (int i = 0; i < _pages.length; i++) {
      indicators.add(
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          height: 8,
          width: _currentPage == i ? 24 : 8,
          decoration: BoxDecoration(
            color: _currentPage == i ? Colors.blue : Colors.grey,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      );
    }
    return indicators;
  }
}
