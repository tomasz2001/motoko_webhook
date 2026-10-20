import Webhook "Webhook";
import Text "mo:core/Text";
import Map "mo:core/Map";

mixin () {
  var response : [Webhook.Webhook] = [
    { id = "test1"; value = "hello" },
    { id = "test2"; value = "world" },
  ];
  var url_webhook : Text = "/webhook.php";
  var box_response = Map.empty<Text, [Webhook.Webhook]>();

  public func http_request_update(_req : Webhook.HttpUpdateRequest) : async Webhook.HttpUpdateResponse {
    if ((_req : Webhook.HttpUpdateRequest).url == "") {
      return Webhook.response_update(response);
    } else {
      let dropp : ?[Webhook.Webhook] = Map.get(box_response, (_req : Webhook.HttpUpdateRequest).url);
      switch (dropp) {
        case (?webhook) {
          return Webhook.response_update(webhook);
        };
        case (null) {
          return Webhook.response_update(response);
        };
      };
    };
  };

  public query func http_request(_req : Webhook.HttpRequest) : async Webhook.HttpResponse {
    if ((_req : Webhook.HttpRequest).url == "") {
      return Webhook.response_qwery(response);
    } else {
      let dropp : ?[Webhook.Webhook] = Map.get(box_response, (_req : Webhook.HttpRequest).url);
      switch (dropp) {
        case (?webhook) {
          return Webhook.response_qwery(webhook);
        };
        case (null) {
          return Webhook.response_qwery(response);
        };
      };
    };
  };

  private func set_webhook(set : [Webhook.Webhook], target : Text) {
    if (target == "") {
      response := set;
    } else {
      Map.add(box_response, target, set);
    };
  };
  private func get_webhook(text : Text) : [Webhook.Webhook] {
    let dropp : ?[Webhook.Webhook] = Map.get(box_response, text);
      switch (dropp) {
        case (?webhook) { return webhook; };
        case (null) {return response; }
        };
  };
};