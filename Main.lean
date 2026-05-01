import VersoBlog
import Theme
import Home
import Research
import Defense

open Verso Genre Blog Site Syntax

def blog : Site := site Home /
  static "assets" ← "assets"
  "Research" Research
  "Defense" Defense

def main := blogMain Site.theme blog
