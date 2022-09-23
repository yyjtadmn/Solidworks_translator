#!/usr/bin/env perl
use strict;
use warnings;
use File::Copy;
use File::Find;
use File::Basename;
use Fcntl qw(:flock);
use Cwd;
use Net::SMTP;
use XML::Simple;
# #USAGE : Inputs needed for script.
#{
my $num_args = $#ARGV + 1;
my @SaveArgs = @ARGV;                                            # takes all commandline inputs
if ($num_args != 1 ) {
  # print "\n Error : Few arguments missing \n";
  print "\n Directory to download baseline is missing \n";
  exit;
}
###################################################
# initialize
###################################################
#{  Var Declaration
use vars qw(
	$PRODUCT_NAME
	$QQC_BAT
	$Distrib_call_bat
	$DISTRIB_BASELINE
	$DISTRIB_DIR
);
my $os = $^O;
my $bit_system=$ENV{ProgramW6432};
my $DMS_CURRENT_BASELINE='';
my $DMS_PARENT_UNIT='';
my $DISTRIB_DIR =$SaveArgs[0] ;
my $TEST_DIR='';
my $GOLD_DIR='';
my $build_file='';
my $qc_file='';
							my $unit_path ='C:\apps\devop_tools\UDU\tools\bin\wnt\unit.bat';
							my $time=localtime();
							$time=~tr{ }{_};
							$time=~tr{:}{_};
							#my $RESULT_DIR='D:\delete\test';
							my $RESULT_DIR='Q:\64_bit';							  
							my $res_sw_dir=$RESULT_DIR.'/'.'SolidWork_Group_'.$time;
							$res_sw_dir=~tr{/}{\\};
							print "\n".$res_sw_dir."\n";
							unless( -d $res_sw_dir)
							{	
							  mkdir $res_sw_dir or die;
							}
							$RESULT_DIR = $res_sw_dir;
							$RESULT_DIR=~tr{/}{\\};
							my $RESULT_DIR1 = $res_sw_dir.'/'.'wntx64';
							$RESULT_DIR1=~tr{/}{\\};	
							$GOLD_DIR='Q:\64_bit\SolidWork_Group_Mon_Aug__2_20_07_52_2021\wntx64';	
							#$GOLD_DIR='G:\SOLIDWORKS\Test_Results\Swtojt-V18\Win7';
							$GOLD_DIR=~tr{/}{\\};
							 
							#Updating the compare xml file using configxmlinput batch file
									my $JTCompare_file='J:\Group_build\Group_build_scripts\SolidWorks\regrun\solidworks\JTCOMPARE_Config_Solidworks.xml';
									$JTCompare_file=~tr{/}{\\};
									my $xml = new XML::Simple;
									my $data = $xml->XMLin($JTCompare_file);
									my $Gold_path =$data->{GOLD_DIRECTORY};
									my $Test_path =$data->{TEST_DIRECTORY};
									my $Create_XML = 'J:\Group_build\Group_build_scripts\SolidWorks\regrun\configxmlinput.bat' ;
									my $Compare_XML=$Create_XML.' '.$JTCompare_file.' '.$Gold_path.' '.$Test_path.' '.$GOLD_DIR.' '.$RESULT_DIR1;
									system($Compare_XML);
									print "\n Comapare XML Call : -------- \n $Compare_XML\n";
									
							#profile file updating by deleting the previous result and gold directory
									my $resultDir= '#ResultDirectory';
									my $goldDir= '#GoldFileDirectory';
									open (Myfile, '<P:\Data_Exchange\from_Roma\jenkins\Dev_profile_SOLIDWORKS_WIN_dummy.txt');
									my @LINES = <Myfile>;
									close (Myfile);
									open (Myfile, '>P:\Data_Exchange\from_Roma\jenkins\Dev_profile_SOLIDWORKS_WIN_dummy.txt');
									foreach my $LINE (@LINES){
										print Myfile $LINE unless ( $LINE =~ m/$resultDir/ || $LINE =~ m/$goldDir/  );
										}
										close (Myfile);
									
							#profile file updating by adding the new result and gold directory
									open (Myfile, '>>P:\Data_Exchange\from_Roma\jenkins\Dev_profile_SOLIDWORKS_WIN_dummy.txt');
									print Myfile "\n#ResultDirectory=$RESULT_DIR";
									print Myfile "\n#GoldFileDirectory=$GOLD_DIR";
									close (Myfile) ;
									my $textfile ='perl -i.old -n -e "print if /\S/" P:\Data_Exchange\from_Roma\jenkins\Dev_profile_SOLIDWORKS_WIN_dummy.txt';
									system($textfile);
									
							#############################################################################################################################  regrun call
									my $regrun_call= $unit_path.' '.' run'.' '.$DISTRIB_DIR.' '.'perl J:\Group_build\Group_build_scripts\JTCompare_Regrun_2021\regrun\RegRun.pl'.' '.'-profile=P:\Data_Exchange\from_Roma\jenkins\Dev_profile_SOLIDWORKS_WIN_dummy.txt'.' '.'-compXml='.$JTCompare_file.' '.'-resDir='.$RESULT_DIR.' '.'-jtcomp_opt=0'.' '.'-type=group'.' '.'>'.' '.$RESULT_DIR.'/'.'SW_Regrun_log_'.$time.'.txt';
									print "\n Regrunner Call : -------- \n $regrun_call\n";
									system($regrun_call);
									my $outline='echo Solidwork regrun succeeded';
									system($outline);
							#############################################################################################################################  regrun end
							  
							  if(!$bit_system)
									{			
										my $bmail_loc ='J:\Group_build\Group_build_scripts\tools\bmail.exe';
										$bmail_loc =~ tr{/}{\\};
										my $text_mail ='call'.' '.$bmail_loc.' '.'-s pnsmtp -t mohapatr@ugs.com -f mohapatr@ugs.com  -a "SW_(32 bit)_ Regrun Testing Completed . ( Map J: drive to \\pnqfiler2\jtdev)  Group Regrun   at:--"'. $RESULT_DIR ;		
										system($text_mail );   
										$text_mail ='call'.' '.$bmail_loc.' '.'-s pnsmtp -t dhokrika@ugs.com -f mohapatr@ugs.com  -a "SW(32 bit)_ Regrun Testing Completed .( Map J: drive to \\pnqfiler2\jtdev) Group Regrun   at:--"'. $RESULT_DIR ;
										system($text_mail );
									
									}else{
										my $bmail_loc ='J:\Group_build\Group_build_scripts\tools\bmail.exe';
										$bmail_loc =~ tr{/}{\\};
										my $text_mail ='call'.' '.$bmail_loc.' '.'-s pnsmtp -t mohapatr@ugs.com -f mohapatr@ugs.com  -a "SW_(64 bit)_ Regrun Testing Completed .( Map J: drive to \\plm\pnnas\jtdev)  Group Regrun   at:--"'. $RESULT_DIR ;		
										system($text_mail );   
 
									}		
							  
	  