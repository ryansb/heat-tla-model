-------------------------------- MODULE Heat --------------------------------
EXTENDS Naturals, TLC, Sequences, FiniteSets

CONSTANT N, Stack, deps

VARIABLES status, locks, Q

vars == << status, locks, Q >>

ASSUME IsFiniteSet(Stack)
\* deps is a function of r |-> {resources}
ASSUME IsFiniteSet(deps)

Status == {"READY", "IN_PROGRESS", "COMPLETE"}
Locks == [status: "FREE"] \cup [status: "BUSY", traversal: Nat]

Init ==
  (* Here we define the functions that will let our logic run              *)
  (* status is a function that, given a resource, will tell us its state   *)
  /\ status = [x \in Stack |-> "READY"]
  (* locks are the underlying place we store sync points free/busy state   *)
  /\ locks = [x \in Stack |-> "FREE"]
  (* Q is just a work queue of resource IDs, and stands in for the time    *)
  (* between a lock being acquired and the work being completed.           *)
  /\ Q = <<>>

Complete(parent) ==
  (* For a given resource, it is complete if it and all children are done  *)
  /\ \A r \in deps[parent]: status[r] = "COMPLETE"
  /\ status[parent] = "COMPLETE"

ResReady[r \in Stack] ==
  (* Readiness is defined as all dependencies being ready                  *)
  /\ status[r] = "READY"
  /\ \A d \in deps[r]: status[d] = "COMPLETE"

BeginAct(r) ==
  (* Perform an action on a resource, in this (simple) case the only       *)
  (* action is to satisfy the resource after ensuring the syncpoint is not *)
  (* in use by another traversal                                           *)
  (* The action itself is not executed here, but is enqueued to be done by *)
  (* the heat engine *)
  /\ locks[r] = "FREE"
  /\ ResReady[r]
  (* Now we acquire the lock for our traversal                             *)
  /\ locks' = [locks EXCEPT ![r] = "BUSY"]
  (* And enqueue the resource to be worked on                              *)
  /\ Q' = Append(Q, r)
  /\ UNCHANGED status

Act == 
  LET
    r == Head(Q)
  IN
  /\ status' = [status EXCEPT ![r] = "COMPLETE"]
  (* Take off the head item, since we just completed it                    *)
  /\ Q' = Tail(Q)
  (* Release the syncpoint now that the work is complete                   *)
  /\ locks' = [locks EXCEPT ![r] = "FREE"]


TypeOK ==
  /\ \A d \in deps: d \in SUBSET Stack
  /\ Q \in Seq(Stack)
  (* Ensure a resource can never be COMPLETE until all its deps are        *)
  /\ ~\E r \in Stack: status[r] = "COMPLETE" /\ ~(\A d \in deps[r]: ResReady[d])

Termination ==
  /\ \A r \in Stack: status[r] = "COMPLETE"
  /\ UNCHANGED vars

Next ==
  (* The next step is either to ready a resource, or to enqueue an action. *)
  (* There isn't a qualification on which resources can be acted on        *)
  (* because the syncpoint being free and deps being ready are both        *)
  (* preconditions.                                                        *)
  \/ (Q # <<>> /\ Act)
  \/ (\E r \in Stack: BeginAct(r))
  \/ Termination


(* Theorems *)
NonTriviality ==
  /\ Stack # {}

Completeness ==
  \A r \in Stack: status[r] = "COMPLETE"

Spec == Init /\ [][Next]_vars

THEOREM Spec => TypeOK /\ NonTriviality 
=============================================================================
\* Modification History
\* Last modified Tue Feb 10 13:54:13 EST 2015 by ryansb
\* Created Fri Jan 23 16:29:46 EST 2015 by ryansb
