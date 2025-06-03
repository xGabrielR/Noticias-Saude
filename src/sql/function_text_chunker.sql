CREATE OR REPLACE FUNCTION NEWS_DB.GOLD.NOTICIAS_CHUNK (
    ID string,
    CONTEUDO string
)
RETURNS TABLE (
    id string,
    chunk string
)
LANGUAGE python
RUNTIME_VERSION = '3.9'
HANDLER = 'text_chunker'
PACKAGES = ('snowflake-snowpark-python','langchain')
AS
$$
from langchain.text_splitter import RecursiveCharacterTextSplitter
import copy

class text_chunker():

    def process(
        self,
        id: str,
        conteudo: str
    ):
        text_splitter = RecursiveCharacterTextSplitter(
            chunk_size = 100,
            chunk_overlap = 20,
            length_function = len
        )
        
        chunks = text_splitter.split_text(conteudo)
        
        for chunk in chunks:
            yield (id, chunk)
$$;