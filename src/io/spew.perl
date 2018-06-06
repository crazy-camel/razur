
# ======================================================================
# (@function) spew - write contents to a file
# ----
# (@p) <string> - absolute file path
# (@p) <array> - files to slurp
# ----
# (@r)
# ======================================================================
sub spew
{

    my ( $src, $content ) = @_;

    if (open my $fh, '+<:encoding(UTF-8)', $file)
    {
        flock( $fh, LOCK_EX )
            or die "Cannot lock file '$src' - $!\n";

        seek $fh, 0, 0;

        truncate $fh, 0;

        print $fh $content;

        undef $fh;
    }
}

