import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import '../service/translation_service.dart';
import 'widgets.dart';
import '../model/language.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111111),
      appBar: AppBar(
        backgroundColor: const Color(0xFF111111),
        elevation: 0,
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFF7C6AF7),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.translate, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 10),
            const Text(
              'TranslateAI',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Histórico',
            icon: const Icon(Icons.history, color: Colors.white70),
            onPressed: () => Get.toNamed('/history'),
          ),
          IconButton(
            tooltip: 'Favoritos',
            icon: const Icon(Icons.star_outline, color: Colors.white70),
            onPressed: () => Get.toNamed('/favorites'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),

            const Center(
              child: Column(
                children: [
                  Text(
                    'O que deseja traduzir?',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Powered by Gemini AI',
                    style: TextStyle(color: Colors.white38, fontSize: 13),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            const LanguageBarWidget(),

            const SizedBox(height: 16),

            const TranslationBoxWidget(),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111111),
      appBar: AppBar(
        backgroundColor: const Color(0xFF111111),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
        title: const Text(
          'Histórico',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          ValueListenableBuilder(
            valueListenable: translationService.historyNotifier,
            builder: (_, list, __) => list.isEmpty
                ? const SizedBox.shrink()
                : IconButton(
                    tooltip: 'Limpar histórico',
                    icon: const Icon(Icons.delete_outline, color: Colors.white54),
                    onPressed: () {
                      translationService.limparHistorico();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Histórico limpo!'),
                          backgroundColor: Color(0xFF7C6AF7),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: translationService.historyNotifier,
        builder: (_, list, __) {
          if (list.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history, color: Colors.white24, size: 64),
                  SizedBox(height: 16),
                  Text(
                    'Nenhuma tradução ainda.',
                    style: TextStyle(color: Colors.white38, fontSize: 16),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Traduza algo na tela principal!',
                    style: TextStyle(color: Colors.white24, fontSize: 13),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: list.length,
            itemBuilder: (_, i) => TranslationCardWidget(
              item: list[i],
              onFavoriteToggle: () =>
                  translationService.toggleFavorito(list[i]),
            ),
          );
        },
      ),
    );
  }
}

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111111),
      appBar: AppBar(
        backgroundColor: const Color(0xFF111111),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
        title: const Text(
          'Favoritos',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: translationService.favoritesNotifier,
        builder: (_, list, __) {
          if (list.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.star_outline, color: Colors.white24, size: 64),
                  SizedBox(height: 16),
                  Text(
                    'Nenhum favorito ainda.',
                    style: TextStyle(color: Colors.white38, fontSize: 16),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Toque na ⭐ no histórico para favoritar!',
                    style: TextStyle(color: Colors.white24, fontSize: 13),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: list.length,
            itemBuilder: (_, i) => TranslationCardWidget(
              item: list[i],
              onFavoriteToggle: () =>
                  translationService.toggleFavorito(list[i]),
            ),
          );
        },
      ),
    );
  }
}

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111111),
      appBar: AppBar(
        backgroundColor: const Color(0xFF111111),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
        title: const Text(
          'Sobre',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 32),
            // Logo
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF7C6AF7).withOpacity(0.15),
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFF7C6AF7).withOpacity(0.4),
                  width: 2,
                ),
              ),
              child: const Icon(Icons.translate, color: Color(0xFF7C6AF7), size: 56),
            ),
            const SizedBox(height: 24),
            const Text(
              'TranslateAI',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'v1.0.0',
              style: TextStyle(color: Colors.white38, fontSize: 14),
            ),
            const SizedBox(height: 32),
            _InfoCard(
              icon: Icons.school,
              title: 'Projeto Acadêmico',
              subtitle: 'Disciplina de POO com Flutter\nUniversidade Federal',
            ),
            const SizedBox(height: 12),
            _InfoCard(
              icon: Icons.psychology,
              title: 'Powered by Gemini AI',
              subtitle: 'Tradução via Google Gemini 2.0 Flash',
            ),
            const SizedBox(height: 12),
            _InfoCard(
              icon: Icons.check_circle_outline,
              title: 'Funcionalidades',
              subtitle:
                  '• Tradução em 12 idiomas\n• Histórico de traduções\n• Favoritos\n• Inversão de idiomas',
            ),
            const SizedBox(height: 12),
            _InfoCard(
              icon: Icons.architecture,
              title: 'Arquitetura',
              subtitle:
                  '• Gerência de estado: ValueNotifier\n• Gerência de rotas: GetX\n• Separação: Model / Service / View',
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF3A3A3A)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF7C6AF7), size: 22),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.white54, fontSize: 13, height: 1.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}