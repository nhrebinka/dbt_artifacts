{% macro create_model_executions_table_if_not_exists(database_name, schema_name, table_name) -%}

    {%- if adapter.get_relation(database=database_name, schema=schema_name, identifier=table_name) is none -%}
        {% if database_name %}
        {{ log("Creating table " ~ adapter.quote(database_name ~ "." ~ schema_name ~ "." ~ table_name), info=true) }}
        {% else %}
        {{ log("Creating table " ~ adapter.quote(schema_name ~ "." ~ table_name), info=true) }}
        {% endif %}
        {%- set query -%}
            {{ adapter.dispatch('get_create_model_executions_table_if_not_exists_statement', 'dbt_artifacts')(database_name, schema_name, table_name) }}
        {% endset %}
        {%- call statement(auto_begin=True) -%}
            {{ query }}
        {%- endcall -%}
    {%- endif -%}

{%- endmacro %}

{% macro databricks__get_create_model_executions_table_if_not_exists_statement(database_name, schema_name, table_name) -%}
    create table {% if database_name %}{{ database_name }}.{% endif %}{{schema_name}}.{{table_name}} (
        command_invocation_id STRING,
        node_id STRING,
        was_full_refresh BOOLEAN,
        thread_id STRING,
        status STRING,
        compile_started_at TIMESTAMP,
        query_completed_at TIMESTAMP,
        total_node_runtime DOUBLE,
        rows_affected INTEGER,
        materialization STRING,
        schema STRING,
        name STRING
    )
    using delta
{%- endmacro %}

{% macro default__get_create_model_executions_table_if_not_exists_statement(database_name, schema_name, table_name) -%}
    create table {{database_name}}.{{schema_name}}.{{table_name}} (
        command_invocation_id STRING,
        node_id STRING,
        was_full_refresh BOOLEAN,
        thread_id STRING,
        status STRING,
        compile_started_at TIMESTAMP,
        query_completed_at TIMESTAMP,
        total_node_runtime INTEGER,
        rows_affected INTEGER,
        materialization STRING,
        schema STRING,
        name STRING
    )
{%- endmacro %}
