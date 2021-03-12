//= require active_admin/base
//= require active_material

$(document).ready(function(){
    $( ".menu-button" ).remove();
    $( "#utility_nav" ).attr("id","tabs");

    $('input[name="approved"]').click(function (event) {
        ajaxCall(event.target.value, event.target.checked)
    });


    function ajaxCall(value, isChecked) {
        var request = $.ajax({
            url: `/api/v1/formatted_texts/change_approved_status/${value}`,
            type: "PUT",
            data: {approved : isChecked}
          });
          
          request.done(function(response) {
            console.log(response);
          });
          
          request.fail(function(jqXHR,response) {
              alert('Something went wrong')
          });
    }

});
