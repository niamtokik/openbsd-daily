#!/usr/bin/env perl

{ package irc;
  use strict;
  use warnings;
  use JSON;

  sub new {
    my $class = shift();
    my $args = { @_ };
    my $self = { };
    $self->{_counter} = 0;
    $self->{_meta} = {};
    $self->{_words} = {};
    $self->{_result} = [];
    $self->{_meta}->{line} = $self->{_result};
    $self->{_meta}->{words} = $self->{_words};
    bless($self, $class);
    $self->_meta($args);
    return $self;
  }

  sub _words {
    my $self = shift();
    foreach my $word (@_) {
      if ($self->{_words}->{$word}) { $self->{_words}->{$word} += 1 }
      else { $self->{_words}->{$word} = 1 }
    }
  }

  sub _meta {
    my $self = shift();
    my $args = shift();
    if ($args->{author}) { $self->_author($args->{author}); }
    if ($args->{origin}) { $self->_origin($args->{origin}); }
    if ($args->{date})   { $self->_date($args->{date}); }
    if ($args->{topic})  { $self->_topic($args->{topic}); }
    if ($args->{title})  { $self->_title($args->{title}); }
    if ($args->{source}) { $self->_source($args->{source}); }
  }

  sub _author {
    my $self = shift();
    my $args = shift();
    $self->{_meta}->{author} = $args;
  }

  sub _origin {
    my $self = shift();
    my $origin = shift();
    $self->{_meta}->{origin} = $origin;
  }

  sub _date {
    my $self = shift();
    my $date = shift();
    $self->{_meta}->{date} = $date;
  }

  sub _topic {
    my $self = shift();
    my $topic = shift();
    $self->{_meta}->{topic} = $topic;
  }

  sub _title {
    my $self = shift();
    my $title = shift();
    $self->{_meta}->{topic} = $title;
  }

  sub _source {
    my $self = shift();
    my $sources = shift();
    $self->{_meta}->{source} = $sources;
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
    $self->_result("time", $split[0]);
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
      $self->_result("pseudo", join("", @split[1..2]));
      $self->_words(@split[3..($length-1)]);
      $self->_result("text", join(" ", @split[3..($length-1)]));
      $self->_result("source", []);
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
      printf("time: %s\n", $item->{time});
      printf("author: %s\n", $item->{pseudo});
      printf("data: %s\n", $item->{text});
    }
  }

  sub to_json {
    my $self = shift();
    print encode_json $self->{_meta};
  }

  1; }

{ package main;
  use strict;
  use warnings;

  my $p = irc->new( origin => "" 
                  , date => "today"
                  , author => { "name" => "mulander" }
                  , topic => "mytopic"
                  , title => "mytitle"
                  , source => [1,2,3]
                  );
  foreach my $line (<>) {
    $p->parse($line);
  }

  1; }
