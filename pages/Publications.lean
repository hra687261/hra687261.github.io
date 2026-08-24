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

/-- A "BibTeX" button that expands a selectable/copyable BibTeX block (with a
copy-to-clipboard button) when clicked. -/
def bibToggle (name : String) : Verso.Output.Html :=
  .tag "button" #[
    ("type", "button"),
    ("class", "link-badge bibtex-toggle"),
    ("onclick", s!"document.getElementById('bibtex-body-{name}').classList.toggle('open')")
  ] (.text true "BibTeX")

/-- A "BibTeX" block. -/
def bibBody (name bibtex : String) : Verso.Output.Html :=
  .tag "div" #[("class", "bibtex-body"), ("id", s!"bibtex-body-{name}")] <| .seq #[
    .tag "button" #[
      ("type", "button"),
      ("class", "bibtex-copy"),
      ("title", "Copy BibTeX"),
      ("aria-label", "Copy BibTeX"),
      ("onclick", r#"navigator.clipboard.writeText(this.nextElementSibling.textContent).then(() => {this.classList.add('copied'); setTimeout(() => this.classList.remove('copied'), 1500)})"#)
    ] <| .seq #[copyIcon, checkIcon],
    .tag "pre" #[] (.text true bibtex)
  ]

/-- Maps each bibtex entry name NAME to the content of
`../assets/papers/NAME.bib`. -/
def bibMap : Std.HashMap String String :=
  Std.HashMap.ofList (include_dir_str_pairs "../assets/papers" ".bib")

