# Migração do Monólito → Microserviço (Guia conceitual esperado)
Explique sucintamente:
- Strangler Pattern (fachada/ACL), fronteira de domínio e contratos OpenAPI/AsyncAPI
- CDC (Debezium/Kafka): tabelas, ordenação temporal, idempotência
- Dual-write canarizado + comparadores + alarme de divergência
- Cutover: critérios objetivos (SLO, mismatch ≤ 0,1% por X dias)
- Rollback: feature-flag/kill-switch, replay/compensação