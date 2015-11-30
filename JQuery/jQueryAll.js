$(document).ready(function()
{

//Contact Us Page 
$(document).ready(function(e) {
	$('#btnValidate').click(function() {
		var sEmail = $('#txtEmail').val();
// Checking Empty Fields
	if ($.trim(sEmail).length == 0 || $("#fname").val()=="" || $("#feedback").val()=="") {
		alert('All fields are mandatory');
			e.preventDefault();
	}
	if (validateEmail(sEmail)) {
		alert('Thank you and We will get back to you!');
	}
	else {
		alert('Invalid Email Address');
		e.preventDefault();
	}
	});
});
// Validates email address
function validateEmail(sEmail) {
	var filter = /^[\w\-\.\+]+\@[a-zA-Z0-9\.\-]+\.[a-zA-z0-9]{2,4}$/;
	if (filter.test(sEmail)) {
		return true;
	}
	else {
		return false;
	}
}

//Registration page.
$("#btnregistrationSubmit").click(function() {
// Checking Empty Fields
	if($("#email").val() == "" || $("#fName").val() == "" || $("#lastName").value == "" || $("#middleI").value == "" || $("#userName").value == "" ) {
		alert("All fields are mandatory");
	}
	else {
		alert("Thank you and We will get back to you!");
		$("#fName").val("");
		$("#middleI").val("");
		$("#lastName").val("");
		$("#email").val("");
		$("#userName").val("");
	}
})	

});