def checkBibName (usage name : String) (stxs : Lean.TSyntaxArray `inline) :
    Verso.Doc.Elab.DocElabM Unit := do
  checkNoContents usage stxs
  if bibMap[name]?.isNone then
    throwError m! "Unknown BibTeX entry {name}. \
      Known entries: {bibMap.toList.map Prod.fst}"

/-- `{bib "NAME"}[]` looks `NAME` up in `bibMap` and renders the inline toggle
badge for it. Pair with a `{bibBox "NAME"}[]` on its own line right after the
badges line, to render the box the toggle reveals. -/
@[role]
def bib : Verso.Doc.Elab.RoleExpanderOf NameArg
  | {name}, stxs => do
    checkBibName "{bib \"NAME\"}[]" name stxs
    ``(Verso.Doc.Inline.other
        (InlineExt.blob (bibToggle $(Lean.quote name)))
        #[])

/-- `{bibBox "NAME"}[]` renders the actual citation box for `NAME`, which
`{bib "NAME"}[]`'s toggle badge reveals. -/
@[role]
def bibBox : Verso.Doc.Elab.RoleExpanderOf NameArg
  | {name}, stxs => do
    checkBibName "{bibBox \"NAME\"}[]" name stxs
    ``(Verso.Doc.Inline.other
        (InlineExt.blob (bibBody $(Lean.quote name) (bibMap.get! $(Lean.quote name))))
        #[])

/-- An invisible in-page anchor: `{anchor "id"}[]` makes it possible to point
straight to this point via `#id` (e.g. `/Publications/#2026_TACAS`). -/
def anchorSpan (id : String) : Verso.Output.Html :=
  .tag "span" #[("id", id), ("class", "anchor")] .empty

@[role]
def anchor : Verso.Doc.Elab.RoleExpanderOf NameArg
  | {name}, stxs => do
    checkNoContents "{anchor \"id\"}[]" stxs
    ``(Verso.Doc.Inline.other
        (InlineExt.blob (anchorSpan $(Lean.quote name)))
        #[])

#doc (Page) "Publications" =>

# Publications

{anchor "2026"}[]

## 2026

- {anchor "2026_Colibri2"}[]*colibri2: A CP solver for SMT problems* {tag "Preprint"}[] {blob br}[]
   François Bobot, *Hichem Rami Ait-El-Hara*, and Bruno Marre. {blob br}[]
  {link "./assets/papers/2026_Colibri2.pdf" "Paper"}[] {bib "2026_Colibri2"}[] {link "https://cea.hal.science/cea-05644448" "HAL"}[]
{bibBox "2026_Colibri2"}[]

{blob hr}[]

- {anchor "2026_TACAS"}[]*Smt.ml: A Multi-Backend Frontend for SMT Solvers in OCaml* {blob br}[]
  João Madeira Pereira, Filipe Marques, Pedro Adão, *Hichem Rami Ait-El-Hara*, Léo Andrès, Arthur Carcano, Pierre Chambart, Petar Maksimović, Nuno Santos, and José Fragoso Santos. {blob br}[]
  TACAS @ ETAPS 2026: Tools and Algorithms for the Construction and Analysis of Systems: 32nd International Conference, Held as Part of the International Joint Conferences on Theory and Practice of Software, ETAPS 2026. {blob br}[]
  {link "./assets/papers/2026_TACAS.pdf" "Paper"}[] {bib "2026_TACAS"}[] {link "https://link.springer.com/chapter/10.1007/978-3-032-22752-2_2" "Publisher Version"}[] {link "https://inria.hal.science/hal-04761767v2" "HAL"}[]
{bibBox "2026_TACAS"}[]

{blob hr}[]

{anchor "2025"}[]

## 2025

- {anchor "PhD_manuscript"}[]*Theory of sequences tailored for program verification* {blob br}[]
  *Hichem Rami Ait-El-Hara*. {blob br}[]
  PhD manuscript, published in Nov 2025. {blob br}[]
  {link "https://theses.fr/2025UPASG067" "Archive"}[] {bib "PhD_manuscript"}[] {link "./assets/papers/PhD_manuscript.pdf" "Manuscript"}[] {link "./assets/papers/PhD_defense_slides.pdf" "Slides"}[] {link "https://theses.hal.science/tel-05383515" "HAL"}[] {page_link Defense}[Defense Page]
{bibBox "PhD_manuscript"}[]

{blob hr}[]

- {anchor "2025_AI"}[]*Reasoning over n-Indexed Sequences in SMT* {blob br}[]
  *Hichem Rami Ait-El-Hara*, François Bobot, and Guillaume Bury. {blob br}[]
  Acta Informatica — Selected Extended Papers of SMT 2024 and Related Papers. {blob br}[]
  {link "./assets/papers/2025_AI.pdf" "Paper"}[] {bib "2025_AI"}[] {link "https://link.springer.com/article/10.1007/s00236-025-00496-w" "Publisher Version"}[]
{bibBox "2025_AI"}[]

{blob hr}[]

- {anchor "2025_SMT"}[]*Constraint Propagation for Bit-Vectors in Alt-Ergo* {blob br}[]
  *Hichem Rami Ait-El-Hara*, Guillaume Bury, Basile Clément and Pierre Villemot. {blob br}[]
  SMT 2025: 23rd International Workshop on Satisfiability Modulo Theories. {blob br}[]
  {link "./assets/papers/2025_SMT.pdf" "Paper"}[] {bib "2025_SMT"}[] {link "https://ceur-ws.org/Vol-4008/#SMT_paper20" "Publisher Version"}[]
{bibBox "2025_SMT"}[]

{blob hr}[]

- {anchor "2025_PLDI"}[]*Relational Abstractions Based on Labeled Union-Find* {blob br}[]
  Dorian Lesbre, Matthieu Lemerre, *Hichem Rami Ait-El-Hara*, and François Bobot. {blob br}[]
  PLDI 2025: 46th ACM SIGPLAN Conference on Programming Language Design and Implementation. {blob br}[]
  {link "./assets/papers/2025_PLDI.pdf" "Paper"}[] {bib "2025_PLDI"}[] {link "https://dl.acm.org/doi/10.1145/3729298" "Publisher Version"}[] {link "https://hal.science/hal-05029216v1" "HAL"}[]
{bibBox "2025_PLDI"}[]

{blob hr}[]

{anchor "2024"}[]

## 2024

- {anchor "2024_SMT"}[]*An SMT Theory for n-Indexed Sequences* {blob br}[]
  *Hichem Rami Ait-El-Hara*, François Bobot, and Guillaume Bury. {blob br}[]
  SMT 2024: 22nd International Workshop on Satisfiability Modulo Theories. {blob br}[]
  {link "./assets/papers/2024_SMT.pdf" "Paper"}[] {bib "2024_SMT"}[] {link "https://ceur-ws.org/Vol-3725/#short13" "Publisher Version"}[] {link "https://hal.science/hal-04706489" "HAL"}[]
{bibBox "2024_SMT"}[]

{blob hr}[]

- {anchor "2024_LPAR"}[]*On SMT Theory Design: The Case of Sequences* {blob br}[]
  *Hichem Rami Ait-El-Hara*, François Bobot, and Guillaume Bury. {blob br}[]
  LPAR 2024: 25th Conference On Logic For Programming, Artificial Intelligence and Reasoning. {blob br}[]
  {link "./assets/papers/2024_LPAR.pdf" "Paper"}[] {bib "2024_LPAR"}[] {link "https://easychair.org/publications/paper/qdvJ" "Publisher Version"}[] {link "https://hal.science/hal-04706459" "HAL"}[]
{bibBox "2024_LPAR"}[]

{blob hr}[]

{anchor "2022"}[]

## 2022

- {anchor "2022_JFLA"}[]*Alt-Ergo-Fuzz: A fuzzer for the Alt-Ergo SMT solver* {blob br}[]
  *Hichem Rami Ait-El-Hara*, Guillaume Bury, and Steven de Oliveira. {blob br}[]
  JFLA 2022: 33èmes Journées Francophones des Langages Applicatifs. {blob br}[]
  {link "./assets/papers/2022_JFLA.pdf" "Paper"}[] {bib "2022_JFLA"}[] {link "https://hal.inria.fr/hal-03626861" "Publisher Version on HAL"}[]
{bibBox "2022_JFLA"}[]

{blob hr}[]
