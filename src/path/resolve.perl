# ======================================================================
# (@function) resolve - resolves the path
# ----
# (@p) <string> - path_info';
# ----
# (@r) <hashref>
# ======================================================================

sub resolve
{

   my ( $path, @parameters ) = ( '', () );

    my @fragments = grep { $_ ne '' } split /\//, $ENV{'PATH_INFO'};

    for ( my $i = $#fragments; $i > -1; $i-- )
    {
        my @dir = @fragments[ 0 .. $i ];

        if ( $docroot->child( @dir )->is_dir() )
        {
            $path = $docroot->child( @dir );

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

    if ( $path eq '' )
    {
        $path = 'index.html';
    }

    return { path => $path, parameters => [ @parameters ] }
}

