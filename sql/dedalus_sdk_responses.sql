ALTER TYPE dedalus_sdk_responses.response
  ADD ATTRIBUTE id TEXT,
  ADD ATTRIBUTE created_at DOUBLE PRECISION,
  ADD ATTRIBUTE model TEXT,
  ADD ATTRIBUTE output JSONB[],
  ADD ATTRIBUTE status TEXT,
  ADD ATTRIBUTE background BOOLEAN,
  ADD ATTRIBUTE completed_at DOUBLE PRECISION,
  ADD ATTRIBUTE conversation JSONB,
  ADD ATTRIBUTE error JSONB,
  ADD ATTRIBUTE frequency_penalty DOUBLE PRECISION,
  ADD ATTRIBUTE incomplete_details JSONB,
  ADD ATTRIBUTE instructions JSONB,
  ADD ATTRIBUTE max_output_tokens BIGINT,
  ADD ATTRIBUTE max_tool_calls BIGINT,
  ADD ATTRIBUTE mcp_server_errors JSONB,
  ADD ATTRIBUTE mcp_tool_results dedalus_sdk.mcp_tool_result[],
  ADD ATTRIBUTE metadata JSONB,
  ADD ATTRIBUTE object TEXT,
  ADD ATTRIBUTE output_text TEXT,
  ADD ATTRIBUTE parallel_tool_calls BOOLEAN,
  ADD ATTRIBUTE presence_penalty DOUBLE PRECISION,
  ADD ATTRIBUTE previous_response_id TEXT,
  ADD ATTRIBUTE prompt_cache_key TEXT,
  ADD ATTRIBUTE reasoning JSONB,
  ADD ATTRIBUTE safety_identifier TEXT,
  ADD ATTRIBUTE service_tier TEXT,
  ADD ATTRIBUTE store BOOLEAN,
  ADD ATTRIBUTE temperature DOUBLE PRECISION,
  ADD ATTRIBUTE text JSONB,
  ADD ATTRIBUTE tool_choice JSONB,
  ADD ATTRIBUTE tools JSONB[],
  ADD ATTRIBUTE tools_executed TEXT[],
  ADD ATTRIBUTE top_logprobs BIGINT,
  ADD ATTRIBUTE top_p DOUBLE PRECISION,
  ADD ATTRIBUTE truncation TEXT,
  ADD ATTRIBUTE usage JSONB;

CREATE OR REPLACE FUNCTION dedalus_sdk_responses.make_response(
  id TEXT,
  created_at DOUBLE PRECISION,
  model TEXT,
  output JSONB[],
  status TEXT,
  background BOOLEAN DEFAULT NULL,
  completed_at DOUBLE PRECISION DEFAULT NULL,
  conversation JSONB DEFAULT NULL,
  error JSONB DEFAULT NULL,
  frequency_penalty DOUBLE PRECISION DEFAULT NULL,
  incomplete_details JSONB DEFAULT NULL,
  instructions JSONB DEFAULT NULL,
  max_output_tokens BIGINT DEFAULT NULL,
  max_tool_calls BIGINT DEFAULT NULL,
  mcp_server_errors JSONB DEFAULT NULL,
  mcp_tool_results dedalus_sdk.mcp_tool_result[] DEFAULT NULL,
  metadata JSONB DEFAULT NULL,
  object TEXT DEFAULT NULL,
  output_text TEXT DEFAULT NULL,
  parallel_tool_calls BOOLEAN DEFAULT NULL,
  presence_penalty DOUBLE PRECISION DEFAULT NULL,
  previous_response_id TEXT DEFAULT NULL,
  prompt_cache_key TEXT DEFAULT NULL,
  reasoning JSONB DEFAULT NULL,
  safety_identifier TEXT DEFAULT NULL,
  service_tier TEXT DEFAULT NULL,
  store BOOLEAN DEFAULT NULL,
  temperature DOUBLE PRECISION DEFAULT NULL,
  text JSONB DEFAULT NULL,
  tool_choice JSONB DEFAULT NULL,
  tools JSONB[] DEFAULT NULL,
  tools_executed TEXT[] DEFAULT NULL,
  top_logprobs BIGINT DEFAULT NULL,
  top_p DOUBLE PRECISION DEFAULT NULL,
  truncation TEXT DEFAULT NULL,
  usage JSONB DEFAULT NULL
)
RETURNS dedalus_sdk_responses.response
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    id,
    created_at,
    model,
    output,
    status,
    background,
    completed_at,
    conversation,
    error,
    frequency_penalty,
    incomplete_details,
    instructions,
    max_output_tokens,
    max_tool_calls,
    mcp_server_errors,
    mcp_tool_results,
    metadata,
    object,
    output_text,
    parallel_tool_calls,
    presence_penalty,
    previous_response_id,
    prompt_cache_key,
    reasoning,
    safety_identifier,
    service_tier,
    store,
    temperature,
    text,
    tool_choice,
    tools,
    tools_executed,
    top_logprobs,
    top_p,
    truncation,
    usage
  )::dedalus_sdk_responses.response;
