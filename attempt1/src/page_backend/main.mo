import Principal "mo:base/Principal";
import Error "mo:base/Error";
import Array "mo:base/Array";
import B "mo:base/Buffer";

actor {
    let newPageText : Text = "New page.";
    var history : B.Buffer<Text> = B.Buffer(0);
    
    public query func getFullPageMarkup() : async Text {
        let historyLen = history.size();
        if (historyLen == 0) {
            return newPageText;
        } else {
            return history.get(historyLen - 1);
        };
    };

    public func setFullPageMarkup(text: Text) {
        let historyLen = history.size();
        if (historyLen == 0) {
            history.add(newPageText);
        };
        history.add(text);
    };

    public query func getHistorySize() : async Nat {
        let historyLen = history.size();
        if (historyLen == 0) {
            return historyLen + 1;
        };
        return historyLen;
    };

    public query func getFullPageAt(index: Nat) : async ?Text {
        let historyLen = history.size();
        if (historyLen == 0 and index == 0) {
            return ?newPageText;
        };
        return history.getOpt(index);
    };
};
