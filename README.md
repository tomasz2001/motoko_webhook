# motoko_webhook

A Motoko library that allows you to quickly create a simple ICP backend with webhook support and basic HTTP/Candid endpoints.

It makes it easy to store webhook data inside a canister, assign it to specific URL paths, and return it in JSON format.

## What does this library do?

- defines the `Webhook.Webhook` type
- allows you to build HTTP responses in JSON format
- supports storing webhooks under a selected address/path
- makes it easy to integrate a canister as a simple API backend
- can be used either inside a full canister or as a helper module for other components

## Getting started

Add these files to your project:

- `src/Webhook.mo`
- `src/Webhook_hotplug.mo`

If you want to use the built-in HTTP/webhook mechanism in a canister, import `Webhook_hotplug` and include it in the actor.

## Core type

```motoko
import Webhook "Webhook";

public type Webhook = {
  id : Text;
  value : Text;
};
```

`id` is the field name in the JSON response, and `value` is the assigned value.

## Simple usage example

```motoko
import Webhook "Webhook";
import Webhook_hotplug "Webhook_hotplug";

actor MyWebhookCanister {
  include Webhook_hotplug();

  public func greet(name : Text, value : [Webhook.Webhook]) : async Text {
    set_webhook(value, name);
    return "Webhook updated";
  };
};
```

### What does this code do?

- `include Webhook_hotplug();` adds webhook and HTTP endpoint support to the actor
- `set_webhook(value, name)` stores the webhook data under the provided path
- `name` can be an address/path such as `/api/test`
- `value` is a list of entries in the format `[{ id; value }]`

If `name == ""`, the data is stored as the default canister data.

## Example with concrete data

```motoko
import Webhook "Webhook";
import Webhook_hotplug "Webhook_hotplug";

actor MyWebhookCanister {
  include Webhook_hotplug();

  public func addWebhook(path : Text, payload : [Webhook.Webhook]) : async Text {
    set_webhook(payload, path);
    return "Webhook registered for " # path;
  };
};
```

Example call:

```motoko
await MyWebhookCanister.addWebhook("/api/orders", [
  { id = "order-1"; value = "created" },
  { id = "order-2"; value = "paid" }
]);
```

This stores the data under the key `/api/orders`.

## Example JSON response

If you provide data like this:

```motoko
[
  { id = "test1"; value = "hello" },
  { id = "test2"; value = "world" }
]
```

then the library response will look like:

```json
{"test1": "hello", "test2": "world"}
```

## HTTP request handling

After including `Webhook_hotplug()`, you can use:

```motoko
public query func http_request(_req : Webhook.HttpRequest) : async Webhook.HttpResponse;

public func http_request_update(_req : Webhook.HttpUpdateRequest) : async Webhook.HttpUpdateResponse;
```

These functions return responses with the header:

```motoko
("Content-Type", "application/json; charset=UTF-8")
```

## Default configuration example

```motoko
import Webhook "Webhook";
import Webhook_hotplug "Webhook_hotplug";

actor Demo {
  include Webhook_hotplug();

  public func configure() : async Text {
    let data : [Webhook.Webhook] = [
      { id = "status"; value = "ok" },
      { id = "version"; value = "1.0.0" }
    ];

    set_webhook(data, "");
    return "Default config applied";
  };
};
```

After running `configure()`, the returned JSON will look like this:

```json
{"status": "ok", "version": "1.0.0"}
```

## Important notes

1. `Webhook.Webhook` stores a pair of `id` and `value`.
2. `set_webhook` takes the order: `(set : [Webhook.Webhook], target : Text)`.
3. If `target == ""`, the data is stored as the default value.
4. If `target` has a value, the data is stored under a specific address/path.
5. The library is designed mainly for simple ICP backend prototyping and webhook use cases.

## Summary

This library is useful for:

- quickly building Motoko backends on ICP
- simple JSON-based webhooks
- creating HTTP endpoints for canister data
- easily retrieving data by path

If you want, I can also prepare an English version of the project description for GitHub, or add a full working canister example with an HTTP endpoint.