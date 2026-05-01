import VersoBlog
import Common
open Verso Genre Blog

def mapEmbed : Verso.Output.Html :=
  .tag "iframe" #[
    ("src", "https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d1168.867709196782!2d2.1932823933723298!3d48.71264116119375!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x47e678bc31c94b7f%3A0x82cc4460edf8740!2sB%C3%A2timent%20862%2C%20D128%2C%2091120%20Palaiseau!5e1!3m2!1sen!2sfr!4v1758880271048!5m2!1sen!2sfr"),
    ("width", "600"),
    ("height", "450"),
    ("style", "border:0;"),
    ("allowfullscreen", ""),
    ("loading", "lazy"),
    ("referrerpolicy", "no-referrer-when-downgrade")
  ] .empty

#doc (Page) "PhD Defense" =>
%%%
showInNav := false
%%%

# Theory of Sequences Tailored for Program Verification

By Hichem Rami AIT EL HARA

I will defend my PhD thesis on October 15th, 2025 at 14h00, in
[Amphi 33 - CEA Nano-INNOV Building 862 - 1st floor, 2 boulevard Thomas Gobert 91120 Palaiseau France.](https://maps.app.goo.gl/3R6Ldw1xpfk54QmT6) {blob br}[]
The entrance (for externals) to the site is from [Sent. de Corbeville](https://maps.app.goo.gl/a6ppU2dWvpYmjRgp8) ([on OSM](https://www.openstreetmap.org/way/140538729)), for more info on how to get there [click here](assets/other/Venir_a_Nano_INNOV_2024.pdf).

The defense will be retransmitted online on [Livestorm](https://app.livestorm.co/cea_list/soutenance-hichem-ait-el-hara?s=f4001161-2f4f-45ff-a73f-f6beed0d7e69).

If you're planning to attend in person please let me know by filling out this form: [https://framadate.org/XBMZNfCje613Bu3I](https://framadate.org/XBMZNfCje613Bu3I).

_(Note: If you are not a EU citizen, please email me at hra687261(at)gmail(dot)com so that I can make sure you can access the site)_

Both the slides and the presentation will be in *English*.

# Abstract

The choices of semantic models for a programming language have a significant effect on the efficiency of the
verification of programs in that language. Indeed, many verification techniques generate mathematical formulas
using those models. The mathematical theories used in these formulas and their shape have a direct impact on
their solvability by the used solver. The modelization of memory and data structures often uses the SMT
(Satisfiablity Modulo Theories) theory of arrays which is well established and used in SMT solvers. In this
theory, arrays associate values with indices, both of which can be of any type. The theory also allows for
operations that enable the writing and reading of the stored data. However, in the concrete programs from which
the formulas that need to be solved are produced, memory and data structures are usually limited. For example,
arrays in programming languages are usually indexed from 0 to a constant n. Although it is possible to encode
finite arrays in the SMT theory of arrays, that would not always be a satisfying solution, one reason being that
extensional equality on a finite array from 0 to n cannot be directly modelized using the extensional equality
on infinite arrays which considers all integers. An SMT theory of finite sequences, in which the sequences are
collections of values indexed over a set of contiguous integers, would simplify the solving of formulas that
modelize such data structures. Moreover, finite sequences with concatenation and extraction operators can also
be used to express particular specification languages such as separation logic. One difficulty is to choose the
set of operations on the sequences to support, since the decidability of the theory depends on them. On the
other hand, complete decidability is not always required since the formulas obtained from program verification
can have specific shapes or uses of the operations.

{blob mapEmbed}[]
