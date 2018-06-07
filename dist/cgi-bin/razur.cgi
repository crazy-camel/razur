#!/usr/bin/env perl

use utf8;
use strict;
use warnings;

use feature ":5.16";

use lib '.';

use Path::Tiny 'path';
use JSON::MaybeXS;



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

            $parameters->{ $name } = HTML::Entities::encode_entities( $value , join( "", ('&','<','>','"',"'", "\012\015" ) ) )  ;
        }
    }

    return $parameters;
}

