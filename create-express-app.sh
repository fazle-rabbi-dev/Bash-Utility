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
echo -e -n "$green[*] Enter the name of your Express app: $reset"
read app_name


# Check template for REST api/web app
function is_it_for_rest_api(){
	echo -n -e "$yellow[?] Do you want to use this template for REST Api (y/n):$reset"
   read option
   if [[ $option == 'y' ]]; then
		# echo "yes"
		# remove views folder
		rm -rf views
		# app.js
		echo "const express = require('express');
const app = express();
const cors = require('cors');
require('dotenv').config();

app.use(cors());
app.use(express.urlencoded({ extended: true }));
app.use(express.json());
//app.use(router);

app.get('/', (req,res) => {
	res.json({message: 'Home Route'});
});

// 404 - page not found error handler
app.use((req,res,next)=>{
	res.json({Message:'Route not found'});
});

// server side error handler
app.use((err,req,res,next)=>{
	if(err.message){
		if(!req.headersent){
			res.json({Message: err.message})
		}
		else{
			res.json({Message: 'There is a server side error'})
		}
	}
});

module.exports = app;
	   " > app.js	
	   
	   echo "[*] Okey, done..."
	elif [[ $option == 'n' ]]; then
		echo "[*] Okey, done..."
	else
		echo "$red[*] Invalid Option...$reset"
		is_it_for_rest_api
   fi
}


# Main Logic
if [ -d "$app_name" ]; then
	echo -e "\n$red[!] Oops! directory already exists try a different name or remove existing directory $reset\n"
else
# Start Creating App Skeleton
	echo "---------------------------"
	echo -e "Creating express app..."
	echo "---------------------------"
	mkdir $app_name
	cd $app_name
	npm init -y > log.txt
	git init > log.txt
	clear
	sleep 1
	echo "---------------------------"
	echo -e "Installing packages..."
	echo "---------------------------"
	npm i express cors dotenv ejs
	touch index.js app.js .env test.js start.sh
	# Write Start Command In start.sh
	echo "nodemon index.js" > start.sh
	# Give executable permission
	chmod +x *
	mkdir models views controllers routes public
	cd public
	mkdir css js images
	cd css && touch app.css
	cd ..
	cd js && touch app.js
	# go to root
	cd ../..
	cd views
	touch home.ejs
	mkdir layout pages utility && cd layout
	touch header.ejs footer.ejs navbar.ejs
	cd ..
	cd utility
	touch page_not_found.ejs unauthorized.ejs 
	# go to root
	cd ../..
	
	# ============================
	# Writing Content Inside File
	# ============================
	
	# index.js
	echo "#!/bin/node
const app = require('./app');
const PORT = process.env.PORT || 3000;

app.listen(PORT, ()=>{
   console.log('Server is running at http://localhost'+PORT);
});
	" > index.js
	
	# app.js
	echo "const express = require('express');
const app = express();
const cors = require('cors');
require('dotenv').config();

// Set Template Engine
app.set('view engine','ejs');
app.use(cors());
app.use(express.urlencoded({ extended: true }));
app.use(express.json());
//app.use(router);

app.get('/', (req,res) => {
	res.render('home.ejs')
});

// 404 - page not found error handler
app.use((req,res,next)=>{
	res.json({Message:'Route not found'});
});

// server side error handler
app.use((err,req,res,next)=>{
	if(err.message){
		if(!req.headersent){
			res.json({Message: err.message})
		}
		else{
			res.json({Message: 'There is a server side error'})
		}
	}
});

module.exports = app;
   " > app.js
	
   # .env
   echo "PORT=3000
DB_URI=uri
	" > .env
	
	# Go To models
	# and create an db.js
	# and write db configuration
	cd models
	touch db.js schema.js
	
	# db.js
	echo "const mongoose = require('mongoose') 
const url = process.env.DB_URI'

const connectionParams = { 
	useNewUrlParser: true, 
	useUnifiedTopology: true
} 

mongoose.connect(url,connectionParams) 
.then( () => { 
	console.log('Connected to mongodb successfull…!');
}) 
.catch( (err) => { 
   console.error(err);
});	
   " > db.js
	
	# schema.js
	echo "const mongoose = require("mongoose");

const usersSchema = mongoose.Schema({
  name: {
    type: String,
    reuired: true,
  },
  email: {
    type: String,
    reuired: true,
  },
  password:{
    type: String,
    reuired: true,
  },
  createdOn: {
    type: Date,
    default: Date.now,
  }
});

module.exports = mongoose.model("users", usersSchema);	
   " > schema.js

	# Go Back
	cd ..
	cd views
	# home.ejs
	echo '<!DOCTYPE html>
<html>
<head>
   <meta http-equiv="content-type" content="text/html; charset=utf-8" />
   <title></title>
   <meta name="viewport" content="width=device-width,initial-scale=1.0">
   <meta name="theme-color" content="#222">
   <meta name="author" content="fazle-rabbi">
   <meta name="keywords" content="">
   <meta name="description" content="">  
   <!--Bootstrap5 CSS Link-->
   <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/css/bootstrap.min.css" type="text/css" media="all" />
   <!--Custom CSS-->
   <link rel="stylesheet" href="css/style.css" type="text/css" media="all" />
</head>
<body>
   
   <!--Header Start Here-->
   <header class="">
      <%- include("layout/header") %>
   </header>
   
   <main class="p-3">
      <h1>Home Page</h1>
   </main>
   
   <footer class="">
      <%- include("layout/footer") %>
   </footer>
   
   <!--Bootstrap5 Js Link-->
   <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>	
   ' > home.ejs
	
	# Go To Root
	cd ..
	rm log.txt
	
   sleep 1
   clear
   # Ask user for some
   # extra configuration
   is_it_for_rest_api
   
   echo -e "[🎉] Your App ($cyan $app_name $reset) Created Successful."
   echo -e "\n";
fi
