# Guia de Contribuição

Obrigado por considerar contribuir com o TabNews iOS! Este documento fornece diretrizes e informações sobre como você pode ajudar a melhorar o projeto.

## 📋 Índice

- [Código de Conduta](#código-de-conduta)
- [Como Posso Contribuir?](#como-posso-contribuir)
- [Desenvolvimento](#desenvolvimento)
- [Estilo de Código](#estilo-de-código)
- [Processo de Pull Request](#processo-de-pull-request)
- [Reportando Bugs](#reportando-bugs)
- [Sugerindo Melhorias](#sugerindo-melhorias)

## 📜 Código de Conduta

Este projeto e todos os participantes estão sob um código de conduta. Ao participar, espera-se que você mantenha este código. Por favor, reporte comportamentos inaceitáveis.

### Nossos Padrões

- Use linguagem acolhedora e inclusiva
- Respeite pontos de vista e experiências diferentes
- Aceite críticas construtivas graciosamente
- Foque no que é melhor para a comunidade
- Mostre empatia com outros membros da comunidade

## 🤝 Como Posso Contribuir?

Existem várias maneiras de contribuir com o projeto:

### 1. Reportar Bugs

Antes de criar um relatório de bug, verifique se o problema já não foi relatado. Se você encontrar um bug:

1. Abra uma [issue](https://github.com/rychillie/TabNews-iOS/issues/new)
2. Use um título claro e descritivo
3. Descreva os passos para reproduzir o problema
4. Forneça exemplos específicos
5. Descreva o comportamento esperado vs. o atual
6. Inclua screenshots se possível
7. Inclua informações sobre seu ambiente (versão do iOS, modelo do dispositivo, etc.)

### 2. Sugerir Melhorias

Se você tem uma ideia para melhorar o app:

1. Verifique se a sugestão já não existe nas issues
2. Abra uma nova issue com a tag `enhancement`
3. Descreva claramente sua sugestão
4. Explique por que essa melhoria seria útil
5. Se possível, forneça exemplos de implementação

### 3. Contribuir com Código

Quer adicionar uma feature ou corrigir um bug? Ótimo!

1. Faça um fork do projeto
2. Crie uma branch a partir da `main`
3. Implemente suas mudanças
4. Teste suas mudanças
5. Commit suas mudanças
6. Faça push para sua branch
7. Abra uma Pull Request

### 4. Melhorar a Documentação

Documentação é fundamental! Você pode:

- Corrigir erros de digitação
- Adicionar exemplos
- Melhorar explicações
- Traduzir documentação

## 🛠️ Desenvolvimento

### Requisitos

- macOS Monterey ou superior
- Xcode 14.0 ou superior
- Swift 5.5+
- Conhecimento de SwiftUI

### Configuração do Ambiente

1. **Clone o repositório:**
```bash
git clone https://github.com/rychillie/TabNews-iOS.git
cd TabNews-iOS
```

2. **Abra o projeto:**
```bash
open TabNews.xcodeproj
```

3. **Execute o projeto:**
   - Selecione um simulador (iPhone 14 ou superior recomendado)
   - Pressione `Cmd + R`

### Estrutura do Projeto

```
TabNews/
├── Models/           # Modelos de dados (Codable structs)
├── Services/         # Camada de serviços (API, Auth)
├── ViewModels/       # ViewModels (Lógica de negócio)
├── Views/           # Views SwiftUI (UI)
└── Assets.xcassets/ # Recursos visuais
```

### Arquitetura

O projeto segue o padrão **MVVM** (Model-View-ViewModel):

- **Models:** Estruturas de dados Codable para serialização JSON
- **Services:** Lógica de comunicação com API e outras operações
- **ViewModels:** Gerenciam estado e lógica de negócio, comunicam-se com Services
- **Views:** SwiftUI Views que observam ViewModels

## 🎨 Estilo de Código

### Swift Style Guide

Seguimos as convenções do [Swift API Design Guidelines](https://swift.org/documentation/api-design-guidelines/).

#### Principais Convenções:

**Nomenclatura:**
```swift
// Classes, Structs, Enums, Protocols: PascalCase
class APIService { }
struct UserProfile { }
enum NetworkError { }
protocol Authenticatable { }

// Variáveis, funções, parâmetros: camelCase
var userName: String
func fetchUserData() { }
```

**Organização do Código:**
```swift
// MARK: - Properties
// MARK: - Initializers
// MARK: - Lifecycle
// MARK: - Public Methods
// MARK: - Private Methods
```

**SwiftUI Views:**
```swift
struct ContentView: View {
    // MARK: - Properties
    @StateObject private var viewModel = ContentViewModel()
    
    // MARK: - Body
    var body: some View {
        // UI code
    }
    
    // MARK: - Subviews
    private var headerView: some View {
        // Subview code
    }
}
```

**Async/Await:**
```swift
// Prefira async/await em vez de closures
func fetchData() async throws -> Data {
    // implementation
}
```

**Error Handling:**
```swift
// Use enums para erros customizados
enum APIError: LocalizedError {
    case invalidURL
    case networkError(Error)
    
    var errorDescription: String? {
        // implementation
    }
}
```

### Formatação

- Indentação: 4 espaços (não tabs)
- Limite de linha: 120 caracteres (recomendado)
- Sempre use `self` apenas quando necessário
- Evite forçar unwrap (`!`) quando possível

## 🔄 Processo de Pull Request

1. **Antes de Começar:**
   - Verifique se já não existe uma PR para o mesmo problema
   - Abra uma issue para discutir mudanças grandes

2. **Durante o Desenvolvimento:**
   - Mantenha commits atômicos e com mensagens claras
   - Siga o estilo de código do projeto
   - Adicione comentários quando necessário
   - Teste suas mudanças em diferentes dispositivos/simuladores

3. **Mensagens de Commit:**
   ```
   tipo: descrição breve
   
   Descrição detalhada (opcional)
   
   Tipos: feat, fix, docs, style, refactor, test, chore
   ```
   
   Exemplos:
   ```
   feat: adiciona listagem de posts na home
   fix: corrige bug no logout do usuário
   docs: atualiza README com novas instruções
   ```

4. **Enviando a PR:**
   - Crie uma PR clara e descritiva
   - Referencie issues relacionadas
   - Descreva as mudanças realizadas
   - Adicione screenshots se houver mudanças visuais
   - Marque a PR como "draft" se ainda estiver em progresso

5. **Template de PR:**
   ```markdown
   ## Descrição
   Breve descrição das mudanças
   
   ## Tipo de Mudança
   - [ ] Bug fix
   - [ ] Nova feature
   - [ ] Breaking change
   - [ ] Documentação
   
   ## Como Foi Testado?
   Descreva os testes realizados
   
   ## Screenshots (se aplicável)
   
   ## Checklist
   - [ ] Meu código segue o estilo do projeto
   - [ ] Realizei self-review do código
   - [ ] Comentei partes complexas do código
   - [ ] Atualizei a documentação
   - [ ] Minhas mudanças não geram novos warnings
   - [ ] Testei em diferentes dispositivos
   ```

6. **Revisão:**
   - Responda aos comentários dos revisores
   - Faça as alterações solicitadas
   - Seja receptivo ao feedback

## 🐛 Reportando Bugs

### Template de Bug Report

```markdown
**Descrição do Bug**
Uma descrição clara do bug.

**Como Reproduzir**
Passos para reproduzir o comportamento:
1. Vá para '...'
2. Clique em '...'
3. Role até '...'
4. Veja o erro

**Comportamento Esperado**
Descrição do que deveria acontecer.

**Screenshots**
Se aplicável, adicione screenshots.

**Ambiente:**
 - Dispositivo: [ex: iPhone 14 Pro]
 - OS: [ex: iOS 17.0]
 - Versão do App: [ex: 1.0.0]

**Contexto Adicional**
Qualquer outra informação relevante.
```

## 💡 Sugerindo Melhorias

### Template de Feature Request

```markdown
**A Feature está Relacionada a um Problema?**
Uma descrição clara do problema. Ex: Eu fico frustrado quando [...]

**Descreva a Solução que Você Gostaria**
Uma descrição clara do que você quer que aconteça.

**Descreva Alternativas Consideradas**
Descrição de soluções ou features alternativas.

**Contexto Adicional**
Screenshots, mockups, ou outras informações relevantes.
```

## 🎯 Áreas Prioritárias

No momento, as seguintes áreas são prioritárias:

1. **Listagem de Posts:** Implementar visualização de posts da home
2. **Visualização de Post Completo:** Tela de detalhes do post
3. **Comentários:** Sistema de comentários
4. **Criação de Conteúdo:** Interface para criar posts
5. **Perfil:** Tela de perfil do usuário
6. **Testes:** Adicionar testes unitários e de UI

## 📚 Recursos Úteis

- [Documentação da API TabNews](https://www.tabnews.com.br/gabrielsozinho/documentacao-da-api-do-tabnews-com-um-exemplo-de-implementacao-em-delphi)
- [Swift.org - API Design Guidelines](https://swift.org/documentation/api-design-guidelines/)
- [SwiftUI Documentation](https://developer.apple.com/documentation/swiftui/)
- [Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/)

## ❓ Dúvidas?

Se você tiver dúvidas sobre como contribuir:

1. Verifique a documentação existente
2. Procure em issues fechadas
3. Abra uma issue com a tag `question`
4. Entre em contato através do [TabNews](https://www.tabnews.com.br/rychillie)

## 🙏 Agradecimentos

Obrigado por dedicar seu tempo para contribuir com o TabNews iOS! Cada contribuição, por menor que seja, é muito valiosa para o projeto.

---

**Lembre-se:** O objetivo é criar uma experiência incrível para a comunidade TabNews no iOS. Vamos fazer isso juntos! 🚀
