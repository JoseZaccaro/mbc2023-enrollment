import Float "mo:base/Float";
// actor {
// Ejercicios "Codign Challenges";
//   var counter : Nat = 0;

//   public query func greet(name : Text) : async Text {
//     return "Hello, " # name # "!";
//   };

//   public query func multiply(n : Nat, m : Nat) : async Nat {
//     return n * m;
//   };

//   public query func volume(n : Nat) : async Nat {
//     return n * n * n;
//   };

//   public query func hours_to_minutes(n : Nat) : async Nat {
//     return n * 60;
//   };

//   public func set_counter(n : Nat) : async () {
//     counter := n;
//   };

//   public func get_counter() : async Nat {
//     return counter;
//   };

//   public func test_divide(n : Nat, m : Nat) : async Bool {
//     let r : Nat = n % m;
//     let t : Bool = r == 0;
//     return t;
//   };

//   public func is_even(n : Nat) : async Bool {
//     let e : Bool = await test_divide(n, 2);
//     return e;
//   };
// };

actor {

  var counter : Float = 0.0;

  public shared func add(x : Float) : async Float {
    counter += x;
    return counter;
  };
  public shared func sub(x : Float) : async Float {
    counter -= x;
    return counter;
  };
  public shared func mul(x : Float) : async Float {
    counter *= x;
    return counter;
  };
  public shared func div(x : Float) : async Float {
    counter /= x;
    return counter;
  };
  public shared func reset() : async () {
    counter := 0;
  };
  public shared query func see() : async Float {
    return counter;
  };
  public shared func power(x : Float) : async Float {
    counter := Float.pow(counter, x);
    return counter;
  };
  public shared func sqrt() : async Float {
    counter := Float.sqrt(counter);
    return counter;
  };
  public shared func floor() : async Int {
    counter := Float.floor(counter);
    return Float.toInt(counter);
  };
};
