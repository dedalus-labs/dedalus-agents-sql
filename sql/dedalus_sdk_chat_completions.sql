ALTER TYPE dedalus_sdk_chat_completions.audio
  ADD ATTRIBUTE id TEXT;

CREATE OR REPLACE FUNCTION dedalus_sdk_chat_completions.make_audio(id TEXT)
RETURNS dedalus_sdk_chat_completions.audio
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(id)::dedalus_sdk_chat_completions.audio;
$$;

ALTER TYPE dedalus_sdk_chat_completions.chat_completion
  ADD ATTRIBUTE id TEXT,
  ADD ATTRIBUTE choices dedalus_sdk_chat_completions.choice[],
  ADD ATTRIBUTE created BIGINT,
  ADD ATTRIBUTE model TEXT,
  ADD ATTRIBUTE object TEXT,
  ADD ATTRIBUTE correlation_id TEXT,
  ADD ATTRIBUTE deferred dedalus_sdk_chat_completions.deferred_call_response[],
  ADD ATTRIBUTE mcp_server_errors JSONB,
  ADD ATTRIBUTE mcp_tool_results dedalus_sdk.mcp_tool_result[],
  ADD ATTRIBUTE pending_tools dedalus_sdk_chat_completions.chat_completion_pending_tool[],
  ADD ATTRIBUTE server_results JSONB,
  ADD ATTRIBUTE service_tier TEXT,
  ADD ATTRIBUTE system_fingerprint TEXT,
  ADD ATTRIBUTE tools_executed TEXT[],
  ADD ATTRIBUTE turns_consumed BIGINT,
  ADD ATTRIBUTE usage dedalus_sdk_chat_completions.completion_usage;

CREATE OR REPLACE FUNCTION dedalus_sdk_chat_completions.make_chat_completion(
  id TEXT,
  choices dedalus_sdk_chat_completions.choice[],
  created BIGINT,
  model TEXT,
  object TEXT,
  correlation_id TEXT DEFAULT NULL,
  deferred dedalus_sdk_chat_completions.deferred_call_response[] DEFAULT NULL,
  mcp_server_errors JSONB DEFAULT NULL,
  mcp_tool_results dedalus_sdk.mcp_tool_result[] DEFAULT NULL,
  pending_tools dedalus_sdk_chat_completions.chat_completion_pending_tool[] DEFAULT NULL,
  server_results JSONB DEFAULT NULL,
  service_tier TEXT DEFAULT NULL,
  system_fingerprint TEXT DEFAULT NULL,
  tools_executed TEXT[] DEFAULT NULL,
  turns_consumed BIGINT DEFAULT NULL,
  usage dedalus_sdk_chat_completions.completion_usage DEFAULT NULL
)
RETURNS dedalus_sdk_chat_completions.chat_completion
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    id,
    choices,
    created,
    model,
    object,
    correlation_id,
    deferred,
    mcp_server_errors,
    mcp_tool_results,
    pending_tools,
    server_results,
    service_tier,
    system_fingerprint,
    tools_executed,
    turns_consumed,
    usage
  )::dedalus_sdk_chat_completions.chat_completion;
$$;

ALTER TYPE dedalus_sdk_chat_completions.chat_completion_pending_tool
  ADD ATTRIBUTE id TEXT,
  ADD ATTRIBUTE arguments JSONB,
  ADD ATTRIBUTE name TEXT,
  ADD ATTRIBUTE dependencies TEXT[];

CREATE OR REPLACE FUNCTION dedalus_sdk_chat_completions.make_chat_completion_pending_tool(
  id TEXT, arguments JSONB, name TEXT, dependencies TEXT[] DEFAULT NULL
)
RETURNS dedalus_sdk_chat_completions.chat_completion_pending_tool
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    id, arguments, name, dependencies
  )::dedalus_sdk_chat_completions.chat_completion_pending_tool;
$$;

ALTER TYPE dedalus_sdk_chat_completions.chat_completion_assistant_message_param
  ADD ATTRIBUTE role TEXT,
  ADD ATTRIBUTE audio dedalus_sdk_chat_completions.audio,
  ADD ATTRIBUTE content JSONB,
  ADD ATTRIBUTE function_call dedalus_sdk_chat_completions.chat_completion_assistant_message_param_function_call,
  ADD ATTRIBUTE name TEXT,
  ADD ATTRIBUTE refusal TEXT,
  ADD ATTRIBUTE tool_calls dedalus_sdk_chat_completions.chat_completion_assistant_message_param_tool_call[];

CREATE OR REPLACE FUNCTION dedalus_sdk_chat_completions.make_chat_completion_assistant_message_param(
  role TEXT,
  audio dedalus_sdk_chat_completions.audio DEFAULT NULL,
  content JSONB DEFAULT NULL,
  function_call dedalus_sdk_chat_completions.chat_completion_assistant_message_param_function_call DEFAULT NULL,
  name TEXT DEFAULT NULL,
  refusal TEXT DEFAULT NULL,
  tool_calls dedalus_sdk_chat_completions.chat_completion_assistant_message_param_tool_call[] DEFAULT NULL
)
RETURNS dedalus_sdk_chat_completions.chat_completion_assistant_message_param
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    role, audio, content, function_call, name, refusal, tool_calls
  )::dedalus_sdk_chat_completions.chat_completion_assistant_message_param;
$$;

ALTER TYPE dedalus_sdk_chat_completions.chat_completion_assistant_message_param_function_call
  ADD ATTRIBUTE arguments TEXT, ADD ATTRIBUTE name TEXT;

CREATE OR REPLACE FUNCTION dedalus_sdk_chat_completions.make_chat_completion_assistant_message_param_function_call(
  arguments TEXT, name TEXT
)
RETURNS dedalus_sdk_chat_completions.chat_completion_assistant_message_param_function_call
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    arguments, name
  )::dedalus_sdk_chat_completions.chat_completion_assistant_message_param_function_call;
$$;

ALTER TYPE dedalus_sdk_chat_completions.chat_completion_assistant_message_param_tool_call
  ADD ATTRIBUTE id TEXT,
  ADD ATTRIBUTE type TEXT,
  ADD ATTRIBUTE function dedalus_sdk_chat_completions.chat_completion_assistant_message_param_tool_call_function,
  ADD ATTRIBUTE thought_signature TEXT,
  ADD ATTRIBUTE custom dedalus_sdk_chat_completions.chat_completion_assistant_message_param_tool_call_custom;

CREATE OR REPLACE FUNCTION dedalus_sdk_chat_completions.make_chat_completion_assistant_message_param_tool_call(
  id TEXT,
  type TEXT,
  function dedalus_sdk_chat_completions.chat_completion_assistant_message_param_tool_call_function DEFAULT NULL,
  thought_signature TEXT DEFAULT NULL,
  custom dedalus_sdk_chat_completions.chat_completion_assistant_message_param_tool_call_custom DEFAULT NULL
)
RETURNS dedalus_sdk_chat_completions.chat_completion_assistant_message_param_tool_call
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    id, type, function, thought_signature, custom
  )::dedalus_sdk_chat_completions.chat_completion_assistant_message_param_tool_call;
$$;

ALTER TYPE dedalus_sdk_chat_completions.chat_completion_assistant_message_param_tool_call_function
  ADD ATTRIBUTE arguments TEXT, ADD ATTRIBUTE name TEXT;

CREATE OR REPLACE FUNCTION dedalus_sdk_chat_completions.make_chat_completion_assistant_message_param_tool_call_function(
  arguments TEXT, name TEXT
)
RETURNS dedalus_sdk_chat_completions.chat_completion_assistant_message_param_tool_call_function
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    arguments, name
  )::dedalus_sdk_chat_completions.chat_completion_assistant_message_param_tool_call_function;
$$;

ALTER TYPE dedalus_sdk_chat_completions.chat_completion_assistant_message_param_tool_call_custom
  ADD ATTRIBUTE input TEXT, ADD ATTRIBUTE name TEXT;

CREATE OR REPLACE FUNCTION dedalus_sdk_chat_completions.make_chat_completion_assistant_message_param_tool_call_custom(
  input TEXT, name TEXT
)
RETURNS dedalus_sdk_chat_completions.chat_completion_assistant_message_param_tool_call_custom
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    input, name
  )::dedalus_sdk_chat_completions.chat_completion_assistant_message_param_tool_call_custom;
