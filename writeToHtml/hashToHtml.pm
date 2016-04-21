#!/usr/local/perl
package writeToHtml::hashToHtml;
sub printIsHere{
  print "Nothing but here and it is in my module";
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
