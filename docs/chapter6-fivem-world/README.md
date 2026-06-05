# Mundo e Objetos (FiveM)

Manipular entidades e objetos 3D no GTA V requer cuidado com a engine do jogo, como carregar modelos na memória (`RequestModel`) antes de criar o objeto, achar a altura correta do chão (`Z`) e gerenciar pools de entidades próximas.

O `pr_bridge` agrupa o essencial dessas tarefas nos módulos de `objects` (coleta de entidades) e `streaming` (carregamento e spawn).
