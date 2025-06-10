// Funções principais para o formulário CEEJA - Versão Completa e Otimizada

const SessionManager = {
    STORAGE_KEY: 'ceeja_form_session',
    init: function() {
        if (!this.getSession()) {
            this.createSession();
        }
        // console.log("Sessão Iniciada/Carregada:", this.getSession());
    },
    createSession: function() {
        const session = {
            user_id: this.generateUUID(),
            created_at: new Date().toISOString(),
            forms: {} // Armazenará dados e status de 'completed'
        };
        localStorage.setItem(this.STORAGE_KEY, JSON.stringify(session));
        return session;
    },
    getSession: function() {
        try {
            const sessionData = localStorage.getItem(this.STORAGE_KEY);
            return sessionData ? JSON.parse(sessionData) : null;
        } catch (e) {
            console.error("Erro ao parsear sessão do localStorage:", e);
            localStorage.removeItem(this.STORAGE_KEY); // Limpa sessão corrompida
            return null;
        }
    },
    generateUUID: function() {
        return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
            const r = Math.random() * 16 | 0,
                  v = c === 'x' ? r : (r & 0x3 | 0x8);
            return v.toString(16);
        });
    },
    getUserId: function() {
        let session = this.getSession();
        if (!session || !session.user_id) { // Garante que user_id exista
            session = this.createSession();
        }
        return session.user_id;
    },
    _saveSession: function(session) {
        localStorage.setItem(this.STORAGE_KEY, JSON.stringify(session));
    },
    saveFormCompletionStatus: function(formName) {
        const session = this.getSession() || this.createSession();
        if (!session.forms[formName]) session.forms[formName] = {};
        session.forms[formName].completed = true;
        this._saveSession(session);
    },
    savePartialFormData: function(formName, data) {
        const session = this.getSession() || this.createSession();
        session.forms[formName] = { ...(session.forms[formName] || {}), ...data };
        this._saveSession(session);
    },
    getFormData: function(formName) {
        const session = this.getSession();
        return session && session.forms && session.forms[formName] ? session.forms[formName] : null;
    },
    isFormCompleted: function(formName) {
        const data = this.getFormData(formName);
        return data && data.completed === true;
    },
    clearAllData: function() {
        localStorage.removeItem(this.STORAGE_KEY);
        alert('Todos os dados foram limpos. Você será redirecionado para o início.');
        window.location.href = 'dados-pessoais.html'; 
    },
    clearFormData: function(formName) {
        const session = this.getSession();
        if (session && session.forms && session.forms[formName]) {
            delete session.forms[formName];
            this._saveSession(session);
        }
    }
};

const InputMasks = {
    applyMaskCPF: function(input) { if(!input) return; input.addEventListener('input', function(e) {let value = e.target.value.replace(/\D/g, ''); if (value.length > 11) value = value.slice(0, 11); if (value.length > 9) { value = value.replace(/^(\d{3})(\d{3})(\d{3})(\d{1,2})$/, '$1.$2.$3-$4');} else if (value.length > 6) { value = value.replace(/^(\d{3})(\d{3})(\d{1,3})$/, '$1.$2.$3');} else if (value.length > 3) { value = value.replace(/^(\d{3})(\d{1,3})$/, '$1.$2');} e.target.value = value;}); },
    applyMaskRG: function(input) { if(!input) return; input.addEventListener('input', function(e) {let value = e.target.value.replace(/[^\d\w]/g, '').toUpperCase(); if (value.length > 9) value = value.slice(0, 9); /* Ajustar conforme formato de RG local, este é genérico */ e.target.value = value;}); },
    applyMaskPhone: function(input) { if(!input) return; input.addEventListener('input', function(e) {let value = e.target.value.replace(/\D/g, ''); if (value.length > 11) value = value.slice(0, 11); if (value.length > 10) { value = value.replace(/^(\d{2})(\d{5})(\d{4})$/, '($1) $2-$3');} else if (value.length > 6) { value = value.replace(/^(\d{2})(\d{4})(\d{1,4})$/, '($1) $2-$3');} else if (value.length > 2) { value = value.replace(/^(\d{2})(\d{1,})$/, '($1) $2');} else if (value.length > 0) { value = value.replace(/^(\d*)$/, '($1'); } e.target.value = value;}); },
    applyMaskCEP: function(input) { if(!input) return; input.addEventListener('input', function(e) {let value = e.target.value.replace(/\D/g, ''); if (value.length > 8) value = value.slice(0, 8); if (value.length > 5) { value = value.replace(/^(\d{5})(\d{1,3})$/, '$1-$2');} e.target.value = value;}); },
    applyMaskDateText: function(input) { if(!input) return; input.addEventListener('input', function(e) {let value = e.target.value.replace(/\D/g, ''); if (value.length > 8) value = value.slice(0, 8); if (value.length > 4) { value = value.replace(/^(\d{2})(\d{2})(\d{1,4})$/, '$1/$2/$3');} else if (value.length > 2) { value = value.replace(/^(\d{2})(\d{1,4})$/, '$1/$2');} e.target.value = value;}); }
};

