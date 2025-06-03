
{{ 
    config(
        materialized='table',
        pre_hook="{{ call_incremental_procedure( this ) }}"
    )
}}

SELECT 
    CAST(UUID_STRING() AS STRING) AS ID,
    SRC['content']::STRING AS CONTEUDO,
    SRC['title']::STRING AS TITULO,
    CONCAT_WS(', ', SRC['title']::STRING, SRC['content']::STRING) AS CONTEUDO_COMPLETO,
    SRC['link']::STRING AS LINK,
    SRC['posted_on']::STRING AS DATA_POSTAGEM,
    SRC['scrap_date']::STRING AS DATA_RASPAGEM
FROM NEWS_DB.BRONZE.NOTICIAS
WHERE _mt_america_sao_paulo_scan_time = (
    SELECT MAX(_mt_america_sao_paulo_scan_time)
    FROM NEWS_DB.BRONZE.NOTICIAS
)