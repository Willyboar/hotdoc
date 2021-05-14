# STANDARD LIBRARY IMPORTS
import std/strformat

# INSIDE IMPORTS
import hotdoc/generators

# EXTERNAL LIBRARIES IMPORTS
import docopt

const 
  VERSION* = "hotdoc v.0.1.0"

let doc = fmt"""

---------------------------------------------------

██╗  ██╗ ██████╗ ████████╗██████╗  ██████╗  ██████╗
██║  ██║██╔═══██╗╚══██╔══╝██╔══██╗██╔═══██╗██╔════╝
███████║██║   ██║   ██║   ██║  ██║██║   ██║██║     
██╔══██║██║   ██║   ██║   ██║  ██║██║   ██║██║     
██║  ██║╚██████╔╝   ██║   ██████╔╝╚██████╔╝╚██████╗
╚═╝  ╚═╝ ╚═════╝    ╚═╝   ╚═════╝  ╚═════╝  ╚═════╝
                                                                            
Usage:
  hotdoc new <docsite>
  hotdoc build
  hotdoc (-h | --help)
  hotdoc (-v | --version)

Options:
  -h --help        Show this screen.
  -v --version     Show version.

Available Commands:
  new             Generates a new documentation site.
  build           Builds your documentation site.

"""

when isMainModule:
  
  # Parsing doc for commands 
  let args = docopt(doc, version = VERSION)
  
  # Generate new documentation site 
  if args["new"]: 
    discard newDocSite($args["<docsite>"])

  # Needs a lot of work to stay 
  elif args["build"]:
    discard buildDocSite("docs")
