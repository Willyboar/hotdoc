import std / [strutils]

const app* = """
import std / [os, macros, strutils, unicode]
include karax / [prelude, kdom]

type
  Item = object
    path: string

    case kind: PathComponent
    of {pcDir, pcLinkToDir}:
      children: seq[Item]
    else:
      content: string

proc renderMarkdown(input: cstring): cstring {.importjs: "md.render(#)".}

proc getFile(kind: PathComponent, path: string): Item =
  result.path = splitPath(path).tail
  result.kind = kind
  case result.kind:
  of {pcDir, pcLinkToDir}:
    for k, childPath in walkDir(path):
      result.children.add getFile(k, childPath)
  else:
    result.content = readFile(path)

proc drawItem(item: Item, printName = true): VNode =
  result = buildHtml(tdiv):
    case item.kind:
    of {pcDir, pcLinkToDir}:
      if printName: a(class="title", href = "#" & replace(item.path, ".md" , "")): text replace(item.path, ".md" , "").capitalize
      for child in item.children:
        drawItem(child)
    else:
      a(class = "section", href="#" & replace(item.path, ".md" , "")):
        text replace(item.path, ".md" , "").capitalize


proc drawMd(item: Item, printName = true): VNode =
  result = buildHtml(tdiv):
    case item.kind:
    of {pcDir, pcLinkToDir}:
      if printName: h1(class="title", id = item.path): text item.path.capitalize
      for child in item.children:
        drawMd(child)
    else:
      tdiv(class = "content-div"):
        h2(id =  replace(item.path, ".md" , "")):
          text replace(item.path, ".md" , "").capitalize
        tdiv:
          verbatim(item.content.renderMarkdown())


proc createDom: VNode =
  const root = getFile(pcDir, getProjectPath() & "/contents")

  result = buildHtml():
    body:
      tdiv(class = "container clear"):
        tdiv(class = "row wrapper"):
          tdiv(class = "toc"):
            span(class = "logo"):
              text "Hotdoc"
              text "®"
            span(class = "switch"):
              button:
                text "🌞🌚"
                proc onclick() =
                  document.body.classList.toggle("dark")
                  document.querySelector("#ROOT").classList.toggle("dark")
            drawItem(root, printName=false)
          tdiv(class = "content"):
            drawMd(root, printName=false)
      footer(class = "container row"):
        text "👑 Made with "
        a(href = "https://github.com/willyboar/hotdoc"):
          text "Hotdoc"
        text " 🌭.\n     "
        a(href="#", class="button"):
          text "⬆"

proc main =
  setRenderer createDom

asm ***
var script = document.createElement('script')
script.onload = function () {
  window.md = new Remarkable()
  `main`()
}
script.src = "https://cdn.jsdelivr.net/remarkable/1.7.1/remarkable.min.js"
document.head.appendChild(script)
***

""".replace('*', '"')

const index* = """
<!DOCTYPE html>
<html>
   <head>
      <meta charset="utf-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <title>Hotdoc - Single Page Documentation</title>
      <link rel="preconnect" href="https://fonts.gstatic.com">
      <link href="https://fonts.googleapis.com/css2?family=Epilogue:wght@100;200;300&display=swap" rel="stylesheet">
      <link rel="stylesheet" href="assets/css/style.css">
      <link rel="stylesheet" href="//unpkg.com/@highlightjs/cdn-assets@10.7.2/styles/solarized-light.min.css">
      <script src="//unpkg.com/@highlightjs/cdn-assets@10.7.2/highlight.min.js"></script>
      <script>hljs.highlightAll();</script> 
   </head>
   <body>
      <div id="ROOT"></div>
      <script type="text/javascript" src="assets/js/hotdoc.js"></script>
   </body>
</html>
"""

