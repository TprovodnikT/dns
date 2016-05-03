#!/usr/bin/perl
use Clone 'clone';
use JSON;
use Switch;
use util::subroutine;
$pathToFile = $ARGV[0];
$pathToOut = $ARGV[1];

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

sub setFlagForWhois{
  my $flag = shift(@_);
  my $line = shift(@_);
  if(index($line, '[Holder]') > -1){
    $flag = "holder";
  }elsif(index($line, '[Tech]') > -1){
    $flag = "tech";
  }elsif(index($line, '[Registrar]') > -1){
    $flag = "registrar";
  }
  return $flag;
}

sub getInfoFromWhois{
  my @contactPersonInfo = ();
  my $domain = shift(@_);
  my @interestingFields = ('Type', 'Email','Phone', 'Name');
  my $flag = "";
  my @result = ();
  my %holder = ();
  my %tech = ();
  my %registrar = ();
  my @fullInfo = `whois $domain`;
#  my @fullInfo = `cat delfi_lv`;
  foreach my $line (@fullInfo){
    $flag = setFlagForWhois($flag, $line);
    if ($flag ne  ""){
      $line =~ /(.*?)\:/;
      my $key = $1;
      $line =~ /\: (.*)$/;
      my $value = $1;
      if (util::subroutine::contains($key, @interestingFields) > -1){
        #print "\n$flag";
        #print "\n$key is $value\n";
	switch($flag){
	  case "holder"{
	    $holder{'person_type'} = 'holder';
	    $holder{$key} = $value;
	  } 
	  case "tech"{
	    $tech{'person_type'} = 'tech';
	    $tech{$key} = $value;
	  }
	  case "registrar"{
	    $registrar{'person_type'} = 'registrar';
	    $registrar{$key} = $value;
	  }
	}
      }
    }
  }
  push @result, \%holder;
  push @result, \%tech;
  push @result, \%registrar;
#  $json = JSON->new->allow_nonref;
#  $string_json = $json->pretty->encode(\@result);
#  print $string_json;
  return \@result;
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
#  @domains = ("google.lv", "delfi.lv");
  @domainsFullInfo = ();
  %domainInfo = ();
  foreach $domain (@domains){
    $domainInfo{'name'} = $domain;
    @domainMxs = getMxs($domain);
    $domainInfo{'mx'} = \@domainMxs;
    @domainInfo{'ip'} = getIps($domain);
    @domainInfo{'info'} = getInfoFromWhois($domain);
    push @domainsFullInfo, clone (\%domainInfo);
#    $json = JSON->new->allow_nonref;
#    $prettyPrinted = $json->pretty->encode(\%domainInfo);
#    print $fhOut $prettyPrinted;
    %domainInfo = ();
  }
    $json = JSON->new->allow_nonref;
    $prettyPrinted = $json->pretty->encode(\@domainsFullInfo);
#    print $prettyPrinted;
    print $fhOut $prettyPrinted;
}

saveResultToFile();
