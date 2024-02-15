var projpath='/ogsl/signlist/';

function slpage () {
    var form=document.getElementById('sl');
    // alert('form='+form);
    var key=document.getElementById('k').value;
    // alert('key='+key);
    var oid=x[key];
    if (oid) {
	// alert('oid='+oid);
	window.location=projpath+oid+'/index.html';
    } else {
	alert('OGSL has nothing for '+key);
    }
}
