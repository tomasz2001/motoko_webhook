import Webhook "Webhook";
import Webhook_hotplug "Webhook_hotplug";
import Text "mo:core/Text";

actor test_webhook {
  include Webhook_hotplug();

  public func greet(name : Text, value : [Webhook.Webhook]) : async Text {
    set_webhook(value, name);
    return "drop";
  };
};
