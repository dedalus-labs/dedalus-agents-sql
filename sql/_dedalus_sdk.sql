-- A file that declares all schemas and types upfront so that their definitions don't
-- have to be topologically sorted in other files. It also creates some internal utility functions.

CREATE SCHEMA IF NOT EXISTS dedalus_sdk_internal;
REVOKE ALL ON SCHEMA dedalus_sdk_internal FROM PUBLIC;

CREATE OR REPLACE FUNCTION dedalus_sdk_internal.ensure_empty_type(
  p_schema TEXT,
  p_type TEXT
)
RETURNS void
LANGUAGE plpgsql
AS $$
  DECLARE
    attr RECORD;
  BEGIN
    -- Create an empty type if it doesn't exist from a previous extension version.
    IF NOT EXISTS (
      SELECT 1
      FROM pg_type t
      JOIN pg_namespace n ON n.oid = t.typnamespace
      WHERE t.typname = p_type
        AND n.nspname = p_schema
    ) THEN
      EXECUTE format(
        'CREATE TYPE %I.%I AS ();',
        p_schema,
        p_type
      );
      -- Already empty, nothing to drop.
      RETURN;
    END IF;

    -- Drop all existing attributes from the previous extension version so we can readd them.
    FOR attr IN
      SELECT a.attname
      FROM pg_attribute a
      JOIN pg_type t ON t.typrelid = a.attrelid
      JOIN pg_namespace n ON n.oid = t.typnamespace
      WHERE t.typname = p_type
        AND n.nspname = p_schema
        AND a.attnum > 0
        AND NOT a.attisdropped
      ORDER BY a.attnum DESC
    LOOP
      EXECUTE format(
        'ALTER TYPE %I.%I DROP ATTRIBUTE %I;',
        p_schema,
        p_type,
        attr.attname
      );
    END LOOP;
  END;
$$;

CREATE OR REPLACE FUNCTION dedalus_sdk_internal.ensure_context()
RETURNS void
LANGUAGE plpython3u
AS $$
  from types import SimpleNamespace
  from dedalus_labs import Dedalus

  if "__dedalus_sdk_context__" in GD:
      # The context was already created.
      return

  client_options = {}
  try:
      value = plpy.execute("SELECT current_setting('dedalus_sdk.base_url') AS value")[0]['value']
      client_options["base_url"] = value
  except Exception:
      # This configuration parameter was not set, but it's optional so ignore the exception.
      pass
  try:
      value = plpy.execute("SELECT current_setting('dedalus_sdk.environment') AS value")[0]['value']
      client_options["environment"] = value
  except Exception:
      # This configuration parameter was not set, but it's optional so ignore the exception.
      pass
  try:
      value = plpy.execute("SELECT current_setting('dedalus_sdk.api_key') AS value")[0]['value']
      client_options["api_key"] = value
  except Exception:
      # This configuration parameter was not set, but it's optional so ignore the exception.
      pass
  try:
      value = plpy.execute("SELECT current_setting('dedalus_sdk.x_api_key') AS value")[0]['value']
      client_options["x_api_key"] = value
  except Exception:
      # This configuration parameter was not set, but it's optional so ignore the exception.
      pass
  try:
      value = plpy.execute("SELECT current_setting('dedalus_sdk.as_url') AS value")[0]['value']
      client_options["as_base_url"] = value
  except Exception:
      # This configuration parameter was not set, but it's optional so ignore the exception.
      pass
  try:
      value = plpy.execute("SELECT current_setting('dedalus_sdk.org_id') AS value")[0]['value']
      client_options["dedalus_org_id"] = value
  except Exception:
      # This configuration parameter was not set, but it's optional so ignore the exception.
      pass
  try:
      value = plpy.execute("SELECT current_setting('dedalus_sdk.provider') AS value")[0]['value']
      client_options["provider"] = value
  except Exception:
      # This configuration parameter was not set, but it's optional so ignore the exception.
      pass
  try:
      value = plpy.execute("SELECT current_setting('dedalus_sdk.provider_key') AS value")[0]['value']
      client_options["provider_key"] = value
  except Exception:
      # This configuration parameter was not set, but it's optional so ignore the exception.
      pass
  try:
      value = plpy.execute("SELECT current_setting('dedalus_sdk.provider_model') AS value")[0]['value']
      client_options["provider_model"] = value
  except Exception:
      # This configuration parameter was not set, but it's optional so ignore the exception.
      pass

  def strip_none(value):
      if isinstance(value, dict):
          return {
              k: strip_none(v)
              for k, v in value.items()
              if v is not None
          }
      elif isinstance(value, list):
          return [strip_none(v) for v in value]
      else:
          return value

  GD["__dedalus_sdk_context__"] = SimpleNamespace(
      client=Dedalus(**client_options),
      strip_none=strip_none,
  )
$$;

CREATE TYPE dedalus_sdk_internal.page AS (
  data JSONB,
  next_request_options JSONB
);

CREATE SCHEMA IF NOT EXISTS dedalus_sdk;

