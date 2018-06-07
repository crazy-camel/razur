# ======================================================================
# (@function) resolve - resolves the path
# ----
# (@p) <string> - path_info';
# ----
# (@r) <hashref>
# ======================================================================

sub resolve
{

   my ( $path, @parameters ) = ( {}, () );

    my @fragments = grep { $_ ne '' } split /\//, $ENV{'PATH_INFO'};

    for ( my $i = $#fragments; $i > -1; $i-- )
    {
        my @dir = @fragments[ 0 .. $i ];

        if ( $docroot->child( @dir )->is_dir() )
        {
            my $base = $docroot->child( @dir );

            $path = { 'view' => $path->child( 'index.html' ) };

            if ( $path->child('index.json')->is_file() )
            {
                $path->{'model'} = $path->child('index.json');
            }

            # lets establish views and models with a lookahead

            if ( $fragments[$i-1] && $base->child( $fragments[$i-1].".html" )->is_file() )
            {
                $path->{'view'} = $path->child(  $fragments[$i-1].".html"  );

                if ( $path->child(  $fragments[$i-1].".html"  )->is_file() )
                {
                    $path->{'model'} = $path->child(  $fragments[$i-1].".json"  );
                }
            }

            last;
        }

        push @parameters, $fragments[ $i ];
    }

    # lets reverse the order to ensure it makes sense for parsing later
    @parameters = reverse @parameters if ( @parameters );

    if ( length( $ENV{'QUERY_STRING'} ) > 0 )
    {
        @parameters = ( @parameters, parameters( $ENV{'QUERY_STRING'} ) );
    }

    if ( !$path->{'view'} )
    {
        $path = { 'view' => $docroot->child( 'index.html' ) };

        if ( $docroot->child('index.json')->is_file() )
        {
            $docroot->{'model'} = $docroot->child('index.json');
        }
    }

    return { path => $path, parameters => [ @parameters ] }
}

