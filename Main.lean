import VersoBlog
import Theme
import Home
import CV
import Publications
import Talks
import Service
import Defense

open Verso Genre Blog Site Syntax

def blog : Site := site Home /
  static "assets" ← "assets"
  "CV" CV
  "Publications" Publications
  "Talks" Talks
  "Service" Service
  "Defense" Defense

def main := blogMain Site.theme blog
