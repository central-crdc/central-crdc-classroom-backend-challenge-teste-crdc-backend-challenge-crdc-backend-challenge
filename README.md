# 🏗️ CRDC – Backend Challenge

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![GitHub Classroom](https://img.shields.io/badge/GitHub-Classroom-green.svg)](https://classroom.github.com)
[![Docker](https://img.shields.io/badge/Docker-Ready-blue.svg)](https://www.docker.com/)

> **Desafio prático de migração de monólito para microserviços**  
> Tempo estimado: **4 horas** | Foco: Observabilidade + Data-Ready Architecture

## 📋 Visão Geral

Este desafio simula um cenário real de migração de um sistema de **assinaturas digitais** de monólito para microserviços, com foco em observabilidade e arquitetura orientada a dados.

### 🎯 Objetivos

| Módulo | Descrição | Tecnologias |
|--------|-----------|-------------|
| **🔧 Microserviço** | API REST para gestão de assinaturas | Kotlin/Java/Go + ECS + OpenTelemetry |
| **🤖 Automação** | Consumer que persiste dados | n8n/Python/Lambda + SQLite/Postgres |
| **📚 Data-Ready** | Documentação de migração | Strangler Pattern + CDC + Rollback |

## 🚀 Quick Start

### Pré-requisitos
- Docker & Docker Compose
- JDK 11+ (se Java/Kotlin) ou Go 1.19+ 
- Python 3.9+ (se escolher automação Python)

### Execução Rápida
```bash
# 1. Clone o repositório
git clone <seu-repo>
cd crdc-backend-challenge

# 2. Execute o setup
docker-compose up -d

# 3. Teste os endpoints
curl -X POST http://localhost:8080/assinaturas \
  -H "Content-Type: application/json" \
  -d '{"id":"123","documento":"contrato.pdf"}'

curl http://localhost:8080/assinaturas/123
```

## 📁 Estrutura do Projeto

```
crdc-backend-challenge/
├── 🔧 service/           # Microserviço principal
├── 🤖 automation/        # Scripts de automação  
├── 📚 data-ready/        # Docs de migração
├── 🐳 docker/            # Containers e compose
└── 📋 README.md          # Este arquivo
```

## 🔧 Módulo 1: Microserviço

### Endpoints Obrigatórios

#### `POST /assinaturas`
```bash
curl -X POST http://localhost:8080/assinaturas \
  -H "Content-Type: application/json" \
  -d '{
    "id": "123",
    "documento": "contrato.pdf"
  }'
```

**Resposta:**
```json
{
  "id": "123",
  "status": "RECEBIDA"
}
```

#### `GET /assinaturas/{id}`
```bash
curl http://localhost:8080/assinaturas/123
```

**Resposta:**
```json
{
  "id": "123",
  "status": "PROCESSANDO",
  "documento": "contrato.pdf",
  "created_at": "2025-08-21T10:00:00Z"
}
```

### Status Permitidos
- `RECEBIDA` - Assinatura recebida e validada
- `PROCESSANDO` - Em processo de validação  
- `CONCLUIDA` - Assinatura concluída com sucesso
- `RECUSADA` - Assinatura rejeitada

### Observabilidade Obrigatória

#### Logs em ECS (Elastic Common Schema)
```json
{
  "@timestamp": "2025-08-21T10:00:00Z",
  "log.level": "info",
  "message": "Assinatura processada com sucesso",
  "service.name": "service-assinaturas",
  "event.dataset": "assinaturas.api",
  "trace.id": "abc123def456",
  "transaction.id": "txn-789",
  "http.request.method": "POST",
  "http.response.status_code": 200,
  "url.path": "/assinaturas",
  "crdc.domain": "assinaturas",
  "crdc.event": "assinatura_processada"
}
```

#### OpenTelemetry Metrics & Tracing
- **Métricas**: latência, throughput, error rate
- **Traces**: spans por request, propagação de contexto
- **Configuração**: OTLP exporter para Jaeger/Zipkin

## 🤖 Módulo 2: Automação

Escolha **uma** das opções:

### Opção A: n8n Workflow
- Export JSON do workflow completo
- Polling periódico no endpoint `/assinaturas/{id}`
- Persistência em SQLite/Postgres

### Opção B: Python/Lambda
```python
# Exemplo de estrutura
import requests
import sqlite3
from datetime import datetime

def process_signatures():
    # 1. Consultar API
    # 2. Validar dados
    # 3. Persistir no banco
    # 4. Log da operação
    pass
```

## 📚 Módulo 3: Data-Ready

### Documentos Obrigatórios

| Arquivo | Propósito |
|---------|-----------|
| `MIGRACAO.md` | Estratégia de migração (Strangler, CDC, rollback) |
| `EVENTO_DOMINIO.json` | Schema do evento de assinatura |
| `INVARIANTES.md` | Regras de negócio e validações |
| `CDC_VIEWS.md` | Views SQL para Change Data Capture |

## 📊 Critérios de Avaliação

| Critério | Peso | Descrição |
|----------|------|-----------|
| **Microserviço** | 40% | Endpoints funcionais + ECS + OpenTelemetry |
| **Automação** | 20% | Consumer funcional com persistência |
| **Data-Ready** | 20% | Documentação de migração completa |
| **Qualidade** | 20% | Código limpo + Docker + Documentação |

### Nota de Corte: **≥ 60%**

## 🛠️ Tecnologias Recomendadas

### Backend
- **Java**: Spring Boot + Micrometer + Logback
- **Kotlin**: Ktor + OpenTelemetry + kotlinx-serialization  
- **Go**: Gin + OTEL SDK + Zap/Logrus

### Persistência
- **Desenvolvimento**: H2, SQLite
- **Produção**: PostgreSQL, MySQL

### Observabilidade
- **Logs**: ECS format via Logback/Zap
- **Métricas**: Prometheus + Grafana
- **Tracing**: Jaeger ou Zipkin

## 🔍 Troubleshooting

### Docker Issues
```bash
# Limpar containers antigos
docker-compose down -v
docker system prune -f

# Rebuild imagens
docker-compose build --no-cache
```

### Port Conflicts
```bash
# Verificar portas em uso
netstat -tulpn | grep :8080

# Alterar porta no docker-compose.yml
ports:
  - "8081:8080"  # host:container
```

### Logs ECS não aparecem
```bash
# Verificar configuração do logger
docker-compose logs service

# Validar formato JSON
echo '{"@timestamp":"..."}' | jq .
```

## 📖 Recursos Úteis

- [Elastic Common Schema](https://www.elastic.co/guide/en/ecs/current/ecs-field-reference.html)
- [OpenTelemetry Docs](https://opentelemetry.io/docs/)
- [Strangler Fig Pattern](https://martinfowler.com/bliki/StranglerFigApplication.html)
- [n8n Documentation](https://docs.n8n.io/)

## 💡 Dicas de Implementação

### ⚡ Para economizar tempo:
1. **Use templates**: Spring Initializr, create-go-app
2. **Implemente incrementalmente**: Endpoints → Logs → Métricas → Automação
3. **Dockerize early**: Configure containers desde o início
4. **Documente trade-offs**: Explique decisões no README

### 🎯 Foque no essencial:
- ✅ Endpoints funcionais
- ✅ Logs em formato ECS 
- ✅ Métricas básicas (latência, throughput)
- ✅ Automação simples mas funcional
- ✅ Docs conceituais claros

**Pragmatismo > Overengineering**

## 📝 Entrega

1. **Commit frequente**: Mostre evolução do código
2. **README atualizado**: Instruções de execução
3. **Docker funcionando**: `docker-compose up` deve funcionar
4. **Testes básicos**: Pelo menos smoke tests
5. **Documentação**: Explique decisões arquiteturais

---

**Boa sorte! 🚀**

> Em caso de dúvidas, abra uma [Issue](../../issues) ou consulte o [Guia do Instrutor](INSTRUCTOR_GUIDE.md)