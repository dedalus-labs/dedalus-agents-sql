ALTER TYPE dedalus_sdk_ocr.ocr_document
  ADD ATTRIBUTE document_url TEXT, ADD ATTRIBUTE type TEXT;

CREATE OR REPLACE FUNCTION dedalus_sdk_ocr.make_ocr_document(
  document_url TEXT, type TEXT DEFAULT NULL
)
RETURNS dedalus_sdk_ocr.ocr_document
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(document_url, type)::dedalus_sdk_ocr.ocr_document;
$$;

ALTER TYPE dedalus_sdk_ocr.ocr_page
  ADD ATTRIBUTE index BIGINT, ADD ATTRIBUTE markdown TEXT;

CREATE OR REPLACE FUNCTION dedalus_sdk_ocr.make_ocr_page(
  index BIGINT, markdown TEXT
)
RETURNS dedalus_sdk_ocr.ocr_page
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(index, markdown)::dedalus_sdk_ocr.ocr_page;
$$;

ALTER TYPE dedalus_sdk_ocr.ocr_request
  ADD ATTRIBUTE document dedalus_sdk_ocr.ocr_document, ADD ATTRIBUTE model TEXT;

CREATE OR REPLACE FUNCTION dedalus_sdk_ocr.make_ocr_request(
  document dedalus_sdk_ocr.ocr_document, model TEXT DEFAULT NULL
)
RETURNS dedalus_sdk_ocr.ocr_request
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(document, model)::dedalus_sdk_ocr.ocr_request;
$$;

ALTER TYPE dedalus_sdk_ocr.ocr_response
  ADD ATTRIBUTE model TEXT,
  ADD ATTRIBUTE pages dedalus_sdk_ocr.ocr_page[],
  ADD ATTRIBUTE usage JSONB;

CREATE OR REPLACE FUNCTION dedalus_sdk_ocr.make_ocr_response(
  model TEXT, pages dedalus_sdk_ocr.ocr_page[], usage JSONB DEFAULT NULL
)
RETURNS dedalus_sdk_ocr.ocr_response
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(model, pages, usage)::dedalus_sdk_ocr.ocr_response;
$$;

CREATE OR REPLACE FUNCTION dedalus_sdk_ocr._process(
  document dedalus_sdk_ocr.ocr_document, model TEXT DEFAULT NULL
)
RETURNS JSONB
LANGUAGE plpython3u
AS $$
  from dedalus_labs._types import not_given

  response = GD["__dedalus_sdk_context__"].client.ocr.with_raw_response.process(
      document=GD["__dedalus_sdk_context__"].strip_none(document),
      model=not_given if model is None else model,
  )

  # We don't parse the JSON and let PL/Python perform data mapping because PL/Python errors for omitted
  # fields instead of defaulting them to NULL, but we want to be more lenient, which we handle in the
  # caller later.
  return response.text()
$$;

CREATE OR REPLACE FUNCTION dedalus_sdk_ocr.process(
  document dedalus_sdk_ocr.ocr_document, model TEXT DEFAULT NULL
)
RETURNS dedalus_sdk_ocr.ocr_response
LANGUAGE plpgsql
AS $$
  BEGIN
    PERFORM dedalus_sdk_internal.ensure_context();
    RETURN jsonb_populate_record(
      NULL::dedalus_sdk_ocr.ocr_response,
      dedalus_sdk_ocr._process(document, model)
    );
  END;
$$;