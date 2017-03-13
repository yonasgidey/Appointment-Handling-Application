#!C:/perl/bin/perl.exe


#PERL MODULES INCLUDED 

use warnings;
use strict;

# we use CGI since this will be executed in a browser
use CGI qw(:standard);
use HTML::TEMPLATE;

use utf8;
use Encode;
use open ':std', ':encoding(utf8)';  
use Cpanel::JSON::XS qw(encode_json decode_json);


use JSON -support_by_pp;
use JSON;
use JSON::PP;

#DBI is the standard database interface for Perl
#DBD is the Perl module that we use to connect to the <a href="http://mysql.com/" />MySQL</a> database
use DBI;
use DBD::mysql;

my $cgi = CGI -> new;




#definition of variables
$databaseName ="appointmentHandling";
$host="localhost";
$user="root";
$password="pass";  #the root password



#Connect to MySQL database.
my $dbh = DBI->connect("DBI:mysql:database=$databaseName:host=$host:3306",$user,$password,{
   PrintError       => 0,
   RaiseError       => 1,
   AutoCommit       => 1,
   FetchHashKeyName => 'NAME_lc',
})   or die "couldn’t connect to appointmentHandling Database".$DBI->errstr;;

 


print header();
print start_html();
my $searchQuery =$cgi->param("search");
my $query;


if($searchQuery eq ""){

$query='SELECT * FROM appointment';

}

$query = 'SELECT * FROM appointment where appointment_Description LIKE '%'. $searchQuery. '%'';
  
  
  
my $statement = $dbh->prepare($query)	die "Prepare failed:DBI::errstr\n";
$statement->execute()
			die "Couldn't Execute Query :DBI::errstr\n";


my $jsonObject=[];

my $matches=$statement->rows(); 

unless($matches){
	print "Sorry, There are no matches\n";
}
else{

# retrieve the values returned from executing your SQL statement
my @data;
while (@data = $statement->fetchrow_array) {
$newdata={
'appointment_Date'=>$data[1],
'appointment_Time'=>$data[2],
'appointment_Description'=>$data[3]
}

push @{$jsonObject},$newdata; 
    
}

}

my $jsonData = JSON->new;
$jsonData = to_json( $jsonObject, { utf8 => 1, pretty => 1 } ); 
print header('application/json');
print "$jsonData";


#quit the database
#Clean up the record set and the database connection 
$sth->finish();
$dbh->disconnect || die "Failed to disconnect";

