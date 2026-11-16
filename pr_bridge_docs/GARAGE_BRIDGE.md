# Garagens residenciais — pr_lib.garage

Seleção dinâmica por `setr pr_bridge:garage "auto"`: Forge Garage → JG Advanced Garages → QBX Garages → QB Garages. Pode informar o nome exato de um desses recursos para seleção explícita. Se o recurso forçado não estiver iniciado, não troca silenciosamente de fornecedor.

Cliente:
- `getProvider()` → recurso selecionado ou nil.
- `createPropertyGarage(options, callback)` → inicia edição; Forge recebe seu editor nativo. Demais sistemas chamam `options.placeCoords()` para obter x/y/z/h. Callback devolve `success`, `draft` ou `cancelled`.
- `commitPropertyGarageDraft({propertyId, draft})` → `{success, data, message?}`. `data` é o vínculo a persistir no Housing; validação e autorização permanecem no servidor consumidor.
- `registerProperty({propertyId, label, data, canAccess, registerServer?})` → handle para targets/zona. Forge mantém suas próprias zonas salvas.
- `unregisterProperty(handle)` → remove as interações criadas pelo adaptador.

Servidor:
- `getProvider()`.
- `validateLink(propertyId, data)` → valida fornecedor e vínculo; Forge exige o mesmo `propertyGarage.id`. O consumidor deve validar o corretor antes.
- `registerProperty({propertyId, label, data, canAccess})` → registro dinâmico QBX, com autorização no servidor.

O adaptador não migra o banco de veículos entre sistemas. O consumidor deve reconstruir suas zonas quando carregar propriedades ou mudar os acessos. A seleção deve ser definida antes de iniciar os consumidores.

JG: [integração PS Housing](https://docs.jgscripts.com/advanced-garages/integrations/ps-housing), [eventos](https://docs.jgscripts.com/advanced-garages/commands-events-and-exports/events). QBX: [RegisterGarage e canAccess](https://github.com/Qbox-project/qbx_garages/blob/main/server/main.lua).
