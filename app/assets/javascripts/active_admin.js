//= require active_admin/base
//= require active_material
//= require active_admin/sortable
//= require active_admin/searchable_select


function creatTag() {
    var title = $('#title').val();
    var title_ar = $('#title_ar').val();
    var request = $.ajax({
        url: "/admin/tags",
        type: "POST",
        data: {tag: {name: title, name_ar: title_ar}}
    });

    request.done(function(response) {
        console.log(response)
        // $('#title').val('');
        // $('#title_ar').val('');
        $(".alert").show();
        setTimeout(function() {
            $(".alert").hide();
            $('#createTagModal').modal('toggle');
          }, 1000);
    })
};

$(document).ready(function(){
    // $( ".menu-button" ).remove();
    // $( ".resource_selection_cell, .resource_selection_toggle_panel, .right" ).remove(); // This line is for sortable-tree functionality
    // $( "#utility_nav" ).attr("id","tabs");

    $('#createTagModal').on('hidden.bs.modal', function (e) {
        $(this).find("input,textarea,select").val('').end();
        $('#create_tag_btn').prop("disabled", true);
      })
    
    $('#title').on('input', function(e) {
        if (e.target.value) {
            $('#create_tag_btn').prop("disabled", false); // Element(s) are now enabled.
        } else {
            $('#create_tag_btn').prop("disabled", true); // Element(s) are now disabled.
        }
    });
    

    $('input[name="approved_formatted_text"]').click(function (event) {
        ajaxCall(event)
    });

    $('input[name="approved_template"]').click(function (event) {
        ajaxCall(event)
    });

    $('input[name="private_template"]').click(function (event) {
        ajaxCall(event)
    });


    function ajaxCall(event) {
        var model_name = null;
        var end_point = null;
        if (event.target.id == 'approved_template') {  
            model_name = 'templates'
            end_point = 'change_approved_status'
        } else if (event.target.id == 'private_template') {
            model_name = 'templates'
            end_point = 'change_private_status'
        } else if (event.target.id == 'approved_formatted_text') {
            model_name = 'formatted_texts'
            end_point = 'change_approved_status'
        } 
        var request = $.ajax({
            url: "/api/v1/" + model_name + "/" + end_point + "/" + event.target.value,
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

