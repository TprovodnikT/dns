#!/usr/bin/perl
package util::JSONToObject;
use Data::Dumper;
use JSON;
use Switch;
$pathtoFile = $ARGV[0];
sub convertFileToString{
  if (length($pathToFile) == 0){
    $pathToFile = '/home/jn/workspace/bash_tut/perl_tutorial/domains_full_info';
    $pathToFile = '/home/jn/workspace/bash_tut/perl_tutorial/domains_full_info';
  }
  local $/ = undef;
  open (my $fhIn, '<:encoding(UTF-8)', $pathToFile)
    or die "Could not open JSON file $pathToFile";
  $fileContent = <$fhIn>;
  close $fhIn;
  return $fileContent;
}
sub convertJsonToHash {
  $string = convertFileToString();
  $json = JSON->new->allow_nonref;
  @allInfo = $json->decode($string);
#  print Dumper(\@allInfo);
}
#convertJsonToHash();
1;
