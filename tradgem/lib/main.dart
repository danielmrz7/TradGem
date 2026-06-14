import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; 
import 'view/screens.dart';

void main() async {                                  
  await dotenv.load(fileName: ".env");                
  runApp(const TranslateApp());
}

class TranslateApp extends StatelessWidget {
  const TranslateApp({super.key});

  @override
  Widget build(BuildContext context) {
    // GetMaterialApp com gerência de rotas — padrão receita 9
    return GetMaterialApp(
      title: 'TranslateAI',
      debugShowCheckedModeBanner: false,

      // Tema escuro
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.dark(
          primary: const Color(0xFF7C6AF7),
          surface: const Color(0xFF1E1E1E),
        ),
        scaffoldBackgroundColor: const Color(0xFF111111),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF111111),
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
        ),
        snackBarTheme: const SnackBarThemeData(
          backgroundColor: Color(0xFF7C6AF7),
          contentTextStyle: TextStyle(color: Colors.white),
        ),
      ),

      // Gerência de rotas com GetX — padrão receita 9
      initialRoute: '/',
      getPages: [
        GetPage(name: '/',          page: () => const HomeScreen()),
        GetPage(name: '/history',   page: () => const HistoryScreen()),
        GetPage(name: '/favorites', page: () => const FavoritesScreen()),
        GetPage(name: '/about',     page: () => const AboutScreen()),
      ],
    );
  }
}