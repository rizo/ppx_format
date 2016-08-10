
open Ast_helper
open Ast_mapper
open Asttypes
open Parsetree

let rec expr this e =
  match e.pexp_desc with
  (*
   *   `"..." % (a, b, c)` -> `Printf.sprintf "..." a b c`
   *   `"..." % a`         -> `Printf.sprintf "..." a`
   *)
  | Pexp_apply
      (({pexp_desc = Pexp_ident ({txt = Longident.Lident "%"} as f_ident_loc)} as f),
       (((Nolabel, {pexp_desc = Pexp_constant (Pconst_string (fmt_str, None))}) as fmt_arg) :: args)) ->

         let id = Longident.Ldot (Longident.Lident "Printf", "sprintf") in
         let f' = {f with pexp_desc = Pexp_ident {f_ident_loc with txt = id}} in
         let args' =
           match args with
           (* Multiple arguments as a tuple - extract them all as args. *)
           | [(Nolabel, {pexp_desc = Pexp_tuple exp_list})] ->
             List.map (fun e -> (Nolabel, e)) exp_list

           (* Single format argument as in `"..." % a` - use it directly. *)
           | [(Nolabel, single_exp)] -> [(Nolabel, single_exp)]

           (* Somehow a label was used with the format argument: `(%) "..." ~xxx:a`.
              It's just silly, I'll fail. *)
           | [(_label, _single_exp)] ->
             failwith "arguments with labels in format syntax"

           (* So you must have used `(%) fmt_str`. Really? Ok, I'll use id. *)
           | [] -> []

           (* Multiple arguments but NOT as a tuple. It's an invalid syntax. *)
           | _::_ -> failwith "invalid format syntax: please use `fmt % (a, b, c)`." in

         Exp.apply f' (fmt_arg :: args')
  | _ -> default_mapper.expr this e


let () =
  register "ppx_monad" (fun argv -> { default_mapper with expr })