const CEPSearch = {
    searchCEP: async function(cepValue) {
        const loadingElement = document.querySelector('.loading');
        if (loadingElement) loadingElement.classList.add('show');
        
        try {
            const response = await fetch(`https://viacep.com.br/ws/${cepValue}/json/`);
            if (!response.ok) {
                throw new Error(`Erro na requisição ao ViaCEP: ${response.statusText}`);
            }
            const data = await response.json();
            if (data.erro) {
                throw new Error('CEP não encontrado.');
            }
            return data;
        } finally {
            if (loadingElement) loadingElement.classList.remove('show');
        }
    },
    fillAddressFields: function(data, form) {
        if (data && form) {
            const trySetValue = (selector, value) => {
                const el = form.querySelector(selector);
                if (el) el.value = value || '';
            };
            trySetValue('#rua', data.logradouro);
            trySetValue('#bairro', data.bairro);
            trySetValue('#cidade', data.localidade);
            trySetValue('#estado', data.uf);
            const numeroEl = form.querySelector('#numero');
            if(numeroEl) numeroEl.focus();
        }
    }
};

const FormHandler = {
    showLoading: function(show) {
        const loadingElement = document.querySelector('.loading');
        if (loadingElement) {
            loadingElement.style.display = show ? 'flex' : 'none'; // Usa display flex/none
        }
    },
    handleSubmitForm: async function(event) {
        event.preventDefault();
        const form = event.target;
        const formName = form.getAttribute('data-form-name');
        const webhookUrl = form.getAttribute('action'); // Usa action em vez de data-webhook
        const nextPage = form.getAttribute('data-next-page');

        if (!form.checkValidity()) {
            alert('Por favor, preencha todos os campos obrigatórios (*) corretamente e verifique os formatos solicitados.');
            form.reportValidity();
            return;
        }

        FormHandler.showLoading(true);

        let payload;
        let fetchOptions = { method: 'POST' }; // Method já está no form, mas ok manter aqui
        const userId = SessionManager.getUserId();

        if (!userId) {
            alert('Erro crítico: Não foi possível obter o ID do usuário. Por favor, recarregue a página e tente novamente.');
            FormHandler.showLoading(false);
            return;
        }

        if (form.enctype === 'multipart/form-data') {
            payload = new FormData(form);
            // Adiciona user_id ao FormData
            payload.append('user_id', userId);
            fetchOptions.body = payload;
            // Não definir Content-Type para FormData, o browser faz isso
        } else {
            const data = {};
            const formData = new FormData(form);
            formData.forEach((value, key) => {
                if (key.endsWith('[]')) { // Lida com arrays de checkboxes/selects múltiplos
                    const actualName = key.slice(0, -2);
                    if (!data[actualName]) {
                        data[actualName] = [];
                    }
                    data[actualName].push(value);
                } else {
                    data[key] = value;
                }
            });
            // Adiciona user_id ao objeto JSON
            data.user_id = userId;
            payload = JSON.stringify(data);
            fetchOptions.headers = { 'Content-Type': 'application/json' };
            fetchOptions.body = payload;
        }
        
        try {
            const response = await fetch(webhookUrl, fetchOptions);
            
            // Tenta parsear como JSON, mas lida com outros tipos de resposta
            let responseData;
            const contentType = response.headers.get("content-type");
            if (contentType && contentType.indexOf("application/json") !== -1) {
                responseData = await response.json();
            } else {
                // Se não for JSON, pega como texto (pode ser uma mensagem de erro HTML, etc)
                responseData = { success: response.ok, message: await response.text() }; 
            }

            // Verifica se a resposta indica sucesso (status 2xx e/ou propriedade success: true)
            if (!response.ok || (responseData && responseData.success === false)) {
                console.error("Erro na resposta do servidor:", responseData);
                // Tenta extrair uma mensagem de erro mais útil
                const errorMessage = responseData.message || (typeof responseData === 'string' ? responseData : `Erro ${response.status} ao enviar dados.`);
                throw new Error(errorMessage);
            }
            
            // Se chegou aqui, o envio foi bem-sucedido
            SessionManager.saveFormCompletionStatus(formName); 
            const currentFormData = {}; // Pega os dados atuais para salvar no localStorage
            const allInputs = form.querySelectorAll('input:not([type="file"]), select, textarea');
            allInputs.forEach(input => {
                if (input.name) {
                    if (input.type === 'radio') {
                        if (input.checked) currentFormData[input.name] = input.value;
                    } else if (input.type === 'checkbox') {
                         if (input.name.endsWith('[]')) {
                            const actualName = input.name.slice(0, -2);
                            if (!currentFormData[actualName]) currentFormData[actualName] = [];
                            if (input.checked) currentFormData[actualName].push(input.value);
                        } else { 
                           currentFormData[input.name] = input.checked;
                        }
                    } else {
                        currentFormData[input.name] = input.value;
                    }
                }
            });
            SessionManager.savePartialFormData(formName, currentFormData); // Salva os dados atuais como parciais

            window.location.href = nextPage;
        } catch (error) {
            console.error('Erro no handleSubmitForm:', error);
            alert(`Ocorreu um erro ao enviar os dados: ${error.message}. Por favor, tente novamente ou contate o suporte.`);
        } finally {
            FormHandler.showLoading(false);
        }
    }
};

