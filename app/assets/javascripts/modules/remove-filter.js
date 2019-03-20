window.GOVUK = window.GOVUK || {};
window.GOVUK.Modules = window.GOVUK.Modules || {};

(function (global, GOVUK) {
  'use strict';

  GOVUK.Modules.RemoveFilter = function () {
    this.start = function (element) {
      $(element).on('click', '[data-module="remove-filter-link"]', toggleFilter);
    };

    function toggleFilter(e) {
      e.preventDefault();
      e.stopPropagation();
      var $el = $(e.target);

      var removeFilterName = $el.data('name');
      var removeFilterValue = $el.data('value');
      var removeFilterFacet = $el.data('facet');

      var $input = getInput(removeFilterName, removeFilterValue, removeFilterFacet);
      clearFacet($input, removeFilterValue, removeFilterFacet);
      fireRemoveTagTrackingEvent(removeFilterValue, removeFilterFacet);
    }

    function clearFacet($input, removeFilterValue, removeFilterFacet) {
      var elementType = $input.prop('tagName');
      var inputType = $input.prop('type');
      var currentVal = $input.val();

      if (inputType == 'checkbox') {
        $input.prop("checked", false);
        $input.trigger('change');
      }
      else if (inputType == 'text' || inputType == 'search') {
        $input.val(currentVal.replace(removeFilterValue, '').replace(/\s+/g,' ').trim()).trigger({
          type: "change",
          suppressAnalytics: true
        });
      }
      else if (elementType == 'OPTION') {
        $('#' + removeFilterFacet).val('').trigger('change');
      }
    }

    function getInput(removeFilterName, removeFilterValue, removeFilterFacet) {
      var selector = (!!removeFilterName) ? " input[name='" + removeFilterName + "']" : " [value='" + removeFilterValue + "']";

      return $(selector);
    }

    function fireRemoveTagTrackingEvent(filterValue, filterFacet) {
      var category = "facetTagRemoved";
      var action = filterFacet;
      var label = filterValue;

      GOVUK.analytics.trackEvent(
        category,
        action,
        { label: label }
      );
    }
  };
})(window, window.GOVUK);
