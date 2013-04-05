
/*
* A SomaCoverGrid displays & updates a grid of album cover images.
* @author Joel Dalley
* @version 2013/Apr/01
*/

function SomaCoverGrid(jsonUrl) {

    // object properties
    this.jsonUrl = jsonUrl;
    this.covers = [];
    this.count = 0;
    this.seenCnt = 0;
    this.cols = 0;
    this.rows = 0;
    this.imgSize = 0;
    this.gridHeight = 0;


    //////////////////////////////////
    // object methods ////////////////

    this.getJson = function() {
        var scg = this;

        $.ajax({
            async: false,
            url: scg.jsonUrl,
            context: document.body,
            success: function(data) {
                scg.covers = $.parseJSON(data);
                scg.count = scg.covers.length;
            }
        });
    };

    this.draw = function() {
        $('#grid').empty();
        var cellCnt = this.seenCnt >= this.rows*this.cols 
                    ? this.seenCnt - this.rows*this.cols
                    : 0;

        for (var r = 0; r < this.rows; r++) {
            var rowId = 'row' + r;
            var rowAttrs = {'id': rowId, 'class': 'grid-row'};
            $('<div/>', rowAttrs).appendTo('#grid');

            for (var c = 0; c < this.cols; c++) {
                var cell = SomaCoverCell(this, cellCnt % this.count);
                $('#' + rowId).append(cell);
                cellCnt += 1;
            }
        }

        this.seenCnt = cellCnt % this.count;
    }

    this.setGridSize = function() {
        var bodyWidth = $('body').innerWidth();
        var bodyHeight = $('body').innerHeight();

        this.gridHeight = bodyHeight - $('#heading').height()
                                      - $('#nav').height();
        $('#grid').height(this.gridHeight + 'px');

        this.imgSize = Math.ceil(bodyWidth / 6);
        this.cols = Math.ceil(bodyWidth / this.imgSize);
        this.rows = Math.ceil(bodyHeight / this.imgSize);
    };


    // initialize
    this.setGridSize();
    this.getJson();
}

function SomaCoverCell(scg, index) {
    var id = scg.covers[index].id;

    var randMin = 10000;
    var randMax = 25000;

    // img elem
    var imgAttrs = {
        'class': 'coverImg',
        'src': '/cover/' + id,
        'width': scg.imgSize,
        'height': scg.imgSize
        };
    var img = $('<img/>', imgAttrs);

    // a elem
    var a = $('<a/>', {'href': '/play/album/' + id});
    a.html(img);

    // switch cover
    a.ready(function() {
        setTimeout(function() {
           scg.seenCnt = scg.seenCnt + 1 < scg.count 
                       ? scg.seenCnt + 1 : 0;
           var cell = SomaCoverCell(scg, scg.seenCnt);
           a.fadeOut(1000, function() {a.html(cell)}).fadeIn(1000);
        }, randMin + Math.floor(Math.random() * randMax));
    });

    return a;
}
