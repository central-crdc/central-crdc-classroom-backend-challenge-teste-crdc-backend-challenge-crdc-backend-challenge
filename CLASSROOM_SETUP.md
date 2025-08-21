# 🎓 Configuração do GitHub Classroom

## Para Instrutores

### 1. Criar Assignment no GitHub Classroom

1. Acesse [GitHub Classroom](https://classroom.github.com)
2. Selecione ou crie uma organização
3. Clique em "New Assignment"
4. Configure:
   - **Title**: CRDC Backend Challenge
   - **Type**: Individual
   - **Deadline**: 4 horas após início (opcional)
   - **Repository visibility**: Private
   - **Template repository**: `central-crdc/crdc-backend-challenge`

### 2. Configurações do Assignment

#### Starter Code
- ✅ Use template repository
- Repository: `central-crdc/crdc-backend-challenge`

#### Autograding
- ✅ Enable autograding
- Import from: `.github/classroom/autograding.json`

#### Feedback
- ✅ Enable feedback pull requests
- ✅ Enable automatic feedback

### 3. Critérios de Avaliação Automática

| Teste | Pontos | Descrição |
|-------|--------|-----------|
| Estrutura | 10 | Diretórios service, automation, data-ready |
| Código do Serviço | 20 | Arquivo .kt/.java/.go presente |
| Dockerfile | 15 | Container configurado |
| Automação | 15 | Script n8n/Python/Lambda |
| Data-Ready | 20 | Documentação completa |
| Build | 20 | Container builda com sucesso |

**Total**: 100 pontos  
**Aprovação**: ≥ 60 pontos

### 4. Revisão Manual Adicional

Além da avaliação automática, revise:

- **Logs ECS**: Verificar implementação correta
- **OpenTelemetry**: Métricas e tracing configurados
- **Qualidade do código**: Clean code, patterns
- **Documentação**: Clareza e completude

### 5. Configurar Proteções

```bash
# No repositório template
gh api -X PUT "repos/central-crdc/crdc-backend-challenge/branches/main/protection" \
  -f required_status_checks='{"strict":false,"contexts":["Autograding"]}' \
  -f enforce_admins=false \
  -f required_pull_request_reviews='null' \
  -f restrictions='null'
```

## Para Candidatos

### 📋 Como Submeter

1. Aceite o convite do GitHub Classroom
2. Clone seu repositório privado
3. Complete as atividades em até 4 horas
4. Faça commits frequentes mostrando progresso
5. Push final dispara avaliação automática

### ✅ Checklist de Entrega

- [ ] Microserviço com endpoints `/assinaturas`
- [ ] Logs no padrão ECS
- [ ] OpenTelemetry configurado
- [ ] Dockerfile funcional
- [ ] Automação (n8n/Python/Lambda)
- [ ] Documentação Data-Ready completa
- [ ] README com instruções de execução

### 🔍 Validação Local

```bash
# Testar estrutura
test -d service && test -d automation && test -d data-ready && echo "✅ Estrutura OK"

# Testar Docker build
docker build -t test-service .

# Verificar documentação
ls -la data-ready/*.md
```

### 📊 Avaliação

- **Automática**: 100 pontos via GitHub Actions
- **Manual**: Revisão de qualidade do código
- **Nota de corte**: 60%

## Monitoramento (Instrutor)

### Dashboard de Progresso

```bash
# Listar submissions
gh api "orgs/YOUR_ORG/classroom/assignments" | jq '.[] | select(.title=="CRDC Backend Challenge")'

# Ver progresso dos alunos
gh api "assignments/ASSIGNMENT_ID/submissions" | jq '.[].grade'
```

### Métricas de Sucesso

- Taxa de conclusão > 70%
- Tempo médio < 4 horas
- Pontuação média > 65
- Todos critérios ECS/OTel atendidos

## Troubleshooting

### Problema: Actions não roda
**Solução**: Verificar se Actions está habilitado na org

### Problema: Autograding falha
**Solução**: Revisar `.github/classroom/autograding.json`

### Problema: Docker build timeout
**Solução**: Aumentar timeout no autograding.json

## Recursos Adicionais

- [GitHub Classroom Docs](https://docs.github.com/en/education/manage-coursework-with-github-classroom)
- [Autograding Guide](https://docs.github.com/en/education/manage-coursework-with-github-classroom/teach-with-github-classroom/use-autograding)
- [Template Repository Best Practices](https://docs.github.com/en/repositories/creating-and-managing-repositories/creating-a-template-repository)