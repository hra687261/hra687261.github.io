import VersoBlog
import Common
import Verso.Doc.ArgParse
open Verso Genre Blog

/-- `include_dir_str_pairs "dir" "ext"` lists `dir` (relative to the current
file, like `include_str`) at elaboration time and reads every file whose name
ends in `ext`, producing a `List (String × String)` of (filename without `ext`,
file content) pairs, i.e. `include_str` generalized to a whole directory. -/
elab "include_dir_str_pairs " dir:str ext:str : term => do
  let ctx ← readThe Lean.Core.Context
  let some srcDir := (System.FilePath.mk ctx.fileName).parent
    | throwError "cannot compute parent directory of `{ctx.fileName}`"
  let entries ← (srcDir / dir.getString).readDir
  let mut pairs : Array (String × String) := #[]
  let ext := ext.getString
  for e in entries do
    if e.fileName.endsWith ext then
      let contents ← IO.FS.readFile e.path
      pairs := pairs.push ((e.fileName.dropEnd ext.length).toString, contents)
  return Lean.toExpr pairs.toList

/-- A "BibTeX" badge that expands in place to a selectable/copyable
BibTeX block (with a copy-to-clipboard button) when clicked. -/
def bibtexBox (bibtex : String) : Verso.Output.Html :=
  .tag "details" #[("class", "bibtex")] <| .seq #[
    .tag "summary" #[] (.text true "BibTeX"),
    .tag "div" #[("class", "bibtex-body")] <| .seq #[
      .tag "button" #[
        ("type", "button"),
        ("class", "bibtex-copy"),
        ("title", "Copy BibTeX"),
        ("aria-label", "Copy BibTeX"),
        ("onclick", r#"navigator.clipboard.writeText(this.nextElementSibling.textContent).then(() => {this.classList.add('copied'); setTimeout(() => this.classList.remove('copied'), 1500)})"#)
      ] <| .seq #[copyIcon, checkIcon],
      .tag "pre" #[] (.text true bibtex)
    ]
  ]

/-- HashMap assocaiting each bibtex entry name NAME with its content that is read
from  "../assets/papers/NAME.bib" -/
def bibMap : Std.HashMap String Verso.Output.Html :=
  Std.HashMap.ofList <|
    (include_dir_str_pairs "../assets/papers" ".bib").map fun (name, contents) =>
      (name, bibtexBox contents)

structure BibEntry where
  name : String

