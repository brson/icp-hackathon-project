import Principal "mo:base/Principal";
import Error "mo:base/Error";
import Cycles "mo:base/ExperimentalCycles";
import Debug "mo:base/Debug";
import Nat "mo:base/Nat";
import HashMap "mo:base/HashMap";
import Text "mo:base/Text";


actor {
    let IC =
        actor "aaaaa-aa" : actor {
            create_canister : { } -> async { canister_id : Principal };
        };

    var pageIndex = HashMap.HashMap<Text, Principal>(0, Text.equal, Text.hash);

    public func initialize() : async Bool {
        // if already initialized, return false
        // todo create index page
        // use the ic management canister:
        // https://smartcontracts.org/docs/current/references/ic-interface-spec/#ic-management-canister
        // todo return true

       if (Nat.greater(pageIndex.size(), 0)) {
           return false;
       } else {            
            pageIndex := HashMap.HashMap<Text, Principal>(0, Text.equal, Text.hash);
            return true;
        };
    };

    public query func getIndexPagePrincipal() : async ?Principal {
        // todo if index page has been created, return it,
        // otherwise null.
        throw Error.reject("poop getIndex");
    };

    public query func getPagePrincipal(name: Text) : async ?Principal {
        // todo: verify user's input
        return pageIndex.get(name);
    };

    // Returns a new Principal on success, null otherwise.
    public func createPage(name: Text) : async ?Principal {
        // todo: verify user's input
        let maybe_page = pageIndex.get(name);
        switch(maybe_page) {
            case null {  };
            case (?_) { throw Error.reject("page already exist"); };
        };

        Debug.print("balance before: " # Nat.toText(Cycles.balance()));

        Cycles.add(Cycles.balance()/2);
        let newPageCanister = await IC.create_canister({});

        Debug.print("balance after: " # Nat.toText(Cycles.balance()));

        pageIndex.put(name, newPageCanister.canister_id);

        for ((name, pagePrincipal) in pageIndex.entries()) {
            Debug.print("pageName: " # name # ", pagePricipal:" # Principal.toText(pagePrincipal) # " ");
        };

        return ?newPageCanister.canister_id;
    };    
};
