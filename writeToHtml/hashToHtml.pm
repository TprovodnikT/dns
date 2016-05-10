#!/usr/local/perl
package writeToHtml::hashToHtml;
use Data::Dumper;
sub printIsHere{
  print "Nothing but here and it is in my module";
}
sub printFromFileHeader{
  my $fileHeader = shift(@_);
  local $/ = undef;
  open (my $fhIn, '<:encoding(UTF-8)', $fileHeader)
    or die "Could not open header containing file";
  $header = <$fhIn>;
  close $fhIn;
  return $header;
}
sub printInfoTable{
  my @info = @_;
  my $result = '<table>';
  $result .= '<tr>';
  for my $person (@info){
    $result .= 
  }
  $result .= '<\tr>';
  $result .= '<\table>';
}
sub printMXTable{
  my @mx = @_;
  my $result = '<table>';
  for my $mx_record (@mx){
    $result .= '<tr>';
    $result .= printCells($mx_record->{'mx_name'});
    $result .= printCells(printInnerTableFromArray(@{$mx_record->{'mx_ips'}}));
#     print Dumper $mx_record;
    $result .= '</tr>';
  } 
  $result .= '</table>';
  return $result;
}
sub printTableHeader{
  my @list = @_;
  $header = '<tr>';
  foreach $i (@list){
    $header = $header . '<th>' . $i . '</th>';
  }
  $header = $header . '</tr>';
  print $header;
}
#sub printMX{} 
sub printInnerTableFromArray{
  my @values = @_;
#  @values = [0];
#  print Dumper($values);
  $result = '<table>';
  for my $value (@values) {
#    print "\n val: $value .";
    $result .= '<tr><td>';
#    print Dumper($value);
    $result .= $value;
    $result .= '</td></tr>';
  }
  $result .= '</table>';
  return $result;
}
sub printCells{
  my @cells = @_;
  my $result = '';
  for my $cell (@cells){
    $result .= '<td>' . $cell . '</td>';
  }
  return $result;
}

sub printTableBody{
 my @list = (values @_);
 $res = '<tr>';
 foreach $i (@list){
   $res = $res . '<td>';
   if (checkHashOrArray($i)) {
     $res = $res . printInnerTable($i);
   }else {
     $res = $res . $i;
   }
   $res = $res . '</td>';
 }
 $res = $res . '</tr>';
}

sub printInnerTable{
  my $res = '<table>';
  my $list = @_;
  if (ref(\$list) eq 'HASH'){
    @list = (values $list);
  }else{
    @list = $list;
  }
  foreach $i (@list){
    my $res = $res . '<tr><td>';
    if (checkHashOrArray($i)){
      $res = $res . printInnerTable($i);
    }else{

    }
    my $res = $res . '</td></tr>';
  }
  my $res = '</table>';
}
1;
