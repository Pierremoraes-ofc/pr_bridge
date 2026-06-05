# Manipulação de Rede e Veículos (FiveM)

Trabalhar com veículos e rede no FiveM pode ser uma dor de cabeça devido a problemas de latência, migração de *Network Owner* e `netId` inexistentes temporariamente. 

Para resolver isso, o `pr_bridge` possui motores complexos (`pr_lib.fivem.net`, `vehicleProperties`, `tuning` e `vehicleCache`) que blindam suas funções de falharem por causa da rede. Você interage com as propriedades, e a biblioteca garante que sejam aplicadas corretamente a quem possui o controle da entidade naquele exato momento.
