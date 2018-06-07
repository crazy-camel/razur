
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

    my ( $filename, $overrides ) = ( @_ );

    my $json = decode_json path( $filename )->slurp_utf8;

    return { %$json, %$overrides };
}
