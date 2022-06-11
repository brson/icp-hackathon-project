import Principal "mo:base/Principal";
import Error "mo:base/Error";
import Cycles "mo:base/ExperimentalCycles";
import Debug "mo:base/Debug";
import Nat "mo:base/Nat";
import HashMap "mo:base/HashMap";
import Text "mo:base/Text";
import Array "mo:base/Array";

// Subset of IC management canister interface required for our use
module ManagementCanister = {
    public type wasm_module = Blob;
    public type canister_settings = {
        controller : ?[var Principal];
        compute_allocation: ?Nat;
        memory_allocation: ?Nat;
        freezing_threshold: ?Nat;
    };
};

actor Self {
    let IC = actor "aaaaa-aa" : actor {
        create_canister : {
            settings : ?ManagementCanister.canister_settings
        } -> async { canister_id : Principal };

        install_code : {
            mode : { #install; #reinstall; #upgrade };
            canister_id : Principal;
            wasm_module : ManagementCanister.wasm_module;
            arg : Blob;
        } -> async ();
        
        canister_status : { canister_id : Principal } -> async {
            settings : ?ManagementCanister.canister_settings
        };
    };

    var pageIndex = HashMap.HashMap<Text, Principal>(0, Text.equal, Text.hash);
    var pageIndexCanisterId : ?Principal = null;

    public func initialize() : async Bool {
        // if already initialized, return false
        // use the ic management canister:
        // https://smartcontracts.org/docs/current/references/ic-interface-spec/#ic-management-canister

        if (Nat.greater(pageIndex.size(), 0)) {
            return false;
        } else {
            pageIndex := HashMap.HashMap<Text, Principal>(0, Text.equal, Text.hash);

            Debug.print("balance before creating pageIndex canister: " # Nat.toText(Cycles.balance()));

            Cycles.add(Cycles.balance()/2);

            let newPageIndexCanister = await IC.create_canister({ settings = null });
            pageIndexCanisterId := ?newPageIndexCanister.canister_id;
            Debug.print("balance after creating pageIndex canister: " # Nat.toText(Cycles.balance()));
            
            return true;
        };
    };

    public query func getIndexPagePrincipal() : async ?Principal {
        return pageIndexCanisterId;
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

        let currentPrincipal = Principal.fromActor(Self);
        let newPageCanisterControllers : [var Principal] = [var currentPrincipal];

        Debug.print("balance before: " # Nat.toText(Cycles.balance()));
        Cycles.add(Cycles.balance()/2);
        let newPageCanister = await IC.create_canister({ settings = ?newPageCanisterControllers});
        Debug.print("balance after: " # Nat.toText(Cycles.balance()));

        let status = await IC.canister_status(newPageCanister);
        let status_settings = status.settings;
        switch(status_settings) {
            case null {};
            case (?settings) {
                switch(settings) {
                    case null {};
                    case (?controllerPrincipal) {
                        Debug.print("settings: " # Principal.toText(controllerPrincipal[0]));
                    }
                }
//                Debug.print("settings: " # Principal.toText(ccc));
            }
        };

        pageIndex.put(name, newPageCanister.canister_id);

        for ((name, pagePrincipal) in pageIndex.entries()) {
            Debug.print("pageName: " # name # ", pagePricipal:" # Principal.toText(pagePrincipal) # " ");
        };

        return ?newPageCanister.canister_id;
    };    
};
