import 'package:biocu/features/homepage/homepage_view.dart';
import 'package:flutter/material.dart';
import 'package:biocu/core/styles/styles_colors.dart';
import 'package:biocu/core/styles/styles_texts.dart';
import 'package:lottie/lottie.dart';
import '../../core/widgets/doubleTap_to_exit.dart';
import 'data/logic_tutorial.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({Key? key}) : super(key: key);

  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  int currentIndex = 0;
  late PageController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _skipTutorial() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => HomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DoubleBackExitWrapper(
      message: 'Presiona de nuevo para salir',
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              color: contents[currentIndex].backgroundColor,
              child: Column(
                children: [
                  Expanded(
                    child: PageView.builder(
                      controller: _controller,
                      itemCount: contents.length,
                      onPageChanged: (int index) {
                        setState(() => currentIndex = index);
                      },
                      itemBuilder: (_, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Lottie.asset(
                                contents[index].lottieAnimation,
                                width: 250,
                                height: 250,
                                fit: BoxFit.contain,
                              ),
                              const SizedBox(height: 32),
                              Text(
                                contents[index].title,
                                style: AppTextStyles.titleMedium.copyWith(
                                  color: AppColors.textDark,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                child: Text(
                                  contents[index].description,
                                  style: AppTextStyles.bodyText.copyWith(
                                    color: AppColors.textDark,
                                    height: 1.5,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  _buildIndicator(),
                  _buildNavigationButton(context),
                  const SizedBox(height: 24),
                ],
              ),
            ),
            // Botón Omitir en la esquina superior derecha
            Positioned(
              top: MediaQuery.of(context).padding.top + 16,
              right: 16,
              child: TextButton(
                onPressed: _skipTutorial,
                child: Text(
                  'OMITIR',
                  style: AppTextStyles.bodyText.copyWith(
                    color: AppColors.textDark.withOpacity(0.7),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        contents.length,
            (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 8,
          width: currentIndex == index ? 24 : 8,
          decoration: BoxDecoration(
            color: currentIndex == index
                ? AppColors.Lightsecondary
                : AppColors.textDark.withOpacity(0.3),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.Lightsecondary,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () {
            if (currentIndex == contents.length - 1) {
              _skipTutorial();
            } else {
              _controller.nextPage(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
              );
            }
          },
          child: Text(
            currentIndex == contents.length - 1 ? "COMENZAR" : "CONTINUAR",
            style: AppTextStyles.buttonText.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}