#!/usr/bin/perl
#Version, that get list of active domains and store in file
#Working, do not change
sub contains{
  $element = shift(@_);
  @list = @_;
  foreach $i (@list){
    if ($i eq $element) {
      return 1;
    }
  }
  return 0;
}

sub getIpAddr{
  my @res = ();
  my $host = shift(@_);
  my @list = `host $host`;
  foreach $i (@list){
    if ($i =~ /has\ address\ (.*)/){
      push(@res, $1);
    }
  }
  return @res;
}

#checked work like a charm
sub changeArrayToPartOf {
  ($mask) = shift(@_);
  (@array) = @_;
  @result = ();
  foreach $el (@array){
    if ($el =~ m/$mask/){
       push @result, $1;
    }
  }
  return @result;

}

sub ifEuroprojects {
  open($fh, '>', 'active_domain');
  @dnsservers = @_;
  @domains = `grep -R '\$ORIGIN' /etc/bind/`;
  foreach $domain (@domains) {
    $domain =~ m/\ (.*)\.$/;
    $domain = $1;
    @domainsDnsServers = changeArrayToPartOf('name server (.*)\.$', `host -t ns $domain`);
    $flagContainsDns = 0;
    foreach $dnsRecord (@dnsservers){
      if (contains($dnsRecord, @domainsDnsServers)){
        $flagContainsDns = 1;
        break;
      }
    }
    if((length(@domainsDnsServers) > 0) && $flagContainsDns){
       print $domain . "\n";
       print $fh $domain . "\n";
    }
  }
  close $fh;
  print "Done";
}

$dnsserver1 = "some_domain";
$dnsserver2 = "some_domain";
@dnsservers = ($dnsserver1, $dnsserver2);
ifEuroprojects(@dnsservers);