$$;

ALTER TYPE dedalus_sdk_chat_completions.chat_completion_audio_param
  ADD ATTRIBUTE format TEXT, ADD ATTRIBUTE voice JSONB;

CREATE OR REPLACE FUNCTION dedalus_sdk_chat_completions.make_chat_completion_audio_param(
  format TEXT, voice JSONB
)
RETURNS dedalus_sdk_chat_completions.chat_completion_audio_param
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    format, voice
  )::dedalus_sdk_chat_completions.chat_completion_audio_param;
$$;

ALTER TYPE dedalus_sdk_chat_completions.chat_completion_chunk
  ADD ATTRIBUTE id TEXT,
  ADD ATTRIBUTE choices dedalus_sdk_chat_completions.stream_choice[],
  ADD ATTRIBUTE created BIGINT,
  ADD ATTRIBUTE model TEXT,
  ADD ATTRIBUTE object TEXT,
  ADD ATTRIBUTE service_tier TEXT,
  ADD ATTRIBUTE system_fingerprint TEXT,
  ADD ATTRIBUTE usage dedalus_sdk_chat_completions.completion_usage;

CREATE OR REPLACE FUNCTION dedalus_sdk_chat_completions.make_chat_completion_chunk(
  id TEXT,
  choices dedalus_sdk_chat_completions.stream_choice[],
  created BIGINT,
  model TEXT,
  object TEXT,
  service_tier TEXT DEFAULT NULL,
  system_fingerprint TEXT DEFAULT NULL,
  usage dedalus_sdk_chat_completions.completion_usage DEFAULT NULL
)
RETURNS dedalus_sdk_chat_completions.chat_completion_chunk
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    id, choices, created, model, object, service_tier, system_fingerprint, usage
  )::dedalus_sdk_chat_completions.chat_completion_chunk;
$$;

ALTER TYPE dedalus_sdk_chat_completions.chat_completion_content_part_file_param
  ADD ATTRIBUTE file dedalus_sdk_chat_completions.chat_completion_content_part_file_param_file,
  ADD ATTRIBUTE type TEXT;

CREATE OR REPLACE FUNCTION dedalus_sdk_chat_completions.make_chat_completion_content_part_file_param(
  file dedalus_sdk_chat_completions.chat_completion_content_part_file_param_file,
  type TEXT
)
RETURNS dedalus_sdk_chat_completions.chat_completion_content_part_file_param
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    file, type
  )::dedalus_sdk_chat_completions.chat_completion_content_part_file_param;
$$;

ALTER TYPE dedalus_sdk_chat_completions.chat_completion_content_part_file_param_file
  ADD ATTRIBUTE file_data TEXT,
  ADD ATTRIBUTE file_id TEXT,
  ADD ATTRIBUTE filename TEXT;

CREATE OR REPLACE FUNCTION dedalus_sdk_chat_completions.make_chat_completion_content_part_file_param_file(
  file_data TEXT DEFAULT NULL,
  file_id TEXT DEFAULT NULL,
  filename TEXT DEFAULT NULL
)
RETURNS dedalus_sdk_chat_completions.chat_completion_content_part_file_param_file
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    file_data, file_id, filename
  )::dedalus_sdk_chat_completions.chat_completion_content_part_file_param_file;
$$;

ALTER TYPE dedalus_sdk_chat_completions.chat_completion_content_part_image_param
  ADD ATTRIBUTE image_url dedalus_sdk_chat_completions.chat_completion_content_part_image_param_image_url,
  ADD ATTRIBUTE type TEXT;

CREATE OR REPLACE FUNCTION dedalus_sdk_chat_completions.make_chat_completion_content_part_image_param(
  image_url dedalus_sdk_chat_completions.chat_completion_content_part_image_param_image_url,
  type TEXT
)
RETURNS dedalus_sdk_chat_completions.chat_completion_content_part_image_param
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    image_url, type
  )::dedalus_sdk_chat_completions.chat_completion_content_part_image_param;
$$;

ALTER TYPE dedalus_sdk_chat_completions.chat_completion_content_part_image_param_image_url
  ADD ATTRIBUTE url TEXT, ADD ATTRIBUTE detail TEXT;

CREATE OR REPLACE FUNCTION dedalus_sdk_chat_completions.make_chat_completion_content_part_image_param_image_url(
  url TEXT, detail TEXT DEFAULT NULL
)
RETURNS dedalus_sdk_chat_completions.chat_completion_content_part_image_param_image_url
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    url, detail
  )::dedalus_sdk_chat_completions.chat_completion_content_part_image_param_image_url;
$$;

ALTER TYPE dedalus_sdk_chat_completions.chat_completion_content_part_input_audio_param
  ADD ATTRIBUTE input_audio dedalus_sdk_chat_completions.chat_completion_content_part_input_audio_param_input_audio,
  ADD ATTRIBUTE type TEXT;

CREATE OR REPLACE FUNCTION dedalus_sdk_chat_completions.make_chat_completion_content_part_input_audio_param(
  input_audio dedalus_sdk_chat_completions.chat_completion_content_part_input_audio_param_input_audio,
  type TEXT
)
RETURNS dedalus_sdk_chat_completions.chat_completion_content_part_input_audio_param
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    input_audio, type
  )::dedalus_sdk_chat_completions.chat_completion_content_part_input_audio_param;
$$;

ALTER TYPE dedalus_sdk_chat_completions.chat_completion_content_part_input_audio_param_input_audio
  ADD ATTRIBUTE data TEXT, ADD ATTRIBUTE format TEXT;

CREATE OR REPLACE FUNCTION dedalus_sdk_chat_completions.make_chat_completion_content_part_input_audio_param_input_audio(
  data TEXT, format TEXT
)
RETURNS dedalus_sdk_chat_completions.chat_completion_content_part_input_audio_param_input_audio
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    data, format
  )::dedalus_sdk_chat_completions.chat_completion_content_part_input_audio_param_input_audio;
$$;

ALTER TYPE dedalus_sdk_chat_completions.chat_completion_content_part_refusal_param
  ADD ATTRIBUTE refusal TEXT, ADD ATTRIBUTE type TEXT;

CREATE OR REPLACE FUNCTION dedalus_sdk_chat_completions.make_chat_completion_content_part_refusal_param(
  refusal TEXT, type TEXT
)
RETURNS dedalus_sdk_chat_completions.chat_completion_content_part_refusal_param
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    refusal, type
  )::dedalus_sdk_chat_completions.chat_completion_content_part_refusal_param;
$$;

ALTER TYPE dedalus_sdk_chat_completions.chat_completion_content_part_text_param
  ADD ATTRIBUTE text TEXT, ADD ATTRIBUTE type TEXT;

CREATE OR REPLACE FUNCTION dedalus_sdk_chat_completions.make_chat_completion_content_part_text_param(
  text TEXT, type TEXT
)
RETURNS dedalus_sdk_chat_completions.chat_completion_content_part_text_param
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    text, type
  )::dedalus_sdk_chat_completions.chat_completion_content_part_text_param;
$$;

ALTER TYPE dedalus_sdk_chat_completions.chat_completion_developer_message_param
  ADD ATTRIBUTE content JSONB, ADD ATTRIBUTE role TEXT, ADD ATTRIBUTE name TEXT;

CREATE OR REPLACE FUNCTION dedalus_sdk_chat_completions.make_chat_completion_developer_message_param(
  content JSONB, role TEXT, name TEXT DEFAULT NULL
)
RETURNS dedalus_sdk_chat_completions.chat_completion_developer_message_param
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    content, role, name
  )::dedalus_sdk_chat_completions.chat_completion_developer_message_param;
$$;

ALTER TYPE dedalus_sdk_chat_completions.chat_completion_function_message_param
  ADD ATTRIBUTE name TEXT, ADD ATTRIBUTE role TEXT, ADD ATTRIBUTE content TEXT;

