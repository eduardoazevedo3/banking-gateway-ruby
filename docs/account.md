# Modelagem de Contas

As contas neste projeto são a representação das contas dos clientes nos provedores, que são os bancos ou intermediários de pagamentos.

| coluna              | tipo     | descrição                                                    |
| ------------------- | -------- | ------------------------------------------------------------ |
| provider_account_id | string   | ID da conta no provedor (BB, Arbi, Caixa)                    |
| reference_code      | string   | Código de referência para uso do AFSYS e SACADOR             |
| description         | string   | Nome ou razão social da empresa                              |
| document_type       | string   | CPF ou CNPJ                                                  |
| document_number     | string   | Documento da pessoa ou empresa                               |
| credentials         | text     | Dados de integração com provedor (CLIENT_ID, CLIENT_SECRET)  |
| issue_data          | json     | Dados de convênio, carteira, modalidade, etc                 |
