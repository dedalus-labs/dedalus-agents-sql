CREATE OR REPLACE FUNCTION dedalus_sdk_audio_speech._create(
  input TEXT,
  model TEXT,
  voice JSONB,
  instructions TEXT DEFAULT NULL,
  response_format TEXT DEFAULT NULL,
  speed DOUBLE PRECISION DEFAULT NULL,
  stream_format TEXT DEFAULT NULL
)
RETURNS JSONB
LANGUAGE plpython3u
AS $$
  import json
  from dedalus_labs._types import not_given

  response = GD["__dedalus_sdk_context__"].client.audio.speech.with_raw_response.create(
      input=input,
      model=model,
      voice=json.loads(voice),
      instructions=not_given if instructions is None else instructions,
      response_format=not_given if response_format is None else response_format,
      speed=not_given if speed is None else speed,
      stream_format=not_given if stream_format is None else stream_format,
  )

  # We don't parse the JSON and let PL/Python perform data mapping because PL/Python errors for omitted
  # fields instead of defaulting them to NULL, but we want to be more lenient, which we handle in the
  # caller later.
  return response.text()
$$;

CREATE OR REPLACE FUNCTION dedalus_sdk_audio_speech.create(
  input TEXT,
  model TEXT,
  voice JSONB,
  instructions TEXT DEFAULT NULL,
  response_format TEXT DEFAULT NULL,
  speed DOUBLE PRECISION DEFAULT NULL,
  stream_format TEXT DEFAULT NULL
)
RETURNS BYTEA
LANGUAGE plpgsql
AS $$
  BEGIN
    PERFORM dedalus_sdk_internal.ensure_context();
    RETURN jsonb_populate_record(
      NULL::BYTEA,
      dedalus_sdk_audio_speech._create(
        input, model, voice, instructions, response_format, speed, stream_format
      )
    );
  END;
$$;