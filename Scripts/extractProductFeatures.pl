#!/usr/bin/perl -w
use miRWoods;
use Bio::DB::Sam;
use Getopt::Long;
use strict;
$| = 1;

my $USAGE = "USAGE:\n$0 -L <config file>\n";

die $USAGE unless (@ARGV);

my $parameters = miRWoods::loadDefaultParameters();

Getopt::Long::Configure("no_ignore_case");

GetOptions ("lengthMin=i" => \$parameters->{lengthMin},
	    "totalLength=i" => \$parameters->{totalLength},
	    "hairpinShortLength=i" => \$parameters->{hairpinShortLength},
	    "distanceMin=i" => \$parameters->{distanceMin},
	    "reverseMax=i" => \$parameters->{reverseMax},
	    "countMinLocus=i" => \$parameters->{countMinLocus},
	    "fivePrimeHetMax=f" => \$parameters->{fivePrimeHetMax},
	    "shiftMin=i" => \$parameters->{shiftMin},
	    "OverlapMin=i" => \$parameters->{OverlapMin},
	    "InHairpinBuffer=i" => \$parameters->{InHairpinBuffer},
	    "OutHairpinBuffer=i" => \$parameters->{OutHairpinBuffer},
	    "RangeOfHairpin=i" => \$parameters->{RangeOfHairpin},
	    "outputPrefix=s" => \$parameters->{outputPrefix},
	    "bamListFile=s" => \$parameters->{bamListFile},
	    "FileRepeatRegions=s" => \$parameters->{FileRepeatRegions},
	    "genomeDir=s" => \$parameters->{genomeDir},
	    "SizesFile=s" => \$parameters->{SizesFile},
	    "LoadFromConfigFile=s" => \$parameters->{LoadFromConfigFile}
    );

unless ($parameters->{LoadFromConfigFile} eq "") {
    my $configFile = $parameters->{LoadFromConfigFile};
    miRWoods::readConfigFile($configFile,$parameters);
}
miRWoods::createOutputFileParameters($parameters);

my $bamListFile = $parameters->{bamListFile} or die "error: bamListFile parameter not set\n";
my $readRegionsFile = $parameters->{readRegionsFile} or die "error: readRegionsFile parameter not set\n";
my $chromSizesFile = $parameters->{SizesFile} or die "error: SizesFile parameter not set\n";
my $genomeDir = $parameters->{genomeDir} or die "error: genomeDir parameter not set\n";
die "error: $bamListFile not found\n" unless (-e $bamListFile);
die "error: $readRegionsFile not found\n" unless (-e $readRegionsFile);
die "error: $chromSizesFile not found\n" unless (-e $chromSizesFile);
my $chromLengths = miRWoods::readChromLengths($chromSizesFile) or die "failed to load $chromSizesFile.\n";
my $bamList = miRWoods::loadBamList($bamListFile) or die "failed to load $bamListFile.\n";
my $prodMLParameters = miRWoods::loadDefaultMLProductParameters();
miRWoods::printProductVectorFile($readRegionsFile,$bamList,$genomeDir,$chromLengths,$prodMLParameters,$parameters);
