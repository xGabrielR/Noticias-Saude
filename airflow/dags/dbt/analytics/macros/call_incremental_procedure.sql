{% macro call_incremental_procedure(model=none) %}
    {% if model is not none %}
        CALL NEWS_DB.STAGE.LANDING_TO_BRONZE('{{ model.identifier }}');
    {% endif %}
{% endmacro %}
