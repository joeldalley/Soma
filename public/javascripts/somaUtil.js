function urlOnEnter(url) {
    $(document).keypress(function(e) {
        if (e.which != 13) return;
        location.href = url;
    });
}
