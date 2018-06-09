#!/usr/bin/env perl

use utf8;
use strict;
use warnings;

use feature ":5.16";

use lib '.';

use Path::Tiny 'path';
use JSON::MaybeXS;

use Mustache::Simple;

use Data::Dump 'dump';



# ######################################################################
# # Defaults
# ######################################################################


my $stache = Mustache::Simple->new( extension => 'html', partials => path( $ENV{'TEMPLATE_PARTIALS'} )->stringify );

my $docroot = path( $ENV{'DOCUMENT_ROOT'} );

# ######################################################################
# # Initialization
# ######################################################################


print "Content-Type: text/html\n\n";

print "ok --> ";

print unpack('a', $ENV{'PATH_INFO'} );
exit;

my $request = resolve();


print dump $request;


my $context = { query => $request->{'query'} };

if ( $request->{'path'}->{'model'} )
{
    my $json = decode_json $request->{'path'}->{'model'}->slurp_utf8;
    $context = {
        %$json,
        %$context
    };
}

print dump $context;

print $stache->render(
        $request->{'path'}->{'view'}->slurp_utf8,
        $context
    );
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


            $path = { 'view' => $base->child( 'index.html' ) };

            if ( $base->child('index.json')->is_file() )
            {
                $path->{'model'} = $base->child('index.json');
            }

            # lets establish views and models with a lookahead

            if ( $fragments[$i+1] && $base->child( $fragments[$i+1].".html" )->is_file() )
            {
                $path->{'view'} = $base->child(  $fragments[$i+1].".html"  );

                if ( $base->child(  $fragments[$i+1].".json"  )->is_file() )
                {
                    $path->{'model'} = $base->child(  $fragments[$i+1].".json"  );
                }

                pop @parameters;
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

    push @parameters, '*' if ( @parameters % 2 != 0 );

    if ( !$path->{'view'} )
    {
        $path = { 'view' => $docroot->child( 'index.html' ) };

        if ( $docroot->child('index.json')->is_file() )
        {
            $path->{'model'} = $docroot->child('index.json');
        }
    }

    return { path => $path, query => { @parameters } }
}



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

