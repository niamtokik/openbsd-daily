#!/usr/bin/env perl

{ package irc;
  use strict;
  use warnings;

  sub new {
    my $class = shift();
    my $self = { @_ };
    $self->{_counter} = 0;
    $self->{_result} = [];
    return bless($self, $class);
  }

  sub parse {
    my $self = shift();
    my $line = shift();
    $self->{_counter} += 1;
    chomp($line);
    my @split = split(/\s+/, $line);
    $self->router(\@split);
  }

  sub router {
    my $self = shift();
    my $s = shift();
    my @split = @$s;
    printf(":: %s\n", join(" ", @split));
    if ($split[1] =~ m/\[Users/) { 
      printf("USERS\n");
    }
  }

  1; }

{ package main;
  use strict;
  use warnings;

  sub test {
  my $counter = 1;
  foreach my $line (<>) {
    chomp($line);
    my @split = split(/\s+/, $line);
    my $length = @split;
    my $date = $split[0];   
    my $user = join("", @split[1..2]);
    my $message = join(" ", @split[3..($length-1)]);
    printf("date: %s\n", $date);
    printf("user: %s\n", $user);
    printf("message: %s\n", $message);
    $counter += 1;
  }
  }

  my $p = irc->new();
  foreach my $line (<>) {
    $p->parse($line);
  }

  1; }
