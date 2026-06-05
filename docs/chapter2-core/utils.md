# Utilitários Globais (`pr_lib.utils`)

O `pr_lib.utils` carrega pequenos ajudantes que simplificam o código local.

### `.trim(value)`
Remove os espaços em branco do início e do final de uma string.
```lua
local str = pr_lib.utils.trim("   FiveM Script   ")
-- Result: "FiveM Script"
```

### `.firstToUpper(value)`
Transforma a primeira letra da string em Maiúscula (também dá trim).
```lua
local str = pr_lib.utils.firstToUpper("pierre")
-- Result: "Pierre"
```

### `.round(value, decimals)`
Arredonda um número para as casas decimais fornecidas.
```lua
local price = pr_lib.utils.round(10.5678, 2)
-- Result: 10.57

local integer = pr_lib.utils.round(10.5678)
-- Result: 11
```

### `.deepCopy(value)`
Clona completamente uma tabela de Lua (evitando passagem por referência acidental).
```lua
local obj1 = { name = "Car", mods = { turbo = true } }
local obj2 = pr_lib.utils.deepCopy(obj1)
obj2.mods.turbo = false
print(obj1.mods.turbo) -- true (a tabela original nao foi afetada)
```

### `.dumpTable(value)`
Converte uma tabela em uma String lindamente indentada para prints e logs de depuração. Ele suporta tabelas recursivas.
```lua
print(pr_lib.utils.dumpTable({ status = 200, items = { "water", "bread" } }))
```

### `.ensureTable(value)`
Assegura que a variável recebida é uma tabela. Se for `nil`, retorna `{}` vazio, evitando crashes por indexar `nil`.
```lua
local items = pr_lib.utils.ensureTable(player.items)
```

### `.hash(value)`
Transforma strings em hash, mas se receber um `number`, o retorna intacto.
```lua
local modelHash = pr_lib.utils.hash("adder")
-- Result: <Hash Number>
```
