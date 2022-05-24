import Principal "mo:base/Principal";
import Error "mo:base/Error";

actor {
    public func initialize() : async Bool {
        // if already initialized, return false
        // todo create index page
        // use the ic management canister:
        // https://smartcontracts.org/docs/current/references/ic-interface-spec/#ic-management-canister
        // todo return true
        throw Error.reject("poop");
    };

    public query func getIndexPagePrincipal() : async ?Principal {
        // todo if index page has been created, return it,
        // otherwise null.
        throw Error.reject("poop");
    };

    public query func getPagePrincipal(name: Text) : async ?Principal {
        throw Error.reject("poop");
    };

    // Returns a new Principal on success, null otherwise.
    public query func createPage(name: Text) : async ?Principal {
        // todo if exists return the existing principal
        // if not exists create a new principal and store in hash map
        throw Error.reject("poop");
    };
};
