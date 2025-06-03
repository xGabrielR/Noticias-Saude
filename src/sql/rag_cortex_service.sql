SET question='Qual foi o custo em reais de materiais para a prática de artes marciais ?';

WITH tbl_search AS ( 
    SELECT PARSE_JSON(
      SNOWFLAKE.CORTEX.SEARCH_PREVIEW(
          'NEWS_DB.GOLD.SEARCH_SERVICE_NOTICIAS',
          '{
            "query": "' || $question || '",
            "columns":[
                "chunk"
            ],
            "limit":1
          }'
      )
    )['results'] AS RESULTS
),
parse_context AS (
    SELECT
        CONCAT_WS('', '"', RESULTS[0]['chunk'], '"') AS contexto
    FROM tbl_search
),
create_prompt AS (
    SELECT 
        CONCAT_WS(
            ' ',
            'Você é um agente especializado em saúde pública.',
            'Extraia a informação do CONTEXTO: ',
            contexto,
            ' Responda a seguinte pergunta:',
            $question,
            ' Seja conciso e não alucinado',
            ' Se não existir a informação, diga que você não sabe',
            ' Apenas responda se você conseguir extrair a informação do CONTEXTO.',
            ' Não mencione que você extraiu informações do CONTEXTO.'
        ) AS prompt
    FROM parse_context
)
SELECT
    prompt,
    SNOWFLAKE.CORTEX.COMPLETE('snowflake-arctic', prompt) AS gen
FROM create_prompt;