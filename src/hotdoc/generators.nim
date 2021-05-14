# STANDARD LIBRARY IMPORTS
import std / [os, osproc]

# INTERNAL IMPORTS
import application

# EXTERNAL IMPORTS

# Deafult Site Structure Type
type SiteStruct* = ref object
  docsite*: string
  contentsDir*: string     
  buildDir*: string
  buildAssets: string
  cssDir*: string
  jsDir*: string
  imgDir*: string


# Constant variables to set names of directories
const 
  contentsDirName* = "contents"     
  assetsDirName* = "assets"
  cssDirName* = "css"
  jsDirName* = "js"
  imgDirName* = "img"
  buildDirName* = "docs"
  


# Creates a new hotdoc documentation site
proc newDocSite*(docsite : string) : SiteStruct =
  new result

  let
    dir = getCurrentDir()
    siteDir = joinpath(dir, docsite)

    

  if not dirExists(siteDir):
    block createSite:
      createDir(siteDir)

  result.contentsDir = joinPath(siteDir, contentsDirName)

  block createContentsDir:
    if not dirExists(result.contentsDir):
      createDir(result.contentsDir)
  
  writeFile(siteDir / "hotdoc.nim", app)

# Builds the hotdoc static documentation site 
proc buildDocSite*(folder : string) : SiteStruct  =
  new result

  let
    dir = getCurrentDir()
    buildDir = joinPath(dir, buildDirName)
    buildAssets = joinPath(buildDir, assetsDirName)
   
  if not fileExists("hotdoc.nim"):
    echo "hotdoc file not found. Please cd into hotdoc project."
  else:
    block createBuild:
      if not dirExists(buildDir):
        createDir(buildDir)
    
    result.buildAssets = joinPath(buildDir, assetsDirName)

    block createAssetsDir:
      if not dirExists(buildAssets):
        createDir(result.buildAssets)

    result.cssDir = joinpath(result.buildAssets, cssDirName)

    block createCss:
      if not dirExists(result.cssDir):
        createDir(result.cssDir)

    writeFile(result.cssDir / "style.css", css)

    result.jsDir = joinpath(result.buildAssets, jsDirName)

    block createJs:
      if not dirExists(result.jsDir):
        createDir(result.jsDir)

    result.imgDir = joinpath(result.buildAssets, imgDirName)

    block createImg:
      if not dirExists(result.imgDir):
        createDir(result.imgDir)
    

    writeFile(buildDir / "index.html", index)

    discard execCmd("nim js --outdir:docs/assets/js --verbosity:0 --hints:off --warnings:off hotdoc.nim")


