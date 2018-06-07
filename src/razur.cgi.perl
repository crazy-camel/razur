#!/usr/bin/env perl

#{{> src/pragmas/use }}

# ######################################################################
# # Defaults
# ######################################################################

my $stache = Mustache::Simple->new( extension => 'html' );

my $docroot = path( $ENV{'DOCUMENT_ROOT'} );

# ######################################################################
# # Initialization
# ######################################################################


print "Content-Type: text/html\n\n";

print dump resolve();

#{{> src/path/resolve }}

#{{> src/json/parse }}

#{{> src/cgi/parse }}
