var express = require("express");
var app = express();
var bodyParser = require("body-parser");
var mysql = require("mysql");
var session = require("express-session");
var port = 8090;
var routes = require("./src/routes");

app.use(bodyParser.urlencoded({ extended: true }));
app.set("view engine", "ejs");
app.use(session({ secret: "max", saveUninitialized: false, resave: false }));

// Database connection
var con = mysql.createConnection({
  host: "localhost",
  user: "root",
  password: "password",
  database: "TRUXXITv2"
});

con.connect(function(err) {
  if (err) throw err;
  console.log("Connected!");
});

app.get("/", function(req, res) {
  res.render("landingPage");
});

app.get("/loginAdmin", function(req, res) {
  res.render("loginAdmin");
});

app.get("/adminPage", function(req, res) {
  var bookingtable = [];
  console.log(typeof bookingtable);
  con.query("SELECT * from Booking", function(err, rows) {
    if (err) {
      console.log(err);
      res.render("adminPage.ejs");
    } else {
      temp = rows;
      // var truckdetails = JSON.stringify(rows);
      console.log(rows[0]);
      for (let i = 0; i < rows.length; i++) {
        bookingtable.push(rows[i]);
      }
      console.log(rows.length);
      console.log(bookingtable.length);
      console.log(bookingtable[0]);
      console.log(bookingtable[0].PickUp);
      res.render("adminPage.ejs", { bookingtable: bookingtable });
    }
  });
});

app.post("/CheckInAdmin", function(req, res) {
  let adminemail = req.body.Adminusername;
  let adminpassword = req.body.Adminpassword;
  let sql1 =
    "Select * from Admin where Admin.Adm_UserId = '" +
    adminemail +
    "' and Admin.Pwd = '" +
    adminpassword +
    "';";
  con.query(sql1, function(error, result) {
    console.log(result);
    if (result.length == 0) {
      console.log("Wrong Admin Credentials");
    } else {
      res.redirect("adminPage");
    }
  });
});

//LOGIN
app.get("/login", function(req, res) {
  res.render("loginMainPage");
});

app.get("/loginCustomer", function(req, res) {
  res.render("loginCustomer");
});

app.get("/loginDriver", function(req, res) {
  res.render("loginDriver");
});
// LOGIN ENDS HERE

//SIGNUP STARTS HERE
app.get("/signUp", function(req, res) {
  res.render("registerMainPage");
});

app.get("/registerCustomer", function(req, res) {
  res.render("registerCustomer");
});

app.get("/registerDriver", function(req, res) {
  res.render("registerDriver");
});

//SIGNUP ENDS HERE

//ADD CUSTOMER - SignUp Customer
app.post("/AddingCustomer", function(req, res) {
  let Cust_UserId = req.body.custuserid;
  let Pwd = req.body.password;
  let confirmpass = req.body.confirmpassword;
  let FName = req.body.firstname;
  let LName = req.body.lastname;
  let PhoneNo = req.body.phonenumber;
  let DOB = req.body.dob;
  if (Pwd == confirmpass) {
    let sql1 =
      "Select count(*) from Customer where Customer.Cust_UserId = '" +
      Cust_UserId +
      "';";
    con.query(sql1, function(error, result) {
      console.log(JSON.stringify(result)[13]);
      if (JSON.stringify(result)[13] < 1) {
        let sql =
        "INSERT into Customer(Cust_UserId, Pwd, FName, LName, PhoneNo, DOB) VALUES (" +
        "'" +
        Cust_UserId +
        "'" +
        "," +
        "'" +
        Pwd +
        "'" +
        "," +
        "'" +
        FName +
        "'" +
        "," +
        "'" +
        LName +
        "'" +
        "," +
        "'" +
        PhoneNo +
        "'" +
        "," +
        "'" +
        DOB +
        "'" +
        ");";
      con.query(sql, function(error, results) {
        if (error) {
          console.log(error);
        } else {
          console.log("Sucessfully Added");
          global.userNameStatic = Cust_UserId;
          res.redirect("CustHomePage");
        }
      });
      } else {
        console.log("UserName already exists");
      }
    });
  } else {
    console.log("password dosent match");
  }
});

app.get("/Booking", function(req, res) {
  res.render("bookTruck");
});

//Customer Book a Truck Page
app.get("/CustHomePage", function(req, res) {
  res.render("CustHomePage");
});