const FormLoader = {
    loadFormDataAndFillFields: function(formName, form) {
        const savedData = SessionManager.getFormData(formName);
        if (savedData && form) {
            Object.keys(savedData).forEach(key => {
                const fields = form.querySelectorAll(`[name="${key}"]`);
                if (fields.length > 0) {
                    if (fields[0].type === 'radio') {
                        fields.forEach(radio => {
                            radio.checked = (radio.value === savedData[key]);
                        });
                    } else if (fields[0].type === 'checkbox' && !key.endsWith('[]')) { // Checkbox único
                        fields[0].checked = savedData[key];
                    } else if (key.endsWith('[]') && Array.isArray(savedData[key])) { // Checkboxes múltiplos
                        const actualName = key;
                        form.querySelectorAll(`input[name="${actualName}"]`).forEach(checkbox => {
                            checkbox.checked = savedData[key].includes(checkbox.value);
                        });
                    } else {
                        fields[0].value = savedData[key] || '';
                    }
                }
            });
            // Disparar eventos change para restaurar estado visual da lógica condicional
            const conditionalControllers = [
                'nacionalidade', 'serie_requerida', 'eliminou_materias_status', 
                'dp_status', 'educacao_fisica'
            ];
            conditionalControllers.forEach(fieldName => {
                const field = form.querySelector(`[name="${fieldName}"]:checked`) || form.querySelector(`[name="${fieldName}"]`);
                if (field) {
                    field.dispatchEvent(new Event('change', { bubbles: true }));
                }
            });
            // Para dp_series[] que são checkboxes e controlam renderizarDisciplinasDP
            const dpSeriesCheckboxes = form.querySelectorAll("input[name='dp_series[]']");
            if (dpSeriesCheckboxes.length > 0 && typeof window.renderizarDisciplinasDP === 'function') {
                let shouldRenderDPs = false;
                dpSeriesCheckboxes.forEach(cb => { if (cb.checked) shouldRenderDPs = true; });
                if (shouldRenderDPs) window.renderizarDisciplinasDP();
            }
        }
    }
};