CREATE OR REPLACE FUNCTION dedalus_sdk_chat_completions.make_chat_completion_function_message_param(
  name TEXT, role TEXT, content TEXT DEFAULT NULL
)
RETURNS dedalus_sdk_chat_completions.chat_completion_function_message_param
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    name, role, content
  )::dedalus_sdk_chat_completions.chat_completion_function_message_param;
$$;

ALTER TYPE dedalus_sdk_chat_completions.chat_completion_functions
  ADD ATTRIBUTE name TEXT,
  ADD ATTRIBUTE description TEXT,
  ADD ATTRIBUTE parameters JSONB;

CREATE OR REPLACE FUNCTION dedalus_sdk_chat_completions.make_chat_completion_functions(
  name TEXT, description TEXT DEFAULT NULL, parameters JSONB DEFAULT NULL
)
RETURNS dedalus_sdk_chat_completions.chat_completion_functions
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    name, description, parameters
  )::dedalus_sdk_chat_completions.chat_completion_functions;
$$;

ALTER TYPE dedalus_sdk_chat_completions.chat_completion_message
  ADD ATTRIBUTE role TEXT,
  ADD ATTRIBUTE content TEXT,
  ADD ATTRIBUTE refusal TEXT,
  ADD ATTRIBUTE annotations dedalus_sdk_chat_completions.chat_completion_message_annotation[],
  ADD ATTRIBUTE audio dedalus_sdk_chat_completions.chat_completion_message_audio,
  ADD ATTRIBUTE function_call dedalus_sdk_chat_completions.chat_completion_message_function_call,
  ADD ATTRIBUTE tool_calls dedalus_sdk_chat_completions.chat_completion_message_tool_call[];

CREATE OR REPLACE FUNCTION dedalus_sdk_chat_completions.make_chat_completion_message(
  role TEXT,
  content TEXT DEFAULT NULL,
  refusal TEXT DEFAULT NULL,
  annotations dedalus_sdk_chat_completions.chat_completion_message_annotation[] DEFAULT NULL,
  audio dedalus_sdk_chat_completions.chat_completion_message_audio DEFAULT NULL,
  function_call dedalus_sdk_chat_completions.chat_completion_message_function_call DEFAULT NULL,
  tool_calls dedalus_sdk_chat_completions.chat_completion_message_tool_call[] DEFAULT NULL
)
RETURNS dedalus_sdk_chat_completions.chat_completion_message
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    role, content, refusal, annotations, audio, function_call, tool_calls
  )::dedalus_sdk_chat_completions.chat_completion_message;
$$;

ALTER TYPE dedalus_sdk_chat_completions.chat_completion_message_annotation
  ADD ATTRIBUTE type TEXT,
  ADD ATTRIBUTE url_citation dedalus_sdk_chat_completions.chat_completion_message_annotation_url_citation;

CREATE OR REPLACE FUNCTION dedalus_sdk_chat_completions.make_chat_completion_message_annotation(
  type TEXT,
  url_citation dedalus_sdk_chat_completions.chat_completion_message_annotation_url_citation
)
RETURNS dedalus_sdk_chat_completions.chat_completion_message_annotation
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    type, url_citation
  )::dedalus_sdk_chat_completions.chat_completion_message_annotation;
$$;

ALTER TYPE dedalus_sdk_chat_completions.chat_completion_message_annotation_url_citation
  ADD ATTRIBUTE end_index BIGINT,
  ADD ATTRIBUTE start_index BIGINT,
  ADD ATTRIBUTE title TEXT,
  ADD ATTRIBUTE url TEXT;

CREATE OR REPLACE FUNCTION dedalus_sdk_chat_completions.make_chat_completion_message_annotation_url_citation(
  end_index BIGINT, start_index BIGINT, title TEXT, url TEXT
)
RETURNS dedalus_sdk_chat_completions.chat_completion_message_annotation_url_citation
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    end_index, start_index, title, url
  )::dedalus_sdk_chat_completions.chat_completion_message_annotation_url_citation;
$$;

ALTER TYPE dedalus_sdk_chat_completions.chat_completion_message_audio
  ADD ATTRIBUTE id TEXT,
  ADD ATTRIBUTE data TEXT,
  ADD ATTRIBUTE expires_at BIGINT,
  ADD ATTRIBUTE transcript TEXT;

CREATE OR REPLACE FUNCTION dedalus_sdk_chat_completions.make_chat_completion_message_audio(
  id TEXT, data TEXT, expires_at BIGINT, transcript TEXT
)
RETURNS dedalus_sdk_chat_completions.chat_completion_message_audio
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    id, data, expires_at, transcript
  )::dedalus_sdk_chat_completions.chat_completion_message_audio;
$$;

ALTER TYPE dedalus_sdk_chat_completions.chat_completion_message_function_call
  ADD ATTRIBUTE arguments TEXT, ADD ATTRIBUTE name TEXT;

CREATE OR REPLACE FUNCTION dedalus_sdk_chat_completions.make_chat_completion_message_function_call(
  arguments TEXT, name TEXT
)
RETURNS dedalus_sdk_chat_completions.chat_completion_message_function_call
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    arguments, name
  )::dedalus_sdk_chat_completions.chat_completion_message_function_call;
$$;

ALTER TYPE dedalus_sdk_chat_completions.chat_completion_message_tool_call
  ADD ATTRIBUTE id TEXT,
  ADD ATTRIBUTE type TEXT,
  ADD ATTRIBUTE function dedalus_sdk_chat_completions.chat_completion_message_tool_call_function,
  ADD ATTRIBUTE thought_signature TEXT,
  ADD ATTRIBUTE custom dedalus_sdk_chat_completions.chat_completion_message_tool_call_custom;

CREATE OR REPLACE FUNCTION dedalus_sdk_chat_completions.make_chat_completion_message_tool_call(
  id TEXT,
  type TEXT,
  function dedalus_sdk_chat_completions.chat_completion_message_tool_call_function DEFAULT NULL,
  thought_signature TEXT DEFAULT NULL,
  custom dedalus_sdk_chat_completions.chat_completion_message_tool_call_custom DEFAULT NULL
)
RETURNS dedalus_sdk_chat_completions.chat_completion_message_tool_call
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    id, type, function, thought_signature, custom
  )::dedalus_sdk_chat_completions.chat_completion_message_tool_call;
$$;

ALTER TYPE dedalus_sdk_chat_completions.chat_completion_message_tool_call_function
  ADD ATTRIBUTE arguments TEXT, ADD ATTRIBUTE name TEXT;

CREATE OR REPLACE FUNCTION dedalus_sdk_chat_completions.make_chat_completion_message_tool_call_function(
  arguments TEXT, name TEXT
)
RETURNS dedalus_sdk_chat_completions.chat_completion_message_tool_call_function
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    arguments, name
  )::dedalus_sdk_chat_completions.chat_completion_message_tool_call_function;
$$;

ALTER TYPE dedalus_sdk_chat_completions.chat_completion_message_tool_call_custom
  ADD ATTRIBUTE input TEXT, ADD ATTRIBUTE name TEXT;

CREATE OR REPLACE FUNCTION dedalus_sdk_chat_completions.make_chat_completion_message_tool_call_custom(
  input TEXT, name TEXT
)
RETURNS dedalus_sdk_chat_completions.chat_completion_message_tool_call_custom
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    input, name
  )::dedalus_sdk_chat_completions.chat_completion_message_tool_call_custom;
$$;

ALTER TYPE dedalus_sdk_chat_completions.chat_completion_message_custom_tool_call
  ADD ATTRIBUTE id TEXT,
  ADD ATTRIBUTE custom dedalus_sdk_chat_completions.chat_completion_message_custom_tool_call_custom,
  ADD ATTRIBUTE type TEXT;

CREATE OR REPLACE FUNCTION dedalus_sdk_chat_completions.make_chat_completion_message_custom_tool_call(
  id TEXT,
  custom dedalus_sdk_chat_completions.chat_completion_message_custom_tool_call_custom,
  type TEXT
)
RETURNS dedalus_sdk_chat_completions.chat_completion_message_custom_tool_call
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    id, custom, type
  )::dedalus_sdk_chat_completions.chat_completion_message_custom_tool_call;
$$;

