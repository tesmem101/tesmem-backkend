//= require active_admin/base
//= require active_material
//= require active_admin/sortable


$(document).ready(function(){
    $( ".menu-button" ).remove();
    // $( ".resource_selection_cell, .resource_selection_toggle_panel, .right" ).remove(); // This line is for sortable-tree functionality
    $( "#utility_nav" ).attr("id","tabs");

    $('input[name="approved"]').click(function (event) {
        ajaxCall(event)
    });


    function ajaxCall(event) {
        var request = $.ajax({
            url: `/api/v1/formatted_texts/change_approved_status/${event.target.value}`,
            type: "PUT",
            data: {approved : event.target.checked, user_id: event.target.className}
          });
          
          request.done(function(response) {
            console.log(response);
          });
          
          request.fail(function(jqXHR,response) {
              alert('Something went wrong')
          });
    }

});
