#!/usr/bin/perl
use strict;
use warnings;
my ($file) = @ARGV;
my $customIdent = " " x 4;
if(not defined $file){
  print "iziIdenter : fileSrc [fileDest] [customIdent]";
  die;

}
if( defined $ARGV[2]){
  $customIdent = "$ARGV[2]";
}
open my $IN_FILE,"<$file", or die "Error opening file ";

my $formated_line = "";
while (defined (my $line=<$IN_FILE>) ){
  $line =~ s/^\s*//;
  $line =~ s/;\s*/;/;
  if($line=~ /^#/){
	$line .= "\\#";
}
  $formated_line .= $line;
  chomp($formated_line);

}

$formated_line =~ s/[\t\n\r]//g;

close $IN_FILE;
my $code = "";
my $ident=0;
my $i=0;
my $bfr="";
my $inString=0;
while ($i< length($formated_line)){
  my $c_char = substr($formated_line,$i,1);
  if($c_char eq "\{" && ! $inString){
    $code .= ("$customIdent" x $ident).$bfr."{\n";
    $bfr="";
    $ident += 1;
  }
  elsif($c_char eq "\}" && ! $inString){
      if( length($bfr) != 0){
        $code .= ("$customIdent" x $ident).$bfr;
      }
      $ident -= 1;
      $code .= ("$customIdent" x ($ident))."}\n";
      $bfr="";
  }
  elsif($c_char eq ";" && ! $inString){
    $code .= ("$customIdent" x $ident).$bfr.";\n";
    $bfr="";
  }
  elsif($c_char  eq  "\""){
    $inString=!$inString;
    $bfr .= $c_char;
  }
  elsif($c_char eq "\\"){
    $bfr .= substr($formated_line,$i,2);
    $i++;
  }
  else{
    $bfr .= $c_char;

  }
  $i++;

}
$code .= $bfr;
$code =~ s/\\#/\n/g;

my $target=$ARGV[0];
if(defined $ARGV[1]){
  $target =$ARGV[1];
}
open my $FILE ,">$target",or die "error";
print $FILE  $code;
close $FILE;
print "output : $target\n";
