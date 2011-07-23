$(document).ready(function() {

	var DsModuleFilterController = Backbone.Controller.extend({
		routes: {
			"" : "all",
			"all" : "all", // e.g. #all
			":filter": "filter" // e.g. #Architecture
		},

		all: function() {
			$(".ds-module-wrapper-tag").show();
		},

		filter: function(query) {
			$(".ds-module-wrapper-tag").hide();
			
			$(".ds-module-tag-" + query).show('fast');
		}
	});

	$(function(){
		new DsModuleFilterController();
		Backbone.history.start();
	});

});