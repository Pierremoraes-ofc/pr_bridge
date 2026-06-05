# Core e Ferramentas Globais

Além das adaptações a frameworks de mercado, o `pr_bridge` possui motores próprios injetados na global `pr_lib` para lidar com a base de qualquer resource complexo de FiveM.

Esta seção cobre as ferramentas agnósticas que funcionam de forma idêntica independente do ambiente instalado. Você aprenderá a utilizar:

* **Utils (`pr_lib.utils`)**: Funções clássicas de formatação de string, arredondamentos e manipulações profundas de tabela.
* **Callbacks (`pr_lib.callback`)**: Chamadas assíncronas Cliente -> Servidor e Servidor -> Cliente com tratamentos de timeout automáticos.
* **Database (`pr_lib.db` / `pr_lib.sql`)**: Conexão universal com o banco de dados que abstrai qual script MySQL está rodando no servidor.
* **Cache API (`pr_lib.cache`)**: Uma API monstruosa de otimização em memória para não precisar ir ao banco de dados ou às exports do framework o tempo todo, ganhando de 0.05ms a 0.20ms em *tick* dependendo do script.
