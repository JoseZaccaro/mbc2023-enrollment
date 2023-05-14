import Type "Types";
import Buffer "mo:base/Buffer";
import Result "mo:base/Result";
import Array "mo:base/Array";
import Iter "mo:base/Iter";
import HashMap "mo:base/HashMap";
import Nat "mo:base/Nat";
import Nat32 "mo:base/Nat32";
import Principal "mo:base/Principal";
import Hash "mo:base/Hash";
import Blob "mo:base/Blob";
import Int "mo:base/Int";

actor class StudentWall() {
  type Message = Type.Message;
  type Content = Type.Content;
  type Survey = Type.Survey;
  type Answer = Type.Answer;

  var messageId : Nat = 0;
  let wall = HashMap.HashMap<Nat, Message>(1, Nat.equal, Hash.hash);

  // Add a new message to the wall
  public shared ({ caller }) func writeMessage(c : Content) : async Nat {
    let message : Message = {
      content = c;
      vote = 0;
      creator = caller;
    };
    wall.put(messageId, message);
    messageId := messageId + 1;
    return messageId - 1;
  };

  // Get a specific message by ID
  public shared query func getMessage(messageId : Nat) : async Result.Result<Message, Text> {
    let message : ?Message = wall.get(messageId);
    // if (message != null) {
    //   return #ok(message);
    // };

    switch (message) {
      case (null) {
        return #err("Message not found");
      };
      case (?msg){
        return #ok(msg);
      }
    };
  };

  // Update the content for a specific message by ID
  public shared ({ caller }) func updateMessage(messageId : Nat, c : Content) : async Result.Result<(), Text> {
    let message : ?Message = wall.get(messageId);
    switch (message) {
      case (null) {
        return #err("Message not found, cannot update message");
      };
      case (?msg) {
        if (msg.creator == caller) {
          let updateMessage : Message = {
            content = c;
            creator = msg.creator;
            vote = msg.vote;
          };
          wall.put(messageId, updateMessage);
          return #ok();
        };
        return #err("You do not have permission to update this message.");
      };
    };
    // if (message != null) {
    //   for ((key, value) in wall.entries()) {
    //     if (messageId == key and value.creator == caller) {
    //       let updateMessage : Message = {
    //         content = c;
    //         creator = value.creator;
    //         vote = value.vote;
    //       };
    //       wall.put(messageId, updateMessage);
    //     };
    //   };
    //   return #ok();
    // } else {
    //   return #err("You do not have permission to update this message.");
    // };
    // return #err("Message not found, cannot update message");
  };

  // Delete a specific message by ID
  public shared ({ caller }) func deleteMessage(messageId : Nat) : async Result.Result<(), Text> {
    let message : ?Message = wall.get(messageId);
    if (message != null) {
      for ((key, value) in wall.entries()) {
        if (messageId == key and value.creator == caller) {
          ignore wall.remove(messageId);
        };
      };
      return #ok();
    } else {
      return #err("You do not have permission to update this message.");
    };
    return #err("Message not found, cannot update message");
  };

  // Voting
  public func upVote(messageId : Nat) : async Result.Result<(), Text> {
    let message : ?Message = wall.get(messageId);
    if (message != null) {
      for ((key, value) in wall.entries()) {
        if (messageId == key) {
          let messageUpdate : Message = {
            content = value.content;
            vote = value.vote + 1;
            creator = value.creator;
          };
          wall.put(key, messageUpdate);
          return #ok();
        };
      };
    };
    return #err("Message not found, cannot vote up message");
  };

  public func downVote(messageId : Nat) : async Result.Result<(), Text> {
    let message : ?Message = wall.get(messageId);
    if (message != null) {
      for ((key, value) in wall.entries()) {
        if (messageId == key) {
          let messageUpdate : Message = {
            content = value.content;
            vote = value.vote - 1;
            creator = value.creator;
          };
          wall.put(key, messageUpdate);
          return #ok();
        };
      };
    };
    return #err("Message not found, cannot vote up message");
  };

  // Get all messages
  public func getAllMessages() : async [Message] {

    let allMessages = Buffer.Buffer<Message>(1);
    for ((value) in wall.vals()) {
      allMessages.add(value);
    };

    return Buffer.toArray(allMessages);
  };

  // Get all messages ordered by votes
  public func getAllMessagesRanked() : async [Message] {
    let allMessages = Buffer.Buffer<Message>(1);
    for ((value) in wall.vals()) {
      allMessages.add(value);
    };

    allMessages.sort(
      func(a : Message, b : Message) {
        if (a.vote < b.vote) {
          return #greater;
        };
        if (a.vote > b.vote) {
          return #less;
        };
        // if (a.vote == b.vote) {
        return #equal;
        // };
      }
    );
    return Buffer.toArray(allMessages);
  };
};
