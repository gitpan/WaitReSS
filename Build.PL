
use strict;
use warnings;

use Module::Build 0.3601;


my %module_build_args = (
  "build_requires" => {
    "File::Find" => 0,
    "File::Temp" => 0,
    "Module::Build" => "0.3601",
    "Test::More" => "0.88"
  },
  "configure_requires" => {
    "Module::Build" => "0.3601"
  },
  "dist_abstract" => "A server-side RSS aggregator",
  "dist_author" => [
    "Jerome Quelin <jquelin\@gmail.com>"
  ],
  "dist_name" => "WaitReSS",
  "dist_version" => "0.004",
  "license" => "perl",
  "module_name" => "WaitReSS",
  "recommends" => {},
  "recursive_test_files" => 1,
  "requires" => {
    "App::Cmd::Setup" => 0,
    "DateTime" => 0,
    "Digest::MD5" => 0,
    "Exporter" => 0,
    "Exporter::Lite" => 0,
    "Fcntl" => 0,
    "File::HomeDir" => 0,
    "Find::Lib" => 0,
    "LWP::Simple" => 0,
    "List::AllUtils" => 0,
    "MLDBM" => 0,
    "Moose" => 0,
    "Moose::Util::TypeConstraints" => 0,
    "MooseX::Has::Sugar" => 0,
    "MooseX::SemiAffordanceAccessor" => 0,
    "Parallel::ForkManager" => 0,
    "Path::Tiny" => 0,
    "Term::ANSIColor" => 0,
    "UNIVERSAL::require" => 0,
    "XML::Feed" => 0,
    "XML::OPML::LibXML" => 0,
    "YAML::XS" => 0,
    "parent" => 0,
    "perl" => "5.016",
    "strict" => 0,
    "warnings" => 0
  },
  "script_files" => [
    "bin/waitress"
  ]
);


my $build = Module::Build->new(%module_build_args);

$build->create_build_script;
