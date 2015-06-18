# Rainforest Integrations

This is a small web service for outbound integrations from
Rainforest.

## API
`POST /events`
Rainforest will post events to this endpoint (see below for details
and the format).

`GET /integrations/:key`
Return the schema of settings for a particular integration (see below
for the format).

`GET /integrations`
Return a list of schemas for all supported integrations.

### General flow
Rainforest will check the API endpoint for the required settings keys
for each integration. Every event will be posted to the `events`
endpoint (Rainforest will determine which events to post based on user
preferences). The payload for the `events` post should contain all the
information necessary to complete integration event, including all
authentication and user settings.

### `POST /events`
#### Request payload
Each post to `events` should include a JSON object in the request body
with the following keys:

- `event_name`: The event name key (see below for more details).
- `integrations`: A list of integrations to post the event to. Each
  integration object should have 2 keys: `key`, which is the key name
  of the integration (e.g. `"slack"`), and `settings`, which is an
  object with integration-specific settings (including all
  authentication settings).
- `payload`: The appropriate event data (event-specific, see below for
  the payload types for each event).

#### Response
`POST /events` will return a 201 response on success with a
`{"status": "ok"}` object. On failure due to a bad request, it will
return a 400 response and an object with two keys:

- `error`: A description of the error that that occurred.
- `type`: The type of failure (currently one of `invalid_request`,
  `unsupported_integration`, or `misconfigured_integration`).

### `GET /integrations`
#### Response
`GET /integrations` will return a list of schemas for all supported
integrations, each of which has the following keys:

- `key`: The unique key of the integration (e.g. `"slack"`).
- `title`: A human-readable title for the integration name
  (e.g. `"Slack"`).
- `settings`: A list of possible settings for the integration. Each
  setting has three keys: `key`, the key name for the setting;
  `title`, a human-readable title for the setting; and `required`, a
  boolean indicating whether the setting is required.

The response object for an individual integration follows the same
format.

## Event payload
Events come with a payload that is specific to the event. The
following events are currently supported, with the corresponding keys
in the payload:


#### `run_completion`
Keys: run, failed_tests

#### `run_error`
Keys: run

#### `run_webhook_timeout`
Keys: run

#### `run_test_failure`
Keys: run, failed_test


The actual objects are similar to the objects returned in the
Rainforest API, and will be fully documented once the format has been
completely specified.