const css* = """
/*
* Root Variables
*/

:root {
    --white: #fff;
    --black: #000;
    --light-blue: #f6f8fa;
    --yellow: #ffea7d;
    --dark-gray: #242526;
    --pink: #fc4cc3;
    --blue: #53b2e7;
    --table-border:#dddddd;
    --font: 'Epilogue', sans-serif;
}

/*
* Basic Configuration
*/

body {
    font-family: var(--font);
    color: var(--dark-gray) !important;
    background-color: var(--white) !important;
    margin: 0;
}

body h1,
h2,
h3,
h4,
h5,
h6 {
    color: var(--pink);
}

.hljs,
code {
    background-color: var(--light-blue) !important;
}

blockquote {
    background-color: var(--light-blue) !important;
    max-width:100%;
    padding:1em;
    margin:0;
    border-left:1px solid var(--dark-gray);
}

blockquote:nth(child) {
    padding:0;
}

a {
    color: var(--blue);
    text-decoration: none;
}

a:hover {
    text-decoration: underline;
}

table {
    border-collapse: collapse;
    width: 100%;
}

td,
th {
    border: 1px solid var(--table-border);
    text-align: left;
    padding: 8px;
}

th {
    background-color: var(--light-blue) !important;
}

/*
* Dark Side
*/

.dark {
    background-color: var(--dark-gray) !important;
    color: var(--yellow) !important;
}

.dark a {
    color: var(--blue);
}

.dark code {
    background-color: #2b2b2b !important;
}

.dark th {
    background-color: #2b2b2b !important;
}

.dark .hljs {
    background-color: #2b2b2b !important;
    color: #f8f8f2;
}

.dark blockquote {
    background-color: #2b2b2b !important;
    color: #f8f8f2;
    border-left:1px solid #f8f8f2;
}

/*
* Toggle switch-button
*/

.switch {
    width: 100%;
    text-align: right;
}

.switch button {
    font-size: 2em;
    border: none;
    background: none;
    cursor: pointer;
    padding:5px 0 0;
}
 
/*
* Logo
*/

.logo {
    font-size: 2em;
    float: left;
    margin: 0;
    width: 100%;
    font-weight: bold;
    text-align:left;
}

.logo img {
    max-width: 150px;
}

/*
* General Config
*/

.container {
    width: 100%;
}

.row {
    max-width: 60rem;
    margin: auto;
    display: block;
}

.wrapper {
    display: flex;
    padding: 0 20px;
}

/*
* Table of Contents (ToC)
*/

.toc {
    width: 200px;
    margin-top:1.5em;
    overflow-x: hidden;
    position: fixed;
    height: auto;
    background-color:inherit;
}

.toc a.title {
    font-size: 18px;
    font-weight: 600;
    text-align: left;
    text-decoration: none;
    color: var(--pink);
    display: block;
    padding: 5px 0;
}

.toc a.section {
    font-size: 15px;
    text-align: left;
    line-height: 30px;
    display: block;
    text-decoration: none;
    color: inherit;
}

.toc a.sub-section {
    font-size: 15px;
    text-align: left;
    line-height: 25px;
    display: block;
    text-decoration: none;
    color: inherit;
    padding-left: 20px;
}

.toc a.title:hover,
.toc a.section:hover,
.toc a.sub-section:hover {
    text-decoration: underline;
}

/*
* Content area
*/

.content {
    text-align: left;
    width: 100%;
    margin: 1em  0 0 220px;
    min-height: 30vh;
    background-color:inherit;
}

.content h1 {
    font-size: 1.8em;
    line-height: 1.8em;
    margin: 0;
    text-decoration:underline;
}

.content h2 {
    font-size: 1.3em;
    line-height: 1.3em;
    margin-bottom: 10px;
    text-align: left;
}

.content p {
    font-size: 1em;
    line-height: 1.3em;
    margin-bottom: 15px;
}

.content ol,
ul {
    line-height: 1.5em;  
}

.content img {
    max-width:100%;
}


/*
* Expandable Area
*/

 .expander:last-of-type .expander-content {
     border-bottom: 1px dotted var(--table-border);
     margin-bottom: 0;
}
 input[type='checkbox'] {
     display: none !important;
}
 .expander-toggle {
     display: block;
     padding: 1em 0;
     cursor: pointer;
     border-radius: 2px;
     transition: 200ms cubic-bezier(0.4, 0, 0.2, 1);
}
 .expander-toggle::before {
     content: ' ';
     display: inline-block;
     border-top: 5px solid transparent;
     border-bottom: 5px solid transparent;
     border-left: 5px solid currentColor;
     vertical-align: middle;
     margin-right: 0.7rem;
     transform: translateY(-2px);
     transition: 200ms cubic-bezier(0.4, 0, 0.2, 1);
}
 .toggle:checked + .expander-toggle::before {
     transform: rotate(90deg) translateX(-3px);
}
 .expander-content {
     max-height: 0px;
     overflow: hidden;
}
 .toggle:checked + .expander-toggle + .expander-content {
     max-height: 350px;
}
 .expander-content .expander-content-inner {
     padding:1em 0;
}
 .expander .toggle:checked + label + .expander-content {
     margin-bottom: 15px;
     border-radius: 2px;
     transition: 200ms cubic-bezier(0.4, 0, 0.2, 1);
}

/*
* Back to top button
*/

.button{
    position:fixed;
    bottom:20px;
    right:20px;
    background:var(--yellow);
    color:var(--dark-gray) !important;
    text-decoration:none;
    transition:0.5s;
    cursor:pointer;
    font-size:1.5em;
    border-radius:100%;
    padding:.5em .8em;
}

.button:hover {
    text-decoration: none;
}


/*
* Footer
*/

footer {
    padding: 1em 20px;
}

/*
* Breakpoints
*/
/* 650px and down */

@media only screen and (max-width: 650px) {
    .switch {
        text-align: center;
        float: left;
    }
 
    .wrapper {
        display: block;
    }
    .toc {
        width: 100%;
        text-align: center;
        position: relative;
        height: auto;
    }
    .toc a.title,
    .toc a.section,
    .toc a.sub-section {
        text-align: center;
    }
    .content {
        position: relative;
        margin-top: 20px;
        margin-left: 0px;
    }

    .logo {
        text-align:center;
    }


}

"""