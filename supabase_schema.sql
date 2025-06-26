-- Criação do tipo ENUM para os papéis de usuário
CREATE TYPE public.user_role AS ENUM (
    'aluno',
    'administrador'
);

-- Tabela: perfis
-- Armazena informações adicionais sobre os usuários, incluindo seus papéis.
CREATE TABLE public.perfis (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    nome_completo TEXT,
    papel user_role NOT NULL DEFAULT 'aluno',
    data_criacao TIMESTAMPTZ DEFAULT now()
);

-- Adicionar comentários para clareza na tabela perfis
COMMENT ON TABLE public.perfis IS 'Tabela para armazenar perfis de usuários e seus papéis (aluno, administrador).';
COMMENT ON COLUMN public.perfis.id IS 'ID do perfil, chave primária e chave estrangeira para auth.users.id.';
COMMENT ON COLUMN public.perfis.nome_completo IS 'Nome completo do usuário.';
COMMENT ON COLUMN public.perfis.papel IS 'Papel do usuário no sistema (aluno ou administrador).';
COMMENT ON COLUMN public.perfis.data_criacao IS 'Data e hora de criação do perfil.';

-- Criação do tipo ENUM para os status de extração de documentos
CREATE TYPE public.extraction_status AS ENUM (
    'pendente',
    'processando',
    'concluido',
    'erro',
    'revisar',
    'validado',
    'automatizado'
);

-- Tabela: documentos_matricula
-- Gerencia o fluxo de automação para cada documento enviado, ligando o documento ao seu status e dados extraídos.
CREATE TABLE public.documentos_matricula (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    id_aluno UUID NOT NULL REFERENCES public.perfis(id) ON DELETE CASCADE,
    nome_arquivo TEXT NOT NULL,
    url_storage TEXT NOT NULL,
    tipo_documento TEXT NOT NULL, -- Ex: 'RG_FRENTE', 'HISTORICO_ESCOLAR', etc.
    status_extracao extraction_status NOT NULL DEFAULT 'pendente',
    dados_extraidos_ocr JSONB, -- O texto bruto extraído pelo OCR
    dados_extraidos_ia JSONB, -- O JSON estruturado que a IA gerou
    dados_confirmados JSONB, -- O JSON que o administrador revisou e confirmou
    embedding_vetorial VECTOR(384), -- Vetor para busca semântica, ajuste o tamanho conforme o modelo de embedding
    data_upload TIMESTAMPTZ DEFAULT now(),
    data_extracao TIMESTAMPTZ,
    data_validacao TIMESTAMPTZ
);

-- Adicionar comentários para clareza na tabela documentos_matricula
COMMENT ON TABLE public.documentos_matricula IS 'Tabela para rastrear o status e os dados extraídos de cada documento enviado para automação.';
COMMENT ON COLUMN public.documentos_matricula.id_aluno IS 'ID do aluno associado ao documento, chave estrangeira para perfis.id.';
COMMENT ON COLUMN public.documentos_matricula.nome_arquivo IS 'Nome original do arquivo enviado.';
COMMENT ON COLUMN public.documentos_matricula.url_storage IS 'URL do documento no Supabase Storage.';
COMMENT ON COLUMN public.documentos_matricula.tipo_documento IS 'Tipo do documento (ex: RG, CPF, Histórico Escolar).';
COMMENT ON COLUMN public.documentos_matricula.status_extracao IS 'Status atual do processo de extração e validação do documento.';
COMMENT ON COLUMN public.documentos_matricula.dados_extraidos_ocr IS 'Dados brutos de texto extraídos pelo OCR.';
COMMENT ON COLUMN public.documentos_matricula.dados_extraidos_ia IS 'Dados estruturados em JSON, extraídos pela IA.';
COMMENT ON COLUMN public.documentos_matricula.dados_confirmados IS 'Dados em JSON, confirmados ou corrigidos pelo administrador.';
COMMENT ON COLUMN public.documentos_matricula.embedding_vetorial IS 'Vetor numérico para busca de similaridade semântica do conteúdo do documento.';
COMMENT ON COLUMN public.documentos_matricula.data_upload IS 'Timestamp do upload do documento.';
COMMENT ON COLUMN public.documentos_matricula.data_extracao IS 'Timestamp da conclusão da extração pela IA.';
COMMENT ON COLUMN public.documentos_matricula.data_validacao IS 'Timestamp da validação dos dados pelo administrador.';