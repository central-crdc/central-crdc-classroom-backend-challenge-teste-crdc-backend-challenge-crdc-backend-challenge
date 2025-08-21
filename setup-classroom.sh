#!/usr/bin/env bash
set -euo pipefail

echo "🎓 Configurando GitHub Classroom para CRDC Backend Challenge"
echo "=================================================="

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Verificar se gh CLI está instalado
if ! command -v gh &> /dev/null; then
    echo -e "${RED}❌ GitHub CLI (gh) não está instalado${NC}"
    echo "Instale em: https://cli.github.com/"
    exit 1
fi

# Verificar autenticação
if ! gh auth status &> /dev/null; then
    echo -e "${RED}❌ Não autenticado no GitHub${NC}"
    echo "Execute: gh auth login"
    exit 1
fi

# Detectar org/repo
REPO_URL=$(git remote get-url origin)
if [[ "$REPO_URL" =~ github.com[:/]+([^/]+)/([^/.]+)(.git)?$ ]]; then
    ORG="${BASH_REMATCH[1]}"
    REPO="${BASH_REMATCH[2]}"
else
    echo -e "${RED}❌ Não foi possível detectar org/repo${NC}"
    exit 1
fi

echo -e "${GREEN}✓${NC} Repositório: ${ORG}/${REPO}"

# Configurar como template repository
echo -e "\n${YELLOW}Configurando repositório como template...${NC}"
gh api -X PATCH "repos/${ORG}/${REPO}" \
    -f is_template=true \
    -f description="Template para desafio técnico backend CRDC com foco em migração de monólito" \
    --silent

echo -e "${GREEN}✓${NC} Repositório configurado como template"

# Adicionar topics
echo -e "\n${YELLOW}Adicionando topics...${NC}"
echo '{
  "names": [
    "backend-challenge",
    "microservices", 
    "migration",
    "observability",
    "github-classroom",
    "crdc"
  ]
}' | gh api -X PUT "repos/${ORG}/${REPO}/topics" \
    --input - \
    --silent

echo -e "${GREEN}✓${NC} Topics adicionados"

# Criar labels para issues
echo -e "\n${YELLOW}Criando labels...${NC}"
labels=(
    "help-wanted:Dúvidas sobre o desafio:#008672"
    "submission:Submissão do candidato:#0075ca"
    "evaluation:Em avaliação:#d73a4a"
    "approved:Aprovado:#2ea44f"
    "feedback:Feedback do instrutor:#7057ff"
)

for label in "${labels[@]}"; do
    IFS=':' read -r name description color <<< "$label"
    gh label create "$name" -c "$color" -d "$description" --repo "${ORG}/${REPO}" 2>/dev/null || \
    gh label edit "$name" -c "$color" -d "$description" --repo "${ORG}/${REPO}" 2>/dev/null || true
done

echo -e "${GREEN}✓${NC} Labels criadas"

# Configurar branch protection
echo -e "\n${YELLOW}Configurando proteção de branch...${NC}"
gh api -X PUT "repos/${ORG}/${REPO}/branches/main/protection" \
    -f required_status_checks='{"strict":false,"contexts":["Autograding","CI"]}' \
    -f enforce_admins=false \
    -f required_pull_request_reviews='null' \
    -f restrictions='null' \
    --silent 2>/dev/null || echo -e "${YELLOW}⚠️  Proteção de branch requer permissões admin${NC}"

# Criar webhook para Classroom (se tiver permissão)
echo -e "\n${YELLOW}Configurando webhook do Classroom...${NC}"
gh api -X POST "repos/${ORG}/${REPO}/hooks" \
    -f name=web \
    -f active=true \
    -f events='["push","pull_request","issues","issue_comment"]' \
    -f config='{"url":"https://classroom.github.com/webhooks","content_type":"json"}' \
    --silent 2>/dev/null || echo -e "${YELLOW}⚠️  Webhook requer permissões admin${NC}"

# Verificar arquivos necessários
echo -e "\n${YELLOW}Verificando estrutura do template...${NC}"
required_files=(
    ".github/classroom/autograding.json"
    ".github/workflows/classroom.yml"
    "README.md"
    "QUESTIONS.md"
    "data-ready/MIGRACAO.md"
)

all_present=true
for file in "${required_files[@]}"; do
    if [ -f "$file" ]; then
        echo -e "${GREEN}✓${NC} $file"
    else
        echo -e "${RED}✗${NC} $file ausente"
        all_present=false
    fi
done

if [ "$all_present" = true ]; then
    echo -e "\n${GREEN}✅ Template pronto para uso no GitHub Classroom!${NC}"
else
    echo -e "\n${YELLOW}⚠️  Alguns arquivos estão faltando${NC}"
fi

# Instruções finais
echo -e "\n${YELLOW}📋 Próximos passos:${NC}"
echo "1. Acesse https://classroom.github.com"
echo "2. Crie um novo assignment"
echo "3. Use este repositório como template: ${ORG}/${REPO}"
echo "4. Configure autograding com o arquivo .github/classroom/autograding.json"
echo "5. Compartilhe o link do assignment com os candidatos"

echo -e "\n${YELLOW}📊 Monitoramento:${NC}"
echo "- Ver submissions: gh api 'orgs/${ORG}/classroom/assignments'"
echo "- Dashboard: https://classroom.github.com/classrooms"

echo -e "\n${GREEN}✨ Setup concluído!${NC}"