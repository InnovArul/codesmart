#******************************************************************************
 # Copyright (c) 2016 Arulkumar (arul.csecit@ymail.com).
 # All rights reserved. This program and the accompanying materials
 # are made available under the terms of the Eclipse Public License v1.0
 # which accompanies this distribution, and is available at
 # http://www.eclipse.org/legal/epl-v10.html
 #
 # Contributors:
 #     Arulkumar (arul.csecit@ymail.com)
 #
 # Dependencies:
 #
 # make sure to install Devel::GDB from CPAN
 #
 # This is a prototype script for the evaluation of Assembly programs by communicating with GDB.
 # This script needs to be run on Host PC. 
 #
 # The main APIs to be noted are : executeGDBcommands, executeCompiler
 # 
 #******************************************************************************/
use strict;
use warnings;
use Log::Log4perl qw(:easy);
use Log::Log4perl qw(get_logger);
use File::Basename;
use Devel::GDB;
use Cwd 'abs_path';
use Devel::GDB;
my $rootDirectory = dirname(abs_path($0));
my $oddAddress = $ARGV[0];
my $evenAddress = $ARGV[1];

my $log_conf = "../log4perl.conf";
Log::Log4perl::init($log_conf);

my $logger = get_logger();
$logger->trace("ALP Lab Assignment-1 evaluation ");
$logger->trace("Odd seg Address = $oddAddress, Even seg Address = $evenAddress ");

$logger->trace("root folder: $rootDirectory");

sub gdb_send_cmd {
	my $command = shift;
	my $gdb = shift;

	#$logger->trace("$command");
	my $output = $gdb->send_cmd_excl( $command); 
	return $output;
}

sub gdb_get {
	my $command = shift;
	my $gdb = shift;

	#$logger->trace("$command");
	my @output = $gdb->get( $command); 
	my $allOutput = join(' , ', @output);
	chomp($allOutput);
	return $allOutput;
}

sub verifySIGTRAP { 
	my $output = shift;
	my $status = 0;
	if($output !~ /sigtrap/ig) {
		$status = 1;
		$logger->trace('SIGTRAP not found! something wrong!');
	} else	{
		$logger->trace('SIGTRAP found! program executed successfully!');
	}
	
	return $status;
}

sub verifyOddFibNumbers { 
	my $output = shift;
	$logger = get_logger();
	
	my @oddFibNumbers = ('0x00000001', '0x00000001', '0x00000003', '0x00000005',
						'0x0000000d', '0x00000015', '0x00000037', '0x00000059',
						'0x000000e9', '0x00000179', '0x000003db', '0x0000063d',
						'0x00001055', '0x00001a6d', '0x0000452f', '0x00006ff1',
						'0x00012511', '0x0001da31', '0x0004d973', '0x0007d8b5',
						'0x00148add', '0x00213d05', '0x005704e7', '0x008cccc9',
						'0x01709e79', '0x02547029', '0x06197ecb', '0x09de8d6d',
						'0x19d699a5', '0x29cea5dd', '0x6d73e55f', '0xb11924e1',
						'0x90909090', '0x90909090', '0x90909090', '0x90909090',
						'0x90909090', '0x90909090', '0x90909090', '0x90909090',
						'0x90909090', '0x90909090', '0x90909090', '0x90909090',
						'0x90909090', '0x90909090', '0x90909090', '0x90909090',
						'0x90909090', '0x90909090');
						
	#get the odd fib numbers from output
	$logger->trace("\nOdd numbers check:\n");
	my $index = 0;
	my $status = verifySIGTRAP($output);
	
	while($output =~ /(0x[0-9a-f]{8})/mgi) {
		my $currentNumber = $1;
		
		if($currentNumber ne $oddFibNumbers[$index]) {
			$logger->trace(($index+1) . ': ' . $currentNumber . ' == ' . $oddFibNumbers[$index] . ' ? X');
			$status = 1;
		} else {
			$logger->trace(($index+1) . ': ' . $currentNumber . ' == ' . $oddFibNumbers[$index] . ' ? correct');
		}
		
		$index++;
	}
	return $status;
}

