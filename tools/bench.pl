#!/usr/bin/perl

use strict;
use warnings;
use blib;
use Dumbbench;

use URI::Escape     ();
use URI::Escape::XS ();
use URI::XSEscape   ();

my $iterations = 1e4;

exit main();

sub main {
    benchmark_escaping_ascii();
    benchmark_escaping_utf8();
    benchmark_unescaping();

    return 0;
}

sub benchmark_escaping_ascii {
    my $bench = make_benchmark();
    my $orig = 'I said this: you / them ~ us & me _will_ "do-it" NOW!';

    $bench->add_instances(

        Dumbbench::Instance::PerlSub->new(
            name => 'URI::Escape',
            code => sub {
                for(1..$iterations){
                    URI::Escape::uri_escape($orig);
                }
            },
        ),

        Dumbbench::Instance::PerlSub->new(
            name => 'URI::Escape::XS',
            code => sub {
                for(1..$iterations){
                    URI::Escape::XS::uri_escape($orig);
                }
            },
        ),

        Dumbbench::Instance::PerlSub->new(
            name => 'URI::XSEscape',
            code => sub {
                for(1..$iterations){
                    URI::XSEscape::escape_ascii($orig);
                }
            },
        ),
    );

    $bench->run;
    $bench->report;
    printf("== DONE ==========\n");
}

sub benchmark_escaping_utf8 {
    my $bench = make_benchmark();
    my $orig = 'http://www.google.co.jp/search?q=小飼弾';

    $bench->add_instances(

        Dumbbench::Instance::PerlSub->new(
            name => 'URI::Escape',
            code => sub {
                for(1..$iterations){
                    URI::Escape::uri_escape_utf8($orig);
                }
            },
        ),

#        Dumbbench::Instance::PerlSub->new(
#            name => 'URI::Escape::XS',
#            code => sub {
#                for(1..$iterations){
#                    URI::Escape::XS::uri_escape_utf8($orig);
#                }
#            },
#        ),

        Dumbbench::Instance::PerlSub->new(
            name => 'URI::XSEscape',
            code => sub {
                for(1..$iterations){
                    URI::XSEscape::escape_utf8($orig);
                }
            },
        ),
    );

    $bench->run;
    $bench->report;
    printf("== DONE ==========\n");
}

sub benchmark_unescaping {
    my $bench = make_benchmark();
    my $orig = 'I%20said%20this%3a%20you%20%2f%20them%20~%20us%20%26%20me%20_will_%20%22do-it%22%20NOW%21';

    $bench->add_instances(

        Dumbbench::Instance::PerlSub->new(
            name => 'URI::Escape',
            code => sub {
                for(1..$iterations){
                    URI::Escape::uri_unescape($orig);
                }
            },
        ),

        Dumbbench::Instance::PerlSub->new(
            name => 'URI::Escape::XS',
            code => sub {
                for(1..$iterations){
                    URI::Escape::XS::uri_unescape($orig);
                }
            },
        ),

        Dumbbench::Instance::PerlSub->new(
            name => 'URI::XSEscape',
            code => sub {
                for(1..$iterations){
                    URI::XSEscape::unescape($orig);
                }
            },
        ),
    );

    $bench->run;
    $bench->report;
    printf("== DONE ==========\n");
}

sub make_benchmark {
    my $bench = Dumbbench->new(
        target_rel_precision => 0.005,
        initial_runs         => 20,
    );
    return $bench;
}
