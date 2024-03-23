#!/bin/bash


addPlugin() {
  # Check if project name is provided
  if [ -z "$1" ] || [ -z "$2" ]; then
    printf "Please provide a project name and a plugin name.\n"
    exit 1
  fi
  local project_name=$1
  local plugin_name=$2
  config_file="./$project_name/tailwind.config.js"
  

  if [ -f "$config_file" ]; then
    # Check if plugin already exists in config
    if grep -q "$plugin_name" "$config_file"; then
      echo "Plugin $plugin_name already exists in $config_file."
    else
      printf "installing plugin..\n"
      npm install $plugin_name
      exit_code=$?
      # Check if there was an error
      if [ $exit_code -ne 0 ]; then
        echo "npm install command failed with error code $exit_code"
        # Add urther error handling logic here if needed
      else
        echo "npm install command executed successfully"
      # Add plugin to the end of the plugins array
      printf $plugin_name.'\n'
      printf $config_file.'\n'
      sed -i -e "s|\(plugins: \[\)|\1\n    require('$plugin_name'),|" "$config_file"
      echo "Plugin $plugin_name added to $config_file."
      fi
    fi
  else
    echo "tailwind.config.js not found."
  fi
}


showRunInstructions(){
    local filename=$1
    # Show command required to run tailwind in watch mode
    printf "Run tailwind using 'cd $project_name && npx tailwindcss -i ./src/css/input.css -o ./src/css/output.css --minify --watch'\n"
    # Show URL to access the HTML file
    # # Get the absolute path of the current directory
    current_dir=$(pwd)
    # Concatenate the directory path with the filename
    file_path="$current_dir/1.html"
    encoded_file_path=$(printf "%s" "$file_path" | sed 's/ /%20/g')
    printf "If using vscode live server extension: Open URL http://localhost:5500/$filename\n"
    file_url="file://$encoded_file_path"
    printf "Open URL file : file://$encoded_file_path\n\n"
    printf "New css rules can be added to src/css/input.css\n" 
}

createProject() {
    # Check if project name is provided
    if [ -z "$1" ]; then
        printf "Please provide a project name.\n"
        exit 1
    fi

    project_name="$1"

    # Check if project directory already exists
    if [ -d "$project_name" ]; then
        echo "Project directory already exists."
        exit 1
    fi

    # Create project directory
    mkdir -p "$project_name/src/htmls" "$project_name/src/img" "$project_name/src/css"

    # Create files with specified content
    cat << EOF > "$project_name/src/css/input.css"
/* @tailwind import Tailwind CSS utilities, base styles, and components */
@tailwind base;
@tailwind components;
@tailwind utilities;


/* @layer organizes styles into logical layers for better control over specificity and order of generated CSS */
/* @apply allows combining existing tailwind classes into custom classes or tags */
@layer components {
    /* Define a new class 'blue-section' */
    /* .blue-section {
        @apply container mx-auto flex flex-col justify-center bg-blue-600;
    }
    */
}

@layer base {
  h1 {
    @apply text-4xl; /* Apply the text-4xl utility to h1 */
  }
}
EOF

    cat << EOF > "$project_name/src/htmls/1.html"
<!doctype html>
<html>

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="../css/output.css" rel="stylesheet">
    <!-- <script src="https://cdn.tailwindcss.com"></script> -->

</head>
<body>

</body>
</html>
EOF

    cat << EOF > "$project_name/tailwind.config.js"
/** @type {import('tailwindcss').Config} */
module.exports = {
  content: ["./src/htmls/*.html", "./src/**/*.{html,js}"],
  theme: {
    extend: {},
  },
  plugins: [],
}
EOF

    # List created files, check if they exist, and show their file sizes
    printf "Files created:\n"
    for file in "$project_name/src/css/input.css" "$project_name/src/htmls/1.html" "$project_name/tailwind.config.js"; do
        if [ -f "$file" ]; then
            printf "$file (Size: $(du -h "$file" | cut -f1))\n"
        fi
    done
    showRunInstructions $project_name/src/htmls/1.html;
}

createHtml() {
    local filename=$2
    # Check if project name is provided
    if [ -z "$1" ]; then
        printf "Please provide a project name.\n"
        exit 1
    fi

    project_name="$1"


    if [  "$2" ]; then
        filename="$project_name/src/htmls/$2.html"
    else
        echo 'Creating new number file'
        # Find the next available HTML filename
        next_file=$(find "$project_name/src/htmls" -type f -regex '.*/[0-9]+.html' | sort -V | tail -n 1 | awk -F/ '{print $NF}' | sed 's/.html//')
        echo $next_file
        next_file=$((next_file + 1))
        echo $next_file
        filename="$project_name/src/htmls/$next_file.html"
    fi
    # Check if project directory already exists
    if [ -f "$filename" ]; then
        echo "$filename already exists"
        exit 1
    fi

    # Create file with specified content
    cat << EOF > "$filename"
<!doctype html>
<html>

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="../css/output.css" rel="stylesheet">
    <!-- <script src="https://cdn.tailwindcss.com"></script> -->

</head>
<body>

</body>
</html>
EOF

    # Confirm creation of file and display its path and filesize
    if [ -f "$filename" ]; then
        printf "File created: $filename (Size: $(du -h "$filename" | cut -f1))\n\n"
    fi
    showRunInstructions $filename;
}

# Main script logic
case "$1" in 
    pl|plugin)
        addPlugin "$2" "$3"
        ;;
    pr|project)
        createProject "$2"
        ;;
    h|html)
        if [ -z "$3" ]; then
            createHtml "$2"
        else
            createHtml "$2" "$3"
        fi
        ;;
    *)
        printf "\nUsage:\n 
        $0 project|pr <Projectname>               : Create a new folder with basic tailwind structure 
        $0 html|h     <Projectname> <filename?>   : Create a new html file in src/htmlssrc/htmls. Filename is optional
        $0 plugin|pl  <Projectname> <plugin_name> : Adds a new plugin"
        exit 1
        ;;
esac
