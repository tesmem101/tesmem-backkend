//= require active_admin/base
//= require active_material
//= require active_admin/sortable
//= require active_admin/searchable_select




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

    onInstanceChange = function (instanceType) {

        if (instanceType == 'Design') {

            $('#container_instance_id').find('option').remove().end()

            var request = $.ajax({
                url: '/api/v1/designs/titles/',
                type: "GET"
              });
              
              request.done(function(response) {
                var design_titles = response.json.titles;
                $.each(design_titles, function (i, item) {
                    $('#container_instance_id').append($('<option>', { 
                        value: item.id,
                        text : item.title 
                    }));
                });
              });


        } else if (instanceType == 'Upload') {

            $('#container_instance_id').find('option').remove().end()

            var request = $.ajax({
                url: '/api/v1/uploads/titles/',
                type: "GET"
              });
              
              request.done(function(response) {
                var upload_titles = response.json.titles;
                $.each(upload_titles, function (i, item) {
                    $('#container_instance_id').append($('<option>', { 
                        value: item.id,
                        text : item.title 
                    }));
                });
              });
        } else {
            $('#container_instance_id').find('option').remove().end()   
        }
    }

});

