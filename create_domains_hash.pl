#!/usr/bin/perl
use util::subroutine;
$pathToFile = $ARGV[0];
$pathToOut = $ARGV[1];
if (length($ARGV[0]) == 0) {
  $pathToFile = '/home/jn/workspace/bash_tut/perl_tutorial/active_domains';
}
if (length($ARGV[1]) == 0) {
  $pathToOut = '/home/jn/workspace/bash_tut/perl_tutorial/domains_full_info';
}

open ($fhOut, '>', $pathToOut);
#print "\nHere: $pathToFile\n";
open($fh, '<:encoding(UTF-8)', $pathToFile)
  or die "Could not open file $pathtoFile";
sub getMxAndIp {
  @domains = @_;
#  while ($row = <$fh>) {
  foreach $domain (@domains) {
    chomp $domain;
    print $fhOut "domain:\n" . $domain;
    @domainRecords = `host $domain`;
    @domainIps = ();
    @mxRecords = ();
    for $record (@domainRecords){
      if ($record =~ m/has\ address\ (.*)$/){
        $domainIp = $1;
        push @domainIps, $domainIp; 
      }elsif (index($record, "mail is handled") > -1){
        $record =~ /.*\ (.*)\.$/;
        $mxRec = $1;
        push @mxRecords, $mxRec;
      }
    }
  }
}
  
  print $fhOut "\ndomain_ips:\n";
  for $domainIp (@domainIps) {
    print $fhOut $domainIp . "\n";
  }

  print $fhOut "mx_records:\n";
  for $mxRecord (@mxRecords){
    if (length($mxRecord) > 0) {
      @mxRecIps = `host $mxRecord`;
      print $fhOut "$mxRecord\nmx_ips:\n";
      foreach $mxRecIp (@mxRecIps) {
        $mxRecIp =~ m/has\ address\ (.*)$/;
	$mxRecIp = $1;
        print $fhOut $mxRecIp . "\n";
      } 
    }
  }

  print $fhOut "\n";
  

print "@domains\n";
#sub 