$$;

ALTER TYPE dedalus_sdk_responses.response_create_params
  ADD ATTRIBUTE background BOOLEAN,
  ADD ATTRIBUTE conversation JSONB,
  ADD ATTRIBUTE credentials JSONB,
  ADD ATTRIBUTE frequency_penalty DOUBLE PRECISION,
  ADD ATTRIBUTE include TEXT[],
  ADD ATTRIBUTE input JSONB,
  ADD ATTRIBUTE instructions JSONB,
  ADD ATTRIBUTE max_output_tokens BIGINT,
  ADD ATTRIBUTE max_tool_calls BIGINT,
  ADD ATTRIBUTE mcp_servers JSONB,
  ADD ATTRIBUTE metadata JSONB,
  ADD ATTRIBUTE model JSONB,
  ADD ATTRIBUTE parallel_tool_calls BOOLEAN,
  ADD ATTRIBUTE presence_penalty DOUBLE PRECISION,
  ADD ATTRIBUTE previous_response_id TEXT,
  ADD ATTRIBUTE prompt dedalus_sdk_responses.response_create_params_prompt,
  ADD ATTRIBUTE prompt_cache_key TEXT,
  ADD ATTRIBUTE reasoning JSONB,
  ADD ATTRIBUTE safety_identifier TEXT,
  ADD ATTRIBUTE service_tier TEXT,
  ADD ATTRIBUTE store BOOLEAN,
  ADD ATTRIBUTE stream BOOLEAN,
  ADD ATTRIBUTE stream_options JSONB,
  ADD ATTRIBUTE temperature DOUBLE PRECISION,
  ADD ATTRIBUTE text JSONB,
  ADD ATTRIBUTE tool_choice JSONB,
  ADD ATTRIBUTE tools JSONB[],
  ADD ATTRIBUTE top_logprobs BIGINT,
  ADD ATTRIBUTE top_p DOUBLE PRECISION,
  ADD ATTRIBUTE truncation TEXT,
  ADD ATTRIBUTE "user" TEXT;

CREATE OR REPLACE FUNCTION dedalus_sdk_responses.make_response_create_params(
  background BOOLEAN DEFAULT NULL,
  conversation JSONB DEFAULT NULL,
  credentials JSONB DEFAULT NULL,
  frequency_penalty DOUBLE PRECISION DEFAULT NULL,
  include TEXT[] DEFAULT NULL,
  input JSONB DEFAULT NULL,
  instructions JSONB DEFAULT NULL,
  max_output_tokens BIGINT DEFAULT NULL,
  max_tool_calls BIGINT DEFAULT NULL,
  mcp_servers JSONB DEFAULT NULL,
  metadata JSONB DEFAULT NULL,
  model JSONB DEFAULT NULL,
  parallel_tool_calls BOOLEAN DEFAULT NULL,
  presence_penalty DOUBLE PRECISION DEFAULT NULL,
  previous_response_id TEXT DEFAULT NULL,
  prompt dedalus_sdk_responses.response_create_params_prompt DEFAULT NULL,
  prompt_cache_key TEXT DEFAULT NULL,
  reasoning JSONB DEFAULT NULL,
  safety_identifier TEXT DEFAULT NULL,
  service_tier TEXT DEFAULT NULL,
  store BOOLEAN DEFAULT NULL,
  stream BOOLEAN DEFAULT NULL,
  stream_options JSONB DEFAULT NULL,
  temperature DOUBLE PRECISION DEFAULT NULL,
  text JSONB DEFAULT NULL,
  tool_choice JSONB DEFAULT NULL,
  tools JSONB[] DEFAULT NULL,
  top_logprobs BIGINT DEFAULT NULL,
  top_p DOUBLE PRECISION DEFAULT NULL,
  truncation TEXT DEFAULT NULL,
  "user" TEXT DEFAULT NULL
)
RETURNS dedalus_sdk_responses.response_create_params
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    background,
    conversation,
    credentials,
    frequency_penalty,
    include,
    input,
    instructions,
    max_output_tokens,
    max_tool_calls,
    mcp_servers,
    metadata,
    model,
    parallel_tool_calls,
    presence_penalty,
    previous_response_id,
    prompt,
    prompt_cache_key,
    reasoning,
    safety_identifier,
    service_tier,
    store,
    stream,
    stream_options,
    temperature,
    text,
    tool_choice,
    tools,
    top_logprobs,
    top_p,
    truncation,
    "user"
  )::dedalus_sdk_responses.response_create_params;
