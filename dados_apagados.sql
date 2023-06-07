-- Cenário:
-- Uma trigger está no estado "problem" a nível de host mas não aparece na aba "problems" do Zabbix, por que?

-- Resposta:
-- Após uma consulta SQL descobri que o "problems" busca informações da tabela "events" e essa tabela já estava limpa, por isso não constava mais.

-- Consulta utilizada

-- Consultar o lastchange, value, state e status da trigger
SELECT from_unixtime(lastchange), lastchange, value, state, status FROM triggers WHERE triggerid=<triggerid> 

-- Consultar na tabela events se existe o problem
SELECT * FROM events WHERE source = 0 and object = 0 AND objectid=<triggerid> AND clock=<valor que a query acima retornou em unix>
