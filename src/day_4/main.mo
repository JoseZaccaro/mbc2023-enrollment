import TrieMap "mo:base/TrieMap";
import Trie "mo:base/Trie";
import Result "mo:base/Result";
import Text "mo:base/Text";
import Option "mo:base/Option";
import Debug "mo:base/Debug";

import Account "Account";
// NOTE: only use for local dev,
// when deploying to IC, import from "rww3b-zqaaa-aaaam-abioa-cai"
// import BootcampLocalActor "BootcampLocalActor";

actor class MotoCoin() {
    public type Account = Account.Account;

    let ledger = TrieMap.TrieMap<Account, Nat>(Account.accountsEqual, Account.accountsHash);

    // Returns the name of the token
    public query func name() : async Text {
        return "MotoCoin";
    };

    // Returns the symbol of the token
    public query func symbol() : async Text {
        return "MOC";
    };

    // Returns the the total number of tokens on all accounts
    public func totalSupply() : async Nat {

        var totalSupply : Nat = 0;
        for (tokens in ledger.vals()) {
            totalSupply += tokens;
        };

        return totalSupply;
    };

    // Returns the default transfer fee
    public query func balanceOf(account : Account) : async (Nat) {

        let accBalance = ledger.get(account);
        switch (accBalance) {
            case (null) {
                return 0;
            };
            case (?accBalance) {
                return accBalance;
            };
        };
    };

    // Transfer tokens to another account
    public shared ({ caller }) func transfer(
        from : Account,
        to : Account,
        amount : Nat,
    ) : async Result.Result<(), Text> {

        let fromAcc = ledger.get(from);
        switch (fromAcc) {
            case (null) {
                return #err("Your account could not be found");
            };
            case (?fromAcc) {
                if (amount > fromAcc) {
                    return #err("Not enough amount for from and to");
                };
                let toAcc = ledger.get(to);
                switch (toAcc) {
                    case (null) {
                        return #err("couldn't find the account to transfer");
                    };
                    case (?toAcc) {
                        ledger.put(from, fromAcc -amount);
                        ledger.put(to, toAcc +amount);
                        return #ok();
                    };
                };

            };
        };

        return #ok;
    };

    // Airdrop 1000 MotoCoin to any student that is part of the Bootcamp.
    public func airdrop() : async Result.Result<(), Text> {
        let studentsActor = actor ("rww3b-zqaaa-aaaam-abioa-cai") : actor {
            getAllStudentsPrincipal : query () -> async [Principal];
        };
        let allStudentsPrincipals : [Principal] = await studentsActor.getAllStudentsPrincipal();
        for (studentAcc in allStudentsPrincipals.vals()) {
            let acc : Account = {
                owner = studentAcc;
                subaccount = null;
            };
            ledger.put(acc, 100);
        };
        return #ok();
    };
};
