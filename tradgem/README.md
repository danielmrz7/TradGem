#  TradGem

> Aplicativo de tradução de idiomas com IA, desenvolvido em Flutter e integrado com a API Gemini do Google.

---

# Sobre o Projeto

O TradGem é um aplicativo mobile/desktop desenvolvido em Flutter como projeto da disciplina de Programação Orientada a Objetos. Ele permite traduzir textos entre múltiplos idiomas de forma simples e rápida, utilizando o poder da API Gemini como motor de tradução.

---

# Funcionalidades

- Tradução em tempo real — Traduz textos utilizando o modelo Gemini AI
- 12 idiomas suportados — Português, Inglês, Espanhol, Francês, Alemão, Italiano, Japonês, Chinês, Árabe, Russo, Coreano e Hindi
- Inversão de idiomas— Troca o idioma de origem e destino com um clique
- Histórico de traduções — Mantém um registro das traduções realizadas na sessão
- Favoritos— Salve suas traduções favoritas para acesso rápido
- Tela Sobre— Informações sobre o app e o projeto
- Tema escuro — Interface com design moderno em dark mode



# Tecnologias Utilizadas

| Tecnologia | Versão | Finalidade |
|---|---|---|
| [Flutter](https://flutter.dev/) | ≥ 3.0.0 | Framework principal |
| [Dart](https://dart.dev/) | ≥ 3.0.0 | Linguagem de programação |
| [Gemini API](https://ai.google.dev/) | — | Motor de tradução com IA |
| [GetX](https://pub.dev/packages/get) | ^4.6.6 | Gerenciamento de rotas |
| [flutter_hooks](https://pub.dev/packages/flutter_hooks) | ^0.20.5 | Hooks para state management |
| [http](https://pub.dev/packages/http) | ^1.2.1 | Requisições HTTP |
| [flutter_dotenv](https://pub.dev/packages/flutter_dotenv) | ^6.0.1 | Variáveis de ambiente |
| [flutter_svg](https://pub.dev/packages/flutter_svg) | ^2.0.10 | Renderização de SVGs |

---

# Estrutura do Projeto

```
tradgem/
├── lib/
│   ├── main.dart                    # Ponto de entrada e configuração do app
│   ├── model/
│   │   ├── language.dart            # Modelo de idioma e lista de idiomas disponíveis
│   │   └── translation_item.dart   # Modelo de item de tradução (histórico/favoritos)
│   ├── service/
│   │   └── translation_service.dart # Serviço de tradução com a API Gemini
│   └── view/
│       ├── screens.dart             # Telas: Home, Histórico, Favoritos, Sobre
│       └── widgets.dart             # Widgets reutilizáveis
├── .env                             # Variáveis de ambiente (não commitado)
├── pubspec.yaml                     # Dependências do projeto
└── analysis_options.yaml
```

---

# Como Executar

# Pré-requisitos

- [Flutter SDK](https://docs.flutter.dev/get-started/install) instalado (versão ≥ 3.0.0)
- Uma chave de API do Google Gemini ([obtenha aqui](https://aistudio.google.com/app/apikey))

# Passo a passo

*1. Clone o repositório*
```bash
git clone https://github.com/danielmrz7/TradGem.git
cd TradGem/tradgem
```

*2. Instale as dependências*
```bash
flutter pub get
```

*3. Configure as variáveis de ambiente*

Crie um arquivo `.env` na raiz da pasta `tradgem/` com o seguinte conteúdo:

```env
GEMINI_API_KEY=sua_chave_de_api_aqui
GEMINI_API_URL=https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent
```

*Atenção:* Nunca commite o arquivo `.env` com sua chave de API. Adicione-o ao `.gitignore`.

*4. Execute o aplicativo*
```bash
flutter run
aperte 2 para abrir o arquivo no Microsoft Edge (Recomendado)
```

---

# Idiomas Disponíveis

| Bandeira | Idioma | Código |
|---|---|---|
| 🇧🇷 | Português | `pt` |
| 🇺🇸 | Inglês | `en` |
| 🇪🇸 | Espanhol | `es` |
| 🇫🇷 | Francês | `fr` |
| 🇩🇪 | Alemão | `de` |
| 🇮🇹 | Italiano | `it` |
| 🇯🇵 | Japonês | `ja` |
| 🇨🇳 | Chinês | `zh` |
| 🇸🇦 | Árabe | `ar` |
| 🇷🇺 | Russo | `ru` |
| 🇰🇷 | Coreano | `ko` |
| 🇮🇳 | Hindi | `hi` |

---

# Telas do App

| Home | Histórico | Favoritos |
|---|---|---|
| Seleção de idiomas e campo de tradução | Lista de traduções realizadas na sessão | Traduções marcadas como favoritas |

---

# Arquitetura

O projeto segue os princípios de Programação Orientada a Objetos com separação clara em camadas:

- **Model** — Classes de dados (`Language`, `TranslationItem`)
- **Service** — Lógica de negócio e integração com a API (`TranslationService`)
- **View** — Interface do usuário com telas e widgets reutilizáveis

O gerenciamento de estado é feito com `ValueNotifier` (nativo do Flutter) e as rotas são gerenciadas pelo **GetX**.

---

## Licença

Este projeto está licenciado sob a licença MIT. Consulte o arquivo [LICENSE](LICENSE) para mais detalhes.

---

##  Autor

Desenvolvido por Daniel Mariz como projeto de POO em Flutter.

---

<p align="center">
  Feito com Flutter
</p>