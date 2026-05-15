ALTER TYPE dedalus_sdk_audio_transcriptions.transcription_create_response
  ADD ATTRIBUTE text TEXT,
  ADD ATTRIBUTE duration DOUBLE PRECISION,
  ADD ATTRIBUTE language TEXT,
  ADD ATTRIBUTE segments dedalus_sdk_audio_transcriptions.transcription_create_response_segment[],
  ADD ATTRIBUTE usage dedalus_sdk_audio_transcriptions.transcription_create_response_usage,
  ADD ATTRIBUTE words dedalus_sdk_audio_transcriptions.transcription_create_response_word[],
  ADD ATTRIBUTE logprobs dedalus_sdk_audio_transcriptions.transcription_create_response_logprob[];

CREATE OR REPLACE FUNCTION dedalus_sdk_audio_transcriptions.make_transcription_create_response(
  text TEXT,
  duration DOUBLE PRECISION DEFAULT NULL,
  language TEXT DEFAULT NULL,
  segments dedalus_sdk_audio_transcriptions.transcription_create_response_segment[] DEFAULT NULL,
  usage dedalus_sdk_audio_transcriptions.transcription_create_response_usage DEFAULT NULL,
  words dedalus_sdk_audio_transcriptions.transcription_create_response_word[] DEFAULT NULL,
  logprobs dedalus_sdk_audio_transcriptions.transcription_create_response_logprob[] DEFAULT NULL
)
RETURNS dedalus_sdk_audio_transcriptions.transcription_create_response
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    text, duration, language, segments, usage, words, logprobs
  )::dedalus_sdk_audio_transcriptions.transcription_create_response;
$$;

ALTER TYPE dedalus_sdk_audio_transcriptions.transcription_create_response_segment
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

CREATE OR REPLACE FUNCTION dedalus_sdk_audio_transcriptions.make_transcription_create_response_segment(
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
RETURNS dedalus_sdk_audio_transcriptions.transcription_create_response_segment
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
  )::dedalus_sdk_audio_transcriptions.transcription_create_response_segment;
$$;

ALTER TYPE dedalus_sdk_audio_transcriptions.transcription_create_response_usage
  ADD ATTRIBUTE type TEXT,
  ADD ATTRIBUTE seconds DOUBLE PRECISION,
  ADD ATTRIBUTE input_tokens BIGINT,
  ADD ATTRIBUTE output_tokens BIGINT,
  ADD ATTRIBUTE total_tokens BIGINT,
  ADD ATTRIBUTE input_token_details dedalus_sdk_chat_completions.input_token_details;

CREATE OR REPLACE FUNCTION dedalus_sdk_audio_transcriptions.make_transcription_create_response_usage(
  type TEXT,
  seconds DOUBLE PRECISION DEFAULT NULL,
  input_tokens BIGINT DEFAULT NULL,
  output_tokens BIGINT DEFAULT NULL,
  total_tokens BIGINT DEFAULT NULL,
  input_token_details dedalus_sdk_chat_completions.input_token_details DEFAULT NULL
)
RETURNS dedalus_sdk_audio_transcriptions.transcription_create_response_usage
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    type,
    seconds,
    input_tokens,
    output_tokens,
    total_tokens,
    input_token_details
  )::dedalus_sdk_audio_transcriptions.transcription_create_response_usage;
$$;

ALTER TYPE dedalus_sdk_audio_transcriptions.transcription_create_response_word
  ADD ATTRIBUTE "end" DOUBLE PRECISION,
  ADD ATTRIBUTE start DOUBLE PRECISION,
  ADD ATTRIBUTE word TEXT;

CREATE OR REPLACE FUNCTION dedalus_sdk_audio_transcriptions.make_transcription_create_response_word(
  "end" DOUBLE PRECISION, start DOUBLE PRECISION, word TEXT
)
RETURNS dedalus_sdk_audio_transcriptions.transcription_create_response_word
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    "end", start, word
  )::dedalus_sdk_audio_transcriptions.transcription_create_response_word;
$$;

ALTER TYPE dedalus_sdk_audio_transcriptions.transcription_create_response_logprob
  ADD ATTRIBUTE token TEXT,
  ADD ATTRIBUTE bytes DOUBLE PRECISION[],
  ADD ATTRIBUTE logprob DOUBLE PRECISION;

CREATE OR REPLACE FUNCTION dedalus_sdk_audio_transcriptions.make_transcription_create_response_logprob(
  token TEXT DEFAULT NULL,
  bytes DOUBLE PRECISION[] DEFAULT NULL,
  logprob DOUBLE PRECISION DEFAULT NULL
)
RETURNS dedalus_sdk_audio_transcriptions.transcription_create_response_logprob
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    token, bytes, logprob
  )::dedalus_sdk_audio_transcriptions.transcription_create_response_logprob;
$$;

CREATE OR REPLACE FUNCTION dedalus_sdk_audio_transcriptions._create(
  file TEXT,
  model TEXT,
  language TEXT DEFAULT NULL,
  prompt TEXT DEFAULT NULL,
  response_format TEXT DEFAULT NULL,
  temperature DOUBLE PRECISION DEFAULT NULL
)
RETURNS JSONB
LANGUAGE plpython3u
AS $$
  from dedalus_labs._types import not_given

  response = GD["__dedalus_sdk_context__"].client.audio.transcriptions.with_raw_response.create(
      file=file,
      model=model,
      language=not_given if language is None else language,
      prompt=not_given if prompt is None else prompt,
      response_format=not_given if response_format is None else response_format,
      temperature=not_given if temperature is None else temperature,
  )

  # We don't parse the JSON and let PL/Python perform data mapping because PL/Python errors for omitted
  # fields instead of defaulting them to NULL, but we want to be more lenient, which we handle in the
  # caller later.
  return response.text()
$$;

CREATE OR REPLACE FUNCTION dedalus_sdk_audio_transcriptions.create(
  file TEXT,
  model TEXT,
  language TEXT DEFAULT NULL,
  prompt TEXT DEFAULT NULL,
  response_format TEXT DEFAULT NULL,
  temperature DOUBLE PRECISION DEFAULT NULL
)
RETURNS dedalus_sdk_audio_transcriptions.transcription_create_response
LANGUAGE plpgsql
AS $$
  BEGIN
    PERFORM dedalus_sdk_internal.ensure_context();
    RETURN jsonb_populate_record(
      NULL::dedalus_sdk_audio_transcriptions.transcription_create_response,
      dedalus_sdk_audio_transcriptions._create(
        file, model, language, prompt, response_format, temperature
      )
    );
  END;
$$;