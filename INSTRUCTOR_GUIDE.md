# 👨‍🏫 Guia do Instrutor - CRDC Backend Challenge

## Visão Geral

Este desafio avalia competências em:
- Migração de monólito para microserviços
- Observabilidade (ECS + OpenTelemetry)
- Automação e integração
- Arquitetura Data-Ready

## Timeline de Avaliação

### Durante o Desafio (4 horas)
- ⏱️ Monitorar commits via GitHub Classroom
- 📊 Dashboard mostra progresso em tempo real
- 💬 Responder dúvidas via Issues (se permitido)

### Pós-Submissão
1. **Avaliação Automática** (imediata)
   - Autograding roda via GitHub Actions
   - Pontuação base: 100 pontos

2. **Revisão Manual** (até 24h)
   - Qualidade do código
   - Implementação ECS/OTel
   - Decisões arquiteturais

## Critérios de Avaliação Detalhados

### 1. Microserviço (40 pontos)

#### Endpoints (10 pts)
- ✅ POST /assinaturas funcional
- ✅ GET /assinaturas/{id} retorna status correto
- ✅ Tratamento de erros adequado

#### Logs ECS (15 pts)
```json
{
  "@timestamp": "2025-08-21T10:00:00Z",
  "log.level": "info",
  "message": "Assinatura recebida",
  "service.name": "service-assinaturas",
  "trace.id": "abc123",
  "http.request.method": "POST",
  "http.response.status_code": 200
}
```

#### OpenTelemetry (15 pts)
- Métricas: latência, throughput, erros
- Tracing: spans corretos, propagação de contexto
- Configuração: OTLP exporter configurado

### 2. Automação (20 pontos)

#### n8n (se escolhido)
- Workflow exportado como JSON
- Polling ou webhook configurado
- Persistência em DB

#### Python/Lambda (se escolhido)
- Script funcional
- Tratamento de erros
- Configuração de schedule/trigger

### 3. Data-Ready (20 pontos)

#### MIGRACAO.md (5 pts)
- Estratégia clara (Strangler/CDC)
- Plano de rollback
- Métricas de sucesso

#### EVENTO_DOMINIO.json (5 pts)
- Schema válido
- Campos necessários
- Versionamento

#### INVARIANTES.md (5 pts)
- Regras de negócio claras
- Validações documentadas

#### CDC_VIEWS.md (5 pts)
- Views SQL corretas
- Ordenação temporal
- Idempotência

### 4. Qualidade Geral (20 pontos)

#### Docker (5 pts)
- Build sem erros
- Multi-stage se aplicável
- Boas práticas

#### Código (10 pts)
- Clean Code
- SOLID principles
- Testes (bonus)

#### Documentação (5 pts)
- README claro
- Instruções de execução
- Trade-offs explicados

## Rubrica de Notas

| Pontuação | Classificação | Ação |
|-----------|--------------|------|
| 90-100 | Excepcional | Aprovado + Fast track |
| 75-89 | Muito Bom | Aprovado |
| 60-74 | Satisfatório | Aprovado com ressalvas |
| 45-59 | Abaixo | Revisão + Entrevista |
| 0-44 | Insuficiente | Reprovado |

## Feedback Templates

### Aprovado (≥75 pontos)
```markdown
## 🎉 Parabéns!

Você demonstrou excelente domínio em:
- ✅ [Pontos fortes específicos]

### Destaques:
- [Implementação específica que impressionou]

### Sugestões de melhoria:
- [Áreas para desenvolvimento contínuo]

Próximos passos: [Entrevista técnica/cultural]
```

### Aprovado com Ressalvas (60-74 pontos)
```markdown
## ✅ Aprovado

### Pontos positivos:
- [Listar conquistas]

### Áreas de atenção:
- ⚠️ [Gaps identificados]
- 💡 Sugestão: [Melhorias específicas]

Próximos passos: [Discussão na entrevista]
```

### Necessita Revisão (<60 pontos)
```markdown
## 📝 Feedback

Identificamos oportunidades de melhoria em:
- [Áreas específicas]

### Recomendações:
- [Recursos de estudo]
- [Práticas sugeridas]

Encorajamos você a [próximas ações].
```

## Red Flags

⚠️ **Atenção para:**
- Código copiado (verificar similaridade)
- Overengineering extremo
- Ausência de logs/métricas
- Ignorar requisitos core
- Commits únicos (sem progresso)

## Perguntas de Follow-up (Entrevista)

### Técnicas
1. "Explique sua decisão de usar [tecnologia X]"
2. "Como você garantiria zero downtime na migração?"
3. "Qual métrica você priorizaria monitorar?"
4. "Como escalaria este serviço para 10x o volume?"

### Comportamentais
1. "Qual parte foi mais desafiadora?"
2. "O que você faria diferente com mais tempo?"
3. "Como você priorizou as tarefas?"

## Scripts Úteis

### Verificar todas submissions
```bash
gh api graphql -f query='
{
  organization(login: "central-crdc") {
    classroom {
      assignments(first: 10) {
        nodes {
          title
          submissions {
            totalCount
            nodes {
              student { login }
              grade
              submittedAt
            }
          }
        }
      }
    }
  }
}'
```

### Exportar resultados
```bash
# Gerar CSV com resultados
echo "Student,Grade,Time,Status" > results.csv
gh api "assignments/ASSIGNMENT_ID/submissions" | \
  jq -r '.[] | [.student.login, .grade, .submitted_at, .status] | @csv' >> results.csv
```

### Análise em batch
```bash
# Clonar todos os repos para análise local
for repo in $(gh api "assignments/ASSIGNMENT_ID/submissions" | jq -r '.[].repository.full_name'); do
  git clone "https://github.com/$repo" "submissions/$(basename $repo)"
done
```

## Troubleshooting Comum

### "Autograding não rodou"
- Verificar se Actions está habilitado
- Confirmar arquivo `.github/classroom/autograding.json`
- Check workflow permissions

### "Docker build falha"
- Timeout muito baixo no autograding
- Falta de recursos no runner
- Dockerfile com erros de sintaxe

### "Pontuação não aparece"
- Verificar webhook configuration
- API rate limits
- Sync delay (aguardar 5 min)

## Métricas de Sucesso do Programa

📊 **KPIs para tracking:**
- Taxa de conclusão: >70%
- Tempo médio: <4h
- Satisfação (NPS): >8
- Taxa de aprovação: 40-60%
- Correlação nota vs performance futura

## Recursos Adicionais

- [GitHub Classroom Dashboard](https://classroom.github.com)
- [Documentação Autograding](https://docs.github.com/en/education/manage-coursework-with-github-classroom)
- [ECS Fields Reference](https://www.elastic.co/guide/en/ecs/current/ecs-field-reference.html)
- [OpenTelemetry Docs](https://opentelemetry.io/docs/)