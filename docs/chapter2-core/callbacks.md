# Callbacks (`pr_lib.callback`)

O `pr_bridge` possui seu próprio despachante de Callbacks, com manipulação de `Promises` na nuvem e destruição segura para não prender threads.

## No Client (Chamando o Server)

### `.await(name, timeout, ...args)`
Maneira síncrona e fácil de puxar uma resposta do servidor. 
**Atenção:** Pausa o fluxo da thread no client até responder ou o timeout expirar.

```lua
Citizen.CreateThread(function()
    -- timeout de 5000ms
    local resultado, errorMensagem = pr_lib.callback.await("meu_script:verificarCarro", 5000, "adder")
    
    if resultado then
        print("Pode spawnar!")
    else
        print("Erro: " .. tostring(errorMensagem))
    end
end)
```

### `.trigger(name, cb, ...args)`
Maneira assíncrona, não congela a thread e aciona a callback (`cb`) quando finalizar.

```lua
pr_lib.callback.trigger("meu_script:verificarCarro", function(resultado, erro)
    print("Respondeu:", resultado)
end, "adder")
```

---

## No Server (Chamando o Client)

A lógica é exatamente idêntica, mas as funções possuem o sufixo `Client` ou podem receber o `target` via `triggerClient`.

### `.awaitClient(target, name, timeout, ...args)`
Aguarda de forma síncrona uma informação vinda de um jogador específico.

```lua
local plateInfo = pr_lib.callback.awaitClient(source, "meu_script:getPlate", 5000)
print("Placa do veiculo do jogador: " .. plateInfo)
```

*(O alias `.await` também está presente no lado server e direciona para a mesma função)*

### `.triggerClient(target, name, cb, ...args)`
Versão assíncrona para o lado server.

```lua
pr_lib.callback.triggerClient(source, "meu_script:getPlate", function(plateInfo)
    print("Placa retornou: " .. plateInfo)
end)
```

*(O alias `.trigger` também está presente no lado server e direciona para a mesma função)*
