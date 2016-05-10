#!/usr/bin/perl
use writeToHtml::hashToHtml;
use util::JSONToObject;
use Data::Dumper;

@fullInfo = util::JSONToObject::convertJsonToHash();
$header = writeToHtml::hashToHtml::printFromFileHeader("htmlHeader.html");
my $body = "";
foreach my $domains (@fullInfo) {
   foreach my $domain (@$domains) {
     $body .= '<tr>';
     $body .= writeToHtml::hashToHtml::printCells($domain->{'name'});
#     my @ipArr = @{$domain->{'ip'}};
     my $ips = writeToHtml::hashToHtml::printInnerTableFromArray(@{$domain->{'ip'}});
#     print "@ipArr\n";
     my @mx = @{$domain->{'mx'}};
     my $mx_table = writeToHtml::hashToHtml::printMXTable(@mx); 
#     print $mx_table;
     
      
     $body .= writeToHtml::hashToHtml::printCells($ips);
#     print Dumper ($domain); 
     
#     foreach my $ip ($domain->{'ip'}){
#              
#     }
#     my $name = $domain->{'name'};
     $body .= '<\tr>';
#     print $body;
     die "here";
   }
}

