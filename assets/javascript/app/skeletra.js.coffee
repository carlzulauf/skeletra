# Simple example/test coffeescript file

class window.Skeletra
  constructor: ->
    $("#js-test-output").text("Hello from Coffee Script!")

$ ->
  new Skeletra