function updateProgressBar() {
    const stepsData = [
        { name: 'dados_pessoais', pathPart: 'dados-pessoais.html' },
        { name: 'endereco', pathPart: 'endereco.html' },
        { name: 'escolaridade', pathPart: 'escolaridade.html' },
        { name: 'documentos', pathPart: 'documentos.html' }
    ];
    const stepsElements = document.querySelectorAll('.progress-steps .step');
    const progressIndicator = document.querySelector('.progress-indicator'); 
    if (stepsElements.length === 0) return;

    let currentStepIndex = -1;
    const currentPath = window.location.pathname;

    stepsData.forEach((stepInfo, index) => {
        if (stepsElements[index]) {
            stepsElements[index].classList.remove('active', 'completed');
            if (SessionManager.isFormCompleted(stepInfo.name)) {
                stepsElements[index].classList.add('completed');
            }
            if (currentPath.includes(stepInfo.pathPart)) {
                currentStepIndex = index;
            }
        }
    });
    
    if (currentPath.includes('sucesso.html')) {
        stepsElements.forEach(stepEl => stepEl.classList.add('completed'));
        if(progressIndicator) progressIndicator.style.width = '100%';
    } else if (currentStepIndex !== -1 && stepsElements[currentStepIndex]) {
        stepsElements[currentStepIndex].classList.add('active');
        if (progressIndicator) {
            const progressPercentage = (currentStepIndex / (stepsData.length - 1)) * 100 * ((stepsData.length -1)/ (stepsData.length -1 + 0.33) );
            progressIndicator.style.width = `${progressPercentage}%`;
        }
    }
}

// --- Funções de Lógica Específicas para cada página ---
function setupDadosPessoaisLogic() {
    const dataNascimentoInput = document.getElementById('data_nascimento');
    const idadeInput = document.getElementById('idade');
    const radiosNacionalidade = document.querySelectorAll('input[name="nacionalidade"]');
    const campoNacionalidadeDetalhe = document.getElementById('campoNacionalidadeDetalhe');
    const labelNacionalidadeDetalhe = document.getElementById('labelNacionalidadeDetalhe');
    const inputNacionalidadeDetalhe = document.getElementById('nacionalidade_detalhe');

    // Máscaras
    InputMasks.applyMaskCPF(document.getElementById('cpf'));
    InputMasks.applyMaskRG(document.getElementById('rg'));
    InputMasks.applyMaskPhone(document.getElementById('telefone'));
    InputMasks.applyMaskDateText(document.getElementById('data_nascimento'));
    InputMasks.applyMaskDateText(document.getElementById('data_emissao_rg'));

    // Calcular Idade
    if (dataNascimentoInput && idadeInput) {
        const calcularIdade = () => {
            const dataNascimentoStr = dataNascimentoInput.value;
            if (dataNascimentoStr && dataNascimentoStr.match(/^\d{2}\/\d{2}\/\d{4}$/)) {
                const parts = dataNascimentoStr.split('/');
                const dataNascimento = new Date(parseInt(parts[2], 10), parseInt(parts[1], 10) - 1, parseInt(parts[0], 10));
                const hoje = new Date();
                let idade = hoje.getFullYear() - dataNascimento.getFullYear();
                const m = hoje.getMonth() - dataNascimento.getMonth();
                if (m < 0 || (m === 0 && hoje.getDate() < dataNascimento.getDate())) {
                    idade--;
                }
                idadeInput.value = idade >= 0 ? idade : '';
            } else {
                idadeInput.value = '';
            }
        };
        dataNascimentoInput.addEventListener('change', calcularIdade);
        dataNascimentoInput.addEventListener('blur', calcularIdade);
        calcularIdade(); // Calcula ao carregar
    }

    // Lógica Nacionalidade
    if (radiosNacionalidade.length > 0 && campoNacionalidadeDetalhe && labelNacionalidadeDetalhe && inputNacionalidadeDetalhe) {
        const toggleNacionalidadeDetalhe = () => {
            const selecionado = document.querySelector('input[name="nacionalidade"]:checked');
            if (selecionado && selecionado.value === 'Estrangeiro') {
                campoNacionalidadeDetalhe.style.display = 'block';
                labelNacionalidadeDetalhe.textContent = 'Qual?';
                inputNacionalidadeDetalhe.required = true;
            } else {
                campoNacionalidadeDetalhe.style.display = 'none';
                inputNacionalidadeDetalhe.required = false;
                inputNacionalidadeDetalhe.value = ''; // Limpa o campo
            }
        };
        radiosNacionalidade.forEach(radio => radio.addEventListener('change', toggleNacionalidadeDetalhe));
        toggleNacionalidadeDetalhe(); // Executa ao carregar
    }
}

