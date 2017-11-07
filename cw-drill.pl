#!/usr/bin/perl
# This program is a trivial way to generate randomized strings reflecting
# certain character classes, word grouping and letter quantity. It is primarily
# intended to be used when learning morse-code and in conjunction with the
# CW command line utility.
# (c) 2017 Erik Sonnleitner, es<at>delta-xi.net

use List::Util qw(shuffle min);
use Getopt::Long;

GetOptions(
    "chars=s" => \$in_chars,
    "toad=i" => \$in_toad,
    "2" => \$in_usebi,
    "3" => \$in_usetri,
    "4" => \$in_usequad,
    "5" => \$in_usepent,
    "6" => \$in_usehex,
    "7" => \$in_usesept,
    "8" => \$in_useoct,
    "a" => \$in_alpha,
    "n" => \$in_numeric,
    "s" => \$in_special,
    "h" => \$in_help,
    "help" => \$in_help,
    "run" => \$in_runcw,
    "cq" => \$in_preamblecq,
    "pre" => \$in_preamble,
    "wait" => \$in_wait,
    "wpm=i" => \$in_wpm,
    "gap=i" => \$in_gap,
    "tone=i" => \$in_tone,
);


sub validate_args {
    die "Group sizes are mutually exclusive" if $in_usebi + $in_usetri +
        $in_usequad + $in_usepent + $in_usehex + $in_usesept + $in_useoct > 1;

    die "Can either specify -chars or -toad, not both." if $in_chars and $in_toad;

    die "Can either specify char classes or -chars/-toad"
      if  $in_alpha + $in_numeric + $in_special > 0 && ($in_chars or $in_toad);
}

sub help_and_quit {
    my $helptext = <<EOF;
  Usage: $0 [number of characters to give].
  Options:
   -a                    Include alphabet (a-z)
   -n                    Include numbers (0-9)
   -s                    Include special characters
   -chars=<characters>   Include only given characters
   -toad=<num>           Include first <num> characters from toad* sequence
   -2 to -8              Give in groups of 2-8
   -cq                   Always start with preamble 'cq cq cq '
   -pre                  Always start with preamble 'vvv '
   -run                  Run cw(1) utility to echo generated string
   -wait                 Wait for 2 seconds before starting cw
   -wpm                  --wpm option passed to cw (default: 20)
   -gap                  --gap option passed to cw (default: 10)
   -tone                 --tone option passed to cw (default: 700)
   -h, -help             Show this help text

  * 'MorseToad' is a free Android app to learn morse characters, with one new
  character per lession (hence 'toad sequence'). It's great to learn the
  individual characters, but limited for getting used to understanding longer
  messages. The sequence is:
               e t a r n d s l u k w o m h f j p c y g b i v x q z

  If -run is specified, the CW(1) utility is called to play audio. While
  listening, simply input every letter you understood (conclude with Enter).
  Both strings (the one sent and your copy) are then printed, together with a
  Levensthein similarity distance between them (smaller = better).

  (c) Erik Sonnleitner 2017. See https://github.com/esonn/cw-drill
      es<at>delta-xi.net | erik.sonnleitner<at>fh-hagenberg.at

EOF

    print $helptext;
    exit;
}

sub levensthein {
    my ($s, $t) = @_;
    my $tl = length($t);
    my $sl = length($s);
    my @d = ([0 .. $tl], map { [$_] } 1 .. $sl);
 
    foreach my $i (0 .. $sl - 1) {
        foreach my $j (0 .. $tl - 1) {
            $d[$i + 1][$j + 1] =
              substr($s, $i, 1) eq substr($t, $j, 1)
              ? $d[$i][$j]
              : 1 + min($d[$i][$j + 1], $d[$i + 1][$j], $d[$i][$j]);
        }
    }
 
    $d[-1][-1];
}


# --main code------------------------------------------------------------------

&validate_args();
&help_and_quit() if $in_help;

# Default settings for CW
$in_wpm = 20 if not $in_wpm;
$in_gap = 10 if not $in_gap;
$in_tone = 800 if not $in_tone;

# Set up character classes
my @toad_alphabet = qw( e t a r n d s l u k w o m h f j p c y g b i v x q z );
my @alphabet = qw( a b c d e f g h i j k l m n o p q r s t u v w x y z );
my @numbers = qw( 1 2 3 4 5 6 7 8 9 0 );
my @special = qw( . , ! ? = ) ;


# Create char pool according to options, or use all of them if not specified
my @pool = ();
if($in_chars){
    @pool = split //, $in_chars;
} elsif($in_toad) {
    push(@pool, @toad_alphabet);
    @pool = @pool[0..$in_toad];
} else {
    push(@pool,@alphabet) if $in_alpha;
    push(@pool,@numbers) if $in_numeric;
    push(@pool,@special) if $in_special;
    @pool = (@alphabet,@numbers,@special) if !@pool;
}

# set quantity of displayed characters
my $quantity = $ARGV[0];
if (not defined $quantity) { $quantity = 10; }

my @msg_arr;
for(1..$quantity) {
    @pool = shuffle @pool;
    push @msg_arr, $pool[0];
}


my ($msg_str,$cnt) = ("",0);
foreach(@msg_arr) {
    $cnt++;
    $msg_str .= $_;

    # manage grouping (single chars, bigrams, ...)
         if ($in_usebi)   { $msg_str .= " " if($cnt % 2 == 0)
    } elsif ($in_usetri)  { $msg_str .= " " if($cnt % 3 == 0)
    } elsif ($in_usequad) { $msg_str .= " " if($cnt % 4 == 0)
    } elsif ($in_usepent) { $msg_str .= " " if($cnt % 5 == 0)
    } elsif ($in_usehex)  { $msg_str .= " " if($cnt % 6 == 0)
    } elsif ($in_usesept) { $msg_str .= " " if($cnt % 7 == 0)
    } elsif ($in_useoct)  { $msg_str .= " " if($cnt % 8 == 0)
    } else { $msg_str .= " "; }
}

# Prefix with preamble if requested
$msg_str = "cq cq cq $msg_str" if $in_preamblecq;
$msg_str = "vvv $msg_str" if $in_preamble;
$msg_str =~ s/\s+$//;

# Play or print
if($in_runcw) {
    sleep 2 if $in_wait;

    # This is very dirty. Should check actual path of cw binary, should check
    # if cw is available at all, should not rely on unnamed pipes in system().
    # That's why I use Perl. Perl programmers are dirty by nature.
    system("echo $msg_str | cw --wpm=$in_wpm --tone=$in_tone --gap=$in_gap --vol=70 --noecho --nomessages");
    my $in_cw_copy = <STDIN>;
    chomp($in_cw_copy);

    my $distance = &levensthein($msg_str,$in_cw_copy);
    my $percent = (length($msg_str)-($distance)) * 100 / length($msg_str);

    print "\nCW message:  $msg_str";
    print "\nYour copy:   $in_cw_copy";
    printf("\nYour score:  %2d\% (distance %d)\n", $percent, $distance);

    if   ($percent >= 99) { print "  --Your copy was excellent! Try higher WPM.\n" }
    elsif($percent >= 90) { print "  --Good job!\n"; }
    elsif($percent >= 75) { print "  --Seems OK!\n"; }
    else                  { print "  --You can do better\n"}
} else {
    print "$msg_str\n";
}

