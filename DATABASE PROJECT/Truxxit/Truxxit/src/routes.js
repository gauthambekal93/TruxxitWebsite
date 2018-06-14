var express = require("express");
var app = express();
var bodyParser  = require("body-parser");
var router  = express.Router();
var mysql = require("mysql");
// var addCustomer = require("./../views/addCustomer.ejs");

//CUSTOMER
//Adding Customer
router.post("/addCustomer", function(req,res){
    var FName = req.body.firstName;
    var LName = req.body.lastName;
    var Cust_UserId = req.body.userid;
    var DOB = req.body.dob;
    var pwd = req.body.password;
    var PhoneNo = req.body.phoneNumber;
    if(pwd == req.body.confirmNumber){
        // var sql = "INSERT INTO Customer (Cust_UserId, pwd, FName, LName, PhoneNo, DOB) VALUES (",Company Inc', 'Highway 37')";
        res.locals.connection.
        query("INSERT into Customer (Cust_UserId, pwd, FName, LName, PhoneNo, DOB) VALUES (",Cust_UserId,', ',pwd,', ',FName,', ',LName,', ',PhoneNo,', ',DOB,' );', function(error, results, fields){
            if(error) throw error;
            res.redirect('/addCustomer');
        });
    }
});

//Deleting Customer
router.delete("/deleteCustomer", function(req, res, next){
    
});

//Update customer
router.put("./updateCustomer", function(req,res){

});

//Getting Customer
router.get("./getCustomer", function(req,res){

});


//Driver
//Adding Driver
router.post("/addDriver", function(req,res){

});

//Deleting Driver
router.delete("/deleteDriver", function(req, res){

});

//Update Driver
router.put("./updateDriver", function(req,res){

});

//Getting Driver
router.get("./getDriver", function(req,res){

});

//Truck
//Adding Truck
router.post("/addTruck", function(req,res){

});

//Deleting Truck
router.delete("/deleteTruck", function(req, res){

});

//Update Truck
router.put("./updateTruck", function(req,res){

});

//Getting Truck
router.get("./getTruck", function(req,res){

});

// router.get('/', function(req, res, next) {
// 	res.locals.connection.query('SELECT * from login', function (error, results, fields) {
// 		if (error) throw error;
// 		res.send(JSON.stringify({"status": 200, "error": null, "response": results}));
// 	});
// });