CREATE TYPE dedalus_sdk.credential AS ();
CREATE TYPE dedalus_sdk.dedalus_model AS ();
CREATE TYPE dedalus_sdk.function_definition AS ();
CREATE TYPE dedalus_sdk.mcp_server_spec AS ();
CREATE TYPE dedalus_sdk.mcp_tool_result AS ();
CREATE TYPE dedalus_sdk.model_settings AS ();
CREATE TYPE dedalus_sdk.response_format_json_object AS ();
CREATE TYPE dedalus_sdk.response_format_json_schema AS ();
CREATE TYPE dedalus_sdk.response_format_json_schema_json_schema AS ();
CREATE TYPE dedalus_sdk.response_format_text AS ();
CREATE TYPE dedalus_sdk.voice_ids_or_custom_voice AS ();

CREATE SCHEMA IF NOT EXISTS dedalus_sdk_models;

CREATE TYPE dedalus_sdk_models.list_models_response AS ();
CREATE TYPE dedalus_sdk_models.model AS ();
CREATE TYPE dedalus_sdk_models.model_capability AS ();
CREATE TYPE dedalus_sdk_models.model_default AS ();

CREATE SCHEMA IF NOT EXISTS dedalus_sdk_embeddings;

CREATE TYPE dedalus_sdk_embeddings.create_embedding_request AS ();
CREATE TYPE dedalus_sdk_embeddings.create_embedding_response AS ();
CREATE TYPE dedalus_sdk_embeddings.create_embedding_response_data AS ();
CREATE TYPE dedalus_sdk_embeddings.create_embedding_response_usage AS ();

CREATE SCHEMA IF NOT EXISTS dedalus_sdk_audio_speech;

CREATE SCHEMA IF NOT EXISTS dedalus_sdk_audio_transcriptions;

CREATE TYPE dedalus_sdk_audio_transcriptions.transcription_create_response AS ();
CREATE TYPE dedalus_sdk_audio_transcriptions.transcription_create_response_segment AS ();
CREATE TYPE dedalus_sdk_audio_transcriptions.transcription_create_response_usage AS ();
CREATE TYPE dedalus_sdk_audio_transcriptions.transcription_create_response_word AS ();
CREATE TYPE dedalus_sdk_audio_transcriptions.transcription_create_response_logprob AS ();

CREATE SCHEMA IF NOT EXISTS dedalus_sdk_audio_translations;

CREATE TYPE dedalus_sdk_audio_translations.translation_create_response AS ();
CREATE TYPE dedalus_sdk_audio_translations.translation_create_response_segment AS ();

CREATE SCHEMA IF NOT EXISTS dedalus_sdk_images;

CREATE TYPE dedalus_sdk_images.create_image_request AS ();
CREATE TYPE dedalus_sdk_images.image AS ();
CREATE TYPE dedalus_sdk_images.images_response AS ();

CREATE SCHEMA IF NOT EXISTS dedalus_sdk_ocr;

CREATE TYPE dedalus_sdk_ocr.ocr_document AS ();
CREATE TYPE dedalus_sdk_ocr.ocr_page AS ();
CREATE TYPE dedalus_sdk_ocr.ocr_request AS ();
CREATE TYPE dedalus_sdk_ocr.ocr_response AS ();

CREATE SCHEMA IF NOT EXISTS dedalus_sdk_responses;

CREATE TYPE dedalus_sdk_responses.response AS ();
CREATE TYPE dedalus_sdk_responses.response_create_params AS ();
CREATE TYPE dedalus_sdk_responses.response_create_params_prompt AS ();
CREATE TYPE dedalus_sdk_responses.create_params_prompt AS ();

CREATE SCHEMA IF NOT EXISTS dedalus_sdk_chat_completions;

