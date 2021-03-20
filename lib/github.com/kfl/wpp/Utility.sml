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

fun block i = group o nest i
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


(* Some combinators from "A Prettier Printer" by Phil Wadler
   in "The Fun of Programming", Jeremy Gibbons and Oege de Moor (eds)

   Documentation comments adapted from the Haskell package
   mainland-pretty by Geoffrey Mainland.
*)

(* The document `folddoc f ds` obeys the laws:

   * `folddoc f [] = empty`
   * `folddoc f [d1, d2, ..., dnm1, dn] = d1 `f` (d2 `f` ... (dnm1 `f` dn))`
*)
fun folddoc _ []        = empty
  | folddoc _ [x]       = x
  | folddoc f (x :: xs) = f (x, folddoc f xs)


(* The document `spread ds` concatenates the documents `ds` with `sp`. *)
val spread = folddoc (op ^+^)

(* The document `stack ds` concatenates the documents `ds` with `newline`. *)
val stack = folddoc (fn (x,y) => x ^^ newline ^^ y)

(* The document `sep ds` concatenates the documents `ds` with the 'space'
   document as long as there is room, and uses 'newline' when there isn't. *)
val sep = group o folddoc (op ^/^)



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
