# Plano Detalhado para Extração de Dados de Documentos com Controle de Acesso

Este plano integra a sua ideia de automatização com a necessidade de um sistema robusto de papéis/permissões.

---

### 1. Visão Geral do Novo Fluxo de Trabalho (Atualizado)

O fluxo de trabalho proposto, agora com a camada de controle de acesso:

```mermaid
graph TD
    A[Usuário faz Upload de Documento (Imagem/PDF)] --> B{Serviço de Extração de Dados};
    B --> C[OCR (Reconhecimento Óptico de Caracteres)];
    C --> D[Processamento de IA/ML (Extração de Entidades/Campos)];
    D --> E[Armazenamento de Dados Estruturados no Supabase];
    E --> F[Armazenamento de Embeddings Vetoriais (pgvector)];
    F --> G[Notificação ao Usuário/Admin];
    G --> H{Verificação de Papel do Usuário};
    H -- Usuário = Admin --> I[Tela de Revisão/Edição de Dados no App Flutter];
    H -- Usuário = Aluno --> J[Tela de Status do Documento/Aguardando Revisão];
    I --> K{Confirmação/Validação dos Dados};
    K -- Dados Válidos --> L[Disparo da Automação Selenium (Python)];
    L --> M[Atualização de Status no Supabase];
    K -- Dados Inválidos --> I;
```

---

### 2. Considerações no Supabase (Atualizado)

O Supabase será o coração do seu backend, lidando com armazenamento, banco de dados, autenticação e controle de acesso.

*   **Autenticação e Autorização:**
    *   **Tabela `perfis` (ou `user_profiles`):**
        *   Crie uma nova tabela para armazenar informações adicionais sobre os usuários, incluindo seus papéis.
        *   `id` (UUID, FK para [`auth.users.id`](auth.users.id), chave primária)
        *   `nome_completo` (TEXT)
        *   `papel` (TEXT, ex: 'aluno', 'administrador', 'moderador'). Use um `ENUM` para garantir valores válidos.
        *   `data_criacao` (TIMESTAMP)
        *   **População:** Ao registrar um novo usuário via [`auth.signUp()`](auth.signUp()), você precisará de uma função (trigger ou Edge Function) para criar automaticamente uma entrada correspondente nesta tabela `perfis` com o `papel` padrão (ex: 'aluno').
    *   **Row Level Security (RLS):**
        *   **Tabela `perfis`:**
            *   Política para que usuários possam ler *apenas* seu próprio perfil.
            *   Política para que administradores possam ler e atualizar *todos* os perfis (para gerenciar papéis).
        *   **Tabela de Documentos (`documentos_matricula`):**
            *   Política para que alunos possam fazer upload e ver *apenas* seus próprios documentos.
            *   Política para que administradores possam ver e gerenciar *todos* os documentos e seus dados extraídos.
            *   Política para que apenas o serviço de extração (via chave de serviço ou função específica) possa inserir/atualizar os dados extraídos.
*   **Armazenamento de Documentos (Supabase Storage):**
    *   Crie um bucket específico para os documentos de matrícula (ex: `documentos_matricula`).
    *   Configure as políticas de segurança (RLS) para garantir que apenas usuários autorizados (alunos para seus próprios documentos, administradores para todos) possam fazer upload e acessar os documentos.
    *   Considere a organização dos arquivos (ex: `bucket/id_aluno/tipo_documento/nome_arquivo.pdf`).
*   **Esquema do Banco de Dados (PostgreSQL):**
    *   **Tabela de Documentos (`documentos_matricula`):**
        *   `id` (UUID)
        *   `id_aluno` (UUID, FK para [`auth.users.id`](auth.users.id) e [`perfis.id`](perfis.id))
        *   `nome_arquivo` (TEXT)
        *   `url_storage` (TEXT, URL para o documento no Supabase Storage)
        *   `tipo_documento` (TEXT, ex: 'RG', 'CPF', 'Histórico Escolar')
        *   `status_extracao` (ENUM/TEXT, ex: 'pendente', 'processando', 'concluido', 'erro', 'revisar', 'validado', 'automatizado')
        *   `dados_extraidos_ocr` (JSONB, texto bruto do OCR)
        *   `dados_extraidos_ia` (JSONB, JSON com campos extraídos como nome, CPF, data de nascimento, etc.)
        *   `dados_confirmados` (JSONB, para os dados após a revisão do usuário/administrador)
        *   `embedding_vetorial` (VECTOR, para armazenar os embeddings do texto do documento, se usar `pgvector`).
        *   `data_upload` (TIMESTAMP)
        *   `data_extracao` (TIMESTAMP, quando a extração foi concluída)
        *   `data_validacao` (TIMESTAMP, quando os dados foram confirmados)
