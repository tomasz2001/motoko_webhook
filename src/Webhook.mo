import Array "mo:core/Array";
import Principal "mo:core/Principal";
import Nat "mo:core/Nat";
import Blob "mo:core/Blob";
import Text "mo:core/Text";

module Webhook {

  public type HeaderField = (Text, Text);

  public type HttpUpdateResponse = {
    status_code : Nat16;
    headers : [HeaderField];
    body : Blob;
  };

  public type HttpResponse = {
    status_code : Nat16;
    headers : [HeaderField];
    body : Blob;
    upgrade : ?Bool;
  };

  public type HttpRequest = {
    method : Text;
    url : Text;
    headers : [HeaderField];
    body : Blob;
    certificate_version : ?Nat16;
  };

  public type HttpUpdateRequest = {
    method : Text;
    url : Text;
    headers : [HeaderField];
    body : Blob;
  };

  public type Webhook = {
    id : Text;
    value : Text;
  };

  public func response_update(response : [Webhook]) : HttpUpdateResponse {
    var work : Nat = response.size();
    var result : Text = "{";

    while (work > 0) {
      if (work != 1) {
        result := result # "\"" # response[work - 1].id # "\": \"" # response[work - 1].value # "\", ";
      } else {
        result := result # "\"" # response[work - 1].id # "\": \"" # response[work - 1].value # "\"";
      };

      work -= 1;
    };

    result := result # "}";

    return {
      status_code = 200;
      headers = [("Content-Type", "application/json; charset=UTF-8")];
      body = Text.encodeUtf8(result);
    };
  };

  public func response_qwery(response : [Webhook]) : HttpResponse {
    var work : Nat = response.size();
    var up : ?Bool = ?true;
    var result : Text = "{";

    while (work > 0) {
      if (work != 1) {
        result := result # "\"" # response[work - 1].id # "\": \"" # response[work - 1].value # "\", ";
      } else {
        result := result # "\"" # response[work - 1].id # "\": \"" # response[work - 1].value # "\"";
      };

      work -= 1;
    };

    result := result # "}";

    return {
      status_code = 200;
      headers = [("Content-Type", "application/json; charset=UTF-8")];
      body = Text.encodeUtf8(result);
      upgrade = up;
    };
  };
};