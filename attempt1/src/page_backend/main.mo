import Principal "mo:base/Principal";
import Error "mo:base/Error";

actor {
    var page_content : Text = "";
    
    public query func getFullPageMarkup() : async Text {
        return page_content;
    };

    public func setFullPageMarkup(text: Text) {
        page_content := text;
    }    
};
