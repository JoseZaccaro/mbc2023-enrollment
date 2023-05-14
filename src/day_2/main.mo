import Time "mo:base/Time";
import Buffer "mo:base/Buffer";
import Result "mo:base/Result";
import Array "mo:base/Array";
import Debug "mo:base/Debug";

actor class Homework() {
    public type Time = Time.Time;
    public type Homework = {
        title : Text;
        description : Text;
        dueDate : Time;
        completed : Bool;
    };

    let homeworkDiary = Buffer.Buffer<Homework>(0);

    // Add a new homework task
    public shared func addHomework(homework : Homework) : async Nat {
        homeworkDiary.add(homework);
        return homeworkDiary.size() - 1;
    };

    // Get a specific homework task by id
    public shared query func getHomework(id : Nat) : async Result.Result<Homework, Text> {
        if (id >= 0 and homeworkDiary.getOpt(id) != null) {
            return #ok(homeworkDiary.get(id));
        };
        return #err("Homework doesn't exist get");
    };

    // Update a homework task's title, description, and/or due date
    public shared func updateHomework(id : Nat, homework : Homework) : async Result.Result<(), Text> {
        if (id >= 0 and homeworkDiary.getOpt(id) != null) {
            homeworkDiary.put(id, homework);
            return #ok();
        };

        return #err("Homework doesn't exist update");
    };

    // Mark a homework task as completed
    public shared func markAsCompleted(id : Nat) : async Result.Result<(), Text> {

        if (id >= 0 and homeworkDiary.getOpt(id) != null) {
            var aux : Homework = homeworkDiary.get(id);
            var completedHomework : Homework = {
                title = aux.title;
                dueDate = aux.dueDate;
                description = aux.description;
                completed = true;
            };
            homeworkDiary.put(id, completedHomework);
            return #ok();
        };
        return #err("Homework doesn't exist mark");
    };

    // Delete a homework task by id
    public shared func deleteHomework(id : Nat) : async Result.Result<(), Text> {
        if (id >= 0 and homeworkDiary.getOpt(id) != null) {
            ignore homeworkDiary.remove(id);
            return #ok();
        };
        return #err("Homework doesn't exist delete");
    };

    // Get the list of all homework tasks
    public shared query func getAllHomework() : async [Homework] {
        return Buffer.toArray(homeworkDiary);
    };

    // Get the list of pending (not completed) homework tasks
    public shared query func getPendingHomework() : async [Homework] {
        let pendingHomework = Buffer.mapFilter<Homework, Homework>(
            homeworkDiary,
            func(x) {
                if (x.completed == false) {
                    ?x;
                } else {
                    null;
                };
            },
        );

        return pendingHomework.toArray();
    };

    // Search for homework tasks based on a search terms
    public shared query func searchHomework(searchTerm : Text) : async [Homework] {
        let searchedHomework = Buffer.mapFilter<Homework, Homework>(
            homeworkDiary,
            func(x) {
                if (x.title == searchTerm or x.description == searchTerm) {
                    ?x;
                } else {
                    null;
                };
            },
        );
        return Buffer.toArray(homeworkDiary);
    };
};
