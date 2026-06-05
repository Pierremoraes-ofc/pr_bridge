# Database SQL (`pr_lib.db` / `pr_lib.sql`)

Acesso Universal ao Banco de Dados (Disponível apenas no **Server**). 

Esqueça comandos como `exports.oxmysql:execute(...)` ou `MySQL.Async.fetchAll(...)`. Use `pr_lib.db` (ou o atalho `pr_lib.sql`) e a bridge vai adaptar perfeitamente aos recursos:
* `oxmysql`
* `ghmattimysql`
* `mysql-async`

Todos os comandos suportam chamadas **Síncronas** ou **Assíncronas** (via `cb`). Quando não houver função `cb` como último parâmetro, eles pausarão a execução até retornarem as *rows*.

### `.query(query, parameters, cb)` (Alias: `.read`, `.fetch`, `.fetchAll`)
Retorna uma tabela contendo as colunas selecionadas.
```lua
local rows = pr_lib.db.query("SELECT * FROM users WHERE job = ?", { "police" })

for i=1, #rows do
    print(rows[i].identifier)
end
```

### `.single(query, parameters, cb)`
Retorna o primeiro registro exato (tabela hash). Perfeito para buscas de 1 único indivíduo.
```lua
local user = pr_lib.db.single("SELECT identifier, money FROM users WHERE identifier = ?", { identifier })

if user then
    print("Grana do cara: ", user.money)
end
```

### `.scalar(query, parameters, cb)`
Retorna estritamente um valor de um campo de coluna único.
```lua
local money = pr_lib.db.scalar("SELECT money FROM users WHERE identifier = ?", { identifier })
print("Tem apenas o dinheiro: ", money)
```

### `.insert(query, parameters, cb)`
Retorna o `insertId` numérico da nova coluna gerada.
```lua
local insertId = pr_lib.db.insert("INSERT INTO items (name, count) VALUES (?, ?)", { "water", 10 })
```

### `.execute(query, parameters, cb)` (Alias: `.update`, `.write`, `.run`, `.auto`)
Perfeito para Updates e Deletions. Retorna o número de linhas afetadas.
```lua
local afetados = pr_lib.db.execute("UPDATE users SET money = ? WHERE identifier = ?", { 5000, identifier })
print(afetados .. " usuarios atualizados.")
```

### `.transaction(queries, parameters, cb)`
Executa transações massivas (onde se uma falhar, ocorre rollback de tudo).
```lua
local success = pr_lib.db.transaction({
    "UPDATE users SET money = money - 100 WHERE identifier = ?",
    "INSERT INTO logs (type) VALUES (?)"
}, { 
    { identifier },
    { "BUY_ITEM" }
})
```
