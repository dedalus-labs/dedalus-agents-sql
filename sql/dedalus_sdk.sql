ALTER TYPE dedalus_sdk.credential
  ADD ATTRIBUTE connection_name TEXT, ADD ATTRIBUTE "values" JSONB;

CREATE OR REPLACE FUNCTION dedalus_sdk.make_credential(
  connection_name TEXT, "values" JSONB
)
RETURNS dedalus_sdk.credential
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(connection_name, "values")::dedalus_sdk.credential;
$$;

ALTER TYPE dedalus_sdk.dedalus_model
  ADD ATTRIBUTE model TEXT, ADD ATTRIBUTE settings dedalus_sdk.model_settings;

CREATE OR REPLACE FUNCTION dedalus_sdk.make_dedalus_model(
  model TEXT, settings dedalus_sdk.model_settings DEFAULT NULL
)
RETURNS dedalus_sdk.dedalus_model
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(model, settings)::dedalus_sdk.dedalus_model;
$$;

ALTER TYPE dedalus_sdk.function_definition
  ADD ATTRIBUTE name TEXT;

CREATE OR REPLACE FUNCTION dedalus_sdk.make_function_definition(name TEXT)
RETURNS dedalus_sdk.function_definition
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(name)::dedalus_sdk.function_definition;
$$;

ALTER TYPE dedalus_sdk.mcp_server_spec
  ADD ATTRIBUTE name TEXT,
  ADD ATTRIBUTE credentials JSONB,
  ADD ATTRIBUTE slug TEXT,
  ADD ATTRIBUTE url TEXT,
  ADD ATTRIBUTE version TEXT;

CREATE OR REPLACE FUNCTION dedalus_sdk.make_mcp_server_spec(
  name TEXT,
  credentials JSONB DEFAULT NULL,
  slug TEXT DEFAULT NULL,
  url TEXT DEFAULT NULL,
  version TEXT DEFAULT NULL
)
RETURNS dedalus_sdk.mcp_server_spec
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    name, credentials, slug, url, version
  )::dedalus_sdk.mcp_server_spec;
$$;

ALTER TYPE dedalus_sdk.mcp_tool_result
  ADD ATTRIBUTE arguments JSONB,
  ADD ATTRIBUTE is_error BOOLEAN,
  ADD ATTRIBUTE server_name TEXT,
  ADD ATTRIBUTE tool_name TEXT,
  ADD ATTRIBUTE duration_ms BIGINT,
  ADD ATTRIBUTE result JSONB;

CREATE OR REPLACE FUNCTION dedalus_sdk.make_mcp_tool_result(
  arguments JSONB,
  is_error BOOLEAN,
  server_name TEXT,
  tool_name TEXT,
  duration_ms BIGINT DEFAULT NULL,
  result JSONB DEFAULT NULL
)
RETURNS dedalus_sdk.mcp_tool_result
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    arguments, is_error, server_name, tool_name, duration_ms, result
  )::dedalus_sdk.mcp_tool_result;
$$;

ALTER TYPE dedalus_sdk.model_settings
  ADD ATTRIBUTE attributes JSONB,
  ADD ATTRIBUTE audio JSONB,
  ADD ATTRIBUTE deferred BOOLEAN,
  ADD ATTRIBUTE extra_args JSONB,
  ADD ATTRIBUTE extra_headers JSONB,
  ADD ATTRIBUTE extra_query JSONB,
  ADD ATTRIBUTE frequency_penalty DOUBLE PRECISION,
  ADD ATTRIBUTE generation_config JSONB,
  ADD ATTRIBUTE include_usage BOOLEAN,
  ADD ATTRIBUTE input_audio_format TEXT,
  ADD ATTRIBUTE input_audio_transcription JSONB,
  ADD ATTRIBUTE logit_bias JSONB,
  ADD ATTRIBUTE logprobs BOOLEAN,
  ADD ATTRIBUTE max_completion_tokens BIGINT,
  ADD ATTRIBUTE max_tokens BIGINT,
  ADD ATTRIBUTE metadata JSONB,
  ADD ATTRIBUTE modalities TEXT[],
  ADD ATTRIBUTE n BIGINT,
  ADD ATTRIBUTE output_audio_format TEXT,
  ADD ATTRIBUTE parallel_tool_calls BOOLEAN,
  ADD ATTRIBUTE prediction JSONB,
  ADD ATTRIBUTE presence_penalty DOUBLE PRECISION,
  ADD ATTRIBUTE prompt_cache_key TEXT,
  ADD ATTRIBUTE reasoning JSONB,
  ADD ATTRIBUTE reasoning_effort TEXT,
  ADD ATTRIBUTE response_format JSONB,
  ADD ATTRIBUTE safety_identifier TEXT,
  ADD ATTRIBUTE safety_settings JSONB[],
  ADD ATTRIBUTE search_parameters JSONB,
  ADD ATTRIBUTE seed BIGINT,
  ADD ATTRIBUTE service_tier TEXT,
  ADD ATTRIBUTE stop JSONB,
  ADD ATTRIBUTE store BOOLEAN,
  ADD ATTRIBUTE stream BOOLEAN,
  ADD ATTRIBUTE stream_options JSONB,
  ADD ATTRIBUTE structured_output JSONB,
  ADD ATTRIBUTE system_instruction JSONB,
  ADD ATTRIBUTE temperature DOUBLE PRECISION,
  ADD ATTRIBUTE thinking JSONB,
  ADD ATTRIBUTE timeout DOUBLE PRECISION,
  ADD ATTRIBUTE tool_choice JSONB,
  ADD ATTRIBUTE tool_config JSONB,
  ADD ATTRIBUTE top_k BIGINT,
  ADD ATTRIBUTE top_logprobs BIGINT,
  ADD ATTRIBUTE top_p DOUBLE PRECISION,
  ADD ATTRIBUTE truncation TEXT,
  ADD ATTRIBUTE turn_detection JSONB,
  ADD ATTRIBUTE "user" TEXT,
  ADD ATTRIBUTE verbosity TEXT,
  ADD ATTRIBUTE voice TEXT,
  ADD ATTRIBUTE web_search_options JSONB;

CREATE OR REPLACE FUNCTION dedalus_sdk.make_model_settings(
  attributes JSONB DEFAULT NULL,
  audio JSONB DEFAULT NULL,
  deferred BOOLEAN DEFAULT NULL,
  extra_args JSONB DEFAULT NULL,
  extra_headers JSONB DEFAULT NULL,
  extra_query JSONB DEFAULT NULL,
  frequency_penalty DOUBLE PRECISION DEFAULT NULL,
  generation_config JSONB DEFAULT NULL,
  include_usage BOOLEAN DEFAULT NULL,
  input_audio_format TEXT DEFAULT NULL,
  input_audio_transcription JSONB DEFAULT NULL,
  logit_bias JSONB DEFAULT NULL,
  logprobs BOOLEAN DEFAULT NULL,
  max_completion_tokens BIGINT DEFAULT NULL,
  max_tokens BIGINT DEFAULT NULL,
  metadata JSONB DEFAULT NULL,
  modalities TEXT[] DEFAULT NULL,
  n BIGINT DEFAULT NULL,
  output_audio_format TEXT DEFAULT NULL,
  parallel_tool_calls BOOLEAN DEFAULT NULL,
  prediction JSONB DEFAULT NULL,
  presence_penalty DOUBLE PRECISION DEFAULT NULL,
  prompt_cache_key TEXT DEFAULT NULL,
  reasoning JSONB DEFAULT NULL,
  reasoning_effort TEXT DEFAULT NULL,
  response_format JSONB DEFAULT NULL,
  safety_identifier TEXT DEFAULT NULL,
  safety_settings JSONB[] DEFAULT NULL,
  search_parameters JSONB DEFAULT NULL,
  seed BIGINT DEFAULT NULL,
  service_tier TEXT DEFAULT NULL,
  stop JSONB DEFAULT NULL,
  store BOOLEAN DEFAULT NULL,
  stream BOOLEAN DEFAULT NULL,
  stream_options JSONB DEFAULT NULL,
  structured_output JSONB DEFAULT NULL,
  system_instruction JSONB DEFAULT NULL,
  temperature DOUBLE PRECISION DEFAULT NULL,
  thinking JSONB DEFAULT NULL,
  timeout DOUBLE PRECISION DEFAULT NULL,
  tool_choice JSONB DEFAULT NULL,
  tool_config JSONB DEFAULT NULL,
  top_k BIGINT DEFAULT NULL,
  top_logprobs BIGINT DEFAULT NULL,
  top_p DOUBLE PRECISION DEFAULT NULL,
  truncation TEXT DEFAULT NULL,
  turn_detection JSONB DEFAULT NULL,
  "user" TEXT DEFAULT NULL,
  verbosity TEXT DEFAULT NULL,
  voice TEXT DEFAULT NULL,
  web_search_options JSONB DEFAULT NULL
)
RETURNS dedalus_sdk.model_settings
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    attributes,
    audio,
    deferred,
    extra_args,
    extra_headers,
    extra_query,
    frequency_penalty,
    generation_config,
    include_usage,
    input_audio_format,
    input_audio_transcription,
    logit_bias,
    logprobs,
    max_completion_tokens,
    max_tokens,
    metadata,
    modalities,
    n,
    output_audio_format,
    parallel_tool_calls,
    prediction,
    presence_penalty,
    prompt_cache_key,
    reasoning,
    reasoning_effort,
    response_format,
    safety_identifier,
    safety_settings,
    search_parameters,
    seed,
    service_tier,
    stop,
    store,
    stream,
    stream_options,
    structured_output,
    system_instruction,
    temperature,
    thinking,
    timeout,
    tool_choice,
    tool_config,
    top_k,
    top_logprobs,
    top_p,
    truncation,
    turn_detection,
    "user",
    verbosity,
    voice,
    web_search_options
  )::dedalus_sdk.model_settings;
$$;

ALTER TYPE dedalus_sdk.response_format_json_object
  ADD ATTRIBUTE type TEXT;

CREATE OR REPLACE FUNCTION dedalus_sdk.make_response_format_json_object(
  type TEXT
)
RETURNS dedalus_sdk.response_format_json_object
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(type)::dedalus_sdk.response_format_json_object;
$$;

ALTER TYPE dedalus_sdk.response_format_json_schema
  ADD ATTRIBUTE json_schema dedalus_sdk.response_format_json_schema_json_schema,
  ADD ATTRIBUTE type TEXT;

CREATE OR REPLACE FUNCTION dedalus_sdk.make_response_format_json_schema(
  json_schema dedalus_sdk.response_format_json_schema_json_schema, type TEXT
)
RETURNS dedalus_sdk.response_format_json_schema
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(json_schema, type)::dedalus_sdk.response_format_json_schema;
$$;

ALTER TYPE dedalus_sdk.response_format_json_schema_json_schema
  ADD ATTRIBUTE name TEXT,
  ADD ATTRIBUTE description TEXT,
  ADD ATTRIBUTE schema JSONB,
  ADD ATTRIBUTE strict BOOLEAN;

CREATE OR REPLACE FUNCTION dedalus_sdk.make_response_format_json_schema_json_schema(
  name TEXT,
  description TEXT DEFAULT NULL,
  schema JSONB DEFAULT NULL,
  strict BOOLEAN DEFAULT NULL
)
RETURNS dedalus_sdk.response_format_json_schema_json_schema
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    name, description, schema, strict
  )::dedalus_sdk.response_format_json_schema_json_schema;
$$;

ALTER TYPE dedalus_sdk.response_format_text
  ADD ATTRIBUTE type TEXT;

CREATE OR REPLACE FUNCTION dedalus_sdk.make_response_format_text(type TEXT)
RETURNS dedalus_sdk.response_format_text
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(type)::dedalus_sdk.response_format_text;
$$;

ALTER TYPE dedalus_sdk.voice_ids_or_custom_voice
  ADD ATTRIBUTE id TEXT;

CREATE OR REPLACE FUNCTION dedalus_sdk.make_voice_ids_or_custom_voice(id TEXT)
RETURNS dedalus_sdk.voice_ids_or_custom_voice
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(id)::dedalus_sdk.voice_ids_or_custom_voice;
$$;