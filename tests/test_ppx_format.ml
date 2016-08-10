
let () =
  let name = Unix.getenv "USER" in
  let time = Unix.time () in
  let cdir = Unix.getenv "PWD" in
  print_endline ("Hello %s! Current UNIX time is %f. Your current directory is %s" % (name, time, cdir))

let () =
  let name = Unix.getenv "USER" in
  print_endline ("Hello, %s!" % name)

let () =
  let name = Unix.getenv "USER" in
  print_endline ((%) "Hello, %s!" name)

let () =
  let formatter = (%) "Hello, %s!" in
  print_endline (formatter "world")

