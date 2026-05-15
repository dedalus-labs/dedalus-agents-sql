ALTER TYPE dedalus_sdk_images.create_image_request
  ADD ATTRIBUTE prompt TEXT,
  ADD ATTRIBUTE background TEXT,
  ADD ATTRIBUTE model TEXT,
  ADD ATTRIBUTE moderation TEXT,
  ADD ATTRIBUTE n BIGINT,
  ADD ATTRIBUTE output_compression BIGINT,
  ADD ATTRIBUTE output_format TEXT,
  ADD ATTRIBUTE partial_images BIGINT,
  ADD ATTRIBUTE quality TEXT,
  ADD ATTRIBUTE response_format TEXT,
  ADD ATTRIBUTE size TEXT,
  ADD ATTRIBUTE stream BOOLEAN,
  ADD ATTRIBUTE style TEXT,
  ADD ATTRIBUTE "user" TEXT;

CREATE OR REPLACE FUNCTION dedalus_sdk_images.make_create_image_request(
  prompt TEXT,
  background TEXT DEFAULT NULL,
  model TEXT DEFAULT NULL,
  moderation TEXT DEFAULT NULL,
  n BIGINT DEFAULT NULL,
  output_compression BIGINT DEFAULT NULL,
  output_format TEXT DEFAULT NULL,
  partial_images BIGINT DEFAULT NULL,
  quality TEXT DEFAULT NULL,
  response_format TEXT DEFAULT NULL,
  size TEXT DEFAULT NULL,
  stream BOOLEAN DEFAULT NULL,
  style TEXT DEFAULT NULL,
  "user" TEXT DEFAULT NULL
)
RETURNS dedalus_sdk_images.create_image_request
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    prompt,
    background,
    model,
    moderation,
    n,
    output_compression,
    output_format,
    partial_images,
    quality,
    response_format,
    size,
    stream,
    style,
    "user"
  )::dedalus_sdk_images.create_image_request;
$$;

ALTER TYPE dedalus_sdk_images.image
  ADD ATTRIBUTE b64_json TEXT,
  ADD ATTRIBUTE revised_prompt TEXT,
  ADD ATTRIBUTE url TEXT;

CREATE OR REPLACE FUNCTION dedalus_sdk_images.make_image(
  b64_json TEXT DEFAULT NULL,
  revised_prompt TEXT DEFAULT NULL,
  url TEXT DEFAULT NULL
)
RETURNS dedalus_sdk_images.image
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(b64_json, revised_prompt, url)::dedalus_sdk_images.image;
$$;

ALTER TYPE dedalus_sdk_images.images_response
  ADD ATTRIBUTE created BIGINT, ADD ATTRIBUTE data dedalus_sdk_images.image[];

CREATE OR REPLACE FUNCTION dedalus_sdk_images.make_images_response(
  created BIGINT, data dedalus_sdk_images.image[]
)
RETURNS dedalus_sdk_images.images_response
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(created, data)::dedalus_sdk_images.images_response;
$$;

CREATE OR REPLACE FUNCTION dedalus_sdk_images._create_variation(
  image TEXT,
  model TEXT DEFAULT NULL,
  n BIGINT DEFAULT NULL,
  response_format TEXT DEFAULT NULL,
  size TEXT DEFAULT NULL,
  "user" TEXT DEFAULT NULL
)
RETURNS JSONB
LANGUAGE plpython3u
AS $$
  from dedalus_labs._types import not_given

  response = GD["__dedalus_sdk_context__"].client.images.with_raw_response.create_variation(
      image=image,
      model=not_given if model is None else model,
      n=not_given if n is None else n,
      response_format=not_given if response_format is None else response_format,
      size=not_given if size is None else size,
      user=not_given if user is None else user,
  )

  # We don't parse the JSON and let PL/Python perform data mapping because PL/Python errors for omitted
  # fields instead of defaulting them to NULL, but we want to be more lenient, which we handle in the
  # caller later.
  return response.text()
$$;

CREATE OR REPLACE FUNCTION dedalus_sdk_images.create_variation(
  image TEXT,
  model TEXT DEFAULT NULL,
  n BIGINT DEFAULT NULL,
  response_format TEXT DEFAULT NULL,
  size TEXT DEFAULT NULL,
  "user" TEXT DEFAULT NULL
)
RETURNS dedalus_sdk_images.images_response
LANGUAGE plpgsql
AS $$
  BEGIN
    PERFORM dedalus_sdk_internal.ensure_context();
    RETURN jsonb_populate_record(
      NULL::dedalus_sdk_images.images_response,
      dedalus_sdk_images._create_variation(
        image, model, n, response_format, size, "user"
      )
    );
  END;
$$;

