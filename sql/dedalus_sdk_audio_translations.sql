ALTER TYPE dedalus_sdk_audio_translations.translation_create_response
  ADD ATTRIBUTE text TEXT,
  ADD ATTRIBUTE duration DOUBLE PRECISION,
  ADD ATTRIBUTE language TEXT,
  ADD ATTRIBUTE segments dedalus_sdk_audio_translations.translation_create_response_segment[];

CREATE OR REPLACE FUNCTION dedalus_sdk_audio_translations.make_translation_create_response(
  text TEXT,
  duration DOUBLE PRECISION DEFAULT NULL,
  language TEXT DEFAULT NULL,
  segments dedalus_sdk_audio_translations.translation_create_response_segment[] DEFAULT NULL
)
RETURNS dedalus_sdk_audio_translations.translation_create_response
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    text, duration, language, segments
  )::dedalus_sdk_audio_translations.translation_create_response;
$$;

ALTER TYPE dedalus_sdk_audio_translations.translation_create_response_segment
  ADD ATTRIBUTE id BIGINT,
  ADD ATTRIBUTE avg_logprob DOUBLE PRECISION,
  ADD ATTRIBUTE compression_ratio DOUBLE PRECISION,
  ADD ATTRIBUTE "end" DOUBLE PRECISION,
  ADD ATTRIBUTE no_speech_prob DOUBLE PRECISION,
  ADD ATTRIBUTE seek BIGINT,
  ADD ATTRIBUTE start DOUBLE PRECISION,
  ADD ATTRIBUTE temperature DOUBLE PRECISION,
  ADD ATTRIBUTE text TEXT,
  ADD ATTRIBUTE tokens BIGINT[];

CREATE OR REPLACE FUNCTION dedalus_sdk_audio_translations.make_translation_create_response_segment(
  id BIGINT,
  avg_logprob DOUBLE PRECISION,
  compression_ratio DOUBLE PRECISION,
  "end" DOUBLE PRECISION,
  no_speech_prob DOUBLE PRECISION,
  seek BIGINT,
  start DOUBLE PRECISION,
  temperature DOUBLE PRECISION,
  text TEXT,
  tokens BIGINT[]
)
RETURNS dedalus_sdk_audio_translations.translation_create_response_segment
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    id,
    avg_logprob,
    compression_ratio,
    "end",
    no_speech_prob,
    seek,
    start,
    temperature,
    text,
    tokens
  )::dedalus_sdk_audio_translations.translation_create_response_segment;
$$;

CREATE OR REPLACE FUNCTION dedalus_sdk_audio_translations._create(
  file TEXT,
  model TEXT,
  prompt TEXT DEFAULT NULL,
  response_format TEXT DEFAULT NULL,
  temperature DOUBLE PRECISION DEFAULT NULL
)
RETURNS JSONB
LANGUAGE plpython3u
AS $$
  from dedalus_labs._types import not_given

  response = GD["__dedalus_sdk_context__"].client.audio.translations.with_raw_response.create(
      file=file,
      model=model,
      prompt=not_given if prompt is None else prompt,
      response_format=not_given if response_format is None else response_format,
      temperature=not_given if temperature is None else temperature,
  )

  # We don't parse the JSON and let PL/Python perform data mapping because PL/Python errors for omitted
  # fields instead of defaulting them to NULL, but we want to be more lenient, which we handle in the
  # caller later.
  return response.text()
$$;

CREATE OR REPLACE FUNCTION dedalus_sdk_audio_translations.create(
  file TEXT,
  model TEXT,
  prompt TEXT DEFAULT NULL,
  response_format TEXT DEFAULT NULL,
  temperature DOUBLE PRECISION DEFAULT NULL
)
RETURNS dedalus_sdk_audio_translations.translation_create_response
LANGUAGE plpgsql
AS $$
  BEGIN
    PERFORM dedalus_sdk_internal.ensure_context();
    RETURN jsonb_populate_record(
      NULL::dedalus_sdk_audio_translations.translation_create_response,
      dedalus_sdk_audio_translations._create(
        file, model, prompt, response_format, temperature
      )
    );
  END;
$$;