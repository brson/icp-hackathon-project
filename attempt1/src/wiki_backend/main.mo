import Blob "mo:base/Blob";
import Principal "mo:base/Principal";
import Error "mo:base/Error";
import Cycles "mo:base/ExperimentalCycles";
import Debug "mo:base/Debug";
import Nat "mo:base/Nat";
import Nat8 "mo:base/Nat8";
import HashMap "mo:base/HashMap";
import Text "mo:base/Text";
import Array "mo:base/Array";
import Iter "mo:base/Iter";
import Result "mo:base/Result";
import IC "ic:aaaaa-aa";

actor Self {
    // todo: make it stable & HashMap -> TrieMap
    var pageIndex = HashMap.HashMap<Text, Principal>(0, Text.equal, Text.hash);
    var pageIndexCanisterId : ?Principal = null;
    var pageBackendWasmBlob : ?Blob = null;
    
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

    // for didc to send pageBackend wasm blob for initialization
    public func initWasmBlob(wasmModuleBlob : Blob) : async Bool {
        pageBackendWasmBlob := ?wasmModuleBlob;

        switch(pageBackendWasmBlob) {
            case null {};
            case (?pageBackendWasmBlob) {
                Debug.print("pageBackendWasmBlob: " # Nat.toText(pageBackendWasmBlob.size()));
            };
        };

        return true;
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
        Debug.print("balance: " # Nat.toText(Cycles.balance()));

        await IC.provisional_top_up_canister({amount = 100_000_000_000_000; canister_id = selfPrincipal});
        Debug.print("balance after top_up: " # Nat.toText(Cycles.balance()));
        
        Debug.print("balance before creating page: " # Nat.toText(Cycles.balance()));
        Cycles.add(Cycles.balance()/2);

        let newPageCanister = await IC.create_canister({ settings = null });
        Debug.print("balance after creating page: " # Nat.toText(Cycles.balance()));

        // check the new canister's status
        let status = await IC.canister_status(newPageCanister);
        let controllers = status.settings.controllers;
        for (controller in Iter.fromArray(controllers)) {
            Debug.print("controller in settings: " # Principal.toText(controller));
        };

        switch(pageBackendWasmBlob) {
            case null {
                // panic
            };
            case (?pageBackendWasmBlob) {
                let argBlob : Blob = "";
                await initPage(newPageCanister.canister_id, pageBackendWasmBlob, argBlob);
            };
        };
        
        pageIndex.put(name, newPageCanister.canister_id);

        for ((name, pagePrincipal) in pageIndex.entries()) {
            Debug.print("pageName: " # name # ", pagePricipal:" # Principal.toText(pagePrincipal) # " ");
        };

        return ?newPageCanister.canister_id;
    };    

    /// Struct used for encoding/decoding
    /// `(record {
    ///     mode : variant { install; reinstall; upgrade };
    ///     canister_id: principal;
    ///     wasm_module: blob;
    ///     arg: blob;
    ///     compute_allocation: opt nat;
    ///     memory_allocation: opt nat;
    ///     query_allocation: opt nat;
    /// })`
    func initPage(newPageCanister: Principal, wasmModuleBlob: Blob, argBlob: Blob) : async () {
        let cid = {canister_id = newPageCanister};
        let oldStatus = await IC.canister_status(cid);
        Debug.print("status memory_size: " # Nat.toText(oldStatus.memory_size));
        Debug.print("status cycles: " # Nat.toText(oldStatus.memory_size));

        let selfPrincipal = Principal.fromActor(Self);
        await IC.provisional_top_up_canister({amount = 100_000_000_000_000; canister_id = selfPrincipal});
        Cycles.add(50_000_000_000_000);

        // todo: handle the result
        let installCodeResult = await IC.install_code({
            mode = #install;
            canister_id = newPageCanister;
            wasm_module = wasmModuleBlob;
            arg = argBlob;
            memory_allocation = ?1073741824;
        });

        let newStatus = await IC.canister_status(cid);
        Debug.print("new status memory_size: " # Nat.toText(newStatus.memory_size));
        Debug.print("new status cycles: " # Nat.toText(newStatus.memory_size));
    };
};
