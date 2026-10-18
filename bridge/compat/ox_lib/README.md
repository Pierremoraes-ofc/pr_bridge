# Compatibilidade ox_lib

Esta pasta concentra o host, bootstrap, catálogo, adapters de assinatura,
protocolos, exports legados e traduções do ox_lib incorporado ao PR Bridge.
Os módulos nativos continuam em suas pastas canônicas; não foram duplicados.

Em `bridge/config.lua`:

```lua
compatOx_lib = true,
```

- `true` (padrão desta base): instala a compatibilidade no host e nos consumidores.
- `false`: o dispatcher retorna sem carregar o host. Consumidores de
  `@pr_bridge/init.lua` não carregam nenhum módulo desta pasta nem instalam
  `lib`, `pr_lib.ox_lib`, `pr_lib.ox` ou `pr_lib.ox_target`. Um `lib` original
  existente é preservado. Não há eventos, comandos, exports ou listeners do
  adaptador registrados. APIs nativas do PR Bridge continuam disponíveis.

O dispatcher único está em `bridge/compat/loader.lua`. `compatFramework` é
independente: controla a fachada ESX em `compat/esx`, sem instalar outro core.
Desligar `compatOx_lib` não desliga a compatibilidade de frameworks.

## Caminhos públicos preservados

A pasta raiz `imports/` mantém os entrypoints públicos e seus caminhos. Eles
são carregados de forma preguiçosa somente pelo runtime de compatibilidade
habilitado; não são scripts de inicialização do manifest. Nenhum import foi
duplicado ou movido nesta etapa. `entities_client.lua` e `police.lua` são
adapters separados, não parte do host ox_lib, e permanecem em `compat/`.

## Importante: substituição de recurso no FiveM

`provide('ox_lib')` e `provide('ox_target')` são metadados estáticos no
`fxmanifest.lua`, lido em um ambiente separado, sem acesso ao `Config` dos
scripts. A opção acima desliga o código do adaptador, mas não remove esses
metadados do manifest. Eles continuam ativos nesta base para preservar as
dependências e os imports `@ox_lib/init.lua` já existentes.

Para usar bibliotecas originais em vez da substituição:

1. Defina `compatOx_lib = false`.
2. Comente os `provide` correspondentes em `fxmanifest.lua`.
3. Inicie as bibliotecas originais antes dos consumidores que dependem delas.
4. Reinicie a cidade (recomendado); se mudou o manifest com o servidor ligado,
   atualize a lista de recursos com `refresh` antes de reiniciar os recursos.

Não altere `compatOx_lib` durante uma sessão esperando remover handlers já
registrados: a configuração é de inicialização, não uma alternância ao vivo.
Uma importação pelo alias antigo sem biblioteca original falha com mensagem
explícita quando a compatibilidade está desligada, sem instalar o adaptador.

Referências oficiais:
[manifest e provide](https://docs.fivem.net/docs/scripting-reference/resource-manifest/#provide),
[ambiente de leitura do manifest](https://github.com/citizenfx/fivem/blob/master/code/components/citizen-resources-metadata-lua/src/LuaMetaDataLoader.cpp).

## Verificação offline

Na raiz do PR Bridge, com Lua instalado:

```text
lua tests/compat_toggle_test.lua .
lua tests/ox_compat_test.lua .
lua tests/provider_client_boot_test.lua .
lua tests/provider_client_boot_test.lua . "" started disabled
lua tests/native_library_test.lua .
node scripts/audit_ox_compat.mjs
```

Os testes simulam o ambiente do FiveM; não reiniciam recursos nem substituem
o teste da cidade. O modo desligado verifica host/consumidor, ausência de
carregamento de módulos legados e preservação de `lib`/`cache` originais.
