#!/bin/bash

# Define a variável api_key com o valor da variável de ambiente OPENAI_API_KEY, ou uma string vazia se ela não estiver definida
api_key="${OPENAI_API_KEY:-}"

# Variáveis padrão
model="gpt-3.5-turbo"
snippet_root="snippets"
output_root="output"

# Função para exibir a mensagem de ajuda
show_help() {
  echo "barvis.sh - Script em Bash para conversar com a API de bate-papo do OpenAI"
  echo ""
  echo "Opções disponíveis:"
  echo "-k, --api-key      Define a chave de API do OpenAI (obrigatório)"
  echo "-n, --session-name Define o nome da sessão de chat (padrão: data/hora atual)"
  echo "-s, --snippet-root Define o diretório de snippets (padrão: 'snippets')"
  echo "-o, --output-root  Define o diretório de saída (padrão: 'output')"
  echo "-m, --model        Define o modelo da API do OpenAI (padrão: 'davinci')"
  echo "-l, --list         Lista todas as sessões de chat criadas"
  echo "-h, --help         Exibe esta mensagem de ajuda"
}

# Função para verificar se os requisitos estão instalados
check_sanity() {
  # Verifica se o cURL está instalado
  if ! command -v curl &> /dev/null; then
    echo "cURL não encontrado. Instale o cURL e tente novamente."
    exit 1
  fi

  # Verifica se o jq está instalado
  if ! command -v jq &> /dev/null; then
    echo "jq não encontrado. Instale o jq e tente novamente."
    exit 1
  fi
}

# Processa os argumentos da linha de comando
while [[ "$#" -gt 0 ]]; do
  case $1 in
    -k|--api-key) api_key="$2"; shift;;
    -n|--session-name) session_name="$2"; shift;;
    -s|--snippet-root) snippet_root="$2"; shift;;
    -o|--output-root) output_root="$2"; shift;;
    -m|--model) model="$2"; shift;;
    -l|--list) list_sessions="true";;
    -h|--help) show_help; exit 0;;
    *) echo "Opção inválida: $1. Use -h ou --help para exibir ajuda"

  esac
  shift
done

# Verifica se a chave de API foi fornecida
if [ -z "$api_key" ]; then
  echo "A chave de API do OpenAI é obrigatória. Use -k ou --api-key para fornecê-la."
  exit 1
fi

# Verifica se a sessão de chat foi fornecida
if [ -z "$session_name" ]; then
  session_name=$(date +"%Y-%m-%d_%H-%M-%S")
fi

# Cria o diretório da sessão de chat
if [ ! -d "$session_name" ]; then
  mkdir "$session_name"
fi

# Se a opção --list foi fornecida, lista todas as sessões de chat existentes
if [ "$list_sessions" = "true" ]; then
  echo "Sessões de chat existentes:"
  ls -d */ | sed 's/\/$//' | grep -v "venv"
  exit 0
fi

# Verifica se as dependências estão instaladas
check_sanity

# Cria o diretório de snippets
snippet_dir="$session_name/$snippet_root"
if [ ! -d "$snippet_dir" ]; then
  mkdir "$snippet_dir"
fi

# Cria o diretório de saída
output_dir="$session_name/$output_root"
if [ ! -d "$output_dir" ]; then
  mkdir "$output_dir"
fi

# Cria o arquivo de descrição da sessão de chat
chat_description_file="$session_name/description.txt"
echo "Descrição da sessão de chat '$session_name':" > "$chat_description_file"
echo "" >> "$chat_description_file"
echo "Data/Hora de início: $(date +"%Y-%m-%d %H:%M:%S")" >> "$chat_description_file"
echo "Modelo da API do OpenAI: $model" >> "$chat_description_file"
echo "" >> "$chat_description_file"

# Inicia a sessão de chat
echo "Sessão de chat iniciada. Digite 'quit' para encerrar a sessão."
while true; do
  # Lê a entrada do usuário
  read -p "> " input

  # Sai da sessão de chat se o usuário digitar 'quit'
  if [[ $input == "quit" ]]; then
    echo "Sessão de chat concluída. Obrigado por usar o barvis!"
    exit 0
  fi

  # Gera uma resposta usando a API do OpenAI
  response=$(curl -s -X POST https://api.openai.com/v1/chat/completions \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $api_key" \
    -d "{\"model\": \"$model\", \"messages\": [{\"role\": \"user\", \"content\": \"$input\"}], \"max_tokens\": 150, \"temperature\": 0.7}")

  # Extrai o texto da resposta gerada pela API do OpenAI
  output=$(printf "%s" "$response" | jq -r '.choices[].message.content')

  # Salva a resposta gerada pela API do OpenAI em um arquivo
  output_file="$output_dir/$(date +"%Y-%m-%d_%H-%M-%S_%N").txt"
  echo "$output" > "$output_file"

  # Extrai os trechos de código da resposta gerada pela API do OpenAI
  snippet=$(printf "%s" "$response" | jq -r '.choices[].message.content' | sed -n '/```/,/```/p' | sed 's/```//g')

    snippet_file="$snippet_dir/$(date +"%Y-%m-%d_%H-%M-%S_%N").txt"
    echo "$snippet" > "$snippet_file"

  # Exibe a resposta gerada pela API do OpenAI
  echo "$output"
done

# Exibe uma mensagem de erro se algo der errado
trap 'echo "Ocorreu um erro. Saindo." >&2; exit 1' ERR

# Exibe uma mensagem de boas-vindas
echo "Bem-vindo ao barvis.sh! Use -h ou --help para exibir a ajuda."

# Fim do script