CREATE OR REPLACE FUNCTION dedalus_sdk_images._edit(
  image TEXT,
  prompt TEXT,
  mask TEXT DEFAULT NULL,
  model TEXT DEFAULT NULL,
  n BIGINT DEFAULT NULL,
  response_format TEXT DEFAULT NULL,
  size TEXT DEFAULT NULL,
  "user" TEXT DEFAULT NULL
)
RETURNS JSONB
LANGUAGE plpython3u
AS $$
  from dedalus_labs._types import not_given

  response = GD["__dedalus_sdk_context__"].client.images.with_raw_response.edit(
      image=image,
      prompt=prompt,
      mask=not_given if mask is None else mask,
      model=not_given if model is None else model,
      n=not_given if n is None else n,
      response_format=not_given if response_format is None else response_format,
      size=not_given if size is None else size,
      user=not_given if user is None else user,
  )

  # We don't parse the JSON and let PL/Python perform data mapping because PL/Python errors for omitted
  # fields instead of defaulting them to NULL, but we want to be more lenient, which we handle in the
  # caller later.
  return response.text()
$$;

CREATE OR REPLACE FUNCTION dedalus_sdk_images.edit(
  image TEXT,
  prompt TEXT,
  mask TEXT DEFAULT NULL,
  model TEXT DEFAULT NULL,
  n BIGINT DEFAULT NULL,
  response_format TEXT DEFAULT NULL,
  size TEXT DEFAULT NULL,
  "user" TEXT DEFAULT NULL
)
RETURNS dedalus_sdk_images.images_response
LANGUAGE plpgsql
AS $$
  BEGIN
    PERFORM dedalus_sdk_internal.ensure_context();
    RETURN jsonb_populate_record(
      NULL::dedalus_sdk_images.images_response,
      dedalus_sdk_images._edit(
        image, prompt, mask, model, n, response_format, size, "user"
      )
    );
  END;
$$;

CREATE OR REPLACE FUNCTION dedalus_sdk_images._generate(
  prompt TEXT,
  background TEXT DEFAULT NULL,
  model TEXT DEFAULT NULL,
  moderation TEXT DEFAULT NULL,
  n BIGINT DEFAULT NULL,
  output_compression BIGINT DEFAULT NULL,
  output_format TEXT DEFAULT NULL,
  partial_images BIGINT DEFAULT NULL,
  quality TEXT DEFAULT NULL,
  response_format TEXT DEFAULT NULL,
  size TEXT DEFAULT NULL,
  stream BOOLEAN DEFAULT NULL,
  style TEXT DEFAULT NULL,
  "user" TEXT DEFAULT NULL
)
RETURNS JSONB
LANGUAGE plpython3u
AS $$
  from dedalus_labs._types import not_given

  response = GD["__dedalus_sdk_context__"].client.images.with_raw_response.generate(
      prompt=prompt,
      background=not_given if background is None else background,
      model=not_given if model is None else model,
      moderation=not_given if moderation is None else moderation,
      n=not_given if n is None else n,
      output_compression=not_given if output_compression is None else output_compression,
      output_format=not_given if output_format is None else output_format,
      partial_images=not_given if partial_images is None else partial_images,
      quality=not_given if quality is None else quality,
      response_format=not_given if response_format is None else response_format,
      size=not_given if size is None else size,
      stream=not_given if stream is None else stream,
      style=not_given if style is None else style,
      user=not_given if user is None else user,
  )

  # We don't parse the JSON and let PL/Python perform data mapping because PL/Python errors for omitted
  # fields instead of defaulting them to NULL, but we want to be more lenient, which we handle in the
  # caller later.
  return response.text()
$$;

CREATE OR REPLACE FUNCTION dedalus_sdk_images.generate(
  prompt TEXT,
  background TEXT DEFAULT NULL,
  model TEXT DEFAULT NULL,
  moderation TEXT DEFAULT NULL,
  n BIGINT DEFAULT NULL,
  output_compression BIGINT DEFAULT NULL,
  output_format TEXT DEFAULT NULL,
  partial_images BIGINT DEFAULT NULL,
  quality TEXT DEFAULT NULL,
  response_format TEXT DEFAULT NULL,
  size TEXT DEFAULT NULL,
  stream BOOLEAN DEFAULT NULL,
  style TEXT DEFAULT NULL,
  "user" TEXT DEFAULT NULL
)
RETURNS dedalus_sdk_images.images_response
LANGUAGE plpgsql
AS $$
  BEGIN
    PERFORM dedalus_sdk_internal.ensure_context();
    RETURN jsonb_populate_record(
      NULL::dedalus_sdk_images.images_response,
      dedalus_sdk_images._generate(
        prompt,
        background,
        model,
        moderation,
        n,
        output_compression,
        output_format,
        partial_images,
        quality,
        response_format,
        size,
        stream,
        style,
        "user"
      )
    );
  END;
$$;