function setupEnderecoLogic() {
    const cepInput = document.getElementById('cep');
    const form = document.getElementById('form-endereco');

    // Máscara
    InputMasks.applyMaskCEP(cepInput);

    // Busca CEP
    if (cepInput && form) {
        cepInput.addEventListener('blur', async function() {
            const cepValue = this.value.replace(/\D/g, '');
            if (cepValue.length === 8) {
                try {
                    const data = await CEPSearch.searchCEP(cepValue);
                    CEPSearch.fillAddressFields(data, form);
                } catch (error) {
                    console.error('Erro ao buscar CEP:', error);
                    alert(`Não foi possível buscar o CEP: ${error.message}`);
                }
            }
        });
    }
}

function setupEscolaridadeLogic() {
    const serieRequeridaSelect = document.getElementById('serie_requerida');
    const itinerarioContainer = document.getElementById('itinerario-container');
    const itinerarioSelect = document.getElementById('itinerario');
    const eliminouMateriasCheckbox = document.getElementById('eliminouMateriasSim');
    const disciplinasEliminadasContainer = document.getElementById('disciplinas-eliminadas-container');
    const possuiDpRadios = document.querySelectorAll('input[name="dp_status"]');
    const seriesDpContainer = document.getElementById('series-dp-container');
    const disciplinasDpContainer = document.getElementById('disciplinas-dp-container');
    const disciplinasDpCheckboxesContainer = document.getElementById('disciplinas-dp-checkboxes');
    const dpSeriesCheckboxes = document.querySelectorAll("input[name='dp_series[]']");

    // Lógica Itinerário
    if (serieRequeridaSelect && itinerarioContainer && itinerarioSelect) {
        const toggleItinerario = () => {
            if (serieRequeridaSelect.value === 'M') {
                itinerarioContainer.style.display = 'block';
                itinerarioSelect.required = true;
            } else {
                itinerarioContainer.style.display = 'none';
                itinerarioSelect.required = false;
                itinerarioSelect.value = ''; // Limpa seleção
            }
        };
        serieRequeridaSelect.addEventListener('change', toggleItinerario);
        toggleItinerario(); // Executa ao carregar
    }

    // Lógica Disciplinas Eliminadas
    if (eliminouMateriasCheckbox && disciplinasEliminadasContainer) {
        const toggleDisciplinasEliminadas = () => {
            disciplinasEliminadasContainer.style.display = eliminouMateriasCheckbox.checked ? 'block' : 'none';
        };
        eliminouMateriasCheckbox.addEventListener('change', toggleDisciplinasEliminadas);
        toggleDisciplinasEliminadas(); // Executa ao carregar
    }

    // Lógica DP
    if (possuiDpRadios.length > 0 && seriesDpContainer && disciplinasDpContainer && disciplinasDpCheckboxesContainer) {
        const toggleDpFields = () => {
            const selecionado = document.querySelector('input[name="dp_status"]:checked');
            const show = selecionado && selecionado.value === 'Sim';
            seriesDpContainer.style.display = show ? 'block' : 'none';
            // Não mostramos disciplinas-dp-container aqui, ele depende da seleção de série
            if (!show) {
                // Limpa seleções de séries e disciplinas se DP for Não
                dpSeriesCheckboxes.forEach(cb => cb.checked = false);
                disciplinasDpCheckboxesContainer.innerHTML = '';
                disciplinasDpContainer.style.display = 'none';
            }
        };

        window.renderizarDisciplinasDP = () => {
            disciplinasDpCheckboxesContainer.innerHTML = ''; // Limpa antes de renderizar
            const seriesSelecionadas = Array.from(dpSeriesCheckboxes)
                                            .filter(cb => cb.checked)
                                            .map(cb => cb.value);

            if (seriesSelecionadas.length === 0) {
                disciplinasDpContainer.style.display = 'none';
                return;
            }

            disciplinasDpContainer.style.display = 'block';
            const disciplinasPorSerie = {
                '8ª': ['Português', 'Matemática', 'História', 'Geografia', 'Ciências', 'Arte', 'Inglês'],
                '1º Ensino Médio': ['Português', 'Matemática', 'História', 'Geografia', 'Física', 'Química', 'Biologia', 'Sociologia', 'Filosofia', 'Arte', 'Inglês'],
                '2º Ensino Médio': ['Português', 'Matemática', 'História', 'Geografia', 'Física', 'Química', 'Biologia', 'Sociologia', 'Filosofia', 'Arte', 'Inglês'],
                '3º Ensino Médio': ['Português', 'Matemática', 'História', 'Geografia', 'Física', 'Química', 'Biologia', 'Sociologia', 'Filosofia', 'Arte', 'Inglês']
            };

            const disciplinasUnicas = new Set();
            seriesSelecionadas.forEach(serie => {
                if (disciplinasPorSerie[serie]) {
                    disciplinasPorSerie[serie].forEach(disc => disciplinasUnicas.add(disc));
                }
            });

            disciplinasUnicas.forEach(disciplina => {
                const id = `dp_disc_${disciplina.toLowerCase().replace(/[^a-z0-9]/g, '')}`;
                const label = document.createElement('label');
                label.htmlFor = id;
                label.className = 'checkbox-item';
                const input = document.createElement('input');
                input.type = 'checkbox';
                input.name = 'disciplinas_dp[]';
                input.value = disciplina;
                input.id = id;
                label.appendChild(input);
                label.appendChild(document.createTextNode(` ${disciplina}`));
                disciplinasDpCheckboxesContainer.appendChild(label);
            });
            // Recarregar dados salvos para disciplinas DP após renderizar
            const savedData = SessionManager.getFormData('escolaridade');
            if (savedData && savedData['disciplinas_dp[]'] && Array.isArray(savedData['disciplinas_dp[]'])) {
                 disciplinasDpCheckboxesContainer.querySelectorAll('input[type="checkbox"]').forEach(checkbox => {
                     checkbox.checked = savedData['disciplinas_dp[]'].includes(checkbox.value);
                 });
            }
        };

        possuiDpRadios.forEach(radio => radio.addEventListener('change', toggleDpFields));
        dpSeriesCheckboxes.forEach(checkbox => checkbox.addEventListener('change', renderizarDisciplinasDP));

        toggleDpFields(); // Executa ao carregar
        renderizarDisciplinasDP(); // Executa ao carregar para o caso de já haver séries selecionadas
    }
}