instance : Verso.ArgParse.FromArgs BibEntry Verso.Doc.Elab.DocElabM where
  fromArgs := BibEntry.mk <$> .positional `name .string

/-- `{bib "NAME"}[]` looks `NAME` up in `bibMap` (built from
  `assets/papers/NAME.html`) and renders its BibTeX box. -/
@[role]
def bib : Verso.Doc.Elab.RoleExpanderOf BibEntry
  | {name}, stxs => do
    if h : stxs.size > 0 then
      Lean.logErrorAt stxs[0] "Expected no contents, usage: {bib \"NAME\"}[]"
    if bibMap[name]?.isNone  then
      throwError m! "Unknown BibTeX entry {name}. \
        Known entries: {bibMap.toList.map Prod.fst}"
    ``(Verso.Doc.Inline.other
        (InlineExt.blob (bibMap.get! $(Lean.quote name)))
        #[])

#doc (Page) "Publications" =>

# Publications

## 2026

- *Smt.ml: A Multi-Backend Frontend for SMT Solvers in OCaml* {blob br}[]
  João Madeira Pereira, Filipe Marques, Pedro Adão, *Hichem Rami Ait-El-Hara*, Léo Andrès, Arthur Carcano, Pierre Chambart, Petar Maksimović, Nuno Santos, José Fragoso Santos. {blob br}[]
  To appear in TACAS 2026: 32nd International Conference on Tools and Algorithms for the Construction and Analysis of Systems. {blob br}[]
  [Paper](./assets/papers/2026_TACAS.pdf) {bib "2026_TACAS"}[] [HAL](https://inria.hal.science/hal-04761767v2)

{blob hr}[]

## 2025

- *Theory of sequences tailored for program verification* {blob br}[]
  *Hichem Rami Ait-El-Hara*. {blob br}[]
  PhD manuscript, published in Nov 2025. {blob br}[]
  [Archive](https://theses.fr/2025UPASG067) {bib "PhD_manuscript"}[] [Manuscript](./assets/papers/PhD_manuscript.pdf) [Slides](./assets/papers/PhD_defense_slides.pdf) [HAL](https://theses.hal.science/tel-05383515) {page_link Defense}[Defense Page]

{blob hr}[]

- *Reasoning over n-Indexed Sequences in SMT* {blob br}[]
  *Hichem Rami Ait-El-Hara*, François Bobot, and Guillaume Bury. {blob br}[]
  Acta Informatica — Selected Extended Papers of SMT 2024 and Related Papers. {blob br}[]
  [Paper](./assets/papers/2025_AI.pdf) {bib "2025_AI"}[] [Publisher Version](https://link.springer.com/article/10.1007/s00236-025-00496-w)

{blob hr}[]

- *Constraint Propagation for Bit-Vectors in Alt-Ergo* {blob br}[]
  *Hichem Rami Ait-El-Hara*, Guillaume Bury, Basile Clément and Pierre Villemot. {blob br}[]
  SMT 2025: 23rd International Workshop on Satisfiability Modulo Theories. {blob br}[]
  [Paper](./assets/papers/2025_SMT.pdf) {bib "2025_SMT"}[] [Publisher Version](https://ceur-ws.org/Vol-4008/#SMT_paper20)

{blob hr}[]

- *Relational Abstractions Based on Labeled Union-Find* {blob br}[]
  Dorian Lesbre, Matthieu Lemerre, *Hichem Rami Ait-El-Hara*, and François Bobot. {blob br}[]
  PLDI 2025: 46th ACM SIGPLAN Conference on Programming Language Design and Implementation. {blob br}[]
  [Paper](./assets/papers/2025_PLDI.pdf) {bib "2025_PLDI"}[] [HAL](https://hal.science/hal-05029216v1) [Publisher Version](https://dl.acm.org/doi/10.1145/3729298)

{blob hr}[]

## 2024

- *An SMT Theory for n-Indexed Sequences* {blob br}[]
  *Hichem Rami Ait-El-Hara*, François Bobot, and Guillaume Bury. {blob br}[]
  SMT 2024: 22nd International Workshop on Satisfiability Modulo Theories. {blob br}[]
  [Paper](./assets/papers/2024_SMT.pdf) {bib "2024_SMT"}[] [HAL](https://hal.science/hal-04706489) [Publisher Version](https://ceur-ws.org/Vol-3725/#short13)

{blob hr}[]

- *On SMT Theory Design: The Case of Sequences* {blob br}[]
  *Hichem Rami Ait-El-Hara*, François Bobot, and Guillaume Bury. {blob br}[]
  LPAR 2024: 25th Conference On Logic For Programming, Artificial Intelligence and Reasoning. {blob br}[]
  [Paper](./assets/papers/2024_LPAR.pdf) {bib "2024_LPAR"}[] [HAL](https://hal.science/hal-04706459) [Publisher Version](https://easychair.org/publications/paper/qdvJ)

{blob hr}[]

## 2022

- *Alt-Ergo-Fuzz: A fuzzer for the Alt-Ergo SMT solver* {blob br}[]
  *Hichem Rami Ait-El-Hara*, Guillaume Bury, and Steven de Oliveira. {blob br}[]
  JFLA 2022: 33èmes Journées Francophones des Langages Applicatifs. {blob br}[]
  [Paper](./assets/papers/2022_JFLA.pdf) {bib "2022_JFLA"}[] [HAL](https://hal.inria.fr/hal-03626861)

{blob hr}[]
