#!/bin/bash

showRunInstructions(){
    local filename=$1
    # Show command required to run tailwind in watch mode
    printf "Run tailwind using 'cd $project_name && npx tailwindcss -i ./src/css/input.css -o ./src/css/output.css --watch'\n"
    # Show URL to access the HTML file
    # # Get the absolute path of the current directory
    current_dir=$(pwd)
    # Concatenate the directory path with the filename
    file_path="$current_dir/1.html"
    encoded_file_path=$(printf "%s" "$file_path" | sed 's/ /%20/g')
    printf "If using vscode live server extension: Open URL http://localhost:5500/$filename\n"
    file_url="file://$encoded_file_path"
    printf "Open URL file : file://$encoded_file_path\n"
    printf "New css rules can be added to src/css/input.css\n" 
}

createProject() {
    # Check if project name is provided
    if [ -z "$1" ]; then
        printf "Please provide a project name.\n"
        exit 1
    fi

    project_name="$1"

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
        echo 'creating new number file'
        # Find the next available HTML filename
        next_file=$(find "$project_name/src/htmls" -type f -regex '.*/[0-9]+.html' | sort  -n | tail -n 1 | awk -F/ '{print $NF}' | sed 's/.html//')
        echo $next_file
        next_file=$((next_file + 1))
        echo $next_file
        filename="$project_name/src/htmls/$next_file.html"
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
    createProject|p|project)
        createProject "$2"
        ;;
    createHtml|html|h)
        if [ -z "$3" ]; then
            createHtml "$2"
        else
            createHtml "$2" "$3"
        fi
        ;;
    *)
        printf "\nUsage:\n $0 {createProject|project|p <Projectname> :This creates a new folder with basic tailwind structure\n $0 createHtml|html|h <Projectname>}: This creates a new html file in the project folder\n"
        exit 1
        ;;
esac
