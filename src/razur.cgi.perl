#!/usr/bin/env perl

#{{> src/pragmas/use }}

# ######################################################################
# # Defaults
# ######################################################################

my $stache = Mustache::Simple->new( extension => 'html', partials => path( $ENV{'TEMPLATE_PARTIALS'} )->stringify );

my $docroot = path( $ENV{'DOCUMENT_ROOT'} );

# ######################################################################
# # Initialization
# ######################################################################


print "Content-Type: text/html\n\n";

my $request = resolve();

print $stache->render( $request->{'path'}->slurp_utf8, { parameters => $request->{'parameters'} } )

#{{> src/path/resolve }}

#{{> src/json/parse }}

#{{> src/cgi/parse }}
