# Network API (`pr_lib.fivem.net`)

Utilitário essencial para garantir que os pacotes trocados entre *Client* e *Server* apontem para entidades válidas e instanciadas.

### `.isValidNetId(netId)`
Verifica com segurança se o `netId` existe na memória atual do cliente.

### `.getNetId(entity)`
Pega o `netId` de uma entidade, validando se ela está realmente conectada na malha de rede (`NetworkGetEntityIsNetworked`).

### `.getEntity(netId, timeout)` e `.getVehicle(netId, timeout)`
Em vez de simplesmente usar a nativa `NetworkGetEntityFromNetworkId` (que frequentemente falha caso a entidade ainda não tenha feito o *stream* pro jogador), estas funções aguardam um `timeout` em milissegundos verificando a cada *frame* se a entidade finalmente apareceu.

```lua
-- Tenta achar o veiculo por ate 2 segundos antes de desistir
local vehicle = pr_lib.fivem.net.getVehicle(netId, 2000)
if vehicle then
    print("Veículo finalmente spawnado para o cliente!")
end
```

### `.resolveVehicle(vehicleOrNetId, timeout)`
Uma função de conveniência de ponta a ponta. Você pode passar tanto o ID da entidade (Local) quanto o `netId` (Rede). A função te devolve ambos já convertidos.

```lua
local vehicle, netId = pr_lib.fivem.net.resolveVehicle(idDesconhecido, 1000)
```

### `.getOwner(entityOrNetId, timeout)`
Pega o ID da sessão (`PlayerId()`) do atual "Dono" de processamento da entidade na rede.
