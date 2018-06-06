
# ======================================================================
# (@function) slurp - read the file contents and returns then as a scalar
# ----
# (@p) <string> - filename
# ----
# (@r) <string> - contents of file
# ======================================================================
sub slurp
{
    my ( $file ) = ( @_ );
    if ( not -f $file )
    {
        return;
    }
    return do { local ( @ARGV, $/ ) = $file; <> };
}
