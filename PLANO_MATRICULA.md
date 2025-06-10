# Plano de Ação Final: Requerimento de Matrícula

O objetivo é criar um fluxo de 4 etapas no aplicativo para coletar e salvar os dados de um novo requerimento de matrícula no Supabase, finalizando com uma tela de sucesso.

## Diagrama do Fluxo de Dados

```mermaid
graph TD
    subgraph App Flutter
        A[Tela Inicial] --> B{Requerimento de Matrícula};
        B --> C[Passo 1: Dados Pessoais];
        C --> D[Passo 2: Endereço];
        D --> E[Passo 3: Escolaridade];
        E --> F[Passo 4: Dados dos Documentos];
        F --> G[Resumo e Confirmação];
    end

    G -- Salvar --> H[Banco de Dados Supabase];
    H -- Resposta de Sucesso --> I[Tela de Sucesso];

    subgraph Automação (Processo Externo)
        J(Selenium) -- Lê dados --> H;
        J -- Preenche formulário --> K[Site da SEDUC];
    end
```

## Detalhamento das Etapas de Implementação

### 1. Estrutura do Módulo (Scaffolding)

-   Criação da estrutura de diretórios em `lib/features/enrollment/` com as pastas `data`, `presentation` e `domain`.

### 2. Navegação e Controle de Estado

-   Implementação de um `EnrollmentProvider` para gerenciar o estado do formulário multi-etapas.
-   Uso de um `PageView` ou `Stepper` para a navegação entre as telas do formulário.

### 3. Criação das Telas (Widgets)

-   **Tela 1: Dados Pessoais (`personal_data_screen.dart`)**
    -   Formulário com campos baseados no schema `DadosPessoaisRequest`.

-   **Tela 2: Endereço (`address_screen.dart`)**
    -   Formulário com campos baseados no schema `EnderecoResidencialRequest`.

-   **Tela 3: Escolaridade (`schooling_screen.dart`)**
    -   Formulário com campos baseados no arquivo `seduc-inscricoes`.

-   **Tela 4: Documentos (`documents_screen.dart`)**
    -   Formulário para coletar os **dados textuais** dos documentos (CPF, RG, etc.), baseado no schema `DocumentosRequest`. O upload de arquivos será implementado em uma fase futura.

-   **Tela 5: Sucesso (`success_screen.dart`)**
    -   Uma tela simples e agradável para confirmar ao usuário que os dados foram enviados com sucesso.

### 4. Integração com Supabase

-   Criação da tabela `enrollment_requests` no Supabase para armazenar os dados coletados.
-   Implementação do `EnrollmentRepository` para fazer a comunicação (escrita) com o Supabase.