ALTER TYPE dedalus_sdk_chat_completions.chat_completion_message_custom_tool_call_custom
  ADD ATTRIBUTE input TEXT, ADD ATTRIBUTE name TEXT;

CREATE OR REPLACE FUNCTION dedalus_sdk_chat_completions.make_chat_completion_message_custom_tool_call_custom(
  input TEXT, name TEXT
)
RETURNS dedalus_sdk_chat_completions.chat_completion_message_custom_tool_call_custom
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    input, name
  )::dedalus_sdk_chat_completions.chat_completion_message_custom_tool_call_custom;
$$;

ALTER TYPE dedalus_sdk_chat_completions.chat_completion_message_tool_call1
  ADD ATTRIBUTE id TEXT,
  ADD ATTRIBUTE function dedalus_sdk_chat_completions.chat_completion_message_tool_call_function1,
  ADD ATTRIBUTE type TEXT,
  ADD ATTRIBUTE thought_signature TEXT;

CREATE OR REPLACE FUNCTION dedalus_sdk_chat_completions.make_chat_completion_message_tool_call1(
  id TEXT,
  function dedalus_sdk_chat_completions.chat_completion_message_tool_call_function1,
  type TEXT,
  thought_signature TEXT DEFAULT NULL
)
RETURNS dedalus_sdk_chat_completions.chat_completion_message_tool_call1
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    id, function, type, thought_signature
  )::dedalus_sdk_chat_completions.chat_completion_message_tool_call1;
$$;

ALTER TYPE dedalus_sdk_chat_completions.chat_completion_message_tool_call_function1
  ADD ATTRIBUTE arguments TEXT, ADD ATTRIBUTE name TEXT;

CREATE OR REPLACE FUNCTION dedalus_sdk_chat_completions.make_chat_completion_message_tool_call_function1(
  arguments TEXT, name TEXT
)
RETURNS dedalus_sdk_chat_completions.chat_completion_message_tool_call_function1
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    arguments, name
  )::dedalus_sdk_chat_completions.chat_completion_message_tool_call_function1;
$$;

ALTER TYPE dedalus_sdk_chat_completions.chat_completion_system_message_param
  ADD ATTRIBUTE content JSONB, ADD ATTRIBUTE role TEXT, ADD ATTRIBUTE name TEXT;

CREATE OR REPLACE FUNCTION dedalus_sdk_chat_completions.make_chat_completion_system_message_param(
  content JSONB, role TEXT, name TEXT DEFAULT NULL
)
RETURNS dedalus_sdk_chat_completions.chat_completion_system_message_param
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    content, role, name
  )::dedalus_sdk_chat_completions.chat_completion_system_message_param;
$$;

ALTER TYPE dedalus_sdk_chat_completions.chat_completion_token_logprob
  ADD ATTRIBUTE token TEXT,
  ADD ATTRIBUTE logprob DOUBLE PRECISION,
  ADD ATTRIBUTE top_logprobs dedalus_sdk_chat_completions.chat_completion_token_logprob_top_logprob[],
  ADD ATTRIBUTE bytes BIGINT[];

CREATE OR REPLACE FUNCTION dedalus_sdk_chat_completions.make_chat_completion_token_logprob(
  token TEXT,
  logprob DOUBLE PRECISION,
  top_logprobs dedalus_sdk_chat_completions.chat_completion_token_logprob_top_logprob[],
  bytes BIGINT[] DEFAULT NULL
)
RETURNS dedalus_sdk_chat_completions.chat_completion_token_logprob
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    token, logprob, top_logprobs, bytes
  )::dedalus_sdk_chat_completions.chat_completion_token_logprob;
$$;

ALTER TYPE dedalus_sdk_chat_completions.chat_completion_token_logprob_top_logprob
  ADD ATTRIBUTE token TEXT,
  ADD ATTRIBUTE logprob DOUBLE PRECISION,
  ADD ATTRIBUTE bytes BIGINT[];

CREATE OR REPLACE FUNCTION dedalus_sdk_chat_completions.make_chat_completion_token_logprob_top_logprob(
  token TEXT, logprob DOUBLE PRECISION, bytes BIGINT[] DEFAULT NULL
)
RETURNS dedalus_sdk_chat_completions.chat_completion_token_logprob_top_logprob
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    token, logprob, bytes
  )::dedalus_sdk_chat_completions.chat_completion_token_logprob_top_logprob;
$$;

ALTER TYPE dedalus_sdk_chat_completions.chat_completion_tool_message_param
  ADD ATTRIBUTE content JSONB,
  ADD ATTRIBUTE role TEXT,
  ADD ATTRIBUTE tool_call_id TEXT;

CREATE OR REPLACE FUNCTION dedalus_sdk_chat_completions.make_chat_completion_tool_message_param(
  content JSONB, role TEXT, tool_call_id TEXT
)
RETURNS dedalus_sdk_chat_completions.chat_completion_tool_message_param
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    content, role, tool_call_id
  )::dedalus_sdk_chat_completions.chat_completion_tool_message_param;
$$;

ALTER TYPE dedalus_sdk_chat_completions.chat_completion_tool_param
  ADD ATTRIBUTE function dedalus_sdk.function_definition,
  ADD ATTRIBUTE type TEXT;

CREATE OR REPLACE FUNCTION dedalus_sdk_chat_completions.make_chat_completion_tool_param(
  function dedalus_sdk.function_definition, type TEXT DEFAULT NULL
)
RETURNS dedalus_sdk_chat_completions.chat_completion_tool_param
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    function, type
  )::dedalus_sdk_chat_completions.chat_completion_tool_param;
$$;

ALTER TYPE dedalus_sdk_chat_completions.chat_completion_user_message_param
  ADD ATTRIBUTE content JSONB, ADD ATTRIBUTE role TEXT, ADD ATTRIBUTE name TEXT;

CREATE OR REPLACE FUNCTION dedalus_sdk_chat_completions.make_chat_completion_user_message_param(
  content JSONB, role TEXT, name TEXT DEFAULT NULL
)
RETURNS dedalus_sdk_chat_completions.chat_completion_user_message_param
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    content, role, name
  )::dedalus_sdk_chat_completions.chat_completion_user_message_param;
$$;

ALTER TYPE dedalus_sdk_chat_completions.choice
  ADD ATTRIBUTE index BIGINT,
  ADD ATTRIBUTE message dedalus_sdk_chat_completions.chat_completion_message,
  ADD ATTRIBUTE finish_reason TEXT,
  ADD ATTRIBUTE logprobs dedalus_sdk_chat_completions.choice_logprobs;

CREATE OR REPLACE FUNCTION dedalus_sdk_chat_completions.make_choice(
  index BIGINT,
  message dedalus_sdk_chat_completions.chat_completion_message,
  finish_reason TEXT DEFAULT NULL,
  logprobs dedalus_sdk_chat_completions.choice_logprobs DEFAULT NULL
)
RETURNS dedalus_sdk_chat_completions.choice
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    index, message, finish_reason, logprobs
  )::dedalus_sdk_chat_completions.choice;
$$;

ALTER TYPE dedalus_sdk_chat_completions.choice_delta
  ADD ATTRIBUTE content TEXT,
  ADD ATTRIBUTE function_call dedalus_sdk_chat_completions.choice_delta_function_call,
  ADD ATTRIBUTE refusal TEXT,
  ADD ATTRIBUTE role TEXT,
  ADD ATTRIBUTE tool_calls dedalus_sdk_chat_completions.choice_delta_tool_call[];

CREATE OR REPLACE FUNCTION dedalus_sdk_chat_completions.make_choice_delta(
  content TEXT DEFAULT NULL,
  function_call dedalus_sdk_chat_completions.choice_delta_function_call DEFAULT NULL,
  refusal TEXT DEFAULT NULL,
  role TEXT DEFAULT NULL,
  tool_calls dedalus_sdk_chat_completions.choice_delta_tool_call[] DEFAULT NULL
)
RETURNS dedalus_sdk_chat_completions.choice_delta
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    content, function_call, refusal, role, tool_calls
  )::dedalus_sdk_chat_completions.choice_delta;
$$;

