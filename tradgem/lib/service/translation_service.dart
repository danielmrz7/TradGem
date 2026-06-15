import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // ← import
import 'package:http/http.dart' as http;
import '../model/language.dart';
import '../model/translation_item.dart';

enum TranslationStatus { idle, loading, ready, error }

class TranslationService {
  
  // ✅ Lendo do .env agora
  static String get _apiKey => dotenv.env['GEMINI_API_KEY'] ?? '';
  static String get _apiUrl => dotenv.env['GEMINI_API_URL'] ?? '';

  final ValueNotifier<Map<String, dynamic>> translationStateNotifier =
      ValueNotifier({
    'status': TranslationStatus.idle,
    'translatedText': '',
    'errorMessage': '',
  });

  final ValueNotifier<List<TranslationItem>> historyNotifier =
      ValueNotifier([]);

  final ValueNotifier<List<TranslationItem>> favoritesNotifier =
      ValueNotifier([]);

  final ValueNotifier<Language> sourceLangNotifier =
      ValueNotifier(availableLanguages[0]);

  final ValueNotifier<Language> targetLangNotifier =
      ValueNotifier(availableLanguages[1]);

  Future <void> traduzir(String texto) async {
    if (texto.trim().isEmpty) return;

    final from = sourceLangNotifier.value;
    final to   = targetLangNotifier.value;

    translationStateNotifier.value = {
      'status': TranslationStatus.loading,
      'translatedText': '',
      'errorMessage': '',
    };

    final prompt =
        'Traduza o seguinte texto de ${from.name} para ${to.name}. '
        'Responda APENAS com o texto traduzido, sem explicações:\n\n$texto';

    final body = jsonEncode({
      'contents': [
        {
          'parts': [
            {'text': prompt}
          ]
        }
      ]
    });

    try {
      final urlCompleta = '$_apiUrl?key=$_apiKey';

      final response = await http.post(
        Uri.parse(urlCompleta),
        headers: {
          'Content-Type': 'application/json',
        },
        body: body,
      );
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final translated =
            json['candidates'][0]['content']['parts'][0]['text'] as String;

        translationStateNotifier.value = {
          'status': TranslationStatus.ready,
          'translatedText': translated.trim(),
          'errorMessage': '',
        };

        _adicionarAoHistorico(texto, translated.trim(), from, to);
      } else {
        translationStateNotifier.value = {
          'status': TranslationStatus.error,
          'translatedText': '',
          'errorMessage': 'Erro ${response.statusCode}: verifique sua API key.',
        };
      }
    } catch (e) {
      translationStateNotifier.value = {
        'status': TranslationStatus.error,
        'translatedText': '',
        'errorMessage': 'Sem conexão. Verifique sua internet.',
      };
    }
  }
//historico
  void _adicionarAoHistorico(
    String original,
    String translated,
    Language from,
    Language to,
  ) {
    final item = TranslationItem(
      originalText:   original,
      translatedText: translated,
      fromLanguage:   from.name,
      toLanguage:     to.name,
      fromFlag:       from.flag,
      toFlag:         to.flag,
      timestamp:      DateTime.now(),
    );
    historyNotifier.value = [item, ...historyNotifier.value];
  }

  void limparHistorico() {
    historyNotifier.value = [];
  }

//favoritos
  void toggleFavorito(TranslationItem item) {
    item.isFavorite = !item.isFavorite;

    if (item.isFavorite) {
      favoritesNotifier.value = [item, ...favoritesNotifier.value];
    } else {
      favoritesNotifier.value =
          favoritesNotifier.value.where((f) => f != item).toList();
    }

    historyNotifier.value = [...historyNotifier.value];
  }

  void inverterIdiomas() {
    final temp = sourceLangNotifier.value;
    sourceLangNotifier.value = targetLangNotifier.value;
    targetLangNotifier.value = temp;

    translationStateNotifier.value = {
      'status': TranslationStatus.idle,
      'translatedText': '',
      'errorMessage': '',
    };
  }

  void selecionarIdiomaOrigem(Language lang) {
    sourceLangNotifier.value = lang;
  }

  void selecionarIdiomaDestino(Language lang) {
    targetLangNotifier.value = lang;
  }

  void resetar() {
    translationStateNotifier.value = {
      'status': TranslationStatus.idle,
      'translatedText': '',
      'errorMessage': '',
    };
  }
}

final translationService = TranslationService();