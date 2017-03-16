jQuery(document).ready(function ($) {
    $('.switch-buttons').on('click', 'button', function (event) {
        var payload = {
            mode_name: $(event.target).data('mode')
        };
        $('button').prop('disabled', true);
        $.post('api/switch', payload)
            .done(handleResponse)
    });
    var $status = $('.functions button.status');
    $status.on('click', function () {
        $('button').prop('disabled', true);
        $.get('api/status')
            .done(handleResponse);
    });
    $status.click();
    function handleResponse(data) {
        $('.response').text(data);
        $('button').prop('disabled', false);
    }
});
