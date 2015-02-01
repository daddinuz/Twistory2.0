// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree .

var maxChar=124;
var flag=false;

function checkForImages(element)
{        
  if ('files' in element && flag==false) 
  {
    maxChar = maxChar - 23;     
    flag=true;
  } 
}
  
function textCounter(element, counterBox)
{    
  if (counterBox=="charCounterEng") maxChar=126;
  else maxChar=124;
  
  var counter = document.getElementById(counterBox);
  var remaining = maxChar - element.value.length;
  
  counter.style.display="";
  
  if (remaining >= 0) counter.style.color="green";
  else counter.style.color="red";
  
  counter.innerHTML = maxChar - element.value.length;
}

function Expand_Image(id)
{   
  var newheight = "38em"; // Warning: be sure that style.css height is different to newheight 
  var newmargin = "0 -20% 0 -20%";
  
  if (document.getElementById(id).style.height != newheight)
  {     
    document.getElementById(id).style.height= newheight;
    document.getElementById(id).style.margin= newmargin;    
  }
  else
  {
    document.getElementById(id).style.height= "";
    document.getElementById(id).style.margin= "";
  }
}

function cleanLink()
{
  var cont = document.getElementsByName("Hlink");
          
  for (i=0; i!=cont.length; i++) {
    cont[i].style.color='rgba(0, 0, 0, 0.5)';
    cont[i].style.border='none';
    cont[i].style.backgroundColor='#feffff';
    cont[i].style.padding='0';
  }
}

function switchLink (element)
{
  cleanLink();
  
  element.style.color='white';
  element.style.border='1px solid rgba(0, 80, 100, 0.5)';
  element.style.borderRadius='5px';
  element.style.backgroundColor='rgba(105, 180, 200, 0.75)';    
  element.style.padding='1%';    
} 

function checkingChanges()
{
  var confirmBox = document.getElementById("confirmChanges");  
  var listBox = document.getElementById("fields");
   
  if (confirmBox.style.display=="none") {
    confirmBox.style.display="block";
    listBox.style.display="none";
  } else {
    confirmBox.style.display="none";
    listBox.style.display="block";
  }
}

