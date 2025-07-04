# 📰 | Plataforma de Notícias de Saúde

---

<img src="assets/header.png">


*"Solução Event Driven com Airflow e aplicação de Rag com Snowflake"*.


<h2>Sumário</h2>
<hr>

- [0. Problema de Negócio](#0-problema-de-negócio)
- [1. Estratégia de Solução](#1-estratégia-de-solução)

<hr>

<h2>0. Problema de Negócio</h2>
<hr>

O principal problema enfrentado atualmente é a falta de acesso confiável a eventos realizados em relação a saúde pública no Brasil, muitas famílias se é que sabem que esta tendo algum evento de conscientização, vacinação ou qualquer outro meio ou solução proposta pelo sistema de saúde da cidade em sua vizinhança devido a falta de tempo ou demais características que impedem essas famílias de obter essas informações de maneira fácil e simples.   

O geógrafo brasileiro Milton Santos, descreve em seu célebre texto "As Cidadanias Mutiladas" que a democracia somente é efetiva quando atinge todo o corpo social, isto é, quando os direitos são desfrutados por todos os cidadãos. Todavia, no contexto atual brasileiro, diante dos desafios ao acesso a uma plataforma de noticias de saúde pública, distanciam a população de direitos a notícias que todos deveriam ter acesso de uma forma simples e eficiente. Neste contexto, faz-se necessário a solução dos desafios para implementar uma plataforma de notícias de saúde pública que seja acessível a todos os brasileiros.

<h2>1. Estratégia de Solução</h2>
<hr>

O projeto teve início com uma etapa de imersão no problema de negócios, buscando compreender os desafios e as necessidades dos usuários finais. A partir desse entendimento, foi realizado um planejamento detalhado das atividades que orientariam o desenvolvimento da solução. A solução proposta é baseada em uma arquitetura orientada a eventos (Event-Driven Architecture) e com essa arquitetura seu principal objetivo é facilitar o acesso a informações críticas na área de Saúde das cidades de santa catarina, inicialmente com amostras dacidade de Caçador.
Como as novas publicações de notícias de saúde em fontes oficiais de dados (por exemplo, SUS, portais do governo, entre outros) são gerados em tempos intermitentes é necessário metodologias por meio de um fluxo moderno e eficiente de ingestão e processamento de dados. Além disso a disponibilização desses dados a os usuários finais deve ser por meio de linguagem natural.

- Geração de eventos: Notícias e atualizações são publicadas periodicamente por fontes oficiais.
- Ingestão de dados: Esses eventos são capturados de forma assíncrona por mecanismos Event-Driven.
- Processamento: Os dados são tratados dentro de uma arquitetura moderna de Engenharia de Dados em camadas de consumo (Lakehouse), que combina as vantagens dos data warehouses com a flexibilidade dos data lakes.
- Utilização de técnicas de RAG (Retrieval-Augmented Generation): Interface em linguagem natural, que permite a usuários com pouco ou nenhum conhecimento técnico acessar e interpretar os dados com facilidade.
- Workflow: Automação e escalabilidade no fluxo de dados.
- Inclusão Digital: Acessibilidade da informação para públicos diversos.
- Confiabilidade: Velocidade na tomada de decisão, com dados sempre atualizados.

<img src="assets/workflow.png">

Toda a solução de infraestrutura foi desenvolvida com Terraform integrado a AWS + Snowflake, além disso com a utilização do Python, Airflow, DBT e Snowflake Warehouse para as ferramentas de processamento, orquestração e documentação, por fim o Snowflake Cortex Service para a camada de PLN, VectorDB e RAG com Langchain e SQL. 

