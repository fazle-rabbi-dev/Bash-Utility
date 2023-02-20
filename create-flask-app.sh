#!/bin/bash

# Colors:
red='\033[1;91m'
green='\033[1;92m'
yellow='\033[1;93m'
blue='\033[1;94m'
pink='\033[1;95m'
cyan='\033[1;96m'
reset='\033[0m'	

# clear terminal
clear

# Prompt the user for the name of the Flask app
echo -e -n "$green[*] Enter the name of your Flask app: $reset"
read app_name

# Check folder exists/not exists
if [ -d "$app_name" ]; then
	echo -e "\n$red[!] Oops! directory already exists try a different name or remove existing directory $reset\n"
else
	# Create the app directory
	mkdir $app_name
	
	# Create the required directories and files
	sleep 1
	echo -e "$cyan[*] Creating required folders... $reset"
	cd $app_name
	mkdir static templates
	touch main.py test.py config.py requirements.txt
	chmod +x *
	cd static
	mkdir css js images
	cd css && touch style.css
	cd ../
	cd js && touch app.js
	cd ../../ # inside root
	cd templates
	touch index.html 404.html
	cd ../ # inside root
	
	# Add content to the main.py file
	echo -e "$yellow[*] Writing content into files... $reset"
	echo "#!/bin/python
from flask import *

app = Flask(__name__)

@app.route('/')
def index():
    return render_template('index.html')

# Page Not Found Error Handling
@app.errorhandler(404)
def page_not_found(e):
	return render_template("404.html")

# Start app
if __name__ == '__main__':
    app.run()" > main.py
	
	# Add content to the requirements.txt file
	echo "Flask==2.1.2" > requirements.txt
	
	# Add content to the index.html file
	cd templates
	echo "<!DOCTYPE html>
<html>
<head>
    <title>Welcome to $app_name</title>
</head>
<body>
    <h1>Welcome to $app_name</h1>
</body>
</html>" > index.html
	
	# Go back to the app directory
	cd ..
	
	sleep 1
	echo -e "$cyan[*] Done... $reset"
	echo -e "$green[*] Creating virtual environment... $pink\n"
	virtualenv venv 
	# cd $app_name
	source venv/bin/activate
	
	# Print a message to the user
	echo -e "\n$cyan[🎉]Your Flask app $green($app_name)$cyan has been created successfully! $reset\n"
fi