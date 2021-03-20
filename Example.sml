structure Example =
struct

(*
Small demonstration of how to use Wpp.

An often occurring challenge is to format if-then-else nicely, so that
is mainly what we'll demonstrate,
*)

local
    structure U = Utility
    open U (* only for the infixes amd $, but I'm lazy and just opens the whole thing *)
    infix ^^ ^+^ ^/^ == ** ++ --
in

datatype Ast = Var  of string
             | Lit  of int
             | Opr  of Ast * string * Ast
             | Cond of Ast * Ast * Ast

fun toDoc ast =
    case ast of
        Var v => $v
      | Lit n => Wpp.int n
      | Opr(x, opr, y)  => U.bin toDoc ($opr) (x, y)
      | Cond(test, pos, neg) =>
        Wpp.group ((U.block 2 ($"if"   ^+^ toDoc test)) ^+^
                   (U.block 2 ($"then" ^+^ toDoc pos))  ^+^
                   (U.block 2 ($"else" ^+^ toDoc neg)))

(* AST for `if (x > y) then x+1 else y*z` *)
val maxEx = Cond(Opr(Var"x", ">", Var"y"),
                 Opr(Var"x", "+", Lit 1),
                 Opr(Var"y", "*", Var"z"))
val maxDoc = toDoc maxEx
val maxS50 = Wpp.toString 50 maxDoc (* equals "if (x > y) then (x + 1) else (y * z)\n" *)
val maxS30 = Wpp.toString 30 maxDoc (* equals "if (x > y)\nthen (x + 1)\nelse (y * z)\n" *)
val maxS10 = Wpp.toString 10 maxDoc (* equals "if (x > y)\nthen\n  (x + 1)\nelse\n  (y * z)\n" *)


end
end
