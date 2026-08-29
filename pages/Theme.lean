import VersoBlog
open Verso Genre Blog

def siteCSS : String := include_str "theme.css"

namespace Site

open Output Html Template Theme in
def theme : Theme := { Theme.default with
  primaryTemplate := do
    let path ← currentPath
    let current := path.getD 0 "Home"
    let title ← param (α := String) "title"
    let navClass (name : String) : String := if name == current then "nav current" else "nav"
    let aboutMe (suffix : String) : String := "Hichem Rami Ait-El-Hara — " ++ suffix
    let pageDescription : String :=
      match current with
      | "CV" => aboutMe "Formal Methods R&D Engineer — CV."
      | "Publications" => aboutMe "Publications."
      | "Service" => aboutMe "Service."
      | "Defense" => aboutMe "PhD defense."
      | _ => aboutMe "Formal Methods R&D Engineer at OCamlPro."
    let pageUrl : String := "https://hra687261.github.io/" ++ path.foldl (init := "") fun acc p => acc ++ p ++ "/"
    let postList :=
      match (← param? "posts") with
      | none => Html.empty
      | some html => html
    return {{
      <html lang="en">
        <head>
          <meta charset="utf-8"/>
          <meta name="viewport" content="width=device-width, initial-scale=1"/>
          <title>{{title}} " — Hichem Rami Ait-El-Hara"</title>
          <meta name="author" content="Hichem Rami Ait-El-Hara"/>
          <meta name="description" content={{pageDescription}}/>
          <meta property="og:type" content="website"/>
          <meta property="og:site_name" content="Hichem Rami Ait-El-Hara"/>
          <meta property="og:url" content={{pageUrl}}/>
          <meta property="og:title" content={{title}}/>
          <meta property="og:description" content={{pageDescription}}/>
          <link rel="icon" type="image/svg+xml" href="/assets/favicon.svg"/>
          {{← builtinHeader}}
          <style>{{siteCSS}}</style>
        </head>
        <body>
          <div id="outer">
            <div class="site">
              <div class="title">
                <a class="name" href="/">"Hichem Rami AIT EL HARA"</a>
                <nav class="nav-links">
                  <a class = {{navClass "Home"}} href="/">"Home"</a>
                  <a class = {{navClass "CV"}} href="/CV/">"CV"</a>
                  <a class = {{navClass "Publications"}} href="/Publications/">"Publications"</a>
                  <a class = {{navClass "Service"}} href="/Service/">"Service"</a>
                </nav>
              </div>
              {{← param "content"}}
              {{postList}}
              <div class="footer">
                <div class="footer-links">
                  <a href="https://orcid.org/0000-0001-7909-0413">"ORCID"</a>
                  <a href="https://www.linkedin.com/in/hra687261/">"LinkedIn"</a>
                  <a href="https://scholar.google.com/citations?user=_u9Ed_UAAAAJ">"Google Scholar"</a>
                  <a href="https://github.com/hra687261/">"GitHub"</a>
                </div>
              </div>
            </div>
          </div>
        </body>
      </html>
    }}
  pageTemplate := do
    let path ← currentPath
    let title ← param (α := String) "title"
    let showTitle := path != #[] && path != #["Publications"] && path != #["Service"]
    let pageClass := "page-" ++ path.getD 0 "Home"
    return {{
      <article class = {{pageClass}}>
        {{ if showTitle then {{ <h1>{{title}}</h1> }} else Html.empty }}
        {{← param "content"}}
      </article>
    }}
  cssFiles := #[("site.css", siteCSS)]
}

end Site