ALTER TYPE dedalus_sdk_chat_completions.choice_delta_function_call
  ADD ATTRIBUTE arguments TEXT, ADD ATTRIBUTE name TEXT;

CREATE OR REPLACE FUNCTION dedalus_sdk_chat_completions.make_choice_delta_function_call(
  arguments TEXT DEFAULT NULL, name TEXT DEFAULT NULL
)
RETURNS dedalus_sdk_chat_completions.choice_delta_function_call
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    arguments, name
  )::dedalus_sdk_chat_completions.choice_delta_function_call;
$$;

ALTER TYPE dedalus_sdk_chat_completions.choice_delta_tool_call
  ADD ATTRIBUTE index BIGINT,
  ADD ATTRIBUTE id TEXT,
  ADD ATTRIBUTE function dedalus_sdk_chat_completions.choice_delta_tool_call_function,
  ADD ATTRIBUTE type TEXT;

CREATE OR REPLACE FUNCTION dedalus_sdk_chat_completions.make_choice_delta_tool_call(
  index BIGINT,
  id TEXT DEFAULT NULL,
  function dedalus_sdk_chat_completions.choice_delta_tool_call_function DEFAULT NULL,
  type TEXT DEFAULT NULL
)
RETURNS dedalus_sdk_chat_completions.choice_delta_tool_call
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    index, id, function, type
  )::dedalus_sdk_chat_completions.choice_delta_tool_call;
$$;

ALTER TYPE dedalus_sdk_chat_completions.choice_delta_tool_call_function
  ADD ATTRIBUTE arguments TEXT, ADD ATTRIBUTE name TEXT;

CREATE OR REPLACE FUNCTION dedalus_sdk_chat_completions.make_choice_delta_tool_call_function(
  arguments TEXT DEFAULT NULL, name TEXT DEFAULT NULL
)
RETURNS dedalus_sdk_chat_completions.choice_delta_tool_call_function
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    arguments, name
  )::dedalus_sdk_chat_completions.choice_delta_tool_call_function;
$$;

ALTER TYPE dedalus_sdk_chat_completions.choice_logprobs
  ADD ATTRIBUTE content dedalus_sdk_chat_completions.chat_completion_token_logprob[],
  ADD ATTRIBUTE refusal dedalus_sdk_chat_completions.chat_completion_token_logprob[];

CREATE OR REPLACE FUNCTION dedalus_sdk_chat_completions.make_choice_logprobs(
  content dedalus_sdk_chat_completions.chat_completion_token_logprob[] DEFAULT NULL,
  refusal dedalus_sdk_chat_completions.chat_completion_token_logprob[] DEFAULT NULL
)
RETURNS dedalus_sdk_chat_completions.choice_logprobs
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(content, refusal)::dedalus_sdk_chat_completions.choice_logprobs;
$$;

ALTER TYPE dedalus_sdk_chat_completions.completion_tokens_details
  ADD ATTRIBUTE accepted_prediction_tokens BIGINT,
  ADD ATTRIBUTE audio_tokens BIGINT,
  ADD ATTRIBUTE reasoning_tokens BIGINT,
  ADD ATTRIBUTE rejected_prediction_tokens BIGINT;

CREATE OR REPLACE FUNCTION dedalus_sdk_chat_completions.make_completion_tokens_details(
  accepted_prediction_tokens BIGINT DEFAULT NULL,
  audio_tokens BIGINT DEFAULT NULL,
  reasoning_tokens BIGINT DEFAULT NULL,
  rejected_prediction_tokens BIGINT DEFAULT NULL
)
RETURNS dedalus_sdk_chat_completions.completion_tokens_details
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    accepted_prediction_tokens,
    audio_tokens,
    reasoning_tokens,
    rejected_prediction_tokens
  )::dedalus_sdk_chat_completions.completion_tokens_details;
$$;

ALTER TYPE dedalus_sdk_chat_completions.completion_usage
  ADD ATTRIBUTE completion_tokens BIGINT,
  ADD ATTRIBUTE prompt_tokens BIGINT,
  ADD ATTRIBUTE total_tokens BIGINT,
  ADD ATTRIBUTE completion_tokens_details dedalus_sdk_chat_completions.completion_tokens_details,
  ADD ATTRIBUTE prompt_tokens_details dedalus_sdk_chat_completions.prompt_tokens_details;

CREATE OR REPLACE FUNCTION dedalus_sdk_chat_completions.make_completion_usage(
  completion_tokens BIGINT,
  prompt_tokens BIGINT,
  total_tokens BIGINT,
  completion_tokens_details dedalus_sdk_chat_completions.completion_tokens_details DEFAULT NULL,
  prompt_tokens_details dedalus_sdk_chat_completions.prompt_tokens_details DEFAULT NULL
)
RETURNS dedalus_sdk_chat_completions.completion_usage
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    completion_tokens,
    prompt_tokens,
    total_tokens,
    completion_tokens_details,
    prompt_tokens_details
  )::dedalus_sdk_chat_completions.completion_usage;
$$;

ALTER TYPE dedalus_sdk_chat_completions.deferred_call_response
  ADD ATTRIBUTE id TEXT,
  ADD ATTRIBUTE name TEXT,
  ADD ATTRIBUTE arguments JSONB,
  ADD ATTRIBUTE blocked_by TEXT[],
  ADD ATTRIBUTE dependencies TEXT[],
  ADD ATTRIBUTE venue TEXT;

CREATE OR REPLACE FUNCTION dedalus_sdk_chat_completions.make_deferred_call_response(
  id TEXT,
  name TEXT,
  arguments JSONB DEFAULT NULL,
  blocked_by TEXT[] DEFAULT NULL,
  dependencies TEXT[] DEFAULT NULL,
  venue TEXT DEFAULT NULL
)
RETURNS dedalus_sdk_chat_completions.deferred_call_response
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    id, name, arguments, blocked_by, dependencies, venue
  )::dedalus_sdk_chat_completions.deferred_call_response;
$$;

ALTER TYPE dedalus_sdk_chat_completions.input_token_details
  ADD ATTRIBUTE audio_tokens BIGINT, ADD ATTRIBUTE text_tokens BIGINT;

CREATE OR REPLACE FUNCTION dedalus_sdk_chat_completions.make_input_token_details(
  audio_tokens BIGINT DEFAULT NULL, text_tokens BIGINT DEFAULT NULL
)
RETURNS dedalus_sdk_chat_completions.input_token_details
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    audio_tokens, text_tokens
  )::dedalus_sdk_chat_completions.input_token_details;
$$;

ALTER TYPE dedalus_sdk_chat_completions.prediction_content
  ADD ATTRIBUTE content JSONB, ADD ATTRIBUTE type TEXT;

CREATE OR REPLACE FUNCTION dedalus_sdk_chat_completions.make_prediction_content(
  content JSONB, type TEXT
)
RETURNS dedalus_sdk_chat_completions.prediction_content
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(content, type)::dedalus_sdk_chat_completions.prediction_content;
$$;

ALTER TYPE dedalus_sdk_chat_completions.prompt_tokens_details
  ADD ATTRIBUTE audio_tokens BIGINT, ADD ATTRIBUTE cached_tokens BIGINT;

CREATE OR REPLACE FUNCTION dedalus_sdk_chat_completions.make_prompt_tokens_details(
  audio_tokens BIGINT DEFAULT NULL, cached_tokens BIGINT DEFAULT NULL
)
RETURNS dedalus_sdk_chat_completions.prompt_tokens_details
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    audio_tokens, cached_tokens
  )::dedalus_sdk_chat_completions.prompt_tokens_details;
$$;

ALTER TYPE dedalus_sdk_chat_completions.stream_choice
  ADD ATTRIBUTE delta dedalus_sdk_chat_completions.choice_delta,
  ADD ATTRIBUTE index BIGINT,
  ADD ATTRIBUTE finish_reason TEXT,
  ADD ATTRIBUTE logprobs dedalus_sdk_chat_completions.stream_choice_logprobs;

CREATE OR REPLACE FUNCTION dedalus_sdk_chat_completions.make_stream_choice(
  delta dedalus_sdk_chat_completions.choice_delta,
  index BIGINT,
  finish_reason TEXT DEFAULT NULL,
  logprobs dedalus_sdk_chat_completions.stream_choice_logprobs DEFAULT NULL
)
RETURNS dedalus_sdk_chat_completions.stream_choice
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    delta, index, finish_reason, logprobs
  )::dedalus_sdk_chat_completions.stream_choice;