*   **Extensão `pgvector` para Busca Semântica (Opcional, mas recomendado):**
    *   Se você quiser fazer buscas por similaridade no conteúdo dos documentos (ex: "encontre todos os documentos que mencionam 'ensino médio'"), a extensão `pgvector` é fundamental.
    *   Você precisará gerar embeddings (vetores numéricos) do texto extraído dos documentos usando um modelo de linguagem (LLM) e armazená-los nesta coluna.
*   **Funções do Supabase (Edge Functions / Database Functions):**
    *   **Webhook/Trigger:** Configure um webhook ou um trigger de banco de dados (via `supabase_realtime`) para ser acionado quando um novo documento for carregado no Storage ou quando o status de um documento mudar. Este trigger pode chamar uma Edge Function ou um serviço externo.
    *   **Edge Functions:** Use Edge Functions (baseadas em Deno) para orquestrar o processo de extração. Elas podem:
        1.  Receber o evento de upload.
        2.  Chamar um serviço externo de OCR/IA (ex: Google Cloud Vision AI, AWS Textract, ou um serviço Python rodando em um servidor).
        3.  Receber os dados extraídos.
        4.  Atualizar o banco de dados com os dados extraídos e o novo status.
        5.  Gerar embeddings vetoriais e armazená-los.
        6.  **Disparo da Automação (Opcional):** Uma Edge Function pode ser o ponto de entrada para disparar o script Selenium, passando os dados confirmados.
*   **Realtime:** Utilize o Realtime do Supabase para notificar o aplicativo Flutter sobre o status da extração do documento em tempo real e para atualizações sobre a automação.

---

### 3. Considerações no Código (Flutter - Frontend) (Atualizado)

O aplicativo Flutter será a interface para o usuário interagir com os documentos e dados, respeitando os papéis.

*   **Lógica de Autenticação e Perfil:**
    *   Após o login, o aplicativo deve buscar o `papel` do usuário na tabela `perfis`.
    *   Armazene o papel do usuário em um provedor de estado (ex: Provider, Riverpod, BLoC) para acesso fácil em todo o aplicativo.
*   **Controle de Acesso na UI:**
    *   **Renderização Condicional:** O botão "admin-enrollment" e outras funcionalidades administrativas (ex: lista de todos os documentos, tela de gerenciamento de usuários) devem ser renderizadas *apenas* se o usuário logado tiver o `papel` de 'administrador'.
    *   **Proteção de Rotas:** Implemente um sistema de guarda de rotas no seu `AppRouter` (se estiver usando GoRouter ou similar) que verifica o papel do usuário antes de permitir o acesso a rotas sensíveis (ex: `/admin_enrollment`). Se um usuário não autorizado tentar acessar, redirecione-o para a tela inicial ou uma tela de "Acesso Negado".
*   **Tela de Upload de Documentos:**
    *   Interface intuitiva para o usuário selecionar e fazer upload de arquivos (imagens ou PDFs).
    *   Indicadores de progresso de upload.
    *   Integração com o Supabase Storage para o upload.
*   **Exibição do Status de Extração:**
    *   Mostre ao usuário o status de cada documento (ex: "Enviado", "Processando", "Pronto para Revisão", "Erro na Extração", "Validado", "Automatizado").
    *   Use o Realtime do Supabase para atualizar esses status dinamicamente.
    *   Para alunos, a tela pode mostrar "Documento em Revisão pelo Administrador".
