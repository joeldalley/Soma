
/*
* A SomaAudio loads song data JSON, updates the DOM to 
* reflect the current song, and controls playing of audio.
* @author Joel Dalley
* @version 2013/Mar/31
*/

function SomaAudio(jsonUrl, randomize) {

    // object properties
    this.jsonUrl = jsonUrl;
    this.randomize = randomize;
    this.audio = new Audio();
    this.origH1 = '';
    this.songs = [];
    this.count = 0;
    this.index = 0;

    //////////////////////////////////
    // object methods ////////////////

    this.getJson = function() {
        var sa = this;

        $.ajax({
            async: false,
            url: sa.jsonUrl,
            context: document.body,
            success: function(data) {
                sa.songs = $.parseJSON(data);
                sa.count = sa.songs.length;
            }
        });
    };

    this.setText = function() {
        var curr = this.songs[this.index];
        var prev = this.songs[this.prevIdx()];
        var next = this.songs[this.nextIdx()];

        var track = $('<span/>', {'id': 'track'});
        track.html('[ ' + (this.index + 1) + ' / ' + this.count + ' ]');

        $('#title').html(curr.title);
        $('#artist').html(curr.artist);
        $('#album').html(curr.album);
        $('#h1').html(this.origH1).append(track);

        $('#title').attr('title', curr.title);
        $('#artist').attr('title', curr.artist);
        $('#album').attr('title', curr.album);

        if (!this.randomize) {
            $('#prev').attr('title', prev.title);
            $('#next').attr('title', next.title);
        }
    };

    this.coverSrc = function() {
        var curr = this.songs[this.index];
        var imgUrl = 'url(/cover/' + curr.albumId + ')';
        var currImgUrl = $('#play').css('background-image');
        if (imgUrl != currImgUrl) 
            $('#play').css('background-image', imgUrl);
    };

    this.audioSrc = function() {
        var curr = this.songs[this.index];
        this.audio.setAttribute('src', '/audio/' + curr.songId);
        this.audio.load();
    };

    this.playPause = function() { 
        if (this.audio.paused) return this.play();
        this.pause();
    };

    this.play = function() {
        this.audio.play();
        $('#play-pause > a').html('pause');
    };

    this.pause = function() {
        this.audio.pause();
        $('#play-pause > a').html('play');
    };

    this.next = function() {
        if (this.randomize) this.getJson();
        this.index = this.nextIdx();
        this.setText();
        this.coverSrc();
        this.audioSrc();
        this.play();
    };

    this.nextIdx = function() {
        return this.index + 1 >= this.count ? 0 : this.index + 1
    };

    this.prev = function() {
        if (this.randomize) this.getJson();
        this.index = this.prevIdx();
        this.setText();
        this.coverSrc();
        this.audioSrc();
        this.play();
    };

    this.prevIdx = function() {
        return this.index - 1 < 0 ? this.count - 1 : this.index - 1
    };

    this.prog = function() {
        var pct = 0;
        var dur = this.audio.duration;
        var time = this.audio.currentTime;

        if (time) {
            pct = Math.min(100, Math.floor(100 * time / dur));
            var rem = Math.max(0, Math.floor(dur - time));
            var com = Math.max(0, Math.floor(time));
            $('#remaining').html(formatTime(rem));
            $('#completed').html(formatTime(com));
        }

        $('#progress').css('width', pct + '%');
    };

    this.init = function() {
        var sa = this;
        sa.audio.addEventListener(
            'ended',
            function() {
                sa.next();
                sa.prog();
            },
            false
        );
        sa.audio.addEventListener(
            'timeupdate', 
            function() {sa.prog()},
            false
        );
        sa.origH1 = $('#h1').html();
        sa.getJson();
    };

    this.init();
}

function formatTime(input) {
    var h = Math.floor(input / 3600);
    var m = Math.floor(input / 60);
    var s = input % 60;

    if (m < 10) m = '0' + m;
    if (s < 10) s = '0' + s;

    var t = h ? [h, m, s] : [m, s];
    return t.join(':');
}

