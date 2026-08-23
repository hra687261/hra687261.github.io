import VersoBlog
import Verso.Doc.ArgParse

def br : Verso.Output.Html := .tag "br" #[] .empty

def hr : Verso.Output.Html := .tag "hr" #[] .empty

def copyIcon : Verso.Output.Html :=
  .text false r#"<svg class="icon-copy" xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="9" y="9" width="13" height="13" rx="2" ry="2"/><path d="M5 15H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v1"/></svg>"#

def checkIcon : Verso.Output.Html :=
  .text false r#"<svg class="icon-check" xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"/></svg>"#

/-- A small badge linking to `url`, labeled `label`. -/
def linkBadge (url label : String) : Verso.Output.Html :=
  .tag "a" #[("class", "link-badge"), ("href", url)] (.text true label)

structure NameArg where
  name : String

instance : Verso.ArgParse.FromArgs NameArg Verso.Doc.Elab.DocElabM where
  fromArgs := NameArg.mk <$> .positional `name .string

def checkNoContents (usage : String) (stxs : Lean.TSyntaxArray `inline) :
    Verso.Doc.Elab.DocElabM Unit := do
  if h : stxs.size > 0 then
    Lean.logErrorAt stxs[0] s!"Expected no contents, usage: {usage}"

structure LabeledUrlArg where
  url : String
  label : String

instance : Verso.ArgParse.FromArgs LabeledUrlArg Verso.Doc.Elab.DocElabM where
  fromArgs :=
    LabeledUrlArg.mk <$> .positional `url .string <*>
      (.positional `label .string <|> pure "Source")

@[role]
def link : Verso.Doc.Elab.RoleExpanderOf LabeledUrlArg
  | {url, label}, stxs => do
    checkNoContents "{link \"url\" \"label\"}[]" stxs
    ``(Verso.Doc.Inline.other
        (Verso.Genre.Blog.InlineExt.blob (linkBadge $(Lean.quote url) $(Lean.quote label)))
        #[])

-- For preprint
def tagBadge (label : String) : Verso.Output.Html :=
  .tag "span" #[("class", "tag")] (.text true label)

@[role]
def tag : Verso.Doc.Elab.RoleExpanderOf NameArg
  | {name}, stxs => do
    checkNoContents "{tag \"label\"}[]" stxs
    ``(Verso.Doc.Inline.other
        (Verso.Genre.Blog.InlineExt.blob (tagBadge $(Lean.quote name)))
        #[])

def mailtoLink (email : String) : Verso.Output.Html :=
  .tag "a" #[
    ("href", "#"),
    ("onclick", "location.href = 'mailto:' + this.textContent.replace('(at)', '@').replaceAll('(dot)', '.'); return false")
  ] (.text true email)

@[role]
def mailto : Verso.Doc.Elab.RoleExpanderOf NameArg
  | {name}, stxs => do
    checkNoContents "{mailto \"user(at)domain(dot)tld\"}[]" stxs
    ``(Verso.Doc.Inline.other
        (Verso.Genre.Blog.InlineExt.blob (mailtoLink $(Lean.quote name)))
        #[])
