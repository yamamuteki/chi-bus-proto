# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  $("#new_bus_stop_search").on("ajax:success", (e, data, status, xhr) ->
    $("#result").html xhr.responseText
    $("#error").removeClass "field_with_errors"
  ).on "ajax:error", (e, xhr, status, error) ->
    $("#result").html ""
    $("#error").addClass "field_with_errors"
