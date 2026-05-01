import VersoBlog
open Verso Genre Blog

def siteCSS : String := include_str "theme.css"

namespace Site

open Output Html Template Theme in
def theme : Theme := { Theme.default with
  primaryTemplate := do
    let postList :=
      match (← param? "posts") with
      | none => Html.empty
      | some html => html
    return {{
      <html>
        <head>
          <meta charset="utf-8"/>
          <meta name="viewport" content="width=device-width, initial-scale=1"/>
          <title>{{← param (α := String) "title"}} " — Hichem Rami Ait-El-Hara"</title>
          <meta name="author" content="Hichem Rami Ait-El-Hara"/>
          <meta name="description" content="Hichem Rami Ait-El-Hara — Formal Methods R&D Engineer"/>
          {{← builtinHeader}}
          <style>{{siteCSS}}</style>
        </head>
        <body>
          <div id="outer">
            <div class="site">
              <div class="title">
                <a class="name" href="/">"Hichem Rami AIT EL HARA"</a>
                <nav class="nav-links">
                  <a class="nav" href="/">"Home"</a>
                  <a class="nav" href="/Research/">"Research"</a>
                </nav>
              </div>
              {{← param "content"}}
              {{postList}}
              <div class="footer"></div>
            </div>
          </div>
        </body>
      </html>
    }}
  pageTemplate := do
    let path ← currentPath
    let title ← param (α := String) "title"
    let showTitle := path != #[] && path != #["Research"]
    return {{
      <article>
        {{ if showTitle then {{ <h1>{{title}}</h1> }} else Html.empty }}
        {{← param "content"}}
      </article>
    }}
  cssFiles := #[("site.css", siteCSS)]
}

end Site
