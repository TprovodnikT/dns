#!/usr/bin/perl
use JSON;
use util::subroutine;
$pathToFile = $ARGV[0];
$pathToOut = $ARGV[1];
#sub getMxAndIp {
#  @domains = @_;
##  while ($row = <$fh>) {
#  foreach $domain (@domains) {
#    chomp $domain;
#    print $fhOut "domain:\n" . $domain;
#    @domainRecords = `host $domain`;
#    @domainIps = ();
#    @mxRecords = ();
#    for $record (@domainRecords){
#      if ($record =~ m/has\ address\ (.*)$/){
#        $domainIp = $1;
#        push @domainIps, $domainIp; 
#      }elsif (index($record, "mail is handled") > -1){
#        $record =~ /.*\ (.*)\.$/;
#        $mxRec = $1;
#        push @mxRecords, $mxRec;
#      }
#    }
#  }
#}

sub getIps {
  my @domainIps = ();
  my $domain = shift(@_);
  my @records = `host -t a $domain`;
  foreach my $record (@records){
     if ($record =~ m/has\ address\ (.*)$/){
       my $domainIp = $1;
       push @domainIps, $domainIp; 
     } 
  }
  return \@domainIps;
}

sub getMxs {
  my $json = JSON->new->allow_nonref;
  my @mxRecords = ();
  my %mxRecord = ();
  my $domain = shift(@_);
  my @records = `host -t mx $domain`;
  foreach my $record (@records){
    if (index($record, "mail is handled") > -1){
       $record =~ /.*\ (.*)\.$/;
       my $mxRec = $1;
       $mxRecord{'mx_name'} = $mxRec;
       @mxRecord{'mx_ips'} = getIps($mxRec);
       for $i (@mxRecord{'mx_ips'}){
         print $i . "\n";
       }
       push @mxRecords, \%mxRecord;
    }
  }
  return @mxRecords;
}

sub getDomainsFromFile{
  @domains = ();
  $pathToFile = shift(@_);
  open($fh, '<:encoding(UTF-8)', $pathToFile)
    or die "Could not open file $pathtoFile";
  while ($row = <$fh>){
    chomp($row);
    push @domains, $row;
  }
  return @domains;
   
}

sub saveResultToFile{
  $pathToFile = shift(@_);
  $pathToOut = shift(@_);

  if (length($pathToFile) == 0) {
    $pathToFile = '/home/jn/workspace/bash_tut/perl_tutorial/active_domains';
  }
  if (length($pathToOut) == 0) {
    $pathToOut = '/home/jn/workspace/bash_tut/perl_tutorial/domains_full_info';
  }
  @domains = getDomainsFromFile($pathToFile);
  open ($fhOut, '>', $pathToOut)
    or die "Could not open file $pathToOut";
  %domainInfo = ();
  foreach $domain (@domains){
    $domainInfo{'name'} = $domain;
    @domainMxs = getMxs($domain);
    $domainInfo{'mx'} = \@domainMxs;

    @domainInfo{'ip'} = getIps($domain);
    $json = JSON->new->allow_nonref;
    $prettyPrinted = $json->pretty->encode(\%domainInfo);
    print $fhOut $prettyPrinted;
  }
}
#    print $fhOut "\ndomain_ips:\n";
#    for $domainIp (@domainIps) {
#      print $fhOut $domainIp . "\n";
#    }
#
#  print $fhOut "mx_records:\n";
#  for $mxRecord (@mxRecords){
#    if (length($mxRecord) > 0) {
#      @mxRecIps = `host $mxRecord`;
#      print $fhOut "$mxRecord\nmx_ips:\n";
#      foreach $mxRecIp (@mxRecIps) {
#        $mxRecIp =~ m/has\ address\ (.*)$/;
#	$mxRecIp = $1;
#        print $fhOut $mxRecIp . "\n";
#      } 
#    }
#  }
#
#  print $fhOut "\n";
#  
#
#print "@domains\n";
#sub 
saveResultToFile();
