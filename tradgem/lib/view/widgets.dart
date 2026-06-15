import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../model/language.dart';
import '../model/translation_item.dart';
import '../service/translation_service.dart';

class LanguageSelectorWidget extends StatelessWidget {
  final ValueNotifier<Language> langNotifier;
  final String label;
  final void Function(Language) onSelected;

  const LanguageSelectorWidget({
    required this.langNotifier,
    required this.label,
    required this.onSelected,
    super.key,
  });

  void _showPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E1E1E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Column(
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40, height: 4,
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Selecionar $label',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: availableLanguages.length,
              itemBuilder: (_, i) {
                final lang = availableLanguages[i];
                final isSelected = lang.code == langNotifier.value.code;
                return ListTile(
                  leading: Text(lang.flag, style: const TextStyle(fontSize: 28)),
                  title: Text(
                    lang.name,
                    style: TextStyle(
                      color: isSelected ? const Color(0xFF7C6AF7) : Colors.white,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  trailing: isSelected
                      ? const Icon(Icons.check, color: Color(0xFF7C6AF7))
                      : null,
                  onTap: () {
                    onSelected(lang);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Language>(
      valueListenable: langNotifier,
      builder: (_, lang, __) {
        return GestureDetector(
          onTap: () => _showPicker(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2A),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF3A3A3A)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(lang.flag, style: const TextStyle(fontSize: 22)),
                const SizedBox(width: 8),
                Text(
                  lang.name,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.keyboard_arrow_down, color: Colors.white54, size: 18),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// WIDGET: Barra de tradução central (campo de texto + resultado)
// ═══════════════════════════════════════════════════════════════
class TranslationBoxWidget extends HookWidget {
  const TranslationBoxWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController();
    final focusNode = useFocusNode();

    return Column(
      children: [
        // Campo de entrada
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E1E),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF3A3A3A)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: controller,
                focusNode: focusNode,
                maxLines: 5,
                minLines: 3,
                style: const TextStyle(color: Colors.white, fontSize: 16),
                decoration: const InputDecoration(
                  hintText: 'Digite o texto para traduzir...',
                  hintStyle: TextStyle(color: Colors.white38),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(16),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Limpar texto
                    ValueListenableBuilder<TextEditingValue>(
                      valueListenable: controller,
                      builder: (_, val, __) => val.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, color: Colors.white38, size: 18),
                              onPressed: () {
                                controller.clear();
                                translationService.resetar();
                              },
                            )
                          : const SizedBox.shrink(),
                    ),
                    // Botão Traduzir
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7C6AF7),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                      ),
                      onPressed: () {
                        focusNode.unfocus();
                        translationService.traduzir(controller.text);
                      },
                      icon: const Icon(Icons.translate, size: 18),
                      label: const Text('Traduzir'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // Resultado da tradução
        ValueListenableBuilder<Map<String, dynamic>>(
          valueListenable: translationService.translationStateNotifier,
          builder: (_, state, __) {
            switch (state['status']) {
              case TranslationStatus.idle:
                return const SizedBox.shrink();

              case TranslationStatus.loading:
                return const Padding(
                  padding: EdgeInsets.all(24),
                  child: CircularProgressIndicator(
                    color: Color(0xFF7C6AF7),
                  ),
                );

              case TranslationStatus.ready:
                final text = state['translatedText'] as String;
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A2E),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFF7C6AF7), width: 1.5),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        text,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // Botão copiar
                          IconButton(
                            tooltip: 'Copiar tradução',
                            icon: const Icon(Icons.copy, color: Colors.white54, size: 20),
                            onPressed: () {
                              Clipboard.setData(ClipboardData(text: text));
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Copiado para a área de transferência!'),
                                  backgroundColor: Color(0xFF7C6AF7),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                );

              case TranslationStatus.error:
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2D1B1B),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.redAccent.withOpacity(0.5)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline, color: Colors.redAccent),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          state['errorMessage'],
                          style: const TextStyle(color: Colors.redAccent),
                        ),
                      ),
                    ],
                  ),
                );

              default:
                return const SizedBox.shrink();
            }
          },
        ),
      ],
    );
  }
}

class LanguageBarWidget extends StatelessWidget {
  const LanguageBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: LanguageSelectorWidget(
            langNotifier: translationService.sourceLangNotifier,
            label: 'idioma de origem',
            onSelected: translationService.selecionarIdiomaOrigem,
          ),
        ),
        // Botão inverter — Funcionalidade 4
        IconButton(
          tooltip: 'Inverter idiomas',
          icon: const Icon(Icons.swap_horiz, color: Color(0xFF7C6AF7)),
          onPressed: translationService.inverterIdiomas,
        ),
        Expanded(
          child: LanguageSelectorWidget(
            langNotifier: translationService.targetLangNotifier,
            label: 'idioma de destino',
            onSelected: translationService.selecionarIdiomaDestino,
          ),
        ),
      ],
    );
  }
}

class TranslationCardWidget extends StatelessWidget {
  final TranslationItem item;
  final VoidCallback? onFavoriteToggle;

  const TranslationCardWidget({
    required this.item,
    this.onFavoriteToggle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF3A3A3A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Linha de idiomas
          Row(
            children: [
              Text(item.fromFlag, style: const TextStyle(fontSize: 16)),
              const SizedBox(width: 4),
              Text(
                item.fromLanguage,
                style: const TextStyle(color: Colors.white54, fontSize: 12),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 6),
                child: Icon(Icons.arrow_forward, color: Colors.white38, size: 14),
              ),
              Text(item.toFlag, style: const TextStyle(fontSize: 16)),
              const SizedBox(width: 4),
              Text(
                item.toLanguage,
                style: const TextStyle(color: Colors.white54, fontSize: 12),
              ),
              const Spacer(),
              // Botão favoritar
              GestureDetector(
                onTap: onFavoriteToggle,
                child: Icon(
                  item.isFavorite ? Icons.star : Icons.star_border,
                  color: item.isFavorite ? const Color(0xFFFFD700) : Colors.white38,
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Texto original
          Text(
            item.originalText,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const Divider(color: Color(0xFF3A3A3A), height: 16),
          // Texto traduzido
          Text(
            item.translatedText,
            style: const TextStyle(
              color: Color(0xFF9D8FFA),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}