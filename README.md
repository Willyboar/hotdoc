# Hotdoc

 Hotdoc is a Single Page Documentation Generator made with Karax and Markdown.

## Install

To use Hotdoc you must have Nim installed. You can follow the instructions [here](https://nim-lang.org/install.html). 

Then you can install Hotdoc through nimble:

    nimble install hotdoc

Then type:

    hotdoc -v

If everything is ok you will see something like this:

    Hotdoc v.0.1.0

## Usage

Once you have hotdoc installed you can create a new documentation site by type:

    hotdoc new your_site_name

This will create a directory that contains:

 - An empty "contents" directory
 - A hotdoc.nim file
 
 Hotdoc scans contents dir and creates a category for every folder. For every markdown file inside this folders creates a section and prints content as html.

When you are finished type:

    hotdoc build

inside your documentation folder. 

This will create a docs folder containing your documentation site. 

Everytime you are adding categories or files on contents folder run again the command and your site will be updated.

## Deployments 

You can host docs directory in every hosting service. 
You can also enable Github pages to point on your docs folder.

## License
MIT License. See [here](https://github.com/Willyboar/hotdoc/blob/main/LICENSE).
