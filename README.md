# README.md

## barvis.sh

Este é um script em Bash chamado `barvis.sh`, que permite conversar com a API do OpenAI. Ele interage com a API do OpenAI para gerar respostas automáticas e salvar trechos de código gerados em arquivos separados.

### Pré-requisitos

Certifique-se de ter os seguintes programas instalados:

- cURL
- jq

### Como usar

Para executar o script, use o seguinte comando:

```
    ./barvis.sh [opções]
```


Opções disponíveis:

- `-k, --api-key`: Define a chave de API do OpenAI (obrigatório, a menos que a variável de ambiente `OPENAI_API_KEY` esteja definida)
- `-n, --session-name`: Define o nome da sessão de chat (padrão: data/hora atual)
- `-s, --snippet-root`: Define o diretório de snippets (padrão: 'snippets')
- `-o, --output-root`: Define o diretório de saída (padrão: 'output')
- `-m, --model`: Define o modelo da API do OpenAI (padrão: 'davinci')
- `-l, --list`: Lista todas as sessões de chat criadas
- `-h, --help`: Exibe a mensagem de ajuda

### Obter uma chave de API do OpenAI

Para gerar uma chave de API do OpenAI, siga os passos abaixo:

1. Acesse o site do OpenAI: https://beta.openai.com/signup/
2. Crie uma conta ou faça login na sua conta existente.
3. Após fazer login, vá para a seção "API Keys" no painel: https://platform.openai.com/account/api-keys
4. Clique no botão "Create API key" para gerar uma nova chave de API.
5. Copie a chave de API gerada e use-a ao executar o script `barvis.sh` com a opção `-k` ou configurando a variável de ambiente `OPENAI_API_KEY`.

Lembre-se de manter sua chave de API em segredo e não compartilhá-la publicamente.

### Configurar a chave de API do OpenAI

Você pode definir a variável de ambiente `OPENAI_API_KEY` para evitar o uso da opção `-k` ao executar o `barvis.sh`. 

No Linux ou macOS, use o seguinte comando para definir a variável de ambiente:

```
export OPENAI_API_KEY=my_api_key
```

Substitua `my_api_key` pela sua chave de API do OpenAI.

### Exemplo

Para iniciar uma sessão de chat com a chave de API do OpenAI "my_api_key", use o seguinte comando:

```
./barvis.sh -k my_api_key
```

Ou, se você já definiu a variável de ambiente `OPENAI_API_KEY`, basta executar:

```
./barvis.sh
```


Digite 'quit' para encerrar a sessão de chat.

### Licença

Este projeto é licenciado sob a Licença MIT.


