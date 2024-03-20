// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
//= require jquery
import "@hotwired/turbo-rails";

Turbo.session.drive = false;

import "controllers";
import "./tourhero";