$$;

ALTER TYPE dedalus_sdk_responses.response_create_params_prompt
  ADD ATTRIBUTE id TEXT,
  ADD ATTRIBUTE variables JSONB,
  ADD ATTRIBUTE version TEXT;

CREATE OR REPLACE FUNCTION dedalus_sdk_responses.make_response_create_params_prompt(
  id TEXT, variables JSONB DEFAULT NULL, version TEXT DEFAULT NULL
)
RETURNS dedalus_sdk_responses.response_create_params_prompt
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    id, variables, version
  )::dedalus_sdk_responses.response_create_params_prompt;
$$;

ALTER TYPE dedalus_sdk_responses.create_params_prompt
  ADD ATTRIBUTE id TEXT,
  ADD ATTRIBUTE variables JSONB,
  ADD ATTRIBUTE version TEXT;

CREATE OR REPLACE FUNCTION dedalus_sdk_responses.make_create_params_prompt(
  id TEXT, variables JSONB DEFAULT NULL, version TEXT DEFAULT NULL
)
RETURNS dedalus_sdk_responses.create_params_prompt
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    id, variables, version
  )::dedalus_sdk_responses.create_params_prompt;
$$;

CREATE OR REPLACE FUNCTION dedalus_sdk_responses._create(
  background BOOLEAN DEFAULT NULL,
  conversation JSONB DEFAULT NULL,
  credentials JSONB DEFAULT NULL,
  frequency_penalty DOUBLE PRECISION DEFAULT NULL,
  include TEXT[] DEFAULT NULL,
  input JSONB DEFAULT NULL,
  instructions JSONB DEFAULT NULL,
  max_output_tokens BIGINT DEFAULT NULL,
  max_tool_calls BIGINT DEFAULT NULL,
  mcp_servers JSONB DEFAULT NULL,
  metadata JSONB DEFAULT NULL,
  model JSONB DEFAULT NULL,
  parallel_tool_calls BOOLEAN DEFAULT NULL,
  presence_penalty DOUBLE PRECISION DEFAULT NULL,
  previous_response_id TEXT DEFAULT NULL,
  prompt dedalus_sdk_responses.create_params_prompt DEFAULT NULL,
  prompt_cache_key TEXT DEFAULT NULL,
  reasoning JSONB DEFAULT NULL,
  safety_identifier TEXT DEFAULT NULL,
  service_tier TEXT DEFAULT NULL,
  store BOOLEAN DEFAULT NULL,
  stream BOOLEAN DEFAULT NULL,
  stream_options JSONB DEFAULT NULL,
  temperature DOUBLE PRECISION DEFAULT NULL,
  text JSONB DEFAULT NULL,
  tool_choice JSONB DEFAULT NULL,
  tools JSONB[] DEFAULT NULL,
  top_logprobs BIGINT DEFAULT NULL,
  top_p DOUBLE PRECISION DEFAULT NULL,
  truncation TEXT DEFAULT NULL,
  "user" TEXT DEFAULT NULL
)
RETURNS JSONB
LANGUAGE plpython3u
AS $$
  import json
  from dedalus_labs._types import not_given

  response = GD["__dedalus_sdk_context__"].client.responses.with_raw_response.create(
      background=not_given if background is None else background,
      conversation=not_given if conversation is None else json.loads(conversation),
      credentials=not_given if credentials is None else json.loads(credentials),
      frequency_penalty=not_given if frequency_penalty is None else frequency_penalty,
      include=not_given if include is None else include,
      input=not_given if input is None else json.loads(input),
      instructions=not_given if instructions is None else json.loads(instructions),
      max_output_tokens=not_given if max_output_tokens is None else max_output_tokens,
      max_tool_calls=not_given if max_tool_calls is None else max_tool_calls,
      mcp_servers=not_given if mcp_servers is None else json.loads(mcp_servers),
      metadata=not_given if metadata is None else json.loads(metadata),
      model=not_given if model is None else json.loads(model),
      parallel_tool_calls=not_given if parallel_tool_calls is None else parallel_tool_calls,
      presence_penalty=not_given if presence_penalty is None else presence_penalty,
      previous_response_id=not_given if previous_response_id is None else previous_response_id,
      prompt=not_given if prompt is None else GD["__dedalus_sdk_context__"].strip_none(prompt),
      prompt_cache_key=not_given if prompt_cache_key is None else prompt_cache_key,
      reasoning=not_given if reasoning is None else json.loads(reasoning),
      safety_identifier=not_given if safety_identifier is None else safety_identifier,
      service_tier=not_given if service_tier is None else service_tier,
      store=not_given if store is None else store,
      stream=not_given if stream is None else stream,
      stream_options=not_given if stream_options is None else json.loads(stream_options),
      temperature=not_given if temperature is None else temperature,
      text=not_given if text is None else json.loads(text),
      tool_choice=not_given if tool_choice is None else json.loads(tool_choice),
      tools=not_given if tools is None else tools,
      top_logprobs=not_given if top_logprobs is None else top_logprobs,
      top_p=not_given if top_p is None else top_p,
      truncation=not_given if truncation is None else truncation,
      user=not_given if user is None else user,
  )

  # We don't parse the JSON and let PL/Python perform data mapping because PL/Python errors for omitted
  # fields instead of defaulting them to NULL, but we want to be more lenient, which we handle in the
  # caller later.
  return response.text()