#*****************************************************************
# To verify if the retrieved memory contain even fibonacci numbers
#*****************************************************************
sub verifyEvenFibNumbers { 
	my $output = shift;
	$logger = get_logger();
	my @evenFibNumbers = ('0x00000002', '0x00000008', '0x00000022', '0x00000090',
						 '0x00000262', '0x00000a18', '0x00002ac2', '0x0000b520',
						 '0x0002ff42', '0x000cb228', '0x0035c7e2', '0x00e3d1b0',
						 '0x03c50ea2', '0x0ff80c38', '0x43a53f82', '0x90909090',
						 '0x90909090', '0x90909090', '0x90909090', '0x90909090',
						 '0x90909090', '0x90909090', '0x90909090', '0x90909090',
						 '0x90909090', '0x90909090', '0x90909090', '0x90909090',
						 '0x90909090', '0x90909090', '0x90909090', '0x90909090',
						 '0x90909090', '0x90909090', '0x90909090', '0x90909090', 
						 '0x90909090', '0x90909090', '0x90909090', '0x90909090', 
						 '0x90909090', '0x90909090', '0x90909090', '0x90909090',
						 '0x90909090', '0x90909090', '0x90909090', '0x90909090',
						 '0x90909090', '0x90909090');

	#get the even fib numbers from output
	my $index = 0;
	my $status = 0;
	$logger->trace("\nEven numbers check:\n");
	
	while($output =~ /(0x[0-9a-f]{8})/mgi) {
		my $currentNumber = $1;
		my $baseString = ($index+1) . ': ' . $currentNumber . ' == ' . $evenFibNumbers[$index];
		
		if($currentNumber ne $evenFibNumbers[$index]) {
			$logger->trace($baseString . ' ? X');
			$status = 1;
		} else {
			$logger->trace($baseString . ' ? correct');
		}
		
		$index++;
	}

	return $status;	
}


#*****************************************************************
# execute set of GDB commands. refer Devel::GDB documentation
#*****************************************************************
sub executeGDBcommands {
	my $filename = shift;

	# write the gdb commands file
	my $overallstatus = 0;
		
	my $gdb = new Devel::GDB();
	my $output = gdb_send_cmd('-environment-path', $gdb); 
	$output = gdb_send_cmd('info functions', $gdb);
	$output = gdb_send_cmd('set logging file answerTrace.alplog', $gdb); 
	$output = gdb_send_cmd('set logging on', $gdb); 
	$output = gdb_send_cmd('set debug remote 0', $gdb); 
	$output = gdb_send_cmd('set remotebaud 38400', $gdb); 
	$output = gdb_send_cmd('target remote /dev/ttyS0', $gdb); 
	$output = gdb_send_cmd("load $filename.out", $gdb); 
	$output = gdb_send_cmd("load $filename.out", $gdb); 
	$output = gdb_send_cmd("c", $gdb); 
	

	$output = gdb_get("x/50xw $oddAddress", $gdb);
	# verify odd fibonacci numbers
	$output =~ s/(.*\?)//i;
	$overallstatus += verifyOddFibNumbers($output);

		
	$output = gdb_get("x/50xw $evenAddress", $gdb); 
	# verify even fibonacci numbers
	$overallstatus += verifyEvenFibNumbers($output);
		
	$output = gdb_send_cmd("set logging off", $gdb); 
	
	if($overallstatus != 0) {
		$logger->trace('FAILED!');
	} else {
		$logger->trace('PASSED!');
	}
	
	$gdb->end();
	
}


#*****************************************************************
# execute a single GDB command and return the output
#*****************************************************************
sub executeCommand
{
	my $command = shift;
	$logger->trace("$command");
	my $output = `$command`;
	$logger->trace("$output");
	return $output;
}


#*****************************************************************
# compile the source code (.s) file by using nasm 
#*****************************************************************
sub executeCompiler {
	my $name = shift;
	
	#delete outfile if existing
	if(-e "$name.out"){
		unlink("$name.out");
	}
	
	$logger->trace("compiling \"$name\" ");;
	my $command = "nasm  -felf  $name.s ";
	$logger->trace($command);
	`$command`;
	$command = "ld -T prot_test.ld $name.o  /usr/lib/libc.a -o $name.out -Map $name.map";
	$logger->trace($command);
	`$command`;
	
	#check if the outfile is existing
	if(!-e "$name.out"){
		$logger->trace("$name.out not found after compilation. Something wrong with the code or compiler!");
		return 1; #strong stop
	}	
	
	return 0;
}

=head
my @userSubmissions = grep { -d } glob './*';
$logger->trace("total number of submission found = " . scalar(@userSubmissions));
my $totalDirectories = 0;
=cut

my $totalDirectories = 0;
my @userSubmissions = ('.');

# for each folder, compile the lab1.s file
foreach my $dirname (@userSubmissions) 
{
   if(-d "$dirname")
   {
	   my $currentDirectory = $dirname;
	   my @sourceFiles = grep { /.*?.s$/ } glob "$currentDirectory/*";
	   $logger->trace("current dir & .s files: $dirname , @sourceFiles\n ");
	   
	   if(scalar(@sourceFiles) == 1) {
			$totalDirectories++;
			$sourceFiles[0] =~ s/.s$//i;
			my ($name,$path,$suffix) = fileparse($sourceFiles[0]);  
			
			# compile the source file
			my $status = executeCompiler($name);
			if($status == 1) {
				$logger->trace('Refer reasons above!');
				exit(0);
			}
						
			#write gdb commands
			executeGDBcommands($name);			

	   } else  {
			$logger->trace("no/more .s file exists in current directory\n");
	   }
	   
   }
} 

$logger->trace("total directories = $totalDirectories");