$$;

ALTER TYPE dedalus_sdk_chat_completions.stream_choice_logprobs
  ADD ATTRIBUTE content dedalus_sdk_chat_completions.chat_completion_token_logprob[],
  ADD ATTRIBUTE refusal dedalus_sdk_chat_completions.chat_completion_token_logprob[];

CREATE OR REPLACE FUNCTION dedalus_sdk_chat_completions.make_stream_choice_logprobs(
  content dedalus_sdk_chat_completions.chat_completion_token_logprob[] DEFAULT NULL,
  refusal dedalus_sdk_chat_completions.chat_completion_token_logprob[] DEFAULT NULL
)
RETURNS dedalus_sdk_chat_completions.stream_choice_logprobs
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    content, refusal
  )::dedalus_sdk_chat_completions.stream_choice_logprobs;
$$;

ALTER TYPE dedalus_sdk_chat_completions.thinking_config_disabled
  ADD ATTRIBUTE type TEXT;

CREATE OR REPLACE FUNCTION dedalus_sdk_chat_completions.make_thinking_config_disabled(
  type TEXT
)
RETURNS dedalus_sdk_chat_completions.thinking_config_disabled
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(type)::dedalus_sdk_chat_completions.thinking_config_disabled;
$$;

ALTER TYPE dedalus_sdk_chat_completions.thinking_config_enabled
  ADD ATTRIBUTE budget_tokens BIGINT, ADD ATTRIBUTE type TEXT;

CREATE OR REPLACE FUNCTION dedalus_sdk_chat_completions.make_thinking_config_enabled(
  budget_tokens BIGINT, type TEXT
)
RETURNS dedalus_sdk_chat_completions.thinking_config_enabled
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    budget_tokens, type
  )::dedalus_sdk_chat_completions.thinking_config_enabled;
$$;

ALTER TYPE dedalus_sdk_chat_completions.tool_choice_any
  ADD ATTRIBUTE type TEXT, ADD ATTRIBUTE disable_parallel_tool_use BOOLEAN;

CREATE OR REPLACE FUNCTION dedalus_sdk_chat_completions.make_tool_choice_any(
  type TEXT, disable_parallel_tool_use BOOLEAN DEFAULT NULL
)
RETURNS dedalus_sdk_chat_completions.tool_choice_any
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    type, disable_parallel_tool_use
  )::dedalus_sdk_chat_completions.tool_choice_any;
$$;

ALTER TYPE dedalus_sdk_chat_completions.tool_choice_auto
  ADD ATTRIBUTE type TEXT, ADD ATTRIBUTE disable_parallel_tool_use BOOLEAN;

CREATE OR REPLACE FUNCTION dedalus_sdk_chat_completions.make_tool_choice_auto(
  type TEXT, disable_parallel_tool_use BOOLEAN DEFAULT NULL
)
RETURNS dedalus_sdk_chat_completions.tool_choice_auto
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    type, disable_parallel_tool_use
  )::dedalus_sdk_chat_completions.tool_choice_auto;
$$;

ALTER TYPE dedalus_sdk_chat_completions.tool_choice_none
  ADD ATTRIBUTE type TEXT;

CREATE OR REPLACE FUNCTION dedalus_sdk_chat_completions.make_tool_choice_none(
  type TEXT
)
RETURNS dedalus_sdk_chat_completions.tool_choice_none
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(type)::dedalus_sdk_chat_completions.tool_choice_none;
$$;

ALTER TYPE dedalus_sdk_chat_completions.tool_choice_tool
  ADD ATTRIBUTE name TEXT,
  ADD ATTRIBUTE type TEXT,
  ADD ATTRIBUTE disable_parallel_tool_use BOOLEAN;

CREATE OR REPLACE FUNCTION dedalus_sdk_chat_completions.make_tool_choice_tool(
  name TEXT, type TEXT, disable_parallel_tool_use BOOLEAN DEFAULT NULL
)
RETURNS dedalus_sdk_chat_completions.tool_choice_tool
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    name, type, disable_parallel_tool_use
  )::dedalus_sdk_chat_completions.tool_choice_tool;
$$;

ALTER TYPE dedalus_sdk_chat_completions.create_params_message
  ADD ATTRIBUTE role TEXT,
  ADD ATTRIBUTE content JSONB,
  ADD ATTRIBUTE name TEXT,
  ADD ATTRIBUTE audio dedalus_sdk_chat_completions.audio,
  ADD ATTRIBUTE function_call dedalus_sdk_chat_completions.create_params_message_function_call,
  ADD ATTRIBUTE refusal TEXT,
  ADD ATTRIBUTE tool_calls dedalus_sdk_chat_completions.create_params_message_tool_call[],
  ADD ATTRIBUTE tool_call_id TEXT;

CREATE OR REPLACE FUNCTION dedalus_sdk_chat_completions.make_create_params_message(
  role TEXT,
  content JSONB DEFAULT NULL,
  name TEXT DEFAULT NULL,
  audio dedalus_sdk_chat_completions.audio DEFAULT NULL,
  function_call dedalus_sdk_chat_completions.create_params_message_function_call DEFAULT NULL,
  refusal TEXT DEFAULT NULL,
  tool_calls dedalus_sdk_chat_completions.create_params_message_tool_call[] DEFAULT NULL,
  tool_call_id TEXT DEFAULT NULL
)
RETURNS dedalus_sdk_chat_completions.create_params_message
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    role, content, name, audio, function_call, refusal, tool_calls, tool_call_id
  )::dedalus_sdk_chat_completions.create_params_message;
$$;

ALTER TYPE dedalus_sdk_chat_completions.create_params_message_function_call
  ADD ATTRIBUTE arguments TEXT, ADD ATTRIBUTE name TEXT;

CREATE OR REPLACE FUNCTION dedalus_sdk_chat_completions.make_create_params_message_function_call(
  arguments TEXT, name TEXT
)
RETURNS dedalus_sdk_chat_completions.create_params_message_function_call
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    arguments, name
  )::dedalus_sdk_chat_completions.create_params_message_function_call;
$$;

ALTER TYPE dedalus_sdk_chat_completions.create_params_message_tool_call
  ADD ATTRIBUTE id TEXT,
  ADD ATTRIBUTE type TEXT,
  ADD ATTRIBUTE function dedalus_sdk_chat_completions.create_params_message_tool_call_function,
  ADD ATTRIBUTE thought_signature TEXT,
  ADD ATTRIBUTE custom dedalus_sdk_chat_completions.create_params_message_tool_call_custom;

CREATE OR REPLACE FUNCTION dedalus_sdk_chat_completions.make_create_params_message_tool_call(
  id TEXT,
  type TEXT,
  function dedalus_sdk_chat_completions.create_params_message_tool_call_function DEFAULT NULL,
  thought_signature TEXT DEFAULT NULL,
  custom dedalus_sdk_chat_completions.create_params_message_tool_call_custom DEFAULT NULL
)
RETURNS dedalus_sdk_chat_completions.create_params_message_tool_call
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    id, type, function, thought_signature, custom
  )::dedalus_sdk_chat_completions.create_params_message_tool_call;
$$;

ALTER TYPE dedalus_sdk_chat_completions.create_params_message_tool_call_function
  ADD ATTRIBUTE arguments TEXT, ADD ATTRIBUTE name TEXT;

CREATE OR REPLACE FUNCTION dedalus_sdk_chat_completions.make_create_params_message_tool_call_function(
  arguments TEXT, name TEXT
)
RETURNS dedalus_sdk_chat_completions.create_params_message_tool_call_function
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    arguments, name
  )::dedalus_sdk_chat_completions.create_params_message_tool_call_function;
$$;

ALTER TYPE dedalus_sdk_chat_completions.create_params_message_tool_call_custom
  ADD ATTRIBUTE input TEXT, ADD ATTRIBUTE name TEXT;

