structure Utility =
struct
local open Wpp in
infixr 6 ^^
infix ^+^ ^/^ == ** ++ --

(* Some convenience functions for pp *)
val $     = text
val ws    = group(break 1 0) (* space or break*)
val br    = break 0 0
val sp    = break 1 0
val nl    = break 100000 0   (* an almost certain forced newline *)
val comma = $"," ^^ ws
val semi  = $";" ^^ ws
val colon = $":" ^^ ws


(* Derived reusable combinators *)
fun x ^+^ y = x ^^ sp ^^ y
fun x ^/^ y = x ^^ ws ^^ y

fun block i = nest i o group
val block1 = block 1

fun around left right doc = block1 ((group (left ^^ doc)) ^^ right)

fun opt ppr NONE     = Wpp.empty
  | opt ppr (SOME x) = ppr x

fun list left right sep elem =
	  let fun elements [a]    = elem a ^^ right
	        | elements (a::s) = group (elem a ^^ sep) ^^ elements s
          | elements _      = raise Fail "Impossible"

	      fun list nil = left ^^ right
	        | list l   = left ^^ nest 1 (elements l)
	  in  list
	  end

fun list' sep elem =
    let fun elements []      = empty
          | elements [x]     = elem x
	        | elements (x::xs) = group (elem x ^^ sep) ^^ elements xs
    in  elements
    end


(* Example usage of the combinators *)

fun x == y  = x ^^ text" = " ^^ y
fun x ** y  = x ^^ text" *" ^/^ y
fun x ++ y  = x ^^ text" +" ^/^ y
fun x -- y  = x ^^ text" -" ^/^ y

val paren = around ($"(") ($")")
val curly = around ($"{") ($"}")
val brack = around ($"[") ($"]")

fun bin f opr (x, y) = paren(f x ^+^ opr ^+^ f y)
fun binnp f opr (x, y) = group(f x ^+^ opr ^+^ f y)


end
end
