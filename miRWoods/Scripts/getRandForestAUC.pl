#!/usr/bin/perl -w
use Memory::Usage;
use miRWoods;
use Bio::DB::Sam;
use Getopt::Long;
use strict;
$| = 1;

my $USAGE = "USAGE:\n$0 -L <config file>";


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

my $productVecTrainFile = $parameters->{productVecTrainFile};
my $aucFile = $parameters->{outputPrefix} . "_prodAuc.txt";
my $trials = ($parameters->{aucTrials}) ? $parameters->{aucTrials} : 10;
miRWoods::generateRandForestAucFile($productVecTrainFile,$aucFile,$trials);
