# Interações Visuais (FiveM)

O módulo `pr_lib.fivem` entrega utilitários focados diretamente na experiência do usuário dentro da tela do FiveM (lado Client), dispensando que você crie threads de rendering repetitivas.

Tudo aqui foi otimizado para não impactar o Resmon, ativando Threads em `Wait(0)` apenas durante o período de exibição dos elementos.
