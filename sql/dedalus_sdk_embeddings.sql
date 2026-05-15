ALTER TYPE dedalus_sdk_embeddings.create_embedding_request
  ADD ATTRIBUTE input JSONB,
  ADD ATTRIBUTE model TEXT,
  ADD ATTRIBUTE dimensions BIGINT,
  ADD ATTRIBUTE encoding_format TEXT,
  ADD ATTRIBUTE "user" TEXT;

CREATE OR REPLACE FUNCTION dedalus_sdk_embeddings.make_create_embedding_request(
  input JSONB,
  model TEXT,
  dimensions BIGINT DEFAULT NULL,
  encoding_format TEXT DEFAULT NULL,
  "user" TEXT DEFAULT NULL
)
RETURNS dedalus_sdk_embeddings.create_embedding_request
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    input, model, dimensions, encoding_format, "user"
  )::dedalus_sdk_embeddings.create_embedding_request;
$$;

ALTER TYPE dedalus_sdk_embeddings.create_embedding_response
  ADD ATTRIBUTE data dedalus_sdk_embeddings.create_embedding_response_data[],
  ADD ATTRIBUTE model TEXT,
  ADD ATTRIBUTE object TEXT,
  ADD ATTRIBUTE usage dedalus_sdk_embeddings.create_embedding_response_usage;

CREATE OR REPLACE FUNCTION dedalus_sdk_embeddings.make_create_embedding_response(
  data dedalus_sdk_embeddings.create_embedding_response_data[],
  model TEXT,
  object TEXT,
  usage dedalus_sdk_embeddings.create_embedding_response_usage
)
RETURNS dedalus_sdk_embeddings.create_embedding_response
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    data, model, object, usage
  )::dedalus_sdk_embeddings.create_embedding_response;
$$;

ALTER TYPE dedalus_sdk_embeddings.create_embedding_response_data
  ADD ATTRIBUTE embedding DOUBLE PRECISION[],
  ADD ATTRIBUTE index BIGINT,
  ADD ATTRIBUTE object TEXT;

CREATE OR REPLACE FUNCTION dedalus_sdk_embeddings.make_create_embedding_response_data(
  embedding DOUBLE PRECISION[], index BIGINT, object TEXT
)
RETURNS dedalus_sdk_embeddings.create_embedding_response_data
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    embedding, index, object
  )::dedalus_sdk_embeddings.create_embedding_response_data;
$$;

ALTER TYPE dedalus_sdk_embeddings.create_embedding_response_usage
  ADD ATTRIBUTE prompt_tokens BIGINT, ADD ATTRIBUTE total_tokens BIGINT;

CREATE OR REPLACE FUNCTION dedalus_sdk_embeddings.make_create_embedding_response_usage(
  prompt_tokens BIGINT, total_tokens BIGINT
)
RETURNS dedalus_sdk_embeddings.create_embedding_response_usage
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    prompt_tokens, total_tokens
  )::dedalus_sdk_embeddings.create_embedding_response_usage;
$$;

CREATE OR REPLACE FUNCTION dedalus_sdk_embeddings._create(
  input JSONB,
  model TEXT,
  dimensions BIGINT DEFAULT NULL,
  encoding_format TEXT DEFAULT NULL,
  "user" TEXT DEFAULT NULL
)
RETURNS JSONB
LANGUAGE plpython3u
AS $$
  import json
  from dedalus_labs._types import not_given

  response = GD["__dedalus_sdk_context__"].client.embeddings.with_raw_response.create(
      input=json.loads(input),
      model=model,
      dimensions=not_given if dimensions is None else dimensions,
      encoding_format=not_given if encoding_format is None else encoding_format,
      user=not_given if user is None else user,
  )

  # We don't parse the JSON and let PL/Python perform data mapping because PL/Python errors for omitted
  # fields instead of defaulting them to NULL, but we want to be more lenient, which we handle in the
  # caller later.
  return response.text()
$$;

CREATE OR REPLACE FUNCTION dedalus_sdk_embeddings.create(
  input JSONB,
  model TEXT,
  dimensions BIGINT DEFAULT NULL,
  encoding_format TEXT DEFAULT NULL,
  "user" TEXT DEFAULT NULL
)
RETURNS dedalus_sdk_embeddings.create_embedding_response
LANGUAGE plpgsql
AS $$
  BEGIN
    PERFORM dedalus_sdk_internal.ensure_context();
    RETURN jsonb_populate_record(
      NULL::dedalus_sdk_embeddings.create_embedding_response,
      dedalus_sdk_embeddings._create(
        input, model, dimensions, encoding_format, "user"
      )
    );
  END;
$$;