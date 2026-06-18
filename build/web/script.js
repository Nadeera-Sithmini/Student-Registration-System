document.querySelector('form').addEventListener('submit', function(event) {
    let phone = document.querySelector('input[name="phone"]').value;
    let password = document.querySelector('input[name="password"]').value;
    if (phone.length < 10) { alert("Please enter a valid phone number!"); event.preventDefault(); return; }
    if (password.length < 6) { alert("The password must contain at least 6 characters!"); event.preventDefault(); return; }
});

