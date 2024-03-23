# Tailwind DO


Helper bash script  to make life easy while learning tailwindcss

### Features 
- Rapidly creates new html files and tailwindcss projects
- automatically figures out the html file name
- Provides help to compile and run the project
- Commented source code to make learning even easier. 


### Usage

#### Create Project
```bash 
./tailwindDo.sh {createProject|project|p <Projectname>}
```
This creates a new folder with basic tailwind structure
Example:
```bash
./tailwindDo.sh createProject learntailwind 
./tailwindDo.sh p learntailwind2
```
#### Create new html file
```bash 
 ./tailwindDo.sh createHtml|html|h <Projectname>
```
This creates a new html file in the src/htmls folder
```bash
./tailwindDo.sh createHtml learntailwind
./tailwindDo.sh h learntailwind2 
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
