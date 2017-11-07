# cw-drill
cw-drill is a simple training application for learning morse code (CW). It
generates randomized but configurable text patterns and can play the
corresponding morse code on an audio device using the cw(1) command line utility
available on basically all Unix-like systems and Linux distributions. You can
input the morse sequence when it's played, and the script will then give you
both strings for comparison, as well as a rough similarity calculation.

### Command-line options
#### Character classes
    -a                    Include alphabet (a-z)
    -n                    Include numbers (0-9)
    -s                    Include special characters
    -chars=<characters>   Include only given characters
    -toad=<num>           Include first <num> characters from toad sequence


'MorseToad' is a free Android app to learn morse characters, with one new
character per lession (hence the 'toad sequence'). It's great to learn the
individual characters, but rather limited for getting used to understanding
longer messages. Also, it's not very configurable in terms of playback speed
and other parameters. I used it to learn the basic characters, and the -toad
parameter is a simple way to tell the program to e.g. just include the
first 5 characters (e.g. until lession 5) presented by MorseToad. The sequence
is:

    e t a r n d s l u k w o m h f j p c y g b i v x q z

#### Grouping/help
    -2 to -8              Give in groups of 2-8 (i.e. create words)
    -h, -help             Show help text

#### Prefixing and initial waiting
    -cq                   Always start with preamble 'cq cq cq '
    -pre                  Always start with preamble 'vvv '
    -wait                 Wait for 2 seconds before starting cw

#### Play CW on audio device
    -run                  Run cw(1) utility to echo generated string
    -wpm                  --wpm option passed to cw (words per minute, default: 20)
    -gap                  --gap option passed to cw (inter-character gap, default: 10)
    -tone                 --tone option passed to cw (frequency in Hz, default: 700)


#### Type what you here & compare to what was sent
When -run is used, the generated sequence is played back using cw(1). During
playback, you can just input character after character as you hear the
corresponding morse code. If the transmission ended, simply hit enter.

The program will then show both texts, the one originally sent and the one
copied by you so you can easily spot errors.

The given similarity metric is calculated using the Levensthein distance.
Providing feedback on how good your copy of the audio morse transmission was is
not utterly simple. A character-by-character comparison could tell you how much
% you got right, but fails even if you e.g. skip or add a character which hasn't
been in the original sequence. Levensthein provides a reasonable trade-off,
which doesn't suffer from this problem too much, but isn't too intuitive
either - you get used to it (lower numbers are better). I'm sure there are
better ways, but I tend to be lazy and prefer simple things.

Providing a longer gap with -gap is a good thing to start with. You should
practice understanding morse code in close to regular speed (say, 20-25 wpm),
but use longer gaps between characters and words to give your brain time to
process what you heard (that's the Farnsworth idea).

### Example(s)
Create 3-letter words using only the letters F, L, D and U. A total number of
30 characters are created, and the corresponding morse code is played using
beeps on your audio device:

    cw-drill -chars "fldu" -3 -run 30