//Driver - SignUp
app.post("/AddingDriver", function(req, res) {
  let Driv_UserId = req.body.driveruserid;
  let Pwd = req.body.password;
  let ConPwd = req.body.confirmpassword;
  let FName = req.body.firstname;
  let LName = req.body.lastname;
  let LicenseNo = req.body.licensenumber;
  let validUsername = false;
  if (ConPwd == Pwd) {
    let sql1 =
      "Select count(*) from Driver where Driver.Driv_UserId = '" +
      Driv_UserId +
      "';";
    con.query(sql1, function(error, result) {
      if (JSON.stringify(result)[13] < 1) {
        validUsername = true;
        console.log(true);
      } else {
        validUsername = false;
        console.log(false);
      }
    });
    if (validUsername == true) {
      let sql =
        "INSERT into Driver(Driv_UserId, Pwd, FName, LName, LicenseNo, Availability) VALUES (" +
        "'" +
        Driv_UserId +
        "'" +
        "," +
        "'" +
        Pwd +
        "'" +
        "," +
        "'" +
        FName +
        "'" +
        "," +
        "'" +
        LName +
        "'" +
        "," +
        "'" +
        LicenseNo +
        "'" +
        "," +
        "'Available'" +
        ");";
      con.query(sql, function(error, results) {
        if (error) {
          console.log(error);
        } else {
          console.log("Sucessfully Added");
          res.redirect("driverHomePage");
        }
      });
    } else {
      console.log("UserName already exists");
    }
  } else {
    console.log("Password dosent match");
  }
});

app.get("/successfull", function(req, res) {
  res.render("successfull");
});

app.get("/driverHomePage", function(req, res) {
  res.render("driverHomePage");
});

app.get("/login", function(req, res) {
  res.render("loginMainPage");
});

//Customer Login
app.post("/CheckLogin", function(req, res) {
  let emailid = req.body.custloginusername;
  let pass = req.body.custloginpassword;
  // console.log(emailid);
  // console.log(pass);
  let sql =
    "Select count(*) from Customer where Customer.Cust_UserId = '" +
    emailid +
    "' and Customer.Pwd = '" +
    pass +
    "' ;";
  con.query(sql, function(error, result) {
    console.log(result);
    if (error) {
      console.log(error);
    }
    let count = JSON.stringify(result)[13];
    console.log("look here", JSON.stringify(result)[13]);
    if (count < 1) {
      console.log("Userid dosent exist");
      // res.redirect('/CheckLogin');
    } else {
      console.log(result);
      global.userNameStatic = emailid;
      res.redirect("CustHomePage");
    }
  });
});

//Driver Login
app.post("/checkinDriver", function(req, res) {
  let emailid = req.body.driverloginusername;
  let pass = req.body.driverloginpassword;
  // console.log(emailid);
  // console.log(pass);
  let sql =
    "Select count(*) from Driver where Driver.Driv_UserId = '" +
    emailid +
    "' and Driver.Pwd = '" +
    pass +
    "' ;";
  con.query(sql, function(error, result) {
    console.log(result);
    if (error) {
      console.log(error);
    }
    let count = JSON.stringify(result)[13];
    console.log("look here", JSON.stringify(result)[13]);
    if (count < 1) {
      console.log("DriverId dosent exist");
      // res.redirect('/CheckLogin');
    } else {
      console.log(result);
      res.redirect("driverHomePage");
    }
  });
});

app.post("/truckBooking", function(req, res) {
  let dateofbooking = req.body.dateofbooking;
  let PickUp = req.body.pickuplocation;
  console.log(typeof PickUp);
  let Num_Hours = req.body.hours;
  let AmountCharged = Num_Hours * 10;
  let Cust_UserId = global.userNameStatic;
  let proc = `CALL BookTransaction(?,?,?,?,?,?)`;
  console.log(global.userNameStatic);
  console.log(dateofbooking);
  console.log(PickUp);
  console.log(Num_Hours);
  console.log(AmountCharged);
  con.query(
    "call BookTransaction(?, ?, ?, ?, ?, ?)",
    [Cust_UserId, PickUp, Num_Hours, AmountCharged, dateofbooking, "Booked"],
    function(error, results) {
      if (error) {
        return console.error(error);
      } else {
        res.redirect("successfull");
      }
    }
  );
});

//delete booking ID
app.delete("/deleteCust", function(req, res) {
  let cust_id = req.body.deleteCustId;
  let query1 = "delete table Customer where Cust_UserId = '" + cust_id + "';";
  con.query(query1, function(error, result) {
    if (error) throw error;
    else {
      console.log(result);
    }
  });
});

app.post("/statusChange", function(req, res) {
  let deleteCustId = req.body.deleteCustId;
  let deletedriverId = req.body.deletedriverId;
  let updatestatus = req.body.updatestatus;
  console.log(deleteCustId);
  console.log(deletedriverId);
  console.log(updatestatus);
  con.query(
    "call Driver_Truck_Available_Cancel(?, ?, ?)",
    [deleteCustId, deletedriverId, updatestatus],
    function(error, result) {
      if (error) {
        console.log(error);
      } else {
        console.log(result);
        res.redirect("successfull");
      }
    }
  );
});

app.listen(port, function() {
  console.log("Server running at port" + port);
});
