import Principal "mo:base/Principal";
import Error "mo:base/Error";

actor {
    public query func getFullPageMarkup() : async Text {
        throw Error.reject("poop");
    };

    public func setFullPageMarkup(text: Text) {
        throw Error.reject("poop");
    }
};
