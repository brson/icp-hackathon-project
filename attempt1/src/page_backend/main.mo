import Principal "mo:base/Principal";
import Error "mo:base/Error";

actor {
    var pageContent : Text = "";
    
    public query func getFullPageMarkup() : async Text {
        return pageContent;
    };

    public func setFullPageMarkup(text: Text) {
        pageContent := text;
    }    
};
