
# ======================================================================
# (@function) parse - parse a JSON file
# ----
# (@p) <string> - json file to open and parse
# (@p) <hashref> - override parameters
# ----
# (@r) <hashref>
# ======================================================================
sub parse
{
    require JSON;

    my ( $filename, $overrides ) = ( @_ );

    my $json = decode_json slurp( $filename );

    return { %$json, %$overrides };
}
