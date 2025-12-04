# TabNews iOS

<p align="center">
  <img src="https://img.shields.io/badge/iOS-15.0+-blue.svg" alt="iOS 15.0+">
  <img src="https://img.shields.io/badge/Swift-5.5+-orange.svg" alt="Swift 5.5+">
  <img src="https://img.shields.io/badge/SwiftUI-3.0+-green.svg" alt="SwiftUI 3.0+">
  <img src="https://img.shields.io/badge/License-MIT-yellow.svg" alt="License: MIT">
</p>

Um cliente iOS não oficial para o [TabNews](https://www.tabnews.com.br), desenvolvido com SwiftUI e consumindo a API pública da plataforma.

> **⚠️ Aviso:** Este não é um projeto oficial do TabNews. Trata-se de um cliente iOS desenvolvido de forma independente, utilizando a API pública disponibilizada pela plataforma.

## 📱 Sobre o Projeto

O TabNews iOS surgiu do desejo de ter uma experiência nativa para iOS ao acessar o TabNews. Como a comunidade demonstrou interesse na ideia, o projeto foi iniciado e está sendo desenvolvido de forma aberta e colaborativa.

### Status Atual

Atualmente o app conta com as seguintes funcionalidades:

- ✅ Login de usuário
- ✅ Logout
- 🚧 Listagem de conteúdos (em desenvolvimento)
- 🚧 Visualização de posts (em desenvolvimento)
- 🚧 Comentários (planejado)
- 🚧 Criação de posts (planejado)
- 🚧 Perfil de usuário (planejado)

## 🚀 Tecnologias

- **Swift 5.5+**
- **SwiftUI** - Framework de interface
- **Async/Await** - Para operações assíncronas
- **URLSession** - Para comunicação com a API

## 📋 Requisitos

- iOS 15.0 ou superior
- Xcode 14.0 ou superior
- macOS Monterey ou superior (para desenvolvimento)

## 🔧 Instalação

1. Clone o repositório:
```bash
git clone https://github.com/rychillie/TabNews-iOS.git
cd TabNews-iOS
```

2. Abra o projeto no Xcode:
```bash
open TabNews.xcodeproj
```

3. Execute o projeto:
   - Selecione um simulador ou dispositivo físico
   - Pressione `Cmd + R` ou clique no botão de play

## 🏗️ Estrutura do Projeto

```
TabNews/
├── Models/           # Modelos de dados
├── Services/         # Serviços de API e autenticação
├── ViewModels/       # ViewModels (MVVM)
├── Views/           # Views do SwiftUI
└── Assets.xcassets/ # Recursos visuais
```

## 📡 API

O projeto utiliza a API pública do TabNews. A documentação completa da API pode ser encontrada na [documentação da comunidade](https://www.tabnews.com.br/GabrielSozinho/documentacao-da-api-do-tabnews).

**Base URL:** `https://www.tabnews.com.br/api/v1`

### Endpoints Principais

- `POST /sessions` - Autenticação
- `GET /contents` - Listagem de conteúdos
- `GET /contents/{user}/{slug}` - Detalhes de um post
- `POST /contents` - Criar conteúdo
- `GET /contents/{user}/{slug}/children` - Comentários

## 🤝 Contribuindo

Contribuições são muito bem-vindas! Por favor, leia o [Guia de Contribuição](CONTRIBUTING.md) antes de enviar sua Pull Request.

### Como Contribuir

1. Faça um Fork do projeto
2. Crie uma branch para sua feature (`git checkout -b feature/MinhaFeature`)
3. Commit suas mudanças (`git commit -m 'Adiciona MinhaFeature'`)
4. Push para a branch (`git push origin feature/MinhaFeature`)
5. Abra uma Pull Request

## 📝 Roadmap

- [ ] Implementar listagem de posts da página inicial
- [ ] Implementar visualização completa de posts
- [ ] Adicionar suporte a comentários
- [ ] Implementar criação de posts
- [ ] Adicionar edição de posts
- [ ] Implementar perfil de usuário
- [ ] Adicionar sistema de notificações
- [ ] Implementar busca
- [ ] Modo escuro/claro
- [ ] Suporte a iPad
- [ ] Suporte a widgets

## 🐛 Reportando Bugs

Encontrou um bug? Por favor, abra uma [issue](https://github.com/rychillie/TabNews-iOS/issues) descrevendo:

- O comportamento esperado
- O comportamento atual
- Passos para reproduzir
- Screenshots (se aplicável)
- Versão do iOS e do app

## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.

## 👤 Autor

**Rychillie Umpierre de Oliveira**

- GitHub: [@rychillie](https://github.com/rychillie)
- TabNews: [@rychillie](https://www.tabnews.com.br/rychi)
- Twitter: [@rychillie](https://twitter.com/rychillie)
- LinkedIn: [Rychillie Umpierre de Oliveira](https://www.linkedin.com/in/rychillie/)
- Website: [rychillie.net](https://rychillie.net)

## 🙏 Agradecimentos

- [TabNews](https://www.tabnews.com.br) e [Filipe Deschamps](https://github.com/filipedeschamps) pela plataforma incrível e API pública
- Toda a comunidade TabNews pelo apoio e interesse no projeto
- Todos os contribuidores que ajudarem a tornar este projeto melhor

## ⚖️ Disclaimer

Este é um projeto independente e não possui afiliação oficial com o TabNews ou seus criadores. O app utiliza apenas APIs públicas disponibilizadas pela plataforma.

---

Feito com ❤️ para a comunidade TabNews
