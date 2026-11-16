# Forge Housing e Forge Realtor no PR Bridge

Carregue `@pr_bridge/init.lua` antes do código do consumidor. Use `pr_lib.housing` para os exports de imóveis e `pr_lib.housing.realtor` para os exports da imobiliária. Os métodos usam ponto e recebem os mesmos argumentos dos exports originais.

```lua
-- Servidor
local authorized = pr_lib.housing.IsOwner(source, propertyId)
local reported = pr_lib.housing.ReportSecurityDoorBreach(propertyId, source)

-- Cliente
local property = pr_lib.housing.GetProperty(propertyId)
local opened = pr_lib.housing.realtor.OpenPropertyDetails(propertyId)
```

O Forge Housing valida o jogador, a propriedade e a distância ao registrar um arrombamento. O alarme registra o incidente. As operações administrativas mantêm as verificações originais do provedor.

`IsOwner` mantém o significado do export original e aceita quem tem acesso ao imóvel, inclusive quem tem chave.

O catálogo em `contracts.lua` lista os 69 contratos de export por recurso e por lado. `getProvider()` informa se cada recurso está iniciado. Quando o provedor está indisponível, os exports retornam `nil, 'housing_provider_unavailable'`. A descoberta começa na primeira chamada e acompanha os eventos de início e parada.

No servidor, inicie `pr_bridge` antes de `forge-housing` e `forge-realtor`. As entradas `ps-housing` e `ps-realtor` mantêm os exports e as dependências antigas. O compat registra os eventos de entrada e callbacks com o mesmo handler do Forge. Notificações de alteração de imóveis, higiene e segurança também são entregues no nome legado.

A pasta `gallery` viaja com o Forge Realtor. A entrada `ps-realtor` disponibiliza ao Forge Realtor os metadados das fotos antigas quando ele precisa consultá-los. Os identificadores das fotos, tabelas e fechaduras existentes continuam válidos.
