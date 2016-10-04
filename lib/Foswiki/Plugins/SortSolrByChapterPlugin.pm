# See bottom of file for default license and copyright information

package Foswiki::Plugins::SortSolrByChapterPlugin;

use strict;
use warnings;

use Foswiki::Func    ();    # The plugins API
use Foswiki::Plugins ();    # For the API version

our $VERSION = '1.0';
our $RELEASE = '1.0';

our $SHORTDESCRIPTION = 'Better sorting for chapters/numbers';

our $NO_PREFS_IN_TOPIC = 1;

sub initPlugin {
    my ( $topic, $web, $user, $installWeb ) = @_;

    # check for Plugins.pm versions
    if ( $Foswiki::Plugins::VERSION < 1.2 ) {
        Foswiki::Func::writeWarning( 'Version mismatch between ',
            __PACKAGE__, ' and Plugins.pm' );
        return 0;
    }

    if ($Foswiki::cfg{Plugins}{SolrPlugin}{Enabled}) {
      require Foswiki::Plugins::SolrPlugin;
      Foswiki::Plugins::SolrPlugin::registerIndexTopicHandler(
        \&indexTopicHandler
      );
    }

    # Plugin correctly initialized
    return 1;
}

sub indexTopicHandler {
    my ($indexer, $doc, $web, $topic, $meta, $text) = @_;

    my $cfg = $Foswiki::cfg{Plugins}{SortSolrByChapterPlugin}{FieldNames};
    return unless $cfg;

    my @fieldNames = ();
    push(@fieldNames, split('\s*,\s*', $cfg->{all})) if $cfg->{all};
    push(@fieldNames, split('\s*,\s*', $cfg->{$web})) if $cfg->{$web};

    foreach my $fieldName ( @fieldNames ) {

        my $chapters = $meta->get('FIELD', $fieldName);
        return unless $chapters;
        $chapters = $chapters->{value};
        return unless defined $chapters && $chapters =~ /^\d+([\.\d]*)?$/;

        my $padding = $Foswiki::cfg{Plugins}{SortSolrByChapterPlugin}{Padding} || 4;

        my $toIndex;

        foreach my $chapter (split(/\s*,\s*/, $chapters)) {
            my $newToIndex = '';
            my @parts = split(/\./, $chapter);
            foreach my $part (@parts) {
                $newToIndex .= '0' x ($padding - length($part));
                $newToIndex .= $part;
            }
            $toIndex = $newToIndex unless(defined $toIndex && (($toIndex cmp $newToIndex) < 0));
        }

        $doc->add_fields( "field_${fieldName}_sort" => $toIndex ) if $toIndex;
    }
}

1;

__END__
Foswiki - The Free and Open Source Wiki, http://foswiki.org/

Copyright (C) 2008-2014 Foswiki Contributors. Foswiki Contributors
are listed in the AUTHORS file in the root of this distribution.
NOTE: Please extend that file, not this notice.

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version. For
more details read LICENSE in the root of this distribution.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

As per the GPL, removal of this notice is prohibited.
