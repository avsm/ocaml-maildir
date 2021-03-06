(* The MIT License (MIT)

   Copyright (c) 2014-2017 Nicolas Ojeda Bar <n.oje.bar@gmail.com>

   Permission is hereby granted, free of charge, to any person obtaining a copy
   of this software and associated documentation files (the "Software"), to deal
   in the Software without restriction, including without limitation the rights
   to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
   copies of the Software, and to permit persons to whom the Software is
   furnished to do so, subject to the following conditions:

   The above copyright notice and this permission notice shall be included in all
   copies or substantial portions of the Software.

   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
   IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
   FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
   AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
   LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
   OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
   SOFTWARE. *)

(** Library to access mailbox folders in Maildir format *)

(** The type of Maildir folders. *)
type t

(** The type of message unique identifiers *)
type uid =
  string

(** Message flags *)
type flag =
  | NEW
  | SEEN
  | REPLIED
  | FLAGGED
  | TRASHED
  | PASSED
  | DRAFT

(** A message *)
type msg =
  {
    uid: uid;
    filename: string;
    flags: flag list;
  }

exception Message_not_found of string

val create: string -> t
(** [create path] returns an object that can be used to access a Maildir
    directory at [path]. The directory [path] and its subdirectories "tmp",
    "cur", and "new" will be created if they do not exist. *)

val update: t -> unit
(** [update m] updates the cached information to reflect the actual contents of
    the Maildir folder.  This is only needed if more than one program is
    accessing the folder. *)

val add: t -> ?date:float -> string -> uid
(** [add m ?date data] adds the message with contents [data].

    Returns the uid of the newly inserted message. *)

val get: t -> uid -> string
(** [get m uid] retrieves the filename of the message with uid [uid].

    Raises [Message_not_found uid] if the message is not found. *)

val remove: t -> uid -> unit
(** [remove m uid] removes the message with uid [uid].

    Raises [Message_not_found uid] if the message is not found. *)

val set_flags: t -> uid -> flag list -> unit
(** [set_flags m uid flags] changes sets the flags of the message with uid [uid]
    to [flags].

    Raises [Message_not_found uid] if the message is not found. *)

val get_flags: t -> uid -> flag list
(** [fet_flags m uid] returns the list of flags of message with uid [uid].

    Raises [Message_not_found uid] if the message is not found. *)

val iter: (msg -> unit) -> t -> unit
(** [iter f m] is [f msg1; f msg2; ...; f msgN] where [msg1, ..., msgN] are the
    messages in [m] (in some unspecified order). *)

val fold: (msg -> 'a -> 'a) -> t -> 'a -> 'a
(** [fold f m x] is [(f msg1 (f msg2 (... (f msgN x))))] where [msg1 ... msgN]
    are the messages in [m]. *)
