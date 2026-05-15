ALTER TYPE dedalus_sdk_models.list_models_response
  ADD ATTRIBUTE data dedalus_sdk_models.model[], ADD ATTRIBUTE object TEXT;

CREATE OR REPLACE FUNCTION dedalus_sdk_models.make_list_models_response(
  data dedalus_sdk_models.model[], object TEXT DEFAULT NULL
)
RETURNS dedalus_sdk_models.list_models_response
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(data, object)::dedalus_sdk_models.list_models_response;
$$;

ALTER TYPE dedalus_sdk_models.model
  ADD ATTRIBUTE id TEXT,
  ADD ATTRIBUTE created_at TIMESTAMP,
  ADD ATTRIBUTE provider TEXT,
  ADD ATTRIBUTE capabilities dedalus_sdk_models.model_capability,
  ADD ATTRIBUTE defaults dedalus_sdk_models.model_default,
  ADD ATTRIBUTE description TEXT,
  ADD ATTRIBUTE display_name TEXT,
  ADD ATTRIBUTE provider_declared_generation_methods TEXT[],
  ADD ATTRIBUTE provider_info JSONB,
  ADD ATTRIBUTE version TEXT;

CREATE OR REPLACE FUNCTION dedalus_sdk_models.make_model(
  id TEXT,
  created_at TIMESTAMP,
  provider TEXT,
  capabilities dedalus_sdk_models.model_capability DEFAULT NULL,
  defaults dedalus_sdk_models.model_default DEFAULT NULL,
  description TEXT DEFAULT NULL,
  display_name TEXT DEFAULT NULL,
  provider_declared_generation_methods TEXT[] DEFAULT NULL,
  provider_info JSONB DEFAULT NULL,
  version TEXT DEFAULT NULL
)
RETURNS dedalus_sdk_models.model
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    id,
    created_at,
    provider,
    capabilities,
    defaults,
    description,
    display_name,
    provider_declared_generation_methods,
    provider_info,
    version
  )::dedalus_sdk_models.model;
$$;

ALTER TYPE dedalus_sdk_models.model_capability
  ADD ATTRIBUTE audio BOOLEAN,
  ADD ATTRIBUTE image_generation BOOLEAN,
  ADD ATTRIBUTE input_token_limit BIGINT,
  ADD ATTRIBUTE output_token_limit BIGINT,
  ADD ATTRIBUTE streaming BOOLEAN,
  ADD ATTRIBUTE structured_output BOOLEAN,
  ADD ATTRIBUTE text BOOLEAN,
  ADD ATTRIBUTE thinking BOOLEAN,
  ADD ATTRIBUTE tools BOOLEAN,
  ADD ATTRIBUTE vision BOOLEAN;

CREATE OR REPLACE FUNCTION dedalus_sdk_models.make_model_capability(
  audio BOOLEAN DEFAULT NULL,
  image_generation BOOLEAN DEFAULT NULL,
  input_token_limit BIGINT DEFAULT NULL,
  output_token_limit BIGINT DEFAULT NULL,
  streaming BOOLEAN DEFAULT NULL,
  structured_output BOOLEAN DEFAULT NULL,
  text BOOLEAN DEFAULT NULL,
  thinking BOOLEAN DEFAULT NULL,
  tools BOOLEAN DEFAULT NULL,
  vision BOOLEAN DEFAULT NULL
)
RETURNS dedalus_sdk_models.model_capability
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    audio,
    image_generation,
    input_token_limit,
    output_token_limit,
    streaming,
    structured_output,
    text,
    thinking,
    tools,
    vision
  )::dedalus_sdk_models.model_capability;
$$;

ALTER TYPE dedalus_sdk_models.model_default
  ADD ATTRIBUTE max_output_tokens BIGINT,
  ADD ATTRIBUTE temperature DOUBLE PRECISION,
  ADD ATTRIBUTE top_k BIGINT,
  ADD ATTRIBUTE top_p DOUBLE PRECISION;

CREATE OR REPLACE FUNCTION dedalus_sdk_models.make_model_default(
  max_output_tokens BIGINT DEFAULT NULL,
  temperature DOUBLE PRECISION DEFAULT NULL,
  top_k BIGINT DEFAULT NULL,
  top_p DOUBLE PRECISION DEFAULT NULL
)
RETURNS dedalus_sdk_models.model_default
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    max_output_tokens, temperature, top_k, top_p
  )::dedalus_sdk_models.model_default;
$$;

CREATE OR REPLACE FUNCTION dedalus_sdk_models._retrieve(model_id TEXT)
RETURNS JSONB
LANGUAGE plpython3u
STABLE
AS $$
  response = GD["__dedalus_sdk_context__"].client.models.with_raw_response.retrieve(
      model_id=model_id,
  )

  # We don't parse the JSON and let PL/Python perform data mapping because PL/Python errors for omitted
  # fields instead of defaulting them to NULL, but we want to be more lenient, which we handle in the
  # caller later.
  return response.text()
$$;

CREATE OR REPLACE FUNCTION dedalus_sdk_models.retrieve(model_id TEXT)
RETURNS dedalus_sdk_models.model
LANGUAGE plpgsql
STABLE
AS $$
  BEGIN
    PERFORM dedalus_sdk_internal.ensure_context();
    RETURN jsonb_populate_record(
      NULL::dedalus_sdk_models.model, dedalus_sdk_models._retrieve(model_id)
    );
  END;
$$;

CREATE OR REPLACE FUNCTION dedalus_sdk_models._list()
RETURNS JSONB
LANGUAGE plpython3u
STABLE
AS $$
  response = GD["__dedalus_sdk_context__"].client.models.with_raw_response.list()

  # We don't parse the JSON and let PL/Python perform data mapping because PL/Python errors for omitted
  # fields instead of defaulting them to NULL, but we want to be more lenient, which we handle in the
  # caller later.
  return response.text()
$$;

CREATE OR REPLACE FUNCTION dedalus_sdk_models.list()
RETURNS dedalus_sdk_models.list_models_response
LANGUAGE plpgsql
STABLE
AS $$
  BEGIN
    PERFORM dedalus_sdk_internal.ensure_context();
    RETURN jsonb_populate_record(
      NULL::dedalus_sdk_models.list_models_response, dedalus_sdk_models._list()
    );
  END;
$$;