$$;

CREATE OR REPLACE FUNCTION dedalus_sdk_responses.create(
  background BOOLEAN DEFAULT NULL,
  conversation JSONB DEFAULT NULL,
  credentials JSONB DEFAULT NULL,
  frequency_penalty DOUBLE PRECISION DEFAULT NULL,
  include TEXT[] DEFAULT NULL,
  input JSONB DEFAULT NULL,
  instructions JSONB DEFAULT NULL,
  max_output_tokens BIGINT DEFAULT NULL,
  max_tool_calls BIGINT DEFAULT NULL,
  mcp_servers JSONB DEFAULT NULL,
  metadata JSONB DEFAULT NULL,
  model JSONB DEFAULT NULL,
  parallel_tool_calls BOOLEAN DEFAULT NULL,
  presence_penalty DOUBLE PRECISION DEFAULT NULL,
  previous_response_id TEXT DEFAULT NULL,
  prompt dedalus_sdk_responses.create_params_prompt DEFAULT NULL,
  prompt_cache_key TEXT DEFAULT NULL,
  reasoning JSONB DEFAULT NULL,
  safety_identifier TEXT DEFAULT NULL,
  service_tier TEXT DEFAULT NULL,
  store BOOLEAN DEFAULT NULL,
  stream BOOLEAN DEFAULT NULL,
  stream_options JSONB DEFAULT NULL,
  temperature DOUBLE PRECISION DEFAULT NULL,
  text JSONB DEFAULT NULL,
  tool_choice JSONB DEFAULT NULL,
  tools JSONB[] DEFAULT NULL,
  top_logprobs BIGINT DEFAULT NULL,
  top_p DOUBLE PRECISION DEFAULT NULL,
  truncation TEXT DEFAULT NULL,
  "user" TEXT DEFAULT NULL
)
RETURNS dedalus_sdk_responses.response
LANGUAGE plpgsql
AS $$
  BEGIN
    PERFORM dedalus_sdk_internal.ensure_context();
    RETURN jsonb_populate_record(
      NULL::dedalus_sdk_responses.response,
      dedalus_sdk_responses._create(
        background,
        conversation,
        credentials,
        frequency_penalty,
        include,
        input,
        instructions,
        max_output_tokens,
        max_tool_calls,
        mcp_servers,
        metadata,
        model,
        parallel_tool_calls,
        presence_penalty,
        previous_response_id,
        prompt,
        prompt_cache_key,
        reasoning,
        safety_identifier,
        service_tier,
        store,
        stream,
        stream_options,
        temperature,
        text,
        tool_choice,
        tools,
        top_logprobs,
        top_p,
        truncation,
        "user"
      )
    );
  END;
$$;