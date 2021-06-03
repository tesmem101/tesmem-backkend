//= require active_admin/base
//= require active_material
//= require active_admin/sortable
//= require active_admin/searchable_select



function validatePngType() {
    return isFileValid("png", "stock_image")
}

function validateSvgType() {
    return isFileValid("svg", "stock_svg")
}

function isFileValid(type, elementId) {
    var fileName, fileType = getFileName(elementId)
    if (fileName == "") {
        alert("Browse to upload a valid File with png extension");
        removeInvalidFile(elementId);
        return false;
    } else if (fileType.toLowerCase() == type) {
        return true;
    } else {
        alert("File with " + fileType + " is invalid. Upload a validfile with png extensions");
        removeInvalidFile(elementId);
        return false;
    }
}

function removeInvalidFile(elementId) {
    document.getElementById(elementId).value = "";
}

function getFileName(fileId) {
    var fileName = document.getElementById(fileId).value
    var splittedFileName = fileName.split(".")
    var fileType = splittedFileName[splittedFileName.length - 1]
    return fileName, fileType;
}

function hideModel() {
    $(".alert").show();
    setTimeout(function() {
        $(".alert").hide();
    }, 1000);
}

function creatTag() {
    var title = $('#title').val();
    var title_ar = $('#title_ar').val();
    var request = $.ajax({
        url: "/admin/tags",
        type: "POST",
        data: { tag: { name: title, name_ar: title_ar } }
    });
    request.done(function(response) {
        hideModel();
    });

};

function creatSubCategory() {
    var title = $('#sub_category_title').val();
    var title_ar = $('#sub_category_title_ar').val();
    var description = $('#sub_category_description').val();
    var category_id = $("#stock_category_id").val();
    var request = $.ajax({
        url: "/api/v1/subcategories/create",
        type: "POST",
        data: { category_id: category_id, title: title, title_ar: title_ar, description: description }
    });
    request.done(function(response) {
        hideModel();
    });

};

function creatCategory() {
    console.log('In create category tab');
    var title = $('#category_title').val();
    var title_ar = $('#category_title_ar').val();
    var description = $('#category_description').val();
    var width = $('#category_width').val();
    var height = $('#category_height').val();
    var unit = $('#category_unit').val();
    var cover = $('#category_cover').prop('files')[0];
    var super_category_id = $("#super_category_id").val();

    var formdata = new FormData();
    formdata.append("category[title]", title);
    formdata.append("category[title_ar]", title_ar);
    formdata.append("category[description]", description);
    formdata.append("category[width]", width);
    formdata.append("category[height]", height);
    formdata.append("category[unit]", unit);
    formdata.append("category[cover]", cover);
    formdata.append("category[super_category_id]", super_category_id);
    var request = $.ajax({
        url: "/admin/categories",
        type: "POST",
        data: formdata,
        contentType: false,
        processData: false
    });
    request.done(function(response) {
        hideModel();
    });
}

$(document).ready(function() {
    // $( ".menu-button" ).remove();
    // $( ".resource_selection_cell, .resource_selection_toggle_panel, .right" ).remove(); // This line is for sortable-tree functionality
    // $( "#utility_nav" ).attr("id","tabs");

    $('#createTagModal, #createCategoryModal').on('hidden.bs.modal', function(e) {
        $(this).find("input,textarea,select,file").val('').end();
        $('#create_tag_btn, #create_category_btn').prop("disabled", true);
    })

    $('#title, #category_title').on('input', function(e) {
        console.log('sdfklsdklh');
        if (e.target.value) {
            $('#create_tag_btn, #create_category_btn').prop("disabled", false); // Element(s) are now enabled.
        } else {
            $('#create_tag_btn, #create_category_btn').prop("disabled", true); // Element(s) are now disabled.
        }
    });

    $('#createSubCategoryModal').on('hidden.bs.modal', function(e) {
        $(this).find("input,textarea,select").val('').end();
        $("#stock_category_id").select2({
            placeholder: "Select a Category",
            allowClear: true
        });
        $('#create_sub_category_btn').prop("disabled", true);
    });

    $('#sub_category_title').on('input', function(e) {
        if (e.target.value && $("#stock_category_id").val()) {
            $('#create_sub_category_btn').prop("disabled", false); // Element(s) are now enabled.
        } else {
            $('#create_sub_category_btn').prop("disabled", true); // Element(s) are now disabled.
        }
    });

    $('select').on('change', function(e) {
        if ($('#sub_category_title').val() && e.target.value) {
            $('#create_sub_category_btn').prop("disabled", false); // Element(s) are now enabled.
        } else {
            $('#create_sub_category_btn').prop("disabled", true); // Element(s) are now disabled.
        }
    });

    $('.stock_sub_category_searchable_select_path').on('change', function(e) {
        var selectted_text = $(".stock_sub_category_searchable_select_path option:selected").text();
        if (selectted_text == 'frames') {
            $('#stock_clip_path').prop("disabled", false); // Element(s) are now enabled.
        } else {
            $('#stock_clip_path').prop("disabled", true); // Element(s) are now disabled.
        }
    });

    $('#stock_stocktype_input').on('change', function(e) {
        var selectted_text = $("#stock_stocktype_input option:selected").text();
        console.log(selectted_text);
        if (selectted_text == 'Svg') {
            $('#stock_svg').prop("disabled", false); // Element(s) are now enabled.
            $('#stock_image').prop("disabled", true); // Element(s) are now disabled.

        } else {
            $('#stock_svg').prop("disabled", true); // Element(s) are now disabled.
            $('#stock_image').prop("disabled", false); // Element(s) are now enabled.
        }
    });



    $('input[name="approved_formatted_text"]').click(function(event) {
        ajaxCall(event)
    });

    $('input[name="approved_template"]').click(function(event) {
        ajaxCall(event)
    });

    $('input[name="private_template"]').click(function(event) {
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
            data: { approved: event.target.checked, user_id: event.target.className }
        });

        request.done(function(response) {
            console.log(response);
        });

        request.fail(function(jqXHR, response) {
            alert('Something went wrong')
        });
    }

    onInstanceChange = function(instanceType) {

        if (instanceType == 'Design') {

            $('#container_instance_id').find('option').remove().end()

            var request = $.ajax({
                url: '/api/v1/designs/titles/',
                type: "GET"
            });

            request.done(function(response) {
                var design_titles = response.json.titles;
                $.each(design_titles, function(i, item) {
                    $('#container_instance_id').append($('<option>', {
                        value: item.id,
                        text: item.title
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
                $.each(upload_titles, function(i, item) {
                    $('#container_instance_id').append($('<option>', {
                        value: item.id,
                        text: item.title
                    }));
                });
            });
        } else {
            $('#container_instance_id').find('option').remove().end()
        }
    }

});