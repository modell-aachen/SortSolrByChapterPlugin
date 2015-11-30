# ---+ Extensions
# ---++ SortSolrByChapterPlugin
# **PERL**
# Define which field names should be indexed into the sort field.
# <p>Format: <em>{'WebName' => 'FieldName1, FieldName2', 'all' => 'FieldName3'}</em></p>
# <p>The <em>all</em> web applies to all webs.</p>
$Foswiki::cfg{Plugins}{SortSolrByChapterPlugin}{FieldNames} = {'all' => 'Number'};

# **NUMBER**
# Set this to the length of the highest number we are to encounter.
$Foswiki::cfg{Plugins}{SortSolrByChapterPlugin}{Padding} = 4;