CREATE OR REPLACE FUNCTION dedalus_sdk_chat_completions.make_create_params_message_tool_call_custom(
  input TEXT, name TEXT
)
RETURNS dedalus_sdk_chat_completions.create_params_message_tool_call_custom
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    input, name
  )::dedalus_sdk_chat_completions.create_params_message_tool_call_custom;
$$;

ALTER TYPE dedalus_sdk_chat_completions.create_params_response_format
  ADD ATTRIBUTE type TEXT,
  ADD ATTRIBUTE json_schema dedalus_sdk_chat_completions.create_params_response_format_json_schema;

CREATE OR REPLACE FUNCTION dedalus_sdk_chat_completions.make_create_params_response_format(
  type TEXT,
  json_schema dedalus_sdk_chat_completions.create_params_response_format_json_schema DEFAULT NULL
)
RETURNS dedalus_sdk_chat_completions.create_params_response_format
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    type, json_schema
  )::dedalus_sdk_chat_completions.create_params_response_format;
$$;

ALTER TYPE dedalus_sdk_chat_completions.create_params_response_format_json_schema
  ADD ATTRIBUTE name TEXT,
  ADD ATTRIBUTE description TEXT,
  ADD ATTRIBUTE schema JSONB,
  ADD ATTRIBUTE strict BOOLEAN;

CREATE OR REPLACE FUNCTION dedalus_sdk_chat_completions.make_create_params_response_format_json_schema(
  name TEXT,
  description TEXT DEFAULT NULL,
  schema JSONB DEFAULT NULL,
  strict BOOLEAN DEFAULT NULL
)
RETURNS dedalus_sdk_chat_completions.create_params_response_format_json_schema
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    name, description, schema, strict
  )::dedalus_sdk_chat_completions.create_params_response_format_json_schema;
$$;

ALTER TYPE dedalus_sdk_chat_completions.create_params_safety_setting
  ADD ATTRIBUTE category TEXT, ADD ATTRIBUTE threshold TEXT;

CREATE OR REPLACE FUNCTION dedalus_sdk_chat_completions.make_create_params_safety_setting(
  category TEXT, threshold TEXT
)
RETURNS dedalus_sdk_chat_completions.create_params_safety_setting
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    category, threshold
  )::dedalus_sdk_chat_completions.create_params_safety_setting;
$$;

ALTER TYPE dedalus_sdk_chat_completions.create_params_thinking
  ADD ATTRIBUTE type TEXT, ADD ATTRIBUTE budget_tokens BIGINT;

CREATE OR REPLACE FUNCTION dedalus_sdk_chat_completions.make_create_params_thinking(
  type TEXT, budget_tokens BIGINT DEFAULT NULL
)
RETURNS dedalus_sdk_chat_completions.create_params_thinking
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    type, budget_tokens
  )::dedalus_sdk_chat_completions.create_params_thinking;
$$;

CREATE OR REPLACE FUNCTION dedalus_sdk_chat_completions._create(
  model JSONB,
  agent_attributes JSONB DEFAULT NULL,
  audio dedalus_sdk_chat_completions.chat_completion_audio_param DEFAULT NULL,
  automatic_tool_execution BOOLEAN DEFAULT NULL,
  cached_content TEXT DEFAULT NULL,
  correlation_id TEXT DEFAULT NULL,
  credentials JSONB DEFAULT NULL,
  deferred BOOLEAN DEFAULT NULL,
  deferred_calls dedalus_sdk_chat_completions.deferred_call_response[] DEFAULT NULL,
  frequency_penalty DOUBLE PRECISION DEFAULT NULL,
  function_call TEXT DEFAULT NULL,
  functions dedalus_sdk_chat_completions.chat_completion_functions[] DEFAULT NULL,
  generation_config JSONB DEFAULT NULL,
  guardrails JSONB[] DEFAULT NULL,
  handoff_config JSONB DEFAULT NULL,
  handoff_mode BOOLEAN DEFAULT NULL,
  inference_geo TEXT DEFAULT NULL,
  logit_bias JSONB DEFAULT NULL,
  logprobs BOOLEAN DEFAULT NULL,
  max_completion_tokens BIGINT DEFAULT NULL,
  max_tokens BIGINT DEFAULT NULL,
  max_turns BIGINT DEFAULT NULL,
  mcp_servers JSONB DEFAULT NULL,
  messages dedalus_sdk_chat_completions.create_params_message[] DEFAULT NULL,
  metadata JSONB DEFAULT NULL,
  modalities TEXT[] DEFAULT NULL,
  model_attributes JSONB DEFAULT NULL,
  n BIGINT DEFAULT NULL,
  output_config JSONB DEFAULT NULL,
  parallel_tool_calls BOOLEAN DEFAULT NULL,
  prediction dedalus_sdk_chat_completions.prediction_content DEFAULT NULL,
  presence_penalty DOUBLE PRECISION DEFAULT NULL,
  prompt_cache_key TEXT DEFAULT NULL,
  prompt_cache_retention TEXT DEFAULT NULL,
  prompt_mode TEXT DEFAULT NULL,
  reasoning_effort TEXT DEFAULT NULL,
  response_format dedalus_sdk_chat_completions.create_params_response_format DEFAULT NULL,
  safe_prompt BOOLEAN DEFAULT NULL,
  safety_identifier TEXT DEFAULT NULL,
  safety_settings dedalus_sdk_chat_completions.create_params_safety_setting[] DEFAULT NULL,
  search_parameters JSONB DEFAULT NULL,
  seed BIGINT DEFAULT NULL,
  service_tier TEXT DEFAULT NULL,
  speed TEXT DEFAULT NULL,
  stop JSONB DEFAULT NULL,
  store BOOLEAN DEFAULT NULL,
  stream BOOLEAN DEFAULT NULL,
  stream_options JSONB DEFAULT NULL,
  system_instruction JSONB DEFAULT NULL,
  temperature DOUBLE PRECISION DEFAULT NULL,
  thinking dedalus_sdk_chat_completions.create_params_thinking DEFAULT NULL,
  tool_choice JSONB DEFAULT NULL,
  tool_config JSONB DEFAULT NULL,
  tools dedalus_sdk_chat_completions.chat_completion_tool_param[] DEFAULT NULL,
  top_k BIGINT DEFAULT NULL,
  top_logprobs BIGINT DEFAULT NULL,
  top_p DOUBLE PRECISION DEFAULT NULL,
  "user" TEXT DEFAULT NULL,
  verbosity TEXT DEFAULT NULL,
  web_search_options JSONB DEFAULT NULL
)
RETURNS JSONB
LANGUAGE plpython3u
AS $$
  import json
  from dedalus_labs._types import not_given

  response = GD["__dedalus_sdk_context__"].client.chat.completions.with_raw_response.create(
      model=json.loads(model),
      agent_attributes=not_given if agent_attributes is None else json.loads(agent_attributes),
      audio=not_given if audio is None else GD["__dedalus_sdk_context__"].strip_none(audio),
      automatic_tool_execution=not_given if automatic_tool_execution is None else automatic_tool_execution,
      cached_content=not_given if cached_content is None else cached_content,
      correlation_id=not_given if correlation_id is None else correlation_id,
      credentials=not_given if credentials is None else json.loads(credentials),
      deferred=not_given if deferred is None else deferred,
      deferred_calls=not_given if deferred_calls is None else GD["__dedalus_sdk_context__"].strip_none(deferred_calls),
      frequency_penalty=not_given if frequency_penalty is None else frequency_penalty,
      function_call=not_given if function_call is None else function_call,
      functions=not_given if functions is None else GD["__dedalus_sdk_context__"].strip_none(functions),
      generation_config=not_given if generation_config is None else json.loads(generation_config),
      guardrails=not_given if guardrails is None else guardrails,
      handoff_config=not_given if handoff_config is None else json.loads(handoff_config),
      handoff_mode=not_given if handoff_mode is None else handoff_mode,
      inference_geo=not_given if inference_geo is None else inference_geo,
      logit_bias=not_given if logit_bias is None else json.loads(logit_bias),
      logprobs=not_given if logprobs is None else logprobs,
      max_completion_tokens=not_given if max_completion_tokens is None else max_completion_tokens,
      max_tokens=not_given if max_tokens is None else max_tokens,
      max_turns=not_given if max_turns is None else max_turns,
      mcp_servers=not_given if mcp_servers is None else json.loads(mcp_servers),
      messages=not_given if messages is None else GD["__dedalus_sdk_context__"].strip_none(messages),
      metadata=not_given if metadata is None else json.loads(metadata),
      modalities=not_given if modalities is None else modalities,
      model_attributes=not_given if model_attributes is None else json.loads(model_attributes),
      n=not_given if n is None else n,
      output_config=not_given if output_config is None else json.loads(output_config),
      parallel_tool_calls=not_given if parallel_tool_calls is None else parallel_tool_calls,
      prediction=not_given if prediction is None else GD["__dedalus_sdk_context__"].strip_none(prediction),
      presence_penalty=not_given if presence_penalty is None else presence_penalty,
      prompt_cache_key=not_given if prompt_cache_key is None else prompt_cache_key,
      prompt_cache_retention=not_given if prompt_cache_retention is None else prompt_cache_retention,
      prompt_mode=not_given if prompt_mode is None else prompt_mode,
      reasoning_effort=not_given if reasoning_effort is None else reasoning_effort,
      response_format=not_given if response_format is None else GD["__dedalus_sdk_context__"].strip_none(response_format),
      safe_prompt=not_given if safe_prompt is None else safe_prompt,
      safety_identifier=not_given if safety_identifier is None else safety_identifier,
      safety_settings=not_given if safety_settings is None else GD["__dedalus_sdk_context__"].strip_none(safety_settings),
      search_parameters=not_given if search_parameters is None else json.loads(search_parameters),
      seed=not_given if seed is None else seed,
      service_tier=not_given if service_tier is None else service_tier,
      speed=not_given if speed is None else speed,
      stop=not_given if stop is None else json.loads(stop),
      store=not_given if store is None else store,
      stream=not_given if stream is None else stream,
      stream_options=not_given if stream_options is None else json.loads(stream_options),
      system_instruction=not_given if system_instruction is None else json.loads(system_instruction),
      temperature=not_given if temperature is None else temperature,
      thinking=not_given if thinking is None else GD["__dedalus_sdk_context__"].strip_none(thinking),
      tool_choice=not_given if tool_choice is None else json.loads(tool_choice),
      tool_config=not_given if tool_config is None else json.loads(tool_config),
      tools=not_given if tools is None else GD["__dedalus_sdk_context__"].strip_none(tools),
      top_k=not_given if top_k is None else top_k,
      top_logprobs=not_given if top_logprobs is None else top_logprobs,
      top_p=not_given if top_p is None else top_p,
      user=not_given if user is None else user,
      verbosity=not_given if verbosity is None else verbosity,
      web_search_options=not_given if web_search_options is None else json.loads(web_search_options),
  )

  # We don't parse the JSON and let PL/Python perform data mapping because PL/Python errors for omitted
  # fields instead of defaulting them to NULL, but we want to be more lenient, which we handle in the
  # caller later.
  return response.text()
