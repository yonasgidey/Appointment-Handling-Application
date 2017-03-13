
#!C:/perl/bin/perl.exe

#PERL MODULES USED

use warnings;
use strict;
# we use CGI since this will be executed in a browser
use CGI qw(:standard);
use HTML::TEMPLATE;

# DBI is the standard database interface for Perl
# DBD is the Perl module that we use to connect to the MySQL database
use DBI;
use DBD::mysql;


#definition of Database variables
our $databaseName ="appointmentHandling";
our $host="localhost";
our $user="root";
our $password="pass";  #the root password



#Connect to MySQL database.
my $dbh = DBI->connect("DBI:mysql:database=$databaseName:host=$host:3306",$user,$password,{
   PrintError       => 0,
   RaiseError       => 1,
   AutoCommit       => 1,
   FetchHashKeyName => 'NAME_lc',
})   or die "couldn’t connect to appointmentHandling Database".$DBI->errstr;;


my $stmt= CREATE TABLE IF NOT EXISTS appointment (
  appointment_No INTEGER PRIMARY KEY AUTOINCREMENT,
  appointment_Date      DATE ,
  appointment_Time    VARCHAR(100),
  appointment_Description    VARCHAR(1000) ,
 
 )
 my $result = $dbh->do($stmt);
 
if($result< 0) {
   print STDERR $DBI::errstr;
} else {
   print STDERR "Table created successfully\n";
}


print start_html()

our $query= new CGI;
print $query->header; 

if($query->param("submit") ){

#Get the parameter from your html form.
my $appointment_Date = $query->param("appointment_Date");
my $appointment_Time = $query->param("appointment_Time");
my $appointment_Description = $query->param("appointment_Description");

}

if ($appointment_Date eq "" or $appointment_Time eq "" or $appointment_Description eq "") {
    &dienice("Please fill out the missing fields.");
}


  
 $insertstmt = "insert into appointment(appointment_Date,appointment_Time,appointment_Description) values(?,?,?)", undef, $appointment_Date,$appointment_time,$appointment_description);
 
$sth = $dbh -> prepare($insertstmt)||
				die "Prepare failed:DBI:: errstr\n"; 
$affectedrow= $sth->execute() ||
					die "Couldn't execute query:DBI::errstr\n";



#redirect to the html page 

my $message;
if ($affectedrow == 1){
  $message =  q(Record has been successfully updated !!!);
}else{
  $message =  q(<b style="color:red">Error!!while inserting records</b+>);
}

# return to html page
my $URL = 'http://localhost/appointment.html';
my $refresh =0;
print $query->header(-type=>"text/html", -expires=>"-1m" , -refresh=>"$refresh ; URL=$URL");

print $query->start_html,$query->p($message),$query->end_html;




 
 # quit the database
 # Clean up the record set and the database connection 
$sth->finish(); 
$dbh->disconnect();
print STDERR "Exit the database\n";

