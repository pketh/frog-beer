// Generated by CoffeeScript 1.9.0
(function() {
  var emailPattern;

  emailPattern = /^([\w.-]+)@([\w.-]+)\.([a-zA-Z.]{2,6})$/i;

  if ("john.smith@gmail.com".match(emailPattern)) {
    console.log("E-mail is valid");
  } else {
    console.log("E-mail is invalid");
  }

}).call(this);
