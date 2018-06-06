# ======================================================================
# (@function) parse - parse the querystring for the request if available
# ----
# (@p) <string> - querystring 'after the \?';
# ----
# (@r) <hashref>
# ======================================================================
sub parameters
{
    require HTML::Entities;

    my ( $parameters, $query ) = ( {}, @_ );

    if ( $query ){

        my @pairs = split( /&/, $query);

        foreach $pair (@pairs){

            my ($name, $value) = split( /=/, $pair);

            $value =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;

            my $encode_entities = join( "", ('&','<','>','"',"'", "\012\015" ) ) ;

            $parameters->{ $name } = HTML::Entities::encode_entities( $value , join( "", ('&','<','>','"',"'", "\012\015" ) ) )  ;
        }
    }

    return $parameters;
}
