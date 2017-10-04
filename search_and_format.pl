#!/usr/bin/perl

# Program:		Search and format
# Author: 		Adrian Caymo
# Description:	A simple program that searches through an unordered list, an ordered list,
#				and an unordered hash for ten randomly generated target numbers. 
#				Elapsed time for the search of each target number is recorded.
#				The results are then displayed.

#use strict;
#use warnings;
#use diagnostics;
use Benchmark;
use Time::HiRes qw(gettimeofday tv_interval);

# SEARCHING AN UNORDERED LIST

# empty hash to store unordered list
my %hash_for_unordered_list = ();

# generate random numbers from 1 to 5000000, 5 million times and read into an array
my @random_numbers = map {1 + int(rand(5000000))} (1..5000000);

# run 10 tests on search of number on unordered list
for (my $i = 0; $i <= 9; $i++) {	
	my $random_number1 = 1 + int(rand(5000000)); # randomly generate number to search for
	my $t0 = [gettimeofday]; # search time start

	# search through array for target number
	foreach (@random_numbers) {
		if ($_ == $random_number1) {
			my $elapsed_found = tv_interval($t0, [gettimeofday]) * 1000; # search time end for found number		
			$hash_for_unordered_list{$random_number1} = $elapsed_found;	# add number found to hash
			last; # break out of foreach loop
		} # end if
	} # end foreach

	# determine elapsed time if target number is not found
	if (!defined($hash_for_unordered_list{$random_number1})) {
		my $elapsed_not_found = tv_interval($t0, [gettimeofday]) * 1000; # search time end for number not found
		$hash_for_unordered_list{$random_number1} = $elapsed_not_found; # add number not found to hash
	} # end if
} # end for

# BINARY SEARCH ON AN ORDERED LIST

# empty hash to store ordered list for binary search
my %hash_for_ordered_list = ();

# generate random numbers from 1 to 5000000, 5 million times and read into an array
my @numbers_array = map {1 + int(rand(5000000))} (1..5000000);

# sort array
my @sorted_numbers_array = sort {$a <=> $b} @numbers_array;

# run 10 tests on binary search of number on sorted array
for (my $i = 0; $i <= 9; $i++) {	
	my $random_number2 = 1 + int(rand(5000000)); # randomly generate number to search for
	my $t0 = [gettimeofday]; # search time start

	# iterate through sorted numbers array
	while (defined(search(\@sorted_numbers_array, $random_number2))) {
		my $elapsed_found = tv_interval($t0, [gettimeofday]) * 1000; # search time end for number found
		$hash_for_ordered_list{$random_number2} = $elapsed_found; # add number found to hash
		last; # break out of while loop
	} # end while
	
	if (!defined($hash_for_ordered_list{$random_number2})) {
		my $elapsed_not_found = tv_interval($t0, [gettimeofday]) * 1000; # search time end for number not found
		$hash_for_ordered_list{$random_number2} = $elapsed_not_found; # add number not found to hash
	} # end if
} # end for

# SEARCHING AN UNORDERED HASH

# empty hash to store numbers found/not found in unordered hash for output
my %unordered_hash = ();

# empty hash to store 5M numbers
my %large_hash = ();

my $t0 = [gettimeofday]; # loading hash time start
for (my $i = 0; $i <= 9; $i++) {	
	$large_hash{$i} = 1 + int(rand(5000000));
} # end for
my $elapsed = tv_interval($t0, [gettimeofday]) * 1000; # loading hash time end

# run 10 tests searching for a number from a large hash
for (my $i = 0; $i <= 9; $i++) {	
	my $number = 1 + int(rand(5000000)); # randomly generate number to search for
	my $t0 = [gettimeofday]; # search time start

	# iterate through unordered large hash
	while (my($key, $value) = each %large_hash) {
		if ($value == $number) {
			my $elapsed_found = tv_interval($t0, [gettimeofday]) * 1000; # search time end for number found
			$unordered_hash{$number} = $elapsed_found; # add number found to unordered hash	
			last; # break out of foreach loop
		} # end if
	} # end while

	if (!defined($unordered_hash{$number})) {
		my $elapsed_not_found = tv_interval($t0, [gettimeofday]) * 1000; # search time end for number not found
		$unordered_hash{$number} = $elapsed_not_found; # add number not found to unordered hash
	} # end if
} # end for

# FORMATTING
my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime();
$mon += 1;
$year += 1900;
$= = 12;

my ($key, $value) = 0;
my $count = 0;
my $assignment_type = "ASSIGNMENT #2 UNORDERED";
while (($key, $value) = each %hash_for_unordered_list) {
	$count++;
	write();
} # end while

$count = 0;
$assignment_type = "ASSIGNMENT #2 ORDERED";
while (($key, $value) = each %hash_for_ordered_list) {
	$count++;
	write();
} # end while

$count = 0;
$assignment_type = "ASSIGNMENT #2 UNORDERED";
while (($key, $value) = each %unordered_hash) {
	$count++;
	write();
} # end while

format =
UNSORTED RUN #@#		SEARCH FOR @####### TOOK @###.###### ms
			 $count, 				   $key, 		 $value
.

format STDOUT_TOP =

@#-@#-@### @#:@#:@#		@>>>>>>>>>>>>>>>>>>>>>> SEARCH (PG @<OF 3)
$mon, $mday, $year, $hour, $min, $sec, $assignment_type, $%
.

# HELPER SUBS
sub search {	
	my ($numbers, $target) = @_;
	return binary_search($numbers, $target, 0, $#$numbers);
}

sub binary_search {
	my ($numbers, $target, $low, $high) = @_;
	if ($high < $low) {
		return;
	} # end if

	# divide array in two
	my $middle = int(( $low + $high) / 2);
	if ($numbers->[$middle] > $target) {
		# search the lower half
		return binary_search( $numbers, $target, $low, $middle - 1);
	} # end if
	elsif ($numbers->[$middle] < $target) {
		# search the upper half
		return binary_search($numbers, $target, $middle + 1, $high);
	} # end elsif

	return $middle;
}