CREATE TYPE dedalus_sdk_chat_completions.audio AS ();
CREATE TYPE dedalus_sdk_chat_completions.chat_completion AS ();
CREATE TYPE dedalus_sdk_chat_completions.chat_completion_pending_tool AS ();
CREATE TYPE dedalus_sdk_chat_completions.chat_completion_assistant_message_param AS ();
CREATE TYPE dedalus_sdk_chat_completions.chat_completion_assistant_message_param_function_call AS ();
CREATE TYPE dedalus_sdk_chat_completions.chat_completion_assistant_message_param_tool_call AS ();
CREATE TYPE dedalus_sdk_chat_completions.chat_completion_assistant_message_param_tool_call_function AS ();
CREATE TYPE dedalus_sdk_chat_completions.chat_completion_assistant_message_param_tool_call_custom AS ();
CREATE TYPE dedalus_sdk_chat_completions.chat_completion_audio_param AS ();
CREATE TYPE dedalus_sdk_chat_completions.chat_completion_chunk AS ();
CREATE TYPE dedalus_sdk_chat_completions.chat_completion_content_part_file_param AS ();
CREATE TYPE dedalus_sdk_chat_completions.chat_completion_content_part_file_param_file AS ();
CREATE TYPE dedalus_sdk_chat_completions.chat_completion_content_part_image_param AS ();
CREATE TYPE dedalus_sdk_chat_completions.chat_completion_content_part_image_param_image_url AS ();
CREATE TYPE dedalus_sdk_chat_completions.chat_completion_content_part_input_audio_param AS ();
CREATE TYPE dedalus_sdk_chat_completions.chat_completion_content_part_input_audio_param_input_audio AS ();
CREATE TYPE dedalus_sdk_chat_completions.chat_completion_content_part_refusal_param AS ();
CREATE TYPE dedalus_sdk_chat_completions.chat_completion_content_part_text_param AS ();
CREATE TYPE dedalus_sdk_chat_completions.chat_completion_developer_message_param AS ();
CREATE TYPE dedalus_sdk_chat_completions.chat_completion_function_message_param AS ();
CREATE TYPE dedalus_sdk_chat_completions.chat_completion_functions AS ();
CREATE TYPE dedalus_sdk_chat_completions.chat_completion_message AS ();
CREATE TYPE dedalus_sdk_chat_completions.chat_completion_message_annotation AS ();
CREATE TYPE dedalus_sdk_chat_completions.chat_completion_message_annotation_url_citation AS ();
CREATE TYPE dedalus_sdk_chat_completions.chat_completion_message_audio AS ();
CREATE TYPE dedalus_sdk_chat_completions.chat_completion_message_function_call AS ();
CREATE TYPE dedalus_sdk_chat_completions.chat_completion_message_tool_call AS ();
CREATE TYPE dedalus_sdk_chat_completions.chat_completion_message_tool_call_function AS ();
CREATE TYPE dedalus_sdk_chat_completions.chat_completion_message_tool_call_custom AS ();
CREATE TYPE dedalus_sdk_chat_completions.chat_completion_message_custom_tool_call AS ();
CREATE TYPE dedalus_sdk_chat_completions.chat_completion_message_custom_tool_call_custom AS ();
CREATE TYPE dedalus_sdk_chat_completions.chat_completion_message_tool_call1 AS ();
CREATE TYPE dedalus_sdk_chat_completions.chat_completion_message_tool_call_function1 AS ();
CREATE TYPE dedalus_sdk_chat_completions.chat_completion_system_message_param AS ();
CREATE TYPE dedalus_sdk_chat_completions.chat_completion_token_logprob AS ();
CREATE TYPE dedalus_sdk_chat_completions.chat_completion_token_logprob_top_logprob AS ();
CREATE TYPE dedalus_sdk_chat_completions.chat_completion_tool_message_param AS ();
CREATE TYPE dedalus_sdk_chat_completions.chat_completion_tool_param AS ();
CREATE TYPE dedalus_sdk_chat_completions.chat_completion_user_message_param AS ();
CREATE TYPE dedalus_sdk_chat_completions.choice AS ();
CREATE TYPE dedalus_sdk_chat_completions.choice_delta AS ();
CREATE TYPE dedalus_sdk_chat_completions.choice_delta_function_call AS ();
CREATE TYPE dedalus_sdk_chat_completions.choice_delta_tool_call AS ();
CREATE TYPE dedalus_sdk_chat_completions.choice_delta_tool_call_function AS ();
CREATE TYPE dedalus_sdk_chat_completions.choice_logprobs AS ();
CREATE TYPE dedalus_sdk_chat_completions.completion_tokens_details AS ();
CREATE TYPE dedalus_sdk_chat_completions.completion_usage AS ();
CREATE TYPE dedalus_sdk_chat_completions.deferred_call_response AS ();
CREATE TYPE dedalus_sdk_chat_completions.input_token_details AS ();
CREATE TYPE dedalus_sdk_chat_completions.prediction_content AS ();
CREATE TYPE dedalus_sdk_chat_completions.prompt_tokens_details AS ();
CREATE TYPE dedalus_sdk_chat_completions.stream_choice AS ();
CREATE TYPE dedalus_sdk_chat_completions.stream_choice_logprobs AS ();
CREATE TYPE dedalus_sdk_chat_completions.thinking_config_disabled AS ();
CREATE TYPE dedalus_sdk_chat_completions.thinking_config_enabled AS ();
CREATE TYPE dedalus_sdk_chat_completions.tool_choice_any AS ();
CREATE TYPE dedalus_sdk_chat_completions.tool_choice_auto AS ();
CREATE TYPE dedalus_sdk_chat_completions.tool_choice_none AS ();
CREATE TYPE dedalus_sdk_chat_completions.tool_choice_tool AS ();
CREATE TYPE dedalus_sdk_chat_completions.create_params_message AS ();
CREATE TYPE dedalus_sdk_chat_completions.create_params_message_function_call AS ();
CREATE TYPE dedalus_sdk_chat_completions.create_params_message_tool_call AS ();
CREATE TYPE dedalus_sdk_chat_completions.create_params_message_tool_call_function AS ();
CREATE TYPE dedalus_sdk_chat_completions.create_params_message_tool_call_custom AS ();
CREATE TYPE dedalus_sdk_chat_completions.create_params_response_format AS ();
CREATE TYPE dedalus_sdk_chat_completions.create_params_response_format_json_schema AS ();
CREATE TYPE dedalus_sdk_chat_completions.create_params_safety_setting AS ();
CREATE TYPE dedalus_sdk_chat_completions.create_params_thinking AS ();