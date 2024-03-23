# Tailwind DO


Helper bash script  to make life easy while learning tailwindcss

### Features 
- Rapidly creates new html files and tailwindcss projects
- add plugins from cmd line
- Can automatically calculate the next html file name
- Provides help to compile and run the project
- Commented source code to make learning even easier. 


### Usage

#### Create Project
```bash 
./tailwindDo.sh {createProject|project|p <Projectname>}
```
This creates a new folder with basic tailwind structure  
**Examples:**:
```bash
./tailwindDo.sh createProject learntailwind 
./tailwindDo.sh p learntailwind2
```
#### Create new html file
```bash 
 ./tailwindDo.sh createHtml|html|h <Projectname> <fileName?>
```
A new html file is created src/htmls folder.  
If no filename is specified It figures out the next filename - 1.html, 2.html etc
**Examples:**
```bash
./tailwindDo.sh createHtml learntailwind # creates src/htmls/2.html
./tailwindDo.sh h learntailwind2         # creates src/htmls/3.html
./tailwindDo.sh h learntailwind2 afile   # creates src/htmls/afile.html
```
#### Add Plugin
```bash
./tailwindDo.sh pl|plugin test1 <PluginName>
```
Installs a new plugin from npm. Then add the relevant config to tailwind.config.js
**Examples**
```bash
./tailwindDo.sh pl test1 '@tailwindcss/typography'
./tailwindDo.sh plugin learn1 '@tailwindcss/typography'
```

### Folder and file structure created

```
- current directory
  - project_name
    - src
      - htmls
        - 1.html
      - img
      - css
        - input.css
    - tailwind.config.js
```

### Problems 

- make sure npx command is running
- it should create OR update src/css/output.css file
- Everytime you save, the output.css file should be updated and a message should be  visible in the npx command
- make sure npx command is being run from the project directory
- Check the 'content line' in tailwind.config.js