function setupDocumentosLogic() {
    const fileInputs = document.querySelectorAll('.file-upload input[type="file"]');

    fileInputs.forEach(input => {
        input.addEventListener('change', function(event) {
            const file = event.target.files[0];
            const previewContainer = event.target.closest('.file-upload').querySelector('.file-preview');
            const uploadText = event.target.closest('.file-upload').querySelector('.file-upload-text');
            
            previewContainer.innerHTML = ''; // Limpa preview anterior

            if (file) {
                uploadText.style.display = 'none'; // Esconde texto padrão
                const fileName = document.createElement('p');
                fileName.textContent = file.name;
                fileName.className = 'file-name';
                previewContainer.appendChild(fileName);

                if (file.type.startsWith('image/')) {
                    const reader = new FileReader();
                    reader.onload = function(e) {
                        const img = document.createElement('img');
                        img.src = e.target.result;
                        img.className = 'file-image-preview';
                        previewContainer.appendChild(img);
                    }
                    reader.readAsDataURL(file);
                } else if (file.type === 'application/pdf') {
                    const icon = document.createElement('i');
                    icon.className = 'fas fa-file-pdf file-icon-preview';
                    previewContainer.appendChild(icon);
                }
            } else {
                 uploadText.style.display = 'block'; // Mostra texto padrão se nenhum arquivo for selecionado
            }
        });

        // Adiciona suporte a Drag and Drop
        const fileUploadDiv = input.closest('.file-upload');
        if (fileUploadDiv) {
            fileUploadDiv.addEventListener('dragover', (event) => {
                event.preventDefault();
                fileUploadDiv.classList.add('dragover');
            });
            fileUploadDiv.addEventListener('dragleave', () => {
                fileUploadDiv.classList.remove('dragover');
            });
            fileUploadDiv.addEventListener('drop', (event) => {
                event.preventDefault();
                fileUploadDiv.classList.remove('dragover');
                if (event.dataTransfer.files.length > 0) {
                    input.files = event.dataTransfer.files;
                    // Dispara o evento change manualmente para atualizar a UI
                    input.dispatchEvent(new Event('change', { bubbles: true }));
                }
            });
        }
    });
}

// --- Inicialização Geral ---
document.addEventListener("DOMContentLoaded", function() {
    SessionManager.init();

    const form = document.querySelector('form');
    if (form) {
        form.addEventListener('submit', FormHandler.handleSubmitForm);
    }

    // Botão para limpar dados (opcional, pode ser adicionado em alguma página)
    const clearButton = document.getElementById('clear-storage-button');
    if (clearButton) {
        clearButton.addEventListener('click', SessionManager.clearAllData);
    }
});

