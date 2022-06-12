import Blob "mo:base/Blob";
import Principal "mo:base/Principal";
import Error "mo:base/Error";
import Cycles "mo:base/ExperimentalCycles";
import Debug "mo:base/Debug";
import Nat "mo:base/Nat";
import HashMap "mo:base/HashMap";
import Text "mo:base/Text";
import Array "mo:base/Array";
import Iter "mo:base/Iter";
import Result "mo:base/Result";
import IC "ic:aaaaa-aa";
// import P "Prelude";

actor Self {
    // todo: make it stable & HashMap -> TrieMap
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

        let selfPrincipal = Principal.fromActor(Self);
        Debug.print("selfPrincipal: " # Principal.toText(selfPrincipal));
        
        Debug.print("balance before: " # Nat.toText(Cycles.balance()));
        Cycles.add(Cycles.balance()/2);

        let newPageCanister = await IC.create_canister({ settings = null });
        Debug.print("balance after: " # Nat.toText(Cycles.balance()));

        // check the new canister's status
        let status = await IC.canister_status(newPageCanister);
        let controllers = status.settings.controllers;
        for (controller in Iter.fromArray(controllers)) {
            Debug.print("controller in settings: " # Principal.toText(controller));
        };

        // todo: install wasm blob to the new canister
        let wasmModuleBlob = Principal.toBlob(selfPrincipal);
        let argBlob = Blob.fromArray([1, 2, 3]);
        let installCodeResult = await IC.install_code({
            mode = #install;
            canister_id = newPageCanister.canister_id;
            wasm_module = wasmModuleBlob;
            arg = argBlob;
        });
        let newStatus = await IC.canister_status(newPageCanister);
        Debug.print("new status memory_size: " # Nat.toText(newStatus.memory_size));
        Debug.print("new status cycles: " # Nat.toText(newStatus.memory_size));
        
        pageIndex.put(name, newPageCanister.canister_id);

        for ((name, pagePrincipal) in pageIndex.entries()) {
            Debug.print("pageName: " # name # ", pagePricipal:" # Principal.toText(pagePrincipal) # " ");
        };

        return ?newPageCanister.canister_id;
    };    
};