$$;

CREATE OR REPLACE FUNCTION dedalus_sdk_chat_completions.create(
  model JSONB,
  agent_attributes JSONB DEFAULT NULL,
  audio dedalus_sdk_chat_completions.chat_completion_audio_param DEFAULT NULL,
  automatic_tool_execution BOOLEAN DEFAULT NULL,
  cached_content TEXT DEFAULT NULL,
  correlation_id TEXT DEFAULT NULL,
  credentials JSONB DEFAULT NULL,
  deferred BOOLEAN DEFAULT NULL,
  deferred_calls dedalus_sdk_chat_completions.deferred_call_response[] DEFAULT NULL,
  frequency_penalty DOUBLE PRECISION DEFAULT NULL,
  function_call TEXT DEFAULT NULL,
  functions dedalus_sdk_chat_completions.chat_completion_functions[] DEFAULT NULL,
  generation_config JSONB DEFAULT NULL,
  guardrails JSONB[] DEFAULT NULL,
  handoff_config JSONB DEFAULT NULL,
  handoff_mode BOOLEAN DEFAULT NULL,
  inference_geo TEXT DEFAULT NULL,
  logit_bias JSONB DEFAULT NULL,
  logprobs BOOLEAN DEFAULT NULL,
  max_completion_tokens BIGINT DEFAULT NULL,
  max_tokens BIGINT DEFAULT NULL,
  max_turns BIGINT DEFAULT NULL,
  mcp_servers JSONB DEFAULT NULL,
  messages dedalus_sdk_chat_completions.create_params_message[] DEFAULT NULL,
  metadata JSONB DEFAULT NULL,
  modalities TEXT[] DEFAULT NULL,
  model_attributes JSONB DEFAULT NULL,
  n BIGINT DEFAULT NULL,
  output_config JSONB DEFAULT NULL,
  parallel_tool_calls BOOLEAN DEFAULT NULL,
  prediction dedalus_sdk_chat_completions.prediction_content DEFAULT NULL,
  presence_penalty DOUBLE PRECISION DEFAULT NULL,
  prompt_cache_key TEXT DEFAULT NULL,
  prompt_cache_retention TEXT DEFAULT NULL,
  prompt_mode TEXT DEFAULT NULL,
  reasoning_effort TEXT DEFAULT NULL,
  response_format dedalus_sdk_chat_completions.create_params_response_format DEFAULT NULL,
  safe_prompt BOOLEAN DEFAULT NULL,
  safety_identifier TEXT DEFAULT NULL,
  safety_settings dedalus_sdk_chat_completions.create_params_safety_setting[] DEFAULT NULL,
  search_parameters JSONB DEFAULT NULL,
  seed BIGINT DEFAULT NULL,
  service_tier TEXT DEFAULT NULL,
  speed TEXT DEFAULT NULL,
  stop JSONB DEFAULT NULL,
  store BOOLEAN DEFAULT NULL,
  stream BOOLEAN DEFAULT NULL,
  stream_options JSONB DEFAULT NULL,
  system_instruction JSONB DEFAULT NULL,
  temperature DOUBLE PRECISION DEFAULT NULL,
  thinking dedalus_sdk_chat_completions.create_params_thinking DEFAULT NULL,
  tool_choice JSONB DEFAULT NULL,
  tool_config JSONB DEFAULT NULL,
  tools dedalus_sdk_chat_completions.chat_completion_tool_param[] DEFAULT NULL,
  top_k BIGINT DEFAULT NULL,
  top_logprobs BIGINT DEFAULT NULL,
  top_p DOUBLE PRECISION DEFAULT NULL,
  "user" TEXT DEFAULT NULL,
  verbosity TEXT DEFAULT NULL,
  web_search_options JSONB DEFAULT NULL
)
RETURNS dedalus_sdk_chat_completions.chat_completion
LANGUAGE plpgsql
AS $$
  BEGIN
    PERFORM dedalus_sdk_internal.ensure_context();
    RETURN jsonb_populate_record(
      NULL::dedalus_sdk_chat_completions.chat_completion,
      dedalus_sdk_chat_completions._create(
        model,
        agent_attributes,
        audio,
        automatic_tool_execution,
        cached_content,
        correlation_id,
        credentials,
        deferred,
        deferred_calls,
        frequency_penalty,
        function_call,
        functions,
        generation_config,
        guardrails,
        handoff_config,
        handoff_mode,
        inference_geo,
        logit_bias,
        logprobs,
        max_completion_tokens,
        max_tokens,
        max_turns,
        mcp_servers,
        messages,
        metadata,
        modalities,
        model_attributes,
        n,
        output_config,
        parallel_tool_calls,
        prediction,
        presence_penalty,
        prompt_cache_key,
        prompt_cache_retention,
        prompt_mode,
        reasoning_effort,
        response_format,
        safe_prompt,
        safety_identifier,
        safety_settings,
        search_parameters,
        seed,
        service_tier,
        speed,
        stop,
        store,
        stream,
        stream_options,
        system_instruction,
        temperature,
        thinking,
        tool_choice,
        tool_config,
        tools,
        top_k,
        top_logprobs,
        top_p,
        "user",
        verbosity,
        web_search_options
      )
    );
  END;
$$;