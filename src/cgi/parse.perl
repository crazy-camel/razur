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

    my ( $query, @parameters ) = ( shift );

    if ( $query )
    {

        my @pairs = split( /&/, $query);

        foreach my $pair (@pairs)
        {

            my ($name, $value) = split( /=/, $pair);

            $value =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;

            push @parameters, $name;

            push @parameters, HTML::Entities::encode_entities( $value , join( "", ('&','<','>','"',"'", "\012\015" ) ) ) ;
        }
    }

    return @parameters;
}
