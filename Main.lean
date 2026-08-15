import VersoBlog
import Theme
import Home
import CV
import Publications
import Service
import Defense

open Verso Genre Blog Site Syntax

def blog : Site := site Home /
  static "assets" ← "assets"
  "CV" CV
  "Publications" Publications
  "Service" Service
  "Defense" Defense

def main := blogMain Site.theme blog