*   **Tela de Revisão e Edição de Dados (Apenas para Administradores):**
    *   Crie formulários dinâmicos que pré-preenchem os campos com os dados extraídos pela IA.
    *   Permita que o administrador revise, corrija e adicione informações.
    *   Validação de campos (ex: formato de CPF, data).
    *   Feedback visual claro sobre quais campos foram extraídos com alta confiança e quais podem precisar de mais atenção.
    *   Botão de "Confirmar e Validar" que, ao ser clicado, salva os dados *confirmados* no Supabase e dispara a automação.
*   **Integração com Supabase:**
    *   Use o SDK do Supabase para Flutter para interagir com o Storage e o banco de dados.
    *   Funções para upload de arquivos.
    *   Funções para ler e escrever dados nas tabelas de documentos e dados extraídos, respeitando o RLS.
    *   Escutadores de Realtime para atualizações de status.
*   **Navegação:**
    *   Gerencie a navegação entre as telas de upload, status e revisão de dados, considerando o papel do usuário.

---

### 4. Considerações no Código (Python - Backend/Automação) (Atualizado)

O Python será responsável pela lógica de extração de dados (OCR/IA) e pela automação Selenium.

*   **Serviço de Extração de Dados (OCR/IA):**
    *   Este serviço pode ser um servidor Python (ex: Flask, FastAPI) rodando em algum lugar.
    *   **OCR:**
        *   **Bibliotecas:** `Pillow`, `pytesseract` ou APIs de nuvem (Google Cloud Vision AI, AWS Textract).
        *   **Pré-processamento:** Binarização, remoção de ruído, correção de rotação.
    *   **Extração de Dados Estruturados (IA/ML):**
        *   **Modelos de Linguagem:** PLN para NER (ex: `spaCy`, `NLTK`, `Hugging Face Transformers`). Para documentos complexos, considere "Document AI" de serviços de nuvem.
        *   **Validação Inicial:** Lógica para validar a plausibilidade dos dados extraídos.
    *   **Geração de Embeddings Vetoriais:** Use um modelo de embedding (ex: `sentence-transformers` ou APIs de LLMs) para converter texto em vetores numéricos e envie para o Supabase.
    *   **Comunicação Segura com Supabase:** Use a chave de serviço (Service Role Key) do Supabase para que este serviço possa escrever no banco de dados sem restrições de RLS (apenas para operações de backend). **Nunca exponha a Service Role Key no frontend.**
*   **Automação Selenium (Python):**
    *   **Consumo de Dados:** O script Selenium agora lerá os dados *confirmados* diretamente do Supabase.
    *   **Disparo:** O script Selenium será disparado *após* a validação e confirmação dos dados pelo administrador no aplicativo Flutter.
        *   **Webhook/API:** O aplicativo Flutter, ao confirmar os dados, chama uma API no seu serviço Python que dispara o Selenium.
        *   **Fila de Mensagens:** Coloque uma mensagem em uma fila (ex: Redis, RabbitMQ, ou até mesmo uma tabela no Supabase monitorada) que o script Selenium consome.
        *   **Supabase Edge Function:** A Edge Function pode chamar o serviço Python.
    *   **Robustez:** Implemente tratamento de erros robusto no Selenium (tentativas, capturas de tela em caso de falha) e registre o progresso e os resultados da automação no Supabase.
    *   **Credenciais:** Gerencie as credenciais do Selenium de forma segura (ex: variáveis de ambiente, Supabase Vault).

---

### 5. Considerações Gerais (Atualizado)

*   **Escalabilidade:** Planeje a escalabilidade do seu serviço de extração de dados e da automação.
*   **Segurança:**
    *   **RLS no Supabase:** Essencial para proteger seus dados.
    *   **Proteção de APIs:** Autentique e autorize chamadas para seu serviço de extração/automação.
    *   **Gerenciamento de Credenciais:** Nunca exponha chaves de API ou credenciais no frontend.
*   **Tratamento de Erros e Retentativas:**
    *   Fluxo para re-enviar documentos ou corrigir erros de extração.
    *   Mecanismos de retentativa para chamadas de API e automação Selenium.
*   **Custo:** Monitore os custos de serviços de nuvem (OCR/IA, hospedagem).
*   **Experiência do Usuário (UX):**
    *   Mantenha o usuário informado sobre o progresso da extração.
    *   Torne a tela de revisão e edição o mais fácil e rápida possível para o administrador.
    *   Destaque os campos que a IA tem menos confiança.