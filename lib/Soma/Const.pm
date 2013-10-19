use stern;

#/ Project constants.
#/
#/ @author Joel Dalley
#/ @version 2013/Mar/21

use context;

package Soma::Const;
sub SOMA_DIR  { context::PROJ_DIR }
sub DB_FILE { SOMA_DIR . '/db/soma.db' }
sub DSN { 'DBI:SQLite2:' . DB_FILE }

package Soma::Const::Dancer;
sub COVERS_COUNT { 500 }
sub TMPL_DIR { Soma::Const::SOMA_DIR . '/tmpl' }
sub ENV_DIR { Soma::Const::SOMA_DIR . '/env' }
sub CONF_DIR { ENV_DIR }

package Soma::Const::Capsule;
sub FIELDS { qw(genre artist album song) }

package Soma::Const::Song;
sub MAX_FILEPATH { 255 }
sub TABLE { 'song' }
sub COLS { qw(id album_id title track duration filepath) }
sub RAND { 'random' }

package Soma::Const::Album;
sub TABLE { 'album' }
sub COLS { qw(id name artist_id genre_id year) }
sub COVER_DIR { '/usr/local/media/music/.art' }
sub DEFAULT_COVER { COVER_DIR . '/default.jpg' }

package Soma::Const::Artist;
sub TABLE { 'artist' }
sub COLS { qw(id name) }

package Soma::Const::Genre;
sub TABLE { 'genre' }
sub COLS { qw(id name) }

1;
