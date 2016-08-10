# ppx_format

Simple syntax for string formatters. This extension features a syntax for string formatting inspired by Python. While processing the source code, each occurence of `"..." % (a, b, c)` is converted into `Printf.sprintf "..." a b c`.

**Examples**:

```ocaml
(* Format with one argument. *)
let () =
  let name = Unix.getenv "USER" in
  print_endline ("Hello, %s!" % name)

(* Format with multiple arguments. *)
let () =
  let name = Unix.getenv "USER" in
  let time = Unix.time () in
  let cdir = Unix.getenv "PWD" in
  print_endline ("Hello %s! Current UNIX time is %f. Your current directory is %s" % (name, time, cdir))

(* Partially applied format. *)
let () =
  let hello = (%) "Hello, %s!" in
  print_endline (hello "world")
```
