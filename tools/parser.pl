#!/usr/bin/env perl

{ package irc;
  use strict;
  use warnings;
  use JSON;

  sub new {
    my $class = shift();
    my $self = { @_ };
    $self->{_counter} = 0;
    $self->{_result} = [];
    return bless($self, $class);
  }

  sub _result {
    my $self = shift();
    my $key = shift();
    my $value = shift();
    my $counter = $self->{_counter};
    $self->{_result}->[$counter]->{$key} = $value;
  }

  sub parse {
    my $self = shift();
    my $line = shift();
    chomp($line);
    my @split = split(/\s+/, $line);
    $self->_result("index", $self->{_counter});
    $self->_result("date", $split[0]);
    $self->router(\@split);
    $self->{_counter} += 1;
  }

  sub router {
    my $self = shift();
    my $s = shift();
    my @split = @$s;
    my $length = @split;
    printf(":: %s\n", join(" ", @split));
    if ($split[1] =~ m/-!-/) {
      1;
    }; 
    if ($split[1] =~ m/\[Users/) { 
      1;
    }
    if ($split[1] =~ m/^\[/) {
      1;
    }
    if ($split[1] =~ m/^\</) {
      $self->_result("author", join("", @split[1..2]));
      $self->_result("text", join(" ", @split[3..($length-1)]));
    }
  }

  sub DESTROY {
    my $self = shift();
    $self->to_json();
  }

  sub to_text {
    my $self = shift();
    foreach my $item (@{ $self->{_result} }) {
      printf("index: %d\n", $item->{index});
      printf("date: %s\n", $item->{date});
      printf("author: %s\n", $item->{author});
      printf("data: %s\n", $item->{text});
    }
  }

  sub to_json {
    my $self = shift();
    print encode_json $self->{_result};
  }

  1; }

{ package main;
  use strict;
  use warnings;

  my $p = irc->new();
  foreach my $line (<>) {
    $p->parse($line);
  }

  1; }
