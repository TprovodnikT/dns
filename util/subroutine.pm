#!/usr/bin/perl
package util::subroutine;

sub printArr{
  my @list = @_;
  foreach $i (@list) {
    print "$i\n";
  }
}

sub contains{
  my $element = shift(@_);
  my @list = @_;
  foreach $i (@list){
    if ($i eq $element) {
      return 1;
    }
  }
  return -1;
}

sub printHash(){
  my %hash = @_;
  foreach my $key ( keys %hash )
  {
    print "$key $hash{$key}\n";
  }
}

sub checkHashOrArray{
  my $var = shift(@_);
  return ((ref(\$var) eq 'HASH') 
    || (ref(\$var) eq 'ARRAY'));
}

1;
