# Modelagem de Contas

As contas neste projeto são a representação das contas dos clientes nos provedores, que são os bancos ou intermediários de pagamentos.

| coluna              | tipo     | Validação        | descrição                                                    |
| ------------------- | -------- | ---------------- | ------------------------------------------------------------ |
| provider_account_id | string   | Requerido, único | ID da conta no provedor (BB, Arbi, Caixa)                    |
| reference_code      | string   | Requerido, único | Código de referência para uso do AFSYS e SACADOR             |
| description         | string   | Requerido        | Nome ou razão social da empresa                              |
| document_type       | string   | Requerido        | CPF ou CNPJ                                                  |
| document_number     | string   | Requerido, único | Documento da pessoa ou empresa                               |
| credentials         | text     | Não              | Dados de integração com provedor (CLIENT_ID, CLIENT_SECRET)  |
| issue_data          | json     | Não              | Dados de convênio, carteira, modalidade, etc                 |
| webhook_url         | string   | Não              | URL do webhook para receber atualizações de boleto           |
| webhook_secret      | string   | Não              | Chave secreta para assinar a mensagem do webhook             |

### `provider_account_id`

O `provider_account_id` é um código único, que não pode ser alterado, para identificar a conta no provedor, que pode ser o ID da conta no BB, Arbi, Caixa, etc.

O valor desse atributo é adquirido após a criação da conta no provedor, que pode ser:
- de forma sincrona via API
- via webhook, após a criação da conta no provedor
- manualmente pelo usuário

A DEFINIR: Esse atributo ser único pode ser um problema, pois o ID 123 no banco BB pode ser o mesmo ID 123 no banco Arbi.

### `reference_code`

O `reference_code` é um código único de referência para uso de sistemas que se integram com este serviço.

Esse código serve para garantir que, durante uma integração, o mesmo `reference_code` seja usado para identificar a